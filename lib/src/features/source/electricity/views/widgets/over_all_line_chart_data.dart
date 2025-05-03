// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:nz_ums/src/features/source/model/filter_over_all_line_chart_model.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// class OverAllLineChartDataWidget extends StatelessWidget {
//   final FilterOverAllLineChartModel lineChartModel;
//
//   const OverAllLineChartDataWidget({super.key, required this.lineChartModel});
//
//   @override
//   Widget build(BuildContext context) {
//     final gridData = getNodeData('Grid', lineChartModel);
//     final dieselGeneratorData = getNodeData('Diesel_Generator', lineChartModel);
//     final solarData = getNodeData('Solar', lineChartModel);
//     final totalSourceData = getNodeData('Total_Source', lineChartModel);
//
//     double determineInterval(int dataLength) {
//       if (dataLength > 720) {
//         return 720.0;
//       } else if (dataLength > 450) {
//         return 450.0;
//       } else if (dataLength > 360) {
//         return 360.0;
//       } else {
//         return 240.0;
//       }
//     }
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         width: 1200,
//         padding: const EdgeInsets.all(16.0),
//         child: SfCartesianChart(
//           legend: const Legend(
//             isVisible: true,
//             overflowMode: LegendItemOverflowMode.wrap,
//             position: LegendPosition.top,
//           ),
//           trackballBehavior: TrackballBehavior(
//             enable: true,
//             tooltipAlignment: ChartAlignment.near,
//             tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
//             activationMode: ActivationMode.longPress,
//           ),
//          // tooltipBehavior: TooltipBehavior(enable: true),
//           primaryXAxis: DateTimeAxis(
//             majorGridLines: const MajorGridLines(width: 0.1, color: Colors.deepPurple),
//             dateFormat: DateFormat('dd/MM/yyyy HH:mm:ss'),
//             interval: determineInterval(gridData.length),
//             axisLabelFormatter: (axisLabelRenderArgs) {
//               final String text = DateFormat('dd/MM/yyyy').format(
//                 DateTime.fromMillisecondsSinceEpoch(
//                   axisLabelRenderArgs.value.toInt(),
//                 ),
//               );
//               const TextStyle style =
//               TextStyle(color: Colors.teal, fontWeight: FontWeight.bold);
//               return ChartAxisLabel(text, style);
//             },
//             intervalType: DateTimeIntervalType.minutes,
//             minorGridLines: const MinorGridLines(width: 0),
//           ),
//           primaryYAxis: NumericAxis(
//               majorGridLines: const MajorGridLines(width: 1),
//               numberFormat: NumberFormat.compact(),
//               labelFormat: '{value}',
//          ),
//           series: <SplineSeries>[
//             SplineSeries<ChartData, DateTime>(
//               dataSource: gridData,
//               xValueMapper: (ChartData data, _) => data.x,
//               yValueMapper: (ChartData data, _) => data.y,
//               name: 'Grid (kW)',
//               pointColorMapper: (ChartData data,_)=>  Color.lerp(const Color(0xFF66D6FF), const Color(0xFF4FA3CC),0.5)!,
//               splineType: SplineType.cardinal,
//               cardinalSplineTension: 0.9,
//             ),
//
//             SplineSeries<ChartData, DateTime>(
//               dataSource: solarData,
//               xValueMapper: (ChartData data, _) => data.x,
//               yValueMapper: (ChartData data, _) => data.y,
//               name: 'Solar(kW)',
//               pointColorMapper: (ChartData data,_)=>  Color.lerp(const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!,
//               splineType: SplineType.cardinal,
//               cardinalSplineTension: 0.9,
//             ),
//
//             SplineSeries<ChartData, DateTime>(
//               dataSource: dieselGeneratorData,
//               xValueMapper: (ChartData data, _) => data.x,
//               yValueMapper: (ChartData data, _) => data.y,
//               name: 'Diesel Generator(kW)',
//               pointColorMapper: (ChartData data,_)=>  Color.lerp(const Color(0xFFFFA500), const Color(0xFFFF7F00), 0.5)!,
//               splineType: SplineType.cardinal,
//               cardinalSplineTension: 0.9,
//             ),
//
//             SplineSeries<ChartData, DateTime>(
//               dataSource: totalSourceData,
//               xValueMapper: (ChartData data, _) => data.x,
//               yValueMapper: (ChartData data, _) => data.y,
//               pointColorMapper: (ChartData data,_)=>  Colors.deepPurple,
//               name: 'Total Source(kW)',
//               splineType: SplineType.cardinal,
//               cardinalSplineTension: 0.9,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<ChartData> getNodeData(String nodeName, FilterOverAllLineChartModel model) {
//     return model.data
//         ?.where((entry) => entry.node == nodeName)
//         .map((entry) => ChartData(
//       x: DateTime.parse(entry.timedate ?? ''),
//       y: entry.power ?? 0,
//     ))
//         .toList() ??
//         [];
//   }
// }
//
// class ChartData {
//   final DateTime x;
//   final double y;
//
//   ChartData({required this.x, required this.y});
// }





// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:nz_ums/src/features/source/model/filter_over_all_line_chart_model.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// class OverAllLineChartDataWidget extends StatelessWidget {
//   final FilterOverAllLineChartModel lineChartModel;
//
//   const OverAllLineChartDataWidget({super.key, required this.lineChartModel});
//
//   @override
//   Widget build(BuildContext context) {
//     final gridData = getNodeData('Grid', lineChartModel);
//     final dieselGeneratorData = getNodeData('Diesel_Generator', lineChartModel);
//     final solarData = getNodeData('Solar', lineChartModel);
//     final totalSourceData = getNodeData('Total_Source', lineChartModel);
//
//     double determineInterval(int dataLength) {
//       if (dataLength > 720) {
//         return 720.0;
//       } else if (dataLength > 450) {
//         return 450.0;
//       } else if (dataLength > 360) {
//         return 360.0;
//       } else {
//         return 240.0;
//       }
//     }
//
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Fixed Y-Axis
//         SizedBox(
//           width: 60, // Adjust width as needed
//           child: SfCartesianChart(
//             primaryYAxis: NumericAxis(
//               majorGridLines: const MajorGridLines(width: 1),
//               numberFormat: NumberFormat.compact(),
//               labelFormat: '{value}',
//             ),
//             primaryXAxis:  DateTimeAxis(isVisible: false), // Hide x-axis
//             series: const <ChartSeries>[], // No series for y-axis chart
//           ),
//         ),
//         // Scrollable Chart
//         Expanded(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Container(
//               width: 1200,
//               padding: const EdgeInsets.all(16.0),
//               child: SfCartesianChart(
//                 legend: const Legend(
//                   isVisible: true,
//                   overflowMode: LegendItemOverflowMode.wrap,
//                   position: LegendPosition.top,
//                 ),
//                 trackballBehavior: TrackballBehavior(
//                   enable: true,
//                   tooltipAlignment: ChartAlignment.near,
//                   tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
//                   activationMode: ActivationMode.longPress,
//                 ),
//                 primaryXAxis: DateTimeAxis(
//                   majorGridLines: const MajorGridLines(width: 0.1, color: Colors.deepPurple),
//                   dateFormat: DateFormat('dd/MM/yyyy HH:mm:ss'),
//                   interval: determineInterval(gridData.length),
//                   axisLabelFormatter: (axisLabelRenderArgs) {
//                     final String text = DateFormat('dd/MM/yyyy').format(
//                       DateTime.fromMillisecondsSinceEpoch(
//                         axisLabelRenderArgs.value.toInt(),
//                       ),
//                     );
//                     const TextStyle style =
//                     TextStyle(color: Colors.teal, fontWeight: FontWeight.bold);
//                     return ChartAxisLabel(text, style);
//                   },
//                   intervalType: DateTimeIntervalType.minutes,
//                   minorGridLines: const MinorGridLines(width: 0),
//                 ),
//                 primaryYAxis:  NumericAxis(isVisible: false), // Hide y-axis
//                 series: <SplineSeries>[
//                   SplineSeries<ChartData, DateTime>(
//                     dataSource: gridData,
//                     xValueMapper: (ChartData data, _) => data.x,
//                     yValueMapper: (ChartData data, _) => data.y,
//                     name: 'Grid (kW)',
//                     pointColorMapper: (ChartData data, _) => Color.lerp(
//                         const Color(0xFF66D6FF), const Color(0xFF4FA3CC), 0.5)!,
//                     splineType: SplineType.cardinal,
//                     cardinalSplineTension: 0.9,
//                   ),
//                   SplineSeries<ChartData, DateTime>(
//                     dataSource: solarData,
//                     xValueMapper: (ChartData data, _) => data.x,
//                     yValueMapper: (ChartData data, _) => data.y,
//                     name: 'Solar(kW)',
//                     pointColorMapper: (ChartData data, _) => Color.lerp(
//                         const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!,
//                     splineType: SplineType.cardinal,
//                     cardinalSplineTension: 0.9,
//                   ),
//                   SplineSeries<ChartData, DateTime>(
//                     dataSource: dieselGeneratorData,
//                     xValueMapper: (ChartData data, _) => data.x,
//                     yValueMapper: (ChartData data, _) => data.y,
//                     name: 'Diesel Generator(kW)',
//                     pointColorMapper: (ChartData data, _) => Color.lerp(
//                         const Color(0xFFFFA500), const Color(0xFFFF7F00), 0.5)!,
//                     splineType: SplineType.cardinal,
//                     cardinalSplineTension: 0.9,
//                   ),
//                   SplineSeries<ChartData, DateTime>(
//                     dataSource: totalSourceData,
//                     xValueMapper: (ChartData data, _) => data.x,
//                     yValueMapper: (ChartData data, _) => data.y,
//                     pointColorMapper: (ChartData data, _) => Colors.deepPurple,
//                     name: 'Total Source(kW)',
//                     splineType: SplineType.cardinal,
//                     cardinalSplineTension: 0.9,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   List<ChartData> getNodeData(String nodeName, FilterOverAllLineChartModel model) {
//     return model.data
//         ?.where((entry) => entry.node == nodeName)
//         .map((entry) => ChartData(
//       x: DateTime.parse(entry.timedate ?? ''),
//       y: entry.power ?? 0,
//     ))
//         .toList() ??
//         [];
//   }
// }
//
// class ChartData {
//   final DateTime x;
//   final double y;
//
//   ChartData({required this.x, required this.y});
// }

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'dart:math';
// import 'package:nz_ums/src/features/source/model/filter_over_all_line_chart_model.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// class OverAllLineChartDataWidget extends StatelessWidget {
//   final FilterOverAllLineChartModel lineChartModel;
//
//   const OverAllLineChartDataWidget({super.key, required this.lineChartModel});
//
//   @override
//   Widget build(BuildContext context) {
//     final gridData = getNodeData('Grid', lineChartModel);
//     final dieselGeneratorData = getNodeData('Diesel_Generator', lineChartModel);
//     final solarData = getNodeData('Solar', lineChartModel);
//     final totalSourceData = getNodeData('Total_Source', lineChartModel);
//
//     // Combine all data to calculate the proper Y-axis range
//     final allData = [...gridData, ...solarData, ...dieselGeneratorData, ...totalSourceData];
//
//     // Find max value for proper scaling (min will be forced to 0)
//     double maxY = allData.isEmpty ? 10 : allData.map((e) => e.y).reduce((a, b) => a > b ? a : b);
//
//     // Add padding to the max (10%)
//     double paddedMax = maxY + (maxY * 0.1);
//
//     // Force minimum to be 0
//     double paddedMin = 0;
//
//     // Calculate appropriate interval for better label density
//     double interval = calculateYAxisInterval(paddedMin, paddedMax, 10); // Increased to 10 divisions
//
//     double determineInterval(int dataLength) {
//       if (dataLength > 720) {
//         return 720.0;
//       } else if (dataLength > 450) {
//         return 450.0;
//       } else if (dataLength > 360) {
//         return 360.0;
//       } else {
//         return 240.0;
//       }
//     }
//
//     // Create a row with a fixed Y-axis and a scrollable chart
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Fixed Y-axis chart (no data series, just the axis)
//         SizedBox(
//           width: 60, // Width for the Y-axis
//           child: SfCartesianChart(
//             primaryYAxis: NumericAxis(
//               majorGridLines: const MajorGridLines(width: 0),
//               numberFormat: NumberFormat.compact(),
//               labelFormat: '{value}',
//               minimum: paddedMin,
//               maximum: paddedMax,
//               interval: interval,
//               opposedPosition: false,
//               labelPosition: ChartDataLabelPosition.outside,
//               labelAlignment: LabelAlignment.center,
//               maximumLabels: 20, // Allow more labels
//             ),
//             primaryXAxis: DateTimeAxis(
//               isVisible: false, // Hide X-axis
//             ),
//             // Empty placeholder series to ensure the Y-axis scale matches
//             series: <LineSeries<ChartData, DateTime>>[
//               LineSeries<ChartData, DateTime>(
//                 dataSource: allData,
//                 xValueMapper: (ChartData data, _) => data.x,
//                 yValueMapper: (ChartData data, _) => data.y,
//                 isVisible: false, // Make the series invisible
//               ),
//             ],
//           ),
//         ),
//
//         // Scrollable chart content without Y-axis labels
//         Expanded(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: SizedBox(
//               width: 1200, // Width for scrollable chart area
//               child: SfCartesianChart(
//                 margin: EdgeInsets.zero,
//                 legend: const Legend(
//                   isVisible: true,
//                   overflowMode: LegendItemOverflowMode.wrap,
//                   position: LegendPosition.top,
//                 ),
//                 trackballBehavior: TrackballBehavior(
//                   enable: true,
//                   tooltipAlignment: ChartAlignment.near,
//                   tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
//                   activationMode: ActivationMode.longPress,
//                   markerSettings: const TrackballMarkerSettings(
//                     markerVisibility: TrackballVisibilityMode.visible,
//                     height: 8,
//                     width: 8,
//                     borderWidth: 1,
//                   ),
//                 ),
//                 primaryXAxis: DateTimeAxis(
//                   majorGridLines: const MajorGridLines(width: 0.1, color: Colors.deepPurple),
//                   dateFormat: DateFormat('dd/MM/yyyy HH:mm:ss'),
//                   interval: determineInterval(gridData.length),
//                   axisLabelFormatter: (axisLabelRenderArgs) {
//                     final String text = DateFormat('dd/MM/yyyy').format(
//                       DateTime.fromMillisecondsSinceEpoch(
//                         axisLabelRenderArgs.value.toInt(),
//                       ),
//                     );
//                     const TextStyle style =
//                     TextStyle(color: Colors.teal, fontWeight: FontWeight.bold);
//                     return ChartAxisLabel(text, style);
//                   },
//                   intervalType: DateTimeIntervalType.minutes,
//                   minorGridLines: const MinorGridLines(width: 0),
//                 ),
//                 primaryYAxis: NumericAxis(
//                   majorGridLines: const MajorGridLines(width: 1, color: Colors.grey),
//                   minorGridLines:  MinorGridLines(width: 0.5, color: Colors.grey.withOpacity(0.3)),
//                   labelStyle: const TextStyle(color: Colors.transparent),  // Make labels transparent
//                   axisLine: const AxisLine(width: 0),  // Hide the axis line
//                   majorTickLines: const MajorTickLines(size: 0),  // Hide tick lines
//                   // Keep the same range and interval as the left axis
//                   minimum: paddedMin,
//                   maximum: paddedMax,
//                   interval: interval,
//                 ),
//                 series: <SplineSeries>[
//                   SplineSeries<ChartData, DateTime>(
//                     dataSource: gridData,
//                     xValueMapper: (ChartData data, _) => data.x,
//                     yValueMapper: (ChartData data, _) => data.y,
//                     name: 'Grid (kW)',
//                     pointColorMapper: (ChartData data, _) =>
//                     Color.lerp(const Color(0xFF66D6FF), const Color(0xFF4FA3CC), 0.5)!,
//                     splineType: SplineType.cardinal,
//                     cardinalSplineTension: 0.9,
//                     markerSettings: const MarkerSettings(
//                       isVisible: false,
//                       height: 4,
//                       width: 4,
//                     ),
//                   ),
//                   SplineSeries<ChartData, DateTime>(
//                     dataSource: solarData,
//                     xValueMapper: (ChartData data, _) => data.x,
//                     yValueMapper: (ChartData data, _) => data.y,
//                     name: 'Solar(kW)',
//                     pointColorMapper: (ChartData data, _) =>
//                     Color.lerp(const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!,
//                     splineType: SplineType.cardinal,
//                     cardinalSplineTension: 0.9,
//                     markerSettings: const MarkerSettings(
//                       isVisible: false,
//                       height: 4,
//                       width: 4,
//                     ),
//                   ),
//                   SplineSeries<ChartData, DateTime>(
//                     dataSource: dieselGeneratorData,
//                     xValueMapper: (ChartData data, _) => data.x,
//                     yValueMapper: (ChartData data, _) => data.y,
//                     name: 'Diesel Generator(kW)',
//                     pointColorMapper: (ChartData data, _) =>
//                     Color.lerp(const Color(0xFFFFA500), const Color(0xFFFF7F00), 0.5)!,
//                     splineType: SplineType.cardinal,
//                     cardinalSplineTension: 0.9,
//                     markerSettings: const MarkerSettings(
//                       isVisible: false,
//                       height: 4,
//                       width: 4,
//                     ),
//                   ),
//                   SplineSeries<ChartData, DateTime>(
//                     dataSource: totalSourceData,
//                     xValueMapper: (ChartData data, _) => data.x,
//                     yValueMapper: (ChartData data, _) => data.y,
//                     pointColorMapper: (ChartData data, _) => Colors.deepPurple,
//                     name: 'Total Source(kW)',
//                     splineType: SplineType.cardinal,
//                     cardinalSplineTension: 0.9,
//                     markerSettings: const MarkerSettings(
//                       isVisible: false,
//                       height: 4,
//                       width: 4,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Helper method to calculate appropriate Y-axis interval
//   double calculateYAxisInterval(double min, double max, int targetDivisions) {
//     double range = max - min;
//
//     // Calculate ideal raw interval based on desired number of divisions
//     double rawInterval = range / targetDivisions;
//
//     // Round to a nice number
//     // Find the magnitude (power of 10) close to the raw interval
//     num magnitude = pow(10, (log(rawInterval) / ln10).floor());
//
//     // Normalize the interval to a value between 1 and 10
//     double normalizedInterval = rawInterval / magnitude;
//
//     // Select the closest nice number (1, 2, 2.5, 5, 10)
//     double niceInterval;
//     if (normalizedInterval < 1.5) {
//       niceInterval = 1;
//     } else if (normalizedInterval < 2.25) {
//       niceInterval = 2;
//     } else if (normalizedInterval < 3.75) {
//       niceInterval = 2.5;
//     } else if (normalizedInterval < 7.5) {
//       niceInterval = 5;
//     } else {
//       niceInterval = 10;
//     }
//
//     return niceInterval * magnitude;
//   }
//
//   // Natural logarithm of 10 for use in calculations
//   static const double ln10 = 2.302585092994046;
//
//   List<ChartData> getNodeData(String nodeName, FilterOverAllLineChartModel model) {
//     return model.data
//         ?.where((entry) => entry.node == nodeName)
//         .map((entry) => ChartData(
//       x: DateTime.parse(entry.timedate ?? ''),
//       y: entry.power ?? 0,
//     ))
//         .toList() ??
//         [];
//   }
// }
//
// class ChartData {
//   final DateTime x;
//   final double y;
//
//   ChartData({required this.x, required this.y});
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/source/electricity/model/filter_over_all_line_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverAllLineChartDataWidget extends StatelessWidget {
  final FilterOverAllLineChartModel lineChartModel;
  const OverAllLineChartDataWidget({super.key, required this.lineChartModel});

  @override
  Widget build(BuildContext context) {
    final gridData = getNodeData('Grid', lineChartModel);
    final dieselGeneratorData = getNodeData('Diesel_Generator', lineChartModel);
    final solarData = getNodeData('Solar', lineChartModel);
    final totalSourceData = getNodeData('Total_Source', lineChartModel);

    final allYValues = [
      ...gridData,
      ...dieselGeneratorData,
      ...solarData,
      ...totalSourceData
    ].map((e) => e.y);

    final minY = (allYValues.isNotEmpty ? allYValues.reduce((a, b) => a < b ? a : b) : 0).floorToDouble();
    final maxY = (allYValues.isNotEmpty ? allYValues.reduce((a, b) => a > b ? a : b) : 100).ceilToDouble();

    final step = ((maxY - minY) / 5).ceilToDouble();
    final yLabels = List.generate(6, (index) => maxY - index * step);

    final chartWidth = (gridData.length * 30).toDouble().clamp(300.0, 2000.0);

    return SizedBox(
      height: 400,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Y-axis labels and vertical line
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Stack(
              children: [
                // Vertical line for Y-axis
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 2,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                // Labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: yLabels
                      .map((y) => Text(
                    '${y.toStringAsFixed(0)} kW',
                    style: const TextStyle(fontSize: 11),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),

          // Scrollable chart
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: chartWidth,
                child: SfCartesianChart(
                  legend: const Legend(
                    isVisible: true,
                    position: LegendPosition.top,
                  ),
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                    activationMode: ActivationMode.longPress,
                  ),
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat('dd/MM hh:mm'),
                    intervalType: DateTimeIntervalType.hours,
                    majorGridLines: const MajorGridLines(width: 0.2),
                    //  labelRotation: -45,
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: false,
                    minimum: minY,
                    maximum: maxY,
                  ),
                  series: <SplineSeries>[
                    SplineSeries<ChartData, DateTime>(
                      dataSource: gridData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'Grid (kW)',
                      color: const Color(0xFF66D6FF),
                    ),
                    SplineSeries<ChartData, DateTime>(
                      dataSource: solarData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'Solar (kW)',
                      color: const Color(0xFFC5A4FF),
                    ),
                    SplineSeries<ChartData, DateTime>(
                      dataSource: dieselGeneratorData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'Diesel Generator (kW)',
                      color: const Color(0xFFFFA500),
                    ),
                    SplineSeries<ChartData, DateTime>(
                      dataSource: totalSourceData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'Total Source (kW)',
                      color: Colors.deepPurple,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<ChartData> getNodeData(String nodeName, FilterOverAllLineChartModel model) {
    return model.data
        ?.where((entry) => entry.node == nodeName)
        .map((entry) => ChartData(
      x: DateTime.parse(entry.timedate ?? ''),
      y: entry.power ?? 0,
    ))
        .toList() ??
        [];
  }
}

class ChartData {
  final DateTime x;
  final double y;

  ChartData({required this.x, required this.y});
}