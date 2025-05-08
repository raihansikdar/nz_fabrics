import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/filter_specific_node_model/line_chart_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/filter_specific_node_model/monthly_bar_chart_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/filter_specific_node_model/yearly_bar_chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class FilterCostChartWidget extends StatelessWidget {
  final String graphType;
  final List<LineData> _lineChartDataList;
  final List<MonthlyBarChartData> _monthlyDataList;
  final List<YearlyBarChartData> _yearlyDataList;
  final Size size;

  const FilterCostChartWidget(
      this.size,
      this.graphType,
      this._lineChartDataList,
      this._monthlyDataList,
      this._yearlyDataList,
      );

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime now = DateTime.now();

    final List<LineChartData> chartData = _lineChartDataList
        .map((lineData) => LineChartData(
      dateTime: DateTime.parse(lineData.timedate!),
      cost: (lineData.cost ?? 0).toDouble(),
    ))
        .toList();

    final List<MonthlyChartData> monthlyChartData = _monthlyDataList
        .map((monthlyData) => MonthlyChartData(
      date: DateTime.parse(monthlyData.date!),
      cost: (monthlyData.cost ?? 0).toDouble(),
    ))
        .toList();

    // List<String> getMonths() {
    //   return [
    //     'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    //     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    //   ];
    // }
    //
    // List<YearlyChartData> initializeChartData() {
    //   return getMonths()
    //       .map((month) => YearlyChartData(month: month, cost: 0.0))
    //       .toList();
    // }
    //
    // List<YearlyChartData> yearlyChartData = initializeChartData();
    //
    // _yearlyDataList.forEach((data) {
    //   if (data.date != null) {
    //     DateTime date = DateTime.parse(data.date!);
    //     String month = getMonths()[date.month - 1];
    //
    //     var chartItem = yearlyChartData.firstWhere(
    //             (chartItem) => chartItem.month == month,
    //         orElse: () => YearlyChartData(month: month, cost: 0.0));
    //
    //     chartItem.cost = data.energy ?? 0.0;
    //   }
    // });


    //
    //
    //
    // // Initialize last 12 months for yearly chart
    // List<YearlyChartData> initializeChartData() {
    //   List<YearlyChartData> chartDataList = [];
    //   for (int i = 11; i >= 0; i--) {
    //     DateTime date = DateTime(now.year, now.month - i, 1);
    //     chartDataList.add(YearlyChartData(date: date, cost: 0.0));
    //   }
    //   return chartDataList;
    // }
    //
    // List<YearlyChartData> yearlyChartData = initializeChartData();
    //
    // // Update chart data with actual values from the API
    // for (var data in _yearlyDataList) {
    //   if (data.date != null) {
    //     DateTime date = DateTime.parse(data.date!);
    //     var chartItem = yearlyChartData.firstWhere(
    //           (chartItem) =>
    //       chartItem.date.year == date.year &&
    //           chartItem.date.month == date.month,
    //       orElse: () => YearlyChartData(date: date, cost: 0.0),
    //     );
    //     chartItem.cost = data.energy ?? 0.0;
    //   }
    // }

// Use the API data directly for the yearly chart
    final List<YearlyChartData> yearlyChartData = _yearlyDataList
        .map((yearlyData) => YearlyChartData(
      date: DateTime.parse(yearlyData.date!),
      cost: (yearlyData.energy ?? 0.0),
    ))
        .toList();


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
          ? SfCartesianChart(
        primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width: 0.1, color: Colors.deepPurple),
          dateFormat: DateFormat('dd/MM/yyyy HH:mm:ss '),
          interval: determineInterval(chartData.length),
          axisLabelFormatter: (axisLabelRenderArgs) {
            final String text = DateFormat('dd/MM/yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(
                    axisLabelRenderArgs.value.toInt()));
            const TextStyle style = TextStyle(
                color: Colors.teal, fontWeight: FontWeight.bold);
            return ChartAxisLabel(text, style);
          },
          intervalType: DateTimeIntervalType.minutes,
          minorGridLines: const MinorGridLines(width: 0),
        ),
        legend: const Legend(
          isVisible: false,
          position: LegendPosition.top,
        ),
      //  tooltipBehavior: TooltipBehavior(enable: true),
        trackballBehavior: TrackballBehavior(
          enable: true,
          tooltipAlignment: ChartAlignment.near,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
          activationMode: ActivationMode.longPress,
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 1),
          numberFormat: NumberFormat.compact(), // Format Y-axis as 1k, 2k, 4k
          labelFormat: '{value}', // Display as it is formatted
        ),
        series: <CartesianSeries<LineChartData, DateTime>>[
          SplineSeries<LineChartData, DateTime>(
            color: AppColors.primaryColor,
            dataSource: chartData,
            xValueMapper: (LineChartData data, _) => data.dateTime,
            yValueMapper: (LineChartData data, _) => data.cost,
            name: 'Cost(BDT)',
          )
        ],
      )
          : graphType == 'Monthly-Bar-Chart'
          ? SfCartesianChart(
      //  tooltipBehavior: TooltipBehavior(enable: true),
        trackballBehavior: TrackballBehavior(
          enable: true,
          tooltipAlignment: ChartAlignment.near,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
          activationMode: ActivationMode.longPress,
        ),
        legend: const Legend(
          isVisible: false,
          position: LegendPosition.top,
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 1),
          numberFormat: NumberFormat.compact(), // Format Y-axis as 1k, 2k, 4k
          labelFormat: '{value}', // Display as it is formatted
        ),
        primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat('dd/MMM'),
          majorGridLines: const MajorGridLines(width: 0),
         // minimum: DateTime(now.year, now.month, 1),
        //  maximum: DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1)),
          interval: 2,
          majorTickLines: const MajorTickLines(size: 0),
        ),
        series: <CartesianSeries>[
          ColumnSeries<MonthlyChartData, DateTime>(
            color: AppColors.primaryColor,
            dataSource: monthlyChartData,
            xValueMapper: (MonthlyChartData data, _) =>
            data.date,
            yValueMapper: (MonthlyChartData data, _) =>
            data.cost,
            name: 'Cost(BDT)',
          ),
        ],
      )
          : SfCartesianChart(
       // tooltipBehavior: TooltipBehavior(enable: true),
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
              color: AppColors.primaryTextColor),
        ),
        primaryYAxis: NumericAxis(
          majorGridLines: const MajorGridLines(width: 1),
          numberFormat: NumberFormat.compact(), // Format Y-axis as 1k, 2k, 4k
          labelFormat: '{value}', // Display as it is formatted
        ),
        // series: <CartesianSeries>[
        //   ColumnSeries<YearlyChartData, String>(
        //     color: AppColors.primaryColor,
        //     dataSource: yearlyChartData,
        //     xValueMapper: (YearlyChartData data, _) =>
        //     data.month,
        //     yValueMapper: (YearlyChartData data, _) =>
        //     data.cost,
        //     name: 'Cost(BDT)',
        //   ),
        // ],
        series: <CartesianSeries>[
          ColumnSeries<YearlyChartData, String>(
            color: AppColors.primaryColor,
            dataSource: yearlyChartData.reversed.toList(),
            xValueMapper: (YearlyChartData data, _) =>
                DateFormat('MMM/yy').format(data.date),
            yValueMapper: (YearlyChartData data, _) => data.cost,
            name: 'Cost(BDT)',
          ),
        ],

      ),
    );
  }
}
class LineChartData {
  final DateTime dateTime;
  final dynamic cost;

  LineChartData({required this.dateTime, required this.cost});
}

class MonthlyChartData {
  final DateTime date;
  final dynamic cost;

  MonthlyChartData({required this.date, required this.cost});
}

class YearlyChartData {
  final DateTime date;
  double cost;

  YearlyChartData({required this.date, this.cost = 0.0});
}
