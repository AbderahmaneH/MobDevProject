const sgMail = require('@sendgrid/mail');
const nodemailer = require('nodemailer');

// Determine which email service to use
const useSendGrid = !!process.env.SENDGRID_API_KEY;
console.log(`Email service initialized: Using ${useSendGrid ? 'SendGrid HTTP API' : 'Gmail SMTP'}`);

// Initialize SendGrid if API key exists
if (useSendGrid) {
  sgMail.setApiKey(process.env.SENDGRID_API_KEY);
}

// Fallback to Gmail SMTP for local development
const transporter = !useSendGrid ? nodemailer.createTransport({
  host: 'smtp.gmail.com',
  port: 465,
  secure: true,
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  }
}) : null;

/**
 * Send password reset email
 */
async function sendPasswordResetEmail(email, resetToken) {
  // Remove trailing slash from APP_URL if present
  const baseUrl = process.env.APP_URL?.replace(/\/$/, '') || 'http://localhost:3000';
  const resetLink = `${baseUrl}/reset-password?token=${resetToken}`;
  
  const htmlContent = `
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: #4CAF50; color: white; padding: 20px; text-align: center; }
        .content { padding: 20px; background: #f9f9f9; }
        .button { display: inline-block; padding: 12px 24px; background: #4CAF50; color: white; text-decoration: none; border-radius: 4px; margin: 20px 0; }
        .footer { text-align: center; padding: 20px; font-size: 12px; color: #666; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>QNow Password Reset</h1>
        </div>
        <div class="content">
          <h2>Reset Your Password</h2>
          <p>We received a request to reset your password. Click the button below to create a new password:</p>
          <a href="${resetLink}" class="button">Reset Password</a>
          <p>Or copy and paste this link into your browser:</p>
          <p style="word-break: break-all; color: #4CAF50;">${resetLink}</p>
          <p><strong>This link will expire in 1 hour.</strong></p>
          <p>If you didn't request a password reset, you can safely ignore this email.</p>
        </div>
        <div class="footer">
          <p>© ${new Date().getFullYear()} QNow. All rights reserved.</p>
          <p>This is an automated email, please do not reply.</p>
        </div>
      </div>
    </body>
    </html>
  `;
  
  try {
    if (useSendGrid) {
      // Use SendGrid HTTP API (works on Render)
      const msg = {
        to: email,
        from: process.env.EMAIL_USER,
        subject: 'Reset Your QNow Password',
        html: htmlContent,
      };
      await sgMail.send(msg);
      console.log(`Password reset email sent to ${email} via SendGrid`);
    } else {
      // Use Gmail SMTP (local development only)
      await transporter.sendMail({
        from: `"QNow Support" <${process.env.EMAIL_USER}>`,
        to: email,
        subject: 'Reset Your QNow Password',
        html: htmlContent
      });
      console.log(`Password reset email sent to ${email} via Gmail`);
    }
    return { success: true };
  } catch (error) {
    console.error('Error sending email:', error);
    return { success: false, error: error.message };
  }
}

module.exports = {
  sendPasswordResetEmail
};
