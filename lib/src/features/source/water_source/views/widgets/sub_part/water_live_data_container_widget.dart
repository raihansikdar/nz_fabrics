import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class WaterLiveDataContainerWidget extends StatelessWidget {
  const WaterLiveDataContainerWidget({
    super.key,
    required this.size,
    required this.title,
    required this.text,
    required this.color,
  });

  final Size size;
  final String title;
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: size.height * 0.05,
      width: double.infinity,
      borderRadius: BorderRadius.circular(size.height * k8TextSize),
      child: Padding(
        padding:  const EdgeInsets.only(left: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width > 600 ? size.width * 0.07 : 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                    height: size.height * 0.010,
                    width: size.height * 0.010,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(size.height * 0.005),
                    ),
                  ),
                  TextComponent(text: title,fontFamily: boldFontFamily,)
                ],
              ),
            ),
            SizedBox(width: size.height * k20TextSize,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AssetsPath.sourceLineIconSVG)
              ],
            ),

            SizedBox(width: size.height * k20TextSize,),
            Row(
              children: [
                // const Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     TextComponent(text: "Energy",color: AppColors.secondaryTextColor,),
                //   ],
                // ),
                // SizedBox(width: size.width * k16TextSize,),
                // const Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                //   ],
                // ),
               // SizedBox(width: size.width * k16TextSize,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextComponent(text:  text,),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}