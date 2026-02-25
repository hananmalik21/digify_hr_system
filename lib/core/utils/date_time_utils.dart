import 'package:flutter/foundation.dart';

/// Common date and time utilities used across the app.
@immutable
class DateTimeUtils {
  const DateTimeUtils._();

  static DateTime normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  static DateTime getWeekStart(DateTime date) {
    final normalized = normalizeDate(date);
    final weekday = normalized.weekday;
    return normalized.subtract(Duration(days: weekday - 1));
  }

  static DateTime getWeekEnd(DateTime date) {
    final startOfWeek = getWeekStart(date);
    return startOfWeek.add(const Duration(days: 6));
  }

  static bool isDateInRange({required DateTime start, required DateTime end, DateTime? today}) {
    final target = normalizeDate(today ?? DateTime.now());
    final normalizedStart = normalizeDate(start);
    final normalizedEnd = normalizeDate(end);

    return !target.isBefore(normalizedStart) && !target.isAfter(normalizedEnd);
  }
}
