import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'header_search_field.dart';

class HeaderWelcomeSection extends StatefulWidget {
  const HeaderWelcomeSection({super.key, required this.localizations, required this.isTablet, required this.isDark});

  final AppLocalizations localizations;
  final bool isTablet;
  final bool isDark;

  @override
  State<HeaderWelcomeSection> createState() => _HeaderWelcomeSectionState();
}

class _HeaderWelcomeSectionState extends State<HeaderWelcomeSection> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500.w),
        child: HeaderSearchField(
          controller: _searchController,
          hintText: widget.localizations.search,
          isDark: widget.isDark,
          onSubmitted: (value) {
            // Handle search
          },
        ),
      ),
    );
  }
}
