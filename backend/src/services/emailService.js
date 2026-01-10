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
  
  // Plain text version for email clients that don't support HTML
  const textContent = `
QNow Password Reset

Hello,

We received a request to reset your password for your QNow account.

To reset your password, please click on the following link or copy and paste it into your browser:

${resetLink}

This link will expire in 1 hour for security reasons.

If you didn't request a password reset, you can safely ignore this email. Your password will remain unchanged.

For security reasons, please do not share this link with anyone.

Best regards,
The QNow Team

---
This is an automated email, please do not reply to this message.
© ${new Date().getFullYear()} QNow. All rights reserved.
  `.trim();
  
  const htmlContent = `
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <title>Reset Your QNow Password</title>
      <style>
        body { 
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; 
          line-height: 1.6; 
          color: #333333; 
          margin: 0;
          padding: 0;
          background-color: #f4f4f4;
        }
        .email-wrapper {
          max-width: 600px;
          margin: 0 auto;
          background-color: #ffffff;
        }
        .header { 
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: #ffffff; 
          padding: 30px 20px; 
          text-align: center;
        }
        .header h1 {
          margin: 0;
          font-size: 24px;
          font-weight: 600;
        }
        .content { 
          padding: 40px 30px;
          background-color: #ffffff;
        }
        .content h2 {
          color: #333333;
          font-size: 20px;
          margin-top: 0;
          margin-bottom: 20px;
        }
        .content p {
          margin: 0 0 16px 0;
          color: #555555;
        }
        .button-container {
          text-align: center;
          margin: 30px 0;
        }
        .button { 
          display: inline-block; 
          padding: 14px 30px; 
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: #ffffff !important; 
          text-decoration: none; 
          border-radius: 6px; 
          font-weight: 600;
          font-size: 16px;
        }
        .link-text {
          margin: 20px 0;
          padding: 15px;
          background-color: #f8f9fa;
          border-radius: 4px;
          word-break: break-all;
        }
        .link-text a {
          color: #667eea;
          text-decoration: none;
        }
        .footer { 
          text-align: center; 
          padding: 20px 30px; 
          font-size: 13px; 
          color: #888888;
          background-color: #f8f9fa;
          border-top: 1px solid #e0e0e0;
        }
        .footer p {
          margin: 8px 0;
        }
        .security-note {
          margin-top: 20px;
          padding: 15px;
          background-color: #fff3cd;
          border-left: 4px solid #ffc107;
          font-size: 14px;
          color: #856404;
        }
        @media only screen and (max-width: 600px) {
          .content {
            padding: 20px 15px;
          }
          .header {
            padding: 20px 15px;
          }
        }
      </style>
    </head>
    <body>
      <div class="email-wrapper">
        <div class="header">
          <h1>🕐 QNow Password Reset</h1>
        </div>
        <div class="content">
          <h2>Reset Your Password</h2>
          <p>Hello,</p>
          <p>We received a request to reset your password for your QNow account. To create a new password, please click the button below:</p>
          
          <div class="button-container">
            <a href="${resetLink}" class="button">Reset My Password</a>
          </div>
          
          <p>Or copy and paste this link into your browser:</p>
          <div class="link-text">
            <a href="${resetLink}">${resetLink}</a>
          </div>
          
          <div class="security-note">
            <strong>⚠️ Security Notice:</strong> This link will expire in 1 hour for your security.
          </div>
          
          <p style="margin-top: 20px;">If you didn't request a password reset, you can safely ignore this email. Your password will remain unchanged.</p>
          
          <p style="margin-top: 20px;">For security reasons, please do not share this link with anyone.</p>
        </div>
        <div class="footer">
          <p><strong>The QNow Team</strong></p>
          <p>This is an automated email, please do not reply to this message.</p>
          <p>© ${new Date().getFullYear()} QNow. All rights reserved.</p>
        </div>
      </div>
    </body>
    </html>
  `;
  
  try {
    if (useSendGrid) {
      // Use SendGrid HTTP API with improved headers and settings
      const msg = {
        to: email,
        from: {
          email: process.env.EMAIL_USER,
          name: 'QNow Support'
        },
        replyTo: {
          email: process.env.EMAIL_USER,
          name: 'QNow Support'
        },
        subject: 'Reset Your QNow Password',
        text: textContent,
        html: htmlContent,
        // Additional headers to improve deliverability
        headers: {
          'X-Priority': '1',
          'X-MSMail-Priority': 'High',
          'Importance': 'high'
        },
        // Categories for tracking
        categories: ['password-reset'],
        // Custom args for analytics
        customArgs: {
          'email_type': 'password_reset'
        }
      };
      await sgMail.send(msg);
      console.log(`Password reset email sent to ${email} via SendGrid`);
    } else {
      // Use Gmail SMTP (local development only)
      await transporter.sendMail({
        from: `"QNow Support" <${process.env.EMAIL_USER}>`,
        to: email,
        subject: 'Reset Your QNow Password',
        text: textContent,
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
