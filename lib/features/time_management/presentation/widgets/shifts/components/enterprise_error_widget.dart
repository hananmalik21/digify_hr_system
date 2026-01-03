import 'package:digify_hr_system/features/enterprise_structure/presentation/providers/enterprises_provider.dart';
import 'package:flutter/material.dart';

/// Widget for displaying enterprise loading errors
class EnterpriseErrorWidget extends StatelessWidget {
  final EnterprisesState enterprisesState;

  const EnterpriseErrorWidget({super.key, required this.enterprisesState});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                enterprisesState.errorMessage ?? 'Failed to load enterprises',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
