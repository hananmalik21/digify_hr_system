import 'package:digify_hr_system/core/widgets/feedback/shimmer_widget.dart';
import 'package:digify_hr_system/features/enterprise_structure/presentation/widgets/shared/hierarchy_level_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shimmer loading widget for hierarchy levels
class ShimmerLoadingWidget extends StatelessWidget {
  final bool isMobile;

  const ShimmerLoadingWidget({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerContainer(width: 200.w, height: 20.h, borderRadius: 4.r),
        SizedBox(height: isMobile ? 12.h : 16.h),
        ...List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsetsDirectional.only(bottom: 12.h),
            child: const HierarchyLevelShimmer(),
          ),
        ),
      ],
    );
  }
}
