import 'package:digify_hr_system/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final saveEnterpriseStructureDialogProvider =
    StateNotifierProvider.autoDispose<SaveEnterpriseStructureNotifier, SaveEnterpriseStructureState>((ref) {
      final saveUseCase = ref.watch(saveEnterpriseStructureUseCaseProvider);
      return SaveEnterpriseStructureNotifier(saveUseCase: saveUseCase);
    });

final editEnterpriseStructureDialogProvider = StateNotifierProvider.autoDispose
    .family<EditEnterpriseStructureNotifier, EditEnterpriseStructureState, EditDialogParams>(
      (ref, params) => EditEnterpriseStructureNotifier(
        structureName: params.structureName,
        description: params.description,
        initialLevels: params.initialLevels,
        selectedEnterpriseId: params.selectedEnterpriseId,
        isActive: params.isActive,
      ),
    );
