import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:aliftech_test/models/models.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();

  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('thirdTodo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE $tableTodos ( 
  ${TodoFields.id} integer primary key autoincrement,
  ${TodoFields.todoName} text not null,
  ${TodoFields.todoDescription} text not null,
  ${TodoFields.todoTime} text not null,
  ${TodoFields.todoStatus} text not null)
''');
  }

  Future<Todo> create(Todo todo) async {
    final db = await instance.database;

    final id = await db.insert(tableTodos, todo.toJson());

    return todo.copy(id: id);
  }

  Future<Todo> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTodos,
      columns: TodoFields.values,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Todo.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Todo>> readAllNotes() async {
    final db = await instance.database;

    const orderBy = '${TodoFields.todoTime} ASC';
    final result =
        await db.rawQuery('SELECT * FROM $tableTodos ORDER BY $orderBy');

    // final result = await db.query(tableTodos, orderBy: orderBy);
    //
    return result.map((json) => Todo.fromJson(json)).toList();
  }

  Future<int> update(Todo todo) async {
    final db = await instance.database;

    return db.update(
      tableTodos,
      todo.toJson(),
      where: '${TodoFields.id} = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTodos,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
