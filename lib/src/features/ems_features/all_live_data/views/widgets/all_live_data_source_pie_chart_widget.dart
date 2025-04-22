
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/all_live_data/controllers/live_data_source_pie_chart_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class AllLiveDataSourcePieChartWidget extends StatefulWidget {

  const AllLiveDataSourcePieChartWidget({super.key});

  @override
  State<AllLiveDataSourcePieChartWidget> createState() => _AllLiveDataSourcePieChartWidgetState();
}

class _AllLiveDataSourcePieChartWidgetState extends State<AllLiveDataSourcePieChartWidget> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:  EdgeInsets.all(size.height * k16TextSize),
        child: GetBuilder<LiveDataSourcePieChartController>(
          builder: (controller) {
            if (controller.isLoading) {
              return Padding(padding: EdgeInsets.only(bottom: size.height * 0.1),
                child: Center(child: Lottie.asset(AssetsPath.loadingJson, height: size.height * 0.12)),
              );

            }

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size.height * k16TextSize),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 9,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: size.height * k50TextSize,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.containerTopColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.height * k16TextSize),
                        topRight: Radius.circular(size.height * k16TextSize),
                      ),
                    ),
                    child: Center(
                      child: TextComponent(text: "Cost of Energy Usage/Prediction",fontSize: size.height *k18TextSize,)
                      /*Text(
                        "Cost of Energy Usage/Prediction",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),*/
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: SfCircularChart(
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CircularSeries>[
                        PieSeries<LiveDataSourcePieChartModel, String>(
                          dataSource: controller.chartData,
                          xValueMapper: (LiveDataSourcePieChartModel data, _) => data.name,
                          yValueMapper: (LiveDataSourcePieChartModel data, _) => data.value,
                         // pointColorMapper: (DataPoint data, _) => data.color,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                          ),
                          dataLabelMapper: (LiveDataSourcePieChartModel data, _) {
                            return '${data.name}\n${data.value.toStringAsFixed(2)}%';
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
class LiveDataSourcePieChartModel {
  final String name;
  final dynamic value;

  LiveDataSourcePieChartModel(this.name, this.value);
}