import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/water_short_sld/controller/water_short_sld_main_bus_bar_true_controller/water_short_sld_filter_bus_bar_energy_cost_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/water_short_sld/views/screens/water_short_sld_main_bus_bar_true/widget/water_short_sld_filter_bus_bar_widget.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

import '../widget/water_short_sld_date_widget.dart';


class WaterShortSLDMainBusBarTrueScreen extends StatefulWidget {
  final String busBarName;
  const WaterShortSLDMainBusBarTrueScreen({super.key, required this.busBarName});

  @override
  State<WaterShortSLDMainBusBarTrueScreen> createState() => _WaterShortSLDMainBusBarTrueScreenState();
}

class _WaterShortSLDMainBusBarTrueScreenState extends State<WaterShortSLDMainBusBarTrueScreen> {

  @override
  void initState() {
    Get.find<WaterShortSLDFilterBusBarEnergyCostController>().fetchFilterSpecificData(busBarName: widget.busBarName, fromDate: Get.find<WaterShortSLDFilterBusBarEnergyCostController>().fromDateTEController.text, toDate: Get.find<WaterShortSLDFilterBusBarEnergyCostController>().toDateTEController.text);
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
            WaterShortSLDDateWidget(nodeName: 'REB 01'),

            SizedBox(
              height: 400,
              child: GetBuilder<WaterShortSLDFilterBusBarEnergyCostController>(
                builder: (filterBusBarEnergyCostController) {
                  return WaterShortSLDFilterBusBarWidget(
                    size: size,
                    dateDifference: filterBusBarEnergyCostController.dateDifference,
                    monthlyDataList: filterBusBarEnergyCostController.filterBusBarEnergyBusBarList,
                  );
                },
              ),
            ),
            GetBuilder<WaterShortSLDFilterBusBarEnergyCostController>(
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
              child: GetBuilder<WaterShortSLDFilterBusBarEnergyCostController>(
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