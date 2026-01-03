import 'package:flutter/material.dart';

class DashboardButton {
  final String id;
  final String icon;
  final String label;
  final Color color;
  final String route;
  final bool isMultiLine;

  DashboardButton({
    required this.id,
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
    this.isMultiLine = false,
  });

  DashboardButton copyWith({String? label}) {
    return DashboardButton(
      id: id,
      icon: icon,
      label: label ?? this.label,
      color: color,
      route: route,
      isMultiLine: isMultiLine,
    );
  }
}

class GridSpec {
  final int columns;
  final double spacing;
  final double tileW;
  final double tileH;
  final bool needsLongPress;

  const GridSpec({
    required this.columns,
    required this.spacing,
    required this.tileW,
    required this.tileH,
    required this.needsLongPress,
  });
}

