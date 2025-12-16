import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIconWidget extends StatelessWidget {
  final String assetPath;
  final double? size;
  final Color? color;

  const SvgIconWidget({
    super.key,
    required this.assetPath,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: size ?? 20.sp,
      height: size ?? 20.sp,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      fit: BoxFit.contain,
      placeholderBuilder: (context) => SizedBox(
        width: size ?? 20.sp,
        height: size ?? 20.sp,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      // Ensure SVG renders correctly
      semanticsLabel: '',
    );
  }
}

