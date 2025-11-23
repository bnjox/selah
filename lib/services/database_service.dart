import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/prayer_topic.dart';
import '../models/session.dart';
import '../models/app_settings.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'selah.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // prayer_topics
    await db.execute('''
      CREATE TABLE prayer_topics (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT,
        isDefault INTEGER DEFAULT 0,
        createdAt INTEGER NOT NULL
      )
    ''');

    // sessions
    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        totalDurationSeconds INTEGER,
        completedAt INTEGER,
        createdAt INTEGER NOT NULL
      )
    ''');

    // session_topics (junction table)
    await db.execute('''
      CREATE TABLE session_topics (
        sessionId INTEGER,
        topicId INTEGER,
        orderIndex INTEGER,
        durationSeconds INTEGER,
        FOREIGN KEY(sessionId) REFERENCES sessions(id),
        FOREIGN KEY(topicId) REFERENCES prayer_topics(id)
      )
    ''');

    // app_settings
    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    await _seedPrayerTopics(db);
  }

  Future<void> _seedPrayerTopics(Database db) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final defaultTopics = [
      'Family',
      'Ministry',
      'Souls',
      'Holy Spirit',
      'God use me',
      'Health',
    ];

    for (final title in defaultTopics) {
      await db.insert('prayer_topics', {
        'title': title,
        'description': null,
        'category': null,
        'isDefault': 1,
        'createdAt': now,
      });
    }
  }

  // CRUD Methods

  Future<List<PrayerTopic>> getTopics() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('prayer_topics');
    return List.generate(maps.length, (i) {
      return PrayerTopic.fromMap(maps[i]);
    });
  }

  Future<int> insertTopic(PrayerTopic topic) async {
    final db = await database;
    return await db.insert('prayer_topics', topic.toMap());
  }

  Future<int> deleteTopic(int id) async {
    final db = await database;
    return await db.delete(
      'prayer_topics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTopic(PrayerTopic topic) async {
    final db = await database;
    return await db.update(
      'prayer_topics',
      topic.toMap(),
      where: 'id = ?',
      whereArgs: [topic.id],
    );
  }

  Future<List<AppSettings>> getSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('app_settings');
    return List.generate(maps.length, (i) {
      return AppSettings.fromMap(maps[i]);
    });
  }

  Future<void> updateSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertSession(Session session) async {
    final db = await database;
    return await db.insert('sessions', session.toMap());
  }

  Future<List<Session>> getSessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sessions',
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) {
      return Session.fromMap(maps[i]);
    });
  }
}
