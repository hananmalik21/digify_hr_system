import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/debouncer.dart';
import 'package:digify_hr_system/core/theme/app_shadows.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReportingToEmployeeSearchField extends ConsumerStatefulWidget {
  final String label;
  final bool isRequired;
  final EmployeeListItem? selectedEmployee;
  final ValueChanged<EmployeeListItem> onEmployeeSelected;
  final String? hintText;

  const ReportingToEmployeeSearchField({
    super.key,
    required this.label,
    required this.onEmployeeSelected,
    this.isRequired = false,
    this.selectedEmployee,
    this.hintText,
  });

  @override
  ConsumerState<ReportingToEmployeeSearchField> createState() => _ReportingToEmployeeSearchFieldState();
}

class _ReportingToEmployeeSearchFieldState extends ConsumerState<ReportingToEmployeeSearchField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 400));
  OverlayEntry? _overlayEntry;
  bool _showSuggestions = false;
  List<EmployeeListItem> _employees = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedEmployee?.fullNameDisplay ?? '');
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(ReportingToEmployeeSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedEmployee?.id != oldWidget.selectedEmployee?.id) {
      _controller.text = widget.selectedEmployee?.fullNameDisplay ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debouncer.dispose();
    _removeOverlay(updateState: false);
    super.dispose();
  }

  Future<void> _search(String? query) async {
    final enterpriseId = ref.read(manageEmployeesEnterpriseIdProvider);
    if (enterpriseId == null) {
      if (mounted) {
        setState(() => _employees = []);
        if (_showSuggestions) _updateOverlay();
      }
      return;
    }
    if (mounted) {
      setState(() => _loading = true);
      if (_showSuggestions) _updateOverlay();
    }
    final repository = ref.read(manageEmployeesListRepositoryProvider);
    try {
      final result = await repository.getEmployees(
        enterpriseId: enterpriseId,
        page: 1,
        pageSize: 25,
        search: query == null || query.isEmpty ? null : query,
      );
      if (!mounted) return;
      setState(() {
        _employees = result.items;
        _loading = false;
      });
      if (_showSuggestions) _updateOverlay();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _employees = [];
        _loading = false;
      });
      if (_showSuggestions) _updateOverlay();
    }
  }

  void _handleSearch(String value) {
    _debouncer.run(() {
      if (!mounted) return;
      final query = _controller.text.trim();
      _search(query.isEmpty ? null : query);
    });
  }

  void _showOverlay() {
    if (_showSuggestions) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    if (mounted) setState(() => _showSuggestions = true);
  }

  void _removeOverlay({bool updateState = true}) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (updateState && mounted) setState(() => _showSuggestions = false);
  }

  void _updateOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    final isDark = context.isDark;
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final localizations = AppLocalizations.of(context)!;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4.h),
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(maxHeight: 300.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
                boxShadow: AppShadows.primaryShadow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: _loading && _employees.isEmpty
                    ? Skeletonizer(
                        enabled: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32.w,
                                    height: 32.h,
                                    decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
                                  ),
                                  Gap(12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 14.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                        ),
                                        Gap(6.h),
                                        Container(
                                          width: 150.w,
                                          height: 12.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(4.r),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : _employees.isEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48.r,
                              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                            ),
                            Gap(12.h),
                            Text(
                              localizations.noResultsFound,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                              ),
                            ),
                            Gap(4.h),
                            Text(
                              localizations.tryAdjustingSearchCriteria,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        itemCount: _employees.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          thickness: 1,
                          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                          indent: 16.w,
                          endIndent: 16.w,
                        ),
                        itemBuilder: (context, index) {
                          final employee = _employees[index];
                          final isSelected = widget.selectedEmployee?.id == employee.id;
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _controller.text = employee.fullNameDisplay;
                                widget.onEmployeeSelected(employee);
                                _focusNode.unfocus();
                                _removeOverlay();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? (isDark
                                            ? AppColors.primary.withValues(alpha: 0.15)
                                            : AppColors.primary.withValues(alpha: 0.08))
                                      : Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40.w,
                                      height: 40.h,
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.primary.withValues(alpha: 0.2)
                                            : AppColors.primary.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          employee.initial,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gap(12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            employee.fullNameDisplay,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                            ),
                                          ),
                                          Gap(2.h),
                                          Text(
                                            employee.employeeNumberDisplay,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(Icons.check_circle_rounded, size: 20.r, color: AppColors.primary),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                  fontFamily: 'Inter',
                ),
              ),
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.error,
                    fontFamily: 'Inter',
                  ),
                ),
            ],
          ),
        ),
        Gap(8.h),
        CompositedTransformTarget(
          link: _layerLink,
          child: DigifyTextField(
            controller: _controller,
            hintText: widget.hintText ?? localizations.typeToSearchEmployees,
            focusNode: _focusNode,
            prefixIcon: Padding(
              padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
              child: DigifyAsset(
                assetPath: Assets.icons.searchIcon.path,
                width: 20,
                height: 20,
                color: AppColors.textMuted,
              ),
            ),
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              _handleSearch(value);
              if (!_showSuggestions && _focusNode.hasFocus) {
                _showOverlay();
              } else if (_showSuggestions) {
                _updateOverlay();
              }
            },
            filled: true,
            fillColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
