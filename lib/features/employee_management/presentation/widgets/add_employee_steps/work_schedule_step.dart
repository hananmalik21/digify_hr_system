import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/widgets/common/section_header_card.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/add_employee_work_schedule_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:digify_hr_system/features/employee_management/presentation/widgets/add_employee_steps/work_schedule_assignment_module.dart';
import 'package:digify_hr_system/features/time_management/domain/models/work_schedule.dart';
import 'package:digify_hr_system/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEmployeeWorkScheduleStep extends ConsumerStatefulWidget {
  const AddEmployeeWorkScheduleStep({super.key});

  @override
  ConsumerState<AddEmployeeWorkScheduleStep> createState() => _AddEmployeeWorkScheduleStepState();
}

class _AddEmployeeWorkScheduleStepState extends ConsumerState<AddEmployeeWorkScheduleStep> {
  bool _prefillLoadTriggered = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
    final workScheduleState = ref.watch(addEmployeeWorkScheduleProvider);
    final workScheduleNotifier = ref.read(addEmployeeWorkScheduleProvider.notifier);

    if (enterpriseId != null &&
        workScheduleState.prefillWorkScheduleId != null &&
        workScheduleState.selectedWorkSchedule == null &&
        !_prefillLoadTriggered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _prefillLoadTriggered) return;
        setState(() => _prefillLoadTriggered = true);
        ref.read(workSchedulesNotifierProvider(enterpriseId).notifier).loadFirstPage();
      });
    }
    if (enterpriseId != null) {
      ref.listen<WorkScheduleState>(workSchedulesNotifierProvider(enterpriseId), (prev, next) {
        final state = ref.read(addEmployeeWorkScheduleProvider);
        if (state.prefillWorkScheduleId == null || state.selectedWorkSchedule != null) return;
        final items = next.items;
        if (items.isEmpty) return;
        final match = items.where((s) => s.workScheduleId == state.prefillWorkScheduleId).firstOrNull;
        if (match != null) {
          ref.read(addEmployeeWorkScheduleProvider.notifier).setSelectedWorkScheduleFromPrefill(match);
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        SectionHeaderCard(
          iconAssetPath: Assets.icons.timeManagementMainIcon.path,
          title: localizations.timeManagementWorkSchedule,
          subtitle: localizations.timeManagementWorkScheduleSubtitle,
        ),
        WorkScheduleAssignmentModule(
          enterpriseId: enterpriseId,
          selectedWorkSchedule: workScheduleState.selectedWorkSchedule,
          onWorkScheduleChanged: workScheduleNotifier.setSelectedWorkSchedule,
        ),
        WorkScheduleStartEndModule(
          wsStart: workScheduleState.wsStart,
          wsEnd: workScheduleState.wsEnd,
          onWsStartChanged: workScheduleNotifier.setWsStart,
          onWsEndChanged: workScheduleNotifier.setWsEnd,
        ),
      ],
    );
  }
}

extension _WorkScheduleFirstOrNull on Iterable<WorkSchedule> {
  WorkSchedule? get firstOrNull {
    for (final e in this) {
      return e;
    }
    return null;
  }
}
