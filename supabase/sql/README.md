# Database Migrations

This directory contains SQL migration files for the Supabase database.

## Running Migrations

To run a migration:
1. Log in to your Supabase Dashboard
2. Navigate to SQL Editor
3. Copy and paste the SQL content from the migration file
4. Execute the SQL

## Migration Files

### 1. `add_reset_token_columns.sql`
Adds password reset functionality to the users table.
- Adds `reset_token` column (TEXT)
- Adds `reset_token_expiry` column (BIGINT)
- Creates index on `reset_token` for faster lookups

### 2. `make_email_required_unique.sql`
**IMPORTANT: Run this migration to enable email login support**

This migration enforces email uniqueness and makes it required:
- Makes `email` column NOT NULL
- Adds UNIQUE constraint on `email` column
- Creates index on `email` for faster lookups

**Before running this migration:**
- Ensure all existing users have valid email addresses
- Update any NULL or empty email values in the database

**To verify existing data:**
```sql
-- Check for NULL or empty emails
SELECT id, name, phone, email 
FROM users 
WHERE email IS NULL OR email = '';
```

**To fix NULL emails (if needed):**
```sql
-- Option 1: Generate email from phone number (temporary)
UPDATE users 
SET email = phone || '@temp.local' 
WHERE email IS NULL OR email = '';

-- Option 2: Set a default email for testing
UPDATE users 
SET email = 'user_' || id || '@example.com' 
WHERE email IS NULL OR email = '';
```

## Notes

- Always backup your database before running migrations
- Test migrations in a development environment first
- Check the output messages after running each migration
- The migrations are idempotent - safe to run multiple times
