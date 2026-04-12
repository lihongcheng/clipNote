import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../models/todo_item.dart';
import '../providers/todos_provider.dart';

class TodoEditorScreen extends ConsumerStatefulWidget {
  const TodoEditorScreen({super.key, this.todo});

  final TodoItem? todo;

  @override
  ConsumerState<TodoEditorScreen> createState() => _TodoEditorScreenState();
}

class _TodoEditorScreenState extends ConsumerState<TodoEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late TodoPriority _priority;
  DateTime? _dueAt;
  bool _hasReminder = false;

  bool get _isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _notesController = TextEditingController(text: widget.todo?.notes ?? '');
    _priority = widget.todo?.priority ?? TodoPriority.medium;
    _dueAt = widget.todo?.dueAt;
    _hasReminder = widget.todo?.hasReminder ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.todoEdit : l10n.todoNew),
        actions: [
          TextButton(
            onPressed: _save,
            child: Text(l10n.actionSave),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: l10n.todoTitleField,
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: l10n.todoDetailsField,
              alignLabelWithHint: true,
            ),
            minLines: 4,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          Text(
            l10n.todoPriority,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          SegmentedButton<TodoPriority>(
            segments: [
              ButtonSegment(
                value: TodoPriority.low,
                label: Text(l10n.todoPriorityLow),
              ),
              ButtonSegment(
                value: TodoPriority.medium,
                label: Text(l10n.todoPriorityMedium),
              ),
              ButtonSegment(
                value: TodoPriority.high,
                label: Text(l10n.todoPriorityHigh),
              ),
            ],
            selected: {_priority},
            onSelectionChanged: (value) {
              setState(() => _priority = value.first);
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.schedule_rounded, color: cs.primary),
            title: Text(l10n.todoDueDate),
            subtitle: Text(
              _dueAt == null
                  ? l10n.todoNoDeadline
                  : '${_dueAt!.year}-${_dueAt!.month.toString().padLeft(2, '0')}-${_dueAt!.day.toString().padLeft(2, '0')} ${_dueAt!.hour.toString().padLeft(2, '0')}:${_dueAt!.minute.toString().padLeft(2, '0')}',
            ),
            trailing: Wrap(
              spacing: 8,
              children: [
                if (_dueAt != null)
                  IconButton(
                    onPressed: () => setState(() {
                      _dueAt = null;
                      _hasReminder = false;
                    }),
                    icon: const Icon(Icons.close_rounded),
                  ),
                FilledButton.tonal(
                  onPressed: _pickDueAt,
                  child: Text(_dueAt == null ? l10n.todoSet : l10n.todoChange),
                ),
              ],
            ),
          ),
          SwitchListTile(
            value: _hasReminder && _dueAt != null,
            onChanged: _dueAt == null
                ? null
                : (value) => setState(() => _hasReminder = value),
            title: Text(l10n.todoReminder),
            subtitle: Text(l10n.todoReminderHint),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Future<void> _pickDueAt() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _dueAt ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: DateTime(now.year + 5),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueAt ?? now),
    );
    if (time == null) return;

    setState(() {
      _dueAt =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      _hasReminder = true;
    });
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final notifier = ref.read(todosProvider.notifier);
    if (_isEditing) {
      await notifier.updateTodo(
        widget.todo!,
        title: title,
        notes: _notesController.text,
        dueAt: _dueAt,
        clearDueAt: _dueAt == null,
        hasReminder: _hasReminder,
        priority: _priority,
      );
    } else {
      await notifier.createTodo(
        title: title,
        notes: _notesController.text,
        dueAt: _dueAt,
        hasReminder: _hasReminder,
        priority: _priority,
      );
    }
    if (mounted) Navigator.pop(context);
  }
}
