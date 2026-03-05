import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_enterprises_usecase.dart';

class AppInitializationService {
  final GetEnterprisesUseCase getEnterprisesUseCase;
  final void Function(int?)? onActiveEnterpriseReady;
  final void Function()? initializeLocation;

  List<Enterprise>? _enterprises;
  int? _activeEnterpriseId;

  AppInitializationService({
    required this.getEnterprisesUseCase,
    this.onActiveEnterpriseReady,
    this.initializeLocation,
  });

  Future<void> initializeAfterAuth({void Function()? onEnterprisesLoaded}) async {
    initializeLocation?.call();
    await _loadEnterprises();
    _setEnterpriseIdFromEnterprises();
    onEnterprisesLoaded?.call();
  }

  void _setEnterpriseIdFromEnterprises() {
    final list = _enterprises;
    if (list != null && list.isNotEmpty) {
      _activeEnterpriseId = list.first.id;
      onActiveEnterpriseReady?.call(_activeEnterpriseId);
    }
  }

  Future<void> _loadEnterprises() async {
    try {
      _enterprises = await getEnterprisesUseCase();
    } catch (e) {
      _enterprises = [];
    }
  }

  List<Enterprise>? get enterprises => _enterprises;

  int? get activeEnterpriseId => _activeEnterpriseId;

  Future<void> refreshEnterprises() async {
    await _loadEnterprises();
  }

  void clearCache() {
    _enterprises = null;
    _activeEnterpriseId = null;
  }
}
