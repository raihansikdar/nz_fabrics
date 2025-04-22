import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/element_button_view_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_daily_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_monthly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_this_day_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_this_month_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_this_year_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_yearly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/natural_gas/power_view_natural_gas_element_details_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/natural_gas/revenue_view_natural_gas_element_details_screen.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NaturalGasElementDetailsScreen extends StatefulWidget {
  final String elementName;
  final String elementCategory;
  final double gaugeValue;
  final String gaugeUnit;
  const NaturalGasElementDetailsScreen({super.key, required this.elementName, required this.gaugeValue, required this.gaugeUnit, required this.elementCategory});

  @override
  State<NaturalGasElementDetailsScreen> createState() => _NaturalGasElementDetailsScreenState();
}

class _NaturalGasElementDetailsScreenState extends State<NaturalGasElementDetailsScreen> with  TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();

WidgetsBinding.instance.addPostFrameCallback((_){

  Get.find<NaturalGasThisDayDataController>().fetchThisDayData(sourceName: widget.elementName);
  Get.find<NaturalGasThisMonthDataController>().fetchThisMonthData(sourceName: widget.elementName);
  Get.find<NaturalGasThisYearDataController>().fetchThisYearData(sourceName: widget.elementName);

  Get.find<NaturalGasDailyDataController>().fetchDailyData(elementName: widget.elementName);
  Get.find<NaturalGasMonthlyDataController>().fetchNaturalGasMonthlyData(elementName: widget.elementName);
  Get.find<NaturalGasYearlyDataController>().fetchNaturalGasYearlyData(elementName: widget.elementName);

     });

  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async{
      WidgetsBinding.instance.addPostFrameCallback((_){

        Get.find<NaturalGasThisDayDataController>().fetchThisDayData(sourceName: widget.elementName);
        Get.find<NaturalGasThisMonthDataController>().fetchThisMonthData(sourceName: widget.elementName);
      });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar:  CustomAppBarWidget(
          text: widget.elementName,
          backPreviousScreen: true,
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
                            child: controller.selectedValue == 1 ? PowerViewNaturalGasElementDetailsScreen(elementName: widget.elementName, gaugeValue: widget.gaugeValue, gaugeUnit: widget.gaugeUnit, elementCategory: widget.elementCategory,) : RevenueViewNaturalGasElementDetailsScreen(elementName: widget.elementName, elementCategory: widget.elementCategory,));
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
                                label: 'Utility Cost',
                              ),
                            ],
                          ));
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




