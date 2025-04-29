import 'dart:convert';
import 'dart:developer';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CostAndPredictionWidget extends StatefulWidget {
  const CostAndPredictionWidget({super.key});

  @override
  State<CostAndPredictionWidget> createState() => _CostAndPredictionWidgetState();
}

class _CostAndPredictionWidgetState extends State<CostAndPredictionWidget> {
  List<EnergyData> _chartData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final url = Uri.parse(Urls.getTimeUsageInPercentageUrl);
    final headers = {
      'Authorization': '${AuthUtilityController.accessToken}'
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _chartData = [
            EnergyData('Grid', data['Grid']),
            EnergyData('Generator', data['Generator']),
            EnergyData('Solar', data['Solar']),
          ];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
      body: _isLoading
          ? Center(child: SpinKitFadingCircle(
        color: AppColors.primaryColor,
        size: 50.0,
      ),)
        : SfCartesianChart(
        primaryXAxis: CategoryAxis(),
       // title: ChartTitle(text: 'Energy Usage in Percentage'),
        series: <CartesianSeries>[
          ColumnSeries<EnergyData, String>(
            dataSource: _chartData,
            xValueMapper: (EnergyData data, _) => data.source,
            yValueMapper: (EnergyData data, _) => data.usage,
            color: Colors.blue,
            dataLabelSettings:  DataLabelSettings(
              isVisible: true,
              textStyle: TextStyle(fontSize: size.height * k13TextSize, color: Colors.black),
            ),
            dataLabelMapper: (EnergyData data, _) => '${data.usage}%', // Format labels as percentages
          ),
        ],
      ),
    );
  }
}

class EnergyData {
  final String source;
  final double usage;
  EnergyData(this.source, this.usage);
}