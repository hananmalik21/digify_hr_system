import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:digify_hr_system/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:digify_hr_system/features/leave_management/presentation/providers/abs_lookups_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final employeeAbsLookupValuesAsyncProvider = Provider<AsyncValue<Map<String, List<AbsLookupValue>>>>(
  (ref) => ref.watch(absLookupValuesByCodeProvider),
);

final employeeAbsLookupValuesForCodeProvider = Provider.family<List<AbsLookupValue>, AbsLookupCode>(
  (ref, lookupCode) => ref.watch(absLookupValuesForCodeProvider(lookupCode)),
);
