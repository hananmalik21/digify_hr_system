import 'package:digify_hr_system/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/abs_lookups_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final employeeAbsLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>((ref, lookupCode) {
  final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
  if (enterpriseId == null) return [];
  return ref.watch(absLookupValuesForEnterpriseAndCodeProvider((enterpriseId: enterpriseId, code: lookupCode)));
});
