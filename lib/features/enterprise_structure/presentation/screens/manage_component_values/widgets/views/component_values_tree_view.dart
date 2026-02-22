import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/org_tree/org_units_tree_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComponentValuesTreeView extends ConsumerWidget {
  const ComponentValuesTreeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const OrgUnitsTreeWidget();
  }
}
