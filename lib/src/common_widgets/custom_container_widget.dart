import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    super.key,
    required this.height,
    required this.width,
    required this.child,
    this.borderRadius,
    this.color,
  });
  final double height;
  final double width;
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: AppColors.whiteTextColor,
          borderRadius: borderRadius,
          border: Border.all(color: color ??  AppColors.containerBorderColor, width: 1.0)),
      child: child,
    );
  }
}
