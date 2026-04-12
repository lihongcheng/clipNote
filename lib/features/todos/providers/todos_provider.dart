import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/database/database_service.dart';
import '../../../core/services/notification_service.dart';
import '../models/todo_item.dart';

class TodosNotifier extends Notifier<List<TodoItem>> {
  @override
  List<TodoItem> build() {
    _load();
    return [];
  }

  Isar get _isar => DatabaseService.instance.isar;

  Future<void> _load() async {
    final todos = await _isar.todoItems
        .where()
        .anyUpdatedAt()
        .sortByIsDone()
        .thenByDueAt()
        .thenByUpdatedAtDesc()
        .findAll();
    state = todos;
  }

  Future<void> reload() => _load();

  Future<TodoItem> createTodo({
    required String title,
    String notes = '',
    DateTime? dueAt,
    bool hasReminder = false,
    TodoPriority priority = TodoPriority.medium,
  }) async {
    final now = DateTime.now();
    final todo = TodoItem()
      ..title = title.trim()
      ..notes = notes.trim()
      ..createdAt = now
      ..updatedAt = now
      ..dueAt = dueAt
      ..hasReminder = hasReminder && dueAt != null
      ..priority = priority;

    await _isar.writeTxn(() => _isar.todoItems.put(todo));
    await NotificationService.instance.scheduleTodoReminder(todo);
    await _load();
    return todo;
  }

  Future<void> updateTodo(
    TodoItem todo, {
    String? title,
    String? notes,
    DateTime? dueAt,
    bool clearDueAt = false,
    bool? hasReminder,
    TodoPriority? priority,
    bool? isDone,
  }) async {
    await _isar.writeTxn(() async {
      if (title != null) todo.title = title.trim();
      if (notes != null) todo.notes = notes.trim();
      if (clearDueAt) {
        todo.dueAt = null;
      } else if (dueAt != null) {
        todo.dueAt = dueAt;
      }
      if (hasReminder != null) {
        todo.hasReminder = hasReminder && todo.dueAt != null;
      }
      if (priority != null) todo.priority = priority;
      if (isDone != null) todo.isDone = isDone;
      todo.updatedAt = DateTime.now();
      await _isar.todoItems.put(todo);
    });

    await NotificationService.instance.cancelTodoReminder(todo.id);
    await NotificationService.instance.scheduleTodoReminder(todo);
    await _load();
  }

  Future<void> toggleDone(TodoItem todo) async {
    await updateTodo(
      todo,
      isDone: !todo.isDone,
      hasReminder: todo.isDone ? todo.hasReminder : false,
    );
  }

  Future<void> deleteTodo(TodoItem todo) async {
    await _isar.writeTxn(() => _isar.todoItems.delete(todo.id));
    await NotificationService.instance.cancelTodoReminder(todo.id);
    await _load();
  }

  Future<List<TodoItem>> search(String query) async {
    if (query.trim().isEmpty) return state;

    final titleMatches = await _isar.todoItems
        .filter()
        .titleContains(query, caseSensitive: false)
        .findAll();
    final noteMatches = await _isar.todoItems
        .filter()
        .notesContains(query, caseSensitive: false)
        .findAll();

    final seen = <int>{};
    final merged = <TodoItem>[];
    for (final todo in [...titleMatches, ...noteMatches]) {
      if (seen.add(todo.id)) merged.add(todo);
    }
    merged.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      final dueCompare = (a.dueAt ?? DateTime(2100))
          .compareTo(b.dueAt ?? DateTime(2100));
      if (dueCompare != 0) return dueCompare;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return merged;
  }
}

final todosProvider = NotifierProvider<TodosNotifier, List<TodoItem>>(
  TodosNotifier.new,
);

final todoSearchQueryProvider = StateProvider<String>((ref) => '');

final todoSearchResultsProvider =
    FutureProvider.autoDispose<List<TodoItem>>((ref) async {
  final query = ref.watch(todoSearchQueryProvider);
  final notifier = ref.watch(todosProvider.notifier);
  if (query.isEmpty) return ref.watch(todosProvider);
  return notifier.search(query);
});
