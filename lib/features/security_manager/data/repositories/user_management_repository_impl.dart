import '../../domain/models/system_user.dart';
import '../../domain/repositories/user_management_repository.dart';

class UserManagementRepositoryImpl implements UserManagementRepository {
  @override
  Future<List<SystemUser>> getUsers({
    String? searchQuery,
    SystemUserStatus? status,
    int? enterpriseId,
  }) async {
    // Mock data moved from UI
    final List<SystemUser> mockUsers = [
      SystemUser(
        id: 1,
        name: 'Ahmed Al-Mutairi',
        email: 'ahmed.almutairi@digifyhr.com',
        employeeNumber: 'EMP001',
        department: 'Human Resources',
        designation: 'HR Specialist',
        roles: ['ROLE_HR_SPECIALIST', 'DUTY_HR_OPERATIONS'],
        status: SystemUserStatus.active,
        is2FAEnabled: true,
      ),
      SystemUser(
        id: 2,
        name: 'John Smith',
        email: 'john.smith@digifyhr.com',
        employeeNumber: 'EMP002',
        department: 'Executive',
        designation: 'Chief Executive Officer',
        roles: ['ROLE_CEO', 'JOB_EXECUTIVE_CEO'],
        status: SystemUserStatus.active,
        is2FAEnabled: true,
      ),
      SystemUser(
        id: 3,
        name: 'Sarah Johnson',
        email: 'sarah.johnson@digifyhr.com',
        employeeNumber: 'EMP003',
        department: 'Human Resources',
        designation: 'HR Director',
        roles: ['ROLE_HR_DIRECTOR', 'JOB_HR_DIRECTOR', 'ROLE_HR_MANAGER'],
        status: SystemUserStatus.active,
        is2FAEnabled: true,
      ),
      SystemUser(
        id: 4,
        name: 'Michael Chen',
        email: 'michael.chen@digifyhr.com',
        employeeNumber: 'EMP004',
        department: 'Finance',
        designation: 'Payroll Manager',
        roles: ['ROLE_PAYROLL_MANAGER', 'DUTY_PAYROLL_PROCESSING'],
        status: SystemUserStatus.active,
        is2FAEnabled: false,
      ),
      SystemUser(
        id: 5,
        name: 'Fatima Al-Hassan',
        email: 'fatima.alhassan@digifyhr.com',
        employeeNumber: 'EMP005',
        department: 'Human Resources',
        designation: 'Recruitment Specialist',
        roles: ['ROLE_RECRUITER', 'FUNC_RECRUITMENT_ACCESS'],
        status: SystemUserStatus.active,
        is2FAEnabled: true,
      ),
      SystemUser(
        id: 6,
        name: 'Omar Al-Rashid',
        email: 'omar.alrashid@digifyhr.com',
        employeeNumber: 'EMP006',
        department: 'IT',
        designation: 'System Administrator',
        roles: ['ROLE_SYSTEM_ADMIN', 'FUNC_ALL_MODULES'],
        status: SystemUserStatus.locked,
        is2FAEnabled: true,
      ),
    ];

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return mockUsers.where((user) {
      if (status != null && user.status != status) return false;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        return user.name.toLowerCase().contains(query) ||
            user.email.toLowerCase().contains(query) ||
            user.employeeNumber.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }
}
