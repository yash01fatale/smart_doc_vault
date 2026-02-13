const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema({

  fullName: {
    type: String,
    required: true,
  },

  email: {
    type: String,
    required: true,
    unique: true,
    index: true,
  },

  mobile: {
    type: String,
  },

  passwordHash: {
    type: String,
    required: true,
  },

  role: {
    type: String,
    enum: ["personal", "business"],
    required: true,
  },

  // Email OTP
  otp: String,
  otpExpiry: Date,

  // Google Authenticator
  twoFactorSecret: String,
  twoFactorEnabled: {
    type: Boolean,
    default: false,
  },

  // Account info
  isActive: {
    type: Boolean,
    default: true,
  },

  createdAt: {
    type: Date,
    default: Date.now,
  },

}, { timestamps: true });

module.exports = mongoose.model("User", UserSchema);
