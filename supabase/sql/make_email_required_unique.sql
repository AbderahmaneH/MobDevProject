-- Make email column NOT NULL and UNIQUE in users table
-- Run this migration in your Supabase SQL Editor

-- First, check if email column needs to be updated
DO $$ 
BEGIN
    -- Update any NULL email values to empty string (if needed for existing data)
    -- Comment this out if you want to enforce data cleaning first
    -- UPDATE users SET email = '' WHERE email IS NULL;
    
    -- Add NOT NULL constraint if it doesn't exist
    BEGIN
        ALTER TABLE users ALTER COLUMN email SET NOT NULL;
        RAISE NOTICE 'Set email column to NOT NULL';
    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'Email column already has NOT NULL constraint or contains NULL values';
    END;
END $$;

-- Add UNIQUE constraint on email if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'users_email_unique'
    ) THEN
        ALTER TABLE users ADD CONSTRAINT users_email_unique UNIQUE (email);
        RAISE NOTICE 'Added UNIQUE constraint on email column';
    ELSE
        RAISE NOTICE 'UNIQUE constraint on email already exists';
    END IF;
END $$;

-- Create index on email for faster lookups (if not already created by UNIQUE constraint)
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Verify constraints
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'users' AND column_name = 'email';

-- Verify unique constraint
SELECT constraint_name, constraint_type
FROM information_schema.table_constraints
WHERE table_name = 'users' AND constraint_name = 'users_email_unique';
