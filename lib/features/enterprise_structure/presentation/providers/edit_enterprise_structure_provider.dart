import 'package:flutter_riverpod/flutter_riverpod.dart';

class HierarchyLevel {
  final String id;
  final String name;
  final String icon;
  final int level;
  final bool isMandatory;
  bool isActive;
  final String previewIcon;

  HierarchyLevel({
    required this.id,
    required this.name,
    required this.icon,
    required this.level,
    required this.isMandatory,
    required this.isActive,
    required this.previewIcon,
  });

  HierarchyLevel copyWith({
    String? id,
    String? name,
    String? icon,
    int? level,
    bool? isMandatory,
    bool? isActive,
    String? previewIcon,
  }) {
    return HierarchyLevel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      level: level ?? this.level,
      isMandatory: isMandatory ?? this.isMandatory,
      isActive: isActive ?? this.isActive,
      previewIcon: previewIcon ?? this.previewIcon,
    );
  }
}

class EditEnterpriseStructureState {
  final String structureName;
  final String description;
  final List<HierarchyLevel> levels;

  EditEnterpriseStructureState({
    required this.structureName,
    required this.description,
    required this.levels,
  });

  EditEnterpriseStructureState copyWith({
    String? structureName,
    String? description,
    List<HierarchyLevel>? levels,
  }) {
    return EditEnterpriseStructureState(
      structureName: structureName ?? this.structureName,
      description: description ?? this.description,
      levels: levels ?? this.levels,
    );
  }

  int get totalLevels => levels.length;
  int get activeLevels => levels.where((l) => l.isActive).length;
  int get hierarchyDepth => levels.where((l) => l.isActive).length;
  String get topLevel => levels.first.name;
}

class EditEnterpriseStructureNotifier extends StateNotifier<EditEnterpriseStructureState> {
  EditEnterpriseStructureNotifier({
    required String structureName,
    required String description,
    required List<HierarchyLevel> initialLevels,
  }) : super(EditEnterpriseStructureState(
          structureName: structureName,
          description: description,
          levels: initialLevels.isEmpty ? _getDefaultLevels() : initialLevels,
        ));

  static List<HierarchyLevel> _getDefaultLevels() {
    return [
      HierarchyLevel(
        id: 'company',
        name: 'Company',
        icon: 'assets/icons/company_icon_small.svg',
        level: 1,
        isMandatory: true,
        isActive: true,
        previewIcon: 'assets/icons/company_icon_preview.svg',
      ),
      HierarchyLevel(
        id: 'division',
        name: 'Division',
        icon: 'assets/icons/division_icon_small.svg',
        level: 2,
        isMandatory: false,
        isActive: true,
        previewIcon: 'assets/icons/division_icon_preview.svg',
      ),
      HierarchyLevel(
        id: 'business_unit',
        name: 'Business Unit',
        icon: 'assets/icons/business_unit_icon_small.svg',
        level: 3,
        isMandatory: false,
        isActive: true,
        previewIcon: 'assets/icons/business_unit_icon_preview.svg',
      ),
      HierarchyLevel(
        id: 'department',
        name: 'Department',
        icon: 'assets/icons/department_icon_small.svg',
        level: 4,
        isMandatory: false,
        isActive: true,
        previewIcon: 'assets/icons/department_icon_preview.svg',
      ),
      HierarchyLevel(
        id: 'section',
        name: 'Section',
        icon: 'assets/icons/section_icon_small.svg',
        level: 5,
        isMandatory: false,
        isActive: true,
        previewIcon: 'assets/icons/section_icon_preview.svg',
      ),
    ];
  }

  void updateStructureName(String name) {
    state = state.copyWith(structureName: name);
  }

  void updateDescription(String desc) {
    state = state.copyWith(description: desc);
  }

  void toggleLevelActive(int index) {
    final level = state.levels[index];
    if (level.isMandatory) return;

    final updatedLevels = List<HierarchyLevel>.from(state.levels);
    updatedLevels[index] = level.copyWith(isActive: !level.isActive);
    state = state.copyWith(levels: updatedLevels);
  }

  void moveLevelUp(int index) {
    if (index == 0) return;
    final updatedLevels = List<HierarchyLevel>.from(state.levels);
    final level = updatedLevels[index];
    final previousLevel = updatedLevels[index - 1];

    // Swap levels
    updatedLevels[index] = previousLevel.copyWith(level: level.level);
    updatedLevels[index - 1] = level.copyWith(level: previousLevel.level);

    state = state.copyWith(levels: updatedLevels);
  }

  void moveLevelDown(int index) {
    if (index >= state.levels.length - 1) return;
    final updatedLevels = List<HierarchyLevel>.from(state.levels);
    final level = updatedLevels[index];
    final nextLevel = updatedLevels[index + 1];

    // Swap levels
    updatedLevels[index] = nextLevel.copyWith(level: level.level);
    updatedLevels[index + 1] = level.copyWith(level: nextLevel.level);

    state = state.copyWith(levels: updatedLevels);
  }

  void resetToDefault() {
    // Reset to default hierarchy
    final defaultLevels = [
      HierarchyLevel(
        id: 'company',
        name: 'Company',
        icon: 'assets/icons/company_icon_small.svg',
        level: 1,
        isMandatory: true,
        isActive: true,
        previewIcon: 'assets/icons/company_icon_preview.svg',
      ),
      HierarchyLevel(
        id: 'division',
        name: 'Division',
        icon: 'assets/icons/division_icon_small.svg',
        level: 2,
        isMandatory: false,
        isActive: true,
        previewIcon: 'assets/icons/division_icon_preview.svg',
      ),
      HierarchyLevel(
        id: 'business_unit',
        name: 'Business Unit',
        icon: 'assets/icons/business_unit_icon_small.svg',
        level: 3,
        isMandatory: false,
        isActive: true,
        previewIcon: 'assets/icons/business_unit_icon_preview.svg',
      ),
      HierarchyLevel(
        id: 'department',
        name: 'Department',
        icon: 'assets/icons/department_icon_small.svg',
        level: 4,
        isMandatory: false,
        isActive: true,
        previewIcon: 'assets/icons/department_icon_preview.svg',
      ),
      HierarchyLevel(
        id: 'section',
        name: 'Section',
        icon: 'assets/icons/section_icon_small.svg',
        level: 5,
        isMandatory: false,
        isActive: true,
        previewIcon: 'assets/icons/section_icon_preview.svg',
      ),
    ];
    state = state.copyWith(levels: defaultLevels);
  }
}

