import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_settings.dart';
import '../../../core/database/settings_service.dart';

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    return SettingsService.instance.settings;
  }

  Future<void> update(AppSettings settings) async {
    await SettingsService.instance.save(settings);
    state = settings;
  }

  Future<void> setLanguage(String? languageCode, [String? countryCode]) async {
    if (languageCode == null) {
      await update(state.copyWith(clearLanguage: true, clearCountry: true));
    } else {
      await update(state.copyWith(
        languageCode: languageCode,
        countryCode: countryCode,
        clearCountry: countryCode == null,
      ));
    }
  }

  Future<void> setThemeMode(String mode) async {
    await update(state.copyWith(themeMode: mode));
  }

  Future<void> setMaxHistory(int max) async {
    await update(state.copyWith(maxClipboardHistory: max));
  }

  Future<void> setAutoDeleteDays(int days) async {
    await update(state.copyWith(autoDeleteDays: days));
  }

  Future<void> setPro(bool value) async {
    await update(state.copyWith(
      isPro: value,
      proUnlockedAt: value ? DateTime.now().toIso8601String() : null,
      clearProUnlockedAt: !value,
    ));
  }

  void reload() {
    state = SettingsService.instance.settings;
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);
