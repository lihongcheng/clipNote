import 'package:flutter/material.dart';

import '../models/note.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/time_formatter.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onPin;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onPin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (note.isPinned)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Icon(Icons.push_pin_rounded,
                          size: 14, color: cs.primary),
                    ),
                  Expanded(
                    child: Text(
                      note.displayTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: cs.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _PopupMenu(
                    note: note,
                    l10n: l10n,
                    onPin: onPin,
                    onDelete: onDelete,
                    cs: cs,
                  ),
                ],
              ),
              if (note.preview.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  note.preview,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: cs.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (note.tags.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: note.tags
                      .take(3)
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: cs.secondaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '#$tag',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: cs.onSecondaryContainer,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.schedule_rounded,
                      size: 12, color: cs.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    l10n.notesLastEdited(
                        formatRelativeTime(note.updatedAt, locale)),
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${note.wordCount} words',
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopupMenu extends StatelessWidget {
  final Note note;
  final AppLocalizations l10n;
  final VoidCallback onPin;
  final VoidCallback onDelete;
  final ColorScheme cs;

  const _PopupMenu({
    required this.note,
    required this.l10n,
    required this.onPin,
    required this.onDelete,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      iconSize: 18,
      padding: EdgeInsets.zero,
      itemBuilder: (ctx) => [
        PopupMenuItem(
          value: 'pin',
          child: Text(note.isPinned ? l10n.notesUnpin : l10n.notesPin),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text(l10n.notesDelete,
              style: TextStyle(color: cs.error)),
        ),
      ],
      onSelected: (v) {
        if (v == 'pin') onPin();
        if (v == 'delete') onDelete();
      },
    );
  }
}
