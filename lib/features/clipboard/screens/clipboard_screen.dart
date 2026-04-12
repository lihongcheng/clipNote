import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/native_clipboard_service.dart';
import '../../../l10n/app_localizations.dart';
import '../providers/clipboard_provider.dart';
import '../../notes/providers/notes_provider.dart';
import '../widgets/clipboard_item_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../core/utils/export_service.dart';

class ClipboardScreen extends ConsumerStatefulWidget {
  const ClipboardScreen({super.key});

  @override
  ConsumerState<ClipboardScreen> createState() => _ClipboardScreenState();
}

class _ClipboardScreenState extends ConsumerState<ClipboardScreen>
    with WidgetsBindingObserver {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  bool _favoritesOnly = false;
  StreamSubscription<String>? _clipboardSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Listen to native clipboard events (fires when clipboard changes while app is active)
    _clipboardSub = NativeClipboardService.clipboardStream.listen(
      (text) async {
        await ref.read(clipboardProvider.notifier).addItem(text);
      },
      onError: (_) {}, // gracefully ignore on non-Android or permission denied
    );
  }

  @override
  void dispose() {
    _clipboardSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  // When app resumes, check clipboard and save if new content
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkClipboard();
    }
  }

  Future<void> _checkClipboard() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data?.text != null && data!.text!.trim().isNotEmpty) {
        await ref.read(clipboardProvider.notifier).addItem(data.text!);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final query = ref.watch(clipboardSearchQueryProvider);
    final itemsAsync = ref.watch(clipboardSearchResultsProvider);
    final allItems = ref.watch(clipboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.clipboardSearchHint,
                  border: InputBorder.none,
                  filled: false,
                ),
                onChanged: (v) =>
                    ref.read(clipboardSearchQueryProvider.notifier).state = v,
              )
            : Text(l10n.clipboardTitle),
        actions: [
          // Search toggle
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search_rounded),
            onPressed: () {
              setState(() => _isSearching = !_isSearching);
              if (!_isSearching) {
                _searchController.clear();
                ref.read(clipboardSearchQueryProvider.notifier).state = '';
              }
            },
          ),
          // Overflow menu
          PopupMenuButton<String>(
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'paste',
                child: Row(children: [
                  const Icon(Icons.content_paste_rounded, size: 20),
                  const SizedBox(width: 12),
                  Text(l10n.clipboardCopied.replaceAll('!', 'Paste')),
                ]),
              ),
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
                  Text(l10n.clipboardClearAll,
                      style: TextStyle(color: cs.error)),
                ]),
              ),
            ],
            onSelected: (v) async {
              switch (v) {
                case 'paste':
                  await _checkClipboard();
                  break;
                case 'export':
                  await _exportData(l10n);
                  break;
                case 'clear':
                  await _clearAll(l10n);
                  break;
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Count chip
          if (allItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      l10n.clipboardItemsCount(allItems.length),
                      style: const TextStyle(fontSize: 12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: Text(l10n.clipboardFavorites),
                    selected: _favoritesOnly,
                    onSelected: (value) {
                      setState(() => _favoritesOnly = value);
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: itemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (items) {
                final visibleItems = _favoritesOnly
                    ? items.where((item) => item.isFavorite).toList()
                    : items;
                if (visibleItems.isEmpty) {
                  if (query.isNotEmpty) {
                    return const EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'No results',
                      subtitle: 'Try a different keyword',
                    );
                  }
                  if (_favoritesOnly) {
                    return EmptyState(
                      icon: Icons.favorite_border_rounded,
                      title: l10n.clipboardNoFavorites,
                      subtitle: l10n.clipboardNoFavoritesHint,
                    );
                  }
                  return EmptyState(
                    icon: Icons.content_paste_rounded,
                    title: l10n.clipboardEmpty,
                    subtitle: l10n.clipboardEmptyHint,
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await _checkClipboard();
                    ref.invalidate(clipboardProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 100),
                    itemCount: visibleItems.length,
                    itemBuilder: (ctx, i) {
                      final item = visibleItems[i];
                      return ClipboardItemCard(
                        key: ValueKey(item.id),
                        item: item,
                        onPin: () => ref
                            .read(clipboardProvider.notifier)
                            .togglePin(item),
                        onFavorite: () => ref
                            .read(clipboardProvider.notifier)
                            .toggleFavorite(item),
                        onDelete: () => ref
                            .read(clipboardProvider.notifier)
                            .deleteItem(item),
                        onSaveAsNote: () async {
                          await ref
                              .read(notesProvider.notifier)
                              .createNote(content: item.content);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.clipboardAddNote)),
                            );
                          }
                        },
                        onUpdate: (content) => ref
                            .read(clipboardProvider.notifier)
                            .updateItem(item, content: content),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(AppLocalizations l10n) async {
    final notifier = ref.read(clipboardProvider.notifier);
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
              leading: const Icon(Icons.text_snippet_outlined),
              title: Text(l10n.exportFormatTxt),
              onTap: () => Navigator.pop(ctx, 'txt'),
            ),
          ],
        ),
      ),
    );
    if (result == null) return;
    final content = result == 'json'
        ? await notifier.exportAsJson()
        : await notifier.exportAsTxt();
    final filename =
        'clipboard_${DateTime.now().millisecondsSinceEpoch}.$result';
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
      title: l10n.clipboardClearAll,
      content: l10n.clipboardClearAllConfirm,
      destructive: true,
      cancelLabel: l10n.actionCancel,
      confirmLabel: l10n.actionConfirm,
    );
    if (confirmed) {
      await ref.read(clipboardProvider.notifier).clearUnpinned();
    }
  }
}
