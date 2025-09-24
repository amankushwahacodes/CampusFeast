const express = require("express")
const { pool } = require("../config/database")
const { authenticateToken, authorizeRoles } = require("../middleware/auth")
const { validateRequest, schemas } = require("../middleware/validation")

const router = express.Router()

// Create new order
router.post("/", authenticateToken, validateRequest(schemas.createOrder), async (req, res) => {
  const connection = await pool.getConnection()

  try {
    await connection.beginTransaction()

    const { vendorId, items, paymentMethod } = req.body
    const userId = req.user.id

    // Calculate order totals
    let subtotal = 0
    let totalDiscount = 0
    const orderItems = []

    for (const item of items) {
      const [menuItems] = await connection.execute(
        "SELECT * FROM menu_items WHERE id = ? AND vendor_id = ? AND is_available = TRUE",
        [item.menuItemId, vendorId],
      )

      if (menuItems.length === 0) {
        throw new Error(`Menu item ${item.menuItemId} not found or unavailable`)
      }

      const menuItem = menuItems[0]
      const itemPrice = Number.parseFloat(menuItem.price)
      const itemDiscount = menuItem.wallet_discount ? Number.parseFloat(menuItem.wallet_discount) : 0

      subtotal += itemPrice * item.quantity
      totalDiscount += itemDiscount * item.quantity

      orderItems.push({
        menuItemId: menuItem.id,
        name: menuItem.name,
        price: itemPrice,
        discount: itemDiscount,
        quantity: item.quantity,
      })
    }

    const total = subtotal - totalDiscount

    // Check wallet balance if payment method is wallet
    if (paymentMethod === "wallet") {
      const [users] = await connection.execute("SELECT wallet_balance FROM users WHERE id = ?", [userId])

      if (users.length === 0 || Number.parseFloat(users[0].wallet_balance) < total) {
        throw new Error("Insufficient wallet balance")
      }
    }

    // Create order
    const [orderResult] = await connection.execute(
      `
      INSERT INTO orders (user_id, vendor_id, subtotal, discount, total, payment_method) 
      VALUES (?, ?, ?, ?, ?, ?)
    `,
      [userId, vendorId, subtotal, totalDiscount, total, paymentMethod],
    )

    const orderId = orderResult.insertId

    // Insert order items
    for (const item of orderItems) {
      await connection.execute(
        `
        INSERT INTO order_items (order_id, menu_item_id, name, price, discount, quantity) 
        VALUES (?, ?, ?, ?, ?, ?)
      `,
        [orderId, item.menuItemId, item.name, item.price, item.discount, item.quantity],
      )
    }

    // Deduct from wallet if payment method is wallet
    if (paymentMethod === "wallet") {
      await connection.execute("UPDATE users SET wallet_balance = wallet_balance - ? WHERE id = ?", [total, userId])

      // Create transaction record
      await connection.execute(
        `
        INSERT INTO transactions (user_id, order_id, transaction_type, amount, description, payment_method) 
        VALUES (?, ?, 'debit', ?, 'Order payment', 'wallet')
      `,
        [userId, orderId, total],
      )
    }

    await connection.commit()

    res.status(201).json({
      success: true,
      message: "Order created successfully",
      data: {
        orderId,
        total,
        status: "placed",
      },
    })
  } catch (error) {
    await connection.rollback()
    console.error("Order creation error:", error)
    res.status(400).json({
      success: false,
      message: error.message || "Failed to create order",
    })
  } finally {
    connection.release()
  }
})

// Get user orders
router.get("/my-orders", authenticateToken, async (req, res) => {
  try {
    const [orders] = await pool.execute(
      `
      SELECT o.*, v.name as vendor_name, v.image as vendor_image
      FROM orders o
      JOIN vendors v ON o.vendor_id = v.id
      WHERE o.user_id = ?
      ORDER BY o.order_time DESC
    `,
      [req.user.id],
    )

    const formattedOrders = []

    for (const order of orders) {
      // Get order items
      const [items] = await pool.execute(
        `
        SELECT * FROM order_items WHERE order_id = ?
      `,
        [order.id],
      )

      formattedOrders.push({
        id: order.id,
        userId: order.user_id,
        vendorId: order.vendor_id,
        vendorName: order.vendor_name,
        vendorImage: order.vendor_image,
        items: items.map((item) => ({
          menuItemId: item.menu_item_id,
          name: item.name,
          price: Number.parseFloat(item.price),
          discount: item.discount ? Number.parseFloat(item.discount) : null,
          quantity: item.quantity,
        })),
        subtotal: Number.parseFloat(order.subtotal),
        discount: Number.parseFloat(order.discount),
        total: Number.parseFloat(order.total),
        status: order.status,
        orderTime: order.order_time,
        pickupTime: order.pickup_time,
        paymentMethod: order.payment_method,
      })
    }

    res.json({
      success: true,
      data: formattedOrders,
    })
  } catch (error) {
    console.error("Orders fetch error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

// Update order status (vendor only)
router.patch(
  "/:id/status",
  authenticateToken,
  authorizeRoles("vendor", "admin"),
  validateRequest(schemas.updateOrderStatus),
  async (req, res) => {
    try {
      const { status } = req.body
      const orderId = req.params.id

      // If user is vendor, check if they own the order
      if (req.user.user_type === "vendor") {
        const [orders] = await pool.execute(
          `
        SELECT o.* FROM orders o
        JOIN vendors v ON o.vendor_id = v.id
        WHERE o.id = ? AND v.user_id = ?
      `,
          [orderId, req.user.id],
        )

        if (orders.length === 0) {
          return res.status(403).json({
            success: false,
            message: "Access denied - not your order",
          })
        }
      }

      await pool.execute("UPDATE orders SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?", [status, orderId])

      res.json({
        success: true,
        message: "Order status updated successfully",
      })
    } catch (error) {
      console.error("Order status update error:", error)
      res.status(500).json({
        success: false,
        message: "Internal server error",
      })
    }
  },
)

module.exports = router
