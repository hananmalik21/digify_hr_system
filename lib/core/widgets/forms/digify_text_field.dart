import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:intl/intl.dart' show DateFormat;

class DigifyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool isRequired;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final bool filled;
  final TextInputAction? textInputAction;
  final bool showBorder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool enabled;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;
  final String? initialValue;
  final double? fontSize;
  final EdgeInsetsGeometry? contentPadding;

  const DigifyTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.isRequired = false,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.filled = false,
    this.textInputAction,
    this.showBorder = true,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.onTap,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.inputFormatters,
    this.autovalidateMode,
    this.focusNode,
    this.initialValue,
    this.fontSize,
    this.contentPadding,
  });

  factory DigifyTextField.search({
    required TextEditingController controller,
    String? hintText,
    bool filled = false,
    Color? fillColor,
    Color? borderColor,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return DigifyTextField(
      controller: controller,
      hintText: hintText,
      filled: filled,
      fillColor: fillColor ?? Colors.transparent,
      borderColor: borderColor,
      prefixIcon: Padding(
        padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
        child: DigifyAsset(assetPath: Assets.icons.searchIcon.path, width: 20, height: 20, color: AppColors.textMuted),
      ),
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  factory DigifyTextField.normal({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    bool isRequired = false,
    bool enabled = true,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    int? maxLines = 1,
    bool readOnly = false,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return DigifyTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      isRequired: isRequired,
      enabled: enabled,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      textDirection: textDirection,
      textAlign: textAlign,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      filled: true,
      fillColor: Colors.transparent,
    );
  }

  factory DigifyTextField.number({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    bool isRequired = false,
    bool enabled = true,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    FocusNode? focusNode,
    bool? filled,
    Color? fillColor,
  }) {
    return DigifyTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      isRequired: isRequired,
      enabled: enabled,
      readOnly: readOnly,
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.number,
      inputFormatters: inputFormatters ?? [FilteringTextInputFormatter.digitsOnly],
      focusNode: focusNode,
      filled: filled ?? true,
      fillColor: fillColor ?? Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
    );
  }

  @override
  State<DigifyTextField> createState() => _DigifyTextFieldState();
}

class _DigifyTextFieldState extends State<DigifyTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveFillColor = widget.fillColor ?? (isDark ? AppColors.inputBgDark : Colors.transparent);
    final effectiveBorderColor = widget.borderColor ?? (isDark ? AppColors.inputBorderDark : AppColors.inputBorder);
    final effectiveFocusedColor = widget.focusedBorderColor ?? AppColors.primary;

    Widget field = TextFormField(
      controller: widget.controller,
      initialValue: widget.controller == null ? widget.initialValue : null,
      obscureText: widget.obscureText ? _obscureText : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      inputFormatters: widget.inputFormatters,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      autovalidateMode: widget.autovalidateMode,
      focusNode: widget.focusNode,
      style: TextStyle(
        fontSize: widget.fontSize ?? 15.sp,
        color: isDark ? context.themeTextPrimary : AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText && widget.suffixIcon == null
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 20.sp,
                  color: AppColors.textPlaceholder,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : widget.suffixIcon,
        filled: widget.filled,
        fillColor: effectiveFillColor,
        isDense: true,
        contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        hintStyle: TextStyle(
          fontSize: widget.fontSize ?? 15.sp,
          height: 1.0,
          color: isDark ? context.themeTextMuted : const Color(0xFF0A0A0A).withValues(alpha: 0.5),
        ),
        errorStyle: TextStyle(fontSize: 12.sp, color: AppColors.error, height: 1.2),
        border: _buildBorder(10.r, effectiveBorderColor),
        enabledBorder: _buildBorder(10.r, effectiveBorderColor),
        focusedBorder: _buildBorder(10.r, effectiveFocusedColor, width: 1.5),
        errorBorder: _buildBorder(10.r, AppColors.error),
        focusedErrorBorder: _buildBorder(10.r, AppColors.error, width: 1.5),
      ),
    );

    if (widget.onTap != null && widget.readOnly) {
      field = GestureDetector(
        onTap: widget.onTap,
        child: AbsorbPointer(child: field),
      );
    }

    // Apply height constraint only for single-line fields
    final shouldConstrainHeight = (widget.maxLines == null || widget.maxLines == 1) && widget.minLines == null;
    
    if (widget.labelText != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.labelText,
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
                      color: AppColors.deleteIconRed,
                      fontFamily: 'Inter',
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          shouldConstrainHeight
              ? SizedBox(height: 36.h, child: field)
              : field,
        ],
      );
    }

    return shouldConstrainHeight
        ? SizedBox(height: 36.h, child: field)
        : field;
  }

  InputBorder _buildBorder(double radius, Color color, {double width = 1.0}) {
    if (!widget.showBorder) return InputBorder.none;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width.w),
    );
  }
}

class DigifyTextArea extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool isRequired;
  final int maxLines;
  final int? minLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final bool enabled;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final List<TextInputFormatter>? inputFormatters;
  final bool showCharacterCount;
  final int? maxLength;
  final String Function(int)? characterCountFormatter;
  final Color? fillColor;

  const DigifyTextArea({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.isRequired = false,
    this.maxLines = 3,
    this.minLines,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.inputFormatters,
    this.showCharacterCount = false,
    this.maxLength,
    this.characterCountFormatter,
    this.fillColor,
  });

  @override
  State<DigifyTextArea> createState() => _DigifyTextAreaState();
}

class _DigifyTextAreaState extends State<DigifyTextArea> {
  late TextEditingController _internalController;
  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController();
      _isInternalController = true;
    } else {
      _internalController = widget.controller!;
    }
    if (widget.showCharacterCount) {
      _internalController.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    if (widget.showCharacterCount) {
      _internalController.removeListener(_onTextChanged);
    }
    if (_isInternalController) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.showCharacterCount) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveMinLines = widget.minLines ?? widget.maxLines;
    final currentLength = _internalController.text.length;
    final maxLength = widget.maxLength;
    final isOverLimit = maxLength != null && currentLength > maxLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.labelText,
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
                      color: AppColors.deleteIconRed,
                      fontFamily: 'Inter',
                    ),
                  ),
              ],
            ),
          ),
        if (widget.labelText != null) SizedBox(height: 8.h),
        TextFormField(
          controller: _internalController,
          maxLines: widget.maxLines,
          minLines: effectiveMinLines,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLength: widget.maxLength,
          onChanged: (value) {
            if (widget.showCharacterCount) {
              setState(() {});
            }
            widget.onChanged?.call(value);
          },
          textAlign: widget.textDirection == TextDirection.rtl ? TextAlign.right : widget.textAlign,
          textDirection: widget.textDirection,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(fontSize: 15.sp, color: isDark ? context.themeTextPrimary : AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hintText,
            filled: true,
            fillColor: widget.fillColor ?? (isDark ? AppColors.inputBgDark : Colors.transparent),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            hintStyle: TextStyle(
              fontSize: 15.sp,
              height: 1.0,
              color: isDark ? context.themeTextMuted : const Color(0xFF0A0A0A).withValues(alpha: 0.5),
            ),
            border: _buildBorder(isDark, AppColors.inputBorder),
            enabledBorder: _buildBorder(isDark, isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
            focusedBorder: _buildBorder(isDark, AppColors.primary, width: 1.5),
            errorBorder: _buildBorder(isDark, AppColors.error),
            focusedErrorBorder: _buildBorder(isDark, AppColors.error, width: 1.5),
            counterText: widget.showCharacterCount ? '' : null,
          ),
          validator: widget.validator,
        ),
        if (widget.showCharacterCount) ...[
          SizedBox(height: 2.h),
          Text(
            widget.characterCountFormatter != null
                ? widget.characterCountFormatter!(currentLength)
                : maxLength != null
                ? '$currentLength / $maxLength'
                : '$currentLength',
            style: context.textTheme.bodySmall?.copyWith(
              color: isOverLimit ? AppColors.error : AppColors.textSecondary,
              fontSize: 11.8.sp,
            ),
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _buildBorder(bool isDark, Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(
        color: isDark && color == AppColors.inputBorder ? AppColors.inputBorderDark : color,
        width: width.w,
      ),
    );
  }
}

class DigifyDateField extends StatefulWidget {
  final String label;
  final String? hintText;
  final bool isRequired;
  final String? calendarIconPath;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateSelected;
  final Color? fillColor;

  const DigifyDateField({
    super.key,
    required this.label,
    this.hintText,
    this.isRequired = true,
    this.calendarIconPath,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.fillColor,
  });

  @override
  State<DigifyDateField> createState() => _DigifyDateFieldState();
}

class _DigifyDateFieldState extends State<DigifyDateField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _date = widget.initialDate;
      _controller.text = DateFormat('dd/MM/yyyy').format(widget.initialDate!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _date = picked;
        _controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final iconPath = widget.calendarIconPath ?? Assets.icons.leaveManagementIcon.path;

    return DigifyTextField(
      labelText: widget.label,
      isRequired: widget.isRequired,
      controller: _controller,
      hintText: widget.hintText,
      readOnly: true,
      onTap: _openDatePicker,
      filled: widget.fillColor != null,
      fillColor: widget.fillColor,
      prefixIcon: Padding(
        padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
        child: DigifyAsset(
          assetPath: iconPath,
          width: 20,
          height: 20,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
        ),
      ),
    );
  }
}
