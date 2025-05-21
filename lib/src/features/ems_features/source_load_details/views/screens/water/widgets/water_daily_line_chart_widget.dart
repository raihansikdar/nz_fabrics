// import 'dart:developer';
// import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/water/water_daily_data_model.dart';
// import 'package:nz_fabrics/src/utility/style/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:nz_fabrics/src/utility/style/app_colors.dart';
//
// class WaterDailyLineChartWidget extends StatelessWidget {
//   const WaterDailyLineChartWidget({
//     super.key,
//     required this.elementName,
//     required this.waterDailyDataList,
//     required this.viewName,
//   });
//
//   final String elementName;
//   final String viewName;
//   final List<WaterDailyDataModel>? waterDailyDataList;
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime today = DateTime.now();
//     Size size = MediaQuery.of(context).size;
//
//     // Filter out invalid data and sort the list by timestamp
//     final List<WaterDailyDataModel> sortedData = (waterDailyDataList ?? [])
//         .where((data) => data.timedate != null)
//         .toList()
//       ..sort((a, b) =>
//           DateTime.parse(a.timedate!).compareTo(DateTime.parse(b.timedate!)));
//
//     return Scaffold(
//         backgroundColor: AppColors.backgroundColor,
//         body: Container(
//           padding: EdgeInsets.all(size.height * k16TextSize),
//           child: SfCartesianChart(
//             primaryXAxis: DateTimeAxis(
//               dateFormat: DateFormat(viewName == 'powerView'
//                   ? 'dd-MMM-yyyy HH:mm:ss'
//                   : 'HH:mm'),
//               axisLabelFormatter: viewName == 'powerView'
//                   ? (axisLabelRenderArgs) {
//                 final String text = DateFormat('HH:mm').format(
//                   DateTime.fromMillisecondsSinceEpoch(
//                     axisLabelRenderArgs.value.toInt(),
//                   ),
//                 );
//                 TextStyle style = TextStyle(
//                     color: Colors.grey.shade500,
//                     fontWeight: FontWeight.bold);
//                 return ChartAxisLabel(text, style);
//               }
//                   : null,
//               majorTickLines: MajorTickLines(width: size.width * 0.005),
//               minorTicksPerInterval: 0,
//               minimum: DateTime(today.year, today.month, today.day, 0, 0, 0).add(const Duration(hours: 6)),
//               maximum: DateTime(today.year, today.month, today.day, 23, 59, 59).add(const Duration(hours: 6)),
//               intervalType: DateTimeIntervalType.hours,
//               interval: 4,
//               labelStyle: TextStyle(fontSize: size.height * k10TextSize),
//               labelFormat: '{value}',
//               majorGridLines: const MajorGridLines(width: 1),
//             ),
//             legend: const Legend(
//               isVisible: false,
//               position: LegendPosition.top,
//             ),
//             trackballBehavior: TrackballBehavior(
//               enable: true,
//               tooltipAlignment: ChartAlignment.near,
//               tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
//               activationMode: ActivationMode.singleTap,
//             ),
//             primaryYAxis: NumericAxis(
//               majorGridLines: const MajorGridLines(width: 1),
//               numberFormat: NumberFormat.compact(),
//               labelFormat: '{value}',
//             ),
//             series: <CartesianSeries>[
//               SplineSeries<WaterDailyDataModel, DateTime>(
//                 color: AppColors.primaryColor,
//                 dataSource: sortedData,
//                 xValueMapper: (WaterDailyDataModel data, _) {
//                   DateTime originalTime = DateTime.parse(data.timedate!); // safe due to filter
//                   return originalTime;
//                 },
//                 yValueMapper: (WaterDailyDataModel data, _) =>
//                 viewName == 'powerView'
//                     ? data.instantFlow ?? 0.0
//                     : data.cost ?? 0.0,
//                 name: viewName == 'powerView'
//                     ? 'Water Flow(m³/h)'
//                     : 'Cost(BDT)',
//               ),
//             ],
//           ),
//         ),
//         );
//     }
//
// }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/water/water_daily_data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import '../../../../models/power_and_energy/daily_data_model.dart' show DailyDataModel;

class WaterDailyLineChartWidget extends StatelessWidget {
  const WaterDailyLineChartWidget({
    super.key,
    required this.elementName,
    required this.waterDailyDataList,
    required this.viewName,
  });

  final String elementName;
  final String viewName;

  final List<WaterDailyDataModel>? waterDailyDataList;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime today = DateTime.now();

    // Define start and end of the day
    DateTime startOfDay = DateTime(today.year, today.month, today.day, 0, 0, 0);
    DateTime endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    // Filter and sort the data
    final List<WaterDailyDataModel> filteredData = (waterDailyDataList ?? [])
        .where((data) => data.timedate != null)
        .where((data) {
      DateTime dataTime = DateTime.parse(data.timedate!);
      return dataTime.isAfter(startOfDay) && dataTime.isBefore(endOfDay);
    })
        .toList()
      ..sort((a, b) => DateTime.parse(a.timedate!).compareTo(DateTime.parse(b.timedate!)));

    // Define the label to show in the tooltip and chart legend
    String valueLabel = viewName == 'powerView' ? 'Water Flow' : 'Cost';
    String unit = viewName == 'powerView' ? 'm³/h' : 'BDT';

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
                              viewName == 'powerView' ? FontAwesomeIcons.bolt : FontAwesomeIcons.bangladeshiTakaSign,
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
                SplineSeries<WaterDailyDataModel, DateTime>(
                  name: valueLabel,
                  color: AppColors.primaryColor,
                  dataSource: filteredData,
                  xValueMapper: (WaterDailyDataModel data, _) {
                    final dateTime = DateTime.parse(data.timedate!).subtract(const Duration(hours: 6));
                    return dateTime;
                  },
                  yValueMapper: (WaterDailyDataModel data, _) {
                    final value = viewName == 'powerView' ? data.instantFlow ?? 0.0 : data.cost ?? 0.0;
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
