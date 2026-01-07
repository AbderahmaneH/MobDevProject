const supabase = require('../config/database');

async function addQueueClient(clientData) {
  const { queueId, userId, name, phone, position, status } = clientData;
  
  try {
    const { data, error } = await supabase
      .from('queue_clients')
      .insert({
        queue_id: queueId,
        user_id: userId || null,
        name,
        phone,
        position,
        status: status || 'waiting',
        joined_at: Date.now()
      })
      .select()
      .single();
    
    if (error) {
      console.error('Error adding queue client:', error);
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
    console.error('Error adding queue client:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

async function updateQueueClient(clientId, updateData) {
  const { status, servedAt, notifiedAt, position } = updateData;
  
  const updates = {};
  
  if (status !== undefined) {
    updates.status = status;
  }
  
  if (servedAt !== undefined) {
    updates.served_at = servedAt;
  }
  
  if (notifiedAt !== undefined) {
    updates.notified_at = notifiedAt;
  }
  
  if (position !== undefined) {
    updates.position = position;
  }
  
  try {
    const { data, error } = await supabase
      .from('queue_clients')
      .update(updates)
      .eq('id', clientId)
      .select()
      .single();
    
    if (error) {
      console.error('Error updating queue client:', error);
      return {
        success: false,
        error: error.message
      };
    }
    
    if (!data) {
      return {
        success: false,
        error: 'Queue client not found'
      };
    }
    
    return {
      success: true,
      data
    };
  } catch (error) {
    console.error('Error updating queue client:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

/**
 * Remove a client from queue
 */
async function removeQueueClient(clientId) {
  try {
    const { data, error } = await supabase
      .from('queue_clients')
      .delete()
      .eq('id', clientId)
      .select('id')
      .single();
    
    if (error) {
      console.error('Error removing queue client:', error);
      return {
        success: false,
        error: error.message
      };
    }
    
    if (!data) {
      return {
        success: false,
        error: 'Queue client not found'
      };
    }
    
    return {
      success: true,
      data: { id: data.id }
    };
  } catch (error) {
    console.error('Error removing queue client:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

module.exports = {
  addQueueClient,
  updateQueueClient,
  removeQueueClient
};
