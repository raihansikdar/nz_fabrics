import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/summary_feature/views/widgets/power_cut_hourly_info.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class MonthlyPowerCutsAndAvgDuration extends StatefulWidget {
  const MonthlyPowerCutsAndAvgDuration({super.key});

  @override
  State<MonthlyPowerCutsAndAvgDuration> createState() => _MonthlyPowerCutsAndAvgDurationState();
}

class _MonthlyPowerCutsAndAvgDurationState extends State<MonthlyPowerCutsAndAvgDuration> {
  List<_ChartData> powerCutMinutesData = [];
  List<_ChartData> powerCutCountData = [];
  List<_ChartData> displayedPowerCutMinutes = [];
  List<_ChartData> displayedPowerCutCount = [];
  List<String> nodes = [];
  String selectedNode = "All Nodes";
  bool isLoading = true;
  bool showFirstSixMonths = true;

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    final url = Urls.getMonthlyPowerCutsUrl;
     String token = '${AuthUtilityController.accessToken}';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': token},
      );

    //  log("getMonthlyPowerCutsUrl : ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        final List<String> months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];

        final List nodesSet = data.map((e) => e['node'] ?? 'Unknown').toSet().toList();
        nodes = ["All Nodes", ...nodesSet];

        final Map<String, Map<String, double>> powerCutMinutesMap = {
          for (var month in months) month: {for (var node in nodesSet) node: 0.0}
        };
        final Map<String, Map<String, double>> powerCutCountMap = {
          for (var month in months) month: {for (var node in nodesSet) node: 0.0}
        };

        for (var item in data) {
          final date = DateTime.parse(item['date']);
          final month = getMonthName(date.month);
          final node = item['node'] ?? 'Unknown';
          final powerCutMinutes = item['powercut_in_min']?.toDouble() ?? 0;
          final powerCutCount = item['count_powercuts']?.toDouble() ?? 0;

          powerCutMinutesMap[month]![node] =
              (powerCutMinutesMap[month]![node] ?? 0.0) + powerCutMinutes;
          powerCutCountMap[month]![node] =
              (powerCutCountMap[month]![node] ?? 0.0) + powerCutCount;
        }

        final List<_ChartData> tempPowerCutMinutesData = [];
        final List<_ChartData> tempPowerCutCountData = [];

        powerCutMinutesMap.forEach((month, nodes) {
          nodes.forEach((node, value) {
            tempPowerCutMinutesData.add(_ChartData(month, node, value));
          });
        });

        powerCutCountMap.forEach((month, nodes) {
          nodes.forEach((node, value) {
            tempPowerCutCountData.add(_ChartData(month, node, value));
          });
        });

        setState(() {
          powerCutMinutesData = tempPowerCutMinutesData;
          powerCutCountData = tempPowerCutCountData;
          showFirstSixMonths = DateTime.now().month <= 6;
          updateDisplayedData();
          isLoading = false;
        });
      } else {
        log('Error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching data: $e');
    }
  }

  void updateDisplayedData() {
    const firstSixMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    const lastSixMonths = ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    setState(() {
      displayedPowerCutMinutes = powerCutMinutesData
          .where((data) =>
      (showFirstSixMonths
          ? firstSixMonths.contains(data.month)
          : lastSixMonths.contains(data.month)) &&
          (selectedNode == "All Nodes" || data.node == selectedNode))
          .toList();

      displayedPowerCutCount = powerCutCountData
          .where((data) =>
      (showFirstSixMonths
          ? firstSixMonths.contains(data.month)
          : lastSixMonths.contains(data.month)) &&
          (selectedNode == "All Nodes" || data.node == selectedNode))
          .toList();
    });
  }

  String getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: size.height * k8TextSize,),
          TextComponent(text: 'Monthly Number of  Power Cuts & Avg Duration',color: AppColors.primaryColor,fontFamily: boldFontFamily,fontSize: size.height * k17TextSize,),

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
                  items: nodes
                      .map((node) => DropdownMenuItem<String>(
                    value: node,
                    child: Align(
                        alignment: Alignment.center,
                        child: TextComponent(text:node)),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedNode = value!;
                      updateDisplayedData();
                    });
                  },
                ),
              ),
            ),
          ),

          SizedBox(
            height: 400,
            child: SfCartesianChart(
              trackballBehavior: TrackballBehavior(
                enable: true,
                tooltipAlignment: ChartAlignment.near,
                tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                activationMode: ActivationMode.singleTap,
              ),
              primaryXAxis:  CategoryAxis(),
            //  title:  ChartTitle(text: 'Monthly Node Power Cuts Data',textStyle: const TextStyle(color: AppColors.primaryColor,fontFamily: boldFontFamily)),
              legend: const Legend(isVisible: true,position: LegendPosition.top),
              series: _buildSeries(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(

                  onTap: (){
                    setState(() {
                      showFirstSixMonths = true;
                      updateDisplayedData();
                    });
                  },
                  child: SvgPicture.asset(showFirstSixMonths ? AssetsPath.leftInactiveTriangleSVG : AssetsPath.leftActiveTriangleSVG,height: size.height * 0.025,)),
              SizedBox(width: size.width * k16TextSize,),
              TextComponent(text: showFirstSixMonths ? 'January-June' :'July-December' ),
              SizedBox(width: size.width * k16TextSize,),
              GestureDetector(
                  onTap: (){
                        setState(() {
                          showFirstSixMonths = false;
                          updateDisplayedData();
                        });
                  },
                  child: SvgPicture.asset(showFirstSixMonths ?  AssetsPath.rightActiveTriangleSVG :  AssetsPath.rightInactiveTriangleSVG ,height: size.height * 0.025,)),
            ],
          ),
          SizedBox(height: size.height * k8TextSize,),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: size.height * k5TextSize),
              child: GestureDetector(
                onTap: (){
                  _showAlertDialog(context);
                },
                child: CustomContainer(
                    height: size.height * 0.05,
                    width: size.width * 0.5,
                    borderRadius: BorderRadius.circular(size.height * k8TextSize,),
                    child: const Center(child: TextComponent(text: "Power Cut Hourly Info",color: AppColors.secondaryTextColor,)),
                ),
              ),
            ),
          )

          // ElevatedButton(
          //   onPressed: () {
          //     setState(() {
          //       showFirstSixMonths = !showFirstSixMonths;
          //       updateDisplayedData();
          //     });
          //   },
          //   child: Text(
          //       showFirstSixMonths ? 'Show Jul-Dec' : 'Show Jan-Jun'),
          // ),
        ],
      ),
    );

  }


  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Number of power cuts in month - '),
            titleTextStyle: const TextStyle(fontSize: 16,color: AppColors.primaryTextColor,fontFamily: boldFontFamily),
            insetPadding: const EdgeInsets.all(10),
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
          content: Builder(
            builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return SizedBox(
                   height: height - 480,
                  width: width,
                  child: const PowerCutHourlyInfo());
            }
          )

        );
      },
    );
  }


  List<CartesianSeries<dynamic, dynamic>> _buildSeries() {
    final uniqueNodes =
    displayedPowerCutMinutes.map((data) => data.node).toSet();

    final powerCutMinutesSeries = uniqueNodes.map((node) {
      return ColumnSeries<dynamic, dynamic>(
        dataSource: displayedPowerCutMinutes
            .where((data) => data.node == node)
            .toList(),
        xValueMapper: (dynamic data, _) => data.month,
        yValueMapper: (dynamic data, _) => data.value,
        name: '$node (Minutes)',
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      );
    }).toList();

    final powerCutCountSeries = uniqueNodes.map((node) {
      return ColumnSeries<dynamic, dynamic>(
        dataSource: displayedPowerCutCount
            .where((data) => data.node == node)
            .toList(),
        xValueMapper: (dynamic data, _) => data.month,
        yValueMapper: (dynamic data, _) => data.value,
        name: '$node (Count)',
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      );
    }).toList();

    return [...powerCutMinutesSeries, ...powerCutCountSeries];
  }
}

class _ChartData {
  _ChartData(this.month, this.node, this.value);
  final String month;
  final String node;
  final double value;
}