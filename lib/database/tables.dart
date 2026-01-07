class DatabaseTables {
  static const String users = 'users';
  static const String queues = 'queues';
  static const String queueClients = 'queue_clients';
  static const String manualCustomers = 'manual_customers';

  static const String createUsersTable = '''
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT,
      phone TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      is_business INTEGER NOT NULL DEFAULT 0,
      created_at INTEGER NOT NULL,
      business_name TEXT,
      business_type TEXT,
      business_address TEXT
    )
  ''';

  static const String createQueuesTable = '''
    CREATE TABLE IF NOT EXISTS queues (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      business_owner_id INTEGER NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      max_size INTEGER DEFAULT 50,
      estimated_wait_time INTEGER DEFAULT 5,
      is_active INTEGER DEFAULT 1,
      created_at INTEGER NOT NULL,
      FOREIGN KEY (business_owner_id) REFERENCES users (id) ON DELETE CASCADE
    )
  ''';

  static const String createQueueClientsTable = '''
    CREATE TABLE IF NOT EXISTS queue_clients (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      queue_id INTEGER NOT NULL,
      user_id INTEGER NOT NULL,
      name TEXT NOT NULL,
      phone TEXT NOT NULL,
      position INTEGER NOT NULL,
      status TEXT DEFAULT 'waiting',
      joined_at INTEGER NOT NULL,
      served_at INTEGER,
      notified_at INTEGER,
      FOREIGN KEY (queue_id) REFERENCES queues (id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
      UNIQUE(queue_id, user_id)
    )
  ''';

    static const String createManualCustomersTable = '''
      CREATE TABLE IF NOT EXISTS manual_customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        queue_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        status TEXT DEFAULT 'waiting',
        FOREIGN KEY (queue_id) REFERENCES queues (id) ON DELETE CASCADE
      )
    ''';

  static const List<String> createTableQueries = [
    createUsersTable,
    createQueuesTable,
    createQueueClientsTable,
    createManualCustomersTable,
  ];
}

class DatabaseIndexes {
  static const String usersPhoneIndex =
      'CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone)';
  static const String queuesBusinessOwnerIndex =
      'CREATE INDEX IF NOT EXISTS idx_queues_business_owner ON queues(business_owner_id)';
  static const String queueClientsQueueIndex =
      'CREATE INDEX IF NOT EXISTS idx_queue_clients_queue ON queue_clients(queue_id)';
  static const String queueClientsUserIndex =
      'CREATE INDEX IF NOT EXISTS idx_queue_clients_user ON queue_clients(user_id)';
  static const String queueClientsStatusIndex =
      'CREATE INDEX IF NOT EXISTS idx_queue_clients_status ON queue_clients(status)';

    static const String manualCustomersQueueIndex =
      'CREATE INDEX IF NOT EXISTS idx_manual_customers_queue ON manual_customers(queue_id)';

  static const List<String> createIndexQueries = [
    usersPhoneIndex,
    queuesBusinessOwnerIndex,
    queueClientsQueueIndex,
    queueClientsUserIndex,
    queueClientsStatusIndex,
    manualCustomersQueueIndex,
  ];
}
