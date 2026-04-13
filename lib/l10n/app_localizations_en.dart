// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'ClipNote';

  @override
  String get tabClipboard => 'Clipboard';

  @override
  String get tabNotes => 'Notes';

  @override
  String get tabTasks => 'Tasks';

  @override
  String get tabSettings => 'Settings';

  @override
  String get clipboardTitle => 'Clipboard History';

  @override
  String get clipboardEmpty => 'Nothing copied yet';

  @override
  String get clipboardEmptyHint =>
      'Copy any text to automatically save it here';

  @override
  String get clipboardSearchHint => 'Search clipboard...';

  @override
  String get clipboardCopied => 'Copied!';

  @override
  String get clipboardPinned => 'Pinned';

  @override
  String get clipboardPin => 'Pin';

  @override
  String get clipboardUnpin => 'Unpin';

  @override
  String get clipboardDelete => 'Delete';

  @override
  String get clipboardDeleteConfirm => 'Delete this item?';

  @override
  String get clipboardClearAll => 'Clear All';

  @override
  String get clipboardClearAllConfirm =>
      'Clear all clipboard history? Pinned items will be kept.';

  @override
  String clipboardItemsCount(int count) {
    return '$count items';
  }

  @override
  String get clipboardShareText => 'Share';

  @override
  String get clipboardAddNote => 'Save as Note';

  @override
  String get clipboardFavorites => 'Favorites';

  @override
  String get clipboardNoFavorites => 'No favorites yet';

  @override
  String get clipboardNoFavoritesHint =>
      'Mark important snippets to keep them handy.';

  @override
  String get clipboardFavorite => 'Favorite';

  @override
  String get clipboardUnfavorite => 'Remove favorite';

  @override
  String get clipboardDetailsTitle => 'Clipboard details';

  @override
  String get clipboardDetailsHint => 'Edit clipboard content';

  @override
  String get clipboardCopyEdited => 'Copy edited text';

  @override
  String get clipboardUpdateRecord => 'Update record';

  @override
  String get clipboardUpdated => 'Clipboard record updated';

  @override
  String get clipboardTypeText => 'Text';

  @override
  String get clipboardTypeUrl => 'URL';

  @override
  String get todoTitle => 'Tasks';

  @override
  String get todoSearchHint => 'Search tasks...';

  @override
  String get todoFilterToday => 'Today';

  @override
  String get todoFilterAll => 'All';

  @override
  String get todoFilterDone => 'Done';

  @override
  String get todoEmptySubtitle =>
      'Tasks stay offline and reminders stay local.';

  @override
  String get todoEmptyToday => 'No tasks for today';

  @override
  String get todoEmptyDone => 'No completed tasks yet';

  @override
  String get todoEmptyAll => 'No tasks yet';

  @override
  String get todoAdd => 'Add task';

  @override
  String get todoNew => 'New Task';

  @override
  String get todoEdit => 'Edit Task';

  @override
  String get todoTitleField => 'Task title';

  @override
  String get todoDetailsField => 'Details';

  @override
  String get todoPriority => 'Priority';

  @override
  String get todoPriorityLow => 'Low';

  @override
  String get todoPriorityMedium => 'Medium';

  @override
  String get todoPriorityHigh => 'High';

  @override
  String get todoDueDate => 'Due date';

  @override
  String get todoNoDeadline => 'No deadline';

  @override
  String get todoSet => 'Set';

  @override
  String get todoChange => 'Change';

  @override
  String get todoReminder => 'Local reminder';

  @override
  String get todoReminderHint => 'Send a notification when the task is due';

  @override
  String get todoReminderOn => 'Reminder on';

  @override
  String todoTodayAt(String time) {
    return 'Today $time';
  }

  @override
  String get notesTitle => 'Notes';

  @override
  String get notesEmpty => 'No notes yet';

  @override
  String get notesEmptyHint => 'Tap + to create your first note';

  @override
  String get notesSearchHint => 'Search notes...';

  @override
  String get notesNew => 'New Note';

  @override
  String get notesEdit => 'Edit Note';

  @override
  String get notesTitleHint => 'Title (optional)';

  @override
  String get notesContentHint => 'Start writing...';

  @override
  String get notesSaved => 'Saved';

  @override
  String get notesDelete => 'Delete';

  @override
  String get notesDeleteConfirm => 'Delete this note?';

  @override
  String get notesMarkdownPreview => 'Preview';

  @override
  String get notesMarkdownEdit => 'Edit';

  @override
  String get notesPinned => 'Pinned';

  @override
  String get notesPin => 'Pin';

  @override
  String get notesUnpin => 'Unpin';

  @override
  String get notesShare => 'Share';

  @override
  String get notesExport => 'Export';

  @override
  String notesCount(int count) {
    return '$count notes';
  }

  @override
  String notesLastEdited(String time) {
    return 'Edited $time';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'Follow System';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'Follow System';

  @override
  String get settingsClipboard => 'Clipboard';

  @override
  String get settingsMaxHistory => 'Max History Items';

  @override
  String get settingsAutoDelete => 'Auto Delete After';

  @override
  String get settingsAutoDeleteNever => 'Never';

  @override
  String get settingsAutoDelete7d => '7 days';

  @override
  String get settingsAutoDelete30d => '30 days';

  @override
  String get settingsAutoDelete90d => '90 days';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsExportAll => 'Export all data (JSON)';

  @override
  String get settingsProUpgradeTitle => 'Upgrade to Pro';

  @override
  String get settingsProUnlockedTitle => 'Pro unlocked';

  @override
  String get settingsProUnlockedSubtitle =>
      'One-time unlock active on this device.';

  @override
  String get settingsProLockedSubtitle =>
      'Get full backup export and larger clipboard history.';

  @override
  String get settingsProHistoryLocked =>
      'Upgrade to Pro to unlock larger history limits.';

  @override
  String get proTitle => 'Upgrade to Pro';

  @override
  String get proHeroActive => 'Pro is active';

  @override
  String get proHeroInactive => 'Own ClipNote once';

  @override
  String get proHeroSubtitle =>
      'One-time unlock. No subscription. No cloud. No tracking.';

  @override
  String get proFeatureFullBackup => 'Full backup export';

  @override
  String get proFeatureHistory => 'Higher clipboard limits';

  @override
  String get proFeatureFutureAi => 'Future AI tools';

  @override
  String get proFeatureFutureVault => 'Future encrypted vault';

  @override
  String get proSectionFree => 'What is in Free';

  @override
  String get proFreeCoreTitle => 'Core offline workflow';

  @override
  String get proFreeCoreSubtitle =>
      'Clipboard history, notes, todos, reminders, JSON/TXT exports.';

  @override
  String get proFreeAccountTitle => 'No account required';

  @override
  String get proFreeAccountSubtitle =>
      'All data stays on-device and works offline.';

  @override
  String get proSectionPaid => 'What Pro unlocks';

  @override
  String get proPaidBackupTitle => 'Full workspace backup';

  @override
  String get proPaidBackupSubtitle =>
      'Export a single .clipnote package of notes, tasks, and clipboard.';

  @override
  String get proPaidHistoryTitle => 'Large clipboard history';

  @override
  String get proPaidHistorySubtitle => 'Unlock up to 2000 item history.';

  @override
  String get proPaidFutureTitle => 'AI and encrypted vault';

  @override
  String get proPaidFutureSubtitle =>
      'Reserved for future releases at no extra recurring cost.';

  @override
  String get proAlreadyUnlocked => 'Already unlocked';

  @override
  String proUnlockForPrice(String price) {
    return 'Unlock Pro for $price';
  }

  @override
  String get proUnlockInStore => 'Unlock Pro in Google Play';

  @override
  String get proRestorePurchase => 'Restore purchase';

  @override
  String get proRestorePurchaseSuccess => 'Purchase restored successfully!';

  @override
  String get proRestorePurchaseNotFound => 'No previous purchase found.';

  @override
  String get proDebugSimulate => 'Debug: simulate Pro unlock';

  @override
  String get proDebugRemove => 'Debug: remove Pro';

  @override
  String get proStoreUnavailable =>
      'Google Play is not available on this device.';

  @override
  String get proProductUnavailable => 'Pro product is not configured yet.';

  @override
  String get settingsImportBackupTitle => 'Import backup';

  @override
  String get settingsImportBackupSubtitle =>
      'Restore clipboard, notes, tasks, and optional settings from a backup file.';

  @override
  String get settingsFullBackupTitle => 'Export full backup (.clipnote)';

  @override
  String get settingsFullBackupSubtitlePro =>
      'App-specific full backup for restore and migration.';

  @override
  String get settingsFullBackupSubtitleFree =>
      'App-specific restore backup. Pro feature, or watch an ad to unlock once.';

  @override
  String get settingsUnlockFullBackupTitle => 'Unlock full backup';

  @override
  String get settingsUnlockFullBackupBody =>
      'Watch a short ad to unlock one full backup export, or upgrade to Pro for permanent access.';

  @override
  String get settingsAdNotReady =>
      'Ad is not ready yet. Please try again in a moment.';

  @override
  String get settingsImportMode => 'Import mode';

  @override
  String get settingsImportMerge => 'Merge';

  @override
  String get settingsImportReplace => 'Replace';

  @override
  String get settingsImportModeMergeHint =>
      'Keeps current data and adds new items.';

  @override
  String get settingsImportModeReplaceHint =>
      'Clears current data before import.';

  @override
  String get settingsImportSettingsToo => 'Import settings too';

  @override
  String get settingsImportHasSettings => 'Includes app settings';

  @override
  String get settingsImportNoSettings => 'No settings in this backup';

  @override
  String get settingsImportNow => 'Import now';

  @override
  String settingsImportedSummary(
      int clipboardCount, int noteCount, int todoCount, String settingsSuffix) {
    return 'Imported $clipboardCount clipboard items, $noteCount notes, and $todoCount tasks$settingsSuffix.';
  }

  @override
  String get settingsImportedWithSettingsSuffix => ' with settings';

  @override
  String get settingsImportedWithoutSettingsSuffix => '';

  @override
  String get settingsSelectBackupFileError =>
      'Please select a .clipnote or .json backup file.';

  @override
  String settingsImportFailed(String error) {
    return 'Import failed: $error';
  }

  @override
  String get settingsExportSuccess => 'Exported successfully';

  @override
  String get settingsClearClipboard => 'Clear Clipboard History';

  @override
  String get settingsClearNotes => 'Clear All Notes';

  @override
  String get settingsClearNotesConfirm =>
      'Delete all notes? This cannot be undone.';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsPrivacyNote =>
      'All data is stored locally on your device. Nothing is ever uploaded to the cloud.';

  @override
  String get settingsPrivacyTitle => 'Privacy First';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionSave => 'Save';

  @override
  String get actionClose => 'Close';

  @override
  String get actionDone => 'Done';

  @override
  String get actionUpgrade => 'Upgrade';

  @override
  String get actionWatchAd => 'Watch ad';

  @override
  String get timeJustNow => 'just now';

  @override
  String get exportFormatJson => 'Export as JSON';

  @override
  String get exportFormatTxt => 'Export as TXT';

  @override
  String get exportFormatMd => 'Export as Markdown';
}
