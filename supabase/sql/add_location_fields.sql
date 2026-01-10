-- Supabase Migration: Add Location Fields to Users Table
-- Run this SQL in your Supabase SQL Editor

-- Add new columns to the users table for storing location data
ALTER TABLE users
ADD COLUMN IF NOT EXISTS latitude REAL,
ADD COLUMN IF NOT EXISTS longitude REAL,
ADD COLUMN IF NOT EXISTS area TEXT,
ADD COLUMN IF NOT EXISTS city TEXT,
ADD COLUMN IF NOT EXISTS state TEXT,
ADD COLUMN IF NOT EXISTS pincode TEXT,
ADD COLUMN IF NOT EXISTS landmark TEXT;

-- Optional: Add an index on latitude and longitude for better query performance
-- if you plan to do location-based searches
CREATE INDEX IF NOT EXISTS idx_users_location ON users(latitude, longitude);

-- Optional: Add a comment to document the purpose of these columns
COMMENT ON COLUMN users.latitude IS 'Geographic latitude coordinate of business location';
COMMENT ON COLUMN users.longitude IS 'Geographic longitude coordinate of business location';
COMMENT ON COLUMN users.area IS 'Area or locality of business address';
COMMENT ON COLUMN users.city IS 'City of business address';
COMMENT ON COLUMN users.state IS 'State/Province of business address';
COMMENT ON COLUMN users.pincode IS 'Postal/ZIP code of business address';
COMMENT ON COLUMN users.landmark IS 'Nearby landmark for business location';
