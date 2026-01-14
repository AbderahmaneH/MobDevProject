const express = require('express');
const router = express.Router();
const { createUser, updateUser, deleteUser } = require('../models/user');

// Create a new user
router.post('/', async (req, res) => {
  try {
    const result = await createUser(req.body);
    
    if (result.success) {
      res.status(201).json({
        success: true,
        message: 'User created successfully',
        data: result.data
      });
    } else {
      res.status(400).json({
        success: false,
        message: 'Failed to create user',
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


// Update a user
router.put('/:id', async (req, res) => {
  try {
    const userId = parseInt(req.params.id);
    const result = await updateUser(userId, req.body);
    
    if (result.success) {
      res.status(200).json({
        success: true,
        message: 'User updated successfully',
        data: result.data
      });
    } else {
      res.status(404).json({
        success: false,
        message: 'Failed to update user',
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

// Delete a user
router.delete('/:id', async (req, res) => {
  try {
    const userId = parseInt(req.params.id);
    const result = await deleteUser(userId);
    
    if (result.success) {
      res.status(200).json({
        success: true,
        message: 'User deleted successfully',
        data: result.data
      });
    } else {
      res.status(404).json({
        success: false,
        message: 'Failed to delete user',
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
