const express = require('express');
const router = express.Router();
const { register, login, getProfile, requestPasswordReset, resetPassword } = require('../models/auth');
const { verifyToken } = require('../middleware/auth');

/**
 * POST /api/auth/register - Register a new user
 */
router.post('/register', async (req, res) => {
  try {
    const { name, email, phone, password, isBusiness, businessName, businessType, businessAddress } = req.body;
    
    // Validate required fields
    if (!name || !email || !phone || !password) {
      return res.status(400).json({
        success: false,
        message: 'Name, email, phone, and password are required'
      });
    }
    
    const result = await register(req.body);
    
    if (result.success) {
      res.status(201).json({
        success: true,
        message: 'User registered successfully',
        data: result.data
      });
    } else {
      res.status(400).json({
        success: false,
        message: 'Registration failed',
        error: result.error
      });
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
});

/**
 * POST /api/auth/login - Login user
 */
router.post('/login', async (req, res) => {
  try {
    const { phone, password } = req.body;
    
    // Validate required fields
    if (!phone || !password) {
      return res.status(400).json({
        success: false,
        message: 'Phone and password are required'
      });
    }
    
    const result = await login(phone, password);
    
    if (result.success) {
      res.status(200).json({
        success: true,
        message: 'Login successful',
        data: result.data
      });
    } else {
      res.status(401).json({
        success: false,
        message: 'Login failed',
        error: result.error
      });
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
});

/**
 * GET /api/auth/profile - Get current user profile (protected route)
 */
router.get('/profile', verifyToken, async (req, res) => {
  try {
    const result = await getProfile(req.user.userId);
    
    if (result.success) {
      res.status(200).json({
        success: true,
        data: result.data
      });
    } else {
      res.status(404).json({
        success: false,
        message: 'Profile not found',
        error: result.error
      });
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
});

/**
 * POST /api/auth/forgot-password - Request password reset
 */
router.post('/forgot-password', async (req, res) => {
  try {
    const { email } = req.body;
    
    // Validate required fields
    if (!email) {
      return res.status(400).json({
        success: false,
        message: 'Email is required'
      });
    }
    
    const result = await requestPasswordReset(email);
    
    // Always return 200 to prevent email enumeration
    res.status(200).json({
      success: true,
      message: 'If the email exists, a reset link has been sent'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
});

/**
 * POST /api/auth/reset-password - Reset password with token
 */
router.post('/reset-password', async (req, res) => {
  try {
    const { token, newPassword } = req.body;
    
    // Validate required fields
    if (!token || !newPassword) {
      return res.status(400).json({
        success: false,
        message: 'Token and new password are required'
      });
    }
    
    // Validate password length
    if (newPassword.length < 6) {
      return res.status(400).json({
        success: false,
        message: 'Password must be at least 6 characters long'
      });
    }
    
    const result = await resetPassword(token, newPassword);
    
    if (result.success) {
      res.status(200).json({
        success: true,
        message: 'Password reset successfully'
      });
    } else {
      res.status(400).json({
        success: false,
        message: 'Password reset failed',
        error: result.error
      });
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
});

module.exports = router;
