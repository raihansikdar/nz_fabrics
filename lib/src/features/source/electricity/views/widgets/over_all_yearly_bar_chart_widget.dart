import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/source/electricity/model/filter_over_all_yearly_bar_chart_data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';


class OverAllYearlyBarChartWidget extends StatelessWidget {
  final FilterOverAllYearlyBarChartDataModel barChartModel;

   OverAllYearlyBarChartWidget({super.key, required this.barChartModel});


  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
      enableDoubleTapZooming:true,
      );


  @override
  Widget build(BuildContext context) {
    final gridData = getNodeData('Grid', barChartModel);
    final dieselGeneratorData = getNodeData('Diesel_Generator', barChartModel);
    final solarData = getNodeData('Solar', barChartModel);
    final totalSourceData = getNodeData('Total_Source', barChartModel);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCartesianChart(
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.top,
        ),
        zoomPanBehavior: _zoomPanBehavior,
        trackballBehavior: TrackballBehavior(
          enable: true,
          tooltipAlignment: ChartAlignment.near,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
          activationMode: ActivationMode.longPress,
        ),
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 1),
        ),
        primaryYAxis: NumericAxis(
          numberFormat: NumberFormat.compact(),
          majorGridLines: const MajorGridLines(width: 1),
        ),
        series: <ColumnSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
            dataSource: gridData,
            xValueMapper: (ChartData data, _) => data.x, // Month/Year format
            yValueMapper: (ChartData data, _) => data.y,
            name: 'Grid (kWh)',
            color:Color.lerp(const Color(0xFF66D6FF), const Color(0xFF4FA3CC),0.5)!,
          ),
          ColumnSeries<ChartData, String>(
            dataSource: dieselGeneratorData,
            xValueMapper: (ChartData data, _) => data.x, // Month/Year format
            yValueMapper: (ChartData data, _) => data.y,
            name: 'Diesel Generator (kWh)',
            color: Color.lerp(const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!,
          ),
          ColumnSeries<ChartData, String>(
            dataSource: solarData,
            xValueMapper: (ChartData data, _) => data.x, // Month/Year format
            yValueMapper: (ChartData data, _) => data.y,
            name: 'Solar (kWh)',
            color: Color.lerp(const Color(0xFFFFA500), const Color(0xFFFF7F00), 0.5)!,
          ),
          ColumnSeries<ChartData, String>(
            dataSource: totalSourceData,
            xValueMapper: (ChartData data, _) => data.x, // Month/Year format
            yValueMapper: (ChartData data, _) => data.y,
            name: 'Total Source (kWh)',
            color: Colors.deepPurple,
          ),
        ],
      ),
    );
  }

  // Helper method to process node data, sort it, and format as MMM/yy
  List<ChartData> getNodeData(String nodeName, FilterOverAllYearlyBarChartDataModel model) {
    final List<ChartData> chartData = model.data
        ?.where((entry) => entry.node == nodeName && entry.date != null)
        .map((entry) {
      final DateTime date = DateTime.parse(entry.date!);
      final String formattedDate = DateFormat('MMM/yy').format(date); // Example: Dec/24, Jan/25
      return ChartData(
        x: formattedDate, // Use formatted date (MMM/yy)
        y: entry.energy?.toDouble() ?? 0,
      );
    }).toList() ??
        [];

    // Sort data in ascending order (oldest month first, latest month last)
    chartData.sort((a, b) {
      DateTime dateA = DateFormat('MMM/yy').parse(a.x);
      DateTime dateB = DateFormat('MMM/yy').parse(b.x);
      return dateA.compareTo(dateB);
    });

    return chartData;
  }
}

// Model for chart data
class ChartData {
  final String x; // Formatted as "Dec/24", "Jan/25"
  final double y;

  ChartData({required this.x, required this.y});
}
