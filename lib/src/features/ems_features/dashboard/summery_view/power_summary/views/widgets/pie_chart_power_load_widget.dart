import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/static_pie_chart.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/pie_chart_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/color_palette_widget.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartPowerLoadWidget extends StatefulWidget {
  const PieChartPowerLoadWidget({super.key});

  @override
  State<PieChartPowerLoadWidget> createState() => _PieChartPowerLoadWidgetState();
}

class _PieChartPowerLoadWidgetState extends State<PieChartPowerLoadWidget> {



  final List<ChartData> noInternetChartData = [
    ChartData('Category A', 100),
  ];


  late TooltipBehavior _tooltipBehavior;


  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x: point.y %', decimalPlaces: 2,);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<PieChartPowerLoadController>(
        // init: _controller,
        builder: (controller) {

          if (!controller.isConnected) {
            return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Power',unitText: 'kW');
          }

          if (controller.isLoading) {
            return Center(child: Lottie.asset(AssetsPath.loadingJson, height: size.height * 0.12));
          }
          if (controller.hasError) {
            return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Power',unitText: 'kW');
          }
          if (controller.pieChartDataList.isEmpty) {
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
              // Display the sum in the center of the doughnut chart
              Padding(
                padding:  EdgeInsets.only(top: size.height * k12TextSize),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style:  TextStyle(
                      fontSize: size.height * k14TextSize,
                      color: Colors.black,
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
      );

  }
}


