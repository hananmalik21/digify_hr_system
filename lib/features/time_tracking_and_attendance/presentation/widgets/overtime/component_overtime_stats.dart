import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../domain/models/overtime/overtime_management.dart';
import '../../providers/overtime/overtime_provider.dart';

class ComponentOvertimeStats extends ConsumerWidget {
  const ComponentOvertimeStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(overtimeManagementProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 16.0.w;
        if (context.isMobile) {
          return Column(
            spacing: spacing,
            children: List.generate(
              state.stats?.length ?? 0,
              (index) => OvertimeStatCard(stat: state.stats![index]),
            ),
          );
        } else {
          final minCardWidth = 150.0.w;

          final calcCardWidth =
              (constraints.maxWidth - (spacing * (state.stats?.length ?? 1))) /
              (state.stats?.length ?? 1);
          final cardWidth = calcCardWidth > minCardWidth
              ? calcCardWidth
              : minCardWidth;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: List.generate(
              state.stats?.length ?? 0,
              (index) => OvertimeStatCard(
                stat: state.stats![index],
                cardWidth: cardWidth,
              ),
            ),
          );
        }
      },
    );
  }
}

class OvertimeStatCard extends StatelessWidget {
  const OvertimeStatCard({super.key, required this.stat, this.cardWidth});
  final OvertimeStat stat;
  final double? cardWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: context.themeCardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: context.themeCardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: stat.iconBackground,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: DigifyAsset(
                    assetPath: stat.icon,
                    width: 24,
                    height: 24,
                    color: stat.iconColor,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  stat.title,
                  style: TextStyle(
                    fontSize: 15.1.sp,
                    fontWeight: FontWeight.w400,
                    color: context.themeTextSecondary,
                    height: 24 / 15.1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            stat.value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: context.themeTextPrimary,
              height: 24 / 16,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            stat.subTitle,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: context.themeTextSecondary,
              height: 24 / 16,
            ),
          ),
        ],
      ),
    );
  }
}
