import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'tables.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'qnow.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create all tables
    for (final query in DatabaseTables.createTableQueries) {
      await db.execute(query);
    }

    // Create all indexes
    for (final query in DatabaseIndexes.createIndexQueries) {
      await db.execute(query);
    }

    // Insert dummy data for testing
    await _insertDummyData(db);
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  // ==============================
  // USER OPERATIONS
  // ==============================

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(
      DatabaseTables.users,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUserById(int id) async {
    final db = await database;
    final maps = await db.query(
      DatabaseTables.users,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByPhone(String phone) async {
    final db = await database;
    final maps = await db.query(
      DatabaseTables.users,
      where: 'phone = ?',
      whereArgs: [phone],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> isPhoneRegistered(String phone) async {
    final db = await database;
    final maps = await db.query(
      DatabaseTables.users,
      where: 'phone = ?',
      whereArgs: [phone],
    );
    return maps.isNotEmpty;
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final maps = await db.query(DatabaseTables.users);
    return maps.map((map) => User.fromMap(map)).toList();
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      DatabaseTables.users,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      DatabaseTables.users,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==============================
  // QUEUE OPERATIONS
  // ==============================

  Future<int> insertQueue(Queue queue) async {
    final db = await database;
    return await db.insert(
      DatabaseTables.queues,
      queue.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Queue?> getQueueById(int id) async {
    final db = await database;
    final maps = await db.query(
      DatabaseTables.queues,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      final queue = Queue.fromMap(maps.first);
      queue.clients = await getQueueClients(id);
      return queue;
    }
    return null;
  }

  Future<List<Queue>> getQueuesByBusinessOwner(int businessOwnerId) async {
    final db = await database;
    final maps = await db.query(
      DatabaseTables.queues,
      where: 'business_owner_id = ?',
      whereArgs: [businessOwnerId],
    );

    final queues = maps.map((map) => Queue.fromMap(map)).toList();

    // Load clients for each queue
    for (final queue in queues) {
      queue.clients = await getQueueClients(queue.id);
    }

    return queues;
  }

  Future<List<Queue>> getAllQueues({bool activeOnly = true}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;

    if (activeOnly) {
      maps = await db.query(DatabaseTables.queues, where: 'is_active = 1');
    } else {
      maps = await db.query(DatabaseTables.queues);
    }

    final queues = maps.map((map) => Queue.fromMap(map)).toList();

    // Load clients for each queue
    for (final queue in queues) {
      queue.clients = await getQueueClients(queue.id);
    }

    return queues;
  }

  Future<List<Queue>> searchQueues(String query) async {
    final db = await database;
    final maps = await db.query(
      DatabaseTables.queues,
      where: 'name LIKE ? AND is_active = 1',
      whereArgs: ['%$query%'],
    );

    final queues = maps.map((map) => Queue.fromMap(map)).toList();

    // Load clients for each queue
    for (final queue in queues) {
      queue.clients = await getQueueClients(queue.id);
    }

    return queues;
  }

  Future<int> updateQueue(Queue queue) async {
    final db = await database;
    return await db.update(
      DatabaseTables.queues,
      queue.toMap(),
      where: 'id = ?',
      whereArgs: [queue.id],
    );
  }

  Future<int> deleteQueue(int id) async {
    final db = await database;
    return await db.delete(
      DatabaseTables.queues,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==============================
  // QUEUE CLIENT OPERATIONS
  // ==============================

  Future<int> insertQueueClient(QueueClient client) async {
    final db = await database;
    return await db.insert(
      DatabaseTables.queueClients,
      client.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<QueueClient>> getQueueClients(int queueId) async {
    final db = await database;
    final maps = await db.query(
      DatabaseTables.queueClients,
      where: 'queue_id = ?',
      whereArgs: [queueId],
      orderBy: 'position ASC',
    );
    return maps.map((map) => QueueClient.fromMap(map)).toList();
  }

  Future<List<Queue>> getQueuesByUser(int userId) async {
    final db = await database;

    // Get all queue IDs where user is a client
    final clientMaps = await db.query(
      DatabaseTables.queueClients,
      columns: ['queue_id'],
      where: 'user_id = ? AND status != ?',
      whereArgs: [userId, 'served'],
      distinct: true,
    );

    final queueIds = clientMaps.map((map) => map['queue_id'] as int).toList();

    if (queueIds.isEmpty) return [];

    // Get all queues where user is a client
    final queueMaps = await db.query(
      DatabaseTables.queues,
      where: 'id IN (${queueIds.map((_) => '?').join(',')})',
      whereArgs: queueIds,
    );

    final queues = queueMaps.map((map) => Queue.fromMap(map)).toList();

    // Load clients for each queue
    for (final queue in queues) {
      queue.clients = await getQueueClients(queue.id);
    }

    return queues;
  }

  Future<int> getActiveQueuesCountForUser(int userId) async {
    final db = await database;
    final maps = await db.rawQuery(
      '''
      SELECT COUNT(DISTINCT queue_id) as cnt
      FROM ${DatabaseTables.queueClients}
      WHERE user_id = ? AND status != ?
      ''',
      [userId, 'served'],
    );

    final cnt = maps.first['cnt'];
    if (cnt is int) return cnt;
    if (cnt is int?) return cnt ?? 0;
    return int.tryParse(cnt.toString()) ?? 0;
  }

  Future<QueueClient?> getQueueClient(int queueId, int userId) async {
    final db = await database;
    final maps = await db.query(
      DatabaseTables.queueClients,
      where: 'queue_id = ? AND user_id = ?',
      whereArgs: [queueId, userId],
    );
    if (maps.isNotEmpty) {
      return QueueClient.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateQueueClient(QueueClient client) async {
    final db = await database;
    return await db.update(
      DatabaseTables.queueClients,
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  Future<int> deleteQueueClient(int? id) async {
    final db = await database;
    return await db.delete(
      DatabaseTables.queueClients,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> getNextPosition(int queueId) async {
    final db = await database;
    final maps = await db.rawQuery(
      '''
      SELECT MAX(position) as max_position 
      FROM ${DatabaseTables.queueClients} 
      WHERE queue_id = ?
    ''',
      [queueId],
    );

    final maxPosition = maps.first['max_position'];
    return (maxPosition as int? ?? 0) + 1;
  }

  Future<void> updateClientStatus(int? clientId, String status) async {
    final db = await database;
    final now = DateTime.now().millisecondsSinceEpoch;

    Map<String, dynamic> updates = {'status': status};

    if (status == 'served') {
      updates['served_at'] = now;
    } else if (status == 'notified') {
      updates['notified_at'] = now;
    }

    await db.update(
      DatabaseTables.queueClients,
      updates,
      where: 'id = ?',
      whereArgs: [clientId],
    );
  }

  Future<void> reorderPositions(int queueId) async {
    final db = await database;
    final clients = await getQueueClients(queueId);

    for (int i = 0; i < clients.length; i++) {
      await db.update(
        DatabaseTables.queueClients,
        {'position': i + 1},
        where: 'id = ?',
        whereArgs: [clients[i].id],
      );
    }
  }

  // ==============================
  // DUMMY DATA INSERTION
  // ==============================

  Future<void> _insertDummyData(Database db) async {
    // Insert dummy users
    await db.insert(DatabaseTables.users, {
      'id': 1,
      'name': 'Wassim Customer',
      'email': 'wassim@example.com',
      'phone': '0501111111',
      'password': '123456',
      'is_business': 0,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });

    await db.insert(DatabaseTables.users, {
      'id': 10,
      'name': 'Abderrahmane',
      'phone': '0500000001',
      'password': '123456',
      'is_business': 0,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });

    await db.insert(DatabaseTables.users, {
      'id': 2,
      'name': 'Mohamed Business',
      'email': 'business@example.com',
      'phone': '0502222222',
      'password': 'password123',
      'is_business': 1,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'business_name': 'Super Store',
      'business_type': 'Retail',
      'business_address': '123 Main St',
    });

    // Insert dummy queues
    await db.insert(DatabaseTables.queues, {
      'id': 1,
      'business_owner_id': 2,
      'name': 'Testing Queue 1',
      'description': 'Main checkout counter',
      'max_size': 20,
      'estimated_wait_time': 5,
      'is_active': 1,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });

    await db.insert(DatabaseTables.queues, {
      'id': 2,
      'business_owner_id': 2,
      'name': 'Testing Queue 2',
      'description': 'Returns and inquiries',
      'max_size': 10,
      'estimated_wait_time': 10,
      'is_active': 1,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // ==============================
  // DATABASE MAINTENANCE
  // ==============================

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete(DatabaseTables.queueClients);
    await db.delete(DatabaseTables.queues);
    await db.delete(DatabaseTables.users);
  }

  Future<void> resetDatabase() async {
    final db = await database;
    await db.close();
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'qnow.db');
    await deleteDatabase(path);
    _database = null;
    await database; // Reinitialize database
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
