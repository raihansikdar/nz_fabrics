import 'dart:developer';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/all_live_data/views/widgets/all_live_data_source_pie_chart_widget.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';



class LiveDataSourcePieChartController extends GetxController with InternetConnectivityCheckMixin {
  bool _isConnected = true;
  bool _hasError = false;
  bool _isLoading = false;
  String _errorMessage = '';
  List<LiveDataSourcePieChartModel> _chartData = [];

  bool get isConnected => _isConnected;
  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<LiveDataSourcePieChartModel> get chartData => _chartData;

  Future<bool> fetchLivePieChartData({required String nodeName}) async {
    _isConnected = true;
    _isLoading = true;
    update();

    try {
      // Check internet connectivity
      await internetConnectivityCheck();

      // Make API call
      NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.getPowerUsagePercentageSourceUrl(nodeName),
      );

      log("getPowerUsagePercentageSourceUrl statusCode ==> ${response.statusCode}");
      log("getPowerUsagePercentageSourceUrl body ==> ${response.body}");

      _isLoading = false;

      if (response.isSuccess) {
        final Map<String, dynamic> decodedResponse = response.body;

      //  log("Decoded response type: ${decodedResponse.runtimeType}");

        // Process the Map into the chart data model
        _chartData = decodedResponse.entries.map((entry) {
          return LiveDataSourcePieChartModel(
            entry.key,   // Map key
            entry.value, // Map value
          );
        }).toList();

        _hasError = false;
        update();
        return true;
      } else {
        _errorMessage = "Can't load data";
        _hasError = true;
        update();
        return false;
      }
    } catch (e) {
      _hasError = true;
      _isLoading = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _hasError = false;
        _isConnected = false;
      }

      log('Error in fetchLiveSourcePieChartData: $_errorMessage');
      _errorMessage = "Can't load data";
      update();
      return false;
    }
  }

}
