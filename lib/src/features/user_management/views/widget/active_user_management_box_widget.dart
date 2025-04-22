import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActiveUserManagementBoxWidget extends StatelessWidget {
  const ActiveUserManagementBoxWidget({
    super.key,
    required this.size, required this.firstText, required this.secondText, required this.firstSvgPicture, required this.secondSvgPicture, required this.boxColor, required this.textColor,
  });

  final Size size;
  final SvgPicture firstSvgPicture;
  final SvgPicture secondSvgPicture;
  final String firstText;
  final String secondText;
  final Color boxColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.140,
      width: size.width * 0.290,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(size.height * k12TextSize),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size.height * k25TextSize,),
          firstSvgPicture,
          TextComponent(text: firstText,color: textColor,fontSize: size.height * k18TextSize,fontWeight: FontWeight.bold,),
          TextComponent(text: secondText,color: textColor,fontSize: size.height * k18TextSize,fontWeight: FontWeight.bold,),
          Container(
            transform: Matrix4.translationValues(0, size.height * k25TextSize, 0),
            child: secondSvgPicture,
          ),
        ],
      ),
    );
  }
}