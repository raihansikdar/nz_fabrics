import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/all_live_data/controllers/live_data_load_pie_chart_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class AllLiveDataLoadPieChartWidget extends StatefulWidget {

  const AllLiveDataLoadPieChartWidget({super.key});

  @override
  State<AllLiveDataLoadPieChartWidget> createState() => _AllLiveDataLoadPieChartWidgetState();
}

class _AllLiveDataLoadPieChartWidgetState extends State<AllLiveDataLoadPieChartWidget> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(size.height * k16TextSize),
        child: GetBuilder<LiveDataLoadPieChartController>(
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
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:AppColors.containerTopColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.height * k16TextSize),
                        topRight: Radius.circular(size.height * k16TextSize),
                      ),
                    ),
                    child:  Center(
                      child: TextComponent(text: "Cost of Energy Usage/Prediction",fontSize: size.height *k18TextSize,)

              ),
                  ),
                  SizedBox(
                    height: 250,
                    child: SfCircularChart(
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CircularSeries>[
                        PieSeries<LiveDataPieChartModel, String>(
                          dataSource: controller.chartData,
                          xValueMapper: (LiveDataPieChartModel data, _) => data.name,
                          yValueMapper: (LiveDataPieChartModel data, _) => data.value,
                         // pointColorMapper: (DataPoint data, _) => data.color,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                          ),
                          dataLabelMapper: (LiveDataPieChartModel data, _) {
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
class LiveDataPieChartModel {
  final String name;
  final dynamic value;

  LiveDataPieChartModel(this.name, this.value);
}