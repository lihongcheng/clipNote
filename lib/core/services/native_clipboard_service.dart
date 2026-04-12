import 'package:flutter/services.dart';

/// Flutter-side wrapper for the native Android clipboard channel.
/// Listens for clipboard changes pushed from MainActivity via EventChannel.
class NativeClipboardService {
  static const _methodChannel =
      MethodChannel('cn.inaiworld.clipnote/clipboard');
  static const _eventChannel =
      EventChannel('cn.inaiworld.clipnote/clipboard_events');

  static Stream<String>? _stream;

  /// Stream of new clipboard text from native side.
  static Stream<String> get clipboardStream {
    _stream ??= _eventChannel
        .receiveBroadcastStream()
        .where((event) => event is String && event.trim().isNotEmpty)
        .cast<String>();
    return _stream!;
  }

  /// Explicitly request current clipboard text.
  static Future<String?> getCurrentText() async {
    try {
      final result =
          await _methodChannel.invokeMethod<String>('getClipboardText');
      return result;
    } catch (_) {
      return null;
    }
  }

  /// Start native clipboard monitoring.
  static Future<void> startMonitoring() async {
    try {
      await _methodChannel.invokeMethod('startMonitoring');
    } catch (_) {}
  }

  /// Stop native clipboard monitoring.
  static Future<void> stopMonitoring() async {
    try {
      await _methodChannel.invokeMethod('stopMonitoring');
    } catch (_) {}
  }
}
