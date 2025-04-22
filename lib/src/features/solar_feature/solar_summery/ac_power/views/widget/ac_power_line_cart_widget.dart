import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/ac_power/controller/ac_power_today_data_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';

class AcPowerLineChartWidget extends StatelessWidget {
  const AcPowerLineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime _today = DateTime.now();
    return  GetBuilder<AcPowerTodayDataController>(

        builder: (controller) {
          if (controller.isAcPowerDataInProgress) {
            return Center(child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.3),
              child: Lottie.asset(AssetsPath.loadingJson, height: size.height * 0.12),
            ));
          }

          List<ChartData> totalAcPowerData = controller.plantTodayDataList.map((data) {
            return ChartData(data.timedate?.millisecondsSinceEpoch ?? 0, data.totalAcPower ?? 0);
          }).toList();


          return Center(
            child: Column(
              children: [
                Container(
                  height: size.height * 0.48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: SfCartesianChart(
                    // title: ChartTitle(text: 'Plant Data Overview'),
                    legend: const Legend(isVisible: true,position: LegendPosition.top,overflowMode: LegendItemOverflowMode.wrap),trackballBehavior: TrackballBehavior(
                    enable: true,
                    tooltipAlignment: ChartAlignment.near,
                    tooltipDisplayMode:
                    TrackballDisplayMode.groupAllPoints,
                    activationMode: ActivationMode.singleTap,

                  ),
                    primaryXAxis: DateTimeAxis(
                        dateFormat: DateFormat('dd-MMM-yyyy HH:mm:ss'),
                        majorTickLines: const MajorTickLines(width: 5),
                        minorTicksPerInterval: 0,
                        minimum: DateTime(
                            _today.year, _today.month, _today.day, 7, 0, 0),
                        maximum: DateTime(
                            _today.year, _today.month, _today.day, 19, 0, 0),
                        intervalType: DateTimeIntervalType.hours,
                        interval: 2,
                        labelStyle:  TextStyle(fontSize: size.height * k10TextSize),
                        labelFormat: '{value} ',
                        majorGridLines: const MajorGridLines(width: 1),
                       axisLabelFormatter: (axisLabelRenderArgs) {
                        final String text = DateFormat('HH:mm ').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            axisLabelRenderArgs.value.toInt(),
                          ),
                        );
                         TextStyle style = TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold);
                        return ChartAxisLabel(text, style);
                      },
                       ),
                    //primaryYAxis: NumericAxis(title: AxisTitle(text: 'Value')),
                    series: <CartesianSeries>[
                      SplineSeries<ChartData, DateTime>(
                        name: 'Total AC Power (kW)',
                        legendItemText: 'Total AC Power',
                        dataSource: totalAcPowerData,
                        xValueMapper: (ChartData data, _) => /*DateTime.fromMillisecondsSinceEpoch(data.x),*/ DateTime.fromMillisecondsSinceEpoch(data.x).subtract(const Duration(hours: 6)),
                        yValueMapper: (ChartData data, _) => data.y,
                      ),

                    ],
                  ),
                ),
/*                Align(
                  alignment: Alignment.bottomRight,
                  child: GetBuilder<AcPowerTodayDataController>(
                    builder: (acPowerTodayDataController) {
                      return GestureDetector(
                        onTap: (){
                          acPowerTodayDataController.downloadDataSheet();
                        },
                        child: CustomContainer(
                          height: size.height * 0.05,
                          width: size.width * 0.4,
                          borderRadius: BorderRadius.circular(size.height * k12TextSize),
                          child: Padding(
                            padding: EdgeInsets.all(size.height *k8TextSize),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TextComponent(text: "Download",color: AppColors.secondaryTextColor,fontSize: size.height * k18TextSize,),
                                  SvgPicture.asset(AssetsPath.downloadIconSVG,height: size.height * k20TextSize,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                ),*/
              ],
            ),
          );
        },

    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final double y;
}
