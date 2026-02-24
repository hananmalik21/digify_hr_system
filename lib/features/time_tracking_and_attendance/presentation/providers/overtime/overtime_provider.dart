import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../generated/assets.dart';
import '../../../domain/domain/models/overtime/overtime.dart';

class OvertimeManagementNotifier extends StateNotifier<OvertimeManagement> {
  OvertimeManagementNotifier()
    : super(
        OvertimeManagement(
          selectedCategory: OvertimeCategory.all,
          categories: OvertimeCategory.values,
          stats: [
            OvertimeStat(
              title: 'Total Overtime',
              subTitle: '8 records',
              value: '25.0',
              icon: Assets.iconsTimeManagementIcon,
            ),
            OvertimeStat(
              title: 'Total Amount',
              subTitle: 'Overtime compensation',
              value: 'KKWD 1085.00',
              icon: Assets.leaveManagementDollar,
            ),
            OvertimeStat(
              title: 'Pending Approvals',
              subTitle: 'Awaiting manager review',
              value: '3',
              icon: Assets.iconsCheckIconGreen,
            ),
            OvertimeStat(
              title: 'Approved',
              subTitle: 'Ready for payroll',
              value: '4',
              icon: Assets.iconsCheckIconGreen,
            ),
          ],
        ),
      );

  void selectCategory(OvertimeCategory category) {
    state = state.copyWith(selectedCategory: category);
  }
}

final overtimeManagementProvider =
    StateNotifierProvider<OvertimeManagementNotifier, OvertimeManagement>((
      ref,
    ) {
      return OvertimeManagementNotifier();
    });
