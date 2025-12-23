import 'package:digify_hr_system/core/network/exceptions.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise_structure.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/save_enterprise_structure_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for save enterprise structure operation
class SaveEnterpriseStructureState {
  final bool isSaving;
  final String? errorMessage;
  final bool hasError;
  final bool isSuccess;

  const SaveEnterpriseStructureState({
    this.isSaving = false,
    this.errorMessage,
    this.hasError = false,
    this.isSuccess = false,
  });

  SaveEnterpriseStructureState copyWith({
    bool? isSaving,
    String? errorMessage,
    bool? hasError,
    bool? isSuccess,
  }) {
    return SaveEnterpriseStructureState(
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// Notifier for saving enterprise structure
class SaveEnterpriseStructureNotifier
    extends StateNotifier<SaveEnterpriseStructureState> {
  final SaveEnterpriseStructureUseCase saveUseCase;

  SaveEnterpriseStructureNotifier({required this.saveUseCase})
      : super(const SaveEnterpriseStructureState());

  /// Saves the enterprise structure
  Future<void> saveStructure({
    required String structureName,
    required String description,
    required List<HierarchyLevel> levels,
    int? enterpriseId,
    String? structureCode,
  }) async {
    state = state.copyWith(isSaving: true, hasError: false, errorMessage: null);

    try {
      // Generate structure code if not provided
      final code = structureCode ?? _generateStructureCode(structureName);

      // Convert HierarchyLevel to EnterpriseStructureLevel
      // Only include active levels and maintain their order
      final structureLevels = levels
          .where((level) => level.isActive)
          .toList()
          .asMap()
          .entries
          .map((entry) {
            final level = entry.value;
            final displayOrder = entry.key + 1; // 1-based index for display order
            
            // Parse structureLevelId from HierarchyLevel.id
            // HierarchyLevel.id should be the structure level ID from API
            final structureLevelId = int.tryParse(level.id) ?? 0;
            
            return EnterpriseStructureLevel(
              structureLevelId: structureLevelId,
              levelNumber: level.level,
              displayOrder: displayOrder,
            );
          })
          .toList();

      final enterpriseStructure = EnterpriseStructure(
        enterpriseId: enterpriseId,
        structureCode: code,
        structureName: structureName,
        structureType: 'ENTERPRISE',
        description: description,
        isActive: true,
        levels: structureLevels,
      );

      await saveUseCase(enterpriseStructure);

      state = state.copyWith(
        isSaving: false,
        isSuccess: true,
        hasError: false,
        errorMessage: null,
      );
    } on ValidationException catch (e) {
      // Handle validation errors with detailed messages
      String errorMessage = e.message;
      if (e.errors != null && e.errors!.isNotEmpty) {
        // Extract all error messages
        final errorMessages = <String>[];
        e.errors!.forEach((key, value) {
          if (value is List) {
            errorMessages.addAll(value.map((v) => v.toString()));
          } else {
            errorMessages.add(value.toString());
          }
        });
        if (errorMessages.isNotEmpty) {
          errorMessage = errorMessages.join('\n');
        }
      }
      
      state = state.copyWith(
        isSaving: false,
        hasError: true,
        errorMessage: errorMessage,
        isSuccess: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        isSaving: false,
        hasError: true,
        errorMessage: e.message,
        isSuccess: false,
      );
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        hasError: true,
        errorMessage: 'Failed to save enterprise structure: ${e.toString()}',
        isSuccess: false,
      );
    }
  }

  /// Generates a structure code from structure name
  String _generateStructureCode(String structureName) {
    if (structureName.isEmpty) {
      return 'ORG${DateTime.now().millisecondsSinceEpoch}';
    }

    // Convert name to uppercase and replace spaces with underscores
    final code = structureName
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    // If code is empty or too short, use timestamp
    if (code.isEmpty || code.length < 3) {
      return 'ORG${DateTime.now().millisecondsSinceEpoch}';
    }

    // Limit to 20 characters
    final finalCode = code.length > 20 ? code.substring(0, 20) : code;

    // Add timestamp suffix if needed to ensure uniqueness
    return '${finalCode}_${DateTime.now().millisecondsSinceEpoch % 10000}';
  }

  void reset() {
    state = const SaveEnterpriseStructureState();
  }
}

/// Provider for save enterprise structure notifier
final saveEnterpriseStructureProvider =
    StateNotifierProvider.autoDispose<SaveEnterpriseStructureNotifier,
        SaveEnterpriseStructureState>((ref) {
  final saveUseCase = ref.watch(saveEnterpriseStructureUseCaseProvider);
  return SaveEnterpriseStructureNotifier(saveUseCase: saveUseCase);
});

