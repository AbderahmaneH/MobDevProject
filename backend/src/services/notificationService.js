const supabase = require('../config/database');

/**
 * Notify a customer that they are next in line
 */
async function notifyCustomerNext(queueClientId) {
  try {
    // Get queue client details
    const { data: queueClient, error: clientError } = await supabase
      .from('queue_clients')
      .select(`
        *,
        queues (
          id,
          name,
          business_owner_id
        ),
        users (
          id,
          name,
          phone,
          email
        )
      `)
      .eq('id', queueClientId)
      .single();

    if (clientError || !queueClient) {
      return {
        success: false,
        error: 'Queue client not found'
      };
    }

    // Update notified_at timestamp
    const { error: updateError } = await supabase
      .from('queue_clients')
      .update({
        notified_at: Date.now(),
        status: 'notified'
      })
      .eq('id', queueClientId);

    if (updateError) {
      console.error('Error updating notification status:', updateError);
    }

    // Here you would integrate with Firebase Cloud Messaging (FCM)
    // or any other push notification service
    // For now, we'll just log it
    console.log(`Notification sent to ${queueClient.users.name} for queue ${queueClient.queues.name}`);
    console.log(`Position: ${queueClient.position}`);

    return {
      success: true,
      data: {
        userId: queueClient.user_id,
        queueId: queueClient.queue_id,
        queueName: queueClient.queues.name,
        position: queueClient.position,
        userName: queueClient.users.name,
        userPhone: queueClient.users.phone
      }
    };
  } catch (error) {
    console.error('Error in notifyCustomerNext:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

/**
 * Notify customer that it's their turn
 */
async function notifyCustomerTurn(queueClientId) {
  try {
    const { data: queueClient, error } = await supabase
      .from('queue_clients')
      .select(`
        *,
        queues (
          id,
          name
        ),
        users (
          id,
          name,
          phone
        )
      `)
      .eq('id', queueClientId)
      .single();

    if (error || !queueClient) {
      return {
        success: false,
        error: 'Queue client not found'
      };
    }

    console.log(`TURN notification sent to ${queueClient.users.name} for queue ${queueClient.queues.name}`);

    return {
      success: true,
      data: {
        userId: queueClient.user_id,
        queueId: queueClient.queue_id,
        queueName: queueClient.queues.name,
        userName: queueClient.users.name
      }
    };
  } catch (error) {
    console.error('Error in notifyCustomerTurn:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

/**
 * Notify all customers in a queue of a status change
 */
async function notifyQueueStatusChange(queueId, status) {
  try {
    const { data: queueClients, error } = await supabase
      .from('queue_clients')
      .select(`
        *,
        users (
          id,
          name,
          phone
        )
      `)
      .eq('queue_id', queueId)
      .eq('status', 'waiting');

    if (error) {
      return {
        success: false,
        error: error.message
      };
    }

    console.log(`Queue status change notification sent to ${queueClients.length} customers`);

    return {
      success: true,
      data: {
        notifiedCount: queueClients.length,
        queueId,
        status
      }
    };
  } catch (error) {
    console.error('Error in notifyQueueStatusChange:', error);
    return {
      success: false,
      error: error.message
    };
  }
}

module.exports = {
  notifyCustomerNext,
  notifyCustomerTurn,
  notifyQueueStatusChange
};
