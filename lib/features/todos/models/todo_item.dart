import 'package:isar_community/isar.dart';

part 'todo_item.g.dart';

enum TodoPriority { low, medium, high }

@collection
class TodoItem {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String title;

  String notes = '';

  @Index(type: IndexType.value)
  late DateTime createdAt;

  @Index(type: IndexType.value)
  late DateTime updatedAt;

  @Index(type: IndexType.value)
  DateTime? dueAt;

  bool isDone = false;
  bool hasReminder = false;

  @enumerated
  TodoPriority priority = TodoPriority.medium;

  bool get isOverdue {
    if (isDone || dueAt == null) return false;
    return dueAt!.isBefore(DateTime.now());
  }

  bool get isToday {
    if (dueAt == null) return false;
    final now = DateTime.now();
    return dueAt!.year == now.year &&
        dueAt!.month == now.month &&
        dueAt!.day == now.day;
  }
}
