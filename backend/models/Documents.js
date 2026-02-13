const mongoose = require("mongoose");

const DocumentSchema = new mongoose.Schema({

  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
    index: true,
  },

  role: {
    type: String,
    enum: ["personal", "business"],
    required: true,
  },

  documentName: {
    type: String,
    required: true,
  },

  category: {
    type: String,
    required: true,
  },

  documentNumber: String,

  issueDate: Date,

  expiryDate: {
    type: Date,
    required: true,
  },

  notes: String,

  fileUrl: String,

  status: {
    type: String,
    enum: ["active", "expiring", "expired"],
    default: "active",
  },

}, { timestamps: true });

module.exports = mongoose.model("Document", DocumentSchema);
