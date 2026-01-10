const supabase = require('../config/database');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const { sendPasswordResetEmail } = require('../services/emailService');

const SALT_ROUNDS = 10;

/**
 * Register a new user with hashed password
 */
async function register(userData) {
  const { name, email, phone, password, isBusiness, businessName, businessType, businessAddress } = userData;
  
  try {
    // Validate required fields
    if (!email) {
      return {
        success: false,
        error: 'Email is required'
      };
    }
    
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
    
    // Check if email already exists
    const { data: existingEmail } = await supabase
      .from('users')
      .select('id')
      .eq('email', email)
      .single();
    
    if (existingEmail) {
      return {
        success: false,
        error: 'Email already registered'
      };
    }
    
    // Hash the password
    const hashedPassword = await bcrypt.hash(password, SALT_ROUNDS);
    
    // Create user with hashed password
    const { data, error } = await supabase
      .from('users')
      .insert({
        name,
        email,
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
 * Login user with email or phone and password
 */
async function login(identifier, password) {
  try {
    // Determine if identifier is email or phone
    const isEmail = identifier.includes('@');
    
    // Get user by email or phone
    const { data: user, error } = await supabase
      .from('users')
      .select('*')
      .eq(isEmail ? 'email' : 'phone', identifier)
      .single();
    
    if (error || !user) {
      return {
        success: false,
        error: 'Invalid email/phone or password'
      };
    }
    
    // Verify password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    
    if (!isPasswordValid) {
      return {
        success: false,
        error: 'Invalid email/phone or password'
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

/**
 * Request password reset - generates token and sends email
 */
async function requestPasswordReset(email) {
  try {
    console.log('Password reset requested for email:', email);
    
    // Check if user exists
    const { data: user, error } = await supabase
      .from('users')
      .select('id, name, email')
      .eq('email', email)
      .single();
    
    if (error || !user) {
      console.log('User not found or error:', error?.message || 'No user');
      // Don't reveal if email exists or not (security)
      return {
        success: true,
        message: 'If the email exists, a reset link has been sent'
      };
    }
    
    console.log('User found, generating reset token for user ID:', user.id);
    
    // Generate reset token
    const resetToken = crypto.randomBytes(32).toString('hex');
    const resetTokenExpiry = Date.now() + 3600000; // 1 hour from now
    
    console.log('Storing reset token in database...');
    
    // Store token in database
    const { error: updateError } = await supabase
      .from('users')
      .update({
        reset_token: resetToken,
        reset_token_expiry: resetTokenExpiry
      })
      .eq('id', user.id);
    
    if (updateError) {
      console.error('Failed to store reset token:', updateError);
      return {
        success: false,
        error: 'Failed to generate reset token. Please try again later.'
      };
    }
    
    console.log('Sending password reset email...');
    
    // Send email
    const emailResult = await sendPasswordResetEmail(email, resetToken);
    
    if (!emailResult.success) {
      console.error('Failed to send reset email:', emailResult.error);
      return {
        success: false,
        error: 'Failed to send reset email. Please check email configuration.'
      };
    }
    
    console.log('Password reset email sent successfully to:', email);
    
    return {
      success: true,
      message: 'Password reset email sent successfully'
    };
  } catch (error) {
    console.error('Error requesting password reset:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

/**
 * Reset password using token
 */
async function resetPassword(token, newPassword) {
  try {
    console.log('Attempting to reset password with token');
    
    // Find user with valid token
    const { data: user, error } = await supabase
      .from('users')
      .select('id, reset_token, reset_token_expiry')
      .eq('reset_token', token)
      .single();
    
    if (error) {
      console.error('Error finding user with reset token:', error);
      return {
        success: false,
        error: 'This reset link has expired or is invalid. Please request a new password reset link.'
      };
    }
    
    if (!user) {
      console.log('No user found with provided reset token');
      return {
        success: false,
        error: 'This reset link has expired or is invalid. Please request a new password reset link.'
      };
    }
    
    console.log('User found, checking token expiry...');
    
    // Check if token is expired
    if (user.reset_token_expiry < Date.now()) {
      console.log('Reset token has expired');
      return {
        success: false,
        error: 'This reset link has expired. Please request a new password reset link.'
      };
    }
    
    console.log('Token valid, hashing new password...');
    
    // Hash new password
    const hashedPassword = await bcrypt.hash(newPassword, SALT_ROUNDS);
    
    console.log('Updating password in database...');
    
    // Update password and clear reset token
    const { error: updateError } = await supabase
      .from('users')
      .update({
        password: hashedPassword,
        reset_token: null,
        reset_token_expiry: null
      })
      .eq('id', user.id);
    
    if (updateError) {
      console.error('Failed to update password:', updateError);
      return {
        success: false,
        error: 'Failed to update password'
      };
    }
    
    console.log('Password reset successfully for user ID:', user.id);
    
    return {
      success: true,
      message: 'Password reset successfully'
    };
  } catch (error) {
    console.error('Error resetting password:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

/**
 * Change user password (requires current password verification)
 */
async function changePassword(userId, currentPassword, newPassword) {
  try {
    console.log('Attempting to change password for user ID:', userId);
    
    // Get user with password
    const { data: user, error } = await supabase
      .from('users')
      .select('id, password')
      .eq('id', userId)
      .single();
    
    if (error || !user) {
      console.error('User not found:', error?.message);
      return {
        success: false,
        error: 'User not found'
      };
    }
    
    console.log('User found, verifying current password...');
    
    // Verify current password
    const isPasswordValid = await bcrypt.compare(currentPassword, user.password);
    
    if (!isPasswordValid) {
      console.log('Current password is incorrect');
      return {
        success: false,
        error: 'Current password is incorrect'
      };
    }
    
    console.log('Current password verified, hashing new password...');
    
    // Hash new password
    const hashedPassword = await bcrypt.hash(newPassword, SALT_ROUNDS);
    
    console.log('Updating password in database...');
    
    // Update password
    const { error: updateError } = await supabase
      .from('users')
      .update({ password: hashedPassword })
      .eq('id', userId);
    
    if (updateError) {
      console.error('Failed to update password:', updateError);
      return {
        success: false,
        error: 'Failed to update password'
      };
    }
    
    console.log('Password changed successfully for user ID:', userId);
    
    return {
      success: true,
      message: 'Password changed successfully'
    };
  } catch (error) {
    console.error('Error changing password:', error);
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
  getProfile,
  requestPasswordReset,
  resetPassword,
  changePassword
};
