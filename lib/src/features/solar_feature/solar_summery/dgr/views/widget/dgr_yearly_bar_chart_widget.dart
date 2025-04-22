
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/controllers/dgr_controller.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/model/dgr_yearly_bar_chart_model.dart';

class DgrYearlyBarChartWidget extends StatefulWidget {
  final DGRYearlyBarChartModel yearlyBarChartModel;

  const DgrYearlyBarChartWidget({super.key, required this.yearlyBarChartModel});

  @override
  State<DgrYearlyBarChartWidget> createState() => _DgrYearlyBarChartWidgetState();
}

class _DgrYearlyBarChartWidgetState extends State<DgrYearlyBarChartWidget> {
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
    if (data.isEmpty) return 10.0;
    double maxValue = data.map((d) => d.poaDayAvg).reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? maxValue * 1.1 : 10.0; // Add 10% padding
  }

  double calculateMaxPR(List<_ChartData> data) {
    if (data.isEmpty) return 10.0;
    double maxValue = data.map((d) => d.cumulativePr).reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? maxValue * 1.1 : 10.0; // Add 10% padding
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
    List<Data> chartData = widget.yearlyBarChartModel.data ?? [];
    List<_ChartData> formattedChartData = chartData.map((data) {
      DateTime? parsedDate;
      String formattedDate = '';
      try {
        parsedDate = DateFormat("yyyy-MM-dd").parse(data.date ?? '');
        formattedDate = DateFormat("MMM yyyy").format(parsedDate);
      } catch (e) {
        formattedDate = data.date ?? '';
      }
      return _ChartData(
        date: formattedDate,
        cumulativePr: safeToDouble(data.cumulativePr),
        poaDayAvg: safeToDouble(data.poaDayAvg),
        totalEnergy: safeToDouble(data.totalEnergy),
        maxAcPower: safeToDouble(data.maxAcPower),
      );
    }).toList();

    // Reverse the list to show most recent data first
    formattedChartData = formattedChartData.reversed.toList();

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
                          primaryXAxis: CategoryAxis(
                            majorGridLines: const MajorGridLines(width: 0),
                            labelAlignment: LabelAlignment.center,
                            labelStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
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
                            labelStyle: const TextStyle(color: AppColors.prColor),
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
                              labelStyle: const TextStyle(color:AppColors.acPowerColor),
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
                                  : 10,
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
                          series: <CartesianSeries<_ChartData, String>>[
                            if (_showPR)
                              ColumnSeries<_ChartData, String>(
                                name: 'Cumulative PR',
                                dataSource: formattedChartData,
                                xValueMapper: (_ChartData data, _) => data.date,
                                yValueMapper: (_ChartData data, _) => data.cumulativePr,
                                yAxisName: 'DynamicAxis',
                                color: AppColors.prColor,
                                legendItemText: 'Cumulative PR',
                              ),
                            if (_showAcPower)
                              ColumnSeries<_ChartData, String>(
                                name: 'Max AC Power (kW)',
                                dataSource: formattedChartData,
                                xValueMapper: (_ChartData data, _) => data.date,
                                yValueMapper: (_ChartData data, _) => data.maxAcPower,
                                yAxisName: 'AcPower',
                                color: AppColors.acPowerColor,
                                legendItemText: 'Max AC Power',
                              ),
                            if (_showPoaDayAvg)
                              ColumnSeries<_ChartData, String>(
                                name: 'POA Day Avg (kWh/m²)',
                                dataSource: formattedChartData,
                                xValueMapper: (_ChartData data, _) => data.date,
                                yValueMapper: (_ChartData data, _) => data.poaDayAvg,
                                yAxisName: 'PoaDayAvg',
                                color: AppColors.poaDayAvgColor,
                                legendItemText: 'POA Day Avg',
                              ),
                            if (_showEnergy)
                              ColumnSeries<_ChartData, String>(
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
                            color: AppColors.acPowerColor ,
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
                        transform: energyActive ? Matrix4.translationValues(-13, -8, 0) : Matrix4.translationValues(-13, -8, 0),
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
                        transform: Matrix4.translationValues(-33, 20, 0),
                        child: const Text(
                          'Energy',
                          style: TextStyle(
                            color: AppColors.energyColor,
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
}

class _ChartData {
  final String date;
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