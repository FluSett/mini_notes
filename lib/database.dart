import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'models/note_model.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'app.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, message TEXT NOT NULL, date TEXT NOT NULL, color TEXT NOT NULL)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertNote(Note note) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('notes', note.toMap());
    return result;
  }

  Future<int> updateNotes(Note note) async {
    final Database db = await initializeDB();
    return await db
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<List<Note>> retrieveNotes() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('notes');
    return queryResult.map((e) => Note.fromMap(e)).toList();
  }

  Future<void> deleteNote(int id) async {
    final db = await initializeDB();
    await db.delete(
      'notes',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
