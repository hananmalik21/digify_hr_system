import '../models/system_user.dart';
import '../repositories/user_management_repository.dart';

class GetUsersUseCase {
  final UserManagementRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<SystemUser>> call({
    String? searchQuery,
    SystemUserStatus? status,
    int? enterpriseId,
  }) async {
    return await repository.getUsers(
      searchQuery: searchQuery,
      status: status,
      enterpriseId: enterpriseId,
    );
  }
}
