import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/source/electricity/model/filter_over_all_line_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverAllLineChartDataWidget extends StatelessWidget {
  final FilterOverAllLineChartModel lineChartModel;
   OverAllLineChartDataWidget({super.key, required this.lineChartModel});



  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
      enableDoubleTapZooming:true,
      );


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
                  zoomPanBehavior: _zoomPanBehavior,
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