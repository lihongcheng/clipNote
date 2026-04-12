import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../l10n/app_localizations.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';
import '../../../shared/widgets/confirm_dialog.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final int? noteId;

  const NoteEditorScreen({super.key, this.noteId});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagsController;
  Note? _note;
  bool _isPreview = false;
  bool _isDirty = false;
  Timer? _autoSaveTimer;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _tagsController = TextEditingController();
    _loadNote();
  }

  Future<void> _loadNote() async {
    if (widget.noteId != null) {
      final notes = ref.read(notesProvider);
      final note = notes.where((n) => n.id == widget.noteId).firstOrNull;
      if (note != null) {
        setState(() {
          _note = note;
          _titleController.text = note.title;
          _contentController.text = note.content;
          _tagsController.text = note.tags.join(', ');
        });
      }
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (!_isDirty) setState(() => _isDirty = true);
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), _save);
  }

  Future<void> _save() async {
    if (!_isDirty) return;
    setState(() => _isSaving = true);
    final notifier = ref.read(notesProvider.notifier);
    final title = _titleController.text;
    final content = _contentController.text;
    final tags = _parseTags(_tagsController.text);

    if (_note == null) {
      _note = await notifier.createNote(
        title: title,
        content: content,
        tags: tags,
      );
    } else {
      await notifier.updateNote(
        _note!,
        title: title,
        content: content,
        tags: tags,
      );
    }
    if (mounted) setState(() { _isDirty = false; _isSaving = false; });
  }

  List<String> _parseTags(String raw) {
    return raw
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) return;
        _autoSaveTimer?.cancel();
        if (_isDirty) await _save();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.noteId == null ? l10n.notesNew : l10n.notesEdit,
          ),
          actions: [
            // Save indicator
            if (_isSaving)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (!_isDirty && _note != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.check_circle_outline_rounded,
                    size: 20, color: cs.primary),
              ),
            // Preview toggle
            IconButton(
              icon: Icon(
                _isPreview
                    ? Icons.edit_outlined
                    : Icons.preview_outlined,
              ),
              tooltip:
                  _isPreview ? l10n.notesMarkdownEdit : l10n.notesMarkdownPreview,
              onPressed: () => setState(() => _isPreview = !_isPreview),
            ),
            // More actions
            PopupMenuButton<String>(
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'save',
                  child: Row(children: [
                    const Icon(Icons.save_outlined, size: 20),
                    const SizedBox(width: 12),
                    Text(l10n.actionSave),
                  ]),
                ),
                PopupMenuItem(
                  value: 'share',
                  child: Row(children: [
                    const Icon(Icons.share_outlined, size: 20),
                    const SizedBox(width: 12),
                    Text(l10n.notesShare),
                  ]),
                ),
                if (_note != null)
                  PopupMenuItem(
                    value: 'pin',
                    child: Row(children: [
                      Icon(
                        _note!.isPinned
                            ? Icons.push_pin_outlined
                            : Icons.push_pin_rounded,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(_note!.isPinned
                          ? l10n.notesUnpin
                          : l10n.notesPin),
                    ]),
                  ),
                if (_note != null)
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      Icon(Icons.delete_outline_rounded,
                          size: 20, color: cs.error),
                      const SizedBox(width: 12),
                      Text(l10n.notesDelete,
                          style: TextStyle(color: cs.error)),
                    ]),
                  ),
              ],
              onSelected: (v) async {
                switch (v) {
                  case 'save':
                    await _save();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.notesSaved)),
                      );
                    }
                  case 'share':
                    final text =
                        '${_titleController.text}\n\n${_contentController.text}';
                    await Share.share(text.trim());
                  case 'pin':
                    if (_note != null) {
                      await _save();
                      await ref
                          .read(notesProvider.notifier)
                          .togglePin(_note!);
                      await _loadNote();
                    }
                  case 'delete':
                    if (_note != null) {
                      final ok = await showConfirmDialog(
                        context,
                        title: l10n.notesDelete,
                        content: l10n.notesDeleteConfirm,
                        destructive: true,
                        cancelLabel: l10n.actionCancel,
                        confirmLabel: l10n.actionConfirm,
                      );
                      if (ok && context.mounted) {
                        ref
                            .read(notesProvider.notifier)
                            .deleteNote(_note!);
                        Navigator.pop(context);
                      }
                    }
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Title input
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: l10n.notesTitleHint,
                  border: InputBorder.none,
                  filled: false,
                ),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                onChanged: (_) => _onChanged(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: TextField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  hintText: 'Tags, separated by commas',
                  prefixIcon: Icon(Icons.sell_outlined),
                ),
                onChanged: (_) => _onChanged(),
              ),
            ),
            Divider(height: 1, color: cs.outlineVariant),
            Expanded(
              child: _isPreview
                  ? Markdown(
                      data: _contentController.text,
                      padding: const EdgeInsets.all(16),
                      styleSheet: MarkdownStyleSheet.fromTheme(
                        Theme.of(context),
                      ),
                    )
                  : TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        hintText: l10n.notesContentHint,
                        border: InputBorder.none,
                        filled: false,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.7,
                      ),
                      onChanged: (_) => _onChanged(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
