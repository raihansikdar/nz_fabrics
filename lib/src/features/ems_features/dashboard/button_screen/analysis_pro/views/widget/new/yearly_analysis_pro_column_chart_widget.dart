// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:nz_ums/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_day_analysis_pro_controller.dart';
// import 'package:nz_ums/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/yearly_analysis_pro_filter_dgr_data_model.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// class ChartData {
//   final String monthYear;
//   final double energy;
//   final double cost;
//
//   ChartData(this.monthYear, this.energy, this.cost);
// }
//
// class AnalysisProYearlyColumnChartWidget extends StatelessWidget {
//   final List<YearlyDataModel> yearlySourceData;
//   final List<YearlyDataModel> yearlyLoadData;
//   final ElectricityDayAnalysisProController controller;
//
//   const AnalysisProYearlyColumnChartWidget({
//     super.key,
//     required this.yearlySourceData,
//     required this.yearlyLoadData,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> getMonths() {
//       return [
//         'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//         'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
//       ];
//     }
//
//     // Group source data by node and map to months with year
//     Map<String, List<ChartData>> groupedSourceData = {};
//     for (var data in yearlySourceData) {
//       final DateTime time = DateTime.parse(data.date ?? '');
//       final double energy = data.energy ?? 0.0;
//       final double cost = data.cost ?? 0.0;
//       final String node = data.node ?? '';
//       final String monthYear = '${getMonths()[time.month - 1]}/${time.year % 100}'; // Format: MMM/yy
//
//       groupedSourceData.putIfAbsent(node, () => []);
//       groupedSourceData[node]!.add(ChartData(monthYear, energy, cost));
//     }
//
//     // Group load data by node and map to months with year
//     Map<String, List<ChartData>> groupedLoadData = {};
//     for (var data in yearlyLoadData) {
//       final DateTime time = DateTime.parse(data.date ?? '');
//       final double energy = data.energy ?? 0.0;
//       final double cost = data.cost ?? 0.0;
//       final String node = data.node ?? '';
//       final String monthYear = '${getMonths()[time.month - 1]}/${time.year % 100}'; // Format: MMM/yy
//
//       groupedLoadData.putIfAbsent(node, () => []);
//       groupedLoadData[node]!.add(ChartData(monthYear, energy, cost));
//     }
//
//     // Create series for both source and load data
//     List<CartesianSeries<ChartData, String>> chartSeries = [];
//
//     // Add source data series
//     groupedSourceData.forEach((node, dataList) {
//       if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(2)) {
//         chartSeries.add(ColumnSeries<ChartData, String>(
//           dataSource: dataList,
//           xValueMapper: (ChartData data, _) => data.monthYear,
//           yValueMapper: (ChartData data, _) => data.energy,
//           name: '$node (Energy)',
//         ));
//         chartSeries.add(ColumnSeries<ChartData, String>(
//           dataSource: dataList,
//           xValueMapper: (ChartData data, _) => data.monthYear,
//           yValueMapper: (ChartData data, _) => data.cost,
//           name: '$node (Cost)',
//           color: Colors.red,
//         ));
//       } else if (controller.selectedIndices.contains(2)) {
//         chartSeries.add(ColumnSeries<ChartData, String>(
//           dataSource: dataList,
//           xValueMapper: (ChartData data, _) => data.monthYear,
//           yValueMapper: (ChartData data, _) => data.cost,
//           name: '$node (Cost)',
//           color: Colors.red,
//         ));
//       } else if (controller.selectedIndices.contains(0)) {
//         chartSeries.add(ColumnSeries<ChartData, String>(
//           dataSource: dataList,
//           xValueMapper: (ChartData data, _) => data.monthYear,
//           yValueMapper: (ChartData data, _) => data.energy,
//           name: '$node (Energy)',
//         ));
//       }
//     });
//
//     // Add load data series
//     groupedLoadData.forEach((node, dataList) {
//       if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(2)) {
//         chartSeries.add(ColumnSeries<ChartData, String>(
//           dataSource: dataList,
//           xValueMapper: (ChartData data, _) => data.monthYear,
//           yValueMapper: (ChartData data, _) => data.energy,
//           name: '$node (Energy)',
//           color: Colors.yellow,
//         ));
//         chartSeries.add(ColumnSeries<ChartData, String>(
//           dataSource: dataList,
//           xValueMapper: (ChartData data, _) => data.monthYear,
//           yValueMapper: (ChartData data, _) => data.cost,
//           name: '$node (Cost)',
//           color: Colors.green,
//         ));
//       } else if (controller.selectedIndices.contains(2)) {
//         chartSeries.add(ColumnSeries<ChartData, String>(
//           dataSource: dataList,
//           xValueMapper: (ChartData data, _) => data.monthYear,
//           yValueMapper: (ChartData data, _) => data.cost,
//           name: '$node (Cost)',
//           color: Colors.redAccent,
//         ));
//       } else if (controller.selectedIndices.contains(0)) {
//         chartSeries.add(ColumnSeries<ChartData, String>(
//           dataSource: dataList,
//           xValueMapper: (ChartData data, _) => data.monthYear,
//           yValueMapper: (ChartData data, _) => data.energy,
//           name: '$node (Energy)',
//           color: Colors.blue,
//         ));
//       }
//     });
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: SizedBox(
//         width: 1200,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SfCartesianChart(
//             primaryXAxis: CategoryAxis(
//               labelStyle: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
//               interval: 1,
//               majorGridLines: const MajorGridLines(width: 0),
//             ),
//             primaryYAxis: NumericAxis(
//               majorGridLines: const MajorGridLines(width: 1),
//               numberFormat: NumberFormat.compact(),
//               labelFormat: '{value}',
//             ),
//             series: chartSeries,
//             trackballBehavior: TrackballBehavior(
//               enable: true,
//               tooltipAlignment: ChartAlignment.near,
//               tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
//               activationMode: ActivationMode.longPress,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_day_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/yearly_analysis_pro_filter_dgr_data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final DateTime date;
  final String monthYear;
  final double energy;
  final double cost;

  ChartData(this.date, this.monthYear, this.energy, this.cost);
}

class AnalysisProYearlyColumnChartWidget extends StatelessWidget {
  final List<YearlyDataModel> yearlySourceData;
  final List<YearlyDataModel> yearlyLoadData;
  final ElectricityDayAnalysisProController controller;

  const AnalysisProYearlyColumnChartWidget({
    super.key,
    required this.yearlySourceData,
    required this.yearlyLoadData,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    List<String> getMonths() {
      return [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
    }

    // Group source data by node and map to months with year
    Map<String, List<ChartData>> groupedSourceData = {};
    for (var data in yearlySourceData) {
      final DateTime time = DateTime.parse(data.date ?? '');
      final double energy = data.energy ?? 0.0;
      final double cost = data.cost ?? 0.0;
      final String node = data.node ?? '';
      final String monthYear = '${getMonths()[time.month - 1]}/${time.year % 100}';

      groupedSourceData.putIfAbsent(node, () => []);
      groupedSourceData[node]!.add(ChartData(time, monthYear, energy, cost));
    }

    // Group load data by node and map to months with year
    Map<String, List<ChartData>> groupedLoadData = {};
    for (var data in yearlyLoadData) {
      final DateTime time = DateTime.parse(data.date ?? '');
      final double energy = data.energy ?? 0.0;
      final double cost = data.cost ?? 0.0;
      final String node = data.node ?? '';
      final String monthYear = '${getMonths()[time.month - 1]}/${time.year % 100}';

      groupedLoadData.putIfAbsent(node, () => []);
      groupedLoadData[node]!.add(ChartData(time, monthYear, energy, cost));
    }

    // Sort data by date in ascending order
    groupedSourceData.forEach((node, dataList) {
      dataList.sort((a, b) => a.date.compareTo(b.date));
    });

    groupedLoadData.forEach((node, dataList) {
      dataList.sort((a, b) => a.date.compareTo(b.date));
    });

    // Create series for both source and load data
    List<CartesianSeries<ChartData, String>> chartSeries = [];

    // Add source data series
    groupedSourceData.forEach((node, dataList) {
      if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(2)) {
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.monthYear,
          yValueMapper: (ChartData data, _) => data.energy,
          name: '$node (Energy)',
        ));
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.monthYear,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.red,
        ));
      } else if (controller.selectedIndices.contains(2)) {
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.monthYear,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.red,
        ));
      } else if (controller.selectedIndices.contains(0)) {
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.monthYear,
          yValueMapper: (ChartData data, _) => data.energy,
          name: '$node (Energy)',
        ));
      }
    });

    // Add load data series
    groupedLoadData.forEach((node, dataList) {
      if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(2)) {
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.monthYear,
          yValueMapper: (ChartData data, _) => data.energy,
          name: '$node (Energy)',
          color: Colors.yellow,
        ));
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.monthYear,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.green,
        ));
      } else if (controller.selectedIndices.contains(2)) {
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.monthYear,
          yValueMapper: (ChartData data, _) => data.cost,
          name: '$node (Cost)',
          color: Colors.redAccent,
        ));
      } else if (controller.selectedIndices.contains(0)) {
        chartSeries.add(ColumnSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, _) => data.monthYear,
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
