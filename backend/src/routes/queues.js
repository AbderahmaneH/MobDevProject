const express = require('express');
const router = express.Router();
const { createQueue, updateQueue, deleteQueue } = require('../models/queue');

// Create a new queue
router.post('/', async (req, res) => {
  try {
    const result = await createQueue(req.body);
    
    if (result.success) {
      res.status(201).json({ 
        success: true,
        message: 'Queue created successfully',
        data: result.data
      });
    } else {
      res.status(400).json({
        success: false,
        message: 'Failed to create queue',
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


// Update a queue
router.put('/:id', async (req, res) => {
  try {
    const queueId = parseInt(req.params.id);
    const result = await updateQueue(queueId, req.body);
    
    if (result.success) {
      res.status(200).json({
        success: true,
        message: 'Queue updated successfully',
        data: result.data
      });
    } else {
      res.status(404).json({
        success: false,
        message: 'Failed to update queue',
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

// Delete a queue
router.delete('/:id', async (req, res) => {
  try {
    const queueId = parseInt(req.params.id);
    const result = await deleteQueue(queueId);
    
    if (result.success) {
      res.status(200).json({
        success: true,
        message: 'Queue deleted successfully',
        data: result.data
      });
    } else {
      res.status(404).json({
        success: false,
        message: 'Failed to delete queue',
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
