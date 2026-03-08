import 'package:digify_hr_system/features/employee_management/domain/models/empl_lookup_value.dart';

abstract class EntLookupRepository {
  Future<List<EmplLookupValue>> getLookupValues(int enterpriseId, String lookupTypeCode);
}
