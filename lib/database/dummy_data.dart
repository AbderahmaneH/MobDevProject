import 'package:sqflite/sqflite.dart';
import 'tables.dart';

Future<void> insertDummyData(Database db) async {
  // Insert dummy users
  await db.insert(DatabaseTables.users, {
    'id': 0,
    'name': 'Abderrahmane',
    'phone': '0500000000',
    'password': '123456',
    'is_business': 0,
    'created_at': DateTime.now().millisecondsSinceEpoch,
  });
  await db.insert(DatabaseTables.users, {
    'id': 1,
    'name': 'Wassim Customer',
    'email': 'wassim@example.com',
    'phone': '0500000001',
    'password': '123456',
    'is_business': 0,
    'created_at': DateTime.now().millisecondsSinceEpoch,
  });
  await db.insert(DatabaseTables.users, {
    'id': 2,
    'name': 'ohamed Customer',
    'email': 'wassim@example.com',
    'phone': '0500000002',
    'password': '123456',
    'is_business': 0,
    'created_at': DateTime.now().millisecondsSinceEpoch,
  });
  await db.insert(DatabaseTables.users, {
    'id': 3,
    'name': 'Hassane Customer',
    'email': 'wassim@example.com',
    'phone': '0500000003',
    'password': '123456',
    'is_business': 0,
    'created_at': DateTime.now().millisecondsSinceEpoch,
  });
  await db.insert(DatabaseTables.users, {
    'id': 4,
    'name': 'Kadirou Customer',
    'email': 'wassim@example.com',
    'phone': '0500000004',
    'password': '123456',
    'is_business': 0,
    'created_at': DateTime.now().millisecondsSinceEpoch,
  });
  // Insert dummy business owners
  await db.insert(DatabaseTables.users, {
    'id': 5,
    'name': 'Mohamed Business',
    'email': 'business@example.com',
    'phone': '0600000000',
    'password': '123456',
    'is_business': 1,
    'created_at': DateTime.now().millisecondsSinceEpoch,
    'business_name': 'Super Store',
    'business_type': 'Retail',
    'business_address': '123 Main St',
  });
  await db.insert(DatabaseTables.users, {
    'id': 6,
    'name': 'Aghiles Food',
    'email': 'business2@example.com',
    'phone': '0600000001',
    'password': '123456',
    'is_business': 1,
    'created_at': DateTime.now().millisecondsSinceEpoch,
    'business_name': 'Super Store',
    'business_type': 'Retail',
    'business_address': '123 Main St',
  });
  await db.insert(DatabaseTables.users, {
    'id': 7,
    'name': 'Barber Shop',
    'email': 'business@example.com',
    'phone': '0600000002',
    'password': '123456',
    'is_business': 1,
    'created_at': DateTime.now().millisecondsSinceEpoch,
    'business_name': 'Super Store',
    'business_type': 'Retail',
    'business_address': '123 Main St',
  });

  // Insert dummy queues
  await db.insert(DatabaseTables.queues, {
    'id': 1,
    'business_owner_id': 5,
    'name': 'Testing Queue 1',
    'description': 'Main checkout counter',
    'max_size': 20,
    'estimated_wait_time': 5,
    'is_active': 1,
    'created_at': DateTime.now().millisecondsSinceEpoch,
  });
  await db.insert(DatabaseTables.queues, {
    'id': 2,
    'business_owner_id': 6,
    'name': 'Testing Queue 2',
    'description': 'Returns and inquiries',
    'max_size': 10,
    'estimated_wait_time': 10,
    'is_active': 1,
    'created_at': DateTime.now().millisecondsSinceEpoch,
  });
  await db.insert(DatabaseTables.queues, {
    'id': 3,
    'business_owner_id': 7,
    'name': 'Testing Queue 3',
    'description': 'Barber',
    'max_size': 20,
    'estimated_wait_time': 5,
    'is_active': 1,
    'created_at': DateTime.now().millisecondsSinceEpoch,
  });
}
