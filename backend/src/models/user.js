const supabase = require('../config/database');
const bcrypt = require('bcrypt');

const SALT_ROUNDS = 10;


// Insert a new user into the database with hashed password
async function createUser(userData) {
  const { name, email, phone, password, isBusiness, businessName, businessType, businessAddress } = userData;
  
  try {
    // Hash the password
    const hashedPassword = await bcrypt.hash(password, SALT_ROUNDS);
    
    // Validate required fields
    if (!email) {
      return {
        success: false,
        error: 'Email is required'
      };
    }
    
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
      console.error('Error creating user:', error);
      return {
        success: false,
        error: error.message
      };
    }
    
    // Remove password from response
    const userResponse = { ...data };
    delete userResponse.password;
    
    return {
      success: true,
      data: userResponse
    };
  } catch (error) {
    console.error('Error creating user:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

/**
 * Update an existing user
 */
async function updateUser(userId, userData) {
  const { name, email, phone, password, businessName, businessType, businessAddress } = userData;
  
  try {
    const updateData = {
      name,
      email,
      phone,
      business_name: businessName || null,
      business_type: businessType || null,
      business_address: businessAddress || null
    };
    
    // Only hash and update password if provided
    if (password) {
      updateData.password = await bcrypt.hash(password, SALT_ROUNDS);
    }
    
    const { data, error } = await supabase
      .from('users')
      .update(updateData)
      .eq('id', userId)
      .select()
      .single();
    
    if (error) {
      console.error('Error updating user:', error);
      return {
        success: false,
        error: error.message
      };
    }
    
    if (!data) {
      return {
        success: false,
        error: 'User not found'
      };
    }
    
    // Remove password from response
    const userResponse = { ...data };
    delete userResponse.password;
    
    return {
      success: true,
      data: userResponse
    };
  } catch (error) {
    console.error('Error updating user:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

// Delete a user

async function deleteUser(userId) {
  try {
    const { data, error } = await supabase
      .from('users')
      .delete()
      .eq('id', userId)
      .select('id')
      .single();
    
    if (error) {
      console.error('Error deleting user:', error);
      return {
        success: false,
        error: error.message
      };
    }
    
    if (!data) {
      return {
        success: false,
        error: 'User not found'
      };
    }
    
    return {
      success: true,
      data: { id: data.id }
    };
  } catch (error) {
    console.error('Error deleting user:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

module.exports = {
  createUser,
  updateUser,
  deleteUser
};
