import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/database/app_settings.dart';
import '../../../core/services/rewarded_ad_service.dart';
import '../../../core/utils/backup_import_service.dart';
import '../../../core/utils/export_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../../features/clipboard/providers/clipboard_provider.dart';
import '../../../features/notes/providers/notes_provider.dart';
import '../../../features/pro/screens/upgrade_screen.dart';
import '../../../features/todos/providers/todos_provider.dart';
import '../providers/settings_provider.dart';
import '../../../shared/widgets/confirm_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          // Privacy banner
          _PrivacyBanner(l10n: l10n, cs: cs),

          // Language
          _SectionHeader(title: l10n.settingsLanguage),
          _LanguageTile(settings: settings, l10n: l10n, ref: ref),

          // Theme
          _SectionHeader(title: l10n.settingsTheme),
          _ThemeTile(settings: settings, l10n: l10n, ref: ref),

          // Pro
          const _SectionHeader(title: 'Pro'),
          _ProTile(settings: settings),

          // Clipboard settings
          _SectionHeader(title: l10n.settingsClipboard),
          _MaxHistoryTile(settings: settings, l10n: l10n, ref: ref),
          _AutoDeleteTile(settings: settings, l10n: l10n, ref: ref),

          // Data
          _SectionHeader(title: l10n.settingsData),
          _ImportBackupTile(l10n: l10n, ref: ref, context: context),
          _ProBackupTile(settings: settings, ref: ref, context: context),
          _ClearClipboardTile(l10n: l10n, ref: ref, context: context, cs: cs),
          _ClearNotesTile(l10n: l10n, ref: ref, context: context, cs: cs),

          // About
          _SectionHeader(title: l10n.settingsAbout),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: Text(l10n.settingsVersion),
            trailing: const Text('1.0.0',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.settingsPrivacyPolicy),
            trailing: const Icon(Icons.chevron_right_rounded, size: 20),
            onTap: () async {
              final uri = Uri.parse(
                  'https://dent-tanker-8ee.notion.site/ClipNote-Clipboard-Notes-34094f7d18de80a9ab17c20c38d6a88d');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ProTile extends StatelessWidget {
  const _ProTile({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: Icon(
        settings.isPro
            ? Icons.workspace_premium_rounded
            : Icons.lock_open_rounded,
        color: settings.isPro ? cs.primary : cs.onSurfaceVariant,
      ),
      title: Text(
        settings.isPro
            ? l10n.settingsProUnlockedTitle
            : l10n.settingsProUpgradeTitle,
      ),
      subtitle: Text(
        settings.isPro
            ? l10n.settingsProUnlockedSubtitle
            : l10n.settingsProLockedSubtitle,
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const UpgradeScreen()),
        );
      },
    );
  }
}

class _PrivacyBanner extends StatelessWidget {
  final AppLocalizations l10n;
  final ColorScheme cs;
  const _PrivacyBanner({required this.l10n, required this.cs});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.shield_outlined, color: cs.onPrimaryContainer, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsPrivacyTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.settingsPrivacyNote,
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final AppSettings settings;
  final AppLocalizations l10n;
  final WidgetRef ref;

  const _LanguageTile(
      {required this.settings, required this.l10n, required this.ref});

  static const _languages = [
    (null, null, 'Follow System', '🌐'),
    ('en', null, 'English', '🇬🇧'),
    ('zh', null, '简体中文', '🇨🇳'),
    ('zh', 'TW', '繁體中文', '🇹🇼'),
    ('ja', null, '日本語', '🇯🇵'),
    ('ko', null, '한국어', '🇰🇷'),
  ];

  String get _currentLabel {
    if (settings.languageCode == null) return 'Follow System';
    for (final lang in _languages) {
      if (lang.$1 == settings.languageCode && lang.$2 == settings.countryCode) {
        return lang.$3;
      }
    }
    return 'Follow System';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language_rounded),
      title: Text(l10n.settingsLanguage),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_currentLabel,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, size: 20),
        ],
      ),
      onTap: () => _showPicker(context),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.settingsLanguage,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            ..._languages.map((lang) => ListTile(
                  leading: Text(lang.$4, style: const TextStyle(fontSize: 22)),
                  title: Text(lang.$3),
                  trailing: (settings.languageCode == lang.$1 &&
                          settings.countryCode == lang.$2)
                      ? Icon(Icons.check_rounded,
                          color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    ref.read(settingsProvider.notifier).setLanguage(
                          lang.$1,
                          lang.$2,
                        );
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final AppSettings settings;
  final AppLocalizations l10n;
  final WidgetRef ref;
  const _ThemeTile(
      {required this.settings, required this.l10n, required this.ref});

  String get _label {
    switch (settings.themeMode) {
      case 'light':
        return l10n.settingsThemeLight;
      case 'dark':
        return l10n.settingsThemeDark;
      default:
        return l10n.settingsThemeSystem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(l10n.settingsTheme),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, size: 20),
        ],
      ),
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.settingsTheme,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              _ThemeOption(
                icon: Icons.light_mode_rounded,
                label: l10n.settingsThemeLight,
                value: 'light',
                current: settings.themeMode,
                ref: ref,
                ctx: ctx,
              ),
              _ThemeOption(
                icon: Icons.dark_mode_rounded,
                label: l10n.settingsThemeDark,
                value: 'dark',
                current: settings.themeMode,
                ref: ref,
                ctx: ctx,
              ),
              _ThemeOption(
                icon: Icons.brightness_auto_rounded,
                label: l10n.settingsThemeSystem,
                value: 'system',
                current: settings.themeMode,
                ref: ref,
                ctx: ctx,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String current;
  final WidgetRef ref;
  final BuildContext ctx;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.value,
    required this.current,
    required this.ref,
    required this.ctx,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: current == value
          ? Icon(Icons.check_rounded,
              color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () {
        Navigator.pop(ctx);
        ref.read(settingsProvider.notifier).setThemeMode(value);
      },
    );
  }
}

class _MaxHistoryTile extends StatelessWidget {
  final AppSettings settings;
  final AppLocalizations l10n;
  final WidgetRef ref;
  const _MaxHistoryTile(
      {required this.settings, required this.l10n, required this.ref});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history_rounded),
      title: Text(l10n.settingsMaxHistory),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('${settings.maxClipboardHistory}',
            style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right_rounded, size: 20),
      ]),
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.settingsMaxHistory,
                      style: Theme.of(context).textTheme.titleMedium)),
              for (final v in [100, 200, 500, 1000, 2000])
                ListTile(
                  title: Text('$v${v > 500 ? ' (Pro)' : ''}'),
                  trailing: settings.maxClipboardHistory == v
                      ? Icon(Icons.check_rounded,
                          color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () {
                    if (v > 500 && !settings.isPro) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.settingsProHistoryLocked),
                        ),
                      );
                      return;
                    }
                    Navigator.pop(ctx);
                    ref.read(settingsProvider.notifier).setMaxHistory(v);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AutoDeleteTile extends StatelessWidget {
  final AppSettings settings;
  final AppLocalizations l10n;
  final WidgetRef ref;
  const _AutoDeleteTile(
      {required this.settings, required this.l10n, required this.ref});

  String get _label {
    switch (settings.autoDeleteDays) {
      case 7:
        return l10n.settingsAutoDelete7d;
      case 30:
        return l10n.settingsAutoDelete30d;
      case 90:
        return l10n.settingsAutoDelete90d;
      default:
        return l10n.settingsAutoDeleteNever;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.auto_delete_outlined),
      title: Text(l10n.settingsAutoDelete),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(_label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right_rounded, size: 20),
      ]),
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(l10n.settingsAutoDelete,
                      style: Theme.of(context).textTheme.titleMedium)),
              for (final entry in {
                0: l10n.settingsAutoDeleteNever,
                7: l10n.settingsAutoDelete7d,
                30: l10n.settingsAutoDelete30d,
                90: l10n.settingsAutoDelete90d,
              }.entries)
                ListTile(
                  title: Text(entry.value),
                  trailing: settings.autoDeleteDays == entry.key
                      ? Icon(Icons.check_rounded,
                          color: Theme.of(context).colorScheme.primary)
                      : null,
                  onTap: () {
                    Navigator.pop(ctx);
                    ref
                        .read(settingsProvider.notifier)
                        .setAutoDeleteDays(entry.key);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProBackupTile extends StatelessWidget {
  const _ProBackupTile({
    required this.settings,
    required this.ref,
    required this.context,
  });

  final AppSettings settings;
  final WidgetRef ref;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    final l10n = AppLocalizations.of(ctx);
    return ListTile(
      leading: const Icon(Icons.archive_rounded),
      title: Text(l10n.settingsFullBackupTitle),
      subtitle: Text(
        settings.isPro
            ? l10n.settingsFullBackupSubtitlePro
            : l10n.settingsFullBackupSubtitleFree,
      ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: () async {
        if (!settings.isPro) {
          final action = await showDialog<_BackupUnlockAction>(
            context: ctx,
            builder: (dialogContext) => AlertDialog(
              title: Text(l10n.settingsUnlockFullBackupTitle),
              content: Text(l10n.settingsUnlockFullBackupBody),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(
                    dialogContext,
                    _BackupUnlockAction.cancel,
                  ),
                  child: Text(l10n.actionCancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(
                    dialogContext,
                    _BackupUnlockAction.upgrade,
                  ),
                  child: Text(l10n.actionUpgrade),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(
                    dialogContext,
                    _BackupUnlockAction.watchAd,
                  ),
                  child: Text(l10n.actionWatchAd),
                ),
              ],
            ),
          );

          if (action == _BackupUnlockAction.upgrade) {
            if (!ctx.mounted) return;
            Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => const UpgradeScreen()),
            );
            return;
          }

          if (action != _BackupUnlockAction.watchAd) return;

          final rewarded =
              await RewardedAdService.instance.showRewardedUnlockAd();
          if (!ctx.mounted) return;

          if (!rewarded) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text(l10n.settingsAdNotReady)),
            );
            return;
          }
        }

        final clipboard = ref.read(clipboardProvider);
        final notes = ref.read(notesProvider);
        final todos = ref.read(todosProvider);
        final payload = {
          'schemaVersion': 1,
          'exportedAt': DateTime.now().toIso8601String(),
          'settings': settings.toJson(),
          'clipboard': clipboard
              .map((item) => {
                    'content': item.content,
                    'createdAt': item.createdAt.toIso8601String(),
                    'isPinned': item.isPinned,
                    'isFavorite': item.isFavorite,
                    'type': item.type.name,
                  })
              .toList(),
          'notes': notes
              .map((note) => {
                    'title': note.title,
                    'content': note.content,
                    'tags': note.tags,
                    'createdAt': note.createdAt.toIso8601String(),
                    'updatedAt': note.updatedAt.toIso8601String(),
                    'isPinned': note.isPinned,
                  })
              .toList(),
          'todos': todos
              .map((todo) => {
                    'title': todo.title,
                    'notes': todo.notes,
                    'priority': todo.priority.name,
                    'createdAt': todo.createdAt.toIso8601String(),
                    'updatedAt': todo.updatedAt.toIso8601String(),
                    'dueAt': todo.dueAt?.toIso8601String(),
                    'hasReminder': todo.hasReminder,
                    'isDone': todo.isDone,
                  })
              .toList(),
        };
        final content = const JsonEncoder.withIndent('  ').convert(payload);
        final savedPath = await ExportService.exportToSelectedLocation(
          content,
          'clipnote_full_backup_${DateTime.now().millisecondsSinceEpoch}.clipnote',
        );
        if (ctx.mounted && savedPath != null) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(l10n.settingsExportSuccess)),
          );
        }
      },
    );
  }
}

enum _BackupUnlockAction { cancel, upgrade, watchAd }

class _ImportBackupTile extends StatelessWidget {
  const _ImportBackupTile({
    required this.l10n,
    required this.ref,
    required this.context,
  });

  final AppLocalizations l10n;
  final WidgetRef ref;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      leading: const Icon(Icons.file_upload_outlined),
      title: Text(l10n.settingsImportBackupTitle),
      subtitle: Text(l10n.settingsImportBackupSubtitle),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          withData: true,
        );
        if (result == null || result.files.isEmpty) return;

        try {
          final file = result.files.single;
          final lowerName = file.name.toLowerCase();
          final isSupported =
              lowerName.endsWith('.clipnote') || lowerName.endsWith('.json');
          if (!isSupported) {
            if (!ctx.mounted) return;
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text(l10n.settingsSelectBackupFileError)),
            );
            return;
          }

          final bytes = file.bytes ?? await File(file.path!).readAsBytes();
          final content = utf8.decode(bytes);
          final preview =
              BackupImportService.instance.previewFromJsonString(content);

          if (!ctx.mounted) return;

          final options = await showDialog<_ImportBackupOptions>(
            context: ctx,
            builder: (dialogContext) {
              var mode = BackupImportMode.merge;
              var importSettings = preview.hasSettings;

              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text(l10n.settingsImportBackupTitle),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                file.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  '${l10n.tabClipboard}: ${preview.clipboardCount}'),
                              Text('${l10n.tabNotes}: ${preview.noteCount}'),
                              Text('${l10n.tabTasks}: ${preview.todoCount}'),
                              Text(
                                preview.hasSettings
                                    ? l10n.settingsImportHasSettings
                                    : l10n.settingsImportNoSettings,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.settingsImportMode,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SegmentedButton<BackupImportMode>(
                          segments: [
                            ButtonSegment(
                              value: BackupImportMode.merge,
                              label: Text(l10n.settingsImportMerge),
                            ),
                            ButtonSegment(
                              value: BackupImportMode.replace,
                              label: Text(l10n.settingsImportReplace),
                            ),
                          ],
                          selected: {mode},
                          onSelectionChanged: (value) {
                            setState(() => mode = value.first);
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          mode == BackupImportMode.merge
                              ? l10n.settingsImportModeMergeHint
                              : l10n.settingsImportModeReplaceHint,
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: importSettings && preview.hasSettings,
                          title: Text(l10n.settingsImportSettingsToo),
                          subtitle: Text(
                            preview.hasSettings
                                ? l10n.settingsImportHasSettings
                                : l10n.settingsImportNoSettings,
                          ),
                          onChanged: preview.hasSettings
                              ? (value) =>
                                  setState(() => importSettings = value)
                              : null,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(l10n.actionCancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(
                          dialogContext,
                          _ImportBackupOptions(
                            mode: mode,
                            importSettings:
                                importSettings && preview.hasSettings,
                          ),
                        ),
                        child: Text(l10n.settingsImportNow),
                      ),
                    ],
                  );
                },
              );
            },
          );

          if (options == null) return;
          final summary =
              await BackupImportService.instance.importFromJsonString(
            content,
            mode: options.mode,
            importSettings: options.importSettings,
          );

          await ref.read(clipboardProvider.notifier).reload();
          await ref.read(notesProvider.notifier).reload();
          await ref.read(todosProvider.notifier).reload();
          ref.read(settingsProvider.notifier).reload();

          if (!ctx.mounted) return;
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(
                l10n.settingsImportedSummary(
                  summary.clipboardCount,
                  summary.noteCount,
                  summary.todoCount,
                  summary.settingsImported
                      ? l10n.settingsImportedWithSettingsSuffix
                      : l10n.settingsImportedWithoutSettingsSuffix,
                ),
              ),
            ),
          );
        } catch (error) {
          if (!ctx.mounted) return;
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(l10n.settingsImportFailed(error.toString())),
            ),
          );
        }
      },
    );
  }
}

class _ImportBackupOptions {
  const _ImportBackupOptions({
    required this.mode,
    required this.importSettings,
  });

  final BackupImportMode mode;
  final bool importSettings;
}

class _ClearClipboardTile extends StatelessWidget {
  final AppLocalizations l10n;
  final WidgetRef ref;
  final BuildContext context;
  final ColorScheme cs;
  const _ClearClipboardTile(
      {required this.l10n,
      required this.ref,
      required this.context,
      required this.cs});

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      leading: Icon(Icons.delete_sweep_rounded, color: cs.error),
      title:
          Text(l10n.settingsClearClipboard, style: TextStyle(color: cs.error)),
      onTap: () async {
        final ok = await showConfirmDialog(
          ctx,
          title: l10n.settingsClearClipboard,
          content: l10n.clipboardClearAllConfirm,
          destructive: true,
          cancelLabel: l10n.actionCancel,
          confirmLabel: l10n.actionConfirm,
        );
        if (ok) ref.read(clipboardProvider.notifier).clearAll();
      },
    );
  }
}

class _ClearNotesTile extends StatelessWidget {
  final AppLocalizations l10n;
  final WidgetRef ref;
  final BuildContext context;
  final ColorScheme cs;
  const _ClearNotesTile(
      {required this.l10n,
      required this.ref,
      required this.context,
      required this.cs});

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      leading: Icon(Icons.delete_forever_rounded, color: cs.error),
      title: Text(l10n.settingsClearNotes, style: TextStyle(color: cs.error)),
      onTap: () async {
        final ok = await showConfirmDialog(
          ctx,
          title: l10n.settingsClearNotes,
          content: l10n.settingsClearNotesConfirm,
          destructive: true,
          cancelLabel: l10n.actionCancel,
          confirmLabel: l10n.actionConfirm,
        );
        if (ok) ref.read(notesProvider.notifier).clearAll();
      },
    );
  }
}
