import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomSheetTitleFilterWidget extends StatelessWidget {
  const BottomSheetTitleFilterWidget({
    super.key, required this.size,
  });
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(AssetsPath.bottomSheetFilterContainerSVG),
        Positioned(
          top: size.height * k10TextSize,
          left: size.height * k30TextSize,
          child: Row(
            children: [
              SvgPicture.asset(AssetsPath.whiteFilterIconSVG),
              SizedBox(width: size.width * k14TextSize),
              const TextComponent(
                text: "Filter",
                color: AppColors.whiteTextColor,
                fontFamily: boldFontFamily,
              ),
            ],
          ),
        ),
      ],
    );
  }
}