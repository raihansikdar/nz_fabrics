import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnalysisProFilterResult extends StatelessWidget {
  const AnalysisProFilterResult({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: size.width > 800 ? Matrix4.translationValues(0, -9, 0) : Matrix4.translationValues(0, -2, 0),
      child: Stack(
        children: [
          SvgPicture.asset(AssetsPath.filterResultIconSVG, height: size.height * 0.035),
          Positioned(
            top: size.height * 0.005,
            left: size.height * 0.048,
            right: 0,
            child: TextComponent(
              text: "Filter Result",
              fontSize: size.height * k18TextSize,
              color: AppColors.whiteTextColor,
            ),
          ),
        ],
      ),
    );
  }
}