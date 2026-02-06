const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema({
  fullName: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  mobile: { type: String, required: true },
  passwordHash: { type: String, required: true },
  role: {
    type: String,
    enum: ["personal", "business"],
    required: true,
  },
  businessInfo: {
    businessName: String,
    businessType: String,
    gstNumber: String,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("User", UserSchema);
