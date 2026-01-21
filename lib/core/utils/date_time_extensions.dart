/// Date Time Extensions
/// Helper methods for date and time formatting
library;

import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  /// Format as "20 Januari 2026"
  String get formattedDate {
    return DateFormat('d MMMM yyyy', 'id_ID').format(this);
  }

  /// Format as "20 Jan 2026"
  String get shortDate {
    return DateFormat('d MMM yyyy', 'id_ID').format(this);
  }

  /// Format as "2026-01-20"
  String get isoDate {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  /// Format as "08:00"
  String get timeOnly {
    return DateFormat('HH:mm').format(this);
  }

  /// Format as "08:00:00"
  String get timeWithSeconds {
    return DateFormat('HH:mm:ss').format(this);
  }

  /// Format as "Senin, 20 Januari 2026"
  String get fullDate {
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(this);
  }

  /// Format as "Sen, 20 Jan"
  String get compactDate {
    return DateFormat('E, d MMM', 'id_ID').format(this);
  }

  /// Format as "20 Jan 2026, 08:00"
  String get dateTime {
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(this);
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is in the past
  bool get isPast {
    return isBefore(DateTime.now());
  }

  /// Check if date is in the future
  bool get isFuture {
    return isAfter(DateTime.now());
  }

  /// Get start of day
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Get end of day
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59);
  }

  /// Get start of month
  DateTime get startOfMonth {
    return DateTime(year, month, 1);
  }

  /// Get end of month
  DateTime get endOfMonth {
    return DateTime(year, month + 1, 0, 23, 59, 59);
  }

  /// Get greeting based on time of day
  String get greeting {
    final hour = this.hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }
}

extension DurationExtensions on Duration {
  /// Format as "5 menit" or "1 jam 30 menit"
  String get formatted {
    if (inMinutes < 60) {
      return '$inMinutes menit';
    }

    final hours = inHours;
    final minutes = inMinutes % 60;

    if (minutes == 0) {
      return '$hours jam';
    }

    return '$hours jam $minutes menit';
  }

  /// Format as "05:30" (HH:mm)
  String get asTimeString {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = (inMinutes % 60).toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}

extension StringDateExtensions on String {
  /// Parse ISO date string "2026-01-20" to DateTime
  DateTime? toDate() {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return null;
    }
  }

  /// Parse time string "08:00" to TimeOfDay-like map
  Map<String, int>? toTime() {
    try {
      final parts = split(':');
      return {'hour': int.parse(parts[0]), 'minute': int.parse(parts[1])};
    } catch (e) {
      return null;
    }
  }
}
