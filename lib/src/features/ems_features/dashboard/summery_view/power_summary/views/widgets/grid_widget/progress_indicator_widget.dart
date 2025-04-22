import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.size,
    required this.percentage,
    required this.nodeName,
  });

  final Size size;
  final dynamic percentage;
  final String nodeName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal:size.height * k16TextSize,vertical: size.height * k8TextSize),
      child: Stack(
        children: [
          LinearProgressIndicator(
            borderRadius: BorderRadius.circular(size.height * k5TextSize),
            value: percentage/100,
            backgroundColor: AppColors.progressBarSecondaryColor,
            color: AppColors.progressBarPrimaryColor,
            minHeight: size.height * k30TextSize,
          ),
          Positioned(
              left: size.width * 0.32,
              top: 3,
              child: TextComponent(text: "$nodeName (${percentage.toStringAsFixed(2)})",)),
        ],
      ),
    );
  }
}