import 'package:digify_hr_system/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:flutter/material.dart';

/// Widget for displaying shifts loading errors
class ShiftsErrorWidget extends StatelessWidget {
  final ShiftState shiftsState;

  const ShiftsErrorWidget({super.key, required this.shiftsState});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                shiftsState.errorMessage ?? 'An error occurred',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
