import 'package:digify_hr_system/features/employee_management/domain/models/employee_list_item.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';

class ManageEmployeesListState {
  final List<EmployeeListItem> items;
  final PaginationInfo? pagination;
  final bool isLoading;
  final Object? error;
  final int? lastEnterpriseId;
  final int currentPage;

  const ManageEmployeesListState({
    this.items = const [],
    this.pagination,
    this.isLoading = false,
    this.error,
    this.lastEnterpriseId,
    this.currentPage = 1,
  });

  ManageEmployeesListState copyWith({
    List<EmployeeListItem>? items,
    PaginationInfo? pagination,
    bool? isLoading,
    Object? error,
    int? lastEnterpriseId,
    int? currentPage,
  }) {
    return ManageEmployeesListState(
      items: items ?? this.items,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      lastEnterpriseId: lastEnterpriseId ?? this.lastEnterpriseId,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
