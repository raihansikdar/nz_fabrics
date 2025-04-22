
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_day_button_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';


class SplineChartWidget extends StatelessWidget {
  const SplineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime _today = DateTime.now();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: GetBuilder<AnalysisProDayButtonController>(
            builder: (controller) {
              // if (controller.allWaterSourceItems.isEmpty && controller.allWaterLoadItems.isEmpty) {
              //   return const CircularProgressIndicator();
              // }
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
              List<DGRChartData> _filteredData = [];
/* --------***********************************------------------ DGR Line Chart-------------------***************************----------------*/

              final List<DGRChartData> sourceChartData = controller.allSourceItems
                  .map((data) => DGRChartData(data.timedate!, data.power ?? 0.0, data.node ?? '',data.cost ?? 0.0))
                  .toList();


              final List<DGRChartData> loadChartData = controller.allLoadItems
                  .map((data) => DGRChartData(data.timedate!, data.power ?? 0.0, data.node ?? '',data.cost ?? 0.0))
                  .toList();



              final Map<String, List<DGRChartData>> groupedSourceData = {};
              for (var data in sourceChartData) {
                groupedSourceData.putIfAbsent(data.nodeName, () => []).add(data);
              }

              final Map<String, List<DGRChartData>> groupedLoadData = {};
              for (var data in loadChartData) {
                groupedLoadData.putIfAbsent(data.nodeName, () => []).add(data);
              }



              List<SplineSeries<DGRChartData, DateTime>> dgrSourceSeries = groupedSourceData.entries.map((entry) {
                return SplineSeries<DGRChartData, DateTime>(
                  dataSource: entry.value,
                  xValueMapper: (DGRChartData data, _) {
                    DateTime dateTime = data.timedate;
                    return dateTime.subtract(const Duration(hours: 6));
                  },
                  yValueMapper: (DGRChartData data, _) => double.parse(data.power.toStringAsFixed(2)),
                  name: entry.key,
                 // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();


              List<SplineSeries<DGRChartData, DateTime>> dgrLoadSeries = groupedLoadData.entries.map((entry) {
                return SplineSeries<DGRChartData, DateTime>(
                  dataSource: entry.value,
                  xValueMapper: (DGRChartData data, _) {
                    DateTime dateTime = data.timedate;
                    return dateTime.subtract(const Duration(hours: 6));
                  },
                  yValueMapper: (DGRChartData data, _) => double.parse(data.power.toStringAsFixed(2)),
                  name: entry.key,
                 // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              /* -------------------------- DGR Cost Line Chart-----------------------------------*/

              List<SplineSeries<DGRChartData, DateTime>> dgrSourceSeriesCost = groupedSourceData.entries.map((entry) {
                return SplineSeries<DGRChartData, DateTime>(
                  dataSource: entry.value,
                  xValueMapper: (DGRChartData data, _) {
                    DateTime dateTime = data.timedate;
                    return dateTime.subtract(const Duration(hours: 6));
                  },
                  yValueMapper: (DGRChartData data, _) => data.cost != null ? double.parse(data.cost.toStringAsFixed(2)) : 0.0,

                  name: entry.key,
                  // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              List<SplineSeries<DGRChartData, DateTime>> dgrLoadSeriesCost = groupedLoadData.entries.map((entry) {
                return SplineSeries<DGRChartData, DateTime>(
                  dataSource: entry.value,
                  xValueMapper: (DGRChartData data, _) {
                    DateTime dateTime = data.timedate;
                    return dateTime.subtract(const Duration(hours: 6));
                  },
                  yValueMapper: (DGRChartData data, _) => data.cost != null ? double.parse(data.cost.toStringAsFixed(2)) : 0.0,
                  name: entry.key,
                  // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();



/* -------------------*********************----------------- Water Line Chart--------------------***********************---------------*/

              final List<WaterChartData> waterSourceChartData = controller.allWaterSourceItems
                  .map((data) => WaterChartData(data.timedate!, data.instantFlow ?? 0, data.node ?? '',data.cost ?? 0.0))
                  .toList();

              final List<WaterChartData> waterLoadChartData = controller.allWaterLoadItems
                  .map((data) => WaterChartData(data.timedate!, data.instantFlow ?? 0, data.node ?? '',data.cost ?? 0.0))
                  .toList();


              final Map<String, List<WaterChartData>> waterGroupedSourceData = {};
              for (var data in waterSourceChartData) {
                waterGroupedSourceData.putIfAbsent(data.nodeName, () => []).add(data);
              }

              final Map<String, List<WaterChartData>> waterGroupedLoadData = {};
              for (var data in waterLoadChartData) {
                waterGroupedLoadData.putIfAbsent(data.nodeName, () => []).add(data);
              }

              List<SplineSeries<WaterChartData, DateTime>> waterSourceSeries = waterGroupedSourceData.entries.map((entry) {
                return SplineSeries<WaterChartData, DateTime>(
                  dataSource: entry.value,
                  xValueMapper: (WaterChartData data, _) {
                    DateTime dateTime = data.timedate;
                    return dateTime.subtract(const Duration(hours: 6));
                  },
                  yValueMapper: (WaterChartData data, _) => double.parse(data.instantFlow.toStringAsFixed(2)),
                  name: entry.key,
                 // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              List<SplineSeries<WaterChartData, DateTime>> waterLoadSeries = waterGroupedLoadData.entries.map((entry) {
                return SplineSeries<WaterChartData, DateTime>(
                  dataSource: entry.value,
                  xValueMapper: (WaterChartData data, _) {
                    DateTime dateTime = data.timedate;
                    return dateTime.subtract(const Duration(hours: 6));
                  },
                  yValueMapper: (WaterChartData data, _) => double.parse(data.instantFlow.toStringAsFixed(2)),
                  name: entry.key,
                 // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              /* -------------------------- Water Cost Line Chart-----------------------------------*/

              List<SplineSeries<WaterChartData, DateTime>> waterSourceSeriesCost = waterGroupedSourceData.entries.map((entry) {
                return SplineSeries<WaterChartData, DateTime>(
                  dataSource: entry.value,
                  xValueMapper: (WaterChartData data, _) {
                    DateTime dateTime = data.timedate;
                    return dateTime.subtract(const Duration(hours: 6));
                  },
                  yValueMapper: (WaterChartData data, _) => double.parse(data.cost.toStringAsFixed(2)),
                  name: entry.key,
                  // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              List<SplineSeries<WaterChartData, DateTime>> waterLoadSeriesCost = waterGroupedLoadData.entries.map((entry) {
                return SplineSeries<WaterChartData, DateTime>(
                  dataSource: entry.value,
                  xValueMapper: (WaterChartData data, _) {
                    DateTime dateTime = data.timedate;
                    return dateTime.subtract(const Duration(hours: 6));
                  },
                  yValueMapper: (WaterChartData data, _) => double.parse(data.cost.toStringAsFixed(2)),
                  name: entry.key,
                  // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();



/* --------*****************************------------------ Natural Gas Line Chart--------------------********************---------------*/

              final List<NaturalGasChartData> naturalSourceChartData = controller.allNaturalGasSourceItems
                  .map((data) => NaturalGasChartData(data.timedate!, data.instantFlow ?? 0, data.node ?? '', data.cost ?? 0.0))
                  .toList();

              final List<NaturalGasChartData> naturalGasLoadChartData = controller.allNaturalGasLoadItems
                  .map((data) => NaturalGasChartData(data.timedate!, data.instantFlow ?? 0, data.node ?? '', data.cost ?? 0.0))
                  .toList();


              final Map<String, List<NaturalGasChartData>> naturalGasGroupedSourceData = {};
              for (var data in naturalSourceChartData) {
                naturalGasGroupedSourceData.putIfAbsent(data.nodeName, () => []).add(data);
              }

              final Map<String, List<NaturalGasChartData>> naturalGasGroupedLoadData = {};
              for (var data in naturalGasLoadChartData) {
                naturalGasGroupedLoadData.putIfAbsent(data.nodeName, () => []).add(data);
              }

              List<SplineSeries<NaturalGasChartData, DateTime>> naturalGasSourceSeries = naturalGasGroupedSourceData.entries.map((entry) {
                return SplineSeries<NaturalGasChartData, DateTime>(
                  dataSource: entry.value,
                  xValueMapper: (NaturalGasChartData data, _) {
                    DateTime dateTime = data.timedate;
                    return dateTime.subtract(const Duration(hours: 6));
                  },
                  yValueMapper: (NaturalGasChartData data, _) => double.parse(data.instantFlow.toStringAsFixed(2)),
                  name: entry.key,
               //  dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              List<SplineSeries<NaturalGasChartData, DateTime>> naturalGasLoadSeries = naturalGasGroupedLoadData.entries.map((entry) {
                return SplineSeries<NaturalGasChartData, DateTime>(
                  dataSource: entry.value,
                  xValueMapper: (NaturalGasChartData data, _) {
                    DateTime dateTime = data.timedate;
                    return dateTime.subtract(const Duration(hours: 6));
                  },
                  yValueMapper: (NaturalGasChartData data, _) => double.parse(data.instantFlow.toStringAsFixed(2)),
                  name: entry.key,
                //  dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();


              /* -------------------------- Water Cost Line Chart-----------------------------------*/

              List<SplineSeries<NaturalGasChartData, DateTime>> naturalGasSourceSeriesCost = naturalGasGroupedSourceData.entries.map((entry) {
                return SplineSeries<NaturalGasChartData, DateTime>(
                  dataSource: entry.value,
                  xValueMapper: (NaturalGasChartData data, _) {
                    DateTime dateTime = data.timedate;
                    return dateTime.subtract(const Duration(hours: 6));
                  },
                  yValueMapper: (NaturalGasChartData data, _) => double.parse(data.cost.toStringAsFixed(2)),
                  name: entry.key,
                  //  dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              List<SplineSeries<NaturalGasChartData, DateTime>> naturalGasLoadSeriesCost = naturalGasGroupedLoadData.entries.map((entry) {
                return SplineSeries<NaturalGasChartData, DateTime>(
                  dataSource: entry.value,
                  xValueMapper: (NaturalGasChartData data, _) {
                    DateTime dateTime = data.timedate;
                    return dateTime.subtract(const Duration(hours: 6));
                  },
                  yValueMapper: (NaturalGasChartData data, _) => double.parse(data.cost.toStringAsFixed(2)),
                  name: entry.key,
                  //  dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();




              return SfCartesianChart(
                // primaryXAxis: DateTimeAxis(
                //   majorTickLines: const MajorTickLines(width: 5),
                //   minorTicksPerInterval: 0,
                //   minimum: DateTime(_today.year, _today.month, _today.day, 0, 0, 0),
                //   maximum: DateTime(_today.year, _today.month, _today.day, 24, 0, 0),
                //   intervalType: DateTimeIntervalType.hours,
                //   interval: 3,
                //   labelStyle: const TextStyle(fontSize: 10),
                //   labelFormat: '{value} ',
                //   majorGridLines: const MajorGridLines(width: 1),
                // ),
                primaryXAxis: DateTimeAxis(
                    majorGridLines: const MajorGridLines(width: 0.1, color: Colors.deepPurple),
                    dateFormat: DateFormat('dd/MM/yyyy HH:mm:ss '),
                    interval: determineInterval(_filteredData.length),
                    axisLabelFormatter: (axisLabelRenderArgs) {
                      final String text = DateFormat('dd/MM/yyyy').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              axisLabelRenderArgs.value.toInt()));
                      const TextStyle style =
                      TextStyle(color: Colors.teal, fontWeight: FontWeight.bold);
                      return ChartAxisLabel(text, style);
                    },
                    intervalType: DateTimeIntervalType.minutes,

                    minorGridLines:
                    const MinorGridLines(width: 0),
                    ),
                primaryYAxis: NumericAxis(
                  labelFormat: '{value}',
                ),
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  tooltipAlignment: ChartAlignment.near,
                  tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                  activationMode: ActivationMode.singleTap,
                ),

                // series: controller.selectedIndices.contains(0) ? <ChartSeries<DGRChartData, DateTime>>[...dgrSourceSeries, ...dgrLoadSeries]  :
                // controller.selectedIndices.contains(1)
                //     ? <ChartSeries<WaterChartData, DateTime>>[...waterSourceSeries, ...waterLoadSeries] :
                //     controller.selectedIndices.contains(2)
                //     ? <ChartSeries<NaturalGasChartData, DateTime>>[...naturalGasSourceSeries, ...naturalGasLoadSeries]
                //     :  controller.selectedIndices.contains([0,1]) ?  : <ChartSeries<WaterChartData, DateTime>>[],

                series: [
                  // If both 0 (DGR) and 1 (Water) are selected
                  if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(1)) ...[
                    ...dgrSourceSeries,
                    ...dgrLoadSeries,
                    ...waterSourceSeries,
                    ...waterLoadSeries,
                  ]

                 else if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(4)) ...[
                    ...dgrSourceSeries,
                    ...dgrLoadSeries,
                    ...dgrSourceSeriesCost,
                    ...dgrLoadSeriesCost,
                    ...waterSourceSeriesCost,
                    ...waterLoadSeriesCost,
                    ...naturalGasSourceSeriesCost,
                    ...naturalGasLoadSeriesCost,
                  ]

                  else if (controller.selectedIndices.contains(1) && controller.selectedIndices.contains(2)) ...[
                      ...waterSourceSeries,
                      ...waterLoadSeries,
                      ...naturalGasSourceSeries,
                      ...naturalGasLoadSeries,
                    ]

                  else if (controller.selectedIndices.contains(1) && controller.selectedIndices.contains(4)) ...[
                      ...waterSourceSeries,
                      ...waterLoadSeries,
                      ...dgrSourceSeriesCost,
                      ...dgrLoadSeriesCost,
                      ...waterSourceSeriesCost,
                      ...waterLoadSeriesCost,
                      ...naturalGasSourceSeriesCost,
                      ...naturalGasLoadSeriesCost,
                    ]

                  else if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(2)) ...[
                      ...dgrSourceSeries,
                      ...dgrLoadSeries,
                      ...naturalGasSourceSeries,
                      ...naturalGasLoadSeries,
                    ]

                  else if (controller.selectedIndices.contains(0) && controller.selectedIndices.contains(1) && controller.selectedIndices.contains(3)) ...[
                    ...dgrSourceSeries,
                    ...dgrLoadSeries,
                    ...waterSourceSeries,
                    ...waterLoadSeries,
                    ...naturalGasSourceSeries,
                    ...naturalGasLoadSeries,
                  ]

                  // If only 0 (DGR) is selected
                  else if (controller.selectedIndices.contains(0)) ...[
                    ...dgrSourceSeries,
                    ...dgrLoadSeries,
                  ]
                  // If only 1 (Water) is selected
                  else if (controller.selectedIndices.contains(1)) ...[
                      ...waterSourceSeries,
                      ...waterLoadSeries,
                    ]
                    // If 2 (Natural Gas) is selected
                    else if (controller.selectedIndices.contains(2)) ...[
                        ...naturalGasSourceSeries,
                        ...naturalGasLoadSeries,
                      ]
                    else if (controller.selectedIndices.contains(4)) ...[
                        ...dgrSourceSeriesCost,
                        ...dgrLoadSeriesCost,
                        ...waterSourceSeriesCost,
                        ...waterLoadSeriesCost,
                        ...naturalGasSourceSeriesCost,
                        ...naturalGasLoadSeriesCost,
                      ]
                      // If no items are selected, show an empty line graph
                      else if (controller.selectedIndices.isEmpty) ...[
                          SplineSeries<DGRChartData, DateTime>(
                            dataSource: [], // Empty data source
                            xValueMapper: (DGRChartData data, _) => data.timedate,
                            yValueMapper: (DGRChartData data, _) => data.power,
                            name: 'Empty Data',
                          ),
                        ],
                ],




              );
            },
          ),
        ),
      ),
    );
  }
}

class DGRChartData {
  DGRChartData(this.timedate, this.power, this.nodeName, this.cost);
  final DateTime timedate;
  final String nodeName;
  final double power;
  final double cost;
}


class WaterChartData {
  WaterChartData(this.timedate, this.instantFlow, this.nodeName, this.cost);
  final DateTime timedate;
  final String nodeName;
  final double instantFlow;
  final double cost;
}

class NaturalGasChartData {
  NaturalGasChartData(this.timedate, this.instantFlow, this.nodeName, this.cost);
  final DateTime timedate;
  final String nodeName;
  final double instantFlow;
  final double cost;
}