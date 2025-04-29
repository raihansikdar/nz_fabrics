
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/static_pie_chart.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/color_palette_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/pie_chart_water_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/model/water_pie_chart_data_model.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartWaterLoadWidget extends StatefulWidget {
  //final PieChartController _controller = Get.put(PieChartController());

  const PieChartWaterLoadWidget({super.key});

  @override
  State<PieChartWaterLoadWidget> createState() => _PieChartWaterLoadWidgetState();
}

class _PieChartWaterLoadWidgetState extends State<PieChartWaterLoadWidget> {

  // final List<ChartData> chartData = [
  //   ChartData('Category A', 40),
  //   ChartData('Category B', 30),
  //   ChartData('Category C', 20),
  //   ChartData('Category D', 10),
  //   ChartData('Category D', 15),
  //   ChartData('Category D', 5),
  // ];

  final List<ChartData> noInternetChartData = [
    ChartData('Category A', 100),
  ];


  late TooltipBehavior _tooltipBehavior;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<PieChartWaterLoadController>().fetchPieChartData();
    });
    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x: point.y m³/s');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<PieChartWaterLoadController>(
        // init: _controller,
        builder: (controller) {

          if (!controller.isConnected) {
            return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Water',unitText: 'L/M',);
          }


          if (controller.isLoading) {
            return Center(child: SpinKitFadingCircle(
              color: AppColors.primaryColor,
              size: 50.0,
            ),);
          }

          if (controller.hasError) {
            return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Water',unitText: 'L/M');
          }

          if (controller.waterPieChartDataModelList.isEmpty) {
            return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Water',unitText: 'L/M');
          }


          return  Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                height: size.height * .2,
                child: SfCircularChart(
                  tooltipBehavior: _tooltipBehavior,
                  series: <CircularSeries>[
                    DoughnutSeries<WaterPieChartDataModel, String>(
                      dataSource: controller.waterPieChartDataModelList,
                      xValueMapper: (WaterPieChartDataModel data, _) => data.category,
                      yValueMapper: (WaterPieChartDataModel data, _) => data.value,
                      pointColorMapper: (WaterPieChartDataModel data, int index) =>
                      colorPalette[index % colorPalette.length],
                      innerRadius: '80%',

                    ),
                  ],
                ),
              ),
              // Display the sum in the center of the doughnut chart
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style:  TextStyle(
                    fontSize: size.height * k14TextSize,
                    color: Colors.black, // or any color you prefer
                  ),
                  children: [
                    TextSpan(
                      text: 'Total Water \n',
                      style: TextStyle(
                        fontSize: size.height * k14TextSize,
                        color: Colors.grey ,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    TextSpan(
                      text: "${controller.waterPieChartTotalDataList.total?.toStringAsFixed(2)}\n",
                      style:  TextStyle(
                        fontSize: size.height * k18TextSize,
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'L/M',
                      style: TextStyle(
                        fontSize: size.height * k14TextSize,
                        color:  Colors.grey ,
                        fontWeight: FontWeight.w500,
                      ),
                    ),


                  ],
                ),
              ),
            ],
          );
        },
      );

  }
}



