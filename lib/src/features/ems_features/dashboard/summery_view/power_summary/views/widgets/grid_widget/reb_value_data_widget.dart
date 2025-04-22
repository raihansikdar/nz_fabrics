import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class RebValueDataWidget extends StatelessWidget {
  const RebValueDataWidget({
    super.key,
    required this.size,
    required this.powerText,
    required this.energyText,
    required this.costText,
    required this.pfText,
  });

  final Size size;
  final String powerText;
  final String energyText;
  final String costText;
  final String pfText;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextComponent(text: "Total Power ", color: AppColors.secondaryTextColor),
            SizedBox(width: size.height * k16TextSize),
            const TextComponent(text: "Today Energy ", color: AppColors.secondaryTextColor,),
            const TextComponent(text: "Today Cost ", color: AppColors.secondaryTextColor,),
            const TextComponent(text: "PF ", color: AppColors.secondaryTextColor,),
          ],
        ),
        Column(
          children: [
            const TextComponent(text: " : ", color: AppColors.secondaryTextColor, fontFamily: boldFontFamily,),
            SizedBox(width: size.height * k16TextSize),
            const TextComponent(text: " : ", color: AppColors.secondaryTextColor, fontFamily: boldFontFamily,),
            SizedBox(width: size.height * k16TextSize),
            const TextComponent(text: " : ", color: AppColors.secondaryTextColor, fontFamily: boldFontFamily,),
            SizedBox(width: size.height * k16TextSize),
            const TextComponent(text: " : ", color: AppColors.secondaryTextColor, fontFamily: boldFontFamily,)
          ],
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextComponent(
              text: powerText,
            ),
            TextComponent(
              text: energyText,
            ),


            TextComponent(
              text: costText,
            ),

            TextComponent(
              text: pfText,
            ),
          ],
        ),
      ],
    );
  }
}