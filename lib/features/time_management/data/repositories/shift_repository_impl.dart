import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/time_management/data/datasources/shift_remote_datasource.dart';
import 'package:digify_hr_system/features/time_management/domain/models/pagination_info.dart';
import 'package:digify_hr_system/features/time_management/domain/models/shift.dart';
import 'package:digify_hr_system/features/time_management/domain/repositories/shift_repository.dart';

/// Repository implementation for shift operations
class ShiftRepositoryImpl implements ShiftRepository {
  final ShiftRemoteDataSource remoteDataSource;
  final int tenantId;

  const ShiftRepositoryImpl({required this.remoteDataSource, required this.tenantId});

  @override
  Future<PaginatedShifts> getShifts({String? search, bool? isActive, int page = 1, int pageSize = 10}) async {
    try {
      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }

      if (pageSize < 1 || pageSize > 100) {
        throw ValidationException('pageSize must be between 1 and 100');
      }

      final dto = await remoteDataSource.getShifts(
        tenantId: tenantId,
        search: search,
        isActive: isActive,
        page: page,
        pageSize: pageSize,
      );

      final shifts = dto.data.isEmpty
          ? <ShiftOverview>[]
          : dto.data
                .map((shiftDto) {
                  try {
                    return shiftDto.toDomain();
                  } catch (e) {
                    return null;
                  }
                })
                .whereType<ShiftOverview>()
                .toList();

      final paginationPage = dto.meta.pagination.page;
      final paginationPageSize = dto.meta.pagination.pageSize;
      final paginationTotal = dto.meta.pagination.total;
      final paginationTotalPages = dto.meta.pagination.totalPages;

      final validPage = paginationPage < 1 ? 1 : paginationPage;
      final validPageSize = paginationPageSize < 1 ? pageSize : paginationPageSize;
      final validTotal = paginationTotal < 0 ? 0 : paginationTotal;
      final validTotalPages = paginationTotalPages < 0 ? 0 : paginationTotalPages;

      final pagination = PaginationInfo(
        currentPage: validPage,
        totalPages: validTotalPages,
        totalItems: validTotal,
        pageSize: validPageSize,
        hasNext: dto.meta.pagination.hasNext && validPage < validTotalPages,
        hasPrevious: dto.meta.pagination.hasPrevious && validPage > 1,
      );

      return PaginatedShifts(shifts: shifts, pagination: pagination);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get shifts: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<ShiftOverview> createShift({required Map<String, dynamic> shiftData}) async {
    try {
      return await remoteDataSource.createShift(tenantId: tenantId, shiftData: shiftData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create shift: ${e.toString()}', originalError: e);
    }
  }
}
