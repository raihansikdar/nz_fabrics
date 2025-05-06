import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/electricity/views/screens/shed_screen/controller/shed_view_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/electricity/views/screens/shed_screen/screens/shed_wise_custom_screen.dart';

class ShedView extends StatelessWidget {
  const ShedView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GetBuilder<ShedViewController>(
        builder: (controller) {
          return Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     CustomRectangularRadioButton<int>(
              //       value: 1,
              //       groupValue: controller.selectedButton,
              //       onChanged: (value) {
              //         controller.updateButton(value: value!);
              //       },
              //       label: 'Custom' ,
              //     ),
              //     CustomRectangularRadioButton<int>(
              //       value: 2,
              //       groupValue:  controller.selectedButton,
              //       onChanged: (value) {
              //         controller.updateButton(value: value!);
              //       },
              //       label: "DayWise Report",
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 10,),
              // controller.selectedButton == 2 ? SizedBox(
              //     height:MediaQuery.sizeOf(context).height * 0.65,
              //     child: /*ShedWiseTodayScreen()*/ ShedDataPage()
              //     ) :
                   SizedBox(
                  height:size.width > 500 ? size.height * 0.66 : size.height * 0.77,
                  child:  ShedWiseCustomScreen()),


            ],
          );
        }

    );
  }
}
