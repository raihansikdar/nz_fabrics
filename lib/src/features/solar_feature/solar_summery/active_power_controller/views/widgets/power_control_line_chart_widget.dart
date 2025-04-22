  import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/empty_page_widget/empty_page_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/active_power_controller/controller/plant_today_data_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';

class PowerControlLineChartWidget extends StatelessWidget {
  const PowerControlLineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime today = DateTime.now();
    return GetBuilder<PlantTodayDataController>(
        init: PlantTodayDataController(),
        builder: (controller) {
          if (controller.isAssortedDataInProgress) {
            return Center(child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.3),
              child: Lottie.asset(AssetsPath.loadingJson, height: size.height * 0.12),
            ));
          }

          if (controller.plantTodayDataList.isEmpty) {
            return EmptyPageWidget(size: size);
          }

          List<ChartData> activePowerController1 = controller.plantTodayDataList.map((data) {
            return ChartData(data.timedate?.millisecondsSinceEpoch ?? 0, data.activePowerControl1?? 0);
          }).toList();

          List<ChartData> activePowerController2 = controller.plantTodayDataList.map((data) {
            return ChartData(data.timedate?.millisecondsSinceEpoch ?? 0, data.activePowerControl2?? 0);
          }).toList();



          return Column(
            children: [
              Container(
                height: size.height * 0.53,
                width: size.width * 0.95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size.height * k12TextSize),
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
                  legend: const Legend(isVisible: true,position: LegendPosition.top,overflowMode: LegendItemOverflowMode.wrap),
                //  tooltipBehavior: TooltipBehavior(enable: true),

                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    tooltipAlignment: ChartAlignment.near,
                    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                    activationMode: ActivationMode.singleTap,
                  ),
                  primaryXAxis: DateTimeAxis(
                      dateFormat: DateFormat('HH:mm '),
                      majorTickLines: const MajorTickLines(width: 5),
                      minorTicksPerInterval: 0,
                      minimum: DateTime(
                          today.year, today.month, today.day, 5, 0, 0),
                      maximum: DateTime(
                          today.year, today.month, today.day, 19, 0, 0),
                      intervalType: DateTimeIntervalType.hours,
                      interval: 2,
                      labelStyle: const TextStyle(fontSize: 10),
                      labelFormat: '{value} ',
                      majorGridLines: const MajorGridLines(width: 1),
                      ),
                  //primaryYAxis: NumericAxis(title: AxisTitle(text: 'Value')),
                  series: <CartesianSeries>[

                    SplineSeries<ChartData, DateTime>(
                      name: 'Act. Power Ctrl. 1',
                      dataSource: activePowerController1,
                      xValueMapper: (ChartData data, _) => DateTime.fromMillisecondsSinceEpoch(data.x),
                      yValueMapper: (ChartData data, _) => data.y,
                    ),
                    SplineSeries<ChartData, DateTime>(
                      name: 'Act. Power Ctrl. 2',
                      dataSource: activePowerController2,
                      xValueMapper: (ChartData data, _) => DateTime.fromMillisecondsSinceEpoch(data.x),
                      yValueMapper: (ChartData data, _) => data.y,
                    ),



                  ],
                ),
              ),
        /*      Align(
                alignment: Alignment.bottomRight,
                child: GetBuilder<PlantTodayDataController>(
                    builder: (plantTodayDataController) {
                      return GestureDetector(
                        onTap: (){
                          plantTodayDataController.downloadDataSheet();
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
