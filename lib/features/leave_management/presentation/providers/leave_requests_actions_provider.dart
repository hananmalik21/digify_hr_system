import 'package:digify_hr_system/core/localization/l10n/app_localizations.dart';
import 'package:digify_hr_system/core/services/toast_service.dart';
import 'package:digify_hr_system/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:digify_hr_system/features/time_management/domain/models/time_off_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaveRequestsApproveLoadingProvider = StateProvider<Set<String>>((ref) => <String>{});
final leaveRequestsRejectLoadingProvider = StateProvider<Set<String>>((ref) => <String>{});

class LeaveRequestsActions {
  static Future<void> approveLeaveRequest(
    BuildContext context,
    WidgetRef ref,
    TimeOffRequest request,
    AppLocalizations localizations,
  ) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: localizations.approvePendingRequests,
      message: 'Are you sure you want to approve this leave request?',
      confirmLabel: localizations.approve,
      cancelLabel: localizations.close,
      type: ConfirmationType.success,
      icon: Icons.check_circle_outline_rounded,
    );

    if (confirmed != true) return;

    try {
      final notifier = ref.read(leaveRequestsNotifierProvider.notifier);
      await notifier.approveLeaveRequest(request.guid);

      if (context.mounted) {
        ToastService.success(context, 'Leave request approved successfully');
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  static Future<void> rejectLeaveRequest(
    BuildContext context,
    WidgetRef ref,
    TimeOffRequest request,
    AppLocalizations localizations,
  ) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: localizations.rejected,
      message: 'Are you sure you want to reject this leave request?',
      confirmLabel: localizations.reject,
      cancelLabel: localizations.close,
      type: ConfirmationType.danger,
      icon: Icons.cancel_outlined,
    );

    if (confirmed != true) return;

    try {
      final notifier = ref.read(leaveRequestsNotifierProvider.notifier);
      await notifier.rejectLeaveRequest(request.guid);

      if (context.mounted) {
        ToastService.success(context, 'Leave request rejected successfully');
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }
}
