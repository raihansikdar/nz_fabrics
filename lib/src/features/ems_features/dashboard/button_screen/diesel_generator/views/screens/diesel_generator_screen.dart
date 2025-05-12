import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/controllers/daily_diesel_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/controllers/monthly_diesel_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/views/widgets/custom_diesel_generator_list_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/views/widgets/daily_diesel_generator_list_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/views/widgets/diesel_date_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/views/widgets/monthly_diesel_generator_list_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/views/widgets/yearly_diesel_generator_list_widget.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DieselGeneratorScreen extends StatefulWidget {
  const DieselGeneratorScreen({super.key});

  @override
  State<DieselGeneratorScreen> createState() => _DieselGeneratorScreenState();
}

class _DieselGeneratorScreenState extends State<DieselGeneratorScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<DailyDieselButtonController>().fetchDailyDieselData();
      Get.find <MonthlyDieselButtonController>().fetchMonthlyDieselData(selectedMonth: selectedMonth.toString(), selectedYear: selectedYear.toString());
    });
    super.initState();
  }


  MonthlyDieselButtonController monthlyDieselButtonController = Get.put(MonthlyDieselButtonController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
        appBar: const CustomAppBarWidget(text: "Diesel Generator", backPreviousScreen: true),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize),
          child: GetBuilder<DailyDieselButtonController>(
            builder: (dailyDieselButtonController) {
              return Column(
                children: [
                  SizedBox(height: size.height * k16TextSize,),
               //   const DieselDateWidget(),
                  SizedBox(height: size.height * k12TextSize,),
                  dailyDieselButtonController.selectedButton == 1 ?  DailyDieselGeneratorListWidget(size: size, controller: dailyDieselButtonController,) :
                  dailyDieselButtonController.selectedButton == 2 ? MonthlyDieselGeneratorListWidget (size: size)  :
                  dailyDieselButtonController.selectedButton == 3 ? YearlyDieselGeneratorListWidget(size: size) :
                  CustomDieselGeneratorListWidget(size: size)
                ],
              );
            }
          ),
        )
    );
  }
}


