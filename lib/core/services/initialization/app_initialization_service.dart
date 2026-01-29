import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_enterprises_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_active_levels_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/data/datasources/org_structure_level_remote_data_source.dart';

class AppInitializationService {
  final GetEnterprisesUseCase getEnterprisesUseCase;
  final GetActiveLevelsUseCase getActiveLevelsUseCase;
  final OrgStructureLevelRemoteDataSource orgStructureLevelRemoteDataSource;
  final Future<void> Function(int tenantId)? loadAbsLookups;
  final Future<void> Function(int tenantId)? loadAbsLookupValues;
  final void Function(int?)? onActiveEnterpriseReady;

  List<Enterprise>? _enterprises;
  List<ActiveStructureLevel>? _activeLevels;
  int? _activeEnterpriseId;

  AppInitializationService({
    required this.getEnterprisesUseCase,
    required this.getActiveLevelsUseCase,
    required this.orgStructureLevelRemoteDataSource,
    this.loadAbsLookups,
    this.loadAbsLookupValues,
    this.onActiveEnterpriseReady,
  });

  Future<void> initializeApp() async {}

  Future<void> initializeAfterAuth() async {
    await _loadEnterprises();
    await _loadActiveLevels();
    onActiveEnterpriseReady?.call(_activeEnterpriseId);
    _loadAbsLookups();
    _loadAbsLookupValues();
  }

  Future<void> _loadAbsLookups() async {
    final tenantId = _activeEnterpriseId;
    if (tenantId == null || loadAbsLookups == null) return;
    try {
      await loadAbsLookups!(tenantId);
    } catch (_) {}
  }

  Future<void> _loadAbsLookupValues() async {
    final tenantId = _activeEnterpriseId;
    if (tenantId == null || loadAbsLookupValues == null) return;
    try {
      await loadAbsLookupValues!(tenantId);
    } catch (_) {}
  }

  Future<void> _loadEnterprises() async {
    try {
      _enterprises = await getEnterprisesUseCase();
    } catch (e) {
      _enterprises = [];
    }
  }

  Future<void> _loadActiveLevels() async {
    try {
      final responseDto = await orgStructureLevelRemoteDataSource.getActiveLevels();
      _activeEnterpriseId = responseDto.enterpriseId;
      final activeLevels = responseDto.levels
          .where((dto) => dto.isActive.toUpperCase() == 'Y')
          .map((dto) => dto.toDomain())
          .toList();
      activeLevels.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      _activeLevels = activeLevels;
    } catch (e) {
      _activeLevels = [];
      _activeEnterpriseId = null;
    }
  }

  List<Enterprise>? get enterprises => _enterprises;

  List<ActiveStructureLevel>? get activeLevels => _activeLevels;

  int? get activeEnterpriseId => _activeEnterpriseId;

  Future<void> refreshEnterprises() async {
    await _loadEnterprises();
  }

  Future<void> refreshActiveLevels() async {
    await _loadActiveLevels();
  }

  void clearCache() {
    _enterprises = null;
    _activeLevels = null;
    _activeEnterpriseId = null;
  }
}
