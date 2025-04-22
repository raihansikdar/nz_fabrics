

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/controllers/daily_gas_generator_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/controllers/monthly_gas_generator_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/views/widgets/custom_gas_generator_list_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/views/widgets/daily_gas_generator_list_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/views/widgets/gas_generator_data_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/views/widgets/monthly_gas_generator_list_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/views/widgets/yearly_gas_generator_list_widget.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class GasGeneratorButtonScreen extends StatefulWidget {
  const GasGeneratorButtonScreen({super.key});

  @override
  State<GasGeneratorButtonScreen> createState() => _NaturalGasScreenState();
}

class _NaturalGasScreenState extends State<GasGeneratorButtonScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<DailyGasGeneratorButtonController>().fetchDailyGasGeneratorData();
      Get.find <MonthlyGasGeneratorButtonController>().fetchMonthlyGasGeneratorData(selectedMonth: selectedMonth.toString(), selectedYear: selectedYear.toString());
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: const CustomAppBarWidget(text: "Gas Generator", backPreviousScreen: true),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize),
          child: GetBuilder<DailyGasGeneratorButtonController>(
              builder: (dailyGasButtonController) {
                return Column(
                  children: [
                    SizedBox(height: size.height * k16TextSize,),
                    const GasGeneratorDateWidget(),
                    SizedBox(height: size.height * k12TextSize,),
                    dailyGasButtonController.selectedButton == 1 ?  DailyGasGeneratorListWidget(size: size, controller: dailyGasButtonController,) :
                    dailyGasButtonController.selectedButton == 2 ? MonthlyGasGeneratorListWidget(size: size)  :
                    dailyGasButtonController.selectedButton == 3 ? YearlyGasGeneratorListWidget(size: size) :
                    CustomGasGeneratorListWidget(size: size)
                  ],
                );
              }
          ),
        )
    );
  }
}