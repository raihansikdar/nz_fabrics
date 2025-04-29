import 'dart:developer';

import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/natural_gas/natural_gas_daily_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/plot_line/machine_max_power_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/power_and_energy/daily_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/water/water_daily_data_model.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';

class DailyLineChartWidget extends StatelessWidget {

   const  DailyLineChartWidget({super.key, required this.elementName, this.dailyDataList,this.waterDailyDataList ,required this.screenName, required this.viewName, this.naturalGasDailyDataList,  this.machineMaxPowerModel });
   final String elementName;
   final String viewName;
    final List<DailyDataModel>? dailyDataList;
    final List<WaterDailyDataModel>? waterDailyDataList;
    final List<NaturalGasDailyDataModel>? naturalGasDailyDataList;
    final MachineMaxPowerModel? machineMaxPowerModel;
   final String screenName;

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    Size size = MediaQuery.of(context).size;


   // log("-------------->${machineMaxPowerModel?.machineMaxPower}");

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
            padding: EdgeInsets.all(size.height * k16TextSize),
            child: viewName== 'powerView' ?  SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat('dd-MMM-yyyy HH:mm:ss'),
                axisLabelFormatter: (axisLabelRenderArgs) {
                  final String text = DateFormat('HH:mm ').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      axisLabelRenderArgs.value.toInt(),
                    ),
                  );
                  TextStyle style = TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold);
                  return ChartAxisLabel(text, style);
                },
                majorTickLines: MajorTickLines(width: size.width * 0.005),
                minorTicksPerInterval: 0,
                minimum: DateTime(
                    today.year, today.month, today.day, 0, 0, 0),
                maximum: DateTime(
                    today.year, today.month, today.day, 24, 0, 0),
                intervalType: DateTimeIntervalType.hours,
                interval: 4,
                labelStyle:  TextStyle(fontSize: size.height * k10TextSize),
                labelFormat: '{value} ',
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
             /* primaryYAxis: NumericAxis(
                  majorGridLines: const MajorGridLines(width: 1),
                  numberFormat: NumberFormat.compact(), // Format Y-axis as 1k, 2k, 4k
                  labelFormat: '{value}', // Display as it is formatted
                  ),*/



              primaryYAxis: NumericAxis(
                majorGridLines: MajorGridLines(width: 1),
                numberFormat: NumberFormat.compact(),
                labelFormat: '{value}',
                plotBands: [
                  PlotBand(
                    start: machineMaxPowerModel?.machineMaxPower ?? 0.00,
                    end:  machineMaxPowerModel?.machineMaxPower ?? 0.00,
                    borderColor: AppColors.secondaryTextColor,
                    borderWidth: 2,
                   // dashArray: <double>[4, 5],
                    text: "Max Power (${machineMaxPowerModel?.machineMaxPower ?? 0.00})",
                    textAngle: 0,
                    horizontalTextAlignment: TextAnchor.end,
                    verticalTextAlignment: TextAnchor.start,
                  ),
                ],
              ),





              series: screenName == 'water' ?  <CartesianSeries>[
                SplineSeries<WaterDailyDataModel, DateTime>(
                  color: AppColors.primaryColor,
                  dataSource: waterDailyDataList ?? [],
                  xValueMapper: (WaterDailyDataModel data, _) {
                    DateTime originalTime = DateTime.parse(data.timedate ?? DateTime.now().toIso8601String());
                    return originalTime.subtract(const Duration(hours: 6));

                  },
                  yValueMapper: (WaterDailyDataModel data, _) => data.instantFlow ?? 0.0,
                  name: 'Water Flow(m³/s)',
                ),
              ] : screenName == 'naturalGasScreen' ?  <CartesianSeries>[
                SplineSeries<NaturalGasDailyDataModel, DateTime>(
                  color: AppColors.primaryColor,
                  dataSource: naturalGasDailyDataList ?? [],
                  xValueMapper: (NaturalGasDailyDataModel data, _) {

                    DateTime originalTime = DateTime.parse(data.timedate ?? DateTime.now().toIso8601String());
                    return originalTime.subtract(const Duration(hours: 6));

                  },
                  yValueMapper: (NaturalGasDailyDataModel data, _) => data.pressure ?? 0.0,
                  name: 'Gas Pressure(Pa)',
                ),
              ] : <CartesianSeries>[
              SplineSeries<DailyDataModel, DateTime>(
                color: AppColors.primaryColor,
            dataSource: dailyDataList ?? [],
            xValueMapper: (DailyDataModel data, _) {
              DateTime originalTime = DateTime.parse(data.timedate ?? DateTime.now().toIso8601String());
              return originalTime.subtract(const Duration(hours: 6));

            },
            yValueMapper: (DailyDataModel data, _) => data.power ?? 0.0,
            name: 'Power(kW)',
            ),
              ],

            ) : SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                dateFormat: DateFormat('HH:mm'),
                majorTickLines:  MajorTickLines(width: size.width * 0.005),
                minorTicksPerInterval: 0,
                minimum: DateTime(today.year, today.month, today.day, 0, 0, 0)
                    .subtract(const Duration(days: 1)),
                maximum: DateTime(today.year, today.month, today.day, 24, 0, 0)
                    .add(const Duration(days: 1)),
                intervalType: DateTimeIntervalType.hours,
                interval: 4,
                labelStyle:  TextStyle(fontSize: size.height * k10TextSize),
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
                numberFormat: NumberFormat.compact(), // Format Y-axis as 1k, 2k, 4k
                labelFormat: '{value}', // Display as it is formatted
              ),
              series: screenName == 'water' ?  <CartesianSeries>[
                SplineSeries<WaterDailyDataModel, DateTime>(
                  color: AppColors.primaryColor,
                  dataSource: waterDailyDataList ?? [],
                  xValueMapper: (WaterDailyDataModel data, _) {

                    DateTime originalTime = DateTime.parse(data.timedate ?? DateTime.now().toIso8601String());
                    return originalTime.subtract(const Duration(hours: 6));

                  },yValueMapper: (WaterDailyDataModel data, _) => data.cost ?? 0.0,
                  name: 'Cost(BDT)',
                ),
              ] : <CartesianSeries>[
                SplineSeries<DailyDataModel, DateTime>(
                  color: AppColors.primaryColor,
                  dataSource: dailyDataList ?? [],
                  xValueMapper: (DailyDataModel data, _) {
                  //  return DateTime.parse(data.timedate ?? DateTime.now().toIso8601String());
                    DateTime originalTime = DateTime.parse(data.timedate ?? DateTime.now().toIso8601String());
                    return originalTime.subtract(const Duration(hours: 6));

                  }, yValueMapper: (DailyDataModel data, _) => data.cost ?? 0.0,
                  name: 'Cost(BDT)',
                ),
              ],


            ),
          ),

    );
  }
}
