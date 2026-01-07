const express = require('express');
const router = express.Router();
const { addQueueClient, updateQueueClient, removeQueueClient } = require('../models/queueClient');

// Add a client to a queue

router.post('/', async (req, res) => {
  try {
    const result = await addQueueClient(req.body);
    
    if (result.success) {
      res.status(201).json({
        success: true,
        message: 'Client added to queue successfully',
        data: result.data
      });
    } else {
      res.status(400).json({
        success: false,
        message: 'Failed to add client to queue',
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

// Update queue client

router.put('/:id', async (req, res) => {
  try {
    const clientId = parseInt(req.params.id);
    const result = await updateQueueClient(clientId, req.body);
    
    if (result.success) {
      res.status(200).json({
        success: true,
        message: 'Queue client updated successfully',
        data: result.data
      });
    } else {
      res.status(404).json({
        success: false,
        message: 'Failed to update queue client',
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


// Remove a client from queue

router.delete('/:id', async (req, res) => {
  try {
    const clientId = parseInt(req.params.id);
    const result = await removeQueueClient(clientId);
    
    if (result.success) {
      res.status(200).json({
        success: true,
        message: 'Client removed from queue successfully',
        data: result.data
      });
    } else {
      res.status(404).json({
        success: false,
        message: 'Failed to remove client from queue',
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
