import 'package:digify_hr_system/features/enterprise_structure/domain/models/org_unit_tree.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/usecases/get_org_units_tree_usecase.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrgUnitsTreeState {
  final AsyncValue<OrgUnitTree> tree;
  final Set<String> expandedNodes;

  OrgUnitsTreeState({required this.tree, this.expandedNodes = const {}});

  OrgUnitsTreeState copyWith({AsyncValue<OrgUnitTree>? tree, Set<String>? expandedNodes}) {
    return OrgUnitsTreeState(tree: tree ?? this.tree, expandedNodes: expandedNodes ?? this.expandedNodes);
  }
}

final getOrgUnitsTreeUseCaseProvider = Provider<GetOrgUnitsTreeUseCase>((ref) {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return GetOrgUnitsTreeUseCase(repository: repository);
});

class OrgUnitsTreeNotifier extends AutoDisposeNotifier<OrgUnitsTreeState> {
  @override
  OrgUnitsTreeState build() {
    _loadTree();
    return OrgUnitsTreeState(tree: const AsyncValue.loading());
  }

  Future<void> _loadTree() async {
    final useCase = ref.watch(getOrgUnitsTreeUseCaseProvider);
    try {
      final tree = await useCase();
      state = state.copyWith(tree: AsyncValue.data(tree));
    } catch (e, stack) {
      state = state.copyWith(tree: AsyncValue.error(e, stack));
    }
  }

  void toggleNode(String nodeId) {
    final expanded = Set<String>.from(state.expandedNodes);
    if (expanded.contains(nodeId)) {
      expanded.remove(nodeId);
    } else {
      expanded.add(nodeId);
    }
    state = state.copyWith(expandedNodes: expanded);
  }

  void expandAll() {
    final tree = state.tree.valueOrNull;
    if (tree == null) return;

    final allNodes = <String>{};
    void addNode(OrgUnitTreeNode node) {
      if (node.children.isNotEmpty) {
        allNodes.add(node.orgUnitId);
        for (final child in node.children) {
          addNode(child);
        }
      }
    }

    for (final node in tree.tree) {
      addNode(node);
    }
    state = state.copyWith(expandedNodes: allNodes);
  }

  void collapseAll() {
    state = state.copyWith(expandedNodes: {});
  }

  Future<void> refresh() async {
    state = state.copyWith(tree: const AsyncValue.loading());
    await _loadTree();
  }
}

final orgUnitsTreeProvider = NotifierProvider.autoDispose<OrgUnitsTreeNotifier, OrgUnitsTreeState>(
  OrgUnitsTreeNotifier.new,
);
