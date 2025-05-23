import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/steam_short_sld/controller/steam_short_sld_main_bus_bar_true_controller/steam_short_sld_filter_bus_bar_energy_cost_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/steam_short_sld/views/screens/steam_short_sld_main_bus_bar_true/widget/steam_short_sld_filter_bus_bar_widget.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

import '../widget/steam_short_sld_date_widget.dart';


class SteamShortSLDMainBusBarTrueScreen extends StatefulWidget {
  final String busBarName;
  const SteamShortSLDMainBusBarTrueScreen({super.key, required this.busBarName});

  @override
  State<SteamShortSLDMainBusBarTrueScreen> createState() => _SteamShortSLDMainBusBarTrueScreenState();
}

class _SteamShortSLDMainBusBarTrueScreenState extends State<SteamShortSLDMainBusBarTrueScreen> {

  @override
  void initState() {
    Get.find<SteamShortSLDFilterBusBarEnergyCostController>().fetchFilterSpecificData(busBarName: widget.busBarName, fromDate: Get.find<SteamShortSLDFilterBusBarEnergyCostController>().fromDateTEController.text, toDate: Get.find<SteamShortSLDFilterBusBarEnergyCostController>().toDateTEController.text);
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
            SteamShortSLDDateWidget(nodeName: 'REB 01'),

            SizedBox(
              height: 400,
              child: GetBuilder<SteamShortSLDFilterBusBarEnergyCostController>(
                builder: (filterBusBarEnergyCostController) {
                  return SteamShortSLDFilterBusBarWidget(
                    size: size,
                    dateDifference: filterBusBarEnergyCostController.dateDifference,
                    monthlyDataList: filterBusBarEnergyCostController.filterBusBarEnergyBusBarList,
                  );
                },
              ),
            ),
            GetBuilder<SteamShortSLDFilterBusBarEnergyCostController>(
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
              child: GetBuilder<SteamShortSLDFilterBusBarEnergyCostController>(
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