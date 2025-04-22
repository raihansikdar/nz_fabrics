// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/controllers/dgr_controller.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/model/dgr_line_chart_model.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// class DgrLineChart extends StatelessWidget {
//   final DGRLineChartModel lineChartModel;
//
//   const DgrLineChart({required this.lineChartModel});
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     double determineInterval(int dataLength) {
//       if (dataLength > 720) {
//         return 720.0;
//       } else if (dataLength > 450) {
//         return 450.0;
//       } else if (dataLength > 360) {
//         return 360.0;
//       } else {
//         return 240.0;
//       }
//     }
//
//     return GetBuilder<DgrController>(
//         builder: (dgrController) {
//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0),
//               child: Card(
//                 color: Colors.white,
//                 child: SizedBox(
//                   width: dgrController.dateDifference > 1 ? 1500 : MediaQuery.sizeOf(context).width - 20,
//                   child: SfCartesianChart(
//                     primaryXAxis: DateTimeAxis(
//
//                       dateFormat: DateFormat('dd-MMM-yyyy HH:mm:ss'),
//                       interval: determineInterval(lineChartModel.data?.length ?? 0),
//                       intervalType: DateTimeIntervalType.minutes,
//                       majorGridLines: const MajorGridLines(width: 0),
//                       // edgeLabelPlacement: EdgeLabelPlacement.shift,
//                       // rangePadding: ChartRangePadding.round,
//                       labelAlignment: LabelAlignment.center,
//                       axisLabelFormatter: (axisLabelRenderArgs) {
//                         final String text = DateFormat('dd/MMM/yyyy').format(
//                           DateTime.fromMillisecondsSinceEpoch(
//                             axisLabelRenderArgs.value.toInt(),
//                           ),
//                         );
//                         TextStyle style = TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold);
//                         return ChartAxisLabel(text, style);
//                       },
//                     ),
//
//                     primaryYAxis: NumericAxis(
//                       majorGridLines: const MajorGridLines(width: 1),
//                       numberFormat: NumberFormat.compact(), // Format Y-axis as 1k, 2k, 4k
//                       labelFormat: '{value}', // Display as it is formatted
//                     ),
//                     legend: const Legend(
//                       isVisible: true,
//                       overflowMode: LegendItemOverflowMode.wrap,
//                       position: LegendPosition.top,
//                     ),
//                     trackballBehavior: TrackballBehavior(
//                       enable: true,
//                       tooltipAlignment: ChartAlignment.near,
//                       tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
//                       activationMode: ActivationMode.longPress,
//                     ),
//
//                     series: <SplineSeries<Data, DateTime>>[
//                       SplineSeries<Data, DateTime>(
//                         dataSource: lineChartModel.data ?? [],
//                         xValueMapper: (Data data, _) => _parseDateTime(data.timedate),
//                         yValueMapper: (Data data, _) =>
//                         double.tryParse(data.acPower?.toStringAsFixed(2) ?? '0.0') ?? 0.0,
//                         name: 'AC Power (kW)',
//                         legendItemText: 'AC Power',
//                         color:Colors.deepPurple,
//                       ),
//                       SplineSeries<Data, DateTime>(
//                         dataSource: lineChartModel.data ?? [],
//                         xValueMapper: (Data data, _) => _parseDateTime(data.timedate),
//                         yValueMapper: (Data data, _) =>
//                         double.tryParse(data.pr?.toStringAsFixed(2) ?? '0.0') ?? 0.0,
//                         color: const Color(0xFF00AAF3),
//                         name: 'PR',
//                         legendItemText: 'PR',
//                       ),
//                       SplineSeries<Data, DateTime>(
//                         dataSource: lineChartModel.data ?? [],
//                         xValueMapper: (Data data, _) => _parseDateTime(data.timedate),
//                         yValueMapper: (Data data, _) =>
//                         double.tryParse(data.irrEast?.toStringAsFixed(2) ?? '0.0') ?? 0.0,
//                         name: 'Irr East (W/m²)',
//                         legendItemText: 'Irr East',
//                         color:Colors.orange,
//                       ),
//
//                       SplineSeries<Data, DateTime>(
//                         dataSource: lineChartModel.data ?? [],
//                         xValueMapper: (Data data, _) => _parseDateTime(data.timedate),
//                         yValueMapper: (Data data, _) =>
//                         double.tryParse(data.irrWest?.toStringAsFixed(2) ?? '0.0') ?? 0.0,
//                         name: 'Irr West (W/m²)',
//                         legendItemText: 'Irr West',
//                         color:Colors.red,
//                       ),
//                       SplineSeries<Data, DateTime>(
//                         dataSource: lineChartModel.data ?? [],
//                         xValueMapper: (Data data, _) => _parseDateTime(data.timedate),
//                         yValueMapper: (Data data, _) =>
//                         double.tryParse(data.todayEnergy?.toStringAsFixed(2) ?? '0.0') ?? 0.0,
//                         name: 'Today Energy (kWh)',
//                         legendItemText: 'Today Energy',
//                       ),
//
//
//
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//     );
//   }
//
//   /// Method to parse the DateTime from the provided string and subtract 6 hours
//   DateTime _parseDateTime(String? timedate) {
//     if (timedate == null || timedate.isEmpty) {
//       return DateTime.now().subtract(const Duration(hours: 6));
//     }
//
//     try {
//       return DateTime.parse(timedate).toLocal().subtract(const Duration(hours: 6));
//     } catch (e) {
//       return DateTime.now().subtract(const Duration(hours: 6));
//     }
//   }
// }






import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/controllers/dgr_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/model/dgr_line_chart_model.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DgrLineChart extends StatefulWidget {
  final DGRLineChartModel lineChartModel;

  const DgrLineChart({super.key, required this.lineChartModel});

  @override
  State<DgrLineChart> createState() => _DgrLineChartState();
}

class _DgrLineChartState extends State<DgrLineChart> {
  bool _showAcPower = false;
  bool _showPr = true;
  bool _showIrrEast = false;
  bool _showIrrWest = false;
  bool _showTodayEnergy = false;
  bool acPowerOn = false;
  bool energyActive = false;
  bool prOn = true;

  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    super.initState();
    // Initialize zoom/pan behavior
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      zoomMode: ZoomMode.x,
    );
  }

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

  // Calculate maximum values for each series
  double calculateMaxAcPower(List<Data> data) {
    if (data.isEmpty) return 1000.0;
    double maxValue = data.map((d) => safeToDouble(d.acPower)).reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? maxValue * 1.1 : 1000.0;
  }

  double calculateMaxPr(List<Data> data) {
    if (data.isEmpty) return 10.0;
    double maxValue = data.map((d) => safeToDouble(d.pr)).reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? maxValue * 1.1 : 10.0;
  }

  double calculateMaxIrrCombined(List<Data> data) {
    if (data.isEmpty) return 1000.0;
    double maxIrrEast = data.map((d) => safeToDouble(d.irrEast)).reduce((a, b) => a > b ? a : b);
    double maxIrrWest = data.map((d) => safeToDouble(d.irrWest)).reduce((a, b) => a > b ? a : b);
    double maxValue = maxIrrEast > maxIrrWest ? maxIrrEast : maxIrrWest;
    return maxValue > 0 ? maxValue * 1.1 : 1000.0;
  }

  double calculateMaxTodayEnergy(List<Data> data) {
    if (data.isEmpty) return 1000.0;
    double maxValue = data.map((d) => safeToDouble(d.todayEnergy)).reduce((a, b) => a > b ? a : b);
    return maxValue > 0 ? maxValue * 1.1 : 1000.0;
  }




  // Determine interval based on data length
  double determineInterval(int dataLength) {
    if (dataLength > 1220) {
      return 1220.0;
    } else if (dataLength > 1050) {
      return 1050.0;
    }
    else if (dataLength > 860) {
      return 860.0;
    }
    else {
      return 740.0;
    }
  }






  @override
  Widget build(BuildContext context) {
    List<Data> chartData = widget.lineChartModel.data ?? [];

    // Find min and max dates for x-axis
    DateTime? minDate, maxDate;
    if (chartData.isNotEmpty) {
      minDate = chartData.map((d) => _parseDateTime(d.timedate)).reduce((a, b) => a.isBefore(b) ? a : b);
      maxDate = chartData.map((d) => _parseDateTime(d.timedate)).reduce((a, b) => a.isAfter(b) ? a : b);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                    selected: _showPr,
                    onSelected: (selected) {
                   setState(() {
                     _showPr = selected;

                     if(_showPr){
                       prOn = true;
                     } else{
                       prOn = false;
                     }

                   });
                    },
                    selectedColor: AppColors.prColor.withOpacity(0.3),
                    checkmarkColor: AppColors.prColor,
                  ),
                  FilterChip(
                    label: const Text('AC Power',style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                    selected: _showAcPower,
                    onSelected: (selected) {
                      setState(() {
                        _showAcPower = selected;
                        acPowerOn = true;
                      });
                        } ,
                    selectedColor: AppColors.acPowerColor.withOpacity(0.3),
                    checkmarkColor: AppColors.acPowerColor,
                  ),
                  FilterChip(
                    label: const Text('Irr East',style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                    selected: _showIrrEast,
                    onSelected: (selected) => setState(() => _showIrrEast = selected),
                    selectedColor: AppColors.irrEastColor.withOpacity(0.3),
                    checkmarkColor: AppColors.irrEastColor,
                  ),
                  FilterChip(
                    label: const Text('Irr West',style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                    selected: _showIrrWest,
                    onSelected: (selected) => setState(() => _showIrrWest = selected),
                    selectedColor: AppColors.irrWestColor.withOpacity(0.3),
                    checkmarkColor: AppColors.irrWestColor,
                  ),
                  FilterChip(
                    label: const Text('Today Energy',style: TextStyle(fontSize: 12),textAlign: TextAlign.center,),
                    selected: _showTodayEnergy,
                    onSelected: (selected) => setState(() => _showTodayEnergy = selected),
                    selectedColor: AppColors.energyColor.withOpacity(0.3),
                    checkmarkColor: AppColors.energyColor,
                  ),
                ],
              ),
            ),
            GetBuilder<DgrController>(
              builder: (dgrController) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: SizedBox(
                    height:  MediaQuery.sizeOf(context).width > 500 ? MediaQuery.sizeOf(context).height * 0.48 : MediaQuery.sizeOf(context).height * 0.38,
                    width: MediaQuery.of(context).size.width - 16,
                    child: SfCartesianChart(
                      plotAreaBorderWidth: 0,
                      zoomPanBehavior: _zoomPanBehavior,
                      trackballBehavior: TrackballBehavior(
                        enable: true,
                        tooltipAlignment: ChartAlignment.near,
                        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                        activationMode: ActivationMode.longPress,
                      ),
                      legend: const Legend(
                        isVisible: false,
                        position: LegendPosition.top,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),


                      primaryXAxis: DateTimeAxis(
                          dateFormat: DateFormat('dd-MMM-yyyy HH:mm'),
                          majorGridLines: const MajorGridLines(width: 0),
                          labelStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.bold,
                          ),
                          interval: determineInterval(chartData.length),
                         // intervalType: DateTimeIntervalType.hours,
                          minimum: minDate,
                          maximum: maxDate,
                           initialVisibleMinimum: minDate != null
                              ? DateTime(minDate.year, minDate.month, minDate.day, 5, 0)
                              : null,
                          initialVisibleMaximum: minDate != null
                              ? DateTime(minDate.year, minDate.month, minDate.day, 19, 0)
                              : null,
                          axisLabelFormatter: (AxisLabelRenderDetails args) {
                            final String text = DateFormat('dd/MMM').format(
                              DateTime.fromMillisecondsSinceEpoch(args.value.toInt()),
                            );
                            return ChartAxisLabel(text, args.textStyle);
                          },
                          ),


                      primaryYAxis: NumericAxis(
                        name: 'AcPowerAxis',
                        minimum: 0,
                        maximum: chartData.isNotEmpty ? calculateMaxAcPower(chartData) : 1000,
                        majorGridLines: const MajorGridLines(width: 1),
                        numberFormat: NumberFormat.compact(),
                        labelFormat: '{value}',
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
                      axes: [
                        NumericAxis(
                          name: 'PrAxis',
                          minimum: 0,
                          maximum: chartData.isNotEmpty ? calculateMaxPr(chartData) : 10,
                          labelStyle: const TextStyle(color: AppColors.prColor),
                          isVisible: _showPr,
                          axisLabelFormatter: (AxisLabelRenderDetails args) {
                            double value = safeToDouble(args.text);
                            return ChartAxisLabel(value.toStringAsFixed(1), args.textStyle);
                          },
                        ),
                        NumericAxis(
                          name: 'IrrAxis',
                          opposedPosition: true,
                          minimum: 0,
                          maximum: chartData.isNotEmpty ? calculateMaxIrrCombined(chartData) : 1000,
                          labelStyle: const TextStyle(color: AppColors.irrEastColor),
                          isVisible: _showIrrEast || _showIrrWest,
                          axisLabelFormatter: (AxisLabelRenderDetails args) {
                            double value = safeToDouble(args.text);
                            String formattedText = value >= 1000
                                ? '${(value / 1000).toStringAsFixed(1)}k'
                                : value.toStringAsFixed(1);
                            return ChartAxisLabel(formattedText, args.textStyle);
                          },
                        ),
                        NumericAxis(
                          name: 'EnergyAxis',
                          opposedPosition: true,
                          minimum: 0,
                          maximum: chartData.isNotEmpty ? calculateMaxTodayEnergy(chartData) : 1000,
                          labelStyle: const TextStyle(color: AppColors.prColor),
                          isVisible: _showTodayEnergy,
                          axisLabelFormatter: (AxisLabelRenderDetails args) {
                            double value = safeToDouble(args.text);
                            String formattedText = value >= 1000
                                ? '${(value / 1000).toStringAsFixed(1)}k'
                                : value.toStringAsFixed(1);
                            return ChartAxisLabel(formattedText, args.textStyle);
                          },
                        ),
                      ],
                      series: <CartesianSeries<Data, DateTime>>[
                        if (_showAcPower)
                          FastLineSeries<Data, DateTime>(
                            name: 'AC Power (kW)',
                            dataSource: chartData,
                            xValueMapper: (Data data, _) => _parseDateTime(data.timedate),
                            yValueMapper: (Data data, _) => safeToDouble(data.acPower),
                            yAxisName: 'AcPowerAxis',
                            color: AppColors.acPowerColor,
                          ),
                        if (_showPr)
                          FastLineSeries<Data, DateTime>(
                            name: 'PR',
                            dataSource: chartData,
                            xValueMapper: (Data data, _) => _parseDateTime(data.timedate),
                            yValueMapper: (Data data, _) => safeToDouble(data.pr),
                            yAxisName: 'PrAxis',
                            color: AppColors.prColor,
                          ),
                        if (_showIrrEast)
                          FastLineSeries<Data, DateTime>(
                            name: 'Irr East (W/m²)',
                            dataSource: chartData,
                            xValueMapper: (Data data, _) => _parseDateTime(data.timedate),
                            yValueMapper: (Data data, _) => safeToDouble(data.irrEast),
                            yAxisName: 'IrrAxis',
                            color: AppColors.irrEastColor,
                          ),
                        if (_showIrrWest)
                          FastLineSeries<Data, DateTime>(
                            name: 'Irr West (W/m²)',
                            dataSource: chartData,
                            xValueMapper: (Data data, _) => _parseDateTime(data.timedate),
                            yValueMapper: (Data data, _) => safeToDouble(data.irrWest),
                            yAxisName: 'IrrAxis',
                            color: AppColors.irrWestColor,
                          ),
                        if (_showTodayEnergy)
                          FastLineSeries<Data, DateTime>(
                            name: 'Today Energy (kWh)',
                            dataSource: chartData,
                            xValueMapper: (Data data, _) => _parseDateTime(data.timedate),
                            yValueMapper: (Data data, _) => safeToDouble(data.todayEnergy),
                            yAxisName: 'EnergyAxis',
                            color: AppColors.energyColor,
                          ),
                      ],
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
                  if(_showPr)
                    Transform.rotate(
                    angle: 90 * 3.14159 / 180,
                    child: Container(
                      transform: (acPowerOn && prOn)
                          ? Matrix4.translationValues(-45, -30, 0)
                          : Matrix4.translationValues(-45, -32, 0),
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
                        transform:  prOn == true ? Matrix4.translationValues(-25, -38, 0) : Matrix4.translationValues(-18, -28, 0) ,
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
                  if (_showIrrEast || _showIrrWest)
                    Transform.rotate(
                      angle: 90 * 3.14159 / 180,
                      child: Container(
                        transform: energyActive ? Matrix4.translationValues(-15, 0, 0) : Matrix4.translationValues(-40, 40, 0),
                        child: const Text(
                          'IRR',
                          style: TextStyle(
                            color: AppColors.irrEastColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (_showTodayEnergy)
                    Transform.rotate(
                      angle: 90 * 3.14159 / 180,
                      child: Container(
                        transform: Matrix4.translationValues(-25, 22, 0),
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

  DateTime _parseDateTime(String? timedate) {
    if (timedate == null || timedate.isEmpty) {
      return DateTime.now().subtract(const Duration(hours: 6));
    }
    try {
      return DateTime.parse(timedate).toLocal().subtract(const Duration(hours: 6));
    } catch (e) {
      return DateTime.now().subtract(const Duration(hours: 6));
    }
  }
}



