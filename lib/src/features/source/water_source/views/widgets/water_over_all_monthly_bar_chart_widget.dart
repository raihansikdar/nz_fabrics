// import 'package:flutter/material.dart';
// import 'package:nz_ums/src/features/water_source/controller/over_all_source_water_data_controller.dart';
// import 'package:nz_ums/src/features/water_source/model/filter_over_water_all_monthly_bar_chart_Model.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:intl/intl.dart';
//
// class OverAllMonthlyBarChartWidget extends StatelessWidget {
//   final FilterOverAllMonthlyBarChartDataModel barChartModel;
//   final OverAllSourceDataController controller;
//
//   const OverAllMonthlyBarChartWidget({super.key, required this.barChartModel, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     final gridData = getNodeData('Grid', barChartModel);
//     final dieselGeneratorData = getNodeData('Diesel_Generator', barChartModel);
//     final solarData = getNodeData('Solar', barChartModel);
//     final totalSourceData = getNodeData('Total_Source', barChartModel);
//
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Container(
//        width: controller.dateDifference > 15 ? 2400 : 1200,
//         padding: const EdgeInsets.all(16.0),
//         child: SfCartesianChart(
//           legend: const Legend(
//             isVisible: true,
//             overflowMode: LegendItemOverflowMode.wrap,
//             position: LegendPosition.top,
//           ),
//           //tooltipBehavior: _tooltipBehavior,
//           trackballBehavior: TrackballBehavior(
//             enable: true,
//             tooltipAlignment: ChartAlignment.near,
//             tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
//             activationMode: ActivationMode.longPress,
//           ),
//           primaryXAxis: DateTimeAxis(
//             dateFormat: DateFormat('dd/MMM'),
//             intervalType: DateTimeIntervalType.days,  // show one date
//             majorGridLines: const MajorGridLines(width: 1),
//           ),
//           primaryYAxis: NumericAxis(
//               majorGridLines: const MajorGridLines(width: 1),
//               numberFormat: NumberFormat.compact(),
//               labelFormat: '{value}',
//              ),
//           series: <ColumnSeries>[
//             ColumnSeries<ChartData, DateTime>(
//               dataSource: gridData,
//               xValueMapper: (ChartData data, _) => data.x,
//               yValueMapper: (ChartData data, _) => data.y,
//               name: 'Grid (kWh)',
//               color:  Color.lerp(const Color(0xFF66D6FF), const Color(0xFF4FA3CC),0.5)!,
//               enableTooltip: true,
//             ),
//             ColumnSeries<ChartData, DateTime>(
//               dataSource: dieselGeneratorData,
//               xValueMapper: (ChartData data, _) => data.x,
//               yValueMapper: (ChartData data, _) => data.y,
//               name: 'Diesel Generator (kWh)',
//               color: Color.lerp(const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!,
//               enableTooltip: true,
//             ),
//             ColumnSeries<ChartData, DateTime>(
//               dataSource: solarData,
//               xValueMapper: (ChartData data, _) => data.x,
//               yValueMapper: (ChartData data, _) => data.y,
//               name: 'Solar (kWh)',
//               color: Color.lerp(const Color(0xFFFFA500), const Color(0xFFFF7F00), 0.5)!,
//               enableTooltip: true,
//             ),
//             ColumnSeries<ChartData, DateTime>(
//               dataSource: totalSourceData,
//               xValueMapper: (ChartData data, _) => data.x,
//               yValueMapper: (ChartData data, _) => data.y,
//               name: 'Total Source (kWh)',
//               color: Colors.deepPurple,
//               enableTooltip: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<ChartData> getNodeData(String nodeName, FilterOverAllMonthlyBarChartDataModel model) {
//     return model.data
//         ?.where((entry) => entry.node?.toLowerCase() == nodeName.toLowerCase())
//         .map((entry) => ChartData(
//       x: DateTime.parse(entry.date ?? ''),
//       y: entry.energy?.toDouble() ?? 0,
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
import 'package:nz_fabrics/src/features/source/water_source/controller/over_all_source_water_data_controller.dart';
import 'package:nz_fabrics/src/features/source/water_source/model/filter_over_water_all_monthly_bar_chart_Model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WaterOverAllMonthlyBarChartWidget extends StatelessWidget {
  final FilterOverAllWaterMonthlyBarChartDataModel barChartModel;
  final OverAllWaterSourceDataController controller;

  const WaterOverAllMonthlyBarChartWidget({
    super.key,
    required this.barChartModel,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final totalSourceData = getNodeData('Total_Source', barChartModel);
    final subMersibleData = getNodeData('Sub_Mersible', barChartModel);
    final wtpData = getNodeData('WTP', barChartModel);

    final allYValues = [
      ...totalSourceData,
      ...subMersibleData,
      ...wtpData,
    ].map((e) => e.y);

    final minY = (allYValues.isNotEmpty ? allYValues.reduce((a, b) => a < b ? a : b) : 0).floorToDouble();
    final maxY = (allYValues.isNotEmpty ? allYValues.reduce((a, b) => a > b ? a : b) : 100).ceilToDouble();

    final step = ((maxY - minY) / 5).ceilToDouble();
    final yLabels = List.generate(6, (index) => maxY - index * step);

    final screenWidth = MediaQuery.of(context).size.width;
    final calculatedWidth = (totalSourceData.length * 60).toDouble();
    final chartWidth = calculatedWidth < screenWidth - 60
        ? screenWidth - 60
        : calculatedWidth.clamp(300.0, 2000.0);

    return SizedBox(
      height: 400,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Y-axis labels
          Container(
            width: 60,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(width: 2, color: Colors.deepPurple),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: yLabels
                      .map((y) => Text(
                    '${y.toStringAsFixed(0)} m³',
                    style: const TextStyle(fontSize: 11),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
          // Scrollable bar chart
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
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: false,
                    minimum: minY,
                    maximum: maxY,
                  ),
                  series: <CartesianSeries>[
                    ColumnSeries<ChartData, String>(
                      dataSource: totalSourceData,
                      xValueMapper: (ChartData data, _) => DateFormat('dd MMM').format(data.x),
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'Total Source (m³)',
                      color: Colors.deepPurple,
                    ),
                    ColumnSeries<ChartData, String>(
                      dataSource: subMersibleData,
                      xValueMapper: (ChartData data, _) => DateFormat('dd MMM').format(data.x),
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'Sub Mersible (m³)',
                      color: const Color(0xFF66D6FF),
                    ),
                    ColumnSeries<ChartData, String>(
                      dataSource: wtpData,
                      xValueMapper: (ChartData data, _) => DateFormat('dd MMM').format(data.x),
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'WTP (m³)',
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

  List<ChartData> getNodeData(String nodeName, FilterOverAllWaterMonthlyBarChartDataModel model) {
    return model.data
        ?.where((entry) => entry.node == nodeName)
        .map((entry) {
      DateTime date;
      try {
        date = DateTime.parse(entry.date ?? '');
      } catch (e) {
        debugPrint('Invalid date format: ${entry.date}, defaulting to now');
        date = DateTime.now();
      }
      return ChartData(x: date, y: entry.instantFlow?.toDouble() ?? 0);
    })
        .toList()
        ?.reversed
        .toList() ??
        [];
  }
}

class ChartData {
  final DateTime x;
  final double y;

  ChartData({required this.x, required this.y});
}