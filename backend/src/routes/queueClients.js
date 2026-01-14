const express = require('express'); // Import Express framework
const router = express.Router(); // Create a new router instance
const { addQueueClient, updateQueueClient, removeQueueClient } = require('../models/queueClient'); // Import queue client model functions

// Add a client to a queue
router.post('/', async (req, res) => { // Endpoint to add a client to a queue
  try {
    const result = await addQueueClient(req.body); // Call the addQueueClient function with request body data
    
    if (result.success) {
      res.status(201).json({ // Respond with success if client was added
        success: true,
        message: 'Client added to queue successfully',
        data: result.data
      });
    } else {
      res.status(400).json({ // Respond with error if adding client failed
        success: false,
        message: 'Failed to add client to queue',
        error: result.error
      });
    }
  } catch (error) {
    res.status(500).json({ // Handle unexpected server errors
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
});

// Update queue client
router.put('/:id', async (req, res) => { // Endpoint to update a queue client by ID
  try {
    const clientId = parseInt(req.params.id); // Get client ID from request parameters
    const result = await updateQueueClient(clientId, req.body);
    
    if (result.success) {
      res.status(200).json({ // Respond with success if client was updated
        success: true,
        message: 'Queue client updated successfully',
        data: result.data
      });
    } else {
      res.status(404).json({ // Respond with error if updating client failed
        success: false,
        message: 'Failed to update queue client',
        error: result.error
      });
    }
  } catch (error) {
    res.status(500).json({ // Handle unexpected server errors
      success: false,
      message: 'Internal server error',
      error: error.message
    });
  }
});


// Remove a client from queue
router.delete('/:id', async (req, res) => { // Endpoint to remove a client from a queue by ID
  try {
    const clientId = parseInt(req.params.id); // Get client ID from request parameters
    const result = await removeQueueClient(clientId);
    
    if (result.success) {
      res.status(200).json({ // Respond with success if client was removed
        success: true,
        message: 'Client removed from queue successfully',
        data: result.data
      });
    } else {
      res.status(404).json({ // Respond with error if removing client failed
        success: false,
        message: 'Failed to remove client from queue',
        error: result.error
      });
    }
  } catch (error) {
    res.status(500).json({ // Handle unexpected server errors
      success: false, 
      message: 'Internal server error',
      error: error.message
    });
  }
});

module.exports = router; // Export the router to be used in other parts of the application
