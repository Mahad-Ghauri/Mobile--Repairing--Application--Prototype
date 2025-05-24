import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'repairo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users Table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        phone TEXT,
        role TEXT
      )
    ''');

    // Repair Shops Table
    await db.execute('''
      CREATE TABLE repair_shops (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        location TEXT,
        rating REAL,
        services TEXT
      )
    ''');

    // Appointments Table
    await db.execute('''
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        shop_id INTEGER,
        issue TEXT,
        date TEXT,
        time TEXT,
        image_path TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (shop_id) REFERENCES repair_shops(id)
      )
    ''');

    // FixHub Questions Table
    await db.execute('''
      CREATE TABLE fixhub_questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        title TEXT,
        description TEXT,
        tag TEXT,
        upvotes INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    // FixHub Answers Table
    await db.execute('''
      CREATE TABLE fixhub_answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER,
        user_id INTEGER,
        content TEXT,
        FOREIGN KEY (question_id) REFERENCES fixhub_questions(id),
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');

    // Insert some initial data
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    // Insert sample repair shops
    await db.insert('repair_shops', {
      'name': 'TechFix Pro',
      'location': '123 Main St',
      'rating': 4.5,
      'services': 'Screen Repair,Battery Replacement,Water Damage'
    });

    await db.insert('repair_shops', {
      'name': 'Mobile Masters',
      'location': '456 Oak Ave',
      'rating': 4.8,
      'services': 'Screen Repair,Software Issues,Charging Port'
    });
  }

  // User Operations
  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return maps.isNotEmpty ? maps.first : null;
  }

  // Repair Shop Operations
  Future<List<Map<String, dynamic>>> getRepairShops() async {
    final db = await database;
    return await db.query('repair_shops');
  }

  // Appointment Operations
  Future<int> createAppointment(Map<String, dynamic> appointment) async {
    final db = await database;
    return await db.insert('appointments', appointment);
  }

  Future<List<Map<String, dynamic>>> getUserAppointments(int userId) async {
    final db = await database;
    return await db.query(
      'appointments',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // FixHub Operations
  Future<int> createQuestion(Map<String, dynamic> question) async {
    final db = await database;
    return await db.insert('fixhub_questions', question);
  }

  Future<List<Map<String, dynamic>>> getQuestions() async {
    final db = await database;
    return await db.query('fixhub_questions', orderBy: 'id DESC');
  }

  Future<int> createAnswer(Map<String, dynamic> answer) async {
    final db = await database;
    return await db.insert('fixhub_answers', answer);
  }

  Future<List<Map<String, dynamic>>> getAnswersForQuestion(
      int questionId) async {
    final db = await database;
    return await db.query(
      'fixhub_answers',
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  Future<void> updateQuestionUpvotes(int questionId, int upvotes) async {
    final db = await database;
    await db.update(
      'fixhub_questions',
      {'upvotes': upvotes},
      where: 'id = ?',
      whereArgs: [questionId],
    );
  }
}
