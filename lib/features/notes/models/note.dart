import 'package:isar/isar.dart';

part 'note.g.dart';

@collection
class Note {
  Id id = Isar.autoIncrement;

  String title = '';

  late String content;

  @Index(type: IndexType.value)
  late DateTime createdAt;

  @Index(type: IndexType.value)
  late DateTime updatedAt;

  bool isPinned = false;
  List<String> tags = [];

  String get displayTitle {
    if (title.isNotEmpty) return title;
    // Extract first line of content as title
    final firstLine = content.split('\n').first.trim();
    // Remove markdown heading markers
    final cleaned = firstLine.replaceAll(RegExp(r'^#+\s*'), '');
    if (cleaned.isNotEmpty) return cleaned;
    return 'Untitled';
  }

  String get preview {
    final lines = content.split('\n').where((l) => l.trim().isNotEmpty).toList();
    if (lines.isEmpty) return '';
    final start = (title.isNotEmpty) ? 0 : 1;
    final previewLines = lines.skip(start).take(2).join(' ');
    if (previewLines.length <= 120) return previewLines;
    return '${previewLines.substring(0, 120)}...';
  }

  int get wordCount {
    return content.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  }
}
