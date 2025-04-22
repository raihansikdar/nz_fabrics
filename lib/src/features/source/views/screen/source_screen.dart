import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_box_shadow_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/source/controller/over_all_source_data_controller.dart';
import 'package:nz_fabrics/src/features/source/controller/source_category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/source/model/source_category_wise_live_data_model.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/over_all_line_chart_data.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/over_all_date_widget.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/over_all_monthly_bar_chart_widget.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/over_all_yearly_bar_chart_widget.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/source_category_wise_pie_chart.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/sub_part/line_energy_chart_widget.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/sub_part/live_data_container_widget.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/sub_part/monthly_energy_chart_widget.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/sub_part/source_table_widget.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/sub_part/yearly_energy_chart_widget.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class SourceScreen extends StatefulWidget {
  const SourceScreen({super.key});

  @override
  State<SourceScreen> createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
   //   Get.find<TimeUsagePercentageController>().fetchTimeUsagesPercentageData();
      Get.find<SourceCategoryWiseLiveDataController>().fetchSourceCategoryWiseData();
      Get.find<OverAllSourceDataController>().fetchOverAllSourceData( fromDate: Get.find<OverAllSourceDataController>().fromDateTEController.text, toDate: Get.find<OverAllSourceDataController>().toDateTEController.text);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return  Scaffold(
      appBar: CustomAppBarWidget(text: "Source", backPreviousScreen: true,
      onBackButtonPressed: (){
        Future.delayed(const Duration(milliseconds:1500 )).then((_){
          Get.find<OverAllSourceDataController>().selectButtonValue = 1;
          Get.find<OverAllSourceDataController>().clearFilterIngDate();
        });
      },
      ),
      body: SingleChildScrollView(
        child: GetBuilder<OverAllSourceDataController>(
          builder: (controller) {
            return Padding(
              padding:  EdgeInsets.all(size.height * k8TextSize),
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
                  controller.selectButtonValue == 1 ?  CustomBoxShadowContainer(
                      size: size,
                      //height: size.width > 550  ? size.height * .7 : size.height * .6,
                      height:size.width > 550  ? size.height/1.38 :  size.height/1.42,
                      child: SourceTableWidget()) :   Column(
                 children: [
                   GetBuilder<OverAllSourceDataController>(
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
                                 ]
                             ),
                             child: controller.graphType == "Line-Chart" ? OverAllLineChartDataWidget(
                                 lineChartModel:controller.lineChartModel
                             ) :  controller.graphType == "Monthly-Bar-Chart" ? OverAllMonthlyBarChartWidget(
                               barChartModel: controller.monthlyBarchartModel,
                               controller: controller,
                             ) :OverAllYearlyBarChartWidget(
                               barChartModel: controller.yearlyBarChartModel,
                             )
                         );
                       }
                   ),
                   Align(
                     alignment: Alignment.centerRight,
                     child: GestureDetector(
                       onTap: (){
                         controller.downloadDataSheet(context);
                       },
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
                   SizedBox(height: size.height * k12TextSize),
                   GetBuilder<OverAllSourceDataController>(
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
                               ]
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
                                     topRight:  Radius.circular(size.height * k16TextSize),
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
                               controller.graphType == "Line-Chart" ?
                               LineEnergyChartWidget(size: size) : controller.graphType == "Monthly-Bar-Chart" ? MonthlyEnergyChartWidget(size: size) : YearlyEnergyChartWidget(size: size)
                             ],
                           ),
                         );
                       }
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
                         ]
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
                               topRight:  Radius.circular(size.height * k16TextSize),
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
                           child: SourceCategoryWisePieChart(size: size),
                         ),
                         SizedBox(height: size.height * k10TextSize,),
                         GetBuilder<SourceCategoryWiseLiveDataController>(
                           builder: (controller) {
                             final dieselGeneratorData = controller.sourceCategoryWiseLiveDataModel.data?.firstWhere(
                                   (item) => item.category == 'Diesel Generator',
                               orElse: () => SourceCategoryWiseLiveDataModel(totalPower: 0, powerPercentage: 0),
                             );
                             final gridData = controller.sourceCategoryWiseLiveDataModel.data?.firstWhere(
                                   (item) => item.category == 'Grid',
                               orElse: () => SourceCategoryWiseLiveDataModel(totalPower: 0, powerPercentage: 0),
                             );
                             final solarData = controller.sourceCategoryWiseLiveDataModel.data?.firstWhere(
                                   (item) => item.category == 'Solar',
                               orElse: () => SourceCategoryWiseLiveDataModel(totalPower: 0, powerPercentage: 0),
                             );

                             return Padding(
                               padding:  EdgeInsets.symmetric(horizontal: size.height * k12TextSize),
                               child: Column(
                                 children: [
                                   LiveDataContainerWidget(
                                       size: size,
                                       title: "Total",
                                       color: Colors.deepPurple,
                                       text: "${controller.sourceCategoryWiseLiveDataModel.netTotalPower?.toStringAsFixed(2) ?? '0.00'} kW"
                                   ),
                                   SizedBox(height: size.height *k8TextSize ,),
                                   LiveDataContainerWidget(
                                       size: size,
                                       title: "Grid",
                                       color:  Color.lerp(const Color(0xFF66D6FF), const Color(0xFF4FA3CC),0.5)!,
                                       text: "${gridData?.totalPower?.toStringAsFixed(2) ?? '0.00'} kW (${gridData?.powerPercentage?.toStringAsFixed(2) ?? '0.00'}%)"
                                   ),

                                   SizedBox(height: size.height *k8TextSize ,),
                                   LiveDataContainerWidget(
                                     size: size,
                                     title: "Solar",
                                     color:  Color.lerp(const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!,
                                     text: "${solarData?.totalPower?.toStringAsFixed(2) ?? '0.00'} kW (${solarData?.powerPercentage?.toStringAsFixed(2) ?? '0.00'}%)",
                                   ),
                                   SizedBox(height: size.height *k8TextSize ,),
                                   LiveDataContainerWidget(
                                     size: size,
                                     color:  Color.lerp(const Color(0xFFFFA500), const Color(0xFFFF7F00), 0.5)!,
                                     title: "DG",
                                     text: "${dieselGeneratorData?.totalPower?.toStringAsFixed(2) ?? '0.00'} kW (${dieselGeneratorData?.powerPercentage?.toStringAsFixed(2) ?? '0.00'}%)",
                                   ),
                                 ],
                               ),
                             );

                           },
                         )

                       ],
                     ),
                   ),
                 ],
               ) ,
                   SizedBox(height: size.height * k10TextSize,)
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}




