// Dummy data moved to SQL snippets for Supabase migration.
const sampleDataSql = '''
-- Users
INSERT INTO users (id, name, phone, password, is_business, created_at) VALUES
(0, 'Abderrahmane', '0500000000', '123456', 0, extract(epoch from now()) * 1000),
(1, 'Wassim Customer', '0500000001', '123456', 0, extract(epoch from now()) * 1000);

-- Business owners and more users can be added similarly.

-- Queues
INSERT INTO queues (id, business_owner_id, name, description, max_size, estimated_wait_time, is_active, created_at) VALUES
(1, 5, 'Testing Queue 1', 'Main checkout counter', 20, 5, 1, extract(epoch from now()) * 1000);

''';

// Run these SQL statements in the Supabase SQL editor or via psql to insert sample data.
