# Queue Notification System - Implementation Guide

## Overview
This notification system is built using **Supabase Realtime** for instant notifications and **Local Notifications** for in-app alerts. The system allows business owners to notify clients when it's their turn in the queue.

## Features
- ✅ **Real-time Notifications** via Supabase Realtime
- ✅ **Local Push Notifications** on device
- ✅ **Notification History** stored in Supabase
- ✅ **Turn Notifications** - Alert clients when it's their turn
- ✅ **Approaching Turn Notifications** - Warn clients when they're close
- ✅ **Queue Join Notifications** - Confirm when clients join a queue

## How It Works

### 1. Database Schema
The system uses a new `notifications` table in your Supabase database:

```sql
CREATE TABLE notifications (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL,
  data JSONB,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  read_at TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
```

### 2. Setup Instructions

#### Step 1: Update Supabase Database
Run this SQL in your Supabase SQL Editor to create the notifications table:

```sql
-- Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL,
  data JSONB,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  read_at TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);

-- Enable Row Level Security
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Create policies so users can only see their own notifications
CREATE POLICY "Users can view own notifications" ON notifications
  FOR SELECT USING (auth.uid()::text::integer = user_id);

CREATE POLICY "Users can update own notifications" ON notifications
  FOR UPDATE USING (auth.uid()::text::integer = user_id);

-- Enable Realtime for the notifications table
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
```

#### Step 2: Install Flutter Dependencies
The required packages are already added to `pubspec.yaml`. Run:

```bash
flutter pub get
```

#### Step 3: Configure Android (for Local Notifications)
Add the following to `android/app/src/main/AndroidManifest.xml` inside the `<application>` tag:

```xml
<manifest>
  <application>
    <!-- Add these lines -->
    <meta-data
      android:name="com.google.firebase.messaging.default_notification_channel_id"
      android:value="queue_notifications" />
  </application>
  
  <!-- Add permission for notifications -->
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
  <uses-permission android:name="android.permission.VIBRATE"/>
</manifest>
```

#### Step 4: Configure iOS (for Local Notifications)
No additional configuration needed for basic local notifications.

#### Step 5: Enable Realtime in Supabase Dashboard
1. Go to your Supabase project dashboard
2. Navigate to **Database** > **Replication**
3. Enable Realtime for the `notifications` table

### 3. Usage

#### For Business Owners - Notify a Client
When a business owner wants to notify a client that it's their turn:

```dart
// In your business queue management screen
await context.read<QueueCubit>().notifyClient(clientId);
```

This will:
1. Send a notification to the Supabase `notifications` table
2. Trigger a Realtime event to the client's device
3. Show a local notification on the client's device
4. Update the client's status to "notified"

#### For Clients - Receive Notifications
Clients automatically receive notifications when:
1. They log in (subscription is set up automatically)
2. A business owner notifies them
3. The app is in foreground or background

### 4. Notification Types

#### Turn Notification
```dart
await notificationService.notifyClientAboutTurn(
  userId: clientId,
  clientName: 'John Doe',
  phoneNumber: '+1234567890',
  queueName: 'General Queue',
  position: 1,
);
```

#### Approaching Turn Notification  
```dart
await notificationService.notifyClientApproachingTurn(
  userId: clientId,
  clientName: 'John Doe',
  queueName: 'General Queue',
  position: 3,
  peopleAhead: 2,
);
```

#### Queue Join Notification
```dart
await notificationService.notifyClientJoinedQueue(
  userId: clientId,
  clientName: 'John Doe',
  queueName: 'General Queue',
  position: 5,
  estimatedWaitTime: 10, // minutes per person
);
```

### 5. Testing Notifications

#### Test Local Notifications
```dart
await NotificationService().showLocalNotification(
  id: 1,
  title: 'Test Notification',
  body: 'This is a test notification',
);
```

#### Test Realtime Notifications
1. Log in as a client on one device/emulator
2. Log in as a business owner on another device/emulator
3. Add the client to a queue
4. Click "Notify" button next to the client
5. The client should receive a notification

### 6. Troubleshooting

#### Notifications Not Appearing
1. **Check permissions**: Make sure notification permissions are granted
2. **Check Supabase Realtime**: Verify Realtime is enabled for `notifications` table
3. **Check user subscription**: Ensure user is logged in and subscription is active
4. **Check logs**: Look for error messages in the console

#### Realtime Not Working
1. Enable Realtime in Supabase Dashboard
2. Check your RLS policies allow reading notifications
3. Verify the `notifications` table is added to publication

#### Permission Issues
```dart
// Check permission status
final status = await Permission.notification.status;
print('Notification permission: $status');

// Request permission
if (status.isDenied) {
  await Permission.notification.request();
}
```

### 7. Advanced Features (Optional)

#### Adding SMS Notifications
To add SMS notifications (using Twilio or similar):

1. Create a Supabase Edge Function:
```typescript
// supabase/functions/send-sms/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async (req) => {
  const { phone, message } = await req.json()
  
  // Call Twilio API
  const response = await fetch('https://api.twilio.com/2010-04-01/Accounts/YOUR_ACCOUNT_SID/Messages.json', {
    method: 'POST',
    headers: {
      'Authorization': 'Basic ' + btoa('YOUR_ACCOUNT_SID:YOUR_AUTH_TOKEN'),
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams({
      To: phone,
      From: 'YOUR_TWILIO_NUMBER',
      Body: message,
    }),
  })
  
  return new Response(JSON.stringify({ success: true }), {
    headers: { 'Content-Type': 'application/json' },
  })
})
```

2. Update the notification service to call your Edge Function

#### Adding Email Notifications
Use Supabase Auth's email functionality or create an Edge Function with SendGrid/Mailgun.

### 8. Best Practices

1. **Rate Limiting**: Don't spam users with too many notifications
2. **Quiet Hours**: Consider implementing quiet hours (no notifications late at night)
3. **Notification Preferences**: Let users choose notification types they want
4. **Clear Messages**: Make notification messages clear and actionable
5. **Test Thoroughly**: Test on both Android and iOS devices

### 9. API Reference

#### NotificationService Methods

- `initialize({int? userId})` - Initialize the service
- `subscribeToUserNotifications(int userId)` - Subscribe to realtime notifications
- `notifyClientAboutTurn({...})` - Notify client it's their turn
- `notifyClientApproachingTurn({...})` - Notify client they're coming up
- `notifyClientJoinedQueue({...})` - Confirm queue joining
- `showLocalNotification({...})` - Show local notification
- `markAsRead(int notificationId)` - Mark notification as read
- `getUnreadCount(int userId)` - Get unread notification count
- `getNotifications(int userId)` - Get all notifications

## Support

If you need help:
1. Check the troubleshooting section above
2. Review Supabase Realtime documentation
3. Check Flutter local notifications documentation
4. Review your Supabase dashboard logs

## Notes

- This implementation uses **Supabase only** (no Firebase)
- Local notifications work even when the app is closed
- Realtime notifications require an internet connection
- Notifications are stored in your Supabase database for history
