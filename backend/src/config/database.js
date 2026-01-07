const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

// Supabase configuration
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
  console.error('Error: SUPABASE_URL and SUPABASE_ANON_KEY must be set in .env file');
  process.exit(-1);
}

// Create Supabase client
const supabase = createClient(supabaseUrl, supabaseKey);

console.log('Supabase client initialized successfully');

module.exports = supabase;
