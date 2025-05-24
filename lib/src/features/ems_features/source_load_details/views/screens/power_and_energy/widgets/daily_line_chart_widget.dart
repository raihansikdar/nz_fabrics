// import 'dart:developer';
//
// import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/natural_gas/natural_gas_daily_data_model.dart';
// import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/plot_line/machine_max_power_model.dart';
// import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/power_and_energy/daily_data_model.dart';
// import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/water/water_daily_data_model.dart';
// import 'package:nz_fabrics/src/utility/style/constant.dart';
// import 'package:flutter/material.dart';
//
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:nz_fabrics/src/utility/style/app_colors.dart';
//
// class DailyLineChartWidget extends StatelessWidget {
//
//    const  DailyLineChartWidget({super.key, required this.elementName, this.dailyDataList,this.waterDailyDataList ,required this.screenName, required this.viewName, this.naturalGasDailyDataList,  this.machineMaxPowerModel });
//    final String elementName;
//    final String viewName;
//     final List<DailyDataModel>? dailyDataList;
//     final List<WaterDailyDataModel>? waterDailyDataList;
//     final List<NaturalGasDailyDataModel>? naturalGasDailyDataList;
//     final MachineMaxPowerModel? machineMaxPowerModel;
//    final String screenName;
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime today = DateTime.now();
//     Size size = MediaQuery.of(context).size;
//
//
//    // log("-------------->${machineMaxPowerModel?.machineMaxPower}");
//
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: Container(
//             padding: EdgeInsets.all(size.height * k16TextSize),
//             child: viewName== 'powerView' ?  SfCartesianChart(
//               primaryXAxis: DateTimeAxis(
//                 dateFormat: DateFormat('dd-MMM-yyyy HH:mm:ss'),
//                 axisLabelFormatter: (axisLabelRenderArgs) {
//                   final String text = DateFormat('HH:mm ').format(
//                     DateTime.fromMillisecondsSinceEpoch(
//                       axisLabelRenderArgs.value.toInt(),
//                     ),
//                   );
//                   TextStyle style = TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold);
//                   return ChartAxisLabel(text, style);
//                 },
//                 majorTickLines: MajorTickLines(width: size.width * 0.005),
//                 minorTicksPerInterval: 0,
//                 minimum: DateTime(
//                     today.year, today.month, today.day, 0, 0, 0),
//                 maximum: DateTime(
//                     today.year, today.month, today.day, 24, 0, 0),
//                 intervalType: DateTimeIntervalType.hours,
//                 interval: 4,
//                 labelStyle:  TextStyle(fontSize: size.height * k10TextSize),
//                 labelFormat: '{value} ',
//                 majorGridLines: const MajorGridLines(width: 1),
//               ),
//
//               legend: const Legend(
//                 isVisible: false,
//                 position: LegendPosition.top,
//               ),
//
//               trackballBehavior: TrackballBehavior(
//                 enable: true,
//                 tooltipAlignment: ChartAlignment.near,
//                 tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
//                 activationMode: ActivationMode.singleTap,
//               ),
//              /* primaryYAxis: NumericAxis(
//                   majorGridLines: const MajorGridLines(width: 1),
//                   numberFormat: NumberFormat.compact(), // Format Y-axis as 1k, 2k, 4k
//                   labelFormat: '{value}', // Display as it is formatted
//                   ),*/
//
//
//
//               primaryYAxis: NumericAxis(
//                 majorGridLines: MajorGridLines(width: 1),
//                 numberFormat: NumberFormat.compact(),
//                 labelFormat: '{value}',
//                 plotBands: [
//                   PlotBand(
//                     start: machineMaxPowerModel?.machineMaxPower ?? 0.00,
//                     end:  machineMaxPowerModel?.machineMaxPower ?? 0.00,
//                     borderColor: AppColors.secondaryTextColor,
//                     borderWidth: 2,
//                    // dashArray: <double>[4, 5],
//                     text: "Max Water (${machineMaxPowerModel?.machineMaxPower ?? 0.00})",
//                     textAngle: 0,
//                     horizontalTextAlignment: TextAnchor.end,
//                     verticalTextAlignment: TextAnchor.start,
//                   ),
//                 ],
//               ),
//
//
//
//
//
//               series: screenName == 'water' ?  <CartesianSeries>[
//                 SplineSeries<WaterDailyDataModel, DateTime>(
//                   color: AppColors.primaryColor,
//                   dataSource: waterDailyDataList ?? [],
//                   xValueMapper: (WaterDailyDataModel data, _) {
//                     DateTime originalTime = DateTime.parse(data.timedate ?? DateTime.now().toIso8601String());
//                     return originalTime.subtract(const Duration(hours: 6));
//
//                   },
//                   yValueMapper: (WaterDailyDataModel data, _) => data.instantFlow ?? 0.0,
//                   name: 'Water Flow(m³/h)',
//                 ),
//               ] : screenName == 'naturalGasScreen' ?  <CartesianSeries>[
//                 SplineSeries<NaturalGasDailyDataModel, DateTime>(
//                   color: AppColors.primaryColor,
//                   dataSource: naturalGasDailyDataList ?? [],
//                   xValueMapper: (NaturalGasDailyDataModel data, _) {
//
//                     DateTime originalTime = DateTime.parse(data.timedate ?? DateTime.now().toIso8601String());
//                     return originalTime.subtract(const Duration(hours: 6));
//
//                   },
//                   yValueMapper: (NaturalGasDailyDataModel data, _) => data.pressure ?? 0.0,
//                   name: 'Gas Pressure(Pa)',
//                 ),
//               ] : <CartesianSeries>[
//               SplineSeries<DailyDataModel, DateTime>(
//                 color: AppColors.primaryColor,
//             dataSource: dailyDataList ?? [],
//             xValueMapper: (DailyDataModel data, _) {
//               DateTime originalTime = DateTime.parse(data.timedate ?? DateTime.now().toIso8601String());
//               return originalTime.subtract(const Duration(hours: 6));
//
//             },
//             yValueMapper: (DailyDataModel data, _) => data.power ?? 0.0,
//             name: 'Power(kW)',
//             ),
//               ],
//
//             ) : SfCartesianChart(
//               primaryXAxis: DateTimeAxis(
//                 dateFormat: DateFormat('HH:mm'),
//                 majorTickLines:  MajorTickLines(width: size.width * 0.005),
//                 minorTicksPerInterval: 0,
//                 minimum: DateTime(today.year, today.month, today.day, 0, 0, 0)
//                     .subtract(const Duration(days: 1)),
//                 maximum: DateTime(today.year, today.month, today.day, 24, 0, 0)
//                     .add(const Duration(days: 1)),
//                 intervalType: DateTimeIntervalType.hours,
//                 interval: 4,
//                 labelStyle:  TextStyle(fontSize: size.height * k10TextSize),
//                 labelFormat: '{value}',
//                 majorGridLines: const MajorGridLines(width: 1),
//               ),
//
//
//               legend: const Legend(
//                 isVisible: false,
//                 position: LegendPosition.top,
//               ),
//
//               trackballBehavior: TrackballBehavior(
//                 enable: true,
//                 tooltipAlignment: ChartAlignment.near,
//                 tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
//                 activationMode: ActivationMode.singleTap,
//               ),
//
//               primaryYAxis: NumericAxis(
//                 majorGridLines: const MajorGridLines(width: 1),
//                 numberFormat: NumberFormat.compact(), // Format Y-axis as 1k, 2k, 4k
//                 labelFormat: '{value}', // Display as it is formatted
//               ),
//               series: screenName == 'water' ?  <CartesianSeries>[
//                 SplineSeries<WaterDailyDataModel, DateTime>(
//                   color: AppColors.primaryColor,
//                   dataSource: waterDailyDataList ?? [],
//                   xValueMapper: (WaterDailyDataModel data, _) {
//
//                     DateTime originalTime = DateTime.parse(data.timedate ?? DateTime.now().toIso8601String());
//                     return originalTime.subtract(const Duration(hours: 6));
//
//                   },yValueMapper: (WaterDailyDataModel data, _) => data.cost ?? 0.0,
//                   name: 'Cost(BDT)',
//                 ),
//               ] : <CartesianSeries>[
//                 SplineSeries<DailyDataModel, DateTime>(
//                   color: AppColors.primaryColor,
//                   dataSource: dailyDataList ?? [],
//                   xValueMapper: (DailyDataModel data, _) {
//                   //  return DateTime.parse(data.timedate ?? DateTime.now().toIso8601String());
//                     DateTime originalTime = DateTime.parse(data.timedate ?? DateTime.now().toIso8601String());
//                     return originalTime.subtract(const Duration(hours: 6));
//
//                   }, yValueMapper: (DailyDataModel data, _) => data.cost ?? 0.0,
//                   name: 'Cost(BDT)',
//                 ),
//               ],
//
//
//             ),
//           ),
//
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import '../../../../models/power_and_energy/daily_data_model.dart' show DailyDataModel;

class DailyLineChartWidget extends StatelessWidget {
  const DailyLineChartWidget({
    super.key,
    required this.elementName,
    required this.dailyDataList,
    required this.viewName,
  });

  final String elementName;
  final String viewName;
  final List<DailyDataModel>? dailyDataList;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime today = DateTime.now();

    // Define start and end of the day
    DateTime startOfDay = DateTime(today.year, today.month, today.day, 0, 0, 0);
    DateTime endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    // Filter and sort the data
    final List<DailyDataModel> filteredData = (dailyDataList ?? [])
        .where((data) => data.timedate != null)
        .where((data) {
      DateTime dataTime = DateTime.parse(data.timedate!);
      return dataTime.isAfter(startOfDay) && dataTime.isBefore(endOfDay);
    })
        .toList()
      ..sort((a, b) => DateTime.parse(a.timedate!).compareTo(DateTime.parse(b.timedate!)));

    // Define the label to show in the tooltip and chart legend
    String valueLabel = viewName == 'powerView' ? 'Cost' : 'Power';
    String unit = viewName == 'powerView' ? 'BDT' : 'kW';

    final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
        enablePinching: true,
        enablePanning: true,
        zoomMode: ZoomMode.x,
        enableDoubleTapZooming:true,
        );

    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Container(
            padding: EdgeInsets.all(size.height * k16TextSize),
            child: SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat('HH:mm'), // 12-hour format with AM/PM
                majorTickLines: MajorTickLines(width: size.width * 0.005),
                minorTicksPerInterval: 0,
                minimum: startOfDay,
                maximum: DateTime(today.year, today.month, today.day + 1, 0, 0, 0),
                intervalType: DateTimeIntervalType.hours,
                interval: 4,
                labelStyle: TextStyle(fontSize: size.height * k10TextSize),
                majorGridLines: const MajorGridLines(width: 1),
              ),
              legend: Legend(
                isVisible: false,
                position: LegendPosition.top,
              ),
              primaryYAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 1),
                numberFormat: NumberFormat.compact(),
                labelFormat: '{value}',

              ),
              zoomPanBehavior: _zoomPanBehavior,
              trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                tooltipSettings: InteractiveTooltip(
                  color: AppColors.primaryColor.withOpacity(0.8),
                  textStyle: TextStyle(color: Colors.white, fontSize: size.height * k12TextSize),
                  decimalPlaces: 2,
                ),
                lineType: TrackballLineType.vertical,
                lineWidth: 1.5,
                shouldAlwaysShow: false,
                markerSettings: const TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.visible,
                  height: 10,
                  width: 10,
                  borderWidth: 1,
                  color: Colors.white,
                  borderColor: Colors.black45,
                ),
                builder: (BuildContext context, TrackballDetails trackballDetails) {
                  if (trackballDetails.point == null) {
                    return const SizedBox.shrink();
                  }

                  final DateTime displayTime = trackballDetails.point!.x;
                  final String formattedTime = DateFormat('HH:mm:ss').format(displayTime.add(const Duration(hours: 6)));              final String formattedValue = trackballDetails.point?.y != null
                      ? trackballDetails.point!.y!.toStringAsFixed(2)
                      : 'N/A';

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white24,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: Colors.white70,
                              size: size.height * k14TextSize,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Time: $formattedTime',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * k14TextSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              viewName == 'powerView' ? FontAwesomeIcons.bangladeshiTakaSign : FontAwesomeIcons.bolt,
                              color: Colors.white,
                              size: size.height * k14TextSize,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$valueLabel: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * k14TextSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '$formattedValue $unit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * k14TextSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                format: 'Time: {point.x}\n$valueLabel: {point.y}',
                header: '',
              ),
              series: <CartesianSeries>[
                SplineSeries<DailyDataModel, DateTime>(
                  name: valueLabel,
                  color: AppColors.primaryColor,
                  dataSource: filteredData,
                  xValueMapper: (DailyDataModel data, _) {
                    final dateTime = DateTime.parse(data.timedate!).subtract(const Duration(hours: 6));
                    return dateTime;
                  },
                  yValueMapper: (DailyDataModel data, _) {
                    final value = viewName == 'powerView' ? data.cost ?? 0.0 : data.power ?? 0.0;
                    return value;
                  },
                  enableTooltip: true,
                ),
              ],
              onTrackballPositionChanging: (TrackballArgs args) {
                // Customize trackball if needed
              },
            ),
            ),
        );
   }
}