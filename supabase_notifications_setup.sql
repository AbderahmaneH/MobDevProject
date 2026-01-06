-- =====================================================
-- Queue Notification System - Supabase Setup Script
-- =====================================================
-- Run this SQL in your Supabase SQL Editor
-- Go to: Supabase Dashboard > SQL Editor > New Query
-- =====================================================

-- 1. Create notifications table
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

-- 2. Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);

-- 3. Enable Row Level Security (RLS)
-- Note: Since you're using custom authentication (not Supabase Auth),
-- we'll use permissive policies that allow all operations.
-- Security is handled at the application level.
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- 4. Create RLS policies
-- Policy: Allow all users to view all notifications
-- You can filter by user_id in your application queries
CREATE POLICY "Allow read access to notifications" 
  ON notifications
  FOR SELECT 
  USING (true);

-- Policy: Allow all users to insert notifications
CREATE POLICY "Allow insert notifications" 
  ON notifications
  FOR INSERT 
  WITH CHECK (true);

-- Policy: Allow all users to update notifications
CREATE POLICY "Allow update notifications" 
  ON notifications
  FOR UPDATE 
  USING (true);

-- Policy: Allow all users to delete notifications
CREATE POLICY "Allow delete notifications" 
  ON notifications
  FOR DELETE 
  USING (true);

-- 5. Enable Realtime for the notifications table
-- This allows clients to receive notifications in real-time
ALTER PUBLICATION supabase_realtime ADD TABLE notifications;

-- 6. (Optional) Create a function to auto-delete old read notifications
-- This keeps your database clean by removing notifications older than 30 days
CREATE OR REPLACE FUNCTION delete_old_notifications()
RETURNS void AS $$
BEGIN
  DELETE FROM notifications 
  WHERE is_read = true 
  AND read_at < NOW() - INTERVAL '30 days';
END;
$$ LANGUAGE plpgsql;

-- 7. (Optional) Create a scheduled job to clean up old notifications
-- Note: This requires pg_cron extension to be enabled
-- You can enable it in: Database > Extensions > search for "pg_cron"
-- Uncomment the following lines after enabling pg_cron:

-- SELECT cron.schedule(
--   'delete-old-notifications',
--   '0 2 * * *', -- Run at 2 AM every day
--   'SELECT delete_old_notifications();'
-- );

-- =====================================================
-- Verification Queries
-- =====================================================
-- Run these to verify the setup is correct

-- Check if notifications table was created
SELECT EXISTS (
  SELECT FROM information_schema.tables 
  WHERE table_schema = 'public' 
  AND table_name = 'notifications'
) AS table_exists;

-- Check if indexes were created
SELECT indexname 
FROM pg_indexes 
WHERE tablename = 'notifications';

-- Check if RLS is enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'notifications';

-- Check if Realtime is enabled
SELECT * 
FROM pg_publication_tables 
WHERE pubname = 'supabase_realtime' 
AND tablename = 'notifications';

-- =====================================================
-- Test Data (Optional - for testing)
-- =====================================================
-- Uncomment to insert a test notification
-- Replace '1' with an actual user_id from your users table

-- INSERT INTO notifications (user_id, title, message, type, data)
-- VALUES (
--   1,
--   'Test Notification',
--   'This is a test notification to verify the system is working',
--   'test',
--   '{"test": true}'::jsonb
-- );

-- =====================================================
-- Additional Notes
-- =====================================================
-- After running this script:
-- 1. Go to Database > Replication in Supabase Dashboard
-- 2. Make sure "notifications" table is checked for Realtime
-- 3. Test by running your Flutter app and logging in
-- 4. Create a queue and notify a client
-- =====================================================
