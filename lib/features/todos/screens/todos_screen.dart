import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/empty_state.dart';
import '../models/todo_item.dart';
import '../providers/todos_provider.dart';
import '../widgets/todo_item_card.dart';
import 'todo_editor_screen.dart';

enum TodoFilter { today, all, done }

class TodosScreen extends ConsumerStatefulWidget {
  const TodosScreen({super.key});

  @override
  ConsumerState<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends ConsumerState<TodosScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  TodoFilter _filter = TodoFilter.today;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final todosAsync = ref.watch(todoSearchResultsProvider);
    final allTodos = ref.watch(todosProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.todoSearchHint,
                  border: InputBorder.none,
                  filled: false,
                ),
                onChanged: (value) =>
                    ref.read(todoSearchQueryProvider.notifier).state = value,
              )
            : Text(l10n.todoTitle),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search_rounded),
            onPressed: () {
              setState(() => _isSearching = !_isSearching);
              if (!_isSearching) {
                _searchController.clear();
                ref.read(todoSearchQueryProvider.notifier).state = '';
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (allTodos.isNotEmpty)
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              scrollDirection: Axis.horizontal,
              child: SegmentedButton<TodoFilter>(
                segments: [
                  ButtonSegment(
                    value: TodoFilter.today,
                    label: Text(l10n.todoFilterToday),
                  ),
                  ButtonSegment(
                    value: TodoFilter.all,
                    label: Text(l10n.todoFilterAll),
                  ),
                  ButtonSegment(
                    value: TodoFilter.done,
                    label: Text(l10n.todoFilterDone),
                  ),
                ],
                selected: {_filter},
                onSelectionChanged: (value) {
                  setState(() => _filter = value.first);
                },
              ),
            ),
          Expanded(
            child: todosAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text(error.toString())),
              data: (todos) {
                final filtered = _applyFilter(todos);
                if (filtered.isEmpty) {
                  return EmptyState(
                    icon: Icons.checklist_rounded,
                    title: _emptyTitle(l10n),
                    subtitle: l10n.todoEmptySubtitle,
                    action: FilledButton.tonal(
                      onPressed: () => _openEditor(context),
                      child: Text(l10n.todoAdd),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 100),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final todo = filtered[index];
                    return TodoItemCard(
                      key: ValueKey(todo.id),
                      todo: todo,
                      onToggleDone: () =>
                          ref.read(todosProvider.notifier).toggleDone(todo),
                      onEdit: () => _openEditor(context, todo: todo),
                      onDelete: () =>
                          ref.read(todosProvider.notifier).deleteTodo(todo),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add_task_rounded),
        label: Text(l10n.todoNew),
      ),
    );
  }

  List<TodoItem> _applyFilter(List<TodoItem> todos) {
    switch (_filter) {
      case TodoFilter.today:
        return todos
            .where(
                (todo) => !todo.isDone && (todo.isToday || todo.dueAt == null))
            .toList();
      case TodoFilter.done:
        return todos.where((todo) => todo.isDone).toList();
      case TodoFilter.all:
        return todos;
    }
  }

  String _emptyTitle(AppLocalizations l10n) {
    switch (_filter) {
      case TodoFilter.today:
        return l10n.todoEmptyToday;
      case TodoFilter.done:
        return l10n.todoEmptyDone;
      case TodoFilter.all:
        return l10n.todoEmptyAll;
    }
  }

  Future<void> _openEditor(BuildContext context, {TodoItem? todo}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TodoEditorScreen(todo: todo),
      ),
    );
    ref.invalidate(todosProvider);
  }
}
