import 'dart:math' as math;
import 'dart:ui';

import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/common/app_loading_indicator.dart';
import 'package:digify_hr_system/core/widgets/forms/custom_text_field.dart';
import 'package:digify_hr_system/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final localizations = AppLocalizations.of(context)!;

    await ref
        .read(authProvider.notifier)
        .login(_usernameController.text.trim(), _passwordController.text);

    if (!mounted) return;

    final authState = ref.read(authProvider);
    debugPrint("state is ${authState}");
    if (authState.isAuthenticated) {
      context.go('/dashboard');
    } else if (authState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.invalidCredentials),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF155DFC), Color(0xFF4F39F6), Color(0xFF8200DB)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;

              // Better breakpoints (tablet portrait is usually 768..900)
              final isMobile = w < 600;
              final isTablet = w >= 600 && w < 1024;
              final isShortHeight = h < 700; // avoids overflow on short screens

              if (isMobile) {
                return _buildStackedLayout(
                  localizations: localizations,
                  authState: authState,
                  constraints: constraints,
                  showInfoPanel: false,
                  isShortHeight: isShortHeight,
                );
              }

              // Tablet portrait / small tablet -> stacked (prevents squish)
              if (isTablet && w < 900) {
                return _buildStackedLayout(
                  localizations: localizations,
                  authState: authState,
                  constraints: constraints,
                  showInfoPanel: true,
                  isShortHeight: isShortHeight,
                );
              }

              // Tablet landscape + Desktop -> side-by-side
              return _buildSideBySideLayout(
                localizations: localizations,
                authState: authState,
                constraints: constraints,
              );
            },
          ),
        ),
      ),
    );
  }

  /// Mobile OR Tablet-portrait: branding (optional info) + card, scrollable
  Widget _buildStackedLayout({
    required AppLocalizations localizations,
    required AuthState authState,
    required BoxConstraints constraints,
    required bool showInfoPanel,
    required bool isShortHeight,
  }) {
    final maxWidth = math.min(constraints.maxWidth, 560.0);
    final horizontal = math.max(16.0, (constraints.maxWidth - maxWidth) / 2);

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(horizontal, 16.h, horizontal, 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: isShortHeight ? 12.h : 24.h),
            Center(
              child: _buildBranding(
                localizations,
                center: true,
                maxWidth: maxWidth,
              ),
            ),
            SizedBox(height: 20.h),
            if (showInfoPanel) ...[
              _buildSystemDescription(
                localizations,
                maxWidth: maxWidth,
                center: true,
              ),
              SizedBox(height: 14.h),
              _buildFeatureCards(localizations, maxWidth: maxWidth),
              SizedBox(height: 20.h),
            ],
            _buildLoginCard(
              localizations: localizations,
              authState: authState,
              maxWidth: maxWidth,
            ),
          ],
        ),
      ),
    );
  }

  /// Tablet landscape / Desktop: info left + card right
  Widget _buildSideBySideLayout({
    required AppLocalizations localizations,
    required AuthState authState,
    required BoxConstraints constraints,
  }) {
    final pageMax = math.min(constraints.maxWidth, 1200.0);
    final paddingH = math.max(16.0, (constraints.maxWidth - pageMax) / 2);

    // Card width clamps so it never becomes too wide or too tight
    final cardWidth = math.min(
      520.0,
      math.max(420.0, constraints.maxWidth * 0.36),
    );
    final gap = math.min(48.0, math.max(20.0, constraints.maxWidth * 0.04));

    return SingleChildScrollView(
      // scroll on desktop too (prevents overflow on short-height displays)
      padding: EdgeInsets.fromLTRB(paddingH, 16.h, paddingH, 24.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight - 40.h),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildInfoPanel(localizations)),
              SizedBox(width: gap),
              SizedBox(
                width: cardWidth,
                child: Align(
                  alignment: Alignment.center,
                  child: _buildLoginCard(
                    localizations: localizations,
                    authState: authState,
                    maxWidth: cardWidth,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPanel(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBranding(localizations, center: false),
        SizedBox(height: 24.h),
        _buildSystemDescription(localizations, center: false),
        SizedBox(height: 14.h),
        _buildFeatureCards(localizations),
      ],
    );
  }

  Widget _buildBranding(
    AppLocalizations localizations, {
    required bool center,
    double? maxWidth,
  }) {
    // Clamp headline sizes across screens
    final titleSize = (center ? 30.sp : 34.5.sp).clamp(24.0, 36.0);
    final subSize = (center ? 14.sp : 16.9.sp).clamp(12.0, 18.0);

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: const DigifyAsset(
                assetPath: 'assets/icons/security_icon.svg',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.digifyHrTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.16,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                localizations.kuwaitLaborLawCompliant,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: subSize,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xFFDBEAFE),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final content = maxWidth == null
        ? row
        : ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: row,
          );

    return center ? Center(child: content) : content;
  }

  Widget _buildSystemDescription(
    AppLocalizations localizations, {
    required bool center,
    double? maxWidth,
  }) {
    final text = Text(
      localizations.systemDescription,
      textAlign: center ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: 16.5.sp.clamp(14.0, 18.5),
        fontWeight: FontWeight.normal,
        color: const Color(0xFFEFF6FF),
        height: 1.7,
      ),
    );

    final content = maxWidth == null
        ? text
        : ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: text,
          );

    return content;
  }

  Widget _buildFeatureCards(
    AppLocalizations localizations, {
    double? maxWidth,
  }) {
    final features = [
      {
        'icon': 'assets/icons/user_icon.svg',
        'iconBg': const Color(0xFF2B7FFF).withOpacity(0.5),
        'title': localizations.completeHrSuite,
        'description': localizations.completeHrSuiteDescription,
      },
      {
        'icon': 'assets/icons/security_icon.svg',
        'iconBg': const Color(0xFF615FFF).withOpacity(0.5),
        'title': localizations.advancedSecurity,
        'description': localizations.advancedSecurityDescription,
      },
      {
        'icon': 'assets/icons/description_section_icon.svg',
        'iconBg': const Color(0xFFAD46FF).withOpacity(0.5),
        'title': localizations.kuwaitCompliance,
        'description': localizations.kuwaitComplianceDescription,
      },
      {
        'icon': 'assets/icons/metrics_icon.svg',
        'iconBg': const Color(0xFFF6339A).withOpacity(0.5),
        'title': localizations.realTimeAnalytics,
        'description': localizations.realTimeAnalyticsDescription,
      },
    ];

    final list = Column(
      children: features.map((feature) {
        return Padding(
          padding: EdgeInsets.only(bottom: 14.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: feature['iconBg'] as Color,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: DigifyAsset(
                        assetPath: feature['icon'] as String,
                        width: 22,
                        height: 22,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature['title'] as String,
                            style: TextStyle(
                              fontSize: 15.5.sp.clamp(13.5, 17.5),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            feature['description'] as String,
                            style: TextStyle(
                              fontSize: 12.8.sp.clamp(11.5, 14.0),
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFFDBEAFE),
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );

    return maxWidth == null
        ? list
        : ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: list,
          );
  }

  Widget _buildLoginCard({
    required AppLocalizations localizations,
    required AuthState authState,
    required double maxWidth,
  }) {
    // Adaptive padding for small/medium widths
    final innerPad = (maxWidth < 420 ? 20.0 : 28.0);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 50,
                offset: const Offset(0, 25),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(innerPad.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              // important: prevents forced height
              children: [
                // Header
                Column(
                  children: [
                    Text(
                      localizations.welcomeBack,
                      style: TextStyle(
                        fontSize: 26.sp.clamp(20.0, 30.0),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF101828),
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      localizations.signInToAccessDashboard,
                      style: TextStyle(
                        fontSize: 14.5.sp.clamp(12.5, 16.0),
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF4A5565),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        labelText: localizations.username,
                        hintText: localizations.usernameHint,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: 12.w,
                            end: 12.w,
                          ),
                          child: DigifyAsset(
                            assetPath: 'assets/icons/email_card_icon.svg',
                            width: 20,
                            height: 20,
                            color: AppColors.textPlaceholder,
                          ),
                        ),
                        onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                        validator: (value) => (value == null || value.isEmpty)
                            ? localizations.fieldRequired
                            : null,
                      ),
                      SizedBox(height: 18.h),
                      CustomTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        labelText: localizations.password,
                        hintText: localizations.passwordHint,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        prefixIcon: Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: 12.w,
                            end: 12.w,
                          ),
                          child: DigifyAsset(
                            assetPath: 'assets/icons/lock_icon.svg',
                            width: 20,
                            height: 20,
                            color: AppColors.textPlaceholder,
                          ),
                        ),
                        onSubmitted: (_) => _handleLogin(),
                        validator: (value) => (value == null || value.isEmpty)
                            ? localizations.fieldRequired
                            : null,
                      ),
                      SizedBox(height: 18.h),

                      _buildPrimaryButton(
                        text: localizations.signIn,
                        isLoading: authState.isLoading,
                        onTap: authState.isLoading ? null : _handleLogin,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 18.h),
                const Divider(color: Color(0xFFE5E7EB), thickness: 1),
                // SizedBox(height: 18.h),
                //
                // _buildDemoCredentials(localizations),
                SizedBox(height: 22.h),

                Text(
                  localizations.copyrightText,
                  style: TextStyle(
                    fontSize: 12.8.sp.clamp(11.0, 14.0),
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF6A7282),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required bool isLoading,
    required VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF155DFC), Color(0xFF4F39F6)],
        ),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: SizedBox(
            height: 48.h,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      child: AppLoadingIndicator(
                        color: Colors.white,
                        type: LoadingType.threeBounce,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 15.5.sp.clamp(13.5, 16.5),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDemoCredentials(AppLocalizations localizations) {
    final credentials = [
      {
        'role': 'Admin',
        'username': 'admin@digify.com',
        'password': 'Digify@@2025',
      },
    ];

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            localizations.demoCredentials,
            style: TextStyle(
              fontSize: 13.5.sp.clamp(12.0, 14.5),
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1C398E),
              height: 1.4,
            ),
          ),
          SizedBox(height: 10.h),
          ...credentials.map((cred) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: const DigifyAsset(
                      assetPath: 'assets/icons/check_icon_green.svg',
                      width: 16,
                      height: 16,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13.5.sp.clamp(12.0, 14.5),
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: '${cred['role']}: ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF101828),
                            ),
                          ),
                          TextSpan(
                            text: '${cred['username']} / ${cred['password']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF364153),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 10.h),
          _buildPrimaryButton(
            text: localizations.resetDemoUsers,
            isLoading: false,
            onTap: () {
              // TODO: Implement reset demo users functionality
            },
          ),
        ],
      ),
    );
  }
}
