import 'dart:developer';

import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/model/find_water_value_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';


class FindWaterValueController extends GetxController with InternetConnectivityCheckMixin {
  bool _isLoading = false;
  bool _isConnected = true;
  String _errorMessage = '';
  final Map<String, FindWaterValueModel> _waterValues = {};

  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  String get errorMessage => _errorMessage;
  Map<String, FindWaterValueModel> get waterValues => _waterValues;

  Future<void> fetchFindWaterData({required List<String> nodeNameList}) async {
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
            _waterValues[nodeName] = FindWaterValueModel.fromJson(response.body);
            update();
          } else {

            log("==> Failed to find water data for node: $nodeName");
            update();
          }
        } catch (e) {
          log("====> Error fetching water data for node $nodeName: $e");
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
      log('Error in Find Water Value Model: $_errorMessage');
    } finally {
      _isLoading = false;
      update();

    }
  }
}