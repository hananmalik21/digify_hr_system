import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/forms/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Searchable dropdown with pagination for selecting items
class PaginatedDropdown<T> extends StatefulWidget {
  final String label;
  final bool isRequired;
  final T? value;
  final List<T> items;
  final String Function(T) getDisplayText;
  final String Function(T)? getSearchText;
  final ValueChanged<T?> onChanged;
  final String? hintText;
  final bool enabled;
  final int itemsPerPage;
  final Widget Function(T)? itemBuilder;
  final String? Function(T?)? validator;

  const PaginatedDropdown({
    super.key,
    required this.label,
    this.isRequired = false,
    this.value,
    required this.items,
    required this.getDisplayText,
    this.getSearchText,
    required this.onChanged,
    this.hintText,
    this.enabled = true,
    this.itemsPerPage = 10,
    this.itemBuilder,
    this.validator,
  });

  @override
  State<PaginatedDropdown<T>> createState() => _PaginatedDropdownState<T>();
}

class _PaginatedDropdownState<T> extends State<PaginatedDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 0;
  final String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<T> get _filteredItems {
    if (_searchQuery.isEmpty) {
      return widget.items;
    }
    final searchText = _searchQuery.toLowerCase();
    return widget.items.where((item) {
      final displayText = widget.getDisplayText(item).toLowerCase();
      final customSearchText = widget.getSearchText?.call(item).toLowerCase();
      return displayText.contains(searchText) ||
          (customSearchText != null && customSearchText.contains(searchText));
    }).toList();
  }

  List<T> get _paginatedItems {
    final start = _currentPage * widget.itemsPerPage;
    final end = (start + widget.itemsPerPage).clamp(0, _filteredItems.length);
    return _filteredItems.sublist(start, end);
  }

  int get _totalPages => (_filteredItems.length / widget.itemsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: widget.label,
            style: TextStyle(
              fontSize: 13.8.sp,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : const Color(0xFF364153),
              height: 20 / 13.8,
              letterSpacing: 0,
            ),
            children: widget.isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.errorTextDark
                            : const Color(0xFFFB2C36),
                      ),
                    ),
                  ]
                : null,
          ),
        ),
        SizedBox(height: 8.h),
        _buildDropdown(context, isDark),
      ],
    );
  }

  Widget _buildDropdown(BuildContext context, bool isDark) {
    return PopupMenuButton<T>(
      enabled: widget.enabled,
      initialValue: widget.value,
      onSelected: (value) {
        widget.onChanged(value);
        Navigator.of(context).pop();
      },
      itemBuilder: (context) => [
        // Search field
        PopupMenuItem<T>(
          enabled: false,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField.search(
                    controller: _searchController,
                    hintText: widget.hintText ?? 'Search...',
                    height: 39.h,
                    filled: true,
                    fillColor: isDark
                        ? AppColors.inputBgDark
                        : AppColors.inputBg,
                  ),
                  SizedBox(height: 8.h),
                  // Items list
                  ...(_paginatedItems.map((item) {
                    final isSelected = widget.value == item;
                    return PopupMenuItem<T>(
                      value: item,
                      child: Container(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                    ? AppColors.primary.withValues(alpha: 0.1)
                                    : AppColors.primary.withValues(alpha: 0.05))
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: widget.itemBuilder != null
                            ? widget.itemBuilder!(item)
                            : Text(
                                widget.getDisplayText(item),
                                style: TextStyle(
                                  fontSize: 13.7.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark
                                            ? AppColors.textPrimaryDark
                                            : AppColors.textPrimary),
                                  height: 20 / 13.7,
                                ),
                              ),
                      ),
                    );
                  }).toList()),
                  // Pagination controls
                  if (_totalPages > 1)
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: _currentPage > 0
                                ? () {
                                    setState(() {
                                      _currentPage--;
                                    });
                                  }
                                : null,
                            iconSize: 20.sp,
                          ),
                          Text(
                            '${_currentPage + 1} / $_totalPages',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: _currentPage < _totalPages - 1
                                ? () {
                                    setState(() {
                                      _currentPage++;
                                    });
                                  }
                                : null,
                            iconSize: 20.sp,
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 17.w,
          vertical: 9.h,
        ),
        decoration: BoxDecoration(
          color: widget.enabled
              ? (isDark ? AppColors.inputBgDark : AppColors.inputBg)
              : (isDark
                    ? AppColors.cardBackgroundGreyDark
                    : AppColors.cardBackgroundGrey),
          border: Border.all(
            color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.value != null
                    ? widget.getDisplayText(widget.value as T)
                    : (widget.hintText ?? 'Select...'),
                style: TextStyle(
                  fontSize: 15.3.sp,
                  fontWeight: FontWeight.w400,
                  color: widget.value != null
                      ? (isDark
                            ? AppColors.textPrimaryDark
                            : const Color(0xFF0A0A0A))
                      : (isDark
                            ? AppColors.textPlaceholderDark
                            : AppColors.textPlaceholder),
                  height: 24 / 15.3,
                  letterSpacing: 0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 24.sp,
              color: isDark
                  ? AppColors.textPlaceholderDark
                  : AppColors.textPlaceholder,
            ),
          ],
        ),
      ),
    );
  }
}
