import 'package:digify_hr_system/features/employee_management/domain/models/empl_lookup_type.dart';
import 'package:digify_hr_system/features/employee_management/domain/models/empl_lookup_value.dart';

abstract class EmplLookupRepository {
  Future<List<EmplLookupType>> getLookupTypes(int enterpriseId);
  Future<List<EmplLookupValue>> getLookupValues(int enterpriseId, String lookupTypeCode);
}
