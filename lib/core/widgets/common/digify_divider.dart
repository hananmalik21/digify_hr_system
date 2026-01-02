import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// A customizable divider widget for the Digify HR application.
///
/// Provides consistent divider styling across the app with theme-aware colors.
class DigifyDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;
  final EdgeInsetsGeometry? margin;

  const DigifyDivider({
    super.key,
    this.height,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
    this.margin,
  });

  /// Creates a standard horizontal divider with default styling
  const DigifyDivider.horizontal({
    super.key,
    this.height = 1,
    this.thickness = 1,
    this.color,
    this.indent,
    this.endIndent,
    this.margin,
  });

  /// Creates a thin divider (0.5px thickness)
  const DigifyDivider.thin({
    super.key,
    this.height = 1,
    this.thickness = 0.5,
    this.color,
    this.indent,
    this.endIndent,
    this.margin,
  });

  /// Creates a thick divider (2px thickness)
  const DigifyDivider.thick({
    super.key,
    this.height = 2,
    this.thickness = 2,
    this.color,
    this.indent,
    this.endIndent,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final defaultColor = isDark
        ? AppColors.cardBorderDark
        : AppColors.cardBorder;

    final divider = Divider(
      height: height,
      thickness: thickness ?? 1,
      color: color ?? defaultColor,
      indent: indent,
      endIndent: endIndent,
    );

    if (margin != null) {
      return Padding(padding: margin!, child: divider);
    }

    return divider;
  }
}

/// A vertical divider widget for the Digify HR application.
///
/// Provides consistent vertical divider styling across the app with theme-aware colors.
class DigifyVerticalDivider extends StatelessWidget {
  final double? width;
  final double? thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;
  final EdgeInsetsGeometry? margin;

  const DigifyVerticalDivider({
    super.key,
    this.width,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
    this.margin,
  });

  /// Creates a standard vertical divider with default styling
  const DigifyVerticalDivider.standard({
    super.key,
    this.width = 1,
    this.thickness = 1,
    this.color,
    this.indent,
    this.endIndent,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final defaultColor = isDark
        ? AppColors.cardBorderDark
        : AppColors.cardBorder;

    final divider = VerticalDivider(
      width: width,
      thickness: thickness ?? 1,
      color: color ?? defaultColor,
      indent: indent,
      endIndent: endIndent,
    );

    if (margin != null) {
      return Padding(padding: margin!, child: divider);
    }

    return divider;
  }
}
