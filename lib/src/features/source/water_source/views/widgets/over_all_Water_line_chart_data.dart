// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// import '../../model/filter_over_all_water_line_chart_model.dart' show FilterOverAllLineChartModel;
//
// class OverAllLineWaterChartDataWidget extends StatelessWidget {
//   final FilterOverAllLineChartModel lineChartModel;
//   const OverAllLineWaterChartDataWidget({super.key, required this.lineChartModel});
//
//   @override
//   Widget build(BuildContext context) {
//     final totalSourceData = getNodeData('Total_Source', lineChartModel);
//     final subMersibleData = getNodeData('Sub_Mersible', lineChartModel);
//     final wtpData = getNodeData('WTP', lineChartModel);
//
//     final allYValues = [
//       ...totalSourceData,
//       ...subMersibleData,
//       ...wtpData,
//     ].map((e) => e.y);
//
//     final minY = (allYValues.isNotEmpty ? allYValues.reduce((a, b) => a < b ? a : b) : 0).floorToDouble();
//     final maxY = (allYValues.isNotEmpty ? allYValues.reduce((a, b) => a > b ? a : b) : 100).ceilToDouble();
//
//     final step = ((maxY - minY) / 5).ceilToDouble();
//     final yLabels = List.generate(6, (index) => maxY - index * step);
//
//     final chartWidth = (totalSourceData.length * 30).toDouble().clamp(300.0, 2000.0);
//
//     return SizedBox(
//       height: 400,
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Y-axis labels and vertical line
//           Container(
//             width: 60,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: Stack(
//               children: [
//                 // Vertical line for Y-axis
//                 Positioned.fill(
//                   child: Align(
//                     alignment: Alignment.centerRight,
//                     child: Container(
//                       width: 2,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                 ),
//                 // Labels
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: yLabels
//                       .map((y) => Text(
//                     '${y.toStringAsFixed(0)} m³/h',
//                     style: const TextStyle(fontSize: 11),
//                   ))
//                       .toList(),
//                 ),
//               ],
//             ),
//           ),
//
//           // Scrollable chart
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: SizedBox(
//                 width: chartWidth,
//                 child: SfCartesianChart(
//                   legend: const Legend(
//                     isVisible: true,
//                     position: LegendPosition.top,
//                   ),
//                   trackballBehavior: TrackballBehavior(
//                     enable: true,
//                     tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
//                     activationMode: ActivationMode.longPress,
//                   ),
//                   primaryXAxis: DateTimeAxis(
//                     dateFormat: DateFormat('dd/MM hh:mm'),
//                     intervalType: DateTimeIntervalType.hours,
//                     majorGridLines: const MajorGridLines(width: 0.2),
//                   ),
//                   primaryYAxis: NumericAxis(
//                     isVisible: false,
//                     minimum: minY,
//                     maximum: maxY,
//                   ),
//                   series: <SplineSeries>[
//                     SplineSeries<ChartData, DateTime>(
//                       dataSource: totalSourceData,
//                       xValueMapper: (ChartData data, _) => data.x,
//                       yValueMapper: (ChartData data, _) => data.y,
//                       name: 'Total Source (m³/h)',
//                       color: Colors.deepPurple,
//                     ),
//                     SplineSeries<ChartData, DateTime>(
//                       dataSource: subMersibleData,
//                       xValueMapper: (ChartData data, _) => data.x,
//                       yValueMapper: (ChartData data, _) => data.y,
//                       name: 'Sub Mersible (m³/h)',
//                       color: const Color(0xFF66D6FF),
//                     ),
//                     SplineSeries<ChartData, DateTime>(
//                       dataSource: wtpData,
//                       xValueMapper: (ChartData data, _) => data.x,
//                       yValueMapper: (ChartData data, _) => data.y,
//                       name: 'WTP (m³/h)',
//                       color: const Color(0xFFC5A4FF),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<ChartData> getNodeData(String nodeName, FilterOverAllLineChartModel model) {
//     return model.data
//         ?.where((entry) => entry.node == nodeName)
//         .map((entry) => ChartData(
//       x: DateTime.parse(entry.timedate ?? ''),
//       y: entry.instantFlow?.toDouble() ?? 0.0,
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
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../model/filter_over_all_water_line_chart_model.dart'
    show FilterOverAllLineChartModel;

class OverAllLineWaterChartDataWidget extends StatelessWidget {
  final FilterOverAllLineChartModel lineChartModel;
  const OverAllLineWaterChartDataWidget({super.key, required this.lineChartModel});

  @override
  Widget build(BuildContext context) {
    final totalSourceData = getNodeData('Total_Source', lineChartModel);
    final subMersibleData = getNodeData('Sub_Mersible', lineChartModel);
    final wtpData = getNodeData('WTP', lineChartModel);

    final allYValues = [
      ...totalSourceData,
      ...subMersibleData,
      ...wtpData,
    ].map((e) => e.y);

    final minY = (allYValues.isNotEmpty ? allYValues.reduce((a, b) => a < b ? a : b) : 0).floorToDouble();
    final maxY = (allYValues.isNotEmpty ? allYValues.reduce((a, b) => a > b ? a : b) : 100).ceilToDouble();

    final step = ((maxY - minY) / 5).ceilToDouble();
    final yLabels = List.generate(6, (index) => maxY - index * step);

    const double minWidth = 500.0;
    const double maxWidth = 6000.0;
    const double pixelsPerDataPoint = 20.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final dataLength = totalSourceData.length;

    double chartWidth = (dataLength * pixelsPerDataPoint)
        .clamp(minWidth, maxWidth)
        .clamp(0, (screenWidth * 0.8).clamp(minWidth, maxWidth));

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
                    '${y.toStringAsFixed(0)} m³/h',
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
                    dateFormat: DateFormat('dd-MMM-yyyy hh:mm'),
                    majorGridLines: const MajorGridLines(width: 0),
                    labelStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                    intervalType: DateTimeIntervalType.days,
                    interval: 1,
                    axisLabelFormatter: (AxisLabelRenderDetails args) {
                      final String text = DateFormat('dd/MMM/yyyy').format(
                        DateTime.fromMillisecondsSinceEpoch(args.value.toInt()),
                      );
                      return ChartAxisLabel(text, args.textStyle);
                    },
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: false,
                    minimum: minY,
                    maximum: maxY,
                  ),
                  series: <SplineSeries>[
                    SplineSeries<ChartData, DateTime>(
                      dataSource: subMersibleData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'Sub Mersible (m³/h)',
                      color: const Color(0xFF66D6FF),
                    ),
                    SplineSeries<ChartData, DateTime>(
                      dataSource: wtpData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'WTP (m³/h)',
                      color: const Color(0xFFC5A4FF),
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
    final rawList = model.data
        ?.where((entry) => entry.node == nodeName)
        .map((entry) => ChartData(
      x: DateTime.tryParse(entry.timedate ?? '') ?? DateTime.now(),
      y: entry.instantFlow?.toDouble() ?? 0.0,
    ))
        .toList() ??
        [];

    rawList.sort((a, b) => a.x.compareTo(b.x)); // Sort by time ascending
    return rawList;
  }
}

class ChartData {
  final DateTime x;
  final double y;

  ChartData({required this.x, required this.y});
}