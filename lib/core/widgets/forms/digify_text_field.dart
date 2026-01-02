import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';

/// Universal DigifyTextField Widget
/// This is the ONLY text field widget that should be used across the entire app.
class DigifyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final bool filled;
  final TextInputAction? textInputAction;
  final bool showBorder;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool isRequired;
  final bool hasInfoIcon;
  final String? helperText;
  final String? errorText;
  final TextStyle? labelStyle;
  final TextStyle? helperTextStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final bool expands;
  final String? initialValue;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;
  final TextAlign textAlign;
  final TextDirection? textDirection;

  const DigifyTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.height,
    this.borderRadius,
    this.fontSize,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.filled = true,
    this.textInputAction,
    this.showBorder = true,
    this.onChanged,
    this.onSubmitted,
    this.isRequired = false,
    this.hasInfoIcon = false,
    this.helperText,
    this.errorText,
    this.labelStyle,
    this.helperTextStyle,
    this.hintStyle,
    this.textStyle,
    this.expands = false,
    this.initialValue,
    this.readOnly = false,
    this.onTap,
    this.enabled = true,
    this.contentPadding,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.autovalidateMode,
    this.textAlign = TextAlign.start,
    this.textDirection,
  });

  /// Factory for search fields with consistent styling
  factory DigifyTextField.search({
    required TextEditingController controller,
    String? hintText,
    double? height,
    bool filled = true,
    Color? fillColor,
    Color? borderColor,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    double? borderRadius,
  }) {
    return DigifyTextField(
      controller: controller,
      hintText: hintText,
      height: height ?? 40.h,
      borderRadius: borderRadius ?? 10.r,
      fontSize: 15.sp,
      filled: filled,
      fillColor: fillColor,
      borderColor: borderColor,
      prefixIcon: Icon(Icons.search, size: 16.sp),
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  @override
  State<DigifyTextField> createState() => _DigifyTextFieldState();
}

class _DigifyTextFieldState extends State<DigifyTextField> {
  late TextEditingController _controller;
  bool _obscureText = true;
  bool _isUserTyping = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    if (widget.controller != null && widget.initialValue != null) {
      widget.controller!.text = widget.initialValue!;
    }
    _obscureText = widget.obscureText;

    final controller = widget.controller ?? _controller;
    controller.addListener(() {
      _isUserTyping = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _isUserTyping = false;
        }
      });
    });
  }

  @override
  void didUpdateWidget(DigifyTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && !_isUserTyping) {
      final currentController = widget.controller ?? _controller;
      final currentText = currentController.text;
      if (widget.initialValue != null && widget.initialValue != currentText) {
        currentController.text = widget.initialValue!;
      } else if (widget.initialValue == null && currentText.isNotEmpty) {
        currentController.text = '';
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Theme.of(context);

    final effectiveBorderColor = widget.borderColor ?? (isDark ? AppColors.inputBorderDark : AppColors.inputBorder);
    final effectiveFocusedBorderColor = widget.focusedBorderColor ?? AppColors.primary;
    final effectiveFillColor = widget.fillColor ?? (isDark ? AppColors.inputBgDark : AppColors.inputBg);
    final effectiveTextColor = isDark ? context.themeTextPrimary : AppColors.textPrimary;

    // Custom hint color for light mode as requested: #0A0A0A with 0.5 alpha
    final effectiveHintColor = isDark ? context.themeTextMuted : const Color(0xFF0A0A0A).withValues(alpha: 0.5);

    // Provide defaults for height and radius
    final double effectiveHeight = widget.height ?? 40.h;
    final double effectiveRadius = widget.borderRadius ?? 10.r;

    Widget? labelWidget;
    if (widget.labelText != null) {
      labelWidget = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.labelText!,
            style:
                widget.labelStyle ??
                TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.8.sp,
                  fontWeight: FontWeight.w500,
                  height: 20 / 13.8,
                  color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                ),
          ),
          if (widget.isRequired) ...[
            SizedBox(width: 4.w),
            Text(
              '*',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                height: 20 / 13.8,
                color: AppColors.deleteIconRed,
              ),
            ),
          ],
          if (widget.hasInfoIcon) ...[
            SizedBox(width: 6.w),
            Icon(
              Icons.info_outline,
              size: 12.sp,
              color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
            ),
          ],
        ],
      );
    }

    Widget? effectiveSuffixIcon = widget.suffixIcon;
    if (widget.obscureText && widget.suffixIcon == null) {
      effectiveSuffixIcon = InkWell(
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 16.sp,
          color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
        ),
      );
    }

    Widget textField = TextFormField(
      controller: _controller,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      obscureText: widget.obscureText ? _obscureText : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.expands ? null : (widget.obscureText ? 1 : widget.maxLines),
      minLines: widget.minLines,
      expands: widget.expands,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      autovalidateMode: widget.autovalidateMode,
      style:
          widget.textStyle ??
          TextStyle(
            fontFamily: 'Inter',
            fontSize: widget.fontSize ?? 13.7.sp,
            fontWeight: FontWeight.w400,
            color: effectiveTextColor,
          ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        errorText: widget.errorText,
        labelText: widget.labelText == null || labelWidget != null ? null : widget.labelText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: effectiveSuffixIcon,
        filled: widget.filled,
        fillColor: effectiveFillColor,
        hintStyle:
            widget.hintStyle ??
            TextStyle(
              fontFamily: 'Inter',
              // Font size 15.3 as requested for hint
              fontSize: 15.3.sp,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              color: effectiveHintColor,
            ),
        prefixIconConstraints: BoxConstraints(minWidth: 40.w, minHeight: 16.h),
        suffixIconConstraints: BoxConstraints(minWidth: 40.w, minHeight: 16.h),
        isDense: true,
        errorStyle: TextStyle(fontSize: 12.sp, color: AppColors.error, height: 1),
        border: widget.showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveRadius),
                borderSide: BorderSide(color: effectiveBorderColor),
              )
            : InputBorder.none,
        enabledBorder: widget.showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveRadius),
                borderSide: BorderSide(color: effectiveBorderColor),
              )
            : InputBorder.none,
        disabledBorder: widget.showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveRadius),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.borderGreyDark.withValues(alpha: 0.5)
                      : AppColors.borderGrey.withValues(alpha: 0.5),
                ),
              )
            : InputBorder.none,
        focusedBorder: widget.showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveRadius),
                borderSide: BorderSide(color: effectiveFocusedBorderColor, width: 1.5.w),
              )
            : InputBorder.none,
        errorBorder: widget.showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveRadius),
                borderSide: const BorderSide(color: AppColors.error),
              )
            : InputBorder.none,
        focusedErrorBorder: widget.showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(effectiveRadius),
                borderSide: BorderSide(color: AppColors.error, width: 1.5.w),
              )
            : InputBorder.none,
      ),
    );

    final isDateField = widget.onTap != null && widget.readOnly;

    // For heights below 48, isDense: true is required for proper layout.
    // Use minHeight instead of a fixed-height SizedBox to prevent shrinking when error text appears.
    Widget field = ConstrainedBox(
      constraints: BoxConstraints(minHeight: effectiveHeight),
      child: textField,
    );

    if (labelWidget != null || widget.helperText != null) {
      Widget content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (labelWidget != null) ...[labelWidget, SizedBox(height: 8.h)],
          field,
          if (widget.helperText != null) ...[
            SizedBox(height: 12.h),
            Text(
              widget.helperText!,
              style:
                  widget.helperTextStyle ??
                  TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.8.sp,
                    fontWeight: FontWeight.w400,
                    height: 16 / 11.8,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
            ),
          ],
        ],
      );

      if (isDateField) {
        return GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (labelWidget != null) ...[labelWidget, SizedBox(height: 8.h)],
              AbsorbPointer(child: field),
              if (widget.helperText != null) ...[
                SizedBox(height: 12.h),
                Text(
                  widget.helperText!,
                  style:
                      widget.helperTextStyle ??
                      TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.8.sp,
                        fontWeight: FontWeight.w400,
                        height: 16 / 11.8,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                ),
              ],
            ],
          ),
        );
      }
      return content;
    }

    if (isDateField) {
      return GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AbsorbPointer(child: field),
      );
    }

    return field;
  }
}
