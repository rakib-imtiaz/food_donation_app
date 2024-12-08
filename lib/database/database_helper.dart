import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('foodshare.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        isDonor INTEGER NOT NULL,
        location TEXT
      )
    ''');

    // Donations table
    await db.execute('''
      CREATE TABLE donations (
        id TEXT PRIMARY KEY,
        donorId TEXT NOT NULL,
        foodName TEXT NOT NULL,
        description TEXT,
        quantity INTEGER NOT NULL,
        location TEXT NOT NULL,
        pickupTime TEXT NOT NULL,
        isClaimed INTEGER NOT NULL,
        claimedBy TEXT,
        FOREIGN KEY (donorId) REFERENCES users (id),
        FOREIGN KEY (claimedBy) REFERENCES users (id)
      )
    ''');
  }

  // CRUD operations for Users
  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.insert('users', user);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await instance.database;
    return await db.query('users');
  }

  Future<Map<String, dynamic>?> getUser(String id) async {
    final db = await instance.database;
    final results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  // CRUD operations for Donations
  Future<int> createDonation(Map<String, dynamic> donation) async {
    final db = await instance.database;
    return await db.insert('donations', donation);
  }

  Future<List<Map<String, dynamic>>> getAllDonations() async {
    final db = await instance.database;
    return await db.query('donations');
  }

  Future<List<Map<String, dynamic>>> getUserDonations(String userId) async {
    final db = await instance.database;
    return await db.query(
      'donations',
      where: 'donorId = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateDonation(Map<String, dynamic> donation) async {
    final db = await instance.database;
    return await db.update(
      'donations',
      donation,
      where: 'id = ?',
      whereArgs: [donation['id']],
    );
  }

  Future<int> deleteDonation(String id) async {
    final db = await instance.database;
    return await db.delete(
      'donations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
} 