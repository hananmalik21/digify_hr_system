import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/hierarchy_preview_widget.dart';
import 'package:flutter/material.dart';

/// Helper function to calculate preview width
double getPreviewWidth(int level, int totalLevels) {
  final baseWidth = 814.0;
  final widthDecrement = 24.0;
  return baseWidth - (widthDecrement * (level - 1));
}

/// Hierarchy preview section widget
class HierarchyPreviewSection extends StatelessWidget {
  final List<HierarchyLevel> levels;

  const HierarchyPreviewSection({
    super.key,
    required this.levels,
  });

  @override
  Widget build(BuildContext context) {
    final activeLevels = levels.where((level) => level.isActive).toList();
    final previewLevels = activeLevels.asMap().entries.map((entry) {
      final index = entry.key;
      final level = entry.value;
      final sequentialLevel = index + 1; // Sequential level number (1, 2, 3, ...)

      return HierarchyPreviewLevel(
        name: level.name,
        icon: level.previewIcon,
        level: sequentialLevel,
        width: getPreviewWidth(sequentialLevel, activeLevels.length),
      );
    }).toList();

    return HierarchyPreviewWidget(levels: previewLevels);
  }
}

