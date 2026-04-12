import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  static Future<String?> exportToSelectedLocation(
    String content,
    String filename,
  ) async {
    final extension =
        filename.contains('.') ? filename.split('.').last.toLowerCase() : null;

    try {
      return await FilePicker.platform.saveFile(
        dialogTitle: 'Save export',
        fileName: filename,
        type: extension == null ? FileType.any : FileType.custom,
        allowedExtensions: extension == null ? null : [extension],
        bytes: Uint8List.fromList(utf8.encode(content)),
      );
    } on UnsupportedError {
      await exportAndShare(content, filename);
      return filename;
    }
  }

  static Future<void> exportAndShare(
    String content,
    String filename,
  ) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsString(content);
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: filename,
    );
  }

  static Future<String> saveToDownloads(String content, String filename) async {
    Directory? dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) {
        dir = await getExternalStorageDirectory();
      }
    } else {
      dir = await getApplicationDocumentsDirectory();
    }
    dir ??= await getTemporaryDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsString(content);
    return file.path;
  }
}
