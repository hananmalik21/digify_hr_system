import '../models/system_user.dart';

abstract class UserManagementRepository {
  Future<List<SystemUser>> getUsers({
    String? searchQuery,
    SystemUserStatus? status,
    int? enterpriseId,
  });
}
