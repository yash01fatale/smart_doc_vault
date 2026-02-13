const mongoose = require("mongoose");

const NotificationSchema = new mongoose.Schema({

  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },

  documentId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Document",
  },

  message: String,

  isRead: {
    type: Boolean,
    default: false,
  },

}, { timestamps: true });

module.exports = mongoose.model("Notification", NotificationSchema);
