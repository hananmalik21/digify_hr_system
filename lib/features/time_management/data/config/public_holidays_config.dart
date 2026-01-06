import 'package:digify_hr_system/core/enums/time_management_enums.dart';

class PublicHolidaysConfig {
  PublicHolidaysConfig._();

  /// Available years for filtering holidays
  static List<String> get availableYears => ['2024', '2025', '2026', '2027'];

  /// Available holiday types for filtering
  static List<String> get availableTypes => ['All Types', 'Fixed', 'Islamic'];

  /// Default selected year
  static String get defaultYear => '2025';

  /// Default selected type
  static String get defaultType => 'All Types';

  /// Get holiday type from display string
  static HolidayType? getHolidayTypeFromDisplay(String displayName) {
    switch (displayName) {
      case 'Fixed':
        return HolidayType.fixed;
      case 'Islamic':
        return HolidayType.islamic;
      default:
        return null;
    }
  }

  /// Get display name for holiday type
  static String getHolidayTypeDisplayName(HolidayType type) {
    switch (type) {
      case HolidayType.fixed:
        return 'Fixed';
      case HolidayType.islamic:
        return 'Islamic';
    }
  }
}
