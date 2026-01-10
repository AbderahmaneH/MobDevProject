const express = require('express');
const router = express.Router();

const supabaseService = require('../config/databaseService');
const { getFirebaseAdmin } = require('../services/firebaseAdmin');

router.get('/ping', (req, res) => {
  res.json({ ok: true, message: 'webhooks router is mounted' });
});

router.get('/notification-created', (req, res) => {
  res.status(405).json({ success: false, message: 'Use POST' });
});

// Simple shared secret protection
function requireWebhookSecret(req, res, next) {
  const header = req.headers['authorization'] || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;

  if (!token || token !== process.env.SUPABASE_WEBHOOK_SECRET) {
    return res.status(401).json({ success: false, message: 'Unauthorized webhook' });
  }
  next();
}

// Supabase Database Webhook payload includes: type, table, schema, record, old_record
router.post('/notification-created', requireWebhookSecret, async (req, res) => {
  try {
    const payload = req.body;
    const record = payload.record;
    if (!record) return res.status(400).json({ success: false, message: 'Missing record' });

    // Only handle inserts
    if (payload.type && payload.type !== 'INSERT') {
      console.log(`[Webhook] Ignoring non-INSERT event type: ${payload.type}`);
      return res.json({ success: true, ignored: true });
    }

    const notificationId = record.id;
    const userId = record.user_id;

    console.log(`[Webhook] Processing notification ${notificationId} for user ${userId}`);

    // Get user token from Supabase
    const { data: user, error: userErr } = await supabaseService
      .from('users')
      .select('fcm_token')
      .eq('id', userId)
      .maybeSingle();

    if (userErr) {
      console.error(`[Webhook] Error fetching user ${userId}:`, userErr);
      throw userErr;
    }

    // No token => can't push
    if (!user || !user.fcm_token) {
      console.warn(`[Webhook] No FCM token for user ${userId}, skipping push notification`);
      const newData = {
        ...(record.data || {}),
        delivery_status: 'failed',
        delivery_error: 'No fcm_token for this user',
        failed_at: new Date().toISOString(),
      };

      await supabaseService.from('notification').update({ data: newData }).eq('id', notificationId);
      return res.json({ success: true, skipped: true, reason: 'no_fcm_token' });
    }

    // Fetch latest row and check if already sent
    const { data: latest } = await supabaseService
      .from('notification')
      .select('data')
      .eq('id', notificationId)
      .maybeSingle();

    if (latest?.data?.push_sent_at) {
      console.log(`[Webhook] Notification ${notificationId} already sent, deduplicating`);
      return res.json({ success: true, deduped: true });
    }

    // Send push with Firebase Admin
    const admin = getFirebaseAdmin();

    const title = record.title || 'QNow';
    const body = record.message || '';

    // FCM data values must be strings in practice so convert.
    const data = record.data || {};
    const stringData = Object.fromEntries(
      Object.entries(data).map(([k, v]) => [String(k), v == null ? '' : String(v)])
    );

    console.log(`[Webhook] Sending FCM notification to user ${userId}: "${title}"`);
    
    try {
      await admin.messaging().send({
        token: user.fcm_token,
        notification: { title, body },
        data: stringData,
      });
      console.log(`[Webhook] Successfully sent FCM notification ${notificationId} to user ${userId}`);
    } catch (fcmError) {
      console.error(`[Webhook] FCM send error for notification ${notificationId}:`, fcmError);
      const errorData = {
        ...(record.data || {}),
        delivery_status: 'failed',
        delivery_error: fcmError.message || 'FCM send failed',
        failed_at: new Date().toISOString(),
      };
      await supabaseService.from('notification').update({ data: errorData }).eq('id', notificationId);
      return res.status(500).json({ success: false, error: 'FCM send failed', details: fcmError.message });
    }

    // Mark as sent inside `data`
    const updatedData = {
      ...(record.data || {}),
      delivery_status: 'sent',
      push_sent_at: new Date().toISOString(),
    };

    await supabaseService.from('notification').update({ data: updatedData }).eq('id', notificationId);

    return res.json({ success: true, notificationId, userId });
  } catch (e) {
    console.error('[Webhook] Unexpected error:', e);
    return res.status(500).json({ success: false, error: e.message });
  }
});

module.exports = router;
