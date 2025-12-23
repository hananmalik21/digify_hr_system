import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise.dart';

/// Repository interface for enterprise operations
abstract class EnterpriseRepository {
  /// Gets list of all enterprises
  /// 
  /// Throws [AppException] if the operation fails
  Future<List<Enterprise>> getEnterprises();
}

