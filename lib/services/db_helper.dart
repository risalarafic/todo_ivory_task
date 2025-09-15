import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_model.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        isDone INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.insert(
      'tasks',
      {
        'id': task.id,
        'title': task.title,
        'description': task.description,
        'isDone': task.isDone ? 1 : 0,
        'createdAt': now,
        'updatedAt': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      orderBy: 'createdAt DESC',
    );

    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        isDone: maps[i]['isDone'] == 1,
      );
    });
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.update(
      'tasks',
      {
        'title': task.title,
        'description': task.description,
        'isDone': task.isDone ? 1 : 0,
        'updatedAt': now,
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
