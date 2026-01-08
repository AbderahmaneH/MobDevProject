const express = require('express');
const router = express.Router();
const {
  notifyCustomerNext,
  notifyCustomerTurn,
  notifyQueueStatusChange
} = require('../services/notificationService');

/**
 * POST /api/notifications/next/:clientId
 * Notify a customer they are next in line
 */
router.post('/next/:clientId', async (req, res) => {
  try {
    const clientId = parseInt(req.params.clientId);
    const result = await notifyCustomerNext(clientId);

    if (result.success) {
      res.status(200).json({
        success: true,
        message: 'Notification sent successfully',
        data: result.data
      });
    } else {
      res.status(404).json({
        success: false,
        message: 'Failed to send notification',
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
 * POST /api/notifications/turn/:clientId
 * Notify a customer it's their turn
 */
router.post('/turn/:clientId', async (req, res) => {
  try {
    const clientId = parseInt(req.params.clientId);
    const result = await notifyCustomerTurn(clientId);

    if (result.success) {
      res.status(200).json({
        success: true,
        message: 'Turn notification sent successfully',
        data: result.data
      });
    } else {
      res.status(404).json({
        success: false,
        message: 'Failed to send notification',
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
 * POST /api/notifications/queue-status/:queueId
 * Notify all customers in queue of status change
 */
router.post('/queue-status/:queueId', async (req, res) => {
  try {
    const queueId = parseInt(req.params.queueId);
    const { status } = req.body;

    if (!status) {
      return res.status(400).json({
        success: false,
        message: 'Status is required'
      });
    }

    const result = await notifyQueueStatusChange(queueId, status);

    if (result.success) {
      res.status(200).json({
        success: true,
        message: 'Status change notifications sent',
        data: result.data
      });
    } else {
      res.status(400).json({
        success: false,
        message: 'Failed to send notifications',
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
