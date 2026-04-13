import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/clipboard/models/clipboard_item.dart';
import '../../features/notes/models/note.dart';
import '../../features/todos/models/todo_item.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Isar? _isar;

  DatabaseService._();

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  Isar get isar {
    if (_isar == null) throw StateError('Database not initialized');
    return _isar!;
  }

  Future<void> init() async {
    if (_isar != null) return;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ClipboardItemSchema, NoteSchema, TodoItemSchema],
      directory: dir.path,
      name: 'clipnote_db',
    );
  }

  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
