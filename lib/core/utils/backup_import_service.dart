import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../database/app_settings.dart';
import '../database/database_service.dart';
import '../database/settings_service.dart';
import '../services/notification_service.dart';
import '../../features/clipboard/models/clipboard_item.dart';
import '../../features/notes/models/note.dart';
import '../../features/todos/models/todo_item.dart';

enum BackupImportMode { merge, replace }

class BackupImportPreview {
  const BackupImportPreview({
    required this.clipboardCount,
    required this.noteCount,
    required this.todoCount,
    required this.hasSettings,
  });

  final int clipboardCount;
  final int noteCount;
  final int todoCount;
  final bool hasSettings;
}

class BackupImportSummary {
  const BackupImportSummary({
    required this.clipboardCount,
    required this.noteCount,
    required this.todoCount,
    required this.settingsImported,
  });

  final int clipboardCount;
  final int noteCount;
  final int todoCount;
  final bool settingsImported;
}

class BackupImportService {
  BackupImportService._();

  static final BackupImportService instance = BackupImportService._();

  BackupImportPreview previewFromJsonString(String jsonString) {
    final decoded = _decodeBackup(jsonString);
    final clipboardItems = _parseClipboard(decoded['clipboard']);
    final notes = _parseNotes(decoded['notes']);
    final todos = _parseTodos(decoded['todos']);
    final settings = _parseSettings(decoded['settings']);

    return BackupImportPreview(
      clipboardCount: clipboardItems.length,
      noteCount: notes.length,
      todoCount: todos.length,
      hasSettings: settings != null,
    );
  }

  Future<BackupImportSummary> importFromJsonString(
    String jsonString, {
    required BackupImportMode mode,
    required bool importSettings,
  }) async {
    final decoded = _decodeBackup(jsonString);

    final isar = DatabaseService.instance.isar;
    final clipboardItems = _parseClipboard(decoded['clipboard']);
    final notes = _parseNotes(decoded['notes']);
    final todos = _parseTodos(decoded['todos']);
    final settings = importSettings ? _parseSettings(decoded['settings']) : null;

    if (mode == BackupImportMode.replace) {
      final existingTodos = await isar.todoItems.where().findAll();
      for (final todo in existingTodos) {
        await NotificationService.instance.cancelTodoReminder(todo.id);
      }
    }

    final existingClipboard = mode == BackupImportMode.merge
        ? await isar.clipboardItems.where().findAll()
        : <ClipboardItem>[];
    final existingNotes =
        mode == BackupImportMode.merge ? await isar.notes.where().findAll() : <Note>[];
    final existingTodos =
        mode == BackupImportMode.merge ? await isar.todoItems.where().findAll() : <TodoItem>[];

    final mergedClipboard = mode == BackupImportMode.merge
        ? _mergeClipboard(existingClipboard, clipboardItems)
        : clipboardItems;
    final mergedNotes = mode == BackupImportMode.merge
        ? _mergeNotes(existingNotes, notes)
        : notes;
    final mergedTodos = mode == BackupImportMode.merge
        ? _mergeTodos(existingTodos, todos)
        : todos;

    await isar.writeTxn(() async {
      if (mode == BackupImportMode.replace) {
        await isar.clipboardItems.clear();
        await isar.notes.clear();
        await isar.todoItems.clear();
      }

      await isar.clipboardItems.putAll(mergedClipboard);
      await isar.notes.putAll(mergedNotes);
      await isar.todoItems.putAll(mergedTodos);
    });

    final importedTodos = await isar.todoItems.where().findAll();
    for (final todo in importedTodos) {
      await NotificationService.instance.cancelTodoReminder(todo.id);
      await NotificationService.instance.scheduleTodoReminder(todo);
    }

    if (settings != null) {
      await SettingsService.instance.save(settings);
    }

    return BackupImportSummary(
      clipboardCount: mergedClipboard.length,
      noteCount: mergedNotes.length,
      todoCount: mergedTodos.length,
      settingsImported: settings != null,
    );
  }

  Map<String, dynamic> _decodeBackup(String jsonString) {
    final decoded = jsonDecode(jsonString);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Backup file must be a JSON object.');
    }
    return decoded;
  }

  List<ClipboardItem> _parseClipboard(dynamic raw) {
    final items = <ClipboardItem>[];
    if (raw is! List) return items;
    for (final entry in raw) {
      if (entry is! Map) continue;
      final content = (entry['content'] as String?)?.trim();
      if (content == null || content.isEmpty) continue;
      final item = ClipboardItem()
        ..content = content
        ..createdAt = DateTime.tryParse(entry['createdAt'] as String? ?? '') ??
            DateTime.now()
        ..isPinned = entry['isPinned'] as bool? ?? false
        ..isFavorite = entry['isFavorite'] as bool? ?? false
        ..type = _clipboardTypeFromName(entry['type'] as String?);
      items.add(item);
    }
    return items;
  }

  List<Note> _parseNotes(dynamic raw) {
    final notes = <Note>[];
    if (raw is! List) return notes;
    for (final entry in raw) {
      if (entry is! Map) continue;
      final content = (entry['content'] as String?) ?? '';
      final title = (entry['title'] as String?) ?? '';
      if (content.trim().isEmpty && title.trim().isEmpty) continue;
      final note = Note()
        ..title = title
        ..content = content
        ..createdAt = DateTime.tryParse(entry['createdAt'] as String? ?? '') ??
            DateTime.now()
        ..updatedAt = DateTime.tryParse(entry['updatedAt'] as String? ?? '') ??
            DateTime.now()
        ..isPinned = entry['isPinned'] as bool? ?? false
        ..tags = _stringList(entry['tags']);
      notes.add(note);
    }
    return notes;
  }

  List<TodoItem> _parseTodos(dynamic raw) {
    final todos = <TodoItem>[];
    if (raw is! List) return todos;
    for (final entry in raw) {
      if (entry is! Map) continue;
      final title = (entry['title'] as String?)?.trim();
      if (title == null || title.isEmpty) continue;
      final dueAt = DateTime.tryParse(entry['dueAt'] as String? ?? '');
      final todo = TodoItem()
        ..title = title
        ..notes = (entry['notes'] as String?) ?? ''
        ..createdAt = DateTime.tryParse(entry['createdAt'] as String? ?? '') ??
            DateTime.now()
        ..updatedAt = DateTime.tryParse(entry['updatedAt'] as String? ?? '') ??
            DateTime.now()
        ..dueAt = dueAt
        ..hasReminder = (entry['hasReminder'] as bool? ?? false) && dueAt != null
        ..isDone = entry['isDone'] as bool? ?? false
        ..priority = _todoPriorityFromName(entry['priority'] as String?);
      todos.add(todo);
    }
    return todos;
  }

  AppSettings? _parseSettings(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return AppSettings.fromJson(raw);
    }
    return null;
  }

  List<ClipboardItem> _mergeClipboard(
    List<ClipboardItem> existing,
    List<ClipboardItem> imported,
  ) {
    final merged = <ClipboardItem>[];
    final seen = <String>{};

    for (final item in [...existing, ...imported]) {
      final key = item.content.trim();
      if (!seen.add(key)) continue;
      merged.add(_copyClipboardItem(item));
    }

    merged.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return merged;
  }

  List<Note> _mergeNotes(List<Note> existing, List<Note> imported) {
    final merged = <Note>[];
    final seen = <String>{};

    for (final note in [...existing, ...imported]) {
      final key = '${note.title}\u0000${note.content}';
      if (!seen.add(key)) continue;
      merged.add(_copyNote(note));
    }

    merged.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return merged;
  }

  List<TodoItem> _mergeTodos(List<TodoItem> existing, List<TodoItem> imported) {
    final merged = <TodoItem>[];
    final seen = <String>{};

    for (final todo in [...existing, ...imported]) {
      final key =
          '${todo.title}\u0000${todo.notes}\u0000${todo.dueAt?.toIso8601String() ?? ''}';
      if (!seen.add(key)) continue;
      merged.add(_copyTodo(todo));
    }

    merged.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      final dueCompare =
          (a.dueAt ?? DateTime(2100)).compareTo(b.dueAt ?? DateTime(2100));
      if (dueCompare != 0) return dueCompare;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return merged;
  }

  ClipboardItem _copyClipboardItem(ClipboardItem source) {
    return ClipboardItem()
      ..content = source.content
      ..createdAt = source.createdAt
      ..isPinned = source.isPinned
      ..isFavorite = source.isFavorite
      ..type = source.type;
  }

  Note _copyNote(Note source) {
    return Note()
      ..title = source.title
      ..content = source.content
      ..createdAt = source.createdAt
      ..updatedAt = source.updatedAt
      ..isPinned = source.isPinned
      ..tags = List<String>.from(source.tags);
  }

  TodoItem _copyTodo(TodoItem source) {
    return TodoItem()
      ..title = source.title
      ..notes = source.notes
      ..createdAt = source.createdAt
      ..updatedAt = source.updatedAt
      ..dueAt = source.dueAt
      ..hasReminder = source.hasReminder
      ..isDone = source.isDone
      ..priority = source.priority;
  }

  ClipboardType _clipboardTypeFromName(String? name) {
    return ClipboardType.values.where((type) => type.name == name).firstOrNull ??
        ClipboardType.text;
  }

  TodoPriority _todoPriorityFromName(String? name) {
    return TodoPriority.values
            .where((priority) => priority.name == name)
            .firstOrNull ??
        TodoPriority.medium;
  }

  List<String> _stringList(dynamic raw) {
    if (raw is! List) return const [];
    return raw.whereType<String>().map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
  }
}
