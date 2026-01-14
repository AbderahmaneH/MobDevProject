const supabase = require('../config/database');
const bcrypt = require('bcrypt'); // For hashing passwords

const SALT_ROUNDS = 10; // Number of salt rounds (cost) for bcrypt


async function createUser(userData) {
  const { name, email, phone, password, isBusiness, businessName, businessType, businessAddress } = userData;
  
  try {
    const hashedPassword = await bcrypt.hash(password, SALT_ROUNDS); // Hash the password before storing it
    
    if (!email) { // Ensure email is provided
      return {
        success: false,
        error: 'Email is required'
      };
    }
    
    const { data, error } = await supabase // Insert the new user into the users table
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
    
    if (password) { // If password is provided hash it before updating
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
