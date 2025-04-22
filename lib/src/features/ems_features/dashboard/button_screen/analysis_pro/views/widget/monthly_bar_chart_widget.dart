
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_monthly_button_controller.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';


class MonthlyBarChartWidget extends StatelessWidget {
  const MonthlyBarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // DateTime today = DateTime.now();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: size.height * k8TextSize, right: size.height * k8TextSize),
          child: GetBuilder<AnalysisProMonthlyButtonController>(
            builder: (controller) {
              // if (controller.allWaterSourceItems.isEmpty && controller.allWaterLoadItems.isEmpty) {
              //   return const CircularProgressIndicator();
              // }
/* --------***********************************------------------ DGR Line Chart-------------------***************************----------------*/

              final List<DGRChartData> sourceChartData = controller.allSourceItems
                  .map((data) => DGRChartData(data.timedate!, data.energy ?? 0.0, data.node ?? '',data.cost ?? 0.0))
                  .toList();


              final List<DGRChartData> loadChartData = controller.allLoadItems
                  .map((data) => DGRChartData(data.timedate!, data.energy ?? 0.0, data.node ?? '',data.cost ?? 0.0))
                  .toList();



              final Map<String, List<DGRChartData>> groupedSourceData = {};
              for (var data in sourceChartData) {
                groupedSourceData.putIfAbsent(data.nodeName, () => []).add(data);
              }

              final Map<String, List<DGRChartData>> groupedLoadData = {};
              for (var data in loadChartData) {
                groupedLoadData.putIfAbsent(data.nodeName, () => []).add(data);
              }

              int selectedMonth = DateTime.now().month;
              int selectedYear = DateTime.now().year;
              int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;  // Get the number of days in the month

              List<ColumnSeries<DGRChartData, num>> dgrSourceSeries = groupedSourceData.entries.map((entry) {
                return ColumnSeries<DGRChartData, num>(
                  dataSource: entry.value,
                  xValueMapper: (DGRChartData data, _) => data.timedate.day,  // Correct class used here
                  yValueMapper: (DGRChartData data, _) => double.parse(data.energy.toStringAsFixed(2)),  // Numeric value on the y-axis
                  name: entry.key,
                  // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();


              List<ColumnSeries<DGRChartData, num>> dgrLoadSeries = groupedLoadData.entries.map((entry) {
                return ColumnSeries<DGRChartData, num>(
                  dataSource: entry.value,
                  xValueMapper: (DGRChartData data, _) => data.timedate.day,  // Correct class used here
                  yValueMapper: (DGRChartData data, _) => double.parse(data.energy.toStringAsFixed(2)),
                  name: entry.key,
                  // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              /* -------------------------- DGR Cost Line Chart-----------------------------------*/

              List<ColumnSeries<DGRChartData, num>> dgrSourceSeriesCost = groupedSourceData.entries.map((entry) {
                return ColumnSeries<DGRChartData, num>(
                  dataSource: entry.value,
                  xValueMapper: (DGRChartData data, _) => data.timedate.day,  // Correct class used here

                  yValueMapper: (DGRChartData data, _) => data.cost != null ? double.parse(data.cost.toStringAsFixed(2)) : 0.0,

                  name: entry.key,
                  // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              List<ColumnSeries<DGRChartData, num>> dgrLoadSeriesCost = groupedLoadData.entries.map((entry) {
                return ColumnSeries<DGRChartData, num>(
                  dataSource: entry.value,
                  xValueMapper: (DGRChartData data, _) => data.timedate.day,  // Correct class used here

                  yValueMapper: (DGRChartData data, _) => data.cost != null ? double.parse(data.cost.toStringAsFixed(2)) : 0.0,
                  name: entry.key,
                  // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();



/* -------------------*********************----------------- Water Line Chart--------------------**************************---------------*/

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

              List<ColumnSeries<WaterChartData, num>> waterSourceSeries = waterGroupedSourceData.entries.map((entry) {
                return ColumnSeries<WaterChartData, num>(
                  dataSource: entry.value,
                  xValueMapper: (WaterChartData data, _) => data.timedate.day,  // Correct class used here

                  yValueMapper: (WaterChartData data, _) => double.parse(data.instantFlow.toStringAsFixed(2)),
                  name: entry.key,
                  // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              List<ColumnSeries<WaterChartData, num>> waterLoadSeries = waterGroupedLoadData.entries.map((entry) {
                return ColumnSeries<WaterChartData, num>(
                  dataSource: entry.value,
                  xValueMapper: (WaterChartData data, _) => data.timedate.day,  // Correct class used here

                  yValueMapper: (WaterChartData data, _) => double.parse(data.instantFlow.toStringAsFixed(2)),
                  name: entry.key,
                  // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              /* -------------------------- Water Cost Line Chart-----------------------------------*/

              List<ColumnSeries<WaterChartData, num>> waterSourceSeriesCost = waterGroupedSourceData.entries.map((entry) {
                return ColumnSeries<WaterChartData, num>(
                  dataSource: entry.value,
                  xValueMapper: (WaterChartData data, _) => data.timedate.day,  // Correct class used here

                  yValueMapper: (WaterChartData data, _) => double.parse(data.cost.toStringAsFixed(2)),
                  name: entry.key,
                  // dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              List<ColumnSeries<WaterChartData, num>> waterLoadSeriesCost = waterGroupedLoadData.entries.map((entry) {
                return ColumnSeries<WaterChartData, num>(
                  dataSource: entry.value,
                  xValueMapper: (WaterChartData data, _) => data.timedate.day,  // Correct class used here

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

              List<ColumnSeries<NaturalGasChartData, num>> naturalGasSourceSeries = naturalGasGroupedSourceData.entries.map((entry) {
                return ColumnSeries<NaturalGasChartData, num>(
                  dataSource: entry.value,
                  xValueMapper: (NaturalGasChartData data, _) => data.timedate.day,  // Correct class used here

                  yValueMapper: (NaturalGasChartData data, _) => double.parse(data.instantFlow.toStringAsFixed(2)),
                  name: entry.key,
                  //  dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              List<ColumnSeries<NaturalGasChartData, num>> naturalGasLoadSeries = naturalGasGroupedLoadData.entries.map((entry) {
                return ColumnSeries<NaturalGasChartData, num>(
                  dataSource: entry.value,
                  xValueMapper: (NaturalGasChartData data, _) => data.timedate.day,  // Correct class used here

                  yValueMapper: (NaturalGasChartData data, _) => double.parse(data.instantFlow.toStringAsFixed(2)),
                  name: entry.key,
                  //  dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();


              /* -------------------------- Water Cost Line Chart-----------------------------------*/

              List<ColumnSeries<NaturalGasChartData, num>> naturalGasSourceSeriesCost = naturalGasGroupedSourceData.entries.map((entry) {
                return ColumnSeries<NaturalGasChartData, num>(
                  dataSource: entry.value,
                  xValueMapper: (NaturalGasChartData data, _) => data.timedate.day,  // Correct class used here

                  yValueMapper: (NaturalGasChartData data, _) => double.parse(data.cost.toStringAsFixed(2)),
                  name: entry.key,
                  //  dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();

              List<ColumnSeries<NaturalGasChartData, num>> naturalGasLoadSeriesCost = naturalGasGroupedLoadData.entries.map((entry) {
                return ColumnSeries<NaturalGasChartData, num>(
                  dataSource: entry.value,
                  xValueMapper: (NaturalGasChartData data, _) => data.timedate.day,  // Correct class used here

                  yValueMapper: (NaturalGasChartData data, _) => double.parse(data.cost.toStringAsFixed(2)),
                  name: entry.key,
                  //  dataLabelSettings: const DataLabelSettings(isVisible: true),
                );
              }).toList();
              return SfCartesianChart(
                primaryXAxis: NumericAxis(
                  minimum: 1,
                  maximum: daysInMonth.toDouble(), // Set the maximum dynamically based on the month
                  interval: 2,
                ),
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  tooltipAlignment: ChartAlignment.near,
                  tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                  activationMode: ActivationMode.singleTap,
                ),
                primaryYAxis: NumericAxis(
                  // labelFormat: '{value} kWh', // Use this to format the values and append 'kWh'
                ),
                axes: <ChartAxis>[
                  NumericAxis(
                    opposedPosition: true,
                    name: 'SecondaryAxis',
                    numberFormat: NumberFormat.compactCurrency(symbol: '৳'),
                  ),
                ],


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
                                      ColumnSeries<DGRChartData, DateTime>(
                                        dataSource: [], // Empty data source
                                        xValueMapper: (DGRChartData data, _) => data.timedate,
                                        yValueMapper: (DGRChartData data, _) => data.energy,
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
  DGRChartData(this.timedate, this.energy, this.nodeName, this.cost);
  final DateTime timedate;
  final String nodeName;
  final double energy;
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