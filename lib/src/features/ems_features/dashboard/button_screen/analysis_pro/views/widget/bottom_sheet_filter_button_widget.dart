import 'package:nz_fabrics/src/common_widgets/custom_color_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomSheetFilterButtonWidget extends StatelessWidget {
  const BottomSheetFilterButtonWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(10, -10, 0),
      child: CustomColorContainer(

        height: size.width > 800 ? size.height * 0.060 : size.height * k40TextSize,
        width: size.width > 800 ? size.width * 0.120 : size.width * 0.180,
        size: size,
        color: AppColors.containerTopColor,
        border: Border.all(color: AppColors.primaryColor, width: 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(AssetsPath.filterIconSVG),
            const TextComponent(
              text: "Filter",
              color: AppColors.primaryColor,
              fontFamily: boldFontFamily,
            )
          ],
        ),
      ),
    );
  }
}