const express = require("express");
const router = express.Router();
const User = require("../models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

// ✅ SIGNUP
router.post("/signup", async (req, res) => {
  try {
    const { fullName, email, mobile, password, role } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "User already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      fullName,
      email,
      mobile,
      passwordHash: hashedPassword,
      role,
    });

    res.status(201).json({
      message: "Signup successful",
      userId: user._id,
      role: user.role,
    });

  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// ✅ LOGIN
const sendOtp = require("../utils/sendOtp");
const crypto = require("crypto");

router.post("/login", async (req, res) => {

  const { email, password } = req.body;

  const user = await User.findOne({ email });

  if (!user) {
    return res.status(400).json({ message: "User not found" });
  }

const isMatch = await bcrypt.compare(password, user.passwordHash);

  if (!isMatch) {
    return res.status(400).json({ message: "Invalid credentials" });
  }

  if (user.twoFactorEnabled) {
    return res.json({
      require2FA: true,
      userId: user._id,
    });
  }

  const token = jwt.sign(
    { userId: user._id, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: "7d" }
  );

  res.json({
    token,
    role: user.role,
  });
});
router.post("/login-2fa", async (req, res) => {

  const { userId, token } = req.body;

  const user = await User.findById(userId);

  const verified = speakeasy.totp.verify({
    secret: user.twoFactorSecret,
    encoding: "base32",
    token,
    window: 1,
  });

  if (!verified) {
    return res.status(400).json({ message: "Invalid code" });
  }

  const jwtToken = jwt.sign(
    { userId: user._id, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: "7d" }
  );

  res.json({
    token: jwtToken,
    role: user.role,
  });
});


router.post("/verify-otp", async (req, res) => {

  const { userId, otp } = req.body;

  const user = await User.findById(userId);

  if (!user) {
    return res.status(400).json({ message: "User not found" });
  }

  if (user.otp !== otp || user.otpExpiry < Date.now()) {
    return res.status(400).json({ message: "Invalid or expired OTP" });
  }

  // Clear OTP
  user.otp = null;
  user.otpExpiry = null;
  await user.save();

  const token = jwt.sign(
    { userId: user._id, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: "7d" }
  );

  res.json({
    token,
    role: user.role,
  });
});
router.post("/resend-otp", async (req, res) => {

  const { userId } = req.body;

  const user = await User.findById(userId);

  if (!user) {
    return res.status(400).json({ message: "User not found" });
  }

  const otp = Math.floor(100000 + Math.random() * 900000).toString();

  user.otp = otp;
  user.otpExpiry = Date.now() + 5 * 60 * 1000;

  await user.save();

  await sendOtp(user.email, otp);

  res.json({ message: "OTP resent successfully" });
});
const speakeasy = require("speakeasy");
const QRCode = require("qrcode");

router.post("/enable-2fa", async (req, res) => {

  const { userId } = req.body;

  const user = await User.findById(userId);

  if (!user) {
    return res.status(400).json({ message: "User not found" });
  }

  const secret = speakeasy.generateSecret({
    length: 20,
    name: "SmartDocVault",
  });

  user.twoFactorSecret = secret.base32;
  await user.save();

  const qrCode = await QRCode.toDataURL(secret.otpauth_url);

  res.json({
    qrCode,
    secret: secret.base32,
  });
});
router.post("/verify-2fa", async (req, res) => {

  const { userId, token } = req.body;

  const user = await User.findById(userId);

  if (!user || !user.twoFactorSecret) {
    return res.status(400).json({ message: "2FA not setup" });
  }

  const verified = speakeasy.totp.verify({
    secret: user.twoFactorSecret,
    encoding: "base32",
    token,
    window: 1,
  });

  if (!verified) {
    return res.status(400).json({ message: "Invalid code" });
  }

  user.twoFactorEnabled = true;
  await user.save();

  res.json({ message: "2FA enabled successfully" });
});
module.exports = router;
