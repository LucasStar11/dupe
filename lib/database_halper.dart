import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'models/task.dart';
import 'models/board.dart';
import 'models/todo.dart';

class DatabaseHelper {
  /// ПОЧИНИТЬ
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _db;
  Future<Database> get database async => _db ?? await _initDatabase();

  Future<Database> _initDatabase() async {
    /// ошибка тут исправить не смог
    var db = await databaseFactory.openDatabase(inMemoryDatabasePath);
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return openDatabase(
      join(documentsDirectory.path, 'kanban.db'),
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future _onCreate(Database db, int version) async {
      await db.execute('''CREATE TABLE tasks(id INTEGER PRIMARY KEY, boardId INTEGER, title TEXT, description TEXT)''');
      await db.execute('''CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)''');
      await db.execute('''CREATE TABLE boards(id INTEGER PRIMARY KEY, title TEXT, description TEXT)''');
  }

  Future<int> insertBoard(Board board) async {
    int boardId = 0;
    Database _db = await instance.database;
    await _db.insert('tasks', board.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      boardId = value;
    });
    return boardId;
  }

  Future<List<Board>> getBoard() async {
    Database _db = await instance.database;
    List<Map<String, dynamic>> boardMap = await _db.query('boards');
    return List.generate(boardMap.length, (index) {
      return Board(id: boardMap[index]['id'], title: boardMap[index]['title'], description: boardMap[index]['description']);
    });
  }

  Future<void> updateBoardTitle(int id, String title) async {
    Database _db = await instance.database;
    await _db.rawUpdate("UPDATE boards SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateBoardDescription(int id, String description) async {
    Database _db = await instance.database;
    await _db.rawUpdate("UPDATE boards SET description = '$description' WHERE id = '$id'");
  }

  Future<void> deleteBoard(int id) async {
    Database _db = await instance.database;

    await _db.rawDelete("DELETE FROM boards WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM tasks WHERE boardId = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId in (SELECT Id from tasks where boardId = '$id')");
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await instance.database;
    await _db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value) {
      taskId = value;
    });
    return taskId;
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await instance.database;
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await instance.database;
    await _db.rawUpdate("UPDATE tasks SET description = '$description' WHERE id = '$id'");
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await instance.database;
    await _db.insert('todo', todo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await instance.database;
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(id: taskMap[index]['id'], boardId: taskMap[index]['boardId'], title: taskMap[index]['title'], description: taskMap[index]['description']);
    });
  }

  Future<List<Todo>> getTodo(int taskId) async {
    Database _db = await instance.database;
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(id: todoMap[index]['id'], title: todoMap[index]['title'], taskId: todoMap[index]['taskId'], isDone: todoMap[index]['isDone']);
    });
  }

  Future<void> updateTodoDone(int id, int isDone) async {
    Database _db = await instance.database;
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

  Future<void> deleteTask(int id) async {
    Database _db = await instance.database;
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");
  }

}
