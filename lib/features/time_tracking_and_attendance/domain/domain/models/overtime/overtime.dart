import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/domain/models/overtime/overtime_record.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_colors.dart';

enum OvertimeCategory {
  all('All Staff'),
  myOvertime('My Overtime'),
  myTeam("My Team");

  final String name;
  const OvertimeCategory(this.name);
}

class OvertimeStat {
  final String title;
  final String subTitle;
  final String value;
  final String icon;
  final Color? iconBackground;
  final Color? iconColor;

  OvertimeStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.subTitle,
    this.iconBackground = AppColors.infoBg,
    this.iconColor = AppColors.statIconBlue,
  });

  OvertimeStat copyWith({
    String? title,
    String? subTitle,
    String? value,
    String? icon,
    Color? iconBackground,
    Color? iconColor,
  }) {
    return OvertimeStat(
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      value: value ?? this.value,
      icon: icon ?? this.icon,
      iconBackground: iconBackground ?? this.iconBackground,
      iconColor: iconColor ?? this.iconColor,
    );
  }
}

class OvertimeManagement {
  OvertimeCategory? selectedCategory;
  List<OvertimeCategory>? categories;
  List<OvertimeStat>? stats;
  List<OvertimeRecord>? records;

  OvertimeManagement({this.selectedCategory, this.categories, this.stats});

  OvertimeManagement copyWith({
    OvertimeCategory? selectedCategory,
    List<OvertimeCategory>? categories,
    List<OvertimeStat>? stats,
  }) {
    return OvertimeManagement(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      stats: stats ?? this.stats,
    );
  }
}
