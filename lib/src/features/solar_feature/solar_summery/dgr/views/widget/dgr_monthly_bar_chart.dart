// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/controllers/dgr_controller.dart';
// import 'package:nz_ums/src/utility/style/app_colors.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:intl/intl.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/model/dgr_monthly_chart_model.dart';
//
// class DgrMonthlyBarChart extends StatelessWidget {
//   final DGRMonthlyChartModel monthlyBarChartModel;
//
//   const DgrMonthlyBarChart({super.key, required this.monthlyBarChartModel});
//
//   @override
//   Widget build(BuildContext context) {
//     List<Data> chartData = monthlyBarChartModel.data ?? [];
//     List<Data> formattedChartData = chartData.map((data) {
//       try {
//         DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(data.date ?? '');
//         data.date = DateFormat("dd/MMM").format(parsedDate);
//       } catch (e) {
//         data.date = '';
//       }
//       return data;
//     }).toList();
//
//     return GetBuilder<DgrController>(
//       builder: (dgrController) {
//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Card(
//               color: AppColors.whiteTextColor,
//               child: SizedBox(
//                 width: 1500,
//                 child: SfCartesianChart(
//                   legend: const Legend(
//                     isVisible: true,
//                     overflowMode: LegendItemOverflowMode.wrap,
//                     position: LegendPosition.top,
//                   ),
//                   trackballBehavior: TrackballBehavior(
//                     enable: true,
//                     tooltipAlignment: ChartAlignment.near,
//                     tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
//                     activationMode: ActivationMode.longPress,
//                   ),
//                   primaryXAxis: CategoryAxis(
//                     isInversed: true,
//                   ),
//                   primaryYAxis: NumericAxis(
//                     name: 'DynamicAxis',
//                     majorGridLines: const MajorGridLines(width: 1),
//                     numberFormat: NumberFormat.compact(),
//                     labelFormat: '{value}',
//                   ),
//                   axes: <ChartAxis>[
//                     NumericAxis(
//                       name: 'FixedMaxAxis',
//                       opposedPosition: true,
//                       minimum: 0,
//                       maximum: 10, // Set fixed max value
//                       majorGridLines: const MajorGridLines(width: 1),
//                       numberFormat: NumberFormat.compact(),
//                       labelFormat: '{value}',
//                     ),
//                   ],
//                   series: <ChartSeries<Data, String>>[
//                     ColumnSeries<Data, String>(
//                       name: 'Cumulative PR',
//                       dataSource: formattedChartData,
//                       xValueMapper: (Data data, _) => data.date ?? '',
//                       yValueMapper: (Data data, _) => data.cumulativePr ?? 0.0,
//                       yAxisName: 'FixedMaxAxis',
//                       color: const Color(0xFF00AAF3),
//                       legendItemText: 'Cumulative PR',
//                     ),
//                     ColumnSeries<Data, String>(
//                       name: 'POA Day Avg (kWh/m²)',
//                       dataSource: formattedChartData,
//                       xValueMapper: (Data data, _) => data.date ?? '',
//                       yValueMapper: (Data data, _) => data.poaDayAvg ?? 0.0,
//                       yAxisName: 'FixedMaxAxis',
//                       color: const Color(0xFFFF9A00),
//                       legendItemText: 'POA Day Avg',
//                     ),
//                     ColumnSeries<Data, String>(
//                       name: 'Total Energy (kWh)',
//                       dataSource: formattedChartData,
//                       xValueMapper: (Data data, _) => data.date ?? '',
//                       yValueMapper: (Data data, _) => data.totalEnergy ?? 0.0,
//                       yAxisName: 'DynamicAxis',
//                       color: const Color(0xFF3CB64A),
//                       legendItemText: 'Total Energy',
//                     ),
//                     ColumnSeries<Data, String>(
//                       name: 'Max AC Power (kW)',
//                       dataSource: formattedChartData,
//                       xValueMapper: (Data data, _) => data.date ?? '',
//                       yValueMapper: (Data data, _) => data.maxAcPower ?? 0.0,
//                       yAxisName: 'DynamicAxis',
//                       color: Colors.deepPurple,
//                       legendItemText: 'Max AC Power',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/controllers/dgr_controller.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/model/dgr_monthly_chart_model.dart';

class DgrMonthlyBarChart extends StatefulWidget {
  final DGRMonthlyChartModel monthlyBarChartModel;

  const DgrMonthlyBarChart({super.key, required this.monthlyBarChartModel});

  @override
  State<DgrMonthlyBarChart> createState() => _DgrMonthlyBarChartState();
}

class _DgrMonthlyBarChartState extends State<DgrMonthlyBarChart> {
  bool _showPR = true;
  bool _showAcPower = false;
  bool _showEnergy = false;
  bool _showPoaDayAvg = false;

  bool acPowerOn = false;
  bool energyActive = false;

  // Safe conversion method to handle potential NaN/Infinity issues
  double safeToDouble(dynamic value) {
    if (value == null) return 0.0;
    try {
      double result = value is double ? value : double.parse(value.toString());
      if (result.isNaN || !result.isFinite) return 0.0;
      return result;
    } catch (e) {
      return 0.0;
    }
  }

  // Calculate maximum values
  double calculateMaxAcPower(List<_ChartData> data) {
    if (data.isEmpty) return 1000.0;
    double maxValue = data.map((d) => d.maxAcPower).reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? maxValue * 1.1 : 1000.0; // Add 10% padding
  }

  double calculateMaxEnergy(List<_ChartData> data) {
    if (data.isEmpty) return 1000.0;
    double maxValue = data.map((d) => d.totalEnergy).reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? maxValue * 1.1 : 1000.0; // Add 10% padding
  }

  double calculateMaxPoaDayAvg(List<_ChartData> data) {
    if (data.isEmpty) return 1000.0;
    double maxValue = data.map((d) => d.poaDayAvg).reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? maxValue * 1.1 : 1000.0; // Add 10% padding
  }

  double calculateMaxPR(List<_ChartData> data) {
    if (data.isEmpty) return 100.0;
    double maxValue = data.map((d) => d.cumulativePr).reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? maxValue * 1.1 : 100.0; // Add 10% padding
  }

  // Dynamically calculate the maximum for the primary Y-axis
  double _calculateDynamicMax(List<_ChartData> data) {
    if (data.isEmpty) return 1000.0;
    double maxValue = 0.0;
    if (_showPR) {
      maxValue = calculateMaxPR(data);
    } else if (_showAcPower) {
      maxValue = calculateMaxAcPower(data);
    } else if (_showEnergy) {
      maxValue = calculateMaxEnergy(data);
    } else if (_showPoaDayAvg) {
      maxValue = calculateMaxPoaDayAvg(data);
    }
    return maxValue > 0 ? maxValue * 1.1 : 1000.0; // Add 10% padding
  }

  @override
  Widget build(BuildContext context) {
    List<Data> chartData = widget.monthlyBarChartModel.data ?? [];
    List<_ChartData> formattedChartData = chartData.map((data) {
      DateTime? parsedDate;
      try {
        parsedDate = DateFormat("yyyy-MM-dd").parse(data.date ?? '');
      } catch (e) {
        parsedDate = DateTime.now(); // Fallback date
      }
      return _ChartData(
        date: parsedDate,
        cumulativePr: safeToDouble(data.cumulativePr),
        poaDayAvg: safeToDouble(data.poaDayAvg),
        totalEnergy: safeToDouble(data.totalEnergy),
        maxAcPower: safeToDouble(data.maxAcPower),
      );
    }).toList();

    // Sort data by date
    formattedChartData.sort((a, b) => a.date.compareTo(b.date));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Card(
        color: AppColors.whiteTextColor,
        elevation: 4,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  FilterChip(
                    label: const Text('PR',style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                    selected: _showPR,
                    onSelected: (selected) {
                      setState(() {
                        _showPR = selected;
                      });
                    },
                    selectedColor: AppColors.prColor.withOpacity(0.3),
                    checkmarkColor: AppColors.prColor,
                  ),
                  FilterChip(
                    label: const Text('Max AC Power',style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                    selected: _showAcPower,
                    onSelected: (selected) {
                      setState(() {
                        _showAcPower = selected;
                        acPowerOn = !acPowerOn;
                      });
                    },
                    selectedColor: AppColors.acPowerColor.withOpacity(0.3),
                    checkmarkColor: AppColors.acPowerColor,
                  ),

                  FilterChip(
                    label: const Text('Poa Day Avg',style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                    selected: _showPoaDayAvg,
                    onSelected: (selected) {
                      setState(() {
                        _showPoaDayAvg = selected;
                      });
                    },
                    selectedColor: AppColors.poaDayAvgColor.withOpacity(0.3),
                    checkmarkColor: AppColors.poaDayAvgColor,
                  ),

                  FilterChip(
                    label: const Text('Energy',style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                    selected: _showEnergy,
                    onSelected: (selected) {
                      setState(() {
                        _showEnergy = selected;
                        energyActive = !energyActive;
                      });
                    },
                    selectedColor: AppColors.energyColor.withOpacity(0.3),
                    checkmarkColor: AppColors.energyColor,
                  ),
                ],
              ),
            ),
            GetBuilder<DgrController>(
              builder: (dgrController) {
                return Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height:  MediaQuery.sizeOf(context).width > 500 ? MediaQuery.sizeOf(context).height * 0.48 : MediaQuery.sizeOf(context).height * 0.38,
                        width: MediaQuery.of(context).size.width - 16,
                        child: SfCartesianChart(
                          zoomPanBehavior: ZoomPanBehavior(
                            enablePanning: true,
                            zoomMode: ZoomMode.x,
                            enablePinching: true,
                            enableDoubleTapZooming: true,
                          ),
                          trackballBehavior: TrackballBehavior(
                            enable: true,
                            tooltipAlignment: ChartAlignment.near,
                            tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                            activationMode: ActivationMode.longPress,
                          ),
                          primaryXAxis: DateTimeAxis(
                            dateFormat: DateFormat('dd/MMM'),
                            majorGridLines: const MajorGridLines(width: 0),
                            interval: 1,
                            intervalType: DateTimeIntervalType.days,
                            labelAlignment: LabelAlignment.center,
                            axisLabelFormatter: (axisLabelRenderArgs) {
                              final String text = DateFormat('dd/MMM').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  axisLabelRenderArgs.value.toInt(),
                                ),
                              );
                              return ChartAxisLabel(
                                text,
                                TextStyle(
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                            initialVisibleMinimum: formattedChartData.isNotEmpty
                                ? formattedChartData.first.date
                                : null,
                            initialVisibleMaximum: formattedChartData.isNotEmpty
                                ? _determineVisibleMaximum(formattedChartData)
                                : null,
                          ),
                          primaryYAxis: NumericAxis(
                            name: 'DynamicAxis',
                            majorGridLines: const MajorGridLines(width: 1),
                            numberFormat: NumberFormat.compact(),
                            labelFormat: '{value}',
                            minimum: 0,
                            maximum: formattedChartData.isNotEmpty
                                ? _calculateDynamicMax(formattedChartData)
                                : 1000,
                            labelStyle: const TextStyle(color: AppColors.acPowerColor),
                            axisLabelFormatter: (AxisLabelRenderDetails args) {
                              double value = safeToDouble(args.text);
                              String formattedText = value >= 1000
                                  ? '${(value / 1000).toStringAsFixed(1)}k'
                                  : value.toStringAsFixed(1);
                              return ChartAxisLabel(formattedText, args.textStyle);
                            },
                          ),
                          axes: <ChartAxis>[
                            NumericAxis(
                              name: 'AcPower',
                              minimum: 0,
                              maximum: formattedChartData.isNotEmpty
                                  ? calculateMaxAcPower(formattedChartData)
                                  : 100,
                              labelStyle: const TextStyle(color: AppColors.acPowerColor),
                              isVisible: _showAcPower,
                              axisLabelFormatter: (AxisLabelRenderDetails args) {
                                double value = safeToDouble(args.text);
                                String formattedText = value >= 1000
                                    ? '${(value / 1000).toStringAsFixed(1)}k'
                                    : value.toStringAsFixed(1);
                                return ChartAxisLabel(formattedText, args.textStyle);
                              },
                            ),
                            NumericAxis(
                              name: 'PoaDayAvg',
                              opposedPosition: true,
                              minimum: 0,
                              maximum: formattedChartData.isNotEmpty
                                  ? calculateMaxPoaDayAvg(formattedChartData)
                                  : 100,
                              labelStyle: const TextStyle(color: AppColors.poaDayAvgColor),
                              isVisible: _showPoaDayAvg,
                              axisLabelFormatter: (AxisLabelRenderDetails args) {
                                double value = safeToDouble(args.text);
                                String formattedText = value >= 1000
                                    ? '${(value / 1000).toStringAsFixed(1)}k'
                                    : value.toStringAsFixed(1);
                                return ChartAxisLabel(formattedText, args.textStyle);
                              },
                            ),
                            NumericAxis(
                              name: 'Energy',
                              opposedPosition: true,
                              minimum: 0,
                              maximum: formattedChartData.isNotEmpty
                                  ? calculateMaxEnergy(formattedChartData)
                                  : 100,
                              labelStyle: const TextStyle(color: AppColors.energyColor),
                              isVisible: _showEnergy,
                              axisLabelFormatter: (AxisLabelRenderDetails args) {
                                double value = safeToDouble(args.text);
                                String formattedText = value >= 1000
                                    ? '${(value / 1000).toStringAsFixed(1)}k'
                                    : value.toStringAsFixed(1);
                                return ChartAxisLabel(formattedText, args.textStyle);
                              },
                            ),
                          ],
                          series: <CartesianSeries<_ChartData, DateTime>>[
                            if (_showPR)
                              ColumnSeries<_ChartData, DateTime>(
                                name: 'Cumulative PR',
                                dataSource: formattedChartData,
                                xValueMapper: (_ChartData data, _) => data.date,
                                yValueMapper: (_ChartData data, _) => data.cumulativePr,
                                yAxisName: 'DynamicAxis',
                                color: AppColors.prColor,
                                legendItemText: 'Cumulative PR',
                              ),
                            if (_showAcPower)
                              ColumnSeries<_ChartData, DateTime>(
                                name: 'Max AC Power (kW)',
                                dataSource: formattedChartData,
                                xValueMapper: (_ChartData data, _) => data.date,
                                yValueMapper: (_ChartData data, _) => data.maxAcPower,
                                yAxisName: 'AcPower',
                                color: AppColors.acPowerColor,
                                legendItemText: 'Max AC Power',
                              ),
                            if (_showPoaDayAvg)
                              ColumnSeries<_ChartData, DateTime>(
                                name: 'POA Day Avg (kWh/m²)',
                                dataSource: formattedChartData,
                                xValueMapper: (_ChartData data, _) => data.date,
                                yValueMapper: (_ChartData data, _) => data.poaDayAvg,
                                yAxisName: 'PoaDayAvg',
                                color: AppColors.poaDayAvgColor,
                                legendItemText: 'POA Day Avg',
                              ),
                            if (_showEnergy)
                              ColumnSeries<_ChartData, DateTime>(
                                name: 'Total Energy (kWh)',
                                dataSource: formattedChartData,
                                xValueMapper: (_ChartData data, _) => data.date,
                                yValueMapper: (_ChartData data, _) => data.totalEnergy,
                                yAxisName: 'Energy',
                                color: AppColors.energyColor,
                                legendItemText: 'Total Energy',
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(_showPR)
                    Transform.rotate(
                      angle: 90 * 3.14159 / 180,
                      child: Container(
                        transform: acPowerOn
                            ? Matrix4.translationValues(-45, -80, 0)
                            : Matrix4.translationValues(-45, -38, 0),
                        child: const Text(
                          'PR',
                          style: TextStyle(
                            color: AppColors.prColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (_showAcPower)
                    Transform.rotate(
                      angle: 90 * 3.14159 / 180,
                      child: Container(
                        transform: Matrix4.translationValues(-25, -7, 0),
                        child: const Text(
                          'AC Power',
                          style: TextStyle(
                            color: AppColors.acPowerColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  const Spacer(),

                  if (_showPoaDayAvg)
                    Transform.rotate(
                      angle: 90 * 3.14159 / 180,
                      child: Container(
                        transform: energyActive ?  Matrix4.translationValues(-12, -15, 0) : Matrix4.translationValues(-12, -15, 0),
                        child: const Text(
                          'Poa Day Avg',
                          style: TextStyle(
                            color: AppColors.poaDayAvgColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  if (_showEnergy)
                    Transform.rotate(
                      angle: 90 * 3.14159 / 180,
                      child: Container(
                        transform: Matrix4.translationValues(-30, 15, 0),
                        child: const Text(
                          'Energy',
                          style: TextStyle(
                            color:AppColors.energyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime? _determineVisibleMaximum(List<_ChartData> data) {
    if (data.isEmpty) return null;
    if (data.length <= 1) return data.last.date;

    final startDate = data.first.date;
    final endDate = data.last.date;

    const int maxVisibleDays = 15;
    if (data.length <= maxVisibleDays) return endDate;

    final totalDays = endDate.difference(startDate).inDays;
    if (totalDays <= maxVisibleDays) return endDate;

    try {
      return startDate.add(const Duration(days: maxVisibleDays));
    } catch (e) {
      return endDate;
    }
  }
}

class _ChartData {
  final DateTime date;
  final double cumulativePr;
  final double poaDayAvg;
  final double totalEnergy;
  final double maxAcPower;

  _ChartData({
    required this.date,
    required this.cumulativePr,
    required this.poaDayAvg,
    required this.totalEnergy,
    required this.maxAcPower,
  });
}
