import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:digify_hr_system/features/auth/data/models/login_feature_model.dart';
import 'package:flutter/material.dart';

/// Configuration for login feature cards
/// This follows clean architecture by separating data/config from presentation
class LoginFeaturesConfig {
  LoginFeaturesConfig._();

  /// Returns the list of features to display on the login screen
  static List<LoginFeature> getFeatures() {
    return [
      LoginFeature(
        iconPath: Assets.icons.userIcon.path,
        iconBackgroundColor: const Color(0xFF2B7FFF).withValues(alpha: 0.5),
        titleKey: 'completeHrSuite',
        descriptionKey: 'completeHrSuiteDescription',
      ),
      LoginFeature(
        iconPath: Assets.icons.securityIcon.path,
        iconBackgroundColor: const Color(0xFF615FFF).withValues(alpha: 0.5),
        titleKey: 'advancedSecurity',
        descriptionKey: 'advancedSecurityDescription',
      ),
      LoginFeature(
        iconPath: Assets.icons.descriptionSectionIcon.path,
        iconBackgroundColor: const Color(0xFFAD46FF).withValues(alpha: 0.5),
        titleKey: 'kuwaitCompliance',
        descriptionKey: 'kuwaitComplianceDescription',
      ),
      LoginFeature(
        iconPath: Assets.icons.metricsIcon.path,
        iconBackgroundColor: const Color(0xFFF6339A).withValues(alpha: 0.5),
        titleKey: 'realTimeAnalytics',
        descriptionKey: 'realTimeAnalyticsDescription',
      ),
    ];
  }

  /// Returns the localized title for a given feature title key
  static String getLocalizedTitle(String key, AppLocalizations localizations) {
    switch (key) {
      case 'completeHrSuite':
        return localizations.completeHrSuite;
      case 'advancedSecurity':
        return localizations.advancedSecurity;
      case 'kuwaitCompliance':
        return localizations.kuwaitCompliance;
      case 'realTimeAnalytics':
        return localizations.realTimeAnalytics;
      default:
        return key;
    }
  }

  /// Returns the localized description for a given feature description key
  static String getLocalizedDescription(
    String key,
    AppLocalizations localizations,
  ) {
    switch (key) {
      case 'completeHrSuiteDescription':
        return localizations.completeHrSuiteDescription;
      case 'advancedSecurityDescription':
        return localizations.advancedSecurityDescription;
      case 'kuwaitComplianceDescription':
        return localizations.kuwaitComplianceDescription;
      case 'realTimeAnalyticsDescription':
        return localizations.realTimeAnalyticsDescription;
      default:
        return key;
    }
  }
}
