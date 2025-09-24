const express = require("express")
const { pool } = require("../config/database")
const { authenticateToken } = require("../middleware/auth")

const router = express.Router()

// Get wallet balance
router.get("/balance", authenticateToken, async (req, res) => {
  try {
    const [users] = await pool.execute("SELECT wallet_balance FROM users WHERE id = ?", [req.user.id])

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      })
    }

    res.json({
      success: true,
      data: {
        balance: Number.parseFloat(users[0].wallet_balance),
      },
    })
  } catch (error) {
    console.error("Wallet balance fetch error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

// Get transaction history
router.get("/transactions", authenticateToken, async (req, res) => {
  try {
    const [transactions] = await pool.execute(
      `
      SELECT t.*, o.id as order_number
      FROM transactions t
      LEFT JOIN orders o ON t.order_id = o.id
      WHERE t.user_id = ?
      ORDER BY t.created_at DESC
      LIMIT 50
    `,
      [req.user.id],
    )

    const formattedTransactions = transactions.map((transaction) => ({
      id: transaction.id,
      type: transaction.transaction_type,
      amount: Number.parseFloat(transaction.amount),
      description: transaction.description,
      paymentMethod: transaction.payment_method,
      status: transaction.status,
      orderNumber: transaction.order_number,
      createdAt: transaction.created_at,
    }))

    res.json({
      success: true,
      data: formattedTransactions,
    })
  } catch (error) {
    console.error("Transactions fetch error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

// Add money to wallet (for testing - in production this would integrate with payment gateway)
router.post("/add-money", authenticateToken, async (req, res) => {
  try {
    const { amount } = req.body

    if (!amount || amount <= 0) {
      return res.status(400).json({
        success: false,
        message: "Invalid amount",
      })
    }

    const connection = await pool.getConnection()

    try {
      await connection.beginTransaction()

      // Update wallet balance
      await connection.execute("UPDATE users SET wallet_balance = wallet_balance + ? WHERE id = ?", [
        amount,
        req.user.id,
      ])

      // Create transaction record
      await connection.execute(
        `
        INSERT INTO transactions (user_id, transaction_type, amount, description, payment_method) 
        VALUES (?, 'credit', ?, 'Wallet top-up', 'upi')
      `,
        [req.user.id, amount],
      )

      await connection.commit()

      // Get updated balance
      const [users] = await pool.execute("SELECT wallet_balance FROM users WHERE id = ?", [req.user.id])

      res.json({
        success: true,
        message: "Money added successfully",
        data: {
          newBalance: Number.parseFloat(users[0].wallet_balance),
        },
      })
    } catch (error) {
      await connection.rollback()
      throw error
    } finally {
      connection.release()
    }
  } catch (error) {
    console.error("Add money error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

module.exports = router
