const express = require("express")
const bcrypt = require("bcryptjs")
const jwt = require("jsonwebtoken")
const { pool } = require("../config/database")
const { validateRequest, schemas } = require("../middleware/validation")
const { authenticateToken } = require("../middleware/auth")

const router = express.Router()

console.log("✅ auth routes loaded") // Debug log to confirm file is loaded

// ======================== REGISTER ========================
router.post("/register", async (req, res) => {
    console.log("📥 Register body:", req.body) // Debug incoming request

    try {
        const { name, email, phone, campusId, userType, password } = req.body

        if (!name || !email || !password) {
            return res.status(400).json({
                success: false,
                message: "Name, email, and password are required",
            })
        }

        // Check if user already exists
        const [existingUsers] = await pool.execute("SELECT id FROM users WHERE email = ?", [email])

        if (existingUsers.length > 0) {
            return res.status(400).json({
                success: false,
                message: "User with this email already exists",
            })
        }

        // Hash password
        const saltRounds = 10
        const passwordHash = await bcrypt.hash(password, saltRounds)

        // Insert new user
        const [result] = await pool.execute(
            `INSERT INTO users (name, email, phone, campus_id, user_type, password_hash) 
       VALUES (?, ?, ?, ?, ?, ?)`,
            [name, email, phone, campusId, userType, passwordHash]
        )

        // Generate JWT token
        const token = jwt.sign(
            { userId: result.insertId, email, userType },
            process.env.JWT_SECRET,
            { expiresIn: process.env.JWT_EXPIRES_IN }
        )

        res.status(201).json({
            success: true,
            message: "User registered successfully",
            data: {
                token,
                user: {
                    id: result.insertId,
                    name,
                    email,
                    phone,
                    campusId,
                    userType,
                    walletBalance: 0.0,
                },
            },
        })
    } catch (error) {
        console.error("❌ Registration error:", error)
        res.status(500).json({
            success: false,
            message: "Internal server error",
        })
    }
})

// ======================== LOGIN ========================
router.post("/login", async (req, res) => {
    console.log("📥 Login body:", req.body)

    try {
        const { email, password } = req.body

        // Find user by email
        const [users] = await pool.execute("SELECT * FROM users WHERE email = ?", [email])

        if (users.length === 0) {
            return res.status(401).json({
                success: false,
                message: "Invalid email or password",
            })
        }

        const user = users[0]

        // Verify password
        const isPasswordValid = await bcrypt.compare(password, user.password_hash)
        if (!isPasswordValid) {
            return res.status(401).json({
                success: false,
                message: "Invalid email or password",
            })
        }

        // Generate JWT token
        const token = jwt.sign(
            { userId: user.id, email: user.email, userType: user.user_type },
            process.env.JWT_SECRET,
            { expiresIn: process.env.JWT_EXPIRES_IN }
        )

        res.json({
            success: true,
            message: "Login successful",
            data: {
                token,
                user: {
                    id: user.id,
                    name: user.name,
                    email: user.email,
                    phone: user.phone,
                    campusId: user.campus_id,
                    userType: user.user_type,
                    walletBalance: Number.parseFloat(user.wallet_balance),
                    profileImage: user.profile_image,
                },
            },
        })
    } catch (error) {
        console.error("❌ Login error:", error)
        res.status(500).json({
            success: false,
            message: "Internal server error",
        })
    }
})

// ======================== PROFILE ========================
router.get("/profile", authenticateToken, async (req, res) => {
    console.log("👤 Profile request for user:", req.user)

    try {
        const [users] = await pool.execute(
            "SELECT id, name, email, phone, campus_id, user_type, wallet_balance, profile_image FROM users WHERE id = ?",
            [req.user.id]
        )

        if (users.length === 0) {
            return res.status(404).json({
                success: false,
                message: "User not found",
            })
        }

        const user = users[0]
        res.json({
            success: true,
            data: {
                id: user.id,
                name: user.name,
                email: user.email,
                phone: user.phone,
                campusId: user.campus_id,
                userType: user.user_type,
                walletBalance: Number.parseFloat(user.wallet_balance),
                profileImage: user.profile_image,
            },
        })
    } catch (error) {
        console.error("❌ Profile fetch error:", error)
        res.status(500).json({
            success: false,
            message: "Internal server error",
        })
    }
})

module.exports = router
