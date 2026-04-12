import 'package:flutter/material.dart';

/// Simple preferences stored as shared_preferences-style key-value.
/// We persist this using Isar as a single-document collection.
class AppSettings {
  // Language: null = system, 'en', 'zh', 'zh_TW', 'ja', 'ko'
  String? languageCode;
  String? countryCode;

  // Theme: 'light', 'dark', 'system'
  String themeMode;

  // Clipboard
  int maxClipboardHistory;
  int autoDeleteDays; // 0 = never

  // Monetization
  bool isPro;
  String? proUnlockedAt;

  AppSettings({
    this.languageCode,
    this.countryCode,
    this.themeMode = 'system',
    this.maxClipboardHistory = 500,
    this.autoDeleteDays = 0,
    this.isPro = false,
    this.proUnlockedAt,
  });

  Locale? get locale {
    if (languageCode == null) return null;
    if (countryCode != null) return Locale(languageCode!, countryCode);
    return Locale(languageCode!);
  }

  ThemeMode get resolvedThemeMode {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  AppSettings copyWith({
    String? languageCode,
    bool clearLanguage = false,
    String? countryCode,
    bool clearCountry = false,
    String? themeMode,
    int? maxClipboardHistory,
    int? autoDeleteDays,
    bool? isPro,
    String? proUnlockedAt,
    bool clearProUnlockedAt = false,
  }) {
    return AppSettings(
      languageCode: clearLanguage ? null : (languageCode ?? this.languageCode),
      countryCode: clearCountry ? null : (countryCode ?? this.countryCode),
      themeMode: themeMode ?? this.themeMode,
      maxClipboardHistory: maxClipboardHistory ?? this.maxClipboardHistory,
      autoDeleteDays: autoDeleteDays ?? this.autoDeleteDays,
      isPro: isPro ?? this.isPro,
      proUnlockedAt:
          clearProUnlockedAt ? null : (proUnlockedAt ?? this.proUnlockedAt),
    );
  }

  Map<String, dynamic> toJson() => {
        'languageCode': languageCode,
        'countryCode': countryCode,
        'themeMode': themeMode,
        'maxClipboardHistory': maxClipboardHistory,
        'autoDeleteDays': autoDeleteDays,
        'isPro': isPro,
        'proUnlockedAt': proUnlockedAt,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        languageCode: json['languageCode'] as String?,
        countryCode: json['countryCode'] as String?,
        themeMode: (json['themeMode'] as String?) ?? 'system',
        maxClipboardHistory: (json['maxClipboardHistory'] as int?) ?? 500,
        autoDeleteDays: (json['autoDeleteDays'] as int?) ?? 0,
        isPro: (json['isPro'] as bool?) ?? false,
        proUnlockedAt: json['proUnlockedAt'] as String?,
      );
}
