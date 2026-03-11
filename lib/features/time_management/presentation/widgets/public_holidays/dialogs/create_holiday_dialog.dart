import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/enums/time_management_enums.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/input_formatters.dart';
import 'package:digify_hr_system/core/widgets/buttons/app_button.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_dialog.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_text_field.dart';
import 'package:digify_hr_system/features/time_management/data/config/public_holidays_config.dart';
import 'package:digify_hr_system/features/time_management/domain/models/public_holiday.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/public_holidays_provider.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:digify_hr_system/features/workforce_structure/presentation/providers/ent_lookup_providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateHolidayDialog {
  static Future<void> show(BuildContext context, {required int enterpriseId, PublicHoliday? holiday}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer(
        builder: (context, ref, _) => _CreateHolidayDialogContent(enterpriseId: enterpriseId, holiday: holiday),
      ),
    );
  }
}

class _CreateHolidayDialogContent extends ConsumerStatefulWidget {
  final int enterpriseId;
  final PublicHoliday? holiday;

  const _CreateHolidayDialogContent({required this.enterpriseId, required this.holiday});

  @override
  ConsumerState<_CreateHolidayDialogContent> createState() => _CreateHolidayDialogState();
}

class _CreateHolidayDialogState extends ConsumerState<_CreateHolidayDialogContent> {
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;
  late final TextEditingController _descriptionEnController;
  late final TextEditingController _descriptionArController;
  late final TextEditingController _yearController;
  String? _selectedTypeCode;
  String? _selectedAppliesTo;
  final bool _isPaidHoliday = true;
  bool _isSubmittingState = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final holiday = widget.holiday;
    _nameEnController = TextEditingController(text: holiday?.nameEn ?? '');
    _nameArController = TextEditingController(text: holiday?.nameAr ?? '');
    _descriptionEnController = TextEditingController(text: holiday?.descriptionEn ?? '');
    _descriptionArController = TextEditingController(text: holiday?.descriptionAr ?? '');
    _yearController = TextEditingController(text: holiday != null ? holiday.year.toString() : '');
    _selectedDate = holiday?.date;
    _selectedTypeCode = holiday?.type.apiValue;
    _selectedAppliesTo = holiday != null
        ? (PublicHolidaysConfig.getAppliesToDisplayName(holiday.appliesTo) ?? holiday.appliesTo)
        : PublicHolidaysConfig.availableAppliesTo.first;
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameArController.dispose();
    _descriptionEnController.dispose();
    _descriptionArController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmitInternal() async {
    final notifier = ref.read(publicHolidaysNotifierProvider(widget.enterpriseId).notifier);
    final selectedType = _selectedTypeCode != null ? HolidayType.fromString(_selectedTypeCode!) : null;
    final validationError = notifier.validateHolidayInputs(
      nameEn: _nameEnController.text,
      date: _selectedDate,
      type: selectedType,
      descriptionEn: _descriptionEnController.text,
      appliesToLabel: _selectedAppliesTo,
      yearText: _yearController.text,
    );

    if (validationError != null) {
      ToastService.error(context, validationError);
      return;
    }
    setState(() {
      _isSubmittingState = true;
    });

    final appliesToValue = _selectedAppliesTo!;

    if (widget.holiday != null) {
      await notifier.updateHoliday(
        holidayId: widget.holiday!.id,
        tenantId: widget.enterpriseId,
        nameEn: _nameEnController.text.trim(),
        nameAr: _nameArController.text.trim(),
        date: _selectedDate!,
        year: int.parse(_yearController.text.trim()),
        type: selectedType!,
        descriptionEn: _descriptionEnController.text.trim(),
        descriptionAr: _descriptionArController.text.trim(),
        appliesTo: appliesToValue,
        isPaid: _isPaidHoliday,
      );
    } else {
      await notifier.createHoliday(
        tenantId: widget.enterpriseId,
        nameEn: _nameEnController.text.trim(),
        nameAr: _nameArController.text.trim(),
        date: _selectedDate!,
        year: int.parse(_yearController.text.trim()),
        type: selectedType!,
        descriptionEn: _descriptionEnController.text.trim(),
        descriptionAr: _descriptionArController.text.trim(),
        appliesTo: appliesToValue,
        isPaid: _isPaidHoliday,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final notifier = ref.read(publicHolidaysNotifierProvider(widget.enterpriseId).notifier);

    ref.listen<PublicHolidaysState>(publicHolidaysNotifierProvider(widget.enterpriseId), (previous, next) {
      if (previous == null) return;

      if (next.createSuccessMessage != null && previous.createSuccessMessage != next.createSuccessMessage) {
        if (mounted) {
          Navigator.of(context).pop();
        }
        notifier.clearSideEffects();
      }

      if (next.createErrorMessage != null && previous.createErrorMessage != next.createErrorMessage) {
        if (mounted) {
          setState(() {
            _isSubmittingState = false;
          });
        }
        notifier.clearSideEffects();
      }
    });

    return AppDialog(
      title: widget.holiday != null ? 'Edit Holiday' : 'Add New Holiday',
      width: 768.w,
      onClose: () => context.pop(),
      actions: [
        AppButton(label: 'Cancel', type: AppButtonType.outline, onPressed: () => context.pop()),
        Gap(12.w),
        AppButton(
          label: widget.holiday != null ? 'Update' : 'Create',
          type: AppButtonType.primary,
          isLoading: _isSubmittingState,
          onPressed: _handleSubmitInternal,
        ),
      ],
      content: Column(
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
              Gap(16.w),
              Expanded(
                child: DigifyTextField(
                  controller: _nameArController,
                  labelText: 'Holiday Name (Arabic)',
                  hintText: 'Enter holiday name in Arabic (Optional)',
                  isRequired: false,
                  inputFormatters: [AppInputFormatters.nameAny],
                  validator: (value) {
                    return null;
                  },
                ),
              ),
            ],
          ),
          Gap(24.h),
          Row(
            children: [
              Expanded(
                child: DigifyDateField(
                  label: 'Date',
                  hintText: 'dd/mm/yyyy',
                  initialDate: _selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                      _yearController.text = date.year.toString();
                    });
                  },
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                ),
              ),
              Gap(16.w),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final lookupAsync = ref.watch(
                      entLookupValuesForTypeProvider((enterpriseId: widget.enterpriseId, typeCode: 'HOLIDAY_TYPE')),
                    );
                    final items = lookupAsync.valueOrNull ?? <EmplLookupValue>[];
                    final isLoading = lookupAsync.isLoading;
                    final hasItems = items.isNotEmpty;

                    EmplLookupValue? selectedLookup;
                    if (hasItems && _selectedTypeCode != null) {
                      selectedLookup = items.firstWhere(
                        (v) => v.lookupCode == _selectedTypeCode,
                        orElse: () => items.first,
                      );
                    }

                    return DigifySelectFieldWithLabel<EmplLookupValue>(
                      label: 'Type',
                      hint: isLoading
                          ? 'Loading types...'
                          : hasItems
                          ? 'Select type'
                          : 'No types available',
                      value: hasItems ? selectedLookup : null,
                      items: hasItems ? items : const [],
                      itemLabelBuilder: (v) => v.meaningEn,
                      onChanged: (!isLoading && hasItems)
                          ? (value) {
                              setState(() {
                                _selectedTypeCode = value?.lookupCode;
                              });
                            }
                          : null,
                      isRequired: true,
                    );
                  },
                ),
              ),
            ],
          ),
          Gap(24.h),
          DigifyTextArea(
            controller: _descriptionEnController,
            labelText: 'Description (English)',
            hintText: 'Enter holiday description in English',
            isRequired: true,
            maxLines: 3,
            minLines: 3,
          ),
          Gap(24.h),
          DigifyTextArea(
            controller: _descriptionArController,
            labelText: 'Description (Arabic)',
            hintText: 'Enter holiday description in Arabic (Optional)',
            isRequired: false,
            maxLines: 3,
            minLines: 3,
            inputFormatters: [AppInputFormatters.nameAny],
          ),
          Gap(24.h),
          Row(
            children: [
              Expanded(
                child: DigifySelectFieldWithLabel<String>(
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
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifyTextField(
                  controller: _yearController,
                  labelText: 'Year',
                  hintText: 'Select date first',
                  isRequired: true,
                  readOnly: true,
                ),
              ),
            ],
          ),
          Gap(24.h),
          Row(
            children: [
              Checkbox(value: _isPaidHoliday, onChanged: null, activeColor: AppColors.primary),
              Gap(8.w),
              Text(
                'Paid Holiday',
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: 13.8.sp,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              Gap(24.w),
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
    );
  }
}
