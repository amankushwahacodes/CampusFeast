const express = require("express")
const { pool } = require("../config/database")
const { authenticateToken } = require("../middleware/auth")

const router = express.Router()

// Get all vendors
router.get("/", async (req, res) => {
  try {
    console.log("Fetching vendors...");
    const [vendors] = await pool.execute(`
      SELECT v.*, u.name as owner_name 
      FROM vendors v 
      JOIN users u ON v.user_id = u.id 
      ORDER BY v.rating DESC, v.name ASC
    `)

    const formattedVendors = vendors.map((vendor) => {
      let specialties = []
      try {
        specialties = vendor.specialties ? JSON.parse(vendor.specialties) : []
      } catch (e) {
        console.warn(`⚠️ Invalid JSON in specialties for vendor ${vendor.id}:`, vendor.specialties)
      }

      return {
        id: vendor.id,
        name: vendor.name,
        description: vendor.description,
        image: vendor.image,
        location: vendor.location,
        isOpen: vendor.is_open === 1, // convert to true/false
        rating: Number.parseFloat(vendor.rating),
        reviewCount: vendor.review_count,
        openingHours: vendor.opening_hours,
        type: vendor.vendor_type,
        specialties,
        ownerName: vendor.owner_name,
      }
    })

    res.json({
      success: true,
      data: formattedVendors,
    })
  } catch (error) {
    console.error("Vendors fetch error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})


// Get vendor by ID
router.get("/:id", async (req, res) => {
  try {
    const [vendors] = await pool.execute(
      `
      SELECT v.*, u.name as owner_name 
      FROM vendors v 
      JOIN users u ON v.user_id = u.id 
      WHERE v.id = ?
    `,
      [req.params.id],
    )

    if (vendors.length === 0) {
      return res.status(404).json({
        success: false,
        message: "Vendor not found",
      })
    }

    const vendor = vendors[0]
    res.json({
      success: true,
      data: {
        id: vendor.id,
        name: vendor.name,
        description: vendor.description,
        image: vendor.image,
        location: vendor.location,
        isOpen: vendor.is_open,
        rating: Number.parseFloat(vendor.rating),
        reviewCount: vendor.review_count,
        openingHours: vendor.opening_hours,
        type: vendor.vendor_type,
        specialties: JSON.parse(vendor.specialties || "[]"),
        ownerName: vendor.owner_name,
      },
    })
  } catch (error) {
    console.error("Vendor fetch error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

// Get vendor menu items
router.get("/:id/menu", async (req, res) => {
  try {
    const [menuItems] = await pool.execute(
      `
      SELECT * FROM menu_items 
      WHERE vendor_id = ? 
      ORDER BY category, name
    `,
      [req.params.id],
    )

    const formattedItems = menuItems.map((item) => ({
      id: item.id,
      vendorId: item.vendor_id,
      name: item.name,
      description: item.description,
      image: item.image,
      price: Number.parseFloat(item.price),
      walletDiscount: item.wallet_discount ? Number.parseFloat(item.wallet_discount) : null,
      isAvailable: item.is_available,
      isVegetarian: item.is_vegetarian,
      category: item.category,
      preparationTime: item.preparation_time,
    }))

    res.json({
      success: true,
      data: formattedItems,
    })
  } catch (error) {
    console.error("Menu fetch error:", error)
    res.status(500).json({
      success: false,
      message: "Internal server error",
    })
  }
})

module.exports = router
