import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';

class EmptyPageWidget extends StatelessWidget {
  const EmptyPageWidget({
    super.key,
    required this.size
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: size.height * 0.150),
      child: Center(child: Column(
        children: [
          Lottie.asset(AssetsPath.emptyJson, height: size.height * 0.26),
          TextComponent(text: "There is no data available now.",color: AppColors.greyColor,),
        ],
      )),
    );
  }
}