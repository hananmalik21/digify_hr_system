import 'package:digify_hr_system/core/enums/time_management_enums.dart';
import 'package:flutter/material.dart';

class ShiftFormConfig {
  ShiftFormConfig._();

  static List<String> get shiftTypeOptions => ShiftType.values.map((e) => e.displayName).toList();

  static List<String> get statusOptions => ShiftStatus.values.map((e) => e.displayName).toList();

  static const Color defaultColor = Color(0xFFFFD700);
}
