import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/controller/electricity_long_sld_main_bus_bar_true_controller/electricity_long_sld_filter_bus_bar_energy_cost_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/views/screens/electricity_long_sld_main_bus_bar_true/widget/electricity_long_sld_filter_bus_bar_widget.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

import '../widget/electricity_long_sld_date_widget.dart';


class ElectricityLongSLDMainBusBarTrueScreen extends StatefulWidget {
  final String busBarName;
  const ElectricityLongSLDMainBusBarTrueScreen({super.key, required this.busBarName});

  @override
  State<ElectricityLongSLDMainBusBarTrueScreen> createState() => _ElectricityLongSLDMainBusBarTrueScreenState();
}

class _ElectricityLongSLDMainBusBarTrueScreenState extends State<ElectricityLongSLDMainBusBarTrueScreen> {

  @override
  void initState() {
    Get.find<ElectricityLongSLDFilterBusBarEnergyCostController>().fetchFilterSpecificData(busBarName: widget.busBarName, fromDate: Get.find<ElectricityLongSLDFilterBusBarEnergyCostController>().fromDateTEController.text, toDate: Get.find<ElectricityLongSLDFilterBusBarEnergyCostController>().toDateTEController.text);
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
            ElectricityLongSLDDateWidget(nodeName: 'REB 01'),
            SizedBox(
              height: 400,
              child: GetBuilder<ElectricityLongSLDFilterBusBarEnergyCostController>(
                builder: (filterBusBarEnergyCostController) {
                  return ElectricityLongSLDFilterBusBarWidget(
                    size: size,
                    dateDifference: filterBusBarEnergyCostController.dateDifference,
                    monthlyDataList: filterBusBarEnergyCostController.filterBusBarEnergyBusBarList,
                  );
                },
              ),
            ),
            GetBuilder<ElectricityLongSLDFilterBusBarEnergyCostController>(
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
              child: GetBuilder<ElectricityLongSLDFilterBusBarEnergyCostController>(
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