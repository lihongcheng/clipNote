import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_card.dart';
import '../screens/note_editor_screen.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../core/utils/export_service.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  String? _selectedTag;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final query = ref.watch(notesSearchQueryProvider);
    final notesAsync = ref.watch(notesSearchResultsProvider);
    final allNotes = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.notesSearchHint,
                  border: InputBorder.none,
                  filled: false,
                ),
                onChanged: (v) =>
                    ref.read(notesSearchQueryProvider.notifier).state = v,
              )
            : Text(l10n.notesTitle),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search_rounded),
            onPressed: () {
              setState(() => _isSearching = !_isSearching);
              if (!_isSearching) {
                _searchController.clear();
                ref.read(notesSearchQueryProvider.notifier).state = '';
              }
            },
          ),
          PopupMenuButton<String>(
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'export',
                child: Row(children: [
                  const Icon(Icons.file_download_outlined, size: 20),
                  const SizedBox(width: 12),
                  Text(l10n.notesExport),
                ]),
              ),
              PopupMenuItem(
                value: 'clear',
                child: Row(children: [
                  Icon(Icons.delete_sweep_rounded, size: 20, color: cs.error),
                  const SizedBox(width: 12),
                  Text(l10n.settingsClearNotes,
                      style: TextStyle(color: cs.error)),
                ]),
              ),
            ],
            onSelected: (v) async {
              if (v == 'export') await _exportData(l10n);
              if (v == 'clear') await _clearAll(l10n);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (allNotes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          l10n.notesCount(allNotes.length),
                          style: const TextStyle(fontSize: 12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('All tags'),
                          selected: _selectedTag == null,
                          onSelected: (_) =>
                              setState(() => _selectedTag = null),
                        ),
                        const SizedBox(width: 8),
                        ..._allTags(allNotes).map(
                          (tag) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text('#$tag'),
                              selected: _selectedTag == tag,
                              onSelected: (_) =>
                                  setState(() => _selectedTag = tag),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: notesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (notes) {
                final filteredNotes = _selectedTag == null
                    ? notes
                    : notes
                        .where((note) => note.tags.contains(_selectedTag))
                        .toList();
                if (filteredNotes.isEmpty) {
                  if (query.isNotEmpty) {
                    return const EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'No results',
                    );
                  }
                  if (_selectedTag != null) {
                    return EmptyState(
                      icon: Icons.sell_outlined,
                      title: 'No notes for #$_selectedTag',
                      subtitle:
                          'Add tags in the editor to build quick collections.',
                    );
                  }
                  return EmptyState(
                    icon: Icons.note_rounded,
                    title: l10n.notesEmpty,
                    subtitle: l10n.notesEmptyHint,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 100),
                  itemCount: filteredNotes.length,
                  itemBuilder: (ctx, i) {
                    final note = filteredNotes[i];
                    return NoteCard(
                      key: ValueKey(note.id),
                      note: note,
                      onTap: () => _openEditor(context, noteId: note.id),
                      onPin: () =>
                          ref.read(notesProvider.notifier).togglePin(note),
                      onDelete: () async {
                        final confirmed = await showConfirmDialog(
                          context,
                          title: l10n.notesDelete,
                          content: l10n.notesDeleteConfirm,
                          destructive: true,
                          cancelLabel: l10n.actionCancel,
                          confirmLabel: l10n.actionConfirm,
                        );
                        if (confirmed) {
                          ref.read(notesProvider.notifier).deleteNote(note);
                        }
                      },
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
        icon: const Icon(Icons.add_rounded),
        label: Text(l10n.notesNew),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context, {int? noteId}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(noteId: noteId),
      ),
    );
    ref.invalidate(notesProvider);
  }

  Future<void> _exportData(AppLocalizations l10n) async {
    final notifier = ref.read(notesProvider.notifier);
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.notesExport,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            ListTile(
              leading: const Icon(Icons.data_object_rounded),
              title: Text(l10n.exportFormatJson),
              onTap: () => Navigator.pop(ctx, 'json'),
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(l10n.exportFormatMd),
              onTap: () => Navigator.pop(ctx, 'md'),
            ),
            ListTile(
              leading: const Icon(Icons.text_snippet_outlined),
              title: Text(l10n.exportFormatTxt),
              onTap: () => Navigator.pop(ctx, 'txt'),
            ),
          ],
        ),
      ),
    );
    if (result == null) return;
    final content = switch (result) {
      'json' => await notifier.exportAsJson(),
      'md' => await notifier.exportAsMarkdown(),
      _ => await notifier.exportAsTxt(),
    };
    final filename = 'notes_${DateTime.now().millisecondsSinceEpoch}.$result';
    final savedPath = await ExportService.exportToSelectedLocation(
      content,
      filename,
    );
    if (!mounted || savedPath == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved to $savedPath')),
    );
  }

  Future<void> _clearAll(AppLocalizations l10n) async {
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.settingsClearNotes,
      content: l10n.settingsClearNotesConfirm,
      destructive: true,
      cancelLabel: l10n.actionCancel,
      confirmLabel: l10n.actionConfirm,
    );
    if (confirmed) {
      ref.read(notesProvider.notifier).clearAll();
    }
  }

  List<String> _allTags(List<Note> notes) {
    final tags = <String>{};
    for (final note in notes) {
      tags.addAll(note.tags);
    }
    final list = tags.toList()..sort();
    return list;
  }
}
