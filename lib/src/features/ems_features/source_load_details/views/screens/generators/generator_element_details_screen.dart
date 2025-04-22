import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/element_button_view_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/daily_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/monthly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/this_day_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/this_month_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/this_year_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/today_runtime_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/yearly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/power_view_power_and_energy_element_details_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/revenue_view_power_and_energy_element_details_screen.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GeneratorElementDetailsScreen extends StatefulWidget {
  final String elementName;
  final String elementCategory;
  final double gaugeValue;
  final String gaugeUnit;
  const GeneratorElementDetailsScreen({super.key, required this.elementName, required this.gaugeValue, required this.gaugeUnit, required this.elementCategory});

  @override
  State<GeneratorElementDetailsScreen> createState() => _GeneratorElementDetailsScreenState();
}

class _GeneratorElementDetailsScreenState extends State<GeneratorElementDetailsScreen> with  TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();


    Get.find<TodayRuntimeDataController>().fetchTodayRuntimeData(sourceName: widget.elementName);
    Get.find<ThisDayDataController>().fetchThisDayData(sourceName: widget.elementName);
    Get.find<ThisMonthDataController>().fetchThisMonthData(sourceName: widget.elementName);
    Get.find<ThisYearDataController>().fetchThisYearData(sourceName: widget.elementName);

    Get.find<DailyDataController>().fetchDailyData(elementName: widget.elementName);
    Get.find<MonthlyDataController>().fetchMonthlyData(elementName: widget.elementName);
    Get.find<YearlyDataController>().fetchYearlyData(elementName: widget.elementName);

  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar:  CustomAppBarWidget(
        text: widget.elementName,
        backPreviousScreen: true,
      ),
      body: Stack(
        children: [
         /* Positioned(
            top:  size.height * 0.005,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * k40TextSize,
                vertical: size.height * k20TextSize,
              ),
              child: GetBuilder<GeneratorDataController>(
                  builder: (generatorDataController) {
                    return CustomContainer(
                        height: size.height * 0.160,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(size.height * k16TextSize),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: (){
                                      generatorDataController.updateSelectedButton(value: 1);
                                    },
                                    child: Container(
                                      height: size.height * 0.050,
                                       decoration: BoxDecoration(
                                         color: generatorDataController.selectedButton == 1 ?  const Color(0xFF2d98ed) : Colors.transparent,
                                         borderRadius: BorderRadius.only(topLeft: Radius.circular(size.height * k15TextSize))
                                       ),
                                      child: Center(child: TextComponent(text: "This Day",color: generatorDataController.selectedButton == 1 ?  AppColors.whiteTextColor : AppColors.secondaryTextColor)),),
                                  ),
                                ),
                                Expanded(child: GestureDetector(
                                  onTap: (){
                                    generatorDataController.updateSelectedButton(value: 2);
                                  },
                                  child: Container(
                                    height: size.height * 0.050,
                                    decoration:  BoxDecoration(
                                        color:  generatorDataController.selectedButton == 2 ? const Color(0xFFe99d2d) :  Colors.transparent,

                                    ),
                                    child: Center(child: TextComponent(text: "This Month",color: generatorDataController.selectedButton == 2 ?  AppColors.whiteTextColor : AppColors.secondaryTextColor)),),
                                )),
                                Expanded(child: GestureDetector(
                                  onTap: (){
                                    generatorDataController.updateSelectedButton(value: 3);
                                  },
                                  child: Container(
                                    height: size.height * 0.050,
                                    decoration: BoxDecoration(
                                        color:  generatorDataController.selectedButton == 3 ? const Color(0xFF13a6a6) :  Colors.transparent,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(size.height * k15TextSize))
                                    ),

                                    child: Center(child: TextComponent(text: "This Year",color: generatorDataController.selectedButton == 3 ?  AppColors.whiteTextColor : AppColors.secondaryTextColor)),
                                  ),
                                )),
                              ],
                            ),
                             const Divider(height: 0,color: AppColors.containerBorderColor,thickness: 0.5,),
                            Container(
                                height: size.width > 800 ? size.height * 0.104 :   size.height * 0.1075, width: double.infinity,
                              decoration: BoxDecoration(
                                color: generatorDataController.selectedButton == 2 ? const Color(0xFFfdf6ea) : const Color(0xFFe8f7f7),
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(size.height * k14TextSize),bottomRight: Radius.circular(size.height * k14TextSize),),

                              ),
                               child: Padding(
                                 padding:  EdgeInsets.all(size.height * k20TextSize),
                                 child: Center(
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     children: [
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           TextComponent(text: "Fuel Consumption",fontSize: size.height * k18TextSize,color: AppColors.secondaryTextColor,fontFamily: regularFontFamily,),
                                           SizedBox(height: size.height * 0.004,),
                                           Container(height: 1,width: size.width * 0.341 ,color: AppColors.secondaryTextColor,),
                                           SizedBox(height: size.height * 0.004,),
                                           TextComponent(text: "Runtime",fontSize: size.height * k18TextSize,color: AppColors.secondaryTextColor,fontFamily: regularFontFamily,),
                                         ],
                                       ),
                                       // SizedBox(width: size.width * 0.100,),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Padding(
                                             padding: EdgeInsets.only(left:  size.width * 0.100),
                                             child: TextComponent(text: ":",fontSize: size.height * k18TextSize,color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,),
                                           ),
                                           SizedBox(height: size.height * 0.004,),
                                           Container(height: 1,width:  size.width * 0.200 ,color: AppColors.secondaryTextColor,),
                                           SizedBox(height: size.height * 0.004,),
                                           Padding(
                                             padding: EdgeInsets.only(left:  size.width * 0.100),
                                             child: TextComponent(text: ":",fontSize: size.height * k18TextSize,color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,),
                                           ),
                                         ],
                                       ),
                                      // SizedBox(width: size.width * 0.100,),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           TextComponent(text: "0.0",fontSize: size.height * k18TextSize,color: AppColors.primaryTextColor,fontFamily: mediumFontFamily,),
                                           SizedBox(height: size.height * 0.004,),
                                           Container(height: 1,width:  size.width * 0.260 ,color: AppColors.secondaryTextColor,),
                                           SizedBox(height: size.height * 0.004,),
                                            GetBuilder<TodayRuntimeDataController>(
                                             builder: (controller) {
                                               String data = controller.todayRunTimeData.runtimeToday ?? '' ;
                                               List<String> runtimeParts = data.split(":");
                                               String formattedRuntime;
                                               if (runtimeParts.length == 2) {
                                                 formattedRuntime = "${runtimeParts[0]} hrs. ${runtimeParts[1]} min";
                                               } else {
                                                 formattedRuntime = " ";
                                               }
                                               return TextComponent(text: formattedRuntime,fontSize: size.height * k18TextSize,color: AppColors.primaryTextColor,fontFamily: mediumFontFamily,);
                                             }
                                           ),
                                         ],
                                       ),
                                     ],
                                   ),
                                 ),
                               )
                            )
                          ],
                        )
                    );
                  }),
            ),
          ),*/
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
                            solarCategory: "NO Solar",
                            generator: 'True',) : RevenueViewPowerAndEnergyElementDetailsScreen(elementName: widget.elementName, elementCategory:  widget.elementCategory, solarCategory: 'generator', generator: 'True',));
                    }
                ),
              ),
            ),
          ),
          Positioned(
            top:  0,
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
                              label: 'Utility Cost',
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




