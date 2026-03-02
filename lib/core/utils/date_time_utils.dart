import 'package:flutter/foundation.dart';

/// Common date and time utilities used across the app.
@immutable
class DateTimeUtils {
  const DateTimeUtils._();

  static DateTime normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  static DateTime? utcStringToLocal(String? s) {
    if (s == null || s.isEmpty) return null;
    try {
      final trimmed = s.trim();
      final hasTimezone = trimmed.endsWith('Z') || RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(trimmed);
      final toParse = hasTimezone ? trimmed : '$trimmed${trimmed.contains('T') ? '' : 'T00:00:00'}Z';
      return DateTime.parse(toParse).toLocal();
    } catch (_) {
      return null;
    }
  }

  static String localToUtcIso8601(DateTime local) {
    final iso = local.toUtc().toIso8601String();
    return iso.replaceFirst(RegExp(r'\.\d+'), '');
  }

  static String localToIso8601WithOffset(DateTime local) {
    final offset = local.timeZoneOffset;
    final offsetHours = offset.inHours;
    final offsetMins = offset.inMinutes.remainder(60).abs();
    final sign = offsetHours >= 0 ? '+' : '-';
    final offsetStr = '$sign${offsetHours.abs().toString().padLeft(2, '0')}:${offsetMins.toString().padLeft(2, '0')}';
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    final sec = local.second.toString().padLeft(2, '0');
    return '$y-$m-${d}T$h:$min:$sec$offsetStr';
  }

  static String formatYmd(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

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
