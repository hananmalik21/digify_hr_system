import 'package:flutter/services.dart';

class AppInputFormatters {
  AppInputFormatters._();

  // ================= NAMES =================
  static final TextInputFormatter nameEn =
  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\.\-']"));

  static final TextInputFormatter nameAr =
  FilteringTextInputFormatter.allow(RegExp(r"[\u0600-\u06FF\s\.\-']"));

  static final TextInputFormatter nameAny =
  FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z\u0600-\u06FF\s\.\-']"),
  );

  // ================= CODES =================
  static final TextInputFormatter orgUnitCode =
  FilteringTextInputFormatter.allow(RegExp(r"[A-Za-z0-9\-_]"));

  // ================= PHONE =================
  static final TextInputFormatter phone =
  FilteringTextInputFormatter.allow(RegExp(r"[\d\+\-\s\(\)]"));

  // ================= EMAIL =================
  /// Allows only valid email characters while typing
  /// letters, numbers, @ . _ -
  static final TextInputFormatter email =
  FilteringTextInputFormatter.allow(
    RegExp(r"[a-zA-Z0-9@._\-]"),
  );

  // ================= COMMON =================
  static final TextInputFormatter digitsOnly =
      FilteringTextInputFormatter.digitsOnly;

  static TextInputFormatter maxLen(int n) =>
      LengthLimitingTextInputFormatter(n);
}
