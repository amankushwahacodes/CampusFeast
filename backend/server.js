  const express = require("express")
  const cors = require("cors")
  const helmet = require("helmet")
  const rateLimit = require("express-rate-limit")
  require("dotenv").config()

  const { testConnection } = require("./config/database")

  // Import routes
  const authRoutes = require("./routes/auth.js")
  const vendorRoutes = require("./routes/vendors")
  const orderRoutes = require("./routes/orders")
  const walletRoutes = require("./routes/wallet")

  const app = express()
  const PORT = process.env.PORT || 3000

  // Security middleware
  app.use(helmet())

  // CORS configuration
  app.use(cors())

  // Rate limiting
  const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // limit each IP to 100 requests per windowMs
    message: {
      success: false,
      message: "Too many requests from this IP, please try again later.",
    },
  })
  app.use(limiter)

  // Body parsing middleware
  app.use(express.json({ limit: "10mb" }))


  // Health check endpoint
  app.get("/health", (req, res) => {
    res.json({
      success: true,
      message: "Campus Feast API is running",
      timestamp: new Date().toISOString(),
      version: "1.0.0",
    })
  })

  // API routes
  app.use("/api/auth", authRoutes)
  app.use("/api/vendors", vendorRoutes)
  app.use("/api/orders", orderRoutes)
  app.use("/api/wallet", walletRoutes)

  // 404 handler
  app.use("*", (req, res) => {
    res.status(404).json({
      success: false,
      message: "API endpoint not found",
    })
  })

  // Global error handler
  app.use((error, req, res, next) => {
    console.error("Global error handler:", error)

    res.status(error.status || 500).json({
      success: false,
      message: process.env.NODE_ENV === "production" ? "Internal server error" : error.message,
      ...(process.env.NODE_ENV !== "production" && { stack: error.stack }),
    })
  })

  // Start server
  const startServer = async () => {
    try {
      // Test database connection
      await testConnection()

      app.listen(PORT, () => {
        console.log(`🚀 Campus Feast API server running on port ${PORT}`)
        console.log(`📱 Health check: http://localhost:${PORT}/health`)
        console.log(`🔧 Environment: ${process.env.NODE_ENV || "development"}`)
      })
    } catch (error) {
      console.error("Failed to start server:", error)
      process.exit(1)
    }
  }

  startServer()

  module.exports = app
