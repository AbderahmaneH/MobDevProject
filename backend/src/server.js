const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser'); // Middleware for parsing request bodies
const path = require('path'); // Module for handling file paths
require('dotenv').config(); // Load environment variables from .env file
const webhookRoutes = require('./routes/webhooks');
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const queueRoutes = require('./routes/queues');
const queueClientRoutes = require('./routes/queueClients');

const app = express(); // Create an Express application instance
const PORT = process.env.PORT || 3000; // Define the port the server will listen on

// Middleware
app.use(cors()); // Enable CORS for all routes
app.use(bodyParser.json()); // Parse JSON request bodies
app.use(bodyParser.urlencoded({ extended: true })); // Parse URL-encoded request bodies

// Request logging middleware
app.use((req, res, next) => { // Log each incoming request with timestamp method and path
  console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
  next(); // Proceed to the next middleware or route handler
});

// Webhooks need to be before static files to process raw body
app.use('/api/webhooks', webhookRoutes);

app.use(express.static(path.join(__dirname, '../public'))); // Serve static files from public directory

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Password reset page
app.get('/reset-password', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/reset-password.html')); // Serve the password reset HTML file
});

// Password reset success page
app.get('/reset-success', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/reset-success.html')); // Serve the password reset success HTML file
});

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/queues', queueRoutes);
app.use('/api/queue-clients', queueClientRoutes);

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'QNow Backend API',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      auth: '/api/auth',
      users: '/api/users',
      queues: '/api/queues',
      queueClients: '/api/queue-clients'
    }
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Endpoint not found'
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(500).json({
    success: false,
    message: 'Internal server error',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// Start server
app.listen(PORT, () => {
  console.log('========================================');
  console.log('  QNow Backend API Server');
  console.log('========================================');
  console.log(`  Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`  Server running on port ${PORT}`);
  console.log(`  API URL: http://localhost:${PORT}`);
  console.log('========================================');
});

module.exports = app;
