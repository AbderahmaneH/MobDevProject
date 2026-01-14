const supabase = require('../config/database'); // Import the Supabase client from the database configuration file

async function createQueue(queueData) {
  const { businessOwnerId, name, description, maxSize, estimatedWaitTime, isActive } = queueData;
  
  try {
    const { data, error } = await supabase // Call the Supabase client awaiting the result from the table queues
      .from('queues')
      .insert({ // Insert a new record into the queues table with the provided data
        business_owner_id: businessOwnerId,
        name,
        description: description || null,
        max_size: maxSize || 50,
        estimated_wait_time: estimatedWaitTime || 5,
        is_active: isActive !== undefined ? (isActive ? 1 : 0) : 1, // If isActive is provided it checks if it is true/false and converts it to 1 or 0, if isActive is not provided it defaults to 1 (Active)
        created_at: Date.now()
      })
      .select() // Returns the newly created record
      .single(); // Ensures that only a single record is returned
    
    if (error) {
      console.error('Error creating queue:', error);
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
    console.error('Error creating queue:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

async function updateQueue(queueId, queueData) {
  const { name, description, maxSize, estimatedWaitTime, isActive } = queueData;
  
  try {
    const { data, error } = await supabase
      .from('queues')
      .update({ // Update the record in the queues table with the provided data
        name,
        description: description || null,
        max_size: maxSize,
        estimated_wait_time: estimatedWaitTime,
        is_active: isActive ? 1 : 0
      })
      .eq('id', queueId) // Specifies which record to update based on the queueId
      .select() //
      .single();
    
    if (error) {
      console.error('Error updating queue:', error);
      return {
        success: false,
        error: error.message
      };
    }
    
    if (!data) {
      return {
        success: false,
        error: 'Queue not found'
      };
    }
    
    return {
      success: true,
      data
    };
  } catch (error) {
    console.error('Error updating queue:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

async function deleteQueue(queueId) {
  try {
    const { data, error } = await supabase
      .from('queues')
      .delete() // Deletes the record from the queues table
      .eq('id', queueId)
      .select('id')
      .single();
    
    if (error) {
      console.error('Error deleting queue:', error);
      return {
        success: false,
        error: error.message
      };
    }
    
    if (!data) {
      return {
        success: false,
        error: 'Queue not found'
      };
    }
    
    return {
      success: true,
      data: { id: data.id }
    };
  } catch (error) {
    console.error('Error deleting queue:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

module.exports = { // Export the functions to be used in other parts of the application
  createQueue,
  updateQueue,
  deleteQueue
};
