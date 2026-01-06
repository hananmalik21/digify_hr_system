import 'package:digify_hr_system/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';

/// Converts StructureLevelItem to HierarchyLevel
HierarchyLevel convertToHierarchyLevel(StructureLevelItem level) {
  // Map level code to icon paths (same logic as StructureLevelDto)
  final icons = getIconsForLevelCode(level.levelCode);

  return HierarchyLevel(
    id: level.levelId.toString(),
    name: level.levelName,
    icon: icons['icon']!,
    level: level.displayOrder,
    // Use display_order for level position
    isMandatory: level.isMandatory,
    isActive: level.isActive,
    previewIcon: icons['previewIcon']!,
  );
}

/// Maps level codes to icon paths (same as StructureLevelDto)
Map<String, String> getIconsForLevelCode(String levelCode) {
  switch (levelCode.toUpperCase()) {
    case 'COMPANY':
    case 'COMP':
      return {
        'icon': 'assets/icons/company_icon_small.svg',
        'previewIcon': 'assets/icons/company_icon_preview.svg',
      };
    case 'DIVISION':
    case 'DIV':
      return {
        'icon': 'assets/icons/division_icon_small.svg',
        'previewIcon': 'assets/icons/division_icon_preview.svg',
      };
    case 'BUSINESS_UNIT':
    case 'BUSINESSUNIT':
    case 'BU':
      return {
        'icon': 'assets/icons/business_unit_icon_small.svg',
        'previewIcon': 'assets/icons/business_unit_icon_preview.svg',
      };
    case 'DEPARTMENT':
    case 'DEPT':
      return {
        'icon': 'assets/icons/department_icon_small.svg',
        'previewIcon': 'assets/icons/department_icon_preview.svg',
      };
    case 'SECTION':
    case 'SECT':
      return {
        'icon': 'assets/icons/section_icon_small.svg',
        'previewIcon': 'assets/icons/section_icon_preview.svg',
      };
    default:
      return {
        'icon': 'assets/icons/company_icon_small.svg',
        'previewIcon': 'assets/icons/company_icon_preview.svg',
      };
  }
}











