import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'ClipNote'**
  String get appName;

  /// No description provided for @tabClipboard.
  ///
  /// In en, this message translates to:
  /// **'Clipboard'**
  String get tabClipboard;

  /// No description provided for @tabNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get tabNotes;

  /// No description provided for @tabTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tabTasks;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @clipboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Clipboard History'**
  String get clipboardTitle;

  /// No description provided for @clipboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing copied yet'**
  String get clipboardEmpty;

  /// No description provided for @clipboardEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Copy any text to automatically save it here'**
  String get clipboardEmptyHint;

  /// No description provided for @clipboardSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search clipboard...'**
  String get clipboardSearchHint;

  /// No description provided for @clipboardCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get clipboardCopied;

  /// No description provided for @clipboardPinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get clipboardPinned;

  /// No description provided for @clipboardPin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get clipboardPin;

  /// No description provided for @clipboardUnpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get clipboardUnpin;

  /// No description provided for @clipboardDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get clipboardDelete;

  /// No description provided for @clipboardDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this item?'**
  String get clipboardDeleteConfirm;

  /// No description provided for @clipboardClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clipboardClearAll;

  /// No description provided for @clipboardClearAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear all clipboard history? Pinned items will be kept.'**
  String get clipboardClearAllConfirm;

  /// No description provided for @clipboardItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String clipboardItemsCount(int count);

  /// No description provided for @clipboardShareText.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get clipboardShareText;

  /// No description provided for @clipboardAddNote.
  ///
  /// In en, this message translates to:
  /// **'Save as Note'**
  String get clipboardAddNote;

  /// No description provided for @clipboardFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get clipboardFavorites;

  /// No description provided for @clipboardNoFavorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get clipboardNoFavorites;

  /// No description provided for @clipboardNoFavoritesHint.
  ///
  /// In en, this message translates to:
  /// **'Mark important snippets to keep them handy.'**
  String get clipboardNoFavoritesHint;

  /// No description provided for @clipboardFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get clipboardFavorite;

  /// No description provided for @clipboardUnfavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove favorite'**
  String get clipboardUnfavorite;

  /// No description provided for @clipboardDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Clipboard details'**
  String get clipboardDetailsTitle;

  /// No description provided for @clipboardDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Edit clipboard content'**
  String get clipboardDetailsHint;

  /// No description provided for @clipboardCopyEdited.
  ///
  /// In en, this message translates to:
  /// **'Copy edited text'**
  String get clipboardCopyEdited;

  /// No description provided for @clipboardUpdateRecord.
  ///
  /// In en, this message translates to:
  /// **'Update record'**
  String get clipboardUpdateRecord;

  /// No description provided for @clipboardUpdated.
  ///
  /// In en, this message translates to:
  /// **'Clipboard record updated'**
  String get clipboardUpdated;

  /// No description provided for @clipboardTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get clipboardTypeText;

  /// No description provided for @clipboardTypeUrl.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get clipboardTypeUrl;

  /// No description provided for @todoTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get todoTitle;

  /// No description provided for @todoSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search tasks...'**
  String get todoSearchHint;

  /// No description provided for @todoFilterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todoFilterToday;

  /// No description provided for @todoFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get todoFilterAll;

  /// No description provided for @todoFilterDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get todoFilterDone;

  /// No description provided for @todoEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks stay offline and reminders stay local.'**
  String get todoEmptySubtitle;

  /// No description provided for @todoEmptyToday.
  ///
  /// In en, this message translates to:
  /// **'No tasks for today'**
  String get todoEmptyToday;

  /// No description provided for @todoEmptyDone.
  ///
  /// In en, this message translates to:
  /// **'No completed tasks yet'**
  String get todoEmptyDone;

  /// No description provided for @todoEmptyAll.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get todoEmptyAll;

  /// No description provided for @todoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get todoAdd;

  /// No description provided for @todoNew.
  ///
  /// In en, this message translates to:
  /// **'New Task'**
  String get todoNew;

  /// No description provided for @todoEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get todoEdit;

  /// No description provided for @todoTitleField.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get todoTitleField;

  /// No description provided for @todoDetailsField.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get todoDetailsField;

  /// No description provided for @todoPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get todoPriority;

  /// No description provided for @todoPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get todoPriorityLow;

  /// No description provided for @todoPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get todoPriorityMedium;

  /// No description provided for @todoPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get todoPriorityHigh;

  /// No description provided for @todoDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get todoDueDate;

  /// No description provided for @todoNoDeadline.
  ///
  /// In en, this message translates to:
  /// **'No deadline'**
  String get todoNoDeadline;

  /// No description provided for @todoSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get todoSet;

  /// No description provided for @todoChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get todoChange;

  /// No description provided for @todoReminder.
  ///
  /// In en, this message translates to:
  /// **'Local reminder'**
  String get todoReminder;

  /// No description provided for @todoReminderHint.
  ///
  /// In en, this message translates to:
  /// **'Send a notification when the task is due'**
  String get todoReminderHint;

  /// No description provided for @todoReminderOn.
  ///
  /// In en, this message translates to:
  /// **'Reminder on'**
  String get todoReminderOn;

  /// No description provided for @todoTodayAt.
  ///
  /// In en, this message translates to:
  /// **'Today {time}'**
  String todoTodayAt(String time);

  /// No description provided for @notesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesTitle;

  /// No description provided for @notesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get notesEmpty;

  /// No description provided for @notesEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap + to create your first note'**
  String get notesEmptyHint;

  /// No description provided for @notesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search notes...'**
  String get notesSearchHint;

  /// No description provided for @notesNew.
  ///
  /// In en, this message translates to:
  /// **'New Note'**
  String get notesNew;

  /// No description provided for @notesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Note'**
  String get notesEdit;

  /// No description provided for @notesTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get notesTitleHint;

  /// No description provided for @notesContentHint.
  ///
  /// In en, this message translates to:
  /// **'Start writing...'**
  String get notesContentHint;

  /// No description provided for @notesSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get notesSaved;

  /// No description provided for @notesDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get notesDelete;

  /// No description provided for @notesDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this note?'**
  String get notesDeleteConfirm;

  /// No description provided for @notesMarkdownPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get notesMarkdownPreview;

  /// No description provided for @notesMarkdownEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get notesMarkdownEdit;

  /// No description provided for @notesPinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get notesPinned;

  /// No description provided for @notesPin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get notesPin;

  /// No description provided for @notesUnpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get notesUnpin;

  /// No description provided for @notesShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get notesShare;

  /// No description provided for @notesExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get notesExport;

  /// No description provided for @notesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} notes'**
  String notesCount(int count);

  /// No description provided for @notesLastEdited.
  ///
  /// In en, this message translates to:
  /// **'Edited {time}'**
  String notesLastEdited(String time);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsClipboard.
  ///
  /// In en, this message translates to:
  /// **'Clipboard'**
  String get settingsClipboard;

  /// No description provided for @settingsMaxHistory.
  ///
  /// In en, this message translates to:
  /// **'Max History Items'**
  String get settingsMaxHistory;

  /// No description provided for @settingsAutoDelete.
  ///
  /// In en, this message translates to:
  /// **'Auto Delete After'**
  String get settingsAutoDelete;

  /// No description provided for @settingsAutoDeleteNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get settingsAutoDeleteNever;

  /// No description provided for @settingsAutoDelete7d.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get settingsAutoDelete7d;

  /// No description provided for @settingsAutoDelete30d.
  ///
  /// In en, this message translates to:
  /// **'30 days'**
  String get settingsAutoDelete30d;

  /// No description provided for @settingsAutoDelete90d.
  ///
  /// In en, this message translates to:
  /// **'90 days'**
  String get settingsAutoDelete90d;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsData;

  /// No description provided for @settingsExportAll.
  ///
  /// In en, this message translates to:
  /// **'Export all data (JSON)'**
  String get settingsExportAll;

  /// No description provided for @settingsProUpgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get settingsProUpgradeTitle;

  /// No description provided for @settingsProUnlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Pro unlocked'**
  String get settingsProUnlockedTitle;

  /// No description provided for @settingsProUnlockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One-time unlock active on this device.'**
  String get settingsProUnlockedSubtitle;

  /// No description provided for @settingsProLockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get full backup export and larger clipboard history.'**
  String get settingsProLockedSubtitle;

  /// No description provided for @settingsProHistoryLocked.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro to unlock larger history limits.'**
  String get settingsProHistoryLocked;

  /// No description provided for @proTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get proTitle;

  /// No description provided for @proHeroActive.
  ///
  /// In en, this message translates to:
  /// **'Pro is active'**
  String get proHeroActive;

  /// No description provided for @proHeroInactive.
  ///
  /// In en, this message translates to:
  /// **'Own ClipNote once'**
  String get proHeroInactive;

  /// No description provided for @proHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One-time unlock. No subscription. No cloud. No tracking.'**
  String get proHeroSubtitle;

  /// No description provided for @proFeatureFullBackup.
  ///
  /// In en, this message translates to:
  /// **'Full backup export'**
  String get proFeatureFullBackup;

  /// No description provided for @proFeatureHistory.
  ///
  /// In en, this message translates to:
  /// **'Higher clipboard limits'**
  String get proFeatureHistory;

  /// No description provided for @proFeatureFutureAi.
  ///
  /// In en, this message translates to:
  /// **'Future AI tools'**
  String get proFeatureFutureAi;

  /// No description provided for @proFeatureFutureVault.
  ///
  /// In en, this message translates to:
  /// **'Future encrypted vault'**
  String get proFeatureFutureVault;

  /// No description provided for @proSectionFree.
  ///
  /// In en, this message translates to:
  /// **'What is in Free'**
  String get proSectionFree;

  /// No description provided for @proFreeCoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Core offline workflow'**
  String get proFreeCoreTitle;

  /// No description provided for @proFreeCoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clipboard history, notes, todos, reminders, JSON/TXT exports.'**
  String get proFreeCoreSubtitle;

  /// No description provided for @proFreeAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'No account required'**
  String get proFreeAccountTitle;

  /// No description provided for @proFreeAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All data stays on-device and works offline.'**
  String get proFreeAccountSubtitle;

  /// No description provided for @proSectionPaid.
  ///
  /// In en, this message translates to:
  /// **'What Pro unlocks'**
  String get proSectionPaid;

  /// No description provided for @proPaidBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Full workspace backup'**
  String get proPaidBackupTitle;

  /// No description provided for @proPaidBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export a single .clipnote package of notes, tasks, and clipboard.'**
  String get proPaidBackupSubtitle;

  /// No description provided for @proPaidHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Large clipboard history'**
  String get proPaidHistoryTitle;

  /// No description provided for @proPaidHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock 1000 and 2000 item history caps.'**
  String get proPaidHistorySubtitle;

  /// No description provided for @proPaidFutureTitle.
  ///
  /// In en, this message translates to:
  /// **'AI and encrypted vault'**
  String get proPaidFutureTitle;

  /// No description provided for @proPaidFutureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reserved for future releases at no extra recurring cost.'**
  String get proPaidFutureSubtitle;

  /// No description provided for @proAlreadyUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Already unlocked'**
  String get proAlreadyUnlocked;

  /// No description provided for @proUnlockForPrice.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro for {price}'**
  String proUnlockForPrice(String price);

  /// No description provided for @proUnlockInStore.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro in Google Play'**
  String get proUnlockInStore;

  /// No description provided for @proRestorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore purchase'**
  String get proRestorePurchase;

  /// No description provided for @proDebugSimulate.
  ///
  /// In en, this message translates to:
  /// **'Debug: simulate Pro unlock'**
  String get proDebugSimulate;

  /// No description provided for @proDebugRemove.
  ///
  /// In en, this message translates to:
  /// **'Debug: remove Pro'**
  String get proDebugRemove;

  /// No description provided for @proStoreUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Google Play is not available on this device.'**
  String get proStoreUnavailable;

  /// No description provided for @proProductUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Pro product is not configured yet.'**
  String get proProductUnavailable;

  /// No description provided for @settingsImportBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Import backup'**
  String get settingsImportBackupTitle;

  /// No description provided for @settingsImportBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore clipboard, notes, tasks, and optional settings from a backup file.'**
  String get settingsImportBackupSubtitle;

  /// No description provided for @settingsFullBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Export full backup (.clipnote)'**
  String get settingsFullBackupTitle;

  /// No description provided for @settingsFullBackupSubtitlePro.
  ///
  /// In en, this message translates to:
  /// **'App-specific full backup for restore and migration.'**
  String get settingsFullBackupSubtitlePro;

  /// No description provided for @settingsFullBackupSubtitleFree.
  ///
  /// In en, this message translates to:
  /// **'App-specific restore backup. Pro feature, or watch an ad to unlock once.'**
  String get settingsFullBackupSubtitleFree;

  /// No description provided for @settingsUnlockFullBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock full backup'**
  String get settingsUnlockFullBackupTitle;

  /// No description provided for @settingsUnlockFullBackupBody.
  ///
  /// In en, this message translates to:
  /// **'Watch a short ad to unlock one full backup export, or upgrade to Pro for permanent access.'**
  String get settingsUnlockFullBackupBody;

  /// No description provided for @settingsAdNotReady.
  ///
  /// In en, this message translates to:
  /// **'Ad is not ready yet. Please try again in a moment.'**
  String get settingsAdNotReady;

  /// No description provided for @settingsImportMode.
  ///
  /// In en, this message translates to:
  /// **'Import mode'**
  String get settingsImportMode;

  /// No description provided for @settingsImportMerge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get settingsImportMerge;

  /// No description provided for @settingsImportReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get settingsImportReplace;

  /// No description provided for @settingsImportModeMergeHint.
  ///
  /// In en, this message translates to:
  /// **'Keeps current data and adds new items.'**
  String get settingsImportModeMergeHint;

  /// No description provided for @settingsImportModeReplaceHint.
  ///
  /// In en, this message translates to:
  /// **'Clears current data before import.'**
  String get settingsImportModeReplaceHint;

  /// No description provided for @settingsImportSettingsToo.
  ///
  /// In en, this message translates to:
  /// **'Import settings too'**
  String get settingsImportSettingsToo;

  /// No description provided for @settingsImportHasSettings.
  ///
  /// In en, this message translates to:
  /// **'Includes app settings'**
  String get settingsImportHasSettings;

  /// No description provided for @settingsImportNoSettings.
  ///
  /// In en, this message translates to:
  /// **'No settings in this backup'**
  String get settingsImportNoSettings;

  /// No description provided for @settingsImportNow.
  ///
  /// In en, this message translates to:
  /// **'Import now'**
  String get settingsImportNow;

  /// No description provided for @settingsImportedSummary.
  ///
  /// In en, this message translates to:
  /// **'Imported {clipboardCount} clipboard items, {noteCount} notes, and {todoCount} tasks{settingsSuffix}.'**
  String settingsImportedSummary(
      int clipboardCount, int noteCount, int todoCount, String settingsSuffix);

  /// No description provided for @settingsImportedWithSettingsSuffix.
  ///
  /// In en, this message translates to:
  /// **' with settings'**
  String get settingsImportedWithSettingsSuffix;

  /// No description provided for @settingsImportedWithoutSettingsSuffix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get settingsImportedWithoutSettingsSuffix;

  /// No description provided for @settingsSelectBackupFileError.
  ///
  /// In en, this message translates to:
  /// **'Please select a .clipnote or .json backup file.'**
  String get settingsSelectBackupFileError;

  /// No description provided for @settingsImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String settingsImportFailed(String error);

  /// No description provided for @settingsExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exported successfully'**
  String get settingsExportSuccess;

  /// No description provided for @settingsClearClipboard.
  ///
  /// In en, this message translates to:
  /// **'Clear Clipboard History'**
  String get settingsClearClipboard;

  /// No description provided for @settingsClearNotes.
  ///
  /// In en, this message translates to:
  /// **'Clear All Notes'**
  String get settingsClearNotes;

  /// No description provided for @settingsClearNotesConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all notes? This cannot be undone.'**
  String get settingsClearNotesConfirm;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'All data is stored locally on your device. Nothing is ever uploaded to the cloud.'**
  String get settingsPrivacyNote;

  /// No description provided for @settingsPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy First'**
  String get settingsPrivacyTitle;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get actionUpgrade;

  /// No description provided for @actionWatchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch ad'**
  String get actionWatchAd;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get timeJustNow;

  /// No description provided for @exportFormatJson.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get exportFormatJson;

  /// No description provided for @exportFormatTxt.
  ///
  /// In en, this message translates to:
  /// **'Export as TXT'**
  String get exportFormatTxt;

  /// No description provided for @exportFormatMd.
  ///
  /// In en, this message translates to:
  /// **'Export as Markdown'**
  String get exportFormatMd;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
