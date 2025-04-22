import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/controllers/daily_natural_gas_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/controllers/monthly_natural_gas_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/views/widgets/custom_natural_gas_list_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/views/widgets/daily_natural_gas_list_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/views/widgets/monthly_natural_gas_list_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/views/widgets/natural_gas_data_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/views/widgets/yearly_natural_gas_list_widget.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';


class NaturalGasScreen extends StatefulWidget {
  const NaturalGasScreen({super.key});

  @override
  State<NaturalGasScreen> createState() => _NaturalGasScreenState();
}

class _NaturalGasScreenState extends State<NaturalGasScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<DailyNaturalGasButtonController>().fetchDailyNaturalGasData();
      Get.find <MonthlyNaturalGasButtonController>().fetchMonthlyNaturalGasData(selectedMonth: selectedMonth.toString(), selectedYear: selectedYear.toString());
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: const CustomAppBarWidget(text: "Natural Gas Generator", backPreviousScreen: true),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize),
          child: GetBuilder<DailyNaturalGasButtonController>(
              builder: (dailyGasButtonController) {
                return Column(
                  children: [
                    SizedBox(height: size.height * k16TextSize,),
                     const NaturalGasDateWidget(),
                    SizedBox(height: size.height * k12TextSize,),
                    dailyGasButtonController.selectedButton == 1 ?  DailyNaturalGasListWidget(size: size, controller: dailyGasButtonController,) :
                    dailyGasButtonController.selectedButton == 2 ? MonthlyNaturalGasListWidget(size: size)  :
                    dailyGasButtonController.selectedButton == 3 ? YearlyNaturalGasListWidget(size: size) :
                    CustomNaturalGasListWidget(size: size)
                  ],
                );
              }
          ),
        )
    );
  }
}