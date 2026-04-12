import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/database_service.dart';
import 'core/database/settings_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/rewarded_ad_service.dart';
import 'features/settings/providers/settings_provider.dart';
import 'l10n/app_localizations.dart';
import 'shared/theme/app_theme.dart';
import 'shared/widgets/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init services
  await SettingsService.instance.init();
  await DatabaseService.instance.init();
  await NotificationService.instance.init();
  await RewardedAdService.instance.init();

  runApp(
    const ProviderScope(
      child: ClipNoteApp(),
    ),
  );
}

class ClipNoteApp extends ConsumerWidget {
  const ClipNoteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'ClipNote',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.resolvedThemeMode,
      locale: settings.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainShell(),
    );
  }
}
