import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/dash_board_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/controller/machine_view_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/machine_screen/screen/daily_machine_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/machine_screen/screen/custom_machine_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/machine_screen/screen/new_machine_screen.dart';

class MachineView extends StatefulWidget {
  const MachineView({super.key});

  @override
  State<MachineView> createState() => _MachineViewState();
}

class _MachineViewState extends State<MachineView> {


  DashBoardButtonController controllerExitOrNot = Get.put(DashBoardButtonController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GetBuilder<MachineViewController>(
        builder: (controller) {
          return Column(
               children: [
                 // Row(
                 //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 //   children: [
                 //
                 //     CustomRectangularRadioButton<int>(
                 //       value: 1,
                 //       groupValue:  controller.selectedButton,
                 //       onChanged: (value) {
                 //         controller.updateButton(value: value!);
                 //       },
                 //       label: "Custom",
                 //     ),
                 //     CustomRectangularRadioButton<int>(
                 //       value: 2,
                 //       groupValue: controller.selectedButton,
                 //       onChanged: (value) {
                 //         controller.updateButton(value: value!);
                 //       },
                 //       label: 'Daywise Report' ,
                 //     ),
                 //   ],
                 // ),
               //  const SizedBox(height: 10,),
                // controller.selectedButton == 1 ? DailyMachineScreen() : const CustomMachineScreen(),
                //  controller.selectedButton == 1 ? const CustomMachineScreen() : SizedBox(
                //      height: 580,
                //      child: const MachineDataPage()) ,
                 SizedBox(
                     height:  size.width > 500 ? (controllerExitOrNot.buttonList.isEmpty ? size.height * 0.72 :  size.height * 0.66 ) : size.height * 0.808,
                     child:  CombinedMachineScreen()),
               // SizedBox(
               //     height: 300,
               //     child: const MachineDataPage()),




               ],
          );
        }

    );
  }
}
