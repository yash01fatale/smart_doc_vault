const express = require("express");
const router = express.Router();
const { handleAIQuery } = require("../controllers/aiController");

router.post("/ask", handleAIQuery);

module.exports = router;
