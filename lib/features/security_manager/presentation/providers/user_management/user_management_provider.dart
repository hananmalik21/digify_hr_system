import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_management/user_managment_status.dart';
import '../../../data/repositories/user_management_repository_impl.dart';
import '../../../domain/models/system_user.dart';
import '../../../domain/repositories/user_management_repository.dart';
import '../../../domain/usecases/get_users_use_case.dart';

class UserManagementState {
  final String searchQuery;
  final UserManagementStatus? statusFilter;
  final List<SystemUser> users;
  final bool isLoading;
  final bool clearError;
  final String? error;

  UserManagementState({
    this.searchQuery = '',
    this.statusFilter,
    this.users = const [],
    this.isLoading = false,
    this.clearError = false,
    this.error,
  });

  UserManagementState copyWith({
    String? searchQuery,
    UserManagementStatus? statusFilter,
    List<SystemUser>? users,
    bool? isLoading,
    bool? clearError,
    String? error,
  }) {
    return UserManagementState(
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      clearError: clearError ?? this.clearError,
      error: error ?? this.error,
    );
  }
}

class UserManagementNotifier extends StateNotifier<UserManagementState> {
  final GetUsersUseCase _getUsersUseCase;

  UserManagementNotifier(this._getUsersUseCase) : super(UserManagementState()) {
    getUsers();
  }

  Future<void> getUsers() async {
    state = state.copyWith(isLoading: true);
    try {
      final users = await _getUsersUseCase(
        searchQuery: state.searchQuery,
        // status: state.statusFilter, // Note: UserManagementStatus vs SystemUserStatus needs mapping or alignment
      );
      state = state.copyWith(users: users, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    getUsers();
  }

  void setStatusFilter(UserManagementStatus? status) {
    state = state.copyWith(statusFilter: status);
    getUsers();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void clearError() {
    state = state.copyWith(clearError: true, error: null);
  }
}

final userManagementRepositoryProvider = Provider<UserManagementRepository>((ref) {
  return UserManagementRepositoryImpl();
});

final getUsersUseCaseProvider = Provider<GetUsersUseCase>((ref) {
  return GetUsersUseCase(ref.watch(userManagementRepositoryProvider));
});

final userManagementProvider =
    StateNotifierProvider<UserManagementNotifier, UserManagementState>((ref) {
  return UserManagementNotifier(ref.watch(getUsersUseCaseProvider));
});
