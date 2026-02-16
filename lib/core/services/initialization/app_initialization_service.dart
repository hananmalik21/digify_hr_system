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
  final void Function(int enterpriseId)? preloadOrgStructureForEnterprise;

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
    this.preloadOrgStructureForEnterprise,
  });

  Future<void> initializeAfterAuth({void Function()? onEnterprisesLoaded}) async {
    await _loadEnterprises();
    _setEnterpriseIdFromEnterprises();
    onEnterprisesLoaded?.call();
    await _loadActiveLevels();
    final enterpriseId = _activeEnterpriseId;
    if (enterpriseId == null) return;
    preloadOrgStructureForEnterprise?.call(enterpriseId);
    await _loadAbsLookups();
    await _loadAbsLookupValues();
  }

  void _setEnterpriseIdFromEnterprises() {
    final list = _enterprises;
    if (list != null && list.isNotEmpty) {
      _activeEnterpriseId = list.first.id;
      onActiveEnterpriseReady?.call(_activeEnterpriseId);
    }
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
      onActiveEnterpriseReady?.call(_activeEnterpriseId);
      final activeLevels = responseDto.levels
          .where((dto) => dto.isActive.toUpperCase() == 'Y')
          .map((dto) => dto.toDomain())
          .toList();
      activeLevels.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      _activeLevels = activeLevels;
    } catch (e) {
      _activeLevels = [];
      _activeEnterpriseId = null;
      onActiveEnterpriseReady?.call(null);
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
