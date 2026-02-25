import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import 'overtime_record.dart';

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
  String? expandedRecord;
  bool isLoading;
  bool clearError;
  String? error;

  OvertimeManagement({
    this.selectedCategory,
    this.categories,
    this.stats,
    this.records,
    this.isLoading = false,
    this.clearError = true,
    this.error,
    this.expandedRecord,
  });

  OvertimeManagement copyWith({
    OvertimeCategory? selectedCategory,
    List<OvertimeCategory>? categories,
    List<OvertimeStat>? stats,
    List<OvertimeRecord>? records,
    bool? isLoading,
    bool? clearError,
    String? error,
    String? expandedRecord,
  }) {
    return OvertimeManagement(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      stats: stats ?? this.stats,
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      clearError: clearError ?? this.clearError,
      error: error ?? this.error,
      expandedRecord: expandedRecord,
    );
  }
}
