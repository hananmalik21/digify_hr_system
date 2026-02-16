import 'package:digify_hr_system/features/leave_management/data/datasources/leave_details_data_source.dart';
import 'package:digify_hr_system/features/leave_management/data/dto/leave_details_dto.dart';
import 'package:digify_hr_system/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_transaction_table_config.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaveDetailsDataSourceProvider = Provider<LeaveDetailsDataSource>((ref) {
  return LeaveDetailsDataSourceImpl();
});

final leaveDetailsDataProvider = FutureProvider.family<LeaveDetailsData, String>((ref, employeeId) {
  return ref.read(leaveDetailsDataSourceProvider).getLeaveDetails(employeeId);
});

final leaveDetailsTransactionsPaginationProvider = StateProvider.family<(int page, int pageSize), String>((
  ref,
  employeeId,
) {
  return (1, LeaveDetailsTransactionTableConfig.defaultPageSize);
});

class LeaveDetailsTransactionPageState {
  const LeaveDetailsTransactionPageState({
    required this.transactions,
    this.paginationInfo,
    required this.currentPage,
    required this.pageSize,
    this.moveNext,
    this.movePrevious,
  });

  final List<Map<String, dynamic>> transactions;
  final PaginationInfo? paginationInfo;
  final int currentPage;
  final int pageSize;
  final void Function()? moveNext;
  final void Function()? movePrevious;

  static LeaveDetailsTransactionPageState empty() {
    return LeaveDetailsTransactionPageState(
      transactions: const [],
      currentPage: 1,
      pageSize: LeaveDetailsTransactionTableConfig.defaultPageSize,
    );
  }
}

final leaveDetailsTransactionPageProvider = Provider.family<LeaveDetailsTransactionPageState, String>((
  ref,
  employeeId,
) {
  final asyncData = ref.watch(leaveDetailsDataProvider(employeeId));
  final pagination = ref.watch(leaveDetailsTransactionsPaginationProvider(employeeId));
  final paginationNotifier = ref.read(leaveDetailsTransactionsPaginationProvider(employeeId).notifier);

  return asyncData.when(
    loading: LeaveDetailsTransactionPageState.empty,
    error: (_, __) => LeaveDetailsTransactionPageState.empty(),
    data: (data) {
      final page = pagination.$1;
      final pageSize = pagination.$2;
      final total = data.transactions.length;
      final totalPages = total <= 0 ? 1 : (total / pageSize).ceil();
      final start = (page - 1) * pageSize;
      final list = data.transactions;
      final pageTransactions = start >= total
          ? <Map<String, dynamic>>[]
          : list.sublist(start, (start + pageSize).clamp(0, total));
      final paginationInfo = total > 0
          ? PaginationInfo(
              currentPage: page,
              totalPages: totalPages,
              totalItems: total,
              pageSize: pageSize,
              hasNext: page < totalPages,
              hasPrevious: page > 1,
            )
          : null;

      return LeaveDetailsTransactionPageState(
        transactions: pageTransactions,
        paginationInfo: paginationInfo,
        currentPage: page,
        pageSize: pageSize,
        moveNext: paginationInfo != null && paginationInfo.hasNext
            ? () => paginationNotifier.state = (page + 1, pageSize)
            : null,
        movePrevious: paginationInfo != null && paginationInfo.hasPrevious
            ? () => paginationNotifier.state = (page - 1, pageSize)
            : null,
      );
    },
  );
});
