class NumberFormatUtils {
  NumberFormatUtils._();

  static String formatDays(num value) {
    return value.toDouble().toString().replaceAll(RegExp(r'\.0$'), '');
  }

  static String formatWithDecimals(num value, {int decimalPlaces = 1}) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(decimalPlaces);
  }
}
