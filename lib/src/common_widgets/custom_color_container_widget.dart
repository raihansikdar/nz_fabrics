import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';

class CustomColorContainer extends StatelessWidget {
  const CustomColorContainer({
    super.key,
    required this.height,
    required this.width,
    required this.size,
    required this.child,
    this.color,
    this.border,
  });

  final double height;
  final double width;
  final Size size;
  final Widget child;
  final Color? color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color ??  AppColors.whiteTextColor,
          borderRadius:  BorderRadius.circular(size.height * k12TextSize),
          border:  border ?? Border.all(color: Colors.transparent),
      ),
      child: child,
    );
  }
}