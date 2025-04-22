import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_year_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/only_year_analysis_pro_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

/*class ChartData {
  final DateTime time;
  final double energy;
  final double cost;

  ChartData(this.time, this.energy, this.cost);
}

class OnlyAnalysisProYearlyColumnChartWidget extends StatelessWidget {
  final List<OnlyYearlyDgrData> yearlySourceData;
  final List<OnlyYearlyDgrData> yearlyLoadData;
  final ElectricityYearAnalysisProController controller;

  const OnlyAnalysisProYearlyColumnChartWidget({
    super.key,
    required this.yearlySourceData,
    required this.yearlyLoadData,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Group source data by node
    Map<String, List<ChartData>> groupedSourceData = {};
    for (var data in yearlySourceData) {
      final DateTime time = DateTime.parse(data.date ?? '');
      final double energy = data.energy ?? 0.0;
      final double cost = data.cost ?? 0.0;
      final String node = data.node ?? '';

      groupedSourceData.putIfAbsent(node, () => []);
      groupedSourceData[node]!.add(ChartData(time, energy, cost));
    }

    // Group load data by node
    Map<String, List<ChartData>> groupedLoadData = {};
    for (var data in yearlyLoadData) {
      final DateTime time = DateTime.parse(data.date ?? '');
      final double energy = data.energy ?? 0.0;
      final double cost = data.cost ?? 0.0;
      final String node = data.node ?? '';

      groupedLoadData.putIfAbsent(node, () => []);
      groupedLoadData[node]!.add(ChartData(time, energy, cost));
    }

    // Create series for both source and load data
    List<CartesianSeries<ChartData, DateTime>> chartSeries = [];

    // Add source data series
    groupedSourceData.forEach((node, dataList) {
      if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(2)) {
        // Add both energy and cost columns
        chartSeries.add(ColumnSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.energy,
          name: '$node (Energy)',
        ));
        chartSeries.add(ColumnSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.red,
        ));
      } else if (controller.selectedIndices.contains(2)) {
        // Show only cost column
        chartSeries.add(ColumnSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.red,
        ));
      } else if (controller.selectedIndices.contains(0)) {
        // Show only energy column
        chartSeries.add(ColumnSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.energy,
          name: '$node (Energy)',
        ));
      }
    });

    // Add load data series
    groupedLoadData.forEach((node, dataList) {
      if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(2)) {
        // Add both energy and cost columns
        chartSeries.add(ColumnSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.energy,
          name: '$node (Energy)',
          color: Colors.yellow,
        ));
        chartSeries.add(ColumnSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.green,
        ));
      } else if (controller.selectedIndices.contains(2)) {
        // Show only cost column
        chartSeries.add(ColumnSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.redAccent,
        ));
      } else if (controller.selectedIndices.contains(0)) {
        // Show only energy column
        chartSeries.add(ColumnSeries<ChartData, DateTime>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.time,
          yValueMapper: (ChartData data, _) => data.energy,
          name: '$node (Energy)',
          color: Colors.blue,
        ));
      }
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('dd-MM-yyyy'),
              intervalType: DateTimeIntervalType.days,
              interval: 10,
              axisLabelFormatter: (axisLabelRenderArgs) {
                final String text = DateFormat('MMM/yyyy').format(
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
            // legend: Legend(isVisible: true),
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
}*/

class ChartData {
  final String month;
  final double energy;
  final double cost;

  ChartData(this.month, this.energy, this.cost);
}

class OnlyAnalysisProYearlyColumnChartWidget extends StatelessWidget {
  final List<OnlyYearlyDgrData> yearlySourceData;
  final List<OnlyYearlyDgrData> yearlyLoadData;
  final ElectricityYearAnalysisProController controller;

  const OnlyAnalysisProYearlyColumnChartWidget({
    super.key,
    required this.yearlySourceData,
    required this.yearlyLoadData,
    required this.controller,
  });

  List<String> getMonths() {
    return [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Group source data by node and map to months
    Map<String, List<ChartData>> groupedSourceData = {};
    for (var data in yearlySourceData) {
      final DateTime time = DateTime.parse(data.date ?? '');
      final double energy = data.energy ?? 0.0;
      final double cost = data.cost ?? 0.0;
      final String node = data.node ?? '';
      final String month = getMonths()[time.month - 1];

      groupedSourceData.putIfAbsent(node, () => []);
      groupedSourceData[node]!.add(ChartData(month, energy, cost));
    }

    // Group load data by node and map to months
    Map<String, List<ChartData>> groupedLoadData = {};
    for (var data in yearlyLoadData) {
      final DateTime time = DateTime.parse(data.date ?? '');
      final double energy = data.energy ?? 0.0;
      final double cost = data.cost ?? 0.0;
      final String node = data.node ?? '';
      final String month = getMonths()[time.month - 1];

      groupedLoadData.putIfAbsent(node, () => []);
      groupedLoadData[node]!.add(ChartData(month, energy, cost));
    }

    // Create series for both source and load data
    List<CartesianSeries<ChartData, String>> chartSeries = [];

    // Add source data series
    groupedSourceData.forEach((node, dataList) {
      if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(2)) {
        // Add both energy and cost columns
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.energy,
          name: '$node (Energy)',
        ));
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.red,
        ));
      } else if (controller.selectedIndices.contains(2)) {
        // Show only cost column
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.red,
        ));
      } else if (controller.selectedIndices.contains(0)) {
        // Show only energy column
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.energy,
          name: '$node (Energy)',
        ));
      }
    });

    // Add load data series
    groupedLoadData.forEach((node, dataList) {
      if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(2)) {
        // Add both energy and cost columns
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.energy,
          name: '$node (Energy)',
          color: Colors.yellow,
        ));
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.green,
        ));
      } else if (controller.selectedIndices.contains(2)) {
        // Show only cost column
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.redAccent,
        ));
      } else if (controller.selectedIndices.contains(0)) {
        // Show only energy column
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.month,
          yValueMapper: (ChartData data, _) => data.energy,
          name: '$node (Energy)',
          color: Colors.blue,
        ));
      }
    });

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(
              labelStyle: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
              interval: 1,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 1),
              numberFormat: NumberFormat.compact(),
              labelFormat: '{value}',
            ),
            series: chartSeries,
            trackballBehavior: TrackballBehavior(
              enable: true,
              tooltipAlignment: ChartAlignment.near,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              activationMode: ActivationMode.longPress,
            ),
          ),
        ),
      ),
    );
  }
}
