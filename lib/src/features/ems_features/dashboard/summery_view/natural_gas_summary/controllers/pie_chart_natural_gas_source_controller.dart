import 'dart:developer';

import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/natural_gas_summary/model/natural_gas_pie_chart_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/natural_gas_summary/model/natural_gas_pie_chart_total_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class PieChartNaturalGasSourceController extends GetxController with InternetConnectivityCheckMixin {
  List<NaturalGasPieChartDataModel> naturalGasPieChartDataModelList = [];
  NaturalGasPieChartTotalDataModel naturalGasPieChartTotalDataList = NaturalGasPieChartTotalDataModel();
  bool isLoading = false;
  bool hasError = false;
  bool isConnected = true;
  var errorMessage = ''.obs;

  Future<void> fetchPieChartData() async {
    isConnected = true;
    isLoading = true;
    update();

    try {

      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.pieChartNaturalGasSourceUrl);

      isLoading = false;
      update();

      // log(response.statusCode.toString());
      // log(response.body.toString());

      if (response.statusCode == 200) {
        final jsonData = response.body;
        // log('Pie Chart Load Water Data : $jsonData');
        if (jsonData is Map<String, dynamic>) {
          naturalGasPieChartDataModelList = jsonData.entries
              .where((entry) =>
          (entry.value is double || entry.value is int) &&
              entry.key != 'total' &&
              entry.key != 'total_cost')
              .map((entry) =>
              NaturalGasPieChartDataModel(entry.key, (entry.value as num).toDouble()))
              .toList();

          naturalGasPieChartTotalDataList = NaturalGasPieChartTotalDataModel.fromJson(jsonData);
        } else {
          hasError = true;
          throw Exception('Unexpected data format');
        }

      } else {
        hasError = true;
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      hasError = true;
      isLoading = false;
      if (e is AppException) {
        isConnected = false;
        hasError = false;
      }
      update();
      log('Error: $e');
    } finally {
      isLoading = false;
      update();
    }
  }
}
