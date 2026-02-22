import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_unit_tree.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/org_tree/widgets/org_tree_header.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/org_tree/widgets/org_unit_tree_node_widget.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrgTreeSkeleton extends StatelessWidget {
  final bool isDark;

  const OrgTreeSkeleton({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrgTreeHeader(onExpandAll: () {}, onCollapseAll: () {}, isDark: isDark),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: OrgUnitTree.mock().tree.map((node) {
                return OrgUnitTreeNodeWidget(
                  node: node,
                  expandedNodes: const {},
                  onToggle: (_) {},
                  isDark: isDark,
                  level: 0,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
