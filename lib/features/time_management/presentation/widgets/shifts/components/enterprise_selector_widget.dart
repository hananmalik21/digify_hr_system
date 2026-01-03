import 'package:digify_hr_system/core/utils/responsive_helper.dart';
import 'package:digify_hr_system/core/widgets/forms/digify_select_field.dart';
import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprises_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Widget for selecting an enterprise
class EnterpriseSelectorWidget extends ConsumerWidget {
  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;

  const EnterpriseSelectorWidget({super.key, required this.selectedEnterpriseId, required this.onEnterpriseChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterprisesState = ref.watch(enterprisesProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
      child: Skeletonizer(
        enabled: enterprisesState.isLoading,
        child: DigifySelectField<Enterprise>(
          label: 'Select Enterprise',
          isRequired: true,
          hint: 'Select enterprise',
          items: enterprisesState.isLoading
              ? [const Enterprise(id: 0, name: 'Enterprise Placeholder', isActive: true)]
              : enterprisesState.enterprises,
          itemLabelBuilder: (e) => e.name,
          value: enterprisesState.isLoading ? null : enterprisesState.findEnterpriseById(selectedEnterpriseId),
          onChanged: (e) => onEnterpriseChanged(e?.id),
        ),
      ),
    );
  }
}
