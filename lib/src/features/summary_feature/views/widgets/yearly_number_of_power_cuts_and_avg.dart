import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class YearlyNumberOfPowerCutsAndAvgWidget extends StatefulWidget {
  const YearlyNumberOfPowerCutsAndAvgWidget({super.key});

  @override
  State<YearlyNumberOfPowerCutsAndAvgWidget> createState() => _YearlyNumberOfPowerCutsAndAvgWidgetState();
}

class _YearlyNumberOfPowerCutsAndAvgWidgetState extends State<YearlyNumberOfPowerCutsAndAvgWidget> {
  List<dynamic> data = [];
  String selectedNode = 'All';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
     String apiUrl = Urls.getYearlyPowerCutsUrl;
     String token = '${AuthUtilityController.accessToken}';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          data = jsonData ?? [];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load YearlyNumberOfPowerCutsAndAvg data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log('Error: $e');
    }
  }

  List<Map<String, Object>> _prepareChartDataForNode(String nodeName) {
    final List<int> years = [2023, 2024, 2025, 2026];

    List<Map<String, Object>> chartData = years.map((year) {
      return {
        'year': year.toString(),
        'power_cuts_in_min': 0,
        'count_powercuts': 0,
      };
    }).toList();

    for (var yearData in data) {
      String? year = yearData['year']?.toString();
      if (year == null || yearData['nodes'] == null) continue;

      for (var node in (yearData['nodes'] as List<dynamic>? ?? [])) {
        String? nodeNameInData = node['node']?.toString();
        if (nodeNameInData == null || nodeNameInData != nodeName) continue;

        var chartYear = chartData.firstWhere(
              (entry) => entry['year'] == year,
        );

        chartYear['power_cuts_in_min'] =
            (chartYear['power_cuts_in_min'] as int) + (node['power_cuts_in_min'] ?? 0);
        chartYear['count_powercuts'] =
            (chartYear['count_powercuts'] as int) + (node['count_powercuts'] ?? 0);
      }
    }

    return chartData;
  }

  List<ColumnSeries<Map<String, Object>, String>> _buildChartSeries() {
    if (selectedNode == 'All') {
      // Generate series for all nodes
      final nodeNames = data
          .expand((yearData) => (yearData['nodes'] as List<dynamic>? ?? []))
          .map((node) => node['node']?.toString() ?? '')
          .where((nodeName) => nodeName.isNotEmpty)
          .toSet();

      return nodeNames.expand((nodeName) {
        final chartData = _prepareChartDataForNode(nodeName);
        return [
          ColumnSeries<Map<String, Object>, String>(
            dataSource: chartData,
            xValueMapper: (Map<String, Object> data, _) => data['year'] as String,
            yValueMapper: (Map<String, Object> data, _) => data['power_cuts_in_min'] as int,
            name: '$nodeName (Power Cuts)',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
          ColumnSeries<Map<String, Object>, String>(
            dataSource: chartData,
            xValueMapper: (Map<String, Object> data, _) => data['year'] as String,
            yValueMapper: (Map<String, Object> data, _) => data['count_powercuts'] as int,
            name: '$nodeName (Count)',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ];
      }).toList();
    } else {
      // Generate series for the selected node only
      final chartData = _prepareChartDataForNode(selectedNode);
      return [
        ColumnSeries<Map<String, Object>, String>(
          dataSource: chartData,
          xValueMapper: (Map<String, Object> data, _) => data['year'] as String,
          yValueMapper: (Map<String, Object> data, _) => data['power_cuts_in_min'] as int,
          name: '$selectedNode (Power Cuts)',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
        ColumnSeries<Map<String, Object>, String>(
          dataSource: chartData,
          xValueMapper: (Map<String, Object> data, _) => data['year'] as String,
          yValueMapper: (Map<String, Object> data, _) => data['count_powercuts'] as int,
          name: '$selectedNode (Count)',
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SizedBox(height: size.height * k8TextSize,),
          TextComponent(text: 'Yearly Number of Power Cuts & Avg Duration',color: AppColors.primaryColor,fontFamily: boldFontFamily,fontSize: size.height * k18TextSize,),

          Padding(
            padding: EdgeInsets.all(size.height * k8TextSize),
            child: CustomContainer(
              height: size.height * 0.050,
              width: double.infinity,
              borderRadius: BorderRadius.circular(size.height * k16TextSize),
              child: Padding(
                padding: EdgeInsets.all(size.height * k8TextSize),
                child: DropdownButton<String>(
                  underline: const SizedBox(),
                  value: selectedNode,
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      selectedNode = value!;
                    });
                  },
                  items: [
                    'All',
                    ...data.expand((yearData) =>(yearData['nodes'] as List<dynamic>? ?? []))
                        .map((node) => node['node']?.toString() ?? '')
                        .where((nodeName) => nodeName.isNotEmpty)
                        .toSet()
                  ].map((String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Align(
                        alignment: Alignment.center,
                        child:  TextComponent(text:value)),
                  ))
                      .toList(),
                ),
              ),
            ),
          ),
          Expanded(
            child: SfCartesianChart(
              primaryXAxis:  CategoryAxis(
                title: AxisTitle(text: 'Year'),
                interval: 1,
              ),
              legend: const Legend(isVisible: true),
              trackballBehavior: TrackballBehavior(
                enable: true,
                tooltipAlignment: ChartAlignment.near,
                tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                activationMode: ActivationMode.singleTap,
              ),              series: _buildChartSeries(),
            ),
          ),
        ],
      ),
    );
  }
}