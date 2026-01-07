const express = require('express');
const router = express.Router();
const { register, login, getProfile } = require('../models/auth');
const { verifyToken } = require('../middleware/auth');

/**
 * POST /api/auth/register - Register a new user
 */
router.post('/register', async (req, res) => {
  try {
    const { name, email, phone, password, isBusiness, businessName, businessType, businessAddress } = req.body;
    
    // Validate required fields
    if (!name || !phone || !password) {
      return res.status(400).json({
        success: false,
        message: 'Name, phone, and password are required'
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

module.exports = router;
