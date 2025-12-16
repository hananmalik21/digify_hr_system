import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum DeviceType {
  mobile,
  tablet,
  web,
}

class ResponsiveHelper {
  ResponsiveHelper._();

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  // Get device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.web;
    }
  }

  // Check if device is mobile
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  // Check if device is tablet
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  // Check if device is web
  static bool isWeb(BuildContext context) {
    return getDeviceType(context) == DeviceType.web;
  }

  // Get responsive width based on device type
  static double getResponsiveWidth(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? web,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return (mobile ?? 100).w;
      case DeviceType.tablet:
        return (tablet ?? mobile ?? 100).w;
      case DeviceType.web:
        return (web ?? tablet ?? mobile ?? 100).w;
    }
  }

  // Get responsive height based on device type
  static double getResponsiveHeight(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? web,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return (mobile ?? 100).h;
      case DeviceType.tablet:
        return (tablet ?? mobile ?? 100).h;
      case DeviceType.web:
        return (web ?? tablet ?? mobile ?? 100).h;
    }
  }

  // Get responsive font size based on device type
  static double getResponsiveFontSize(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? web,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return (mobile ?? 14).sp;
      case DeviceType.tablet:
        return (tablet ?? mobile ?? 14).sp;
      case DeviceType.web:
        return (web ?? tablet ?? mobile ?? 14).sp;
    }
  }

  // Get responsive padding based on device type
  static EdgeInsetsDirectional getResponsivePadding(
    BuildContext context, {
    EdgeInsetsDirectional? mobile,
    EdgeInsetsDirectional? tablet,
    EdgeInsetsDirectional? web,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile ??
            const EdgeInsetsDirectional.symmetric(
              horizontal: 16,
              vertical: 12,
            );
      case DeviceType.tablet:
        return tablet ??
            mobile ??
            const EdgeInsetsDirectional.symmetric(
              horizontal: 24,
              vertical: 16,
            );
      case DeviceType.web:
        return web ??
            tablet ??
            mobile ??
            const EdgeInsetsDirectional.symmetric(
              horizontal: 32,
              vertical: 20,
            );
    }
  }

  // Get number of columns for grid based on device type
  static int getResponsiveColumns(
    BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int web = 3,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.web:
        return web;
    }
  }

  // Get max width for content containers
  static double getMaxContentWidth(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return double.infinity;
      case DeviceType.tablet:
        return 768.w;
      case DeviceType.web:
        return 1200.w;
    }
  }
}

