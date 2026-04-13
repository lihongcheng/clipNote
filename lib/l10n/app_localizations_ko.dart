// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'ClipNote';

  @override
  String get tabClipboard => '클립보드';

  @override
  String get tabNotes => '노트';

  @override
  String get tabTasks => '작업';

  @override
  String get tabSettings => '설정';

  @override
  String get clipboardTitle => '클립보드 기록';

  @override
  String get clipboardEmpty => '아직 복사된 내용이 없습니다';

  @override
  String get clipboardEmptyHint => '텍스트를 복사하면 자동으로 저장됩니다';

  @override
  String get clipboardSearchHint => '클립보드 검색...';

  @override
  String get clipboardCopied => '복사됨!';

  @override
  String get clipboardPinned => '고정됨';

  @override
  String get clipboardPin => '고정';

  @override
  String get clipboardUnpin => '고정 해제';

  @override
  String get clipboardDelete => '삭제';

  @override
  String get clipboardDeleteConfirm => '이 항목을 삭제할까요?';

  @override
  String get clipboardClearAll => '모두 지우기';

  @override
  String get clipboardClearAllConfirm => '클립보드 기록을 모두 지울까요? 고정된 항목은 유지됩니다.';

  @override
  String clipboardItemsCount(int count) {
    return '$count개 항목';
  }

  @override
  String get clipboardShareText => '공유';

  @override
  String get clipboardAddNote => '노트로 저장';

  @override
  String get clipboardFavorites => '즐겨찾기';

  @override
  String get clipboardNoFavorites => '즐겨찾기가 아직 없습니다';

  @override
  String get clipboardNoFavoritesHint => '중요한 내용을 즐겨찾기로 표시해 빠르게 찾으세요.';

  @override
  String get clipboardFavorite => '즐겨찾기';

  @override
  String get clipboardUnfavorite => '즐겨찾기 해제';

  @override
  String get clipboardDetailsTitle => '클립보드 상세';

  @override
  String get clipboardDetailsHint => '클립보드 내용 편집';

  @override
  String get clipboardCopyEdited => '수정한 내용 복사';

  @override
  String get clipboardUpdateRecord => '기록 업데이트';

  @override
  String get clipboardUpdated => '클립보드 기록이 업데이트되었습니다';

  @override
  String get clipboardTypeText => '텍스트';

  @override
  String get clipboardTypeUrl => 'URL';

  @override
  String get todoTitle => '작업';

  @override
  String get todoSearchHint => '작업 검색...';

  @override
  String get todoFilterToday => '오늘';

  @override
  String get todoFilterAll => '전체';

  @override
  String get todoFilterDone => '완료';

  @override
  String get todoEmptySubtitle => '작업과 알림은 모두 로컬에만 저장됩니다.';

  @override
  String get todoEmptyToday => '오늘 할 작업이 없습니다';

  @override
  String get todoEmptyDone => '완료된 작업이 아직 없습니다';

  @override
  String get todoEmptyAll => '작업이 아직 없습니다';

  @override
  String get todoAdd => '작업 추가';

  @override
  String get todoNew => '새 작업';

  @override
  String get todoEdit => '작업 편집';

  @override
  String get todoTitleField => '작업 제목';

  @override
  String get todoDetailsField => '상세';

  @override
  String get todoPriority => '우선순위';

  @override
  String get todoPriorityLow => '낮음';

  @override
  String get todoPriorityMedium => '보통';

  @override
  String get todoPriorityHigh => '높음';

  @override
  String get todoDueDate => '마감일';

  @override
  String get todoNoDeadline => '마감일 없음';

  @override
  String get todoSet => '설정';

  @override
  String get todoChange => '변경';

  @override
  String get todoReminder => '로컬 알림';

  @override
  String get todoReminderHint => '작업 기한이 되면 알림 보내기';

  @override
  String get todoReminderOn => '알림 켜짐';

  @override
  String todoTodayAt(String time) {
    return '오늘 $time';
  }

  @override
  String get notesTitle => '노트';

  @override
  String get notesEmpty => '노트가 없습니다';

  @override
  String get notesEmptyHint => '+ 를 눌러 첫 번째 노트를 만드세요';

  @override
  String get notesSearchHint => '노트 검색...';

  @override
  String get notesNew => '새 노트';

  @override
  String get notesEdit => '노트 편집';

  @override
  String get notesTitleHint => '제목 (선택사항)';

  @override
  String get notesContentHint => '지금 시작하세요...';

  @override
  String get notesSaved => '저장됨';

  @override
  String get notesDelete => '삭제';

  @override
  String get notesDeleteConfirm => '이 노트를 삭제할까요?';

  @override
  String get notesMarkdownPreview => '미리보기';

  @override
  String get notesMarkdownEdit => '편집';

  @override
  String get notesPinned => '고정됨';

  @override
  String get notesPin => '고정';

  @override
  String get notesUnpin => '고정 해제';

  @override
  String get notesShare => '공유';

  @override
  String get notesExport => '내보내기';

  @override
  String notesCount(int count) {
    return '$count개 노트';
  }

  @override
  String notesLastEdited(String time) {
    return '$time에 편집';
  }

  @override
  String get settingsTitle => '설정';

  @override
  String get settingsLanguage => '언어';

  @override
  String get settingsLanguageSystem => '시스템 설정 따르기';

  @override
  String get settingsTheme => '테마';

  @override
  String get settingsThemeLight => '밝은 테마';

  @override
  String get settingsThemeDark => '어두운 테마';

  @override
  String get settingsThemeSystem => '시스템 설정 따르기';

  @override
  String get settingsClipboard => '클립보드';

  @override
  String get settingsMaxHistory => '최대 기록 수';

  @override
  String get settingsAutoDelete => '자동 삭제';

  @override
  String get settingsAutoDeleteNever => '안 함';

  @override
  String get settingsAutoDelete7d => '7일 후';

  @override
  String get settingsAutoDelete30d => '30일 후';

  @override
  String get settingsAutoDelete90d => '90일 후';

  @override
  String get settingsData => '데이터';

  @override
  String get settingsExportAll => '모든 데이터 내보내기 (JSON)';

  @override
  String get settingsProUpgradeTitle => 'Pro로 업그레이드';

  @override
  String get settingsProUnlockedTitle => 'Pro 잠금 해제됨';

  @override
  String get settingsProUnlockedSubtitle => '이 기기에서 일회성 구매 잠금 해제가 활성화되었습니다.';

  @override
  String get settingsProLockedSubtitle =>
      '전체 백업 내보내기와 더 큰 클립보드 기록 용량을 잠금 해제합니다.';

  @override
  String get settingsProHistoryLocked => '더 큰 기록 한도를 사용하려면 Pro로 업그레이드하세요.';

  @override
  String get proTitle => 'Pro로 업그레이드';

  @override
  String get proHeroActive => 'Pro가 활성화됨';

  @override
  String get proHeroInactive => 'ClipNote를 한 번만 구매';

  @override
  String get proHeroSubtitle => '1회 잠금 해제. 구독 없음. 클라우드 없음. 추적 없음.';

  @override
  String get proFeatureFullBackup => '전체 백업 내보내기';

  @override
  String get proFeatureHistory => '더 큰 클립보드 용량';

  @override
  String get proFeatureFutureAi => '향후 AI 도구';

  @override
  String get proFeatureFutureVault => '향후 암호화 보관함';

  @override
  String get proSectionFree => '무료 버전에 포함된 것';

  @override
  String get proFreeCoreTitle => '핵심 오프라인 워크플로우';

  @override
  String get proFreeCoreSubtitle => '클립보드 기록, 노트, 작업, 알림, JSON/TXT 내보내기.';

  @override
  String get proFreeAccountTitle => '계정 필요 없음';

  @override
  String get proFreeAccountSubtitle => '모든 데이터는 기기에 저장되고 오프라인으로 동작합니다.';

  @override
  String get proSectionPaid => 'Pro가 해제하는 기능';

  @override
  String get proPaidBackupTitle => '전체 작업공간 백업';

  @override
  String get proPaidBackupSubtitle =>
      '노트, 작업, 클립보드를 담은 단일 .clipnote 패키지를 내보냅니다.';

  @override
  String get proPaidHistoryTitle => '대용량 클립보드 기록';

  @override
  String get proPaidHistorySubtitle => '최대 2000개 기록 한도를 해제합니다.';

  @override
  String get proPaidFutureTitle => 'AI 및 암호화 보관함';

  @override
  String get proPaidFutureSubtitle => '추가 정기 요금 없이 향후 릴리스에 포함될 예정입니다.';

  @override
  String get proAlreadyUnlocked => '이미 잠금 해제됨';

  @override
  String proUnlockForPrice(String price) {
    return '$price에 Pro 잠금 해제';
  }

  @override
  String get proUnlockInStore => 'Google Play에서 Pro 잠금 해제';

  @override
  String get proRestorePurchase => '구매 복원';

  @override
  String get proRestorePurchaseSuccess => '구매가 복원되었습니다!';

  @override
  String get proRestorePurchaseNotFound => '구매 기록이 없습니다.';

  @override
  String get proDebugSimulate => '디버그: Pro 잠금 해제 시뮬레이션';

  @override
  String get proDebugRemove => '디버그: Pro 제거';

  @override
  String get proStoreUnavailable => '이 기기에서는 Google Play를 사용할 수 없습니다.';

  @override
  String get proProductUnavailable => 'Pro 상품이 아직 구성되지 않았습니다.';

  @override
  String get settingsImportBackupTitle => '백업 가져오기';

  @override
  String get settingsImportBackupSubtitle =>
      '백업 파일에서 클립보드, 노트, 작업과 선택한 설정을 복원합니다.';

  @override
  String get settingsFullBackupTitle => '전체 백업 내보내기 (.clipnote)';

  @override
  String get settingsFullBackupSubtitlePro => '복원과 마이그레이션을 위한 앱 전용 전체 백업입니다.';

  @override
  String get settingsFullBackupSubtitleFree =>
      '앱 전용 복원 백업입니다. Pro 기능이거나 광고 시청으로 1회 잠금 해제.';

  @override
  String get settingsUnlockFullBackupTitle => '전체 백업 잠금 해제';

  @override
  String get settingsUnlockFullBackupBody =>
      '짧은 광고를 시청하면 전체 백업 내보내기를 1회 사용할 수 있습니다. Pro로 업그레이드하면 영구적으로 사용할 수 있습니다.';

  @override
  String get settingsAdNotReady => '광고가 아직 준비되지 않았습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get settingsImportMode => '가져오기 방식';

  @override
  String get settingsImportMerge => '병합';

  @override
  String get settingsImportReplace => '교체';

  @override
  String get settingsImportModeMergeHint => '현재 데이터를 유지하고 새 항목을 추가합니다.';

  @override
  String get settingsImportModeReplaceHint => '가져오기 전에 현재 데이터를 지웁니다.';

  @override
  String get settingsImportSettingsToo => '설정도 가져오기';

  @override
  String get settingsImportHasSettings => '앱 설정 포함';

  @override
  String get settingsImportNoSettings => '이 백업에는 설정이 없습니다';

  @override
  String get settingsImportNow => '지금 가져오기';

  @override
  String settingsImportedSummary(
      int clipboardCount, int noteCount, int todoCount, String settingsSuffix) {
    return '클립보드 $clipboardCount개, 노트 $noteCount개, 작업 $todoCount개를 가져왔습니다$settingsSuffix.';
  }

  @override
  String get settingsImportedWithSettingsSuffix => ' (설정 포함)';

  @override
  String get settingsImportedWithoutSettingsSuffix => '';

  @override
  String get settingsSelectBackupFileError =>
      '.clipnote 또는 .json 백업 파일을 선택해 주세요.';

  @override
  String settingsImportFailed(String error) {
    return '가져오기 실패: $error';
  }

  @override
  String get settingsExportSuccess => '내보내기 성공';

  @override
  String get settingsClearClipboard => '클립보드 기록 지우기';

  @override
  String get settingsClearNotes => '모든 노트 지우기';

  @override
  String get settingsClearNotesConfirm => '모든 노트를 삭제할까요? 되돌릴 수 없습니다.';

  @override
  String get settingsAbout => '앱 정보';

  @override
  String get settingsVersion => '버전';

  @override
  String get settingsPrivacyPolicy => '개인정보 처리방침';

  @override
  String get settingsPrivacyNote => '모든 데이터는 기기에 로컬로 저장됩니다. 클라우드에 업로드되지 않습니다.';

  @override
  String get settingsPrivacyTitle => '개인정보 우선';

  @override
  String get actionCancel => '취소';

  @override
  String get actionConfirm => '확인';

  @override
  String get actionDelete => '삭제';

  @override
  String get actionSave => '저장';

  @override
  String get actionClose => '닫기';

  @override
  String get actionDone => '완료';

  @override
  String get actionUpgrade => '업그레이드';

  @override
  String get actionWatchAd => '광고 보기';

  @override
  String get timeJustNow => '방금 전';

  @override
  String get exportFormatJson => 'JSON으로 내보내기';

  @override
  String get exportFormatTxt => 'TXT로 내보내기';

  @override
  String get exportFormatMd => 'Markdown으로 내보내기';
}
