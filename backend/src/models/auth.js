const supabase = require('../config/database');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

const SALT_ROUNDS = 10;

/**
 * Register a new user with hashed password
 */
async function register(userData) {
  const { name, email, phone, password, isBusiness, businessName, businessType, businessAddress } = userData;
  
  try {
    // Check if phone already exists
    const { data: existingUser } = await supabase
      .from('users')
      .select('id')
      .eq('phone', phone)
      .single();
    
    if (existingUser) {
      return {
        success: false,
        error: 'Phone number already registered'
      };
    }
    
    // Hash the password
    const hashedPassword = await bcrypt.hash(password, SALT_ROUNDS);
    
    // Create user with hashed password
    const { data, error } = await supabase
      .from('users')
      .insert({
        name,
        email: email || null,
        phone,
        password: hashedPassword,
        is_business: isBusiness ? 1 : 0,
        created_at: Date.now(),
        business_name: businessName || null,
        business_type: businessType || null,
        business_address: businessAddress || null
      })
      .select()
      .single();
    
    if (error) {
      console.error('Error registering user:', error);
      return {
        success: false,
        error: error.message
      };
    }
    
    // Generate JWT token
    const token = jwt.sign(
      { 
        userId: data.id, 
        phone: data.phone,
        isBusiness: data.is_business === 1
      },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );
    
    // Remove password from response
    const userResponse = { ...data };
    delete userResponse.password;
    
    return {
      success: true,
      data: {
        user: userResponse,
        token
      }
    };
  } catch (error) {
    console.error('Error registering user:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

/**
 * Login user with phone and password
 */
async function login(phone, password) {
  try {
    // Get user by phone
    const { data: user, error } = await supabase
      .from('users')
      .select('*')
      .eq('phone', phone)
      .single();
    
    if (error || !user) {
      return {
        success: false,
        error: 'Invalid phone number or password'
      };
    }
    
    // Verify password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    
    if (!isPasswordValid) {
      return {
        success: false,
        error: 'Invalid phone number or password'
      };
    }
    
    // Generate JWT token
    const token = jwt.sign(
      { 
        userId: user.id, 
        phone: user.phone,
        isBusiness: user.is_business === 1
      },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );
    
    // Remove password from response
    const userResponse = { ...user };
    delete userResponse.password;
    
    return {
      success: true,
      data: {
        user: userResponse,
        token
      }
    };
  } catch (error) {
    console.error('Error logging in:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

/**
 * Verify JWT token
 */
function verifyToken(token) {
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    return {
      success: true,
      data: decoded
    };
  } catch (error) {
    return {
      success: false,
      error: 'Invalid or expired token'
    };
  }
}

/**
 * Get user profile by ID
 */
async function getProfile(userId) {
  try {
    const { data: user, error } = await supabase
      .from('users')
      .select('*')
      .eq('id', userId)
      .single();
    
    if (error || !user) {
      return {
        success: false,
        error: 'User not found'
      };
    }
    
    // Remove password from response
    const userResponse = { ...user };
    delete userResponse.password;
    
    return {
      success: true,
      data: userResponse
    };
  } catch (error) {
    console.error('Error getting profile:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

module.exports = {
  register,
  login,
  verifyToken,
  getProfile
};
