import 'package:flutter/services.dart';

class AppInputFormatters {
  AppInputFormatters._();

  // ================= NAMES =================
  static final TextInputFormatter nameEn = FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\.\-']"));

  static final TextInputFormatter nameAr = FilteringTextInputFormatter.allow(RegExp(r"[\u0600-\u06FF\s\.\-']"));

  static final TextInputFormatter nameAny = FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\u0600-\u06FF\s\.\-']"));

  // ================= CODES =================
  static final TextInputFormatter orgUnitCode = FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z0-9\-_]"));

  // ================= PHONE =================
  static final TextInputFormatter phone = FilteringTextInputFormatter.allow(RegExp(r"[\d\+\-\s\(\)]"));

  // ================= EMAIL =================
  /// Allows only valid email characters while typing
  /// letters, numbers, @ . _ -
  static final TextInputFormatter email = FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9@._\-]"));

  // ================= COMMON =================
  static final TextInputFormatter digitsOnly = FilteringTextInputFormatter.digitsOnly;

  static TextInputFormatter maxLen(int n) => LengthLimitingTextInputFormatter(n);

  static TextInputFormatter decimalWithOnePlace() => _DecimalInputFormatter(1);

  static TextInputFormatter decimalWithTwoPlaces() => _DecimalInputFormatter(2);
}

class _DecimalInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  _DecimalInputFormatter(this.decimalPlaces);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    final regex = RegExp(r'^\d*\.?\d{0,' + decimalPlaces.toString() + r'}$');
    if (regex.hasMatch(text)) {
      return newValue;
    }

    return oldValue;
  }
}
