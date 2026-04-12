import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/utils/time_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../models/clipboard_item.dart';

class ClipboardItemCard extends StatelessWidget {
  final ClipboardItem item;
  final VoidCallback onPin;
  final VoidCallback onFavorite;
  final VoidCallback onDelete;
  final VoidCallback? onSaveAsNote;
  final Future<void> Function(String content)? onUpdate;

  const ClipboardItemCard({
    super.key,
    required this.item,
    required this.onPin,
    required this.onFavorite,
    required this.onDelete,
    this.onSaveAsNote,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context);
    final isUrl = item.type == ClipboardType.url;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showDetails(context, l10n),
        onLongPress: () => _showOptions(context, l10n),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: SizedBox(
            height: 112,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isUrl ? cs.tertiaryContainer : cs.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isUrl
                                ? Icons.link_rounded
                                : Icons.text_fields_rounded,
                            size: 12,
                            color: isUrl
                                ? cs.onTertiaryContainer
                                : cs.onPrimaryContainer,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isUrl
                                ? l10n.clipboardTypeUrl
                                : l10n.clipboardTypeText,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isUrl
                                  ? cs.onTertiaryContainer
                                  : cs.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item.isPinned) ...[
                      const SizedBox(width: 6),
                      Icon(
                        Icons.push_pin_rounded,
                        size: 14,
                        color: cs.primary,
                      ),
                    ],
                    if (item.isFavorite) ...[
                      const SizedBox(width: 6),
                      Icon(
                        Icons.favorite_rounded,
                        size: 14,
                        color: cs.error,
                      ),
                    ],
                    const Spacer(),
                    Text(
                      formatRelativeTime(item.createdAt, locale),
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 4),
                    _PopupMenu(
                      item: item,
                      l10n: l10n,
                      onPin: onPin,
                      onFavorite: onFavorite,
                      onDelete: onDelete,
                      onSaveAsNote: onSaveAsNote,
                      onCopy: () =>
                          _copyToClipboard(context, l10n, item.content),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    item.content,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: cs.onSurface,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDetails(BuildContext context, AppLocalizations l10n) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _ClipboardDetailSheet(
        initialContent: item.content,
        onCopy: (content) => _copyToClipboard(context, l10n, content),
        onSave: onUpdate == null
            ? null
            : (content) async {
                await onUpdate!(content);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.clipboardUpdated),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
      ),
    );
  }

  Future<void> _copyToClipboard(
    BuildContext context,
    AppLocalizations l10n,
    String content,
  ) async {
    await Clipboard.setData(ClipboardData(text: content));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.clipboardCopied),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showOptions(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy_rounded),
              title: Text(_copyLabel(l10n)),
              onTap: () {
                Navigator.pop(ctx);
                _copyToClipboard(context, l10n, item.content);
              },
            ),
            ListTile(
              leading: Icon(
                item.isPinned
                    ? Icons.push_pin_outlined
                    : Icons.push_pin_rounded,
              ),
              title: Text(
                item.isPinned ? l10n.clipboardUnpin : l10n.clipboardPin,
              ),
              onTap: () {
                Navigator.pop(ctx);
                onPin();
              },
            ),
            ListTile(
              leading: Icon(
                item.isFavorite
                    ? Icons.favorite_border_rounded
                    : Icons.favorite_rounded,
              ),
              title: Text(
                item.isFavorite
                    ? l10n.clipboardUnfavorite
                    : l10n.clipboardFavorite,
              ),
              onTap: () {
                Navigator.pop(ctx);
                onFavorite();
              },
            ),
            if (onSaveAsNote != null)
              ListTile(
                leading: const Icon(Icons.note_add_rounded),
                title: Text(l10n.clipboardAddNote),
                onTap: () {
                  Navigator.pop(ctx);
                  onSaveAsNote!();
                },
              ),
            ListTile(
              leading: Icon(
                Icons.delete_outline_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                l10n.clipboardDelete,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(ctx);
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _copyLabel(AppLocalizations l10n) {
    return l10n.clipboardCopied.replaceAll('!', '').replaceAll('！', '');
  }
}

class _PopupMenu extends StatelessWidget {
  final ClipboardItem item;
  final AppLocalizations l10n;
  final VoidCallback onPin;
  final VoidCallback onFavorite;
  final VoidCallback onDelete;
  final VoidCallback? onSaveAsNote;
  final VoidCallback onCopy;

  const _PopupMenu({
    required this.item,
    required this.l10n,
    required this.onPin,
    required this.onFavorite,
    required this.onDelete,
    required this.onCopy,
    this.onSaveAsNote,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      iconSize: 18,
      padding: EdgeInsets.zero,
      itemBuilder: (ctx) => [
        PopupMenuItem(value: 'copy', child: Text(_copyLabel(l10n))),
        PopupMenuItem(
          value: 'pin',
          child: Text(item.isPinned ? l10n.clipboardUnpin : l10n.clipboardPin),
        ),
        PopupMenuItem(
          value: 'favorite',
          child: Text(
            item.isFavorite ? l10n.clipboardUnfavorite : l10n.clipboardFavorite,
          ),
        ),
        if (onSaveAsNote != null)
          PopupMenuItem(value: 'note', child: Text(l10n.clipboardAddNote)),
        PopupMenuItem(
          value: 'delete',
          child: Text(
            l10n.clipboardDelete,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ],
      onSelected: (v) {
        switch (v) {
          case 'copy':
            onCopy();
            break;
          case 'pin':
            onPin();
            break;
          case 'favorite':
            onFavorite();
            break;
          case 'note':
            onSaveAsNote?.call();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
    );
  }

  String _copyLabel(AppLocalizations l10n) {
    return l10n.clipboardCopied.replaceAll('!', '').replaceAll('！', '');
  }
}

class _ClipboardDetailSheet extends StatefulWidget {
  const _ClipboardDetailSheet({
    required this.initialContent,
    required this.onCopy,
    this.onSave,
  });

  final String initialContent;
  final Future<void> Function(String content) onCopy;
  final Future<void> Function(String content)? onSave;

  @override
  State<_ClipboardDetailSheet> createState() => _ClipboardDetailSheetState();
}

class _ClipboardDetailSheetState extends State<_ClipboardDetailSheet> {
  late final TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final viewInsets = MediaQuery.of(context).viewInsets;
    final hasChanges = _controller.text.trim() != widget.initialContent.trim();

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.content_paste_search_rounded),
              const SizedBox(width: 8),
              Text(
                l10n.clipboardDetailsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            minLines: 6,
            maxLines: 12,
            decoration: InputDecoration(
              hintText: l10n.clipboardDetailsHint,
              border: const OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          if (hasChanges) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      await widget.onCopy(_controller.text);
                      if (!mounted) return;
                      navigator.pop();
                    },
                    icon: const Icon(Icons.copy_rounded),
                    label: Text(l10n.clipboardCopyEdited),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: widget.onSave == null || _isSaving
                        ? null
                        : () async {
                            final navigator = Navigator.of(context);
                            setState(() => _isSaving = true);
                            await widget.onSave!(_controller.text);
                            if (!mounted) return;
                            navigator.pop();
                          },
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_rounded),
                    label: Text(l10n.clipboardUpdateRecord),
                  ),
                ),
              ],
            ),
          ] else
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonal(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.actionClose),
              ),
            ),
          if (hasChanges) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.actionCancel),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
