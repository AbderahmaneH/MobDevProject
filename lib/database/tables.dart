// ==============================
// DATABASE TABLES & MODELS
// ==============================

// User Model
class User {
  final int id;
  final String name;
  final String? email;
  final String phone;
  final String password;
  final bool isBusiness;
  final DateTime createdAt;
  String? businessName;
  String? businessType;
  String? businessAddress;

  User({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    required this.password,
    required this.isBusiness,
    required this.createdAt,
    this.businessName,
    this.businessType,
    this.businessAddress,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'is_business': isBusiness ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
      'business_name': businessName,
      'business_type': businessType,
      'business_address': businessAddress,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      isBusiness: map['is_business'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      businessName: map['business_name'],
      businessType: map['business_type'],
      businessAddress: map['business_address'],
    );
  }
}

// Queue Model
class Queue {
  final int id;
  final int businessOwnerId;
  final String name;
  final String? description;
  final int maxSize;
  final int estimatedWaitTime;
  final bool isActive;
  final DateTime createdAt;
  List<QueueClient> clients;

  Queue({
    required this.id,
    required this.businessOwnerId,
    required this.name,
    this.description,
    this.maxSize = 50,
    this.estimatedWaitTime = 5,
    this.isActive = true,
    required this.createdAt,
    this.clients = const [],
  });

  int get currentSize => clients.length;
  int get waitingCount => clients.where((c) => c.status == 'waiting').length;
  int get servedCount => clients.where((c) => c.status == 'served').length;
  int get notifiedCount => clients.where((c) => c.status == 'notified').length;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'business_owner_id': businessOwnerId,
      'name': name,
      'description': description,
      'max_size': maxSize,
      'estimated_wait_time': estimatedWaitTime,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Queue.fromMap(Map<String, dynamic> map) {
    return Queue(
      id: map['id'],
      businessOwnerId: map['business_owner_id'],
      name: map['name'],
      description: map['description'],
      maxSize: map['max_size'],
      estimatedWaitTime: map['estimated_wait_time'],
      isActive: map['is_active'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      clients: [],
    );
  }
}

// Queue Client Model
class QueueClient {
  final int? id;
  final int queueId;
  final int userId;
  final String name;
  final String phone;
  final int position;
  final String status;
  final DateTime joinedAt;
  final DateTime? servedAt;
  final DateTime? notifiedAt;

  QueueClient({
    this.id,
    required this.queueId,
    required this.userId,
    required this.name,
    required this.phone,
    required this.position,
    required this.status,
    required this.joinedAt,
    this.servedAt,
    this.notifiedAt,
  });

  bool get served => status == 'served';
  bool get notified => status == 'notified';
  bool get waiting => status == 'waiting';
  bool get cancelled => status == 'cancelled';

  Map<String, dynamic> toMap() {
    return {
      'queue_id': queueId,
      'user_id': userId,
      'name': name,
      'phone': phone,
      'position': position,
      'status': status,
      'joined_at': joinedAt.millisecondsSinceEpoch,
      'served_at': servedAt?.millisecondsSinceEpoch,
      'notified_at': notifiedAt?.millisecondsSinceEpoch,
      if(id != null) 'id': id,
    };
  }

  factory QueueClient.fromMap(Map<String, dynamic> map) {
    return QueueClient(
      id: map['id'],
      queueId: map['queue_id'],
      userId: map['user_id'],
      name: map['name'],
      phone: map['phone'],
      position: map['position'],
      status: map['status'],
      joinedAt: DateTime.fromMillisecondsSinceEpoch(map['joined_at']),
      servedAt: map['served_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['served_at'])
          : null,
      notifiedAt: map['notified_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['notified_at'])
          : null,
    );
  }
}

// Database Table Names
class DatabaseTables {
  static const String users = 'users';
  static const String queues = 'queues';
  static const String queueClients = 'queue_clients';
  
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
  
  static const List<String> createTableQueries = [
    createUsersTable,
    createQueuesTable,
    createQueueClientsTable,
  ];
}

// Database Indexes
class DatabaseIndexes {
  static const String usersPhoneIndex = 'CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone)';
  static const String queuesBusinessOwnerIndex = 'CREATE INDEX IF NOT EXISTS idx_queues_business_owner ON queues(business_owner_id)';
  static const String queueClientsQueueIndex = 'CREATE INDEX IF NOT EXISTS idx_queue_clients_queue ON queue_clients(queue_id)';
  static const String queueClientsUserIndex = 'CREATE INDEX IF NOT EXISTS idx_queue_clients_user ON queue_clients(user_id)';
  static const String queueClientsStatusIndex = 'CREATE INDEX IF NOT EXISTS idx_queue_clients_status ON queue_clients(status)';
  
  static const List<String> createIndexQueries = [
    usersPhoneIndex,
    queuesBusinessOwnerIndex,
    queueClientsQueueIndex,
    queueClientsUserIndex,
    queueClientsStatusIndex,
  ];
}