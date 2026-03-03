import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/domain/models/overtime/overtime_record.dart';
import 'package:digify_hr_system/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_provider.dart';
import 'package:digify_hr_system/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OvertimeActions {
  static Future<void> approveOvertimeRequest(BuildContext context, WidgetRef ref, OvertimeRecord record) async {
    final guid = record.otRequestGuid;
    if (guid == null || guid.isEmpty) return;

    final localizations = AppLocalizations.of(context)!;

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: localizations.approveOvertimeConfirmTitle,
      message: localizations.approveOvertimeConfirmMessage,
      confirmLabel: localizations.approve,
      cancelLabel: localizations.close,
      type: ConfirmationType.success,
      icon: Icons.check_circle_outline_rounded,
    );

    if (confirmed != true) return;

    final notifier = ref.read(overtimeManagementProvider.notifier);
    final error = await notifier.approveOvertimeRequest(guid);

    if (!context.mounted) return;

    if (error == null) {
      ToastService.success(context, 'Overtime request approved', title: 'Success');
    } else {
      ToastService.error(context, error.replaceFirst('Exception: ', ''), title: 'Error');
    }
  }

  static Future<void> rejectOvertimeRequest(BuildContext context, WidgetRef ref, OvertimeRecord record) async {
    final guid = record.otRequestGuid;
    if (guid == null || guid.isEmpty) return;

    final localizations = AppLocalizations.of(context)!;

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: localizations.rejectOvertimeConfirmTitle,
      message: localizations.rejectOvertimeConfirmMessage,
      confirmLabel: localizations.reject,
      cancelLabel: localizations.close,
      type: ConfirmationType.danger,
      icon: Icons.cancel_outlined,
    );

    if (confirmed != true) return;

    final notifier = ref.read(overtimeManagementProvider.notifier);
    final error = await notifier.rejectOvertimeRequest(guid);

    if (!context.mounted) return;

    if (error == null) {
      ToastService.success(context, 'Overtime request rejected', title: 'Success');
    } else {
      ToastService.error(context, error.replaceFirst('Exception: ', ''), title: 'Error');
    }
  }

  static Future<void> cancelDraftOvertimeRequest(BuildContext context, WidgetRef ref, OvertimeRecord record) async {
    final guid = record.otRequestGuid;
    if (guid == null || guid.isEmpty) return;

    final localizations = AppLocalizations.of(context)!;

    final confirmed = await AppConfirmationDialog.show(
      context,
      title: localizations.cancelOvertimeDraftConfirmTitle,
      message: localizations.cancelOvertimeDraftConfirmMessage,
      confirmLabel: localizations.delete,
      cancelLabel: localizations.close,
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );

    if (confirmed != true) return;

    final notifier = ref.read(overtimeManagementProvider.notifier);
    final error = await notifier.cancelOvertimeRequest(guid);

    if (!context.mounted) return;

    if (error == null) {
      ToastService.success(context, localizations.overtimeDraftCancelled, title: 'Success');
    } else {
      ToastService.error(context, error.replaceFirst('Exception: ', ''), title: 'Error');
    }
  }
}
