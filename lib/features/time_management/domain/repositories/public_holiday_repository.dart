import 'package:digify_hr_system/features/time_management/domain/models/public_holiday.dart';

/// Repository interface for public holiday operations
abstract class PublicHolidayRepository {
  Future<PaginatedHolidays> getHolidays({int page = 1, int pageSize = 10, String? search, String? year, String? type});
}
