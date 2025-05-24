// import 'package:flutter/material.dart';
// import 'package:nz_fabrics/src/features/water_source/model/filter_over_all_yearly_bar_chart_data_model.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:intl/intl.dart';
//
//
// class OverAllYearlyBarChartWidget extends StatelessWidget {
//   final FilterOverAllWaterYearlyBarChartDataModel barChartModel;
//
//   const OverAllYearlyBarChartWidget({super.key, required this.barChartModel});
//
//   @override
//   Widget build(BuildContext context) {
//     final gridData = getNodeData('Grid', barChartModel);
//     final dieselGeneratorData = getNodeData('Diesel_Generator', barChartModel);
//     final solarData = getNodeData('Solar', barChartModel);
//     final totalSourceData = getNodeData('Total_Source', barChartModel);
//
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SfCartesianChart(
//         legend: const Legend(
//           isVisible: true,
//           overflowMode: LegendItemOverflowMode.wrap,
//           position: LegendPosition.top,
//         ),
//         trackballBehavior: TrackballBehavior(
//           enable: true,
//           tooltipAlignment: ChartAlignment.near,
//           tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
//           activationMode: ActivationMode.longPress,
//         ),
//         primaryXAxis: CategoryAxis(
//           majorGridLines: const MajorGridLines(width: 1),
//         ),
//         primaryYAxis: NumericAxis(
//           numberFormat: NumberFormat.compact(),
//           majorGridLines: const MajorGridLines(width: 1),
//         ),
//         series: <ColumnSeries<ChartData, String>>[
//           ColumnSeries<ChartData, String>(
//             dataSource: gridData,
//             xValueMapper: (ChartData data, _) => data.x, // Month/Year format
//             yValueMapper: (ChartData data, _) => data.y,
//             name: 'Grid (kWh)',
//             color:Color.lerp(const Color(0xFF66D6FF), const Color(0xFF4FA3CC),0.5)!,
//           ),
//           ColumnSeries<ChartData, String>(
//             dataSource: dieselGeneratorData,
//             xValueMapper: (ChartData data, _) => data.x, // Month/Year format
//             yValueMapper: (ChartData data, _) => data.y,
//             name: 'Diesel Generator (kWh)',
//             color: Color.lerp(const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!,
//           ),
//           ColumnSeries<ChartData, String>(
//             dataSource: solarData,
//             xValueMapper: (ChartData data, _) => data.x, // Month/Year format
//             yValueMapper: (ChartData data, _) => data.y,
//             name: 'Solar (kWh)',
//             color: Color.lerp(const Color(0xFFFFA500), const Color(0xFFFF7F00), 0.5)!,
//           ),
//           ColumnSeries<ChartData, String>(
//             dataSource: totalSourceData,
//             xValueMapper: (ChartData data, _) => data.x, // Month/Year format
//             yValueMapper: (ChartData data, _) => data.y,
//             name: 'Total Source (kWh)',
//             color: Colors.deepPurple,
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Helper method to process node data, sort it, and format as MMM/yy
//   List<ChartData> getNodeData(String nodeName, FilterOverAllWaterYearlyBarChartDataModel model) {
//     final List<ChartData> chartData = model.data
//         ?.where((entry) => entry.node == nodeName && entry.date != null)
//         .map((entry) {
//       final DateTime date = DateTime.parse(entry.date!);
//       final String formattedDate = DateFormat('MMM/yy').format(date); // Example: Dec/24, Jan/25
//       return ChartData(
//         x: formattedDate, // Use formatted date (MMM/yy)
//         y: entry.energy?.toDouble() ?? 0,
//       );
//     }).toList() ??
//         [];
//
//     // Sort data in ascending order (oldest month first, latest month last)
//     chartData.sort((a, b) {
//       DateTime dateA = DateFormat('MMM/yy').parse(a.x);
//       DateTime dateB = DateFormat('MMM/yy').parse(b.x);
//       return dateA.compareTo(dateB);
//     });
//
//     return chartData;
//   }
// }
//
// // Model for chart data
// class ChartData {
//   final String x; // Formatted as "Dec/24", "Jan/25"
//   final double y;
//
//   ChartData({required this.x, required this.y});
// }
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/source/water_source/controller/over_all_source_water_data_controller.dart';
import 'package:nz_fabrics/src/features/source/water_source/model/filter_over_all_yearly_bar_chart_data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverAllWaterYearlyBarChartWidget extends StatelessWidget {
  final FilterOverAllWaterYearlyBarChartDataModel barChartModel; // Changed to Yearly model
  final OverAllWaterSourceDataController controller;

  const OverAllWaterYearlyBarChartWidget({
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
                    // ColumnSeries<ChartData, String>(
                    //   dataSource: totalSourceData,
                    //   xValueMapper: (ChartData data, _) => DateFormat('MMM/yy').format(data.x), // Adjusted for yearly format
                    //   yValueMapper: (ChartData data, _) => data.y,
                    //   name: 'Total Source (m³)',
                    //   color: Colors.deepPurple,
                    // ),
                    ColumnSeries<ChartData, String>(
                      dataSource: subMersibleData,
                      xValueMapper: (ChartData data, _) => DateFormat('MMM/yy').format(data.x),
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'Sub Mersible (m³)',
                      color: const Color(0xFF66D6FF),
                    ),
                    ColumnSeries<ChartData, String>(
                      dataSource: wtpData,
                      xValueMapper: (ChartData data, _) => DateFormat('MMM/yy').format(data.x),
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

  List<ChartData> getNodeData(String nodeName, FilterOverAllWaterYearlyBarChartDataModel model) {
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