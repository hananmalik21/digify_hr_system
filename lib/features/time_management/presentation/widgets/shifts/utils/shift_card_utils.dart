class ShiftCardUtils {
  ShiftCardUtils._();

  static String getArabicName(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('day')) return 'الدوام النهاري';
    if (lowerName.contains('night')) return 'الدوام الليلي';
    if (lowerName.contains('morning')) return 'دوام الصباح';
    if (lowerName.contains('evening')) return 'دوام المساء';
    return '';
  }

  static String getShiftType(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('night')) return 'Night';
    return 'Day';
  }
}
