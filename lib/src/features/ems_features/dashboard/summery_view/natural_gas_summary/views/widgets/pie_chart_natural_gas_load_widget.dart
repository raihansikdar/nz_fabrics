import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/static_pie_chart.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/natural_gas_summary/controllers/pie_chart_natural_gas_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/natural_gas_summary/model/natural_gas_pie_chart_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/color_palette_widget.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PieChartNaturalGasLoadWidget extends StatefulWidget {
  //final PieChartController _controller = Get.put(PieChartController());

  const PieChartNaturalGasLoadWidget({super.key});

  @override
  State<PieChartNaturalGasLoadWidget> createState() => _PieChartNaturalGasLoadWidgetState();
}

class _PieChartNaturalGasLoadWidgetState extends State<PieChartNaturalGasLoadWidget> {

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
      Get.find<PieChartNaturalGasLoadController>().fetchPieChartData();
    });
    _tooltipBehavior = TooltipBehavior(enable: true, format: 'point.x: point.y Pa');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
      body: GetBuilder<PieChartNaturalGasLoadController>(
        // init: _controller,
        builder: (controller) {

          if (!controller.isConnected) {
            return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Gas',unitText: 'Pa');
          }


          if (controller.isLoading) {
            return Center(child: Lottie.asset(AssetsPath.loadingJson, height: size.height * 0.12));
          }

          if (controller.hasError) {
            return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Gas',unitText: 'Pa');
          }

          if (controller.naturalGasPieChartDataModelList.isEmpty) {
            return   StaticPieChart(size: size, tooltipBehavior: _tooltipBehavior, chartData: noInternetChartData,titleText: 'Total Gas',unitText: 'Pa');
          }


          return  Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                height: size.height * .2,
                child: SfCircularChart(
                  tooltipBehavior: _tooltipBehavior,
                  series: <CircularSeries>[
                    DoughnutSeries<NaturalGasPieChartDataModel, String>(
                      dataSource: controller.naturalGasPieChartDataModelList,
                      xValueMapper: (NaturalGasPieChartDataModel data, _) => data.category,
                      yValueMapper: (NaturalGasPieChartDataModel data, _) => data.value,
                      pointColorMapper: (NaturalGasPieChartDataModel data, int index) =>
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
                      text: 'Total N.Gas \n',
                      style: TextStyle(
                        fontSize: size.height * k14TextSize,
                        color: Colors.grey ,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    TextSpan(
                      text: "${controller.naturalGasPieChartTotalDataList.totalPressure?.toStringAsFixed(2)} Pa",
                      style:  TextStyle(
                        fontSize: size.height * k18TextSize,
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: size.height * k20TextSize,
                  right: size.height * k30TextSize,
                  child: GestureDetector(
                      onTap: (){
                       // Get.to(()=>  AllLiveDataScreen(nodeName: Get.find<AllLiveInfoController>().allLiveInfoList[0].nodeName,),transition: sideTransition,duration: duration);
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset(AssetsPath.listIconSVG),
                          TextComponent(text: "Live Data",color: AppColors.secondaryTextColor,fontSize: size.height * k12TextSize,)
                        ],
                      ))),
            ],
          );
        },
      ),
    );
  }
}



