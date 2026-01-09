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

// simple shared secret protection
function requireWebhookSecret(req, res, next) {
  const header = req.headers['authorization'] || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;

  if (!token || token !== process.env.SUPABASE_WEBHOOK_SECRET) {
    return res.status(401).json({ success: false, message: 'Unauthorized webhook' });
  }
  next();
}


// Supabase Database Webhook payload includes: type, table, schema, record, old_record :contentReference[oaicite:3]{index=3}
router.post('/notification-created', requireWebhookSecret, async (req, res) => {
  try {
    const payload = req.body;
    const record = payload.record; // new row data
    if (!record) return res.status(400).json({ success: false, message: 'Missing record' });

    // Only handle INSERTs (optional but safe)
    if (payload.type && payload.type !== 'INSERT') {
      return res.json({ success: true, ignored: true });
    }

    const notificationId = record.id;
    const userId = record.user_id;

    // 1) get user token from Supabase
    const { data: user, error: userErr } = await supabaseService
      .from('users')
      .select('fcm_token')
      .eq('id', userId)
      .maybeSingle();

    if (userErr) throw userErr;

    // No token => can't push
    if (!user || !user.fcm_token) {
      // Optional: write status into notification.data
      const newData = {
        ...(record.data || {}),
        delivery_status: 'failed',
        delivery_error: 'No fcm_token for this user',
        failed_at: new Date().toISOString(),
      };

      await supabaseService.from('notification').update({ data: newData }).eq('id', notificationId);
      return res.json({ success: true, skipped: true });
    }

    // Optional safety: avoid duplicate sends if webhook retries
    // Fetch latest row and check if already sent
    const { data: latest } = await supabaseService
      .from('notification')
      .select('data')
      .eq('id', notificationId)
      .maybeSingle();

    if (latest?.data?.push_sent_at) {
      return res.json({ success: true, deduped: true });
    }

    // 2) send push with Firebase Admin
    const admin = getFirebaseAdmin();

    const title = record.title || 'QNow';
    const body = record.message || '';

    // FCM data values must be strings in practice, so convert.
    const data = record.data || {};
    const stringData = Object.fromEntries(
      Object.entries(data).map(([k, v]) => [String(k), v == null ? '' : String(v)])
    );

    await admin.messaging().send({
      token: user.fcm_token,
      notification: { title, body },
      data: stringData,
    });

    // 3) mark as sent inside `data` (since your table has no status column)
    const updatedData = {
      ...(record.data || {}),
      delivery_status: 'sent',
      push_sent_at: new Date().toISOString(),
    };

    await supabaseService.from('notification').update({ data: updatedData }).eq('id', notificationId);

    return res.json({ success: true });
  } catch (e) {
    console.error('Webhook error:', e);
    return res.status(500).json({ success: false, error: e.message });
  }
});

module.exports = router;
