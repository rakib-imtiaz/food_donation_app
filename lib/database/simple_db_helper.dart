import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SimpleDbHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  static Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'foodshare.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE donations(
            id TEXT PRIMARY KEY,
            foodName TEXT,
            description TEXT,
            quantity INTEGER,
            location TEXT,
            pickupTime TEXT
          )
        ''');
      },
    );
  }

  // Simple CRUD operations
  static Future<int> insertDonation(Map<String, dynamic> donation) async {
    Database dbClient = await db;
    return await dbClient.insert('donations', donation);
  }

  static Future<List<Map<String, dynamic>>> getDonations() async {
    Database dbClient = await db;
    return await dbClient.query('donations');
  }

  static Future<int> deleteDonation(String id) async {
    Database dbClient = await db;
    return await dbClient.delete('donations', where: 'id = ?', whereArgs: [id]);
  }
} 