import 'package:digify_hr_system/features/employee_management/data/dto/employees_response_dto.dart';

/// Returns a mock [EmployeesResponseDto] for use when the remote API is unavailable.
EmployeesResponseDto getManageEmployeesMockResponse() {
  const mockData = [
    ManageEmployeeItemDto(
      employeeId: 1765637069447,
      employeeGuid: '1',
      firstNameEn: 'Khuram',
      middleNameEn: 'K P',
      lastNameEn: 'Shahzad',
      email: 'khuram@example.com',
      phoneNumber: '+965 12345678',
      status: 'probation',
    ),
    ManageEmployeeItemDto(
      employeeId: 1765637069448,
      employeeGuid: '2',
      firstNameEn: 'Sarah',
      lastNameEn: 'Ahmed',
      email: 'sarah@example.com',
      phoneNumber: '+965 87654321',
      status: 'active',
    ),
    ManageEmployeeItemDto(
      employeeId: 1765637069449,
      employeeGuid: '3',
      firstNameEn: 'Mohammed',
      lastNameEn: 'Hassan',
      email: 'mohammed@example.com',
      phoneNumber: '+965 11223344',
      status: 'active',
    ),
  ];

  const mockMeta = PaginationMetaDto(
    page: 1,
    pageSize: 10,
    total: 3,
    totalPages: 1,
    hasNext: false,
    hasPrevious: false,
  );

  return EmployeesResponseDto(success: true, meta: mockMeta, data: mockData);
}
