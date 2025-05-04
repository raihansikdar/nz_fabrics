import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_box_shadow_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/source/water_source/controller/over_all_source_water_data_controller.dart' show OverAllWaterSourceDataController;
import 'package:nz_fabrics/src/features/source/water_source/controller/water_source_category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/source/water_source/views/widgets/over_all_Water_line_chart_data.dart';
import 'package:nz_fabrics/src/features/source/water_source/views/widgets/over_all_yearly_water_bar_chart_widget.dart';
import 'package:nz_fabrics/src/features/source/water_source/views/widgets/sub_part/line_water_chart_widget.dart';
import 'package:nz_fabrics/src/features/source/water_source/views/widgets/sub_part/monthly_water_chart_widget.dart';
import 'package:nz_fabrics/src/features/source/water_source/views/widgets/sub_part/water_live_data_container_widget.dart' show WaterLiveDataContainerWidget;
import 'package:nz_fabrics/src/features/source/water_source/views/widgets/water_over_all_monthly_bar_chart_widget.dart';
import 'package:nz_fabrics/src/features/source/water_source/views/widgets/water_source_category_wise_pie_chart.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import '../../model/source_category_wise_live_data_model.dart';
import '../widgets/sub_part/water_source_table_widget.dart';
import '../widgets/sub_part/yearly_water_chart_widget.dart' show YearlyEnergyChartWidget;
import '../widgets/water_over_all_date_widget.dart' show OverAllDateWidget;
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:intl/intl.dart';

class WaterSourceScreen extends StatefulWidget {
  const WaterSourceScreen({super.key});

  @override
  State<WaterSourceScreen> createState() => _WaterSourceScreenState();
}

class _WaterSourceScreenState extends State<WaterSourceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure all controllers are registered
      if (!Get.isRegistered<AuthUtilityController>()) {
        Get.put(AuthUtilityController());
      }
      if (!Get.isRegistered<OverAllWaterSourceDataController>()) {
        Get.put(OverAllWaterSourceDataController());
      }
      if (!Get.isRegistered<WaterSourceCategoryWiseLiveDataController>()) {
        Get.put(WaterSourceCategoryWiseLiveDataController());
      }

      // Fetch data only if token is available
      if (AuthUtilityController.accessToken != null && AuthUtilityController.accessToken!.isNotEmpty) {
        final controller = Get.find<OverAllWaterSourceDataController>();
        Get.find<WaterSourceCategoryWiseLiveDataController>().fetchSourceCategoryWiseData();
        controller.fetchOverAllSourceData(
          fromDate: controller.fromDateTEController.text.isEmpty
              ? DateFormat('dd-MM-yyyy').format(DateTime.now().subtract(Duration(days: 30)))
              : controller.fromDateTEController.text,
          toDate: controller.toDateTEController.text.isEmpty
              ? DateFormat('dd-MM-yyyy').format(DateTime.now())
              : controller.toDateTEController.text,
        );
      } else {
        // Show a snackbar or handle missing token
        Get.snackbar(
          "Authentication Error",
          "Please log in to access data",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.redColor,
          colorText: Colors.white,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: CustomAppBarWidget(
        text: "Source",
        backPreviousScreen: true,
        onBackButtonPressed: () {
          Future.delayed(const Duration(milliseconds: 1500)).then((_) {
            Get.find<OverAllWaterSourceDataController>().selectButtonValue = 1;
            Get.find<OverAllWaterSourceDataController>().clearFilterIngDate();
          });
        },
      ),
      body: SingleChildScrollView(
        child: GetBuilder<OverAllWaterSourceDataController>(
          builder: (controller) {
            return Padding(
              padding: EdgeInsets.all(size.height * k8TextSize),
              child: Column(
                children: [
                  const OverAllDateWidget(),
                  SizedBox(height: size.height * k12TextSize),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomRectangularRadioButton<int>(
                        value: 1,
                        groupValue: controller.selectButtonValue,
                        onChanged: (value) {
                          controller.updateSelectedValue(value!);
                        },
                        label: 'Table View',
                      ),
                      CustomRectangularRadioButton<int>(
                        value: 2,
                        groupValue: controller.selectButtonValue,
                        onChanged: (value) {
                          controller.updateSelectedValue(value!);
                        },
                        label: "Chart View",
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * k12TextSize),
                  controller.selectButtonValue == 1
                      ? CustomBoxShadowContainer(
                    size: size,
                    height: size.width > 550 ? size.height / 1.38 : size.height / 1.42,
                    child: WaterSourceTableWidget(),
                  )
                      : Column(
                    children: [
                      GetBuilder<OverAllWaterSourceDataController>(
                        builder: (controller) {
                          return Container(
                            height: size.height * 0.52,
                            decoration: BoxDecoration(
                              color: AppColors.whiteTextColor,
                              border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
                              borderRadius: BorderRadius.circular(size.height * k16TextSize),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: controller.graphType == "Line-Chart"
                                ? OverAllLineWaterChartDataWidget(lineChartModel: controller.lineChartModel)
                                : controller.graphType == "Monthly-Bar-Chart"
                                ? WaterOverAllMonthlyBarChartWidget(
                              barChartModel: controller.monthlyBarchartModel,
                              controller: controller,
                            )
                                : OverAllWaterYearlyBarChartWidget(
                              barChartModel: controller.yearlyBarChartModel,
                              controller: controller,
                            ),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            controller.downloadDataSheet(context);
                          },
                          child: CustomContainer(
                            height: size.height * 0.050,
                            width: size.width * 0.3,
                            borderRadius: BorderRadius.circular(size.height * k8TextSize),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TextComponent(text: "Download"),
                                  Icon(Icons.download),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * k12TextSize),
                      GetBuilder<OverAllWaterSourceDataController>(
                        builder: (controller) {
                          return Container(
                            height: size.height * 0.57,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.whiteTextColor,
                              border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
                              borderRadius: BorderRadius.circular(size.height * k16TextSize),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: size.height * 0.04,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(size.height * k16TextSize),
                                      topRight: Radius.circular(size.height * k16TextSize),
                                    ),
                                  ),
                                  child: Center(
                                    child: TextComponent(
                                      text: "Energy Chart",
                                      color: AppColors.whiteTextColor,
                                      fontSize: size.height * k18TextSize,
                                    ),
                                  ),
                                ),
                                controller.graphType == "Line-Chart"
                                    ? LineWaterChartWidget(size: size)
                                    : controller.graphType == "Monthly-Bar-Chart"
                                    ? MonthlyWaterChartWidget(size: size)
                                    : YearlyEnergyChartWidget(size: size),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: size.height * k12TextSize),
                      Container(
                        height: size.height * 0.565,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.whiteTextColor,
                          border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
                          borderRadius: BorderRadius.circular(size.height * k16TextSize),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: size.height * 0.04,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(size.height * k16TextSize),
                                  topRight: Radius.circular(size.height * k16TextSize),
                                ),
                              ),
                              child: Center(
                                child: TextComponent(
                                  text: "Live Data Chart",
                                  color: AppColors.whiteTextColor,
                                  fontSize: size.height * k18TextSize,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.27,
                              child: WaterSourceCategoryWisePieChart(size: size),
                            ),
                            SizedBox(height: size.height * k10TextSize),
                            GetBuilder<WaterSourceCategoryWiseLiveDataController>(
                              builder: (controller) {
                                final subMersibleData = controller.sourceCategoryWiseLiveDataModel.data?.firstWhere(
                                      (item) => item.category == 'Sub_Mersible',
                                  orElse: () => SourceCategoryWiseLiveDataModel(
                                    category: 'Sub_Mersible',
                                    totalInstantFlow: 0,
                                    instantFlowPercentage: 0,
                                  ),
                                );
                                final wtpData = controller.sourceCategoryWiseLiveDataModel.data?.firstWhere(
                                      (item) => item.category == 'WTP',
                                  orElse: () => SourceCategoryWiseLiveDataModel(
                                    category: 'WTP',
                                    totalInstantFlow: 0,
                                    instantFlowPercentage: 0,
                                  ),
                                );
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: size.height * k12TextSize),
                                  child: Column(
                                    children: [
                                      WaterLiveDataContainerWidget(
                                        size: size,
                                        title: "Total",
                                        color: Colors.deepPurple,
                                        text: "${controller.sourceCategoryWiseLiveDataModel.netTotalInstantFlow?.toStringAsFixed(2) ?? '0.00'} m³",
                                      ),
                                      SizedBox(height: size.height * k8TextSize),
                                      WaterLiveDataContainerWidget(
                                        size: size,
                                        title: "Sub_Mersible",
                                        color: Color.lerp(const Color(0xFF66D6FF), const Color(0xFF4FA3CC), 0.5)!,
                                        text: "${subMersibleData?.totalInstantFlow?.toStringAsFixed(2) ?? '0.00'} m³ (${subMersibleData?.instantFlowPercentage?.toStringAsFixed(2) ?? '0.00'}%)",
                                      ),
                                      SizedBox(height: size.height * k8TextSize),
                                      WaterLiveDataContainerWidget(
                                        size: size,
                                        title: "WTP",
                                        color: Color.lerp(const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!,
                                        text: "${wtpData?.totalInstantFlow?.toStringAsFixed(2) ?? '0.00'} m³ (${wtpData?.instantFlowPercentage?.toStringAsFixed(2) ?? '0.00'}%)",
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * k10TextSize),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}