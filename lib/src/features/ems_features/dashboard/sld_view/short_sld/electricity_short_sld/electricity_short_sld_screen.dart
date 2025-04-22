import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';

import '../../nz_power_sld/views/screens/nz_power_sld_screen.dart';

class ElectricityShortSldScreen extends StatelessWidget {
  const ElectricityShortSldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
      body: Stack(
        children: [
          Positioned(
            right: 5,
            bottom: 5,
            child: GestureDetector(
              onTap: (){
                Get.to(()=>NZPowerSldScreen());
              },
              child: CustomContainer(
                  height: size.height* 0.05,
                  width: size.width * 0.35,
                  color: AppColors.textBlueColor,
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextComponent(text: "See Full SLD",color: AppColors.textBlueColor,),
                  SizedBox(width: 5,),
                  Icon(Icons.login_outlined,color: AppColors.textBlueColor,)
                ],
              )),
            ),
          )
        ],
      ),
    );
  }
}
