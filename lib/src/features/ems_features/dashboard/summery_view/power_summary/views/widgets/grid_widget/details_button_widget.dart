import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class DetailsButtonWidget extends StatelessWidget {
  const DetailsButtonWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: size.height * k50TextSize,
      width: size.width * 0.18,
      borderRadius: BorderRadius.circular(size.height * k8TextSize),
      child: Center(child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextComponent(text: "Details",color: AppColors.secondaryTextColor,fontSize: size.height * k18TextSize,),

          // SvgPicture.asset(AssetsPath.detailsListIconSVG,height: size.height * k22TextSize,)
        ],
      ),
      ),
    );
  }
}