import 'dart:developer';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/find_electricity_value_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class FindPowerValueController extends GetxController with InternetConnectivityCheckMixin {
  bool _isLoading = false;
  bool _isConnected = true;
  String _errorMessage = '';
  final Map<String, FindElectricityValueModel> _electricityValues = {};

  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  String get errorMessage => _errorMessage;
  Map<String, FindElectricityValueModel> get electricityValues => _electricityValues;

  Future<void> fetchFindPowerData({required List<String> nodeNameList}) async {
    if (_isLoading) return;

    _isLoading = true;
    _isConnected = true;
   // _electricityValues.clear();
    _errorMessage = '';
    update();

    try {
      await internetConnectivityCheck();

      // Perform API calls in parallel
      List<Future<void>> requests = nodeNameList.map((nodeName) async {
        try {
          NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getLiveDataUrl(nodeName));

          // log(Urls.getLiveDataUrl(nodeName));
          // log("=====================> Api Fetching<<=======================");

          if (response.isSuccess) {
            _electricityValues[nodeName] = FindElectricityValueModel.fromJson(response.body);
            update();
          } else {

            log("==> Failed to find data for node: $nodeName");
            update();
          }
        } catch (e) {
          log("====> Error fetching data for node $nodeName: $e");
          update();
        }
      }).toList();

      // Wait for all requests to complete
      await Future.wait(requests);
    } catch (e) {
      if (e is AppException) {
        _isConnected = false;
        _errorMessage = e.error.toString();
      } else {
        _errorMessage = e.toString();
      }
      log('Error in Find Electricity Value Model: $_errorMessage');
    } finally {
      _isLoading = false;
      update();

    }
  }
}
