
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/static_pie_chart.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/color_palette_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/water_load_category_wise_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/model/water_load_category_wise_live_data_model.dart';
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



  final List<ChartData> noInternetChartData = [
    ChartData('Category A', 100),
  ];


  late TooltipBehavior _tooltipBehavior;


  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Get.find<PieChartWaterLoadController>().fetchWaterCategoryWiseLiveData();
    // });
    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x: point.y m³/h');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<WaterLoadCategoryWiseDataController>(
        // init: _controller,
        builder: (controller) {

          if (!controller.isConnected) {
            return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Water',unitText: ' m³/h',);
          }


          if (controller.isLoading) {
            return Center(child: SpinKitFadingCircle(
              color: AppColors.primaryColor,
              size: 50.0,
            ),);
          }

          if (controller.hasError) {
            return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Water',unitText: ' m³/h');
          }

          if ((controller.waterLoadCategoryWiseLiveData.data ?? []).isEmpty) {
            return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Water',unitText: 'm³/h');
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
                      yValueMapper: (Data data, _) => data.totalInstantFlow,
                      pointColorMapper: (Data data, int index) =>
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
                      text: "${controller.waterLoadCategoryWiseLiveData.netTotalInstantFlow?.toStringAsFixed(2)}\n",
                      style:  TextStyle(
                        fontSize: size.height * k18TextSize,
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'm³/h',
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



