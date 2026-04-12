import 'package:isar/isar.dart';

part 'clipboard_item.g.dart';

enum ClipboardType { text, url }

@collection
class ClipboardItem {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String content;

  @Index(type: IndexType.value)
  late DateTime createdAt;

  bool isPinned = false;
  bool isFavorite = false;

  @enumerated
  ClipboardType type = ClipboardType.text;

  // Computed - not stored
  bool get isUrl {
    final uri = Uri.tryParse(content);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  String get preview {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }
}
