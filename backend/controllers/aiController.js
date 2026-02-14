const axios = require("axios");

exports.handleAIQuery = async (req, res) => {
  try {
    const { question } = req.body;

    // Send question to Python service
    const pythonResponse = await axios.post(
      "http://localhost:8001/process-ai",
      { question }
    );

    res.status(200).json({
      success: true,
      answer: pythonResponse.data.answer,
    });

  } catch (error) {
    res.status(500).json({ message: "AI Service Error" });
  }
};
