import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/views/screens/water_long_sld_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/water_short_sld/views/screens/water_short_sld.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';

class WaterShortSldScreen extends StatelessWidget {
  const WaterShortSldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
      body: Column(
        children: [
          SizedBox(
            height: 650,
            child: WaterShortSld(),
          )
        ],
      ),
      floatingActionButton: SizedBox(
        height: 40,
        width: 155,
        child: FloatingActionButton.large(
          backgroundColor: AppColors.whiteTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: AppColors.textBlueColor, // Border color
              width: 1, // Border width
            ),
          ),
          onPressed: (){
            Get.to(()=>WaterLongSldScreen());
          },child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextComponent(text: "See Full SLD",color: AppColors.textBlueColor,),
            SizedBox(width: 5,),
            Icon(Icons.login_outlined,color: AppColors.textBlueColor,size: 25,)
          ],
        ),
        ),
      ),
    );
  }
}
