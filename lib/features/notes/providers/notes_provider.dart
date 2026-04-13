import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

import '../../../core/database/database_service.dart';
import '../models/note.dart';

class NotesNotifier extends Notifier<List<Note>> {
  @override
  List<Note> build() {
    _load();
    return [];
  }

  Isar get _isar => DatabaseService.instance.isar;

  Future<void> _load() async {
    final notes = await _isar.notes
        .where()
        .anyUpdatedAt()
        .sortByIsPinnedDesc()
        .thenByUpdatedAtDesc()
        .findAll();
    state = notes;
  }

  Future<void> reload() => _load();

  Future<Note> createNote({
    String title = '',
    String content = '',
    List<String> tags = const [],
  }) async {
    final now = DateTime.now();
    final note = Note()
      ..title = title
      ..content = content
      ..createdAt = now
      ..updatedAt = now
      ..tags = tags;
    await _isar.writeTxn(() => _isar.notes.put(note));
    await _load();
    return note;
  }

  Future<void> updateNote(
    Note note, {
    String? title,
    String? content,
    List<String>? tags,
  }) async {
    await _isar.writeTxn(() async {
      if (title != null) note.title = title;
      if (content != null) note.content = content;
      if (tags != null) note.tags = tags;
      note.updatedAt = DateTime.now();
      await _isar.notes.put(note);
    });
    await _load();
  }

  Future<void> togglePin(Note note) async {
    await _isar.writeTxn(() async {
      note.isPinned = !note.isPinned;
      await _isar.notes.put(note);
    });
    await _load();
  }

  Future<void> deleteNote(Note note) async {
    await _isar.writeTxn(() => _isar.notes.delete(note.id));
    await _load();
  }

  Future<void> clearAll() async {
    await _isar.writeTxn(() => _isar.notes.clear());
    await _load();
  }

  Future<List<Note>> search(String query) async {
    if (query.trim().isEmpty) return state;
    final byTitle = await _isar.notes
        .filter()
        .titleContains(query, caseSensitive: false)
        .findAll();
    final byContent = await _isar.notes
        .filter()
        .contentContains(query, caseSensitive: false)
        .findAll();
    final byTags = state
        .where(
          (note) => note.tags.any(
            (tag) => tag.toLowerCase().contains(query.toLowerCase()),
          ),
        )
        .toList();
    final ids = <int>{};
    final results = <Note>[];
    for (final n in [...byTitle, ...byContent, ...byTags]) {
      if (ids.add(n.id)) results.add(n);
    }
    results.sort((a, b) {
      if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    return results;
  }

  Future<String> exportAsJson() async {
    final buffer = StringBuffer('[');
    final notes = state;
    for (int i = 0; i < notes.length; i++) {
      final n = notes[i];
      buffer.write('{"id":${n.id},"title":${_js(n.title)},"content":${_js(n.content)},"createdAt":"${n.createdAt.toIso8601String()}","updatedAt":"${n.updatedAt.toIso8601String()}","isPinned":${n.isPinned},"tags":[${n.tags.map(_js).join(',')}]}');
      if (i < notes.length - 1) buffer.write(',');
    }
    buffer.write(']');
    return buffer.toString();
  }

  Future<String> exportAsMarkdown() async {
    final buffer = StringBuffer();
    for (final n in state) {
      if (n.title.isNotEmpty) {
        buffer.writeln('# ${n.title}');
        buffer.writeln();
      }
      if (n.tags.isNotEmpty) {
        buffer.writeln('_Tags: ${n.tags.join(', ')}_');
        buffer.writeln();
      }
      buffer.writeln(n.content);
      buffer.writeln();
      buffer.writeln('---');
      buffer.writeln();
    }
    return buffer.toString();
  }

  Future<String> exportAsTxt() async {
    final buffer = StringBuffer();
    for (final n in state) {
      if (n.title.isNotEmpty) buffer.writeln(n.title);
      if (n.tags.isNotEmpty) buffer.writeln('Tags: ${n.tags.join(', ')}');
      buffer.writeln(n.content);
      buffer.writeln('--------');
      buffer.writeln();
    }
    return buffer.toString();
  }

  String _js(String s) =>
      '"${s.replaceAll('\\', '\\\\').replaceAll('"', '\\"').replaceAll('\n', '\\n').replaceAll('\r', '\\r')}"';
}

final notesProvider = NotifierProvider<NotesNotifier, List<Note>>(
  NotesNotifier.new,
);

final notesSearchQueryProvider = StateProvider<String>((ref) => '');

final notesSearchResultsProvider =
    FutureProvider.autoDispose<List<Note>>((ref) async {
  final query = ref.watch(notesSearchQueryProvider);
  final notifier = ref.watch(notesProvider.notifier);
  if (query.isEmpty) return ref.watch(notesProvider);
  return notifier.search(query);
});
