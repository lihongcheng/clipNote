import 'package:flutter/material.dart';

String formatRelativeTime(DateTime dt, Locale locale) {
  final now = DateTime.now();
  final diff = now.difference(dt);

  if (diff.inSeconds < 60) {
    return _justNow(locale);
  } else if (diff.inMinutes < 60) {
    return _minutesAgo(diff.inMinutes, locale);
  } else if (diff.inHours < 24) {
    return _hoursAgo(diff.inHours, locale);
  } else if (diff.inDays < 7) {
    return _daysAgo(diff.inDays, locale);
  } else {
    return _formatDate(dt, locale);
  }
}

String _justNow(Locale locale) {
  switch (locale.languageCode) {
    case 'zh':
      return '刚刚';
    case 'ja':
      return 'たった今';
    case 'ko':
      return '방금 전';
    default:
      return 'just now';
  }
}

String _minutesAgo(int minutes, Locale locale) {
  switch (locale.languageCode) {
    case 'zh':
      return '$minutes 分钟前';
    case 'ja':
      return '$minutes 分前';
    case 'ko':
      return '$minutes분 전';
    default:
      return '$minutes min ago';
  }
}

String _hoursAgo(int hours, Locale locale) {
  switch (locale.languageCode) {
    case 'zh':
      return '$hours 小时前';
    case 'ja':
      return '$hours 時間前';
    case 'ko':
      return '$hours시간 전';
    default:
      return '$hours hr ago';
  }
}

String _daysAgo(int days, Locale locale) {
  switch (locale.languageCode) {
    case 'zh':
      return '$days 天前';
    case 'ja':
      return '$days 日前';
    case 'ko':
      return '$days일 전';
    default:
      return '$days days ago';
  }
}

String _formatDate(DateTime dt, Locale locale) {
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}

String formatDateTime(DateTime dt, Locale locale) {
  return '${_formatDate(dt, locale)} ${formatClock(dt, locale)}';
}

String formatClock(DateTime dt, Locale locale) {
  return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
