const Joi = require("joi")

const validateRequest = (schema) => {
  return (req, res, next) => {
    const { error } = schema.validate(req.body)
    if (error) {
      return res.status(400).json({
        success: false,
        message: "Validation error",
        details: error.details.map((detail) => detail.message),
      })
    }
    next()
  }
}

// Validation schemas
const schemas = {
  register: Joi.object({
    name: Joi.string().min(2).max(100).required(),
    email: Joi.string().email().required(),
    phone: Joi.string()
      .pattern(/^[0-9]{10}$/)
      .required(),
    campusId: Joi.string().min(5).max(50).required(),
    userType: Joi.string().valid("student", "staff", "vendor").default("student"),
    password: Joi.string().min(6).required(),
  }),

  login: Joi.object({
    email: Joi.string().email().required(),
    password: Joi.string().required(),
  }),

  createOrder: Joi.object({
    vendorId: Joi.string().required(),
    items: Joi.array()
      .items(
        Joi.object({
          menuItemId: Joi.string().required(),
          quantity: Joi.number().integer().min(1).required(),
        }),
      )
      .min(1)
      .required(),
    paymentMethod: Joi.string().valid("wallet", "upi", "cash").default("wallet"),
  }),

  updateOrderStatus: Joi.object({
    status: Joi.string().valid("accepted", "preparing", "ready", "completed", "rejected", "cancelled").required(),
  }),
}

module.exports = { validateRequest, schemas }
