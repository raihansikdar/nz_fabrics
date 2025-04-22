import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class PowerCutHourlyInfo extends StatefulWidget {
  const PowerCutHourlyInfo({super.key});

  @override
  State<PowerCutHourlyInfo> createState() => _PowerCutHourlyInfoState();
}

class _PowerCutHourlyInfoState extends State<PowerCutHourlyInfo> {
  int selectedMonth = DateTime.now().month; // Dynamically set the current month
  Map<String, dynamic> fullData = {}; // Data for all months
  Map<String, double> chartData = {}; // Data for the selected month
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    final url = Urls.getPowerCutsInMinutesUrl;
    final token = '${AuthUtilityController.accessToken}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Set initial chart data for the current selected month
        setState(() {
          fullData = data;
          chartData = parseChartData(data[selectedMonth.toString()]);
          isLoading = false;
        });
      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  Map<String, double> parseChartData(Map<String, dynamic>? monthData) {
    if (monthData == null) return {};
    return monthData.map((key, value) => MapEntry(key, (value as int).toDouble()));
  }

  void onMonthChanged(int month) {
    setState(() {
      selectedMonth = month;
      chartData = parseChartData(fullData[selectedMonth.toString()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Radio buttons for months
          Padding(
            padding: EdgeInsets.all(size.height * k8TextSize),
            child: Wrap(
              children: List.generate(12, (index) {
                final monthIndex = index + 1;
                final monthName = getMonthName(monthIndex);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      value: monthIndex,
                      groupValue: selectedMonth,
                      onChanged: (value) {
                        if (value != null) {
                          onMonthChanged(value);
                        }
                      },
                    ),
                    Text(monthName),
                  ],
                );
              }),
            ),
          ),
          // Chart
          SizedBox(
            height: size.height * 0.250,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(isVisible: false),
              series: <CartesianSeries>[
                BarSeries<MapEntry<String, double>, String>(
                  dataSource: chartData.entries.toList(),
                  xValueMapper: (entry, _) => entry.key,
                  yValueMapper: (entry, _) => entry.value,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
              trackballBehavior: TrackballBehavior(
                enable: true,
                tooltipAlignment: ChartAlignment.near,
                tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                activationMode: ActivationMode.singleTap,
                tooltipSettings: const InteractiveTooltip(
                  format: 'point.x : Power Cuts = point.y',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}