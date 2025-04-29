import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_source_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/pie_chart_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/color_palette_widget.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common_widget/static_pie_chart.dart';

class PieChartPowerSourceWidget extends StatefulWidget {

  const PieChartPowerSourceWidget({super.key});

  @override
  State<PieChartPowerSourceWidget> createState() => _PieChartPowerSourceWidgetState();
}

class _PieChartPowerSourceWidgetState extends State<PieChartPowerSourceWidget> {

  final List<ChartData> noInternetChartData = [
    ChartData('Category A', 100),
  ];

  late TooltipBehavior _tooltipBehavior;


  @override
  void initState() {
    super.initState();

    _tooltipBehavior = TooltipBehavior(enable: true,format: 'point.x: point.y %',decimalPlaces: 2,);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        // if (Get.find<SearchDataController>().isSearching) {
        //   Get.find<SearchDataController>().changeSearchStatus(false);
        // }
      },
      child: GetBuilder<PieChartPowerSourceController>(
             // init: _controller,
              builder: (controller) {
                if (controller.pageState == PageState.loading) {
                  return Center(child: SpinKitFadingCircle(
                    color: AppColors.primaryColor,
                    size: 50.0,
                  ),);
                }
                else if (!controller.isConnected) {
                  return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Power',unitText: 'kW');
                }

                else if (controller.pieChartDataList.isEmpty) {
                  return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Power',unitText: 'kW');
                }

                else if (controller.pageState == PageState.error) {
                  return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Power',unitText: 'kW');
                }

                return  Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * .2,
                      child: SfCircularChart(
                        tooltipBehavior: _tooltipBehavior,
                        series: <CircularSeries>[
                          DoughnutSeries<Data, String>(
                            dataSource: controller.pieChartDataList,
                            xValueMapper: (Data data, _) => data.category,
                            yValueMapper: (Data data, _) => data.powerPercentage,
                            pointColorMapper: (Data data, int index) =>
                            colorPalette[index % colorPalette.length],
                            innerRadius: '80%',

                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding:  EdgeInsets.only(top: size.height * k12TextSize),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style:  TextStyle(
                            fontSize: size.height * k14TextSize,
                            color: Colors.black, // or any color you prefer
                          ),
                          children: [
                            TextSpan(
                              text: 'Total Power \n',
                              style: TextStyle(
                                fontSize: size.height * k15TextSize,
                                color:  Colors.grey ,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: "${controller.pieChartDataModel.netTotalPower?.toStringAsFixed(2)} \n",
                              style:  TextStyle(
                                fontSize: size.height * k18TextSize,
                                color: AppColors.primaryTextColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            TextSpan(
                              text: 'kW',
                              style: TextStyle(
                                fontSize: size.height * k14TextSize,
                                color:  Colors.grey ,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              ),

    );
    }
}


