
import 'dart:developer';

import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/element_button_view_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/filter_specific_node_data/filter_specific_node_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/plot_controller/plot_line_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/daily_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/monthly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/this_day_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/this_month_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/this_year_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/today_runtime_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/yearly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/screen/power_view_power_and_energy_element_details_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/screen/revenue_view_power_and_energy_element_details_screen.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PowerAndEnergyElementDetailsScreen extends StatefulWidget {
  final String elementName;
  final String elementCategory;
  final String solarCategory;
  final double gaugeValue;
  final String gaugeUnit;


  const PowerAndEnergyElementDetailsScreen({super.key, required this.elementName, required this.gaugeValue, required this.gaugeUnit, required this.elementCategory, required this.solarCategory,});

  @override
  State<PowerAndEnergyElementDetailsScreen> createState() => _PowerAndEnergyElementDetailsScreenState();
}

class _PowerAndEnergyElementDetailsScreenState extends State<PowerAndEnergyElementDetailsScreen> with  TickerProviderStateMixin {

  PlotLineController plotLineController = Get.put(PlotLineController());
  @override
  void initState() {

    //TodayRuntimeDataController todayRuntimeDataController = Get.put(TodayRuntimeDataController());
   // ThisDayDataController thisDayDataController = Get.put(ThisDayDataController());


    WidgetsBinding.instance.addPostFrameCallback((_){

      log("--> solarCategory --> ${widget.solarCategory}");

     // todayRuntimeDataController.fetchTodayRuntimeData(sourceName: widget.elementName);
     // thisDayDataController.fetchThisDayData(sourceName: widget.elementName);
     // Get.find<ThisMonthDataController>().fetchThisMonthData(sourceName: widget.elementName);
    //  Get.find<ThisYearDataController>().fetchThisYearData(sourceName: widget.elementName);

     // Get.find<DailyDataController>().fetchDailyData(elementName: widget.elementName);
     // Get.find<MonthlyDataController>().fetchMonthlyData(elementName: widget.elementName);
     // Get.find<YearlyDataController>().fetchYearlyData(elementName: widget.elementName);



      //Get.find<FilterSpecificNodeDataController>().fetchFilterSpecificData(nodeName: widget.elementName, fromDate: Get.find<FilterSpecificNodeDataController>().fromDateTEController.text, toDate: Get.find<FilterSpecificNodeDataController>().toDateTEController.text);
     // Get.find<FilterSpecificNodeDataController>().fetchFilterSpecificTableData(nodeName: widget.elementName, fromDate: Get.find<FilterSpecificNodeDataController>().fromDateTEController.text, toDate: Get.find<FilterSpecificNodeDataController>().toDateTEController.text);
     // plotLineController.fetchMaxMachineData(nodeName: widget.elementName);

    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:  CustomAppBarWidget(
        text: widget.elementName,
        backPreviousScreen: true,
        onBackButtonPressed: (){
          Get.find<ElementButtonViewController>().updateSelectedValue(1);
          Get.find<FilterSpecificNodeDataController>().updateSelectedButton(value: 1);
          Get.find<FilterSpecificNodeDataController>().clearFilterIngDate();
        },
      ),
      body: Stack(
        children: [
          Positioned(
            top: size.height * 0.050,
            left: 0,
            right: 0,
            child: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                border:
                Border.all(color: AppColors.containerBorderColor, width: 1.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size.height * k30TextSize),
                  topRight: Radius.circular(size.height * k30TextSize),
                ),
              ),
              child: SingleChildScrollView(
                child: GetBuilder<ElementButtonViewController>(
                  builder: (controller) {
                    return  SizedBox(
                        height: 1300,
                        child: controller.selectedValue == 1 ? PowerViewPowerAndEnergyElementDetailsScreen(
                          elementName: widget.elementName,
                          gaugeValue: widget.gaugeValue,
                          gaugeUnit: widget.gaugeUnit,
                          elementCategory: widget.elementCategory,
                          generator: 'False',
                          solarCategory: widget.solarCategory,
                        ) : RevenueViewPowerAndEnergyElementDetailsScreen(
                          elementName: widget.elementName,
                          elementCategory:  widget.elementCategory,
                          solarCategory: widget.solarCategory,
                          generator: 'False'
                          ,)
                    );
                  }
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * k40TextSize,
                vertical: size.height * k20TextSize,
              ),
              child: GetBuilder<ElementButtonViewController>(
                  builder: (controller) {
                    return CustomContainer(
                        height: size.height * 0.070,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(size.height * k16TextSize),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomRectangularRadioButton<int>(
                              value: 1,
                              groupValue: controller.selectedValue,
                              onChanged: (value) {
                                controller.updateSelectedValue(value!);
                              },
                              label: 'Utility Dashboard',
                            ),
                            CustomRectangularRadioButton<int>(
                              value: 2,
                              groupValue: controller.selectedValue,
                              onChanged: (value) {
                                controller.updateSelectedValue(value!);
                              },
                              label: widget.solarCategory == 'Solar' ? 'Revenue View' :"Utility Cost",
                            ),
                          ],
                        ));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}




