import 'dart:io';
import 'package:todo/Model/note_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/user_model.dart';

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper._instance();

  static Database? _db = null;

  DataBaseHelper._instance();

  String noteTable = "note_table";
  String userTable = "user_table";
  String colId = "id";
  String iD = "id";
  String colTitle = "title";
  String colDate = "date";
  String colPriority = "priority";
  String colStatus = "status";

  String firstName = "firstName";
  String lastName = "lastName";
  var age = "age";
  String gender = "gender";

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "todo_list.db";
    final todoListDB =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todoListDB;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDate TEXT, $colPriority TEXT, $colStatus INTEGER)");
    await db.execute(
        "CREATE TABLE $userTable($iD INTEGER PRIMARY KEY AUTOINCREMENT, $firstName TEXT, $lastName TEXT, $age INTEGER, $gender TEXT, $colStatus INTEGER)");
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(noteTable);
    return result;
  }

  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(userTable);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    final List<Map<String, dynamic>> noteMapList = await getNoteMapList();

    final List<Note> noteList = [];
    noteMapList.forEach((noteMap) {
      noteList.add(Note.fromMap(noteMap));
    });
    noteList.sort((noteA, noteB) => noteA.date!.compareTo(noteB.date!));
    return noteList;
  }

  Future<List<User>> getUserList() async {
    final List<Map<String, dynamic>> userMapList = await getUserMapList();

    final List<User> userList = [];

    userMapList.forEach((userMap) {
      userList.add(User.fromMap(userMap));
    });
    return userList;
  }

  Future<int> insertNote(Note note) async {
    Database? db = await this.db;
    final int result = await db!.insert(
      noteTable,
      note.toMap(),
    );
    return result;
  }

  Future<int> insertUser(User user) async {
    Database? db = await this.db;
    final int result = await db!.insert(
      userTable,
      user.toMap(),
    );
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database? db = await this.db;
    final int result = await db!.update(
      noteTable,
      note.toMap(),
      where: "$colId = ?",
      whereArgs: [note.id],
    );

    return result;
  }


  Future<int> updateUser(User user) async {
    Database? db = await this.db;
    final int result = await db!.update(
      userTable,
      user.toMap(),
      where: "$iD = ?",
      whereArgs: [user.iD]
    );

    return result;
  }

  Future<int> deleteNote(int id) async {
    Database? db = await this.db;
    final int result = await db!.delete(
      noteTable,
      where: "$colId = ?",
      whereArgs: [id],
    );

    return result;
  }

  Future<int> deleteUser(int id) async {
    Database? db = await this.db;
    final int result = await db!.delete(
      userTable,
      where: "$iD = ?",
      whereArgs: [iD],
    );

    return result;
  }
}
