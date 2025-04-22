// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nz_ums/src/common_widgets/app_bar/custom_app_bar_widget.dart';
// import 'package:nz_ums/src/features/ems_features/dashboard/sld_view/nz_power_sld/controller/main_bus_bar_true_controller/filter_bus_bar_energy_cost_controller.dart';
// import 'package:nz_ums/src/features/ems_features/dashboard/sld_view/nz_power_sld/views/screens/main_bus_bar_true/widget/date_widget.dart';
// import 'package:nz_ums/src/features/ems_features/dashboard/sld_view/nz_power_sld/views/screens/main_bus_bar_true/widget/filter_bus_bar_widget.dart';
// import 'package:nz_ums/src/utility/style/app_colors.dart';
//
// class MainBusBarTrueScreen extends StatefulWidget {
//   final String busBarName;
//   const MainBusBarTrueScreen({super.key, required this.busBarName});
//
//   @override
//   State<MainBusBarTrueScreen> createState() => _MainBusBarTrueScreenState();
// }
//
// class _MainBusBarTrueScreenState extends State<MainBusBarTrueScreen> {
//
//   @override
//   void initState() {
//     Get.find<FilterBusBarEnergyCostController>().fetchFilterSpecificData(busBarName: widget.busBarName, fromDate: Get.find<FilterBusBarEnergyCostController>().fromDateTEController.text, toDate: Get.find<FilterBusBarEnergyCostController>().toDateTEController.text);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.sizeOf(context);
//
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar:  CustomAppBarWidget(
//       text: widget.busBarName,
//       backPreviousScreen: true,
//       onBackButtonPressed: (){
//
//       },
//     ),
//       body: Column(
//         children: [
//           DateWidget(nodeName: 'REB 01',),
//
//           SizedBox(
//             height: 400,
//             child: GetBuilder<FilterBusBarEnergyCostController>(
//               builder: (filterBusBarEnergyCostController) {
//                 return FilterBusBarWidget(
//                   size: size,dateDifference: filterBusBarEnergyCostController.dateDifference,
//                   monthlyDataList: filterBusBarEnergyCostController.filterBusBarEnergyBusBarList,);
//               }
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/nz_power_sld/controller/main_bus_bar_true_controller/filter_bus_bar_energy_cost_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/nz_power_sld/views/screens/main_bus_bar_true/widget/date_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/nz_power_sld/views/screens/main_bus_bar_true/widget/filter_bus_bar_widget.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class MainBusBarTrueScreen extends StatefulWidget {
  final String busBarName;
  const MainBusBarTrueScreen({super.key, required this.busBarName});

  @override
  State<MainBusBarTrueScreen> createState() => _MainBusBarTrueScreenState();
}

class _MainBusBarTrueScreenState extends State<MainBusBarTrueScreen> {

  @override
  void initState() {
    Get.find<FilterBusBarEnergyCostController>().fetchFilterSpecificData(busBarName: widget.busBarName, fromDate: Get.find<FilterBusBarEnergyCostController>().fromDateTEController.text, toDate: Get.find<FilterBusBarEnergyCostController>().toDateTEController.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar:  CustomAppBarWidget(
        text: widget.busBarName,
        backPreviousScreen: true,
        onBackButtonPressed: (){

        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DateWidget(nodeName: 'REB 01'),

            SizedBox(
              height: 400,
              child: GetBuilder<FilterBusBarEnergyCostController>(
                builder: (filterBusBarEnergyCostController) {
                  return FilterBusBarWidget(
                    size: size,
                    dateDifference: filterBusBarEnergyCostController.dateDifference,
                    monthlyDataList: filterBusBarEnergyCostController.filterBusBarEnergyBusBarList,
                  );
                },
              ),
            ),
            GetBuilder<FilterBusBarEnergyCostController>(
              builder: (filterBusBarEnergyCostController) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: (){
                      filterBusBarEnergyCostController.downloadFilterBusBarDataSheet(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CustomContainer(
                        height: size.height * 0.050,
                        width:  size.width * 0.3,
                        borderRadius: BorderRadius.circular(size.height * k8TextSize),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextComponent(text: "Download"),
                              Icon(Icons.download)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            ),
            SizedBox(
              height: 400,
              child: GetBuilder<FilterBusBarEnergyCostController>(
                builder: (filterBusBarEnergyCostController) {
                  return FilterBusBarTableWidget(
                    size: size,
                    //   dateDifference: filterBusBarEnergyCostController.dateDifference,
                    monthlyDataList: filterBusBarEnergyCostController.filterBusBarEnergyBusBarList,
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}