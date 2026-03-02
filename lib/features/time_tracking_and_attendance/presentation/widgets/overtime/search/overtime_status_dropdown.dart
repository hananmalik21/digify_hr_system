import 'package:digify_hr_system/core/enums/overtime_status.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OvertimeStatusDropdown extends ConsumerWidget {
  final bool isDark;
  final String label;
  final double? width;

  const OvertimeStatusDropdown({super.key, required this.isDark, required this.label, this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStatus = ref.watch(overtimeManagementProvider.select((s) => s.selectedStatus));

    return SizedBox(
      width: width ?? 144.w,
      child: DigifySelectField<OvertimeStatus?>(
        hint: label,
        value: currentStatus,
        items: [null, ...OvertimeStatus.values],
        itemLabelBuilder: (status) => status?.label ?? label,
        onChanged: (newValue) {
          ref.read(overtimeManagementProvider.notifier).selectStatus(newValue);
        },
      ),
    );
  }
}
