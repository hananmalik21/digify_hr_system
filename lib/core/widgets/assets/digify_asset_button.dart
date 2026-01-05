import 'package:digify_hr_system/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DigifyAssetButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final double? padding;
  final BorderRadius? borderRadius;
  final Color? splashColor;
  final Color? hoverColor;
  final Color? highlightColor;

  const DigifyAssetButton({
    super.key,
    required this.assetPath,
    this.onTap,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.padding,
    this.borderRadius,
    this.splashColor,
    this.hoverColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPadding = padding ?? 4.w;
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(100.r);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: defaultBorderRadius,
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: DigifyAsset(assetPath: assetPath, width: width, height: height, color: color, fit: fit),
        ),
      ),
    );
  }
}
