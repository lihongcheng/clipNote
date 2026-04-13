// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'ClipNote';

  @override
  String get tabClipboard => '剪贴板';

  @override
  String get tabNotes => '笔记';

  @override
  String get tabTasks => '任务';

  @override
  String get tabSettings => '设置';

  @override
  String get clipboardTitle => '剪贴板历史';

  @override
  String get clipboardEmpty => '还没有复制任何内容';

  @override
  String get clipboardEmptyHint => '复制任意文字后将自动保存在这里';

  @override
  String get clipboardSearchHint => '搜索剪贴板...';

  @override
  String get clipboardCopied => '已复制！';

  @override
  String get clipboardPinned => '已置顶';

  @override
  String get clipboardPin => '置顶';

  @override
  String get clipboardUnpin => '取消置顶';

  @override
  String get clipboardDelete => '删除';

  @override
  String get clipboardDeleteConfirm => '删除此条目？';

  @override
  String get clipboardClearAll => '清空全部';

  @override
  String get clipboardClearAllConfirm => '清空所有剪贴板历史？置顶内容将被保留。';

  @override
  String clipboardItemsCount(int count) {
    return '$count 条记录';
  }

  @override
  String get clipboardShareText => '分享';

  @override
  String get clipboardAddNote => '保存为笔记';

  @override
  String get clipboardFavorites => '收藏';

  @override
  String get clipboardNoFavorites => '还没有收藏';

  @override
  String get clipboardNoFavoritesHint => '把重要片段标为收藏，方便以后快速找到。';

  @override
  String get clipboardFavorite => '收藏';

  @override
  String get clipboardUnfavorite => '取消收藏';

  @override
  String get clipboardDetailsTitle => '剪贴板详情';

  @override
  String get clipboardDetailsHint => '编辑剪贴板内容';

  @override
  String get clipboardCopyEdited => '复制修改后内容';

  @override
  String get clipboardUpdateRecord => '更新记录';

  @override
  String get clipboardUpdated => '剪贴板记录已更新';

  @override
  String get clipboardTypeText => '文本';

  @override
  String get clipboardTypeUrl => '链接';

  @override
  String get todoTitle => '任务';

  @override
  String get todoSearchHint => '搜索任务...';

  @override
  String get todoFilterToday => '今天';

  @override
  String get todoFilterAll => '全部';

  @override
  String get todoFilterDone => '已完成';

  @override
  String get todoEmptySubtitle => '任务和提醒都只保存在本地。';

  @override
  String get todoEmptyToday => '今天没有任务';

  @override
  String get todoEmptyDone => '还没有已完成任务';

  @override
  String get todoEmptyAll => '还没有任务';

  @override
  String get todoAdd => '添加任务';

  @override
  String get todoNew => '新建任务';

  @override
  String get todoEdit => '编辑任务';

  @override
  String get todoTitleField => '任务标题';

  @override
  String get todoDetailsField => '详情';

  @override
  String get todoPriority => '优先级';

  @override
  String get todoPriorityLow => '低';

  @override
  String get todoPriorityMedium => '中';

  @override
  String get todoPriorityHigh => '高';

  @override
  String get todoDueDate => '截止时间';

  @override
  String get todoNoDeadline => '没有截止时间';

  @override
  String get todoSet => '设置';

  @override
  String get todoChange => '更改';

  @override
  String get todoReminder => '本地提醒';

  @override
  String get todoReminderHint => '任务到期时发送通知提醒';

  @override
  String get todoReminderOn => '提醒已开启';

  @override
  String todoTodayAt(String time) {
    return '今天 $time';
  }

  @override
  String get notesTitle => '笔记';

  @override
  String get notesEmpty => '还没有笔记';

  @override
  String get notesEmptyHint => '点击 + 创建第一条笔记';

  @override
  String get notesSearchHint => '搜索笔记...';

  @override
  String get notesNew => '新建笔记';

  @override
  String get notesEdit => '编辑笔记';

  @override
  String get notesTitleHint => '标题（可选）';

  @override
  String get notesContentHint => '开始写作...';

  @override
  String get notesSaved => '已保存';

  @override
  String get notesDelete => '删除';

  @override
  String get notesDeleteConfirm => '删除此笔记？';

  @override
  String get notesMarkdownPreview => '预览';

  @override
  String get notesMarkdownEdit => '编辑';

  @override
  String get notesPinned => '已置顶';

  @override
  String get notesPin => '置顶';

  @override
  String get notesUnpin => '取消置顶';

  @override
  String get notesShare => '分享';

  @override
  String get notesExport => '导出';

  @override
  String notesCount(int count) {
    return '$count 条笔记';
  }

  @override
  String notesLastEdited(String time) {
    return '编辑于 $time';
  }

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeLight => '浅色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsThemeSystem => '跟随系统';

  @override
  String get settingsClipboard => '剪贴板';

  @override
  String get settingsMaxHistory => '最大历史条数';

  @override
  String get settingsAutoDelete => '自动删除时间';

  @override
  String get settingsAutoDeleteNever => '从不';

  @override
  String get settingsAutoDelete7d => '7 天';

  @override
  String get settingsAutoDelete30d => '30 天';

  @override
  String get settingsAutoDelete90d => '90 天';

  @override
  String get settingsData => '数据';

  @override
  String get settingsExportAll => '导出所有数据（JSON）';

  @override
  String get settingsProUpgradeTitle => '升级到 Pro';

  @override
  String get settingsProUnlockedTitle => 'Pro 已解锁';

  @override
  String get settingsProUnlockedSubtitle => '当前设备已启用一次性买断解锁。';

  @override
  String get settingsProLockedSubtitle => '解锁完整备份导出和更大的剪贴板历史容量。';

  @override
  String get settingsProHistoryLocked => '升级到 Pro 以解锁更大的历史容量。';

  @override
  String get proTitle => '升级到 Pro';

  @override
  String get proHeroActive => 'Pro 已启用';

  @override
  String get proHeroInactive => '一次买断 ClipNote';

  @override
  String get proHeroSubtitle => '一次性解锁，无订阅，无云端，无跟踪。';

  @override
  String get proFeatureFullBackup => '完整备份导出';

  @override
  String get proFeatureHistory => '更高的剪贴板容量';

  @override
  String get proFeatureFutureAi => '未来 AI 工具';

  @override
  String get proFeatureFutureVault => '未来加密保险箱';

  @override
  String get proSectionFree => '免费版包含';

  @override
  String get proFreeCoreTitle => '核心离线工作流';

  @override
  String get proFreeCoreSubtitle => '剪贴板历史、笔记、任务、提醒、JSON/TXT 导出。';

  @override
  String get proFreeAccountTitle => '无需账号';

  @override
  String get proFreeAccountSubtitle => '所有数据都只保存在设备本地，可离线使用。';

  @override
  String get proSectionPaid => 'Pro 解锁内容';

  @override
  String get proPaidBackupTitle => '完整工作区备份';

  @override
  String get proPaidBackupSubtitle => '导出单个 .clipnote 包，包含笔记、任务和剪贴板。';

  @override
  String get proPaidHistoryTitle => '更大的剪贴板历史';

  @override
  String get proPaidHistorySubtitle => '解锁最高2000条剪贴板历史。';

  @override
  String get proPaidFutureTitle => 'AI 和加密保险箱';

  @override
  String get proPaidFutureSubtitle => '后续版本直接开放，无额外持续收费。';

  @override
  String get proAlreadyUnlocked => '已解锁';

  @override
  String proUnlockForPrice(String price) {
    return '以 $price 解锁 Pro';
  }

  @override
  String get proUnlockInStore => '前往 Google Play 解锁 Pro';

  @override
  String get proRestorePurchase => '恢复购买';

  @override
  String get proRestorePurchaseSuccess => '购买已恢复！';

  @override
  String get proRestorePurchaseNotFound => '未找到购买记录。';

  @override
  String get proDebugSimulate => '调试：模拟解锁 Pro';

  @override
  String get proDebugRemove => '调试：移除 Pro';

  @override
  String get proStoreUnavailable => '当前设备无法使用 Google Play。';

  @override
  String get proProductUnavailable => 'Pro 商品暂时还没有配置好。';

  @override
  String get settingsImportBackupTitle => '导入备份';

  @override
  String get settingsImportBackupSubtitle => '从备份文件恢复剪贴板、笔记、任务，以及可选的设置。';

  @override
  String get settingsFullBackupTitle => '导出完整备份（.clipnote）';

  @override
  String get settingsFullBackupSubtitlePro => '用于恢复和迁移的应用专用完整备份。';

  @override
  String get settingsFullBackupSubtitleFree => '应用专用恢复备份。Pro 功能，或看一次广告解锁一次。';

  @override
  String get settingsUnlockFullBackupTitle => '解锁完整备份';

  @override
  String get settingsUnlockFullBackupBody =>
      '观看一段短广告可解锁一次完整备份导出，或升级到 Pro 获得永久权限。';

  @override
  String get settingsAdNotReady => '广告暂时还没准备好，请稍后再试。';

  @override
  String get settingsImportMode => '导入方式';

  @override
  String get settingsImportMerge => '合并';

  @override
  String get settingsImportReplace => '替换';

  @override
  String get settingsImportModeMergeHint => '保留当前数据，并新增备份中的内容。';

  @override
  String get settingsImportModeReplaceHint => '导入前先清空当前数据。';

  @override
  String get settingsImportSettingsToo => '同时导入设置';

  @override
  String get settingsImportHasSettings => '包含应用设置';

  @override
  String get settingsImportNoSettings => '这个备份不包含设置';

  @override
  String get settingsImportNow => '立即导入';

  @override
  String settingsImportedSummary(
      int clipboardCount, int noteCount, int todoCount, String settingsSuffix) {
    return '已导入 $clipboardCount 条剪贴板、$noteCount 条笔记和 $todoCount 条任务$settingsSuffix。';
  }

  @override
  String get settingsImportedWithSettingsSuffix => '，并恢复设置';

  @override
  String get settingsImportedWithoutSettingsSuffix => '';

  @override
  String get settingsSelectBackupFileError => '请选择 .clipnote 或 .json 备份文件。';

  @override
  String settingsImportFailed(String error) {
    return '导入失败：$error';
  }

  @override
  String get settingsExportSuccess => '导出成功';

  @override
  String get settingsClearClipboard => '清空剪贴板历史';

  @override
  String get settingsClearNotes => '清空所有笔记';

  @override
  String get settingsClearNotesConfirm => '删除所有笔记？此操作无法撤销。';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsPrivacyPolicy => '隐私政策';

  @override
  String get settingsPrivacyNote => '所有数据均存储在您的设备本地，不会上传到云端。';

  @override
  String get settingsPrivacyTitle => '隐私第一';

  @override
  String get actionCancel => '取消';

  @override
  String get actionConfirm => '确认';

  @override
  String get actionDelete => '删除';

  @override
  String get actionSave => '保存';

  @override
  String get actionClose => '关闭';

  @override
  String get actionDone => '完成';

  @override
  String get actionUpgrade => '升级';

  @override
  String get actionWatchAd => '看广告';

  @override
  String get timeJustNow => '刚刚';

  @override
  String get exportFormatJson => '导出为 JSON';

  @override
  String get exportFormatTxt => '导出为 TXT';

  @override
  String get exportFormatMd => '导出为 Markdown';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appName => 'ClipNote';

  @override
  String get tabClipboard => '剪貼簿';

  @override
  String get tabNotes => '筆記';

  @override
  String get tabTasks => '任務';

  @override
  String get tabSettings => '設定';

  @override
  String get clipboardTitle => '剪貼簿歷史';

  @override
  String get clipboardEmpty => '尚未複製任何內容';

  @override
  String get clipboardEmptyHint => '複製任意文字後將自動儲存在此';

  @override
  String get clipboardSearchHint => '搜尋剪貼簿...';

  @override
  String get clipboardCopied => '已複製！';

  @override
  String get clipboardPinned => '已釘選';

  @override
  String get clipboardPin => '釘選';

  @override
  String get clipboardUnpin => '取消釘選';

  @override
  String get clipboardDelete => '刪除';

  @override
  String get clipboardDeleteConfirm => '刪除此項目？';

  @override
  String get clipboardClearAll => '清空全部';

  @override
  String get clipboardClearAllConfirm => '清空所有剪貼簿歷史？釘選的內容將被保留。';

  @override
  String clipboardItemsCount(int count) {
    return '$count 筆記錄';
  }

  @override
  String get clipboardShareText => '分享';

  @override
  String get clipboardAddNote => '儲存為筆記';

  @override
  String get clipboardFavorites => '收藏';

  @override
  String get clipboardNoFavorites => '還沒有收藏';

  @override
  String get clipboardNoFavoritesHint => '把重要片段標成收藏，方便之後快速找到。';

  @override
  String get clipboardFavorite => '收藏';

  @override
  String get clipboardUnfavorite => '取消收藏';

  @override
  String get clipboardDetailsTitle => '剪貼簿詳情';

  @override
  String get clipboardDetailsHint => '編輯剪貼簿內容';

  @override
  String get clipboardCopyEdited => '複製修改後內容';

  @override
  String get clipboardUpdateRecord => '更新記錄';

  @override
  String get clipboardUpdated => '剪貼簿記錄已更新';

  @override
  String get clipboardTypeText => '文字';

  @override
  String get clipboardTypeUrl => '連結';

  @override
  String get todoTitle => '任務';

  @override
  String get todoSearchHint => '搜尋任務...';

  @override
  String get todoFilterToday => '今天';

  @override
  String get todoFilterAll => '全部';

  @override
  String get todoFilterDone => '已完成';

  @override
  String get todoEmptySubtitle => '任務和提醒都只儲存在本機。';

  @override
  String get todoEmptyToday => '今天沒有任務';

  @override
  String get todoEmptyDone => '還沒有已完成任務';

  @override
  String get todoEmptyAll => '還沒有任務';

  @override
  String get todoAdd => '新增任務';

  @override
  String get todoNew => '新增任務';

  @override
  String get todoEdit => '編輯任務';

  @override
  String get todoTitleField => '任務標題';

  @override
  String get todoDetailsField => '詳情';

  @override
  String get todoPriority => '優先級';

  @override
  String get todoPriorityLow => '低';

  @override
  String get todoPriorityMedium => '中';

  @override
  String get todoPriorityHigh => '高';

  @override
  String get todoDueDate => '截止時間';

  @override
  String get todoNoDeadline => '沒有截止時間';

  @override
  String get todoSet => '設定';

  @override
  String get todoChange => '變更';

  @override
  String get todoReminder => '本機提醒';

  @override
  String get todoReminderHint => '任務到期時發送通知提醒';

  @override
  String get todoReminderOn => '提醒已開啟';

  @override
  String todoTodayAt(String time) {
    return '今天 $time';
  }

  @override
  String get notesTitle => '筆記';

  @override
  String get notesEmpty => '尚無筆記';

  @override
  String get notesEmptyHint => '點擊 + 建立第一則筆記';

  @override
  String get notesSearchHint => '搜尋筆記...';

  @override
  String get notesNew => '新增筆記';

  @override
  String get notesEdit => '編輯筆記';

  @override
  String get notesTitleHint => '標題（選填）';

  @override
  String get notesContentHint => '開始書寫...';

  @override
  String get notesSaved => '已儲存';

  @override
  String get notesDelete => '刪除';

  @override
  String get notesDeleteConfirm => '刪除此筆記？';

  @override
  String get notesMarkdownPreview => '預覽';

  @override
  String get notesMarkdownEdit => '編輯';

  @override
  String get notesPinned => '已釘選';

  @override
  String get notesPin => '釘選';

  @override
  String get notesUnpin => '取消釘選';

  @override
  String get notesShare => '分享';

  @override
  String get notesExport => '匯出';

  @override
  String notesCount(int count) {
    return '$count 則筆記';
  }

  @override
  String notesLastEdited(String time) {
    return '編輯於 $time';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLanguage => '語言';

  @override
  String get settingsLanguageSystem => '跟隨系統';

  @override
  String get settingsTheme => '主題';

  @override
  String get settingsThemeLight => '淺色';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsThemeSystem => '跟隨系統';

  @override
  String get settingsClipboard => '剪貼簿';

  @override
  String get settingsMaxHistory => '最大歷史筆數';

  @override
  String get settingsAutoDelete => '自動刪除時間';

  @override
  String get settingsAutoDeleteNever => '從不';

  @override
  String get settingsAutoDelete7d => '7 天';

  @override
  String get settingsAutoDelete30d => '30 天';

  @override
  String get settingsAutoDelete90d => '90 天';

  @override
  String get settingsData => '資料';

  @override
  String get settingsExportAll => '匯出所有資料（JSON）';

  @override
  String get settingsProUpgradeTitle => '升級到 Pro';

  @override
  String get settingsProUnlockedTitle => 'Pro 已解鎖';

  @override
  String get settingsProUnlockedSubtitle => '目前裝置已啟用一次性買斷解鎖。';

  @override
  String get settingsProLockedSubtitle => '解鎖完整備份匯出與更大的剪貼簿歷史容量。';

  @override
  String get settingsProHistoryLocked => '升級到 Pro 以解鎖更大的歷史容量。';

  @override
  String get proTitle => '升級到 Pro';

  @override
  String get proHeroActive => 'Pro 已啟用';

  @override
  String get proHeroInactive => '一次買斷 ClipNote';

  @override
  String get proHeroSubtitle => '一次性解鎖，無訂閱、無雲端、無追蹤。';

  @override
  String get proFeatureFullBackup => '完整備份匯出';

  @override
  String get proFeatureHistory => '更高的剪貼簿容量';

  @override
  String get proFeatureFutureAi => '未來 AI 工具';

  @override
  String get proFeatureFutureVault => '未來加密保險箱';

  @override
  String get proSectionFree => '免費版包含';

  @override
  String get proFreeCoreTitle => '核心離線工作流';

  @override
  String get proFreeCoreSubtitle => '剪貼簿歷史、筆記、任務、提醒、JSON/TXT 匯出。';

  @override
  String get proFreeAccountTitle => '無需帳號';

  @override
  String get proFreeAccountSubtitle => '所有資料都只保存在裝置本機，可離線使用。';

  @override
  String get proSectionPaid => 'Pro 解鎖內容';

  @override
  String get proPaidBackupTitle => '完整工作區備份';

  @override
  String get proPaidBackupSubtitle => '匯出單一 .clipnote 封包，包含筆記、任務與剪貼簿。';

  @override
  String get proPaidHistoryTitle => '更大的剪貼簿歷史';

  @override
  String get proPaidHistorySubtitle => '解鎖最高2000筆剪貼簿歷史。';

  @override
  String get proPaidFutureTitle => 'AI 與加密保險箱';

  @override
  String get proPaidFutureSubtitle => '後續版本直接開放，無額外持續收費。';

  @override
  String get proAlreadyUnlocked => '已解鎖';

  @override
  String proUnlockForPrice(String price) {
    return '以 $price 解鎖 Pro';
  }

  @override
  String get proUnlockInStore => '前往 Google Play 解鎖 Pro';

  @override
  String get proRestorePurchase => '恢復購買';

  @override
  String get proRestorePurchaseSuccess => '購買已恢復！';

  @override
  String get proRestorePurchaseNotFound => '未找到購買記錄。';

  @override
  String get proDebugSimulate => '除錯：模擬解鎖 Pro';

  @override
  String get proDebugRemove => '除錯：移除 Pro';

  @override
  String get proStoreUnavailable => '目前裝置無法使用 Google Play。';

  @override
  String get proProductUnavailable => 'Pro 商品目前尚未設定完成。';

  @override
  String get settingsImportBackupTitle => '匯入備份';

  @override
  String get settingsImportBackupSubtitle => '從備份檔還原剪貼簿、筆記、任務，以及可選設定。';

  @override
  String get settingsFullBackupTitle => '匯出完整備份（.clipnote）';

  @override
  String get settingsFullBackupSubtitlePro => '用於還原與遷移的應用專用完整備份。';

  @override
  String get settingsFullBackupSubtitleFree => '應用專用還原備份。Pro 功能，或看一次廣告解鎖一次。';

  @override
  String get settingsUnlockFullBackupTitle => '解鎖完整備份';

  @override
  String get settingsUnlockFullBackupBody =>
      '觀看一段短廣告可解鎖一次完整備份匯出，或升級到 Pro 取得永久權限。';

  @override
  String get settingsAdNotReady => '廣告暫時尚未準備好，請稍後再試。';

  @override
  String get settingsImportMode => '匯入方式';

  @override
  String get settingsImportMerge => '合併';

  @override
  String get settingsImportReplace => '取代';

  @override
  String get settingsImportModeMergeHint => '保留目前資料，並新增備份中的內容。';

  @override
  String get settingsImportModeReplaceHint => '匯入前先清空目前資料。';

  @override
  String get settingsImportSettingsToo => '同時匯入設定';

  @override
  String get settingsImportHasSettings => '包含應用設定';

  @override
  String get settingsImportNoSettings => '這份備份不包含設定';

  @override
  String get settingsImportNow => '立即匯入';

  @override
  String settingsImportedSummary(
      int clipboardCount, int noteCount, int todoCount, String settingsSuffix) {
    return '已匯入 $clipboardCount 筆剪貼簿、$noteCount 則筆記與 $todoCount 項任務$settingsSuffix。';
  }

  @override
  String get settingsImportedWithSettingsSuffix => '，並還原設定';

  @override
  String get settingsImportedWithoutSettingsSuffix => '';

  @override
  String get settingsSelectBackupFileError => '請選擇 .clipnote 或 .json 備份檔。';

  @override
  String settingsImportFailed(String error) {
    return '匯入失敗：$error';
  }

  @override
  String get settingsExportSuccess => '匯出成功';

  @override
  String get settingsClearClipboard => '清空剪貼簿歷史';

  @override
  String get settingsClearNotes => '清空所有筆記';

  @override
  String get settingsClearNotesConfirm => '刪除所有筆記？此操作無法復原。';

  @override
  String get settingsAbout => '關於';

  @override
  String get settingsVersion => '版本';

  @override
  String get settingsPrivacyPolicy => '隱私政策';

  @override
  String get settingsPrivacyNote => '所有資料均儲存於您的裝置本機，不會上傳至雲端。';

  @override
  String get settingsPrivacyTitle => '隱私優先';

  @override
  String get actionCancel => '取消';

  @override
  String get actionConfirm => '確認';

  @override
  String get actionDelete => '刪除';

  @override
  String get actionSave => '儲存';

  @override
  String get actionClose => '關閉';

  @override
  String get actionDone => '完成';

  @override
  String get actionUpgrade => '升級';

  @override
  String get actionWatchAd => '看廣告';

  @override
  String get timeJustNow => '剛才';

  @override
  String get exportFormatJson => '匯出為 JSON';

  @override
  String get exportFormatTxt => '匯出為 TXT';

  @override
  String get exportFormatMd => '匯出為 Markdown';
}
