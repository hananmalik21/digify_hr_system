import 'package:digify_hr_system/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:digify_hr_system/features/workforce_structure/data/datasources/ent_lookup_remote_data_source.dart';
import 'package:digify_hr_system/features/workforce_structure/domain/repositories/ent_lookup_repository.dart';

class EntLookupRepositoryImpl implements EntLookupRepository {
  EntLookupRepositoryImpl({required this.remoteDataSource});
  final EntLookupRemoteDataSource remoteDataSource;

  @override
  Future<List<EmplLookupValue>> getLookupValues(int enterpriseId, String lookupTypeCode) async {
    const pageSize = 100;
    final response = await remoteDataSource.getLookupValues(enterpriseId, lookupTypeCode, page: 1, pageSize: pageSize);
    List<EmplLookupValue> all = response.toDomain();
    for (var page = 2; page <= response.meta.totalPages; page++) {
      final next = await remoteDataSource.getLookupValues(enterpriseId, lookupTypeCode, page: page, pageSize: pageSize);
      all = [...all, ...next.toDomain()];
    }
    return all;
  }
}
