import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/division.dart';

/// Repository interface for division operations
abstract class DivisionRepository {
  /// Gets list of all divisions
  ///
  /// Throws [AppException] if the operation fails
  Future<List<DivisionOverview>> getDivisions({
    String? search,
    int? page,
    int? pageSize,
  });

  /// Creates a new division
  ///
  /// Throws [AppException] if the operation fails
  Future<DivisionOverview> createDivision(Map<String, dynamic> divisionData);

  /// Updates an existing division
  ///
  /// Throws [AppException] if the operation fails
  Future<DivisionOverview> updateDivision(int divisionId, Map<String, dynamic> divisionData);

  /// Deletes a division
  ///
  /// [hard] - If true, permanently deletes the division. If false, soft deletes it.
  /// Throws [AppException] if the operation fails
  Future<void> deleteDivision(int divisionId, {bool hard = true});
}

