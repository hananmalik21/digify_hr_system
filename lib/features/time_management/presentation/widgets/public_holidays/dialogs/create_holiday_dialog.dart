import 'dart:ui' as ui;
import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/enums/time_management_enums.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/time_management/data/config/public_holidays_config.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/public_holidays_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CreateHolidayDialog extends ConsumerStatefulWidget {
  const CreateHolidayDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, barrierDismissible: false, builder: (context) => const CreateHolidayDialog());
  }

  @override
  ConsumerState<CreateHolidayDialog> createState() => _CreateHolidayDialogState();
}

class _CreateHolidayDialogState extends ConsumerState<CreateHolidayDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;
  late final TextEditingController _dateController;
  late final TextEditingController _descriptionEnController;
  late final TextEditingController _descriptionArController;
  late final TextEditingController _yearController;

  HolidayType? _selectedType;
  String? _selectedAppliesTo;
  final bool _isPaidHoliday = true;
  bool _isSubmitting = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController();
    _nameArController = TextEditingController();
    _dateController = TextEditingController();
    _descriptionEnController = TextEditingController();
    _descriptionArController = TextEditingController();
    _yearController = TextEditingController(text: DateTime.now().year.toString());
    _selectedType = HolidayType.fixed;
    _selectedAppliesTo = PublicHolidaysConfig.availableAppliesTo.first;
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();
    _dateController.dispose();
    _descriptionEnController.dispose();
    _descriptionArController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 10);
    final DateTime lastDate = DateTime(now.year + 10);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: isDark ? AppColors.cardBackgroundDark : Colors.white,
              onSurface: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
        _yearController.text = picked.year.toString();
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      ToastService.error(context, 'Please select a date');
      return;
    }

    if (_selectedType == null) {
      ToastService.error(context, 'Please select a holiday type');
      return;
    }

    if (_selectedAppliesTo == null) {
      ToastService.error(context, 'Please select who this holiday applies to');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final useCase = ref.read(createPublicHolidayUseCaseProvider);
      final appliesToApiValue = PublicHolidaysConfig.getAppliesToApiValue(_selectedAppliesTo!);
      final notifier = ref.read(publicHolidaysNotifierProvider.notifier);

      final createdHoliday = await useCase.execute(
        tenantId: 1,
        nameEn: _nameEnController.text.trim(),
        nameAr: _nameArController.text.trim(),
        date: _selectedDate!,
        year: int.parse(_yearController.text.trim()),
        type: _selectedType!,
        descriptionEn: _descriptionEnController.text.trim(),
        descriptionAr: _descriptionArController.text.trim(),
        appliesTo: appliesToApiValue ?? 'ALL',
        isPaid: _isPaidHoliday,
      );

      if (mounted) {
        notifier.addHolidayOptimistically(createdHoliday);
        ToastService.success(context, 'Holiday created successfully');
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ToastService.error(context, 'Failed to create holiday: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return AppDialog(
      title: 'Add New Holiday',
      width: 768.w,
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    controller: _nameEnController,
                    labelText: 'Holiday Name (English)',
                    hintText: 'e.g., National Day',
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Holiday name in English is required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Directionality(
                    textDirection: ui.TextDirection.rtl,
                    child: DigifyTextField(
                      controller: _nameArController,
                      labelText: 'Holiday Name (Arabic)',
                      hintText: 'اليوم الوطني',
                      isRequired: true,
                      inputFormatters: [AppInputFormatters.nameAr],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Holiday name in Arabic is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    controller: _dateController,
                    labelText: 'Date',
                    hintText: 'dd/mm/yyyy',
                    isRequired: true,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      size: 20.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty || _selectedDate == null) {
                        return 'Date is required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: DigifySelectField<HolidayType>(
                    label: 'Type',
                    hint: 'Select type',
                    value: _selectedType,
                    items: [HolidayType.fixed, HolidayType.islamic, HolidayType.variable],
                    itemLabelBuilder: (type) => PublicHolidaysConfig.getHolidayTypeDisplayName(type),
                    onChanged: (type) {
                      setState(() {
                        _selectedType = type;
                      });
                    },
                    isRequired: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Holiday type is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            DigifyTextField(
              controller: _descriptionEnController,
              labelText: 'Description (English)',
              hintText: 'Enter holiday description in English',
              isRequired: true,
              maxLines: 3,
              minLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description in English is required';
                }
                return null;
              },
            ),
            SizedBox(height: 24.h),
            Directionality(
              textDirection: ui.TextDirection.rtl,
              child: DigifyTextField(
                controller: _descriptionArController,
                labelText: 'Description (Arabic)',
                hintText: 'أدخل وصف العطلة بالعربية',
                isRequired: true,
                maxLines: 3,
                minLines: 3,
                inputFormatters: [AppInputFormatters.nameAr],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description in Arabic is required';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: DigifySelectField<String>(
                    label: 'Applies To',
                    hint: 'Select applies to',
                    value: _selectedAppliesTo,
                    items: PublicHolidaysConfig.availableAppliesTo,
                    itemLabelBuilder: (item) => item,
                    onChanged: (value) {
                      setState(() {
                        _selectedAppliesTo = value;
                      });
                    },
                    isRequired: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Applies to is required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: DigifyTextField(
                    controller: _yearController,
                    labelText: 'Year',
                    hintText: '2025',
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Year is required';
                      }
                      final year = int.tryParse(value.trim());
                      if (year == null || year < 1900 || year > 2100) {
                        return 'Please enter a valid year';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Checkbox(value: _isPaidHoliday, onChanged: null, activeColor: AppColors.primary),
                SizedBox(width: 8.w),
                Text(
                  'Paid Holiday',
                  style: TextStyle(
                    fontSize: 13.8.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                SizedBox(width: 24.w),
                // Commented out for now as per requirements
                // Checkbox(
                //   value: _isRecurringAnnually,
                //   onChanged: (value) {
                //     setState(() {
                //       _isRecurringAnnually = value ?? false;
                //     });
                //   },
                //   activeColor: AppColors.primary,
                // ),
                // SizedBox(width: 8.w),
                // Text(
                //   'Recurring Annually',
                //   style: TextStyle(
                //     fontSize: 13.8.sp,
                //     fontWeight: FontWeight.w400,
                //     color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          label: 'Cancel',
          backgroundColor: AppColors.textSecondary,
          foregroundColor: AppColors.buttonTextLight,
          height: 42.h,
          width: 100.w,
          borderRadius: BorderRadius.circular(10.r),
          fontSize: 15.1.sp,
        ),
        SizedBox(width: 12.w),
        AppButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          label: 'Add Holiday',
          icon: Icons.add,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.buttonTextLight,
          height: 40.h,
          width: 163.w,
          borderRadius: BorderRadius.circular(10.r),
          fontSize: 15.1.sp,
          isLoading: _isSubmitting,
        ),
      ],
    );
  }
}
