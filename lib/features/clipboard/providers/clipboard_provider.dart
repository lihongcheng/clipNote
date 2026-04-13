import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

import '../../../core/database/database_service.dart';
import '../../../core/database/settings_service.dart';
import '../models/clipboard_item.dart';

class ClipboardNotifier extends Notifier<List<ClipboardItem>> {
  @override
  List<ClipboardItem> build() {
    _load();
    return [];
  }

  Isar get _isar => DatabaseService.instance.isar;

  Future<void> _load() async {
    final items = await _isar.clipboardItems
        .where()
        .anyCreatedAt()
        .sortByIsPinnedDesc()
        .thenByCreatedAtDesc()
        .findAll();
    state = items;
  }

  Future<void> reload() => _load();

  Future<bool> addItem(String content) async {
    if (content.trim().isEmpty) return false;

    // Dedup check
    final existing = await _isar.clipboardItems
        .filter()
        .contentContains(content)
        .findFirst();
    if (existing != null) {
      // Move to top by updating createdAt
      await _isar.writeTxn(() async {
        existing.createdAt = DateTime.now();
        await _isar.clipboardItems.put(existing);
      });
      await _load();
      return false;
    }

    final item = ClipboardItem()
      ..content = content
      ..createdAt = DateTime.now()
      ..type = _detectType(content);

    await _isar.writeTxn(() => _isar.clipboardItems.put(item));
    await _enforceHistoryLimit();
    await _load();
    return true;
  }

  ClipboardType _detectType(String content) {
    final uri = Uri.tryParse(content);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return ClipboardType.url;
    }
    return ClipboardType.text;
  }

  Future<void> togglePin(ClipboardItem item) async {
    await _isar.writeTxn(() async {
      item.isPinned = !item.isPinned;
      await _isar.clipboardItems.put(item);
    });
    await _load();
  }

  Future<void> toggleFavorite(ClipboardItem item) async {
    await _isar.writeTxn(() async {
      item.isFavorite = !item.isFavorite;
      await _isar.clipboardItems.put(item);
    });
    await _load();
  }

  Future<void> deleteItem(ClipboardItem item) async {
    await _isar.writeTxn(() => _isar.clipboardItems.delete(item.id));
    await _load();
  }

  Future<void> updateItem(
    ClipboardItem item, {
    required String content,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    await _isar.writeTxn(() async {
      item.content = trimmed;
      item.type = _detectType(trimmed);
      await _isar.clipboardItems.put(item);
    });
    await _load();
  }

  Future<void> clearUnpinned() async {
    await _isar.writeTxn(() async {
      await _isar.clipboardItems.filter().isPinnedEqualTo(false).deleteAll();
    });
    await _load();
  }

  Future<void> clearAll() async {
    await _isar.writeTxn(() => _isar.clipboardItems.clear());
    await _load();
  }

  Future<void> _enforceHistoryLimit() async {
    final settings = SettingsService.instance.settings;
    var max = settings.maxClipboardHistory;
    if (max <= 0) return;

    // Enforce Pro limit: non-Pro users can only use up to 50
    final proLimit = 50;
    if (!settings.isPro && max > proLimit) {
      max = proLimit;
    }

    final items = await _isar.clipboardItems
        .where()
        .anyCreatedAt()
        .sortByIsPinnedDesc()
        .thenByCreatedAtDesc()
        .findAll();

    if (items.length <= max) return;
    final removable = items
        .skip(max)
        .where((item) => !item.isPinned)
        .map((item) => item.id)
        .toList();
    if (removable.isEmpty) return;
    await _isar.writeTxn(() => _isar.clipboardItems.deleteAll(removable));
  }

  Future<List<ClipboardItem>> search(String query) async {
    if (query.trim().isEmpty) return state;
    return _isar.clipboardItems
        .filter()
        .contentContains(query, caseSensitive: false)
        .sortByIsPinnedDesc()
        .thenByCreatedAtDesc()
        .findAll();
  }

  Future<void> applyAutoDelete(int days) async {
    if (days == 0) return;
    final cutoff = DateTime.now().subtract(Duration(days: days));
    await _isar.writeTxn(() async {
      final old = await _isar.clipboardItems
          .where()
          .createdAtBetween(
            DateTime.fromMillisecondsSinceEpoch(0),
            cutoff,
          )
          .filter()
          .isPinnedEqualTo(false)
          .findAll();
      final ids = old.map((e) => e.id).toList();
      await _isar.clipboardItems.deleteAll(ids);
    });
    await _load();
  }

  Future<String> exportAsJson() async {
    final items = state;
    final buffer = StringBuffer('[');
    for (int i = 0; i < items.length; i++) {
      buffer.write(
          '{"id":${items[i].id},"content":${_jsonString(items[i].content)},"createdAt":"${items[i].createdAt.toIso8601String()}","isPinned":${items[i].isPinned},"type":"${items[i].type.name}"}');
      if (i < items.length - 1) buffer.write(',');
    }
    buffer.write(']');
    return buffer.toString();
  }

  Future<String> exportAsTxt() async {
    final buffer = StringBuffer();
    for (final item in state) {
      buffer.writeln(item.content);
      buffer.writeln('--- ${item.createdAt.toLocal()} ---');
      buffer.writeln();
    }
    return buffer.toString();
  }

  String _jsonString(String s) {
    return '"${s.replaceAll('\\', '\\\\').replaceAll('"', '\\"').replaceAll('\n', '\\n').replaceAll('\r', '\\r')}"';
  }
}

final clipboardProvider =
    NotifierProvider<ClipboardNotifier, List<ClipboardItem>>(
  ClipboardNotifier.new,
);

// Search state
final clipboardSearchQueryProvider = StateProvider<String>((ref) => '');

final clipboardSearchResultsProvider =
    FutureProvider.autoDispose<List<ClipboardItem>>((ref) async {
  final query = ref.watch(clipboardSearchQueryProvider);
  final notifier = ref.watch(clipboardProvider.notifier);
  if (query.isEmpty) return ref.watch(clipboardProvider);
  return notifier.search(query);
});
