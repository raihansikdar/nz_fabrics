import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/natural_gas/natural_gas_yearly_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/power_and_energy/yearly_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/water/water_yearly_data_model.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';

class YearlyBarChartWidget extends StatelessWidget {
  final String elementName;
  final String viewName;
  final String screenName;
  final List<YearlyDataModel>? yearlyDataModelList;
  final List<WaterYearlyDataModel>? waterYearlyDataModelList;
  final List<NaturalGasYearlyDataModel>? naturalGasYearlyDataModelList;

  const YearlyBarChartWidget({super.key, required this.elementName, required this.screenName,  this.yearlyDataModelList, required this.viewName,  this.waterYearlyDataModelList, this.naturalGasYearlyDataModelList});

  @override
  Widget build(BuildContext context) {
    List<String> getMonths() {
      return [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
    }

    List<ChartData> initializeChartData() {
      return getMonths().map((month) => ChartData(month: month, energy: 0.0,cost: 0.0),).toList();
    }
    List<ChartData> chartData = initializeChartData();

    (yearlyDataModelList ?? []).forEach((data) {
      if (data.date != null) {
        DateTime date = DateTime.parse(data.date!);
        String month = getMonths()[date.month - 1];


        var chartItem = chartData.firstWhere((chartItem) => chartItem.month == month);
        chartItem.energy = data.energy ?? 0.0;
        chartItem.cost = data.cost ?? 0.0;
      }
    });



    List<WaterChartData> initializeWaterChartData() {
      return getMonths().map((month) => WaterChartData(month: month, instantFlow: 0.0,instantCost: 0.0),).toList();
    }
    List<WaterChartData> waterChartData = initializeWaterChartData();

    (waterYearlyDataModelList ?? []).forEach((data) {
      if (data.date != null) {
        DateTime date = DateTime.parse(data.date!);
        String month = getMonths()[date.month - 1];
        var waterChartItem = waterChartData.firstWhere((waterChartItem) => waterChartItem.month == month);
        waterChartItem.instantFlow = data.instantFlow ?? 0.0;
        waterChartItem.instantCost = data.cost ?? 0.0;
      }
    });

    List<NaturalGasChartData> initializeNaturalGasChartData() {
      return getMonths().map((month) => NaturalGasChartData(month: month, volume: 0.0,cost: 0.0),).toList();
    }
    List<NaturalGasChartData> naturalGasChartData = initializeNaturalGasChartData();

    (naturalGasYearlyDataModelList ?? []).forEach((data) {
      if (data.date != null) {
        DateTime date = DateTime.parse(data.date!);
        String month = getMonths()[date.month - 1];

        var naturalGasChartItem = naturalGasChartData.firstWhere((naturalGasChartItem) => naturalGasChartItem.month == month);
        naturalGasChartItem.volume = data.volume ?? 0.0;
        naturalGasChartItem.cost = data.cost ?? 0.0;
      }
    });



    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,

        body: Container(
          padding: EdgeInsets.all(size.height * k16TextSize),
          child: viewName == 'powerView' ? SfCartesianChart(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 15),
            trackballBehavior: TrackballBehavior(
              enable: true,
              tooltipAlignment: ChartAlignment.near,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              activationMode: ActivationMode.singleTap,
            ),
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              labelStyle: TextStyle(fontSize: size.height * k12TextSize, color: AppColors.primaryTextColor),
              labelRotation: 0,
              // For small screens, show fewer labels
              interval: MediaQuery.of(context).size.width < 360 ? 2 : 1,
              // Correctly format the axis labels
              axisLabelFormatter: (AxisLabelRenderDetails args) {
                String text = args.text;
                // Abbreviate to 3 letters
                String shortText = text.length > 3 ? text.substring(0, 3) : text;

                return ChartAxisLabel(
                  shortText,
                  args.textStyle,
                );
              },
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 1),
              numberFormat: NumberFormat.compact(),
              labelFormat: '{value}',
            ),
            series: screenName == 'waterScreen' ? <CartesianSeries>[
              ColumnSeries<WaterChartData, String>(
                color: AppColors.primaryColor,
                dataSource: waterChartData,
                xValueMapper: (WaterChartData data, _) => data.month,
                yValueMapper: (WaterChartData data, _) => data.instantFlow,
                name: 'Water Flow(m³/h)',
                width: 0.6,
                spacing: 0.2,
              ),
            ] : screenName == 'naturalGasScreen' ? <CartesianSeries>[
              ColumnSeries<NaturalGasChartData, String>(
                color: AppColors.primaryColor,
                dataSource: naturalGasChartData,
                xValueMapper: (NaturalGasChartData data, _) => data.month,
                yValueMapper: (NaturalGasChartData data, _) => data.volume,
                name: 'Gas Volume(cf)',
                width: 0.6,
                spacing: 0.2,
              ),
            ] : <CartesianSeries>[
              ColumnSeries<ChartData, String>(
                color: AppColors.primaryColor,
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.month,
                yValueMapper: (ChartData data, _) => data.energy,
                name: 'Energy(kWh)',
                width: 0.6,
                spacing: 0.2,
              ),
            ],
          ) : SfCartesianChart(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 15),
            trackballBehavior: TrackballBehavior(
              enable: true,
              tooltipAlignment: ChartAlignment.near,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              activationMode: ActivationMode.singleTap,
            ),
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
              labelStyle: TextStyle(fontSize: size.height * k12TextSize, color: AppColors.primaryTextColor),
              labelRotation: 0,
              // For small screens, show fewer labels
              interval: MediaQuery.of(context).size.width < 360 ? 2 : 1,
              // Correctly format the axis labels
              axisLabelFormatter: (AxisLabelRenderDetails args) {
                String text = args.text;
                // Abbreviate to 3 letters
                String shortText = text.length > 3 ? text.substring(0, 3) : text;

                return ChartAxisLabel(
                  shortText,
                  args.textStyle,
                );
              },
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 1),
              numberFormat: NumberFormat.compact(),
              labelFormat: '{value}',
            ),
            series: screenName == 'waterScreen' ? <CartesianSeries>[
              ColumnSeries<WaterChartData, String>(
                color: AppColors.primaryColor,
                dataSource: waterChartData,
                xValueMapper: (WaterChartData data, _) => data.month,
                yValueMapper: (WaterChartData data, _) => data.instantCost,
                name: 'Cost(BDT)',
                width: 0.6,
                spacing: 0.2,
              ),
            ] : screenName == 'naturalGasScreen' ? <CartesianSeries>[
              ColumnSeries<NaturalGasChartData, String>(
                color: AppColors.primaryColor,
                dataSource: naturalGasChartData,
                xValueMapper: (NaturalGasChartData data, _) => data.month,
                yValueMapper: (NaturalGasChartData data, _) => data.cost,
                name: 'Cost(BDT)',
                width: 0.6,
                spacing: 0.2,
              ),
            ] : <CartesianSeries>[
              ColumnSeries<ChartData, String>(
                color: AppColors.primaryColor,
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.month,
                yValueMapper: (ChartData data, _) => data.cost,
                name: 'Cost(BDT)',
                width: 0.6,
                spacing: 0.2,
              ),
            ],
          ),
        )


    );
  }
}

class ChartData {
  ChartData({
    required this.month,
    required this.energy,
    required this.cost,
  });

  final String month;
  double energy;
  double cost;
}

class WaterChartData {
  WaterChartData({
    required this.month,
    required this.instantFlow,
    required this.instantCost,
  });
  final String month;
  double instantFlow;
  double instantCost;
}

class NaturalGasChartData {
  NaturalGasChartData({
    required this.month,
    required this.volume,
    required this.cost,
  });
  final String month;
  double volume;
  double cost;
}