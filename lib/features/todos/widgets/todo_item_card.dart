import 'package:flutter/material.dart';

import '../../../core/utils/time_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../models/todo_item.dart';

class TodoItemCard extends StatelessWidget {
  const TodoItemCard({
    super.key,
    required this.todo,
    required this.onToggleDone,
    required this.onEdit,
    required this.onDelete,
  });

  final TodoItem todo;
  final VoidCallback onToggleDone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      child: ListTile(
        onTap: onEdit,
        leading: Checkbox(
          value: todo.isDone,
          onChanged: (_) => onToggleDone(),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.notes.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                todo.notes,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(
                  label: _priorityLabel(todo.priority, l10n),
                  color: _priorityColor(cs, todo.priority),
                ),
                if (todo.dueAt != null)
                  _InfoChip(
                    label: todo.isToday
                        ? l10n.todoTodayAt(formatClock(todo.dueAt!, locale))
                        : formatDateTime(todo.dueAt!, locale),
                    color: todo.isOverdue
                        ? cs.errorContainer
                        : cs.secondaryContainer,
                    foregroundColor: todo.isOverdue
                        ? cs.onErrorContainer
                        : cs.onSecondaryContainer,
                  ),
                if (todo.hasReminder)
                  _InfoChip(
                    label: l10n.todoReminderOn,
                    color: cs.primaryContainer,
                    foregroundColor: cs.onPrimaryContainer,
                  ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: Text(l10n.todoEdit)),
            PopupMenuItem(value: 'delete', child: Text(l10n.actionDelete)),
          ],
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
        ),
      ),
    );
  }

  String _priorityLabel(TodoPriority priority, AppLocalizations l10n) {
    switch (priority) {
      case TodoPriority.low:
        return l10n.todoPriorityLow;
      case TodoPriority.medium:
        return l10n.todoPriorityMedium;
      case TodoPriority.high:
        return l10n.todoPriorityHigh;
    }
  }

  Color _priorityColor(ColorScheme cs, TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return cs.secondaryContainer;
      case TodoPriority.medium:
        return cs.tertiaryContainer;
      case TodoPriority.high:
        return cs.errorContainer;
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.color,
    this.foregroundColor,
  });

  final String label;
  final Color color;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: foregroundColor,
        ),
      ),
    );
  }
}
