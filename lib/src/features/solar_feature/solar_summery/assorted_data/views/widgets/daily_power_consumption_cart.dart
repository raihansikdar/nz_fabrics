import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/controllers/daily_power_consumption_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/model/plant_today_data_model.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DailyPowerConsumptionCart extends StatefulWidget {
  const DailyPowerConsumptionCart({super.key});

  @override
  State<DailyPowerConsumptionCart> createState() => _DailyPowerConsumptionCartState();
}

class _DailyPowerConsumptionCartState extends State<DailyPowerConsumptionCart> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<DailyPowerConsumptionController>().fetchPlantTodayData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _today = DateTime.now();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
      body: GetBuilder<DailyPowerConsumptionController>(
        builder: (dailyPowerConsumptionController) {
          return SfCartesianChart(
            //title: ChartTitle(text: 'Daily Power Consumption'),
            legend: const Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
              position: LegendPosition.top,
            ),
            trackballBehavior: TrackballBehavior(
                enable: true,
                tooltipAlignment: ChartAlignment.near,
                tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                activationMode: ActivationMode.singleTap,
                ),
            // primaryXAxis: DateTimeAxis(
            //   title: AxisTitle(text: 'Time'),
            //   edgeLabelPlacement: EdgeLabelPlacement.shift,
            // ),
            primaryXAxis: DateTimeAxis(
              dateFormat: DateFormat('HH:mm '),
              majorTickLines: MajorTickLines(width: size.height * 0.005),
              minorTicksPerInterval: 0,
              minimum: DateTime(
                  _today.year, _today.month, _today.day, 0, 0, 0),
              maximum: DateTime(
                  _today.year, _today.month, _today.day, 24, 0, 0),
              intervalType: DateTimeIntervalType.hours,
              interval: 1,
              labelStyle: TextStyle(fontSize: size.height * k10TextSize),
              labelFormat: '{value} ',
             /// majorGridLines: const MajorGridLines(width: 1),
            ),
            // primaryYAxis: NumericAxis(
            //   title: AxisTitle(text: 'Irradiance (East)'),
            // ),
            series: <CartesianSeries>[
              SplineSeries<PlantTodayDataModel, DateTime>(
                name: 'Radiation East(W/m²)',
                legendItemText: 'Radiation East',
                dataSource: dailyPowerConsumptionController.plantLiveDataModel,
                xValueMapper: (PlantTodayDataModel data, _) => data.timedate?.subtract(const Duration(hours: 6)),
                yValueMapper: (PlantTodayDataModel data, _) => data.irrEast,
               // dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
              SplineSeries<PlantTodayDataModel, DateTime>(
                name: 'Radiation West(W/m²)',
                legendItemText: 'Radiation West',
                dataSource: dailyPowerConsumptionController.plantLiveDataModel,
                xValueMapper: (PlantTodayDataModel data, _) => data.timedate?.subtract(const Duration(hours: 6)),
                yValueMapper: (PlantTodayDataModel data, _) => data.irrWest,
               // dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
              // SplineSeries<PlantTodayDataModel, DateTime>(
              //   name: 'Radiation North',
              //   dataSource: dailyPowerConsumptionController.plantLiveDataModel,
              //   xValueMapper: (PlantTodayDataModel data, _) => data.timedate,
              //   yValueMapper: (PlantTodayDataModel data, _) => data.irrNorth,
              //  // dataLabelSettings: const DataLabelSettings(isVisible: true),
              // ),
              // SplineSeries<PlantTodayDataModel, DateTime>(
              //   name: 'Radiation South',
              //   dataSource: dailyPowerConsumptionController.plantLiveDataModel,
              //   xValueMapper: (PlantTodayDataModel data, _) => data.timedate,
              //   yValueMapper: (PlantTodayDataModel data, _) => data.irrSouth,
              //  // dataLabelSettings: const DataLabelSettings(isVisible: true),
              // ),
              SplineSeries<PlantTodayDataModel, DateTime>(
                name: 'Plant Power(kW)',
                legendItemText: 'Power',
                dataSource: dailyPowerConsumptionController.plantLiveDataModel,
                xValueMapper: (PlantTodayDataModel data, _) => data.timedate?.subtract(const Duration(hours: 6)),
                yValueMapper: (PlantTodayDataModel data, _) => data.totalAcPower,
                //dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          );
        },
      ),
    );
  }
}
