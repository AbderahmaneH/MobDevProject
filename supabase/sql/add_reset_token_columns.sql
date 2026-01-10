-- Add password reset token columns to users table
-- Run this migration in your Supabase SQL Editor

-- First, check if columns exist
DO $$ 
BEGIN
    -- Add reset_token column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'reset_token'
    ) THEN
        ALTER TABLE users ADD COLUMN reset_token TEXT;
        RAISE NOTICE 'Added reset_token column';
    ELSE
        RAISE NOTICE 'reset_token column already exists';
    END IF;

    -- Add reset_token_expiry column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'reset_token_expiry'
    ) THEN
        ALTER TABLE users ADD COLUMN reset_token_expiry BIGINT;
        RAISE NOTICE 'Added reset_token_expiry column';
    ELSE
        RAISE NOTICE 'reset_token_expiry column already exists';
    END IF;
END $$;

-- Create index on reset_token for faster lookups
CREATE INDEX IF NOT EXISTS idx_users_reset_token ON users(reset_token);

-- Verify columns were created
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'users' 
AND column_name IN ('reset_token', 'reset_token_expiry');

-- Test update (this should work without errors)
-- Uncomment to test with a real user ID
-- UPDATE users SET reset_token = 'test123', reset_token_expiry = 9999999999999 WHERE id = 'your-user-id-here';
