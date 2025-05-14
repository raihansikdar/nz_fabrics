import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/controllers/custom_water_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/controllers/daily_water_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/controllers/monthly_water_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/controllers/yearly_water_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/views/widgets/custom_water_list_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/views/widgets/daily_water_list_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/views/widgets/monthly_water_generator_list_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/views/widgets/water_data_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/views/widgets/yearly_water_generator_list_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/machine_view_names_data_controller.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class WaterGeneratorScreen extends StatefulWidget {
  const WaterGeneratorScreen({super.key});

  @override
  State<WaterGeneratorScreen> createState() => _WaterGeneratorScreenState();
}

class _WaterGeneratorScreenState extends State<WaterGeneratorScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<DailyWaterButtonController>().fetchDailyWaterData();
      Get.find <MonthlyWaterButtonController>().fetchMonthlyWaterData(selectedMonth: selectedMonth.toString(), selectedYear: selectedYear.toString());
      Get.find <YearlyWaterButtonController>().fetchYearlyWaterData(selectedYearDate: selectedYear);
      Get.find  <CustomWaterButtonController>().fetchCustomWaterData(fromDate:  Get.find  <CustomWaterButtonController>().fromDateTEController.text, toDate:  Get.find  <CustomWaterButtonController>().toDateTEController.text);



      Get.find<CategoryWiseLiveDataController>().stopApiCallOnScreenChange();
      Get.find<MachineViewNamesDataController>().stopApiCallOnScreenChange();


    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar:  CustomAppBarWidget(text: "Water", backPreviousScreen: true,onBackButtonPressed: (){


          Get.find<CategoryWiseLiveDataController>().startApiCallOnScreenChange();
          Get.find<MachineViewNamesDataController>().startApiCallOnScreenChange();

        },),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize),
          child: GetBuilder<DailyWaterButtonController>(
              builder: (dailyWaterButtonController) {
                return Column(
                  children: [
                    SizedBox(height: size.height * k16TextSize,),
                    const WaterDateWidget(),
                    SizedBox(height: size.height * k12TextSize,),
                    dailyWaterButtonController.selectedButton == 1 ?  DailyWaterListWidget(size: size, controller: dailyWaterButtonController,) :
                    dailyWaterButtonController.selectedButton == 2 ? MonthlyWaterListWidget(size: size)  :
                    dailyWaterButtonController.selectedButton == 3 ? YearlyWaterGeneratorListWidget(size: size) :
                    CustomWaterListWidget(size: size)
                  ],
                );
              }
          ),
        )
    );
  }
}