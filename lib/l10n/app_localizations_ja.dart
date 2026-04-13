// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'ClipNote';

  @override
  String get tabClipboard => 'クリップボード';

  @override
  String get tabNotes => 'ノート';

  @override
  String get tabTasks => 'タスク';

  @override
  String get tabSettings => '設定';

  @override
  String get clipboardTitle => 'クリップボード履歴';

  @override
  String get clipboardEmpty => 'まだコピーされていません';

  @override
  String get clipboardEmptyHint => 'テキストをコピーすると自動的に保存されます';

  @override
  String get clipboardSearchHint => 'クリップボードを検索...';

  @override
  String get clipboardCopied => 'コピーしました！';

  @override
  String get clipboardPinned => 'ピン留め済み';

  @override
  String get clipboardPin => 'ピン留め';

  @override
  String get clipboardUnpin => 'ピン留め解除';

  @override
  String get clipboardDelete => '削除';

  @override
  String get clipboardDeleteConfirm => 'このアイテムを削除しますか？';

  @override
  String get clipboardClearAll => 'すべてクリア';

  @override
  String get clipboardClearAllConfirm =>
      'クリップボードの履歴をすべてクリアしますか？ピン留めされたアイテムは保持されます。';

  @override
  String clipboardItemsCount(int count) {
    return '$count 件';
  }

  @override
  String get clipboardShareText => '共有';

  @override
  String get clipboardAddNote => 'ノートとして保存';

  @override
  String get clipboardFavorites => 'お気に入り';

  @override
  String get clipboardNoFavorites => 'お気に入りはまだありません';

  @override
  String get clipboardNoFavoritesHint => '大事な内容をお気に入りにしてすぐ見つけられるようにしましょう。';

  @override
  String get clipboardFavorite => 'お気に入り';

  @override
  String get clipboardUnfavorite => 'お気に入り解除';

  @override
  String get clipboardDetailsTitle => 'クリップボード詳細';

  @override
  String get clipboardDetailsHint => 'クリップボード内容を編集';

  @override
  String get clipboardCopyEdited => '編集後の内容をコピー';

  @override
  String get clipboardUpdateRecord => '記録を更新';

  @override
  String get clipboardUpdated => 'クリップボード記録を更新しました';

  @override
  String get clipboardTypeText => 'テキスト';

  @override
  String get clipboardTypeUrl => 'URL';

  @override
  String get todoTitle => 'タスク';

  @override
  String get todoSearchHint => 'タスクを検索...';

  @override
  String get todoFilterToday => '今日';

  @override
  String get todoFilterAll => 'すべて';

  @override
  String get todoFilterDone => '完了';

  @override
  String get todoEmptySubtitle => 'タスクもリマインダーもローカルのままです。';

  @override
  String get todoEmptyToday => '今日のタスクはありません';

  @override
  String get todoEmptyDone => '完了済みタスクはまだありません';

  @override
  String get todoEmptyAll => 'タスクはまだありません';

  @override
  String get todoAdd => 'タスクを追加';

  @override
  String get todoNew => '新しいタスク';

  @override
  String get todoEdit => 'タスクを編集';

  @override
  String get todoTitleField => 'タスク名';

  @override
  String get todoDetailsField => '詳細';

  @override
  String get todoPriority => '優先度';

  @override
  String get todoPriorityLow => '低';

  @override
  String get todoPriorityMedium => '中';

  @override
  String get todoPriorityHigh => '高';

  @override
  String get todoDueDate => '期限';

  @override
  String get todoNoDeadline => '期限なし';

  @override
  String get todoSet => '設定';

  @override
  String get todoChange => '変更';

  @override
  String get todoReminder => 'ローカル通知';

  @override
  String get todoReminderHint => 'タスク期限時に通知を送信';

  @override
  String get todoReminderOn => '通知オン';

  @override
  String todoTodayAt(String time) {
    return '今日 $time';
  }

  @override
  String get notesTitle => 'ノート';

  @override
  String get notesEmpty => 'ノートがありません';

  @override
  String get notesEmptyHint => '+ をタップして最初のノートを作成';

  @override
  String get notesSearchHint => 'ノートを検索...';

  @override
  String get notesNew => '新しいノート';

  @override
  String get notesEdit => 'ノートを編集';

  @override
  String get notesTitleHint => 'タイトル（任意）';

  @override
  String get notesContentHint => '書き始めましょう...';

  @override
  String get notesSaved => '保存しました';

  @override
  String get notesDelete => '削除';

  @override
  String get notesDeleteConfirm => 'このノートを削除しますか？';

  @override
  String get notesMarkdownPreview => 'プレビュー';

  @override
  String get notesMarkdownEdit => '編集';

  @override
  String get notesPinned => 'ピン留め済み';

  @override
  String get notesPin => 'ピン留め';

  @override
  String get notesUnpin => 'ピン留め解除';

  @override
  String get notesShare => '共有';

  @override
  String get notesExport => 'エクスポート';

  @override
  String notesCount(int count) {
    return '$count 件のノート';
  }

  @override
  String notesLastEdited(String time) {
    return '$time に編集';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageSystem => 'システムに従う';

  @override
  String get settingsTheme => 'テーマ';

  @override
  String get settingsThemeLight => 'ライト';

  @override
  String get settingsThemeDark => 'ダーク';

  @override
  String get settingsThemeSystem => 'システムに従う';

  @override
  String get settingsClipboard => 'クリップボード';

  @override
  String get settingsMaxHistory => '最大履歴件数';

  @override
  String get settingsAutoDelete => '自動削除';

  @override
  String get settingsAutoDeleteNever => 'しない';

  @override
  String get settingsAutoDelete7d => '7日後';

  @override
  String get settingsAutoDelete30d => '30日後';

  @override
  String get settingsAutoDelete90d => '90日後';

  @override
  String get settingsData => 'データ';

  @override
  String get settingsExportAll => 'すべてのデータをエクスポート (JSON)';

  @override
  String get settingsProUpgradeTitle => 'Pro にアップグレード';

  @override
  String get settingsProUnlockedTitle => 'Pro が有効です';

  @override
  String get settingsProUnlockedSubtitle => 'この端末では買い切り解除が有効です。';

  @override
  String get settingsProLockedSubtitle => '完全バックアップ書き出しとより大きな履歴数を解放します。';

  @override
  String get settingsProHistoryLocked => 'より大きな履歴数を解放するには Pro にアップグレードしてください。';

  @override
  String get proTitle => 'Pro にアップグレード';

  @override
  String get proHeroActive => 'Pro が有効です';

  @override
  String get proHeroInactive => 'ClipNote を買い切りで所有';

  @override
  String get proHeroSubtitle => '一度きりの解放。サブスクなし。クラウドなし。追跡なし。';

  @override
  String get proFeatureFullBackup => '完全バックアップ書き出し';

  @override
  String get proFeatureHistory => 'より大きなクリップボード容量';

  @override
  String get proFeatureFutureAi => '今後の AI ツール';

  @override
  String get proFeatureFutureVault => '今後の暗号化ボルト';

  @override
  String get proSectionFree => '無料版に含まれるもの';

  @override
  String get proFreeCoreTitle => 'コアのオフライン作業フロー';

  @override
  String get proFreeCoreSubtitle => 'クリップボード履歴、ノート、タスク、通知、JSON/TXT エクスポート。';

  @override
  String get proFreeAccountTitle => 'アカウント不要';

  @override
  String get proFreeAccountSubtitle => 'すべてのデータは端末内に保存され、オフラインで使えます。';

  @override
  String get proSectionPaid => 'Pro で解放されるもの';

  @override
  String get proPaidBackupTitle => 'ワークスペース全体のバックアップ';

  @override
  String get proPaidBackupSubtitle =>
      'ノート、タスク、クリップボードを含む単一の .clipnote パッケージを書き出します。';

  @override
  String get proPaidHistoryTitle => '大きなクリップボード履歴';

  @override
  String get proPaidHistorySubtitle => '履歴上限 1000 件と 2000 件を解放します。';

  @override
  String get proPaidFutureTitle => 'AI と暗号化ボルト';

  @override
  String get proPaidFutureSubtitle => '将来のリリースで追加料金なしで提供予定です。';

  @override
  String get proAlreadyUnlocked => 'すでに解放済み';

  @override
  String proUnlockForPrice(String price) {
    return '$price で Pro を解放';
  }

  @override
  String get proUnlockInStore => 'Google Play で Pro を解放';

  @override
  String get proRestorePurchase => '購入を復元';

  @override
  String get proDebugSimulate => 'デバッグ: Pro 解放をシミュレート';

  @override
  String get proDebugRemove => 'デバッグ: Pro を削除';

  @override
  String get proStoreUnavailable => 'この端末では Google Play を利用できません。';

  @override
  String get proProductUnavailable => 'Pro 商品はまだ設定されていません。';

  @override
  String get settingsImportBackupTitle => 'バックアップをインポート';

  @override
  String get settingsImportBackupSubtitle =>
      'バックアップファイルからクリップボード、ノート、タスク、任意の設定を復元します。';

  @override
  String get settingsFullBackupTitle => '完全バックアップを書き出し (.clipnote)';

  @override
  String get settingsFullBackupSubtitlePro => '復元と移行のためのアプリ専用完全バックアップです。';

  @override
  String get settingsFullBackupSubtitleFree =>
      'アプリ専用の復元バックアップです。Pro 機能、または広告視聴で1回解放。';

  @override
  String get settingsUnlockFullBackupTitle => '完全バックアップを解放';

  @override
  String get settingsUnlockFullBackupBody =>
      '短い広告を視聴すると完全バックアップ書き出しを1回解放できます。Pro にアップグレードすると恒久的に利用できます。';

  @override
  String get settingsAdNotReady => '広告の準備ができていません。少し待ってから再試行してください。';

  @override
  String get settingsImportMode => 'インポート方法';

  @override
  String get settingsImportMerge => 'マージ';

  @override
  String get settingsImportReplace => '置き換え';

  @override
  String get settingsImportModeMergeHint => '現在のデータを残し、新しい項目を追加します。';

  @override
  String get settingsImportModeReplaceHint => 'インポート前に現在のデータを消去します。';

  @override
  String get settingsImportSettingsToo => '設定もインポート';

  @override
  String get settingsImportHasSettings => 'アプリ設定を含む';

  @override
  String get settingsImportNoSettings => 'このバックアップには設定が含まれていません';

  @override
  String get settingsImportNow => '今すぐインポート';

  @override
  String settingsImportedSummary(
      int clipboardCount, int noteCount, int todoCount, String settingsSuffix) {
    return 'クリップボード $clipboardCount 件、ノート $noteCount 件、タスク $todoCount 件をインポートしました$settingsSuffix。';
  }

  @override
  String get settingsImportedWithSettingsSuffix => '（設定を含む）';

  @override
  String get settingsImportedWithoutSettingsSuffix => '';

  @override
  String get settingsSelectBackupFileError =>
      '.clipnote または .json のバックアップファイルを選択してください。';

  @override
  String settingsImportFailed(String error) {
    return 'インポートに失敗しました: $error';
  }

  @override
  String get settingsExportSuccess => 'エクスポート成功';

  @override
  String get settingsClearClipboard => 'クリップボード履歴をクリア';

  @override
  String get settingsClearNotes => 'すべてのノートをクリア';

  @override
  String get settingsClearNotesConfirm => 'すべてのノートを削除しますか？この操作は元に戻せません。';

  @override
  String get settingsAbout => 'アプリについて';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get settingsPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get settingsPrivacyNote =>
      'すべてのデータはデバイスにローカルで保存されます。クラウドにアップロードされることはありません。';

  @override
  String get settingsPrivacyTitle => 'プライバシー最優先';

  @override
  String get actionCancel => 'キャンセル';

  @override
  String get actionConfirm => '確認';

  @override
  String get actionDelete => '削除';

  @override
  String get actionSave => '保存';

  @override
  String get actionClose => '閉じる';

  @override
  String get actionDone => '完了';

  @override
  String get actionUpgrade => 'アップグレード';

  @override
  String get actionWatchAd => '広告を見る';

  @override
  String get timeJustNow => 'たった今';

  @override
  String get exportFormatJson => 'JSONでエクスポート';

  @override
  String get exportFormatTxt => 'TXTでエクスポート';

  @override
  String get exportFormatMd => 'Markdownでエクスポート';
}
