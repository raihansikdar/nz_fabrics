import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';

class CustomBoxShadowContainer extends StatelessWidget {
  const CustomBoxShadowContainer({
    super.key,
  required this.height,
    required this.size,
    required this.child, this.color,
  });

  final double height;
  final Size size;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
          color: color ??  AppColors.whiteTextColor,
          borderRadius:  BorderRadius.circular(size.height * k12TextSize),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ]
      ),
      child: child,
    );
  }
}