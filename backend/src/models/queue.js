const supabase = require('../config/database');

async function createQueue(queueData) {
  const { businessOwnerId, name, description, maxSize, estimatedWaitTime, isActive } = queueData;
  
  try {
    const { data, error } = await supabase
      .from('queues')
      .insert({
        business_owner_id: businessOwnerId,
        name,
        description: description || null,
        max_size: maxSize || 50,
        estimated_wait_time: estimatedWaitTime || 5,
        is_active: isActive !== undefined ? (isActive ? 1 : 0) : 1,
        created_at: Date.now()
      })
      .select()
      .single();
    
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
      .update({
        name,
        description: description || null,
        max_size: maxSize,
        estimated_wait_time: estimatedWaitTime,
        is_active: isActive ? 1 : 0
      })
      .eq('id', queueId)
      .select()
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
      .delete()
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

module.exports = {
  createQueue,
  updateQueue,
  deleteQueue
};
