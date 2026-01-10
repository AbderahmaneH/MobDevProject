const jwt = require('jsonwebtoken');

// Middleware to verify JWT token
function verifyToken(req, res, next) {
  // Get token from header
  const authHeader = req.headers['authorization'];
  // Bearer TOKEN
  const token = authHeader && authHeader.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Access denied. No token provided.'
    });
  }
  
  try {
    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(403).json({
      success: false,
      message: 'Invalid or expired token'
    });
  }
}

// Middleware to verify if user is a business owner
function verifyBusiness(req, res, next) {
  if (!req.user.isBusiness) {
    return res.status(403).json({
      success: false,
      message: 'Access denied. Business account required.'
    });
  }
  next();
}

module.exports = {
  verifyToken,
  verifyBusiness
};
