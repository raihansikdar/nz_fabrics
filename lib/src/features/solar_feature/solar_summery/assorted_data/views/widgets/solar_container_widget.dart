import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';

class SolarContainerWidget extends StatelessWidget {
  final double height;
  final Size size;
  final Widget child;
  const SolarContainerWidget({super.key, required this.height, required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    return  Container(
        height: height,
        width: size.width >  500 ? (MediaQuery.of(context).size.width / 2.1) - 10 :  (MediaQuery.of(context).size.width / 2) - 20,
    decoration: BoxDecoration(
    color: AppColors.whiteTextColor,
    borderRadius: BorderRadius.circular(size.height * k12TextSize),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 4),
        ),
      ],
    ),
      child: child,
    );
  }
}
