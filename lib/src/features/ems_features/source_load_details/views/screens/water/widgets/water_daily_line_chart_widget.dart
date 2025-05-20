import 'dart:developer';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/water/water_daily_data_model.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';

class WaterDailyLineChartWidget extends StatelessWidget {
  const WaterDailyLineChartWidget({
    super.key,
    required this.elementName,
    required this.waterDailyDataList,
    required this.viewName,
  });

  final String elementName;
  final String viewName;
  final List<WaterDailyDataModel>? waterDailyDataList;

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    Size size = MediaQuery.of(context).size;

    // Filter out invalid data and sort the list by timestamp
    final List<WaterDailyDataModel> sortedData = (waterDailyDataList ?? [])
        .where((data) => data.timedate != null)
        .toList()
      ..sort((a, b) =>
          DateTime.parse(a.timedate!).compareTo(DateTime.parse(b.timedate!)));

    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Container(
          padding: EdgeInsets.all(size.height * k16TextSize),
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat(viewName == 'powerView'
                  ? 'dd-MMM-yyyy HH:mm:ss'
                  : 'HH:mm'),
              axisLabelFormatter: viewName == 'powerView'
                  ? (axisLabelRenderArgs) {
                final String text = DateFormat('HH:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    axisLabelRenderArgs.value.toInt(),
                  ),
                );
                TextStyle style = TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold);
                return ChartAxisLabel(text, style);
              }
                  : null,
              majorTickLines: MajorTickLines(width: size.width * 0.005),
              minorTicksPerInterval: 0,
              minimum: DateTime(today.year, today.month, today.day, 0, 0, 0).add(const Duration(hours: 6)),
              maximum: DateTime(today.year, today.month, today.day, 23, 59, 59).add(const Duration(hours: 6)),
              intervalType: DateTimeIntervalType.hours,
              interval: 4,
              labelStyle: TextStyle(fontSize: size.height * k10TextSize),
              labelFormat: '{value}',
              majorGridLines: const MajorGridLines(width: 1),
            ),
            legend: const Legend(
              isVisible: false,
              position: LegendPosition.top,
            ),
            trackballBehavior: TrackballBehavior(
              enable: true,
              tooltipAlignment: ChartAlignment.near,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              activationMode: ActivationMode.singleTap,
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 1),
              numberFormat: NumberFormat.compact(),
              labelFormat: '{value}',
            ),
            series: <CartesianSeries>[
              SplineSeries<WaterDailyDataModel, DateTime>(
                color: AppColors.primaryColor,
                dataSource: sortedData,
                xValueMapper: (WaterDailyDataModel data, _) {
                  DateTime originalTime = DateTime.parse(data.timedate!); // safe due to filter
                  return originalTime;
                },
                yValueMapper: (WaterDailyDataModel data, _) =>
                viewName == 'powerView'
                    ? data.instantFlow ?? 0.0
                    : data.cost ?? 0.0,
                name: viewName == 'powerView'
                    ? 'Water Flow(m³/h)'
                    : 'Cost(BDT)',
              ),
            ],
          ),
        ),
        );
    }

}