const supabase = require('../config/database');

/**
 * Insert a new user into the database
 */
async function createUser(userData) {
  const { name, email, phone, password, isBusiness, businessName, businessType, businessAddress } = userData;
  
  try {
    const { data, error } = await supabase
      .from('users')
      .insert({
        name,
        email: email || null,
        phone,
        password,
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
    
    return {
      success: true,
      data
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
    const { data, error } = await supabase
      .from('users')
      .update({
        name,
        email: email || null,
        phone,
        password,
        business_name: businessName || null,
        business_type: businessType || null,
        business_address: businessAddress || null
      })
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
    
    return {
      success: true,
      data
    };
  } catch (error) {
    console.error('Error updating user:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

/**
 * Delete a user
 */
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
