import 'package:digify_hr_system/core/constants/app_colors.dart';
import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/core/theme/theme_extensions.dart';
import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/enterprise_structure_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Dialog footer widget with cancel and save buttons
class DialogFooter extends ConsumerWidget {
  final EnterpriseStructureDialogMode mode;
  final EditEnterpriseStructureState? editState;
  final int? structureId;
  final AutoDisposeStateNotifierProvider<
      StructureListNotifier,
      StructureListState> provider;
  final AutoDisposeStateNotifierProvider<
      SaveEnterpriseStructureNotifier,
      SaveEnterpriseStructureState> saveEnterpriseStructureProvider;

  const DialogFooter({
    super.key,
    required this.mode,
    this.editState,
    this.structureId,
    required this.provider,
    required this.saveEnterpriseStructureProvider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only show footer for edit/create modes
    if (mode == EnterpriseStructureDialogMode.view) {
      return const SizedBox.shrink();
    }

    final saveState = ref.watch(saveEnterpriseStructureProvider);
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: EdgeInsetsDirectional.all(16.w),
        tablet: EdgeInsetsDirectional.all(20.w),
        web: EdgeInsetsDirectional.all(24.w),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Cancel button
          TextButton(
            onPressed: saveState.isSaving
                ? null
                : () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.w : 24.w,
                vertical: isMobile ? 12.h : 14.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
                side: BorderSide(
                  color: isDark
                      ? AppColors.inputBorderDark
                      : AppColors.inputBorder,
                ),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: isMobile ? 14.sp : 15.sp,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: isMobile ? 12.w : 16.w),
          // Save button
          ElevatedButton(
            onPressed: saveState.isSaving
                ? null
                : () async {
                    final currentEditState = editState;
                    if (currentEditState == null) return;

                    // Validate
                    if (currentEditState.selectedEnterpriseId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select an enterprise'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (currentEditState.structureName.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Structure name is required'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (currentEditState.levels.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('At least one level is required'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Save or Update
                    // PUT for edit mode (when structureId is provided), POST for create mode
                    final saveNotifier = ref.read(
                      saveEnterpriseStructureProvider.notifier,
                    );

                    try {
                      final success = await saveNotifier.saveStructure(
                        structureName: currentEditState.structureName.trim(),
                        description: currentEditState.description.trim(),
                        levels: currentEditState.levels,
                        // Will be empty list for PUT (edit mode)
                        enterpriseId: currentEditState.selectedEnterpriseId,
                        isActive: currentEditState.isActive,
                        structureId: structureId, // For PUT (update) operations
                      );

                      // Check result
                      if (!context.mounted) return;

                      if (success) {
                        // Refresh the list after successful save
                        ref.read(provider.notifier).refresh();

                        Navigator.of(
                          context,
                        ).pop(true); // Return true to indicate success
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Structure saved successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } on AppException catch (e) {
                      // Handle error - use exception message directly
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.message,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 4),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            textColor: Colors.white,
                            onPressed: () {
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                    } catch (e) {
                      // Handle unexpected errors
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to save structure: ${e.toString()}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 4),
                          action: SnackBarAction(
                            label: 'Dismiss',
                            textColor: Colors.white,
                            onPressed: () {
                              ScaffoldMessenger.of(
                                context,
                              ).hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.w : 24.w,
                vertical: isMobile ? 12.h : 14.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: saveState.isSaving
                ? SizedBox(
                    width: isMobile ? 16.w : 20.w,
                    height: isMobile ? 16.h : 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      fontSize: isMobile ? 14.sp : 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

