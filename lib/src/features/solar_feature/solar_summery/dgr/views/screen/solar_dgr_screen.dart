// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/controllers/dgr_controller.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/views/widget/dgr_date_widget.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/views/widget/dgr_line_chart_widget.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/views/widget/dgr_monthly_bar_chart.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/views/widget/dgr_yearly_bar_chart_widget.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/views/widget/table/daily_line_chart_table_widget.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/views/widget/table/monthly_bar_chart_table_widget.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/views/widget/table/yearly_bar_chart_table_widget.dart';
// import 'package:nz_ums/src/utility/assets_path/assets_path.dart';
// import 'package:nz_ums/src/utility/style/app_colors.dart';
// import 'package:nz_ums/src/utility/style/constant.dart';
//
//
// class SolarDgrScreen extends StatefulWidget {
//   const SolarDgrScreen({super.key});
//
//   @override
//   State<SolarDgrScreen> createState() => _SolarDgrScreenState();
// }
//
// class _SolarDgrScreenState extends State<SolarDgrScreen> {
//
//   @override
//   void initState() {
//     Get.find<DgrController>().fetchDgrData( fromDate: Get.find<DgrController>().fromDateTEController.text, toDate: Get.find<DgrController>().toDateTEController.text);
//     super.initState();
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: SingleChildScrollView(
//         child: GetBuilder<DgrController>(
//           builder: (dgrController) {
//             if(dgrController.isDgrPantProgress){
//               return Center(child: Padding(
//                 padding:  EdgeInsets.only(top: size.height * 0.35),
//                 child: Lottie.asset(AssetsPath.loadingJson, height: size.height * 0.12),
//               ));
//             }
//             return Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(size.height * k8TextSize),
//                   child: const DGRDateWidget(),
//                 ),
//                 SizedBox(
//                     height: size.height * 0.5,
//
//                     child: dgrController.graphType == 'Monthly-Bar-Chart' ?
//                     DgrMonthlyBarChart(monthlyBarChartModel: dgrController.monthlyBarchartModel,)
//                     : dgrController.graphType == 'Yearly-Bar-Chart' ? DgrYearlyBarChartWidget(yearlyBarChartModel: dgrController.yearlyBarChartModel,)
//                    : DgrLineChart(lineChartModel: dgrController.lineChartModel,)
//
//                 ),
//
//
//                 SizedBox(
//                     height: size.height * 0.6,
//
//                     child: dgrController.graphType == 'Monthly-Bar-Chart' ?
//                     DgrMonthlyBarChartTableWidget(monthlyBarChartModel: dgrController.monthlyBarchartModel,)
//                         : dgrController.graphType == 'Yearly-Bar-Chart' ? DgrYearlyBarChartTableWidget(yearlyBarChartModel: dgrController.yearlyBarChartModel,)
//                         : DgrLineChartTableWidget(lineChartModel: dgrController.lineChartModel,)
//
//                 ),
//               ],
//             );
//           }
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/controllers/dgr_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/views/widget/dgr_date_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/views/widget/dgr_line_chart_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/views/widget/dgr_monthly_bar_chart.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/views/widget/dgr_yearly_bar_chart_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/views/widget/table/daily_line_chart_table_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/views/widget/table/monthly_bar_chart_table_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/views/widget/table/yearly_bar_chart_table_widget.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class SolarDgrScreen extends StatefulWidget {
  const SolarDgrScreen({super.key});

  @override
  State<SolarDgrScreen> createState() => _SolarDgrScreenState();
}

class _SolarDgrScreenState extends State<SolarDgrScreen> {
  @override
  void initState() {
    Get.find<DgrController>().fetchDgrData(
      fromDate: Get.find<DgrController>().fromDateTEController.text,
      toDate: Get.find<DgrController>().toDateTEController.text,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
            child: GetBuilder<DgrController>(
              builder: (dgrController) {
                if (dgrController.isDgrPantProgress) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: size.height * 0.35),
                      child: Lottie.asset(
                        AssetsPath.loadingJson,
                        height: size.height * 0.12,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize,top: size.height * k8TextSize,bottom: size.height * k8TextSize),
                      child: const DGRDateWidget(),
                    ),
                    SizedBox(
                      height: size.height * 0.61,
                      child: dgrController.graphType == 'Monthly-Bar-Chart'
                          ? DgrMonthlyBarChart(
                        monthlyBarChartModel: dgrController.monthlyBarchartModel,
                      )
                          : dgrController.graphType == 'Yearly-Bar-Chart'
                          ? DgrYearlyBarChartWidget(
                        yearlyBarChartModel: dgrController.yearlyBarChartModel,
                      )
                          : DgrLineChart(
                        lineChartModel: dgrController.lineChartModel,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          dgrController.downloadDataSheet(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
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
                    ),
                    const SizedBox(height: 8,),
                    SizedBox(
                      height: size.height * 0.6,
                      child: dgrController.graphType == 'Monthly-Bar-Chart'
                          ? DgrMonthlyBarChartTableWidget(
                        monthlyBarChartModel: dgrController.monthlyBarchartModel,
                      )
                          : dgrController.graphType == 'Yearly-Bar-Chart'
                          ? DgrYearlyBarChartTableWidget(
                        yearlyBarChartModel: dgrController.yearlyBarChartModel,
                      )
                          : DgrLineChartTableWidget(
                        lineChartModel: dgrController.lineChartModel,
                      ),
                    ),

                  ],
                );
              },
            ),
            ),
       );
    }
}