import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_day_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/daily_analysis_pro_filter_dgr_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final DateTime time;
  final double power;
  final double cost;

  ChartData(this.time, this.power, this.cost);
}


class AnalysisProLineChartWidget extends StatelessWidget {
  final List<DailyDataModel> sourceData;
  final List<DailyDataModel> loadData;
  final ElectricityDayAnalysisProController controller;

  const AnalysisProLineChartWidget({
    super.key,
    required this.sourceData,
    required this.loadData,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {

    double determineInterval(int dataLength) {
      if (dataLength > 720) {
        return 720.0;
      } else if (dataLength > 450) {
        return 450.0;
      } else if (dataLength > 360) {
        return 360.0;
      } else {
        return 240.0;
      }
    }






    // Group source data by node
    Map<String, List<ChartData>> groupedSourceData = {};
    for (var data in sourceData) {
      final DateTime time = DateTime.parse(data.timedate ?? '');
      final double power = data.power ?? 0.0;
      final double cost = data.cost ?? 0.0;
      final String node = data.node ?? '';

      if (groupedSourceData[node] == null) {
        groupedSourceData[node] = [];
      }

      groupedSourceData[node]!.add(ChartData(time, power, cost));
    }

    // Group load data by node
    Map<String, List<ChartData>> groupedLoadData = {};
    for (var data in loadData) {
      final DateTime time = DateTime.parse(data.timedate ?? '');
      final double power = data.power ?? 0.0;
      final double cost = data.cost ?? 0.0;
      final String node = data.node ?? '';

      if (groupedLoadData[node] == null) {
        groupedLoadData[node] = [];
      }

      groupedLoadData[node]!.add(ChartData(time, power, cost));
    }

    // Create series for both source and load data
    List<CartesianSeries<ChartData, DateTime>> chartSeries = [];

    // Add source data series
    groupedSourceData.forEach((node, dataList) {
      if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(2)) {
        // Add both power and cost lines
        chartSeries.add(SplineSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.power,
          name: '$node (Power)',
        ));
        chartSeries.add(SplineSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.teal,
        ));
      } else if (controller.selectedIndices.contains(2)) {
        // Show only cost line
        chartSeries.add(SplineSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.red,
        ));
      } else if (controller.selectedIndices.contains(0)) {
        // Show only power line
        chartSeries.add(SplineSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.power,
          name: '$node (Power)',
        ));
      }
    });


// Add load data series
    groupedLoadData.forEach((node, dataList) {
      if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(2)) {
        // Add both power and cost lines
        chartSeries.add(SplineSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.power,
          name: '$node (Power)',
        ));
        chartSeries.add(SplineSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.blue,
        ));
      } else if (controller.selectedIndices.contains(2)) {
        // Show only cost line
        chartSeries.add(SplineSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.blue,
        ));
      } else if (controller.selectedIndices.contains(0)) {
        // Show only power line
        chartSeries.add(SplineSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.power,
          name: '$node (Power)',
        ));
      }
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: controller.dateDifference > 3 ? 1800 : 1200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('dd-MM-yyyy hh:mm'),
              intervalType: DateTimeIntervalType.minutes,
              interval: determineInterval(sourceData.length),
              majorGridLines: const MajorGridLines(width: 0),
             // edgeLabelPlacement: EdgeLabelPlacement.shift,
             // rangePadding: ChartRangePadding.round,
             // labelAlignment: LabelAlignment.center,
              axisLabelFormatter: (axisLabelRenderArgs) {
                final String text = DateFormat('dd/MM/yyyy').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    axisLabelRenderArgs.value.toInt(),
                  ),
                );
                const TextStyle style =
                TextStyle(color: Colors.teal, fontWeight: FontWeight.bold);
                return ChartAxisLabel(text, style);
              },
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 1),
              numberFormat: NumberFormat.compact(),
              labelFormat: '{value}',
            ),
           // primaryYAxis: NumericAxis(),
            trackballBehavior: TrackballBehavior(
              enable: true,
              tooltipAlignment: ChartAlignment.near,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              activationMode: ActivationMode.longPress,
            ),
            series: chartSeries,
          ),
        ),
      ),
    );
  }
}

