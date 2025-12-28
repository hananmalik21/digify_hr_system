import 'package:digify_hr_system/features/enterprise_structure/domain/models/company.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/component_value.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/division.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/company_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/division_management_provider.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tree node for hierarchical display
class ComponentTreeNode {
  final ComponentValue component;
  final List<ComponentTreeNode> children;
  final int level;

  ComponentTreeNode({
    required this.component,
    this.children = const [],
    this.level = 0,
  });
}

/// State for component values list
class ComponentValuesState {
  final List<ComponentValue> components;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final ComponentType? filterType;
  final String? sortColumn;
  final bool sortAscending;
  final bool isTreeView;
  final Set<String> expandedNodes;

  ComponentValuesState({
    this.components = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.filterType,
    this.sortColumn,
    this.sortAscending = true,
    this.isTreeView = true,
    this.expandedNodes = const {},
  });

  ComponentValuesState copyWith({
    List<ComponentValue>? components,
    bool? isLoading,
    String? error,
    String? searchQuery,
    ComponentType? filterType,
    String? sortColumn,
    bool? sortAscending,
    bool? isTreeView,
    Set<String>? expandedNodes,
  }) {
    return ComponentValuesState(
      components: components ?? this.components,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      filterType: filterType ?? this.filterType,
      sortColumn: sortColumn ?? this.sortColumn,
      sortAscending: sortAscending ?? this.sortAscending,
      isTreeView: isTreeView ?? this.isTreeView,
      expandedNodes: expandedNodes ?? this.expandedNodes,
    );
  }

  /// Get stat counts by component type
  Map<ComponentType, int> get statCounts {
    final counts = <ComponentType, int>{};
    for (final component in components) {
      counts[component.type] = (counts[component.type] ?? 0) + 1;
    }
    return counts;
  }

  List<ComponentValue> get filteredComponents {
    var filtered = components;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((component) {
        return component.name.toLowerCase().contains(query) ||
            component.code.toLowerCase().contains(query) ||
            component.arabicName.toLowerCase().contains(query);
      }).toList();
    }

    // Apply type filter
    if (filterType != null) {
      filtered = filtered
          .where((component) => component.type == filterType)
          .toList();
    }

    // Apply sorting
    if (sortColumn != null) {
      filtered = List.from(filtered);
      filtered.sort((a, b) {
        int comparison = 0;
        switch (sortColumn) {
          case 'code':
            comparison = a.code.compareTo(b.code);
            break;
          case 'name':
            comparison = a.name.compareTo(b.name);
            break;
          default:
            comparison = 0;
        }
        return sortAscending ? comparison : -comparison;
      });
    }

    return filtered;
  }
}

/// StateNotifier for managing component values
class ComponentValuesNotifier extends StateNotifier<ComponentValuesState> {
  final Ref ref;
  late final CompaniesNotifier _companiesNotifier;
  late final DivisionsNotifier _divisionsNotifier;

  ComponentValuesNotifier(this.ref) : super(ComponentValuesState()) {
    // Create a new instance of CompaniesNotifier for this component values screen
    _companiesNotifier = CompaniesNotifier(
      getCompaniesUseCase: ref.read(getCompaniesUseCaseProvider),
    );
    // Create a new instance of DivisionsNotifier for this component values screen
    _divisionsNotifier = DivisionsNotifier(
      getDivisionsUseCase: ref.read(getDivisionsUseCaseProvider),
    );
    loadComponents();
  }

  @override
  void dispose() {
    _companiesNotifier.dispose();
    _divisionsNotifier.dispose();
    super.dispose();
  }

  /// Convert CompanyOverview to ComponentValue
  ComponentValue _companyToComponentValue(CompanyOverview company) {
    // Store orgStructureId in parentId for lookup, registrationNumber in managerId for display
    return ComponentValue(
      id: company.id,
      code: company.entityCode,
      name: company.name,
      arabicName: company.nameArabic,
      type: ComponentType.company,
      parentId: company.orgStructureId
          ?.toString(), // Store org structure ID for lookup
      managerId:
          company.registrationNumber, // Store registration number for display
      location: company.location,
      status: company.isActive,
      description: company.industry,
      createdAt: DateTime.now(), // Companies API doesn't provide these dates
      updatedAt: DateTime.now(),
    );
  }

  /// Convert DivisionOverview to ComponentValue
  ComponentValue _divisionToComponentValue(DivisionOverview division) {
    // Store companyId in parentId for lookup, headName in managerId for display
    return ComponentValue(
      id: division.id,
      code: division.code,
      name: division.name,
      arabicName: division.nameArabic,
      type: ComponentType.division,
      parentId: null, // Will be set based on company lookup if needed
      managerId: division.headName, // Store head name for display
      location: division.location,
      status: division.isActive,
      description: division.description ?? division.industry,
      createdAt: DateTime.now(), // Divisions API doesn't provide these dates
      updatedAt: DateTime.now(),
    );
  }

  /// Load components (mock data for now, or companies from API if filter is company)
  Future<void> loadComponents({String? search}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // If filter is company, fetch from companies API using CompaniesNotifier
      if (state.filterType == ComponentType.company) {
        // Use search if provided, otherwise use existing search query
        final searchQuery =
            search ?? (state.searchQuery.isNotEmpty ? state.searchQuery : '');

        if (searchQuery.isNotEmpty) {
          // Trigger search in companies notifier
          _companiesNotifier.searchCompanies(searchQuery);
        } else {
          // Refresh companies
          await _companiesNotifier.refresh();
        }

        // Wait a bit for the notifier to load (debounce delay + API call)
        await Future.delayed(const Duration(milliseconds: 600));

        // Get companies from the notifier state
        final companiesState = _companiesNotifier.state;
        final companies = companiesState.companies;

        final companyComponents = companies
            .map(_companyToComponentValue)
            .toList();

        state = state.copyWith(
          components: companyComponents,
          isLoading: companiesState.isLoading,
          error: companiesState.hasError ? companiesState.errorMessage : null,
        );
        return;
      }

      // Otherwise, use mock data for other component types
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data matching Figma design
      final mockComponents = [
        // Company
        ComponentValue(
          id: '1',
          code: 'KWT-CORP',
          name: 'Kuwait Corporation',
          arabicName: 'شركة الكويت',
          type: ComponentType.company,
          managerId: 'Abdullah Al-Sabah',
          location: 'Kuwait City',
          status: true,
          createdAt: DateTime(2024, 11, 1),
          updatedAt: DateTime(2024, 12, 1),
        ),
        // Finance Division
        ComponentValue(
          id: '2',
          code: 'DIV-FIN',
          name: 'Finance Division',
          arabicName: 'قسم المالية',
          type: ComponentType.division,
          parentId: '1',
          managerId: 'Sarah Al-Mansour',
          location: 'Kuwait City HQ',
          status: true,
          createdAt: DateTime(2024, 10, 15),
          updatedAt: DateTime(2024, 11, 15),
        ),
        // Accounting Business Unit
        ComponentValue(
          id: '3',
          code: 'BU-ACC',
          name: 'Accounting Business Unit',
          arabicName: 'وحدة المحاسبة',
          type: ComponentType.businessUnit,
          parentId: '2',
          managerId: 'Omar Al-Khalifa',
          location: 'Kuwait City HQ',
          status: true,
          createdAt: DateTime(2024, 11, 10),
          updatedAt: DateTime(2024, 12, 5),
        ),
        // Accounts Payable Department
        ComponentValue(
          id: '4',
          code: 'DEPT-AP',
          name: 'Accounts Payable Department',
          arabicName: 'قسم الحسابات الدائنة',
          type: ComponentType.department,
          parentId: '3',
          managerId: 'Layla Hassan',
          location: 'Kuwait City HQ - Floor 3',
          status: true,
          createdAt: DateTime(2024, 11, 20),
          updatedAt: DateTime(2024, 12, 7),
        ),
        // Vendor Payments Section
        ComponentValue(
          id: '5',
          code: 'SECT-VENDOR',
          name: 'Vendor Payments Section',
          arabicName: 'قسم مدفوعات الموردين',
          type: ComponentType.section,
          parentId: '4',
          managerId: 'Noura Al-Sabah',
          location: 'Kuwait City HQ - Floor 3 - Room 301',
          status: true,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 10)),
        ),
        // Expense Processing Section
        ComponentValue(
          id: '6',
          code: 'SECT-EXP',
          name: 'Expense Processing Section',
          arabicName: 'قسم معالجة المصروفات',
          type: ComponentType.section,
          parentId: '4',
          managerId: 'Youssef Al-Ali',
          location: 'Kuwait City HQ - Floor 3 - Room 302',
          status: true,
          createdAt: DateTime.now().subtract(const Duration(days: 14)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 8)),
        ),
        // Accounts Receivable Department
        ComponentValue(
          id: '7',
          code: 'DEPT-AR',
          name: 'Accounts Receivable Department',
          arabicName: 'قسم الحسابات المدينة',
          type: ComponentType.department,
          parentId: '3',
          managerId: 'Khalid Al-Azmi',
          location: 'Kuwait City HQ - Floor 3',
          status: true,
          createdAt: DateTime(2024, 11, 20),
          updatedAt: DateTime(2024, 12, 7),
        ),
        // Collections Section
        ComponentValue(
          id: '8',
          code: 'SECT-COLL',
          name: 'Collections Section',
          arabicName: 'قسم التحصيل',
          type: ComponentType.section,
          parentId: '7',
          managerId: 'Hessa Al-Kandari',
          location: 'Kuwait City HQ - Floor 3 - Room 305',
          status: true,
          createdAt: DateTime.now().subtract(const Duration(days: 13)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        // General Ledger Department
        ComponentValue(
          id: '9',
          code: 'DEPT-GL',
          name: 'General Ledger Department',
          arabicName: 'قسم الأستاذ العام',
          type: ComponentType.department,
          parentId: '3',
          managerId: 'Maryam Al-Mutairi',
          location: 'Kuwait City HQ - Floor 3',
          status: true,
          createdAt: DateTime(2024, 11, 20),
          updatedAt: DateTime(2024, 12, 7),
        ),
        // Treasury Business Unit
        ComponentValue(
          id: '10',
          code: 'BU-TREAS',
          name: 'Treasury Business Unit',
          arabicName: 'وحدة الخزينة',
          type: ComponentType.businessUnit,
          parentId: '2',
          managerId: 'Noor Abdullah',
          location: 'Kuwait City HQ',
          status: true,
          createdAt: DateTime(2024, 11, 10),
          updatedAt: DateTime(2024, 12, 5),
        ),
        // Operations Division
        ComponentValue(
          id: '11',
          code: 'DIV-OPS',
          name: 'Operations Division',
          arabicName: 'قسم العمليات',
          type: ComponentType.division,
          parentId: '1',
          managerId: 'Mohammed Al-Khalifa',
          location: 'Kuwait City HQ',
          status: true,
          createdAt: DateTime(2024, 10, 15),
          updatedAt: DateTime(2024, 11, 15),
        ),
        // Logistics Business Unit
        ComponentValue(
          id: '12',
          code: 'BU-LOG',
          name: 'Logistics Business Unit',
          arabicName: 'وحدة اللوجستيات',
          type: ComponentType.businessUnit,
          parentId: '11',
          managerId: 'Ali Mahmoud',
          location: 'Shuwaikh Industrial',
          status: true,
          createdAt: DateTime(2024, 11, 10),
          updatedAt: DateTime(2024, 12, 3),
        ),
        // Human Resources Division
        ComponentValue(
          id: '13',
          code: 'DIV-HR',
          name: 'Human Resources Division',
          arabicName: 'قسم الموارد البشرية',
          type: ComponentType.division,
          parentId: '1',
          managerId: 'Fatima Al-Rashid',
          location: 'Kuwait City HQ',
          status: true,
          createdAt: DateTime(2024, 10, 15),
          updatedAt: DateTime(2024, 11, 15),
        ),
        // Recruitment Department
        ComponentValue(
          id: '14',
          code: 'DEPT-REC',
          name: 'Recruitment Department',
          arabicName: 'قسم التوظيف',
          type: ComponentType.department,
          parentId: '13',
          managerId: 'Ahmed Al-Rashid',
          location: 'Kuwait City HQ - Floor 2',
          status: true,
          createdAt: DateTime(2024, 10, 20),
          updatedAt: DateTime(2024, 11, 20),
        ),
      ];

      state = state.copyWith(components: mockComponents, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Search components
  void searchComponents(String query) {
    state = state.copyWith(searchQuery: query);

    // If company filter is active, use companies notifier search
    if (state.filterType == ComponentType.company) {
      _companiesNotifier.searchCompanies(query);

      // Update state after a delay to reflect the search results
      Future.delayed(const Duration(milliseconds: 600), () {
        if (state.filterType == ComponentType.company) {
          final companiesState = _companiesNotifier.state;
          final companies = companiesState.companies;
          final companyComponents = companies
              .map(_companyToComponentValue)
              .toList();

          state = state.copyWith(
            components: companyComponents,
            isLoading: companiesState.isLoading,
            error: companiesState.hasError ? companiesState.errorMessage : null,
          );
        }
      });
    }

    // If division filter is active, use divisions notifier search
    if (state.filterType == ComponentType.division) {
      _divisionsNotifier.searchDivisions(query);

      // Update state after a delay to reflect the search results
      Future.delayed(const Duration(milliseconds: 600), () {
        if (state.filterType == ComponentType.division) {
          final divisionsState = _divisionsNotifier.state;
          final divisions = divisionsState.divisions;
          final divisionComponents = divisions
              .map(_divisionToComponentValue)
              .toList();

          state = state.copyWith(
            components: divisionComponents,
            isLoading: divisionsState.isLoading,
            error: divisionsState.hasError ? divisionsState.errorMessage : null,
          );
        }
      });
    }
  }

  /// Filter by component type
  void filterByType(ComponentType? type) {
    // When a filter type is selected, switch to table view
    // When filter is cleared, switch back to tree view

    state = state.copyWith(
      filterType: type,
      isTreeView: type == null,
      searchQuery: '', // Clear search when changing filter
    );

    // Reload components when filter changes (especially for company)
    loadComponents();
  }

  /// Sort by column
  void sortByColumn(String column) {
    final isAscending = state.sortColumn == column && !state.sortAscending;
    state = state.copyWith(sortColumn: column, sortAscending: isAscending);
  }

  /// Delete component
  Future<void> deleteComponent(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedComponents = state.components
          .where((c) => c.id != id)
          .toList();
      state = state.copyWith(components: updatedComponents);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Toggle tree view
  void toggleTreeView() {
    // When switching to tree view, clear any active filter
    state = state.copyWith(
      isTreeView: !state.isTreeView,
      filterType: !state.isTreeView ? null : state.filterType,
    );
  }

  /// Build tree structure from flat component list
  List<ComponentTreeNode> buildTreeStructure() {
    final filtered = state.filteredComponents;
    if (filtered.isEmpty) return [];

    // Create a map of all components
    final componentMap = <String, ComponentValue>{};
    for (final component in filtered) {
      componentMap[component.id] = component;
    }

    // Build children map
    final childrenMap = <String, List<ComponentValue>>{};
    for (final component in filtered) {
      if (component.parentId != null) {
        childrenMap.putIfAbsent(component.parentId!, () => []).add(component);
      }
    }

    // Recursive function to build tree nodes
    ComponentTreeNode buildNode(ComponentValue component, int level) {
      final children = childrenMap[component.id] ?? [];
      final childNodes = children
          .map((child) => buildNode(child, level + 1))
          .toList();

      // Sort children by name
      childNodes.sort((a, b) => a.component.name.compareTo(b.component.name));

      return ComponentTreeNode(
        component: component,
        children: childNodes,
        level: level,
      );
    }

    // Find root nodes (components without parents)
    final rootComponents = filtered.where((c) => c.parentId == null).toList();
    rootComponents.sort((a, b) => a.name.compareTo(b.name));

    // Build tree from root nodes
    return rootComponents.map((component) => buildNode(component, 0)).toList();
  }

  /// Toggle node expansion
  void toggleNodeExpansion(String nodeId) {
    final newExpanded = Set<String>.from(state.expandedNodes);
    if (newExpanded.contains(nodeId)) {
      newExpanded.remove(nodeId);
    } else {
      newExpanded.add(nodeId);
    }
    state = state.copyWith(expandedNodes: newExpanded);
  }

  /// Expand all nodes
  void expandAll() {
    final allNodeIds = state.components.map((c) => c.id).toSet();
    state = state.copyWith(expandedNodes: allNodeIds);
  }

  /// Collapse all nodes
  void collapseAll() {
    state = state.copyWith(expandedNodes: {});
  }
}

/// Provider for component values
final componentValuesProvider =
    StateNotifierProvider<ComponentValuesNotifier, ComponentValuesState>(
      (ref) => ComponentValuesNotifier(ref),
    );
