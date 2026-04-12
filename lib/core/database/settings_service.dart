import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'app_settings.dart';

class SettingsService {
  static SettingsService? _instance;
  SettingsService._();

  static SettingsService get instance {
    _instance ??= SettingsService._();
    return _instance!;
  }

  late File _file;
  AppSettings _settings = AppSettings();

  AppSettings get settings => _settings;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _file = File('${dir.path}/settings.json');
    if (await _file.exists()) {
      try {
        final json = jsonDecode(await _file.readAsString());
        _settings = AppSettings.fromJson(json as Map<String, dynamic>);
      } catch (_) {
        _settings = AppSettings();
      }
    }
  }

  Future<void> save(AppSettings settings) async {
    _settings = settings;
    await _file.writeAsString(jsonEncode(settings.toJson()));
  }
}
