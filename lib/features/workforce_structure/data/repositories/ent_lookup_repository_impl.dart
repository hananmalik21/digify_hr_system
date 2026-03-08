import 'package:digify_hr_system/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:digify_hr_system/features/workforce_structure/data/datasources/ent_lookup_remote_data_source.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/ent_lookup_repository.dart';

class EntLookupRepositoryImpl implements EntLookupRepository {
  EntLookupRepositoryImpl({required this.remoteDataSource});
  final EntLookupRemoteDataSource remoteDataSource;

  @override
  Future<List<EmplLookupValue>> getLookupValues(int enterpriseId, String lookupTypeCode) async {
    final response = await remoteDataSource.getLookupValues(enterpriseId, lookupTypeCode);
    return response.toDomain();
  }
}
