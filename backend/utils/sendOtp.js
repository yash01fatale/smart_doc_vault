const nodemailer = require("nodemailer");

const sendOtp = async (email, otp) => {

  const transporter = nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });

  await transporter.sendMail({
    from: process.env.EMAIL_USER,
    to: email,
    subject: "Smart Document Vault - Login OTP",
    html: `
      <h2>Your Login OTP</h2>
      <p>Your OTP is: <b>${otp}</b></p>
      <p>This OTP expires in 5 minutes.</p>
    `,
  });
};

module.exports = sendOtp;
