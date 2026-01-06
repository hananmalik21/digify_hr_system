import 'package:digify_hr_system/features/time_management/data/datasources/public_holiday_remote_datasource.dart';
import 'package:digify_hr_system/features/time_management/domain/models/public_holiday.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/public_holiday_repository.dart';

/// Repository implementation for public holiday operations
class PublicHolidayRepositoryImpl implements PublicHolidayRepository {
  final PublicHolidayRemoteDataSource remoteDataSource;

  const PublicHolidayRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedHolidays> getHolidays({
    int page = 1,
    int pageSize = 10,
    String? search,
    String? year,
    String? type,
  }) async {
    final response = await remoteDataSource.getHolidays(
      page: page,
      pageSize: pageSize,
      search: search,
      year: year,
      type: type,
    );

    return response.toDomain();
  }
}
