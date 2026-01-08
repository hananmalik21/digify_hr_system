import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_unit_tree.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_org_units_tree_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for get org units tree use case
final getOrgUnitsTreeUseCaseProvider = Provider<GetOrgUnitsTreeUseCase>((ref) {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return GetOrgUnitsTreeUseCase(repository: repository);
});

/// Provider for org units tree
final orgUnitsTreeProvider = FutureProvider.autoDispose<OrgUnitTree>((ref) async {
  final useCase = ref.watch(getOrgUnitsTreeUseCaseProvider);
  
  try {
    return await useCase();
  } on AppException catch (e) {
    throw Exception(e.message);
  } catch (e) {
    throw Exception('Failed to load org units tree: ${e.toString()}');
  }
});
