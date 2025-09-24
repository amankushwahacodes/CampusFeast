const jwt = require("jsonwebtoken")
const { pool } = require("../config/database")

const authenticateToken = async (req, res, next) => {
  const authHeader = req.headers["authorization"]
  const token = authHeader && authHeader.split(" ")[1]

  if (!token) {
    return res.status(401).json({
      success: false,
      message: "Access token required",
    })
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET)

    // Verify user still exists
    const [users] = await pool.execute("SELECT id, email, user_type FROM users WHERE id = ?", [decoded.userId])

    if (users.length === 0) {
      return res.status(401).json({
        success: false,
        message: "Invalid token - user not found",
      })
    }

    req.user = users[0]
    next()
  } catch (error) {
    return res.status(403).json({
      success: false,
      message: "Invalid or expired token",
    })
  }
}

const authorizeRoles = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.user_type)) {
      return res.status(403).json({
        success: false,
        message: "Access denied - insufficient permissions",
      })
    }
    next()
  }
}

module.exports = { authenticateToken, authorizeRoles }
