import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/filter_specific_node_model/line_chart_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/filter_specific_node_model/monthly_bar_chart_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/filter_specific_node_model/yearly_bar_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';


class WaterFilterSpecificChartWidget extends StatelessWidget {
  final String graphType;
  final List<LineData> _lineChartDataList;
  final List<MonthlyBarChartData> _monthlyDataList;
  final List<YearlyBarChartData> _yearlyDataList;
  final int dateDifference;
  final Size size;

  const WaterFilterSpecificChartWidget(
      this.size,
      this.graphType,
      this._lineChartDataList,
      this._monthlyDataList,
      this._yearlyDataList,
      this.dateDifference, 
      );

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();


    // for(var date in _yearlyDataList){
    //   log(date.date!);
    // }

    // Process line chart data
    final List<LineChartData> chartData = _lineChartDataList
        .map((lineData) => LineChartData(
      dateTime: DateTime.parse(lineData.timedate!),
      power: (lineData.power ?? 0).toDouble(),
    ))
        .toList();

    // Process monthly bar chart data
    final List<MonthlyChartData> monthlyChartData = _monthlyDataList
        .map((monthlyData) => MonthlyChartData(
      date: DateTime.parse(monthlyData.date!),
      energy: (monthlyData.energy ?? 0).toDouble(),
    ))
        .toList();

    // Use the API data directly for the yearly chart
    final List<YearlyChartData> yearlyChartData = _yearlyDataList
        .map((yearlyData) => YearlyChartData(
      date: DateTime.parse(yearlyData.date!),
      energy: (yearlyData.energy ?? 0.0),
    ))
        .toList();

    // Determines the interval for the X-axis
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


    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: graphType == 'Line-Chart'
          ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: dateDifference >= 1 ? 1200 : MediaQuery.sizeOf(context).width - 30,
              child: SfCartesianChart(
                      primaryXAxis: DateTimeAxis(

              majorGridLines:
              const MajorGridLines(width: 0.1, color: Colors.deepPurple),
              dateFormat: DateFormat('dd/MM/yyyy HH:mm:ss '),
              interval: determineInterval(chartData.length),
              axisLabelFormatter: (axisLabelRenderArgs) {
                final String text = DateFormat('dd/MM/yyyy').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      axisLabelRenderArgs.value.toInt()),
                );
                return ChartAxisLabel(
                    text,
                    const TextStyle(
                        color: Colors.teal, fontWeight: FontWeight.bold));
              },
              intervalType: DateTimeIntervalType.minutes,
              minorGridLines: const MinorGridLines(width: 0),
                      ),
                      trackballBehavior: TrackballBehavior(
              enable: true,
              tooltipAlignment: ChartAlignment.near,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              activationMode: ActivationMode.longPress,
                      ),
                      primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 1),
              numberFormat: NumberFormat.compact(),
              labelFormat: '{value}',
                      ),
                      series: <CartesianSeries<LineChartData, DateTime>>[
              SplineSeries<LineChartData, DateTime>(
                color: AppColors.primaryColor,
                dataSource: chartData,
                xValueMapper: (LineChartData data, _) => data.dateTime,
                yValueMapper: (LineChartData data, _) => data.power,
                name: 'Power(kW)',
              )
                      ],
                    ),
            ),
          )
          : graphType == 'Monthly-Bar-Chart'
          ? SingleChildScrollView(
        scrollDirection: Axis.horizontal,
            child: SizedBox(
             width: dateDifference > 15 ? 2400 : 1200,
              child: SfCartesianChart(
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
              majorTickLines: const MajorTickLines(size: 0),
                      ),
                      primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 1),
              numberFormat: NumberFormat.compact(),
              labelFormat: '{value}',
                      ),
                      series: <CartesianSeries>[
              ColumnSeries<MonthlyChartData, DateTime>(
                color: AppColors.primaryColor,
                dataSource: monthlyChartData,
                xValueMapper: (MonthlyChartData data, _) => data.date,
                yValueMapper: (MonthlyChartData data, _) => data.energy,
                name: 'Energy(kWh)',
              ),
                      ],
                    ),
            ),
          )
          : SfCartesianChart(
        trackballBehavior: TrackballBehavior(
          enable: true,
          tooltipAlignment: ChartAlignment.near,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
          activationMode: ActivationMode.longPress,
        ),
        primaryXAxis: CategoryAxis(
          interval: 1,
          majorGridLines: const MajorGridLines(width: 0),
          labelStyle: TextStyle(
            fontSize: size.height * k13TextSize,
            color: AppColors.primaryTextColor,
          ),
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 1),
          numberFormat: NumberFormat.compact(),
          labelFormat: '{value}',
        ),
        series: <CartesianSeries>[
          ColumnSeries<YearlyChartData, String>(
            color: AppColors.primaryColor,
            dataSource: yearlyChartData.reversed.toList(),
            xValueMapper: (YearlyChartData data, _) =>
                DateFormat('MMM/yy').format(data.date),
            yValueMapper: (YearlyChartData data, _) => data.energy,
            name: 'Energy(kWh)',
          ),
        ],
      ),
    );
  }
}



// Model classes for charts
class LineChartData {
  final DateTime dateTime;
  final double power;

  LineChartData({required this.dateTime, required this.power});
}

class MonthlyChartData {
  final DateTime date;
  final double energy;

  MonthlyChartData({required this.date, required this.energy});
}

class YearlyChartData {
  final DateTime date;
  double energy;

  YearlyChartData({required this.date, this.energy = 0.0});
}
