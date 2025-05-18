import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/electricity_long_busbar_status_info_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class ElectricityLongBusBarStatusInfoController extends GetxController with InternetConnectivityCheckMixin {
  bool _isConnected = true;
  bool _isBusBarStatusProgress = false;
  String _errorMessage = '';
  List<ElectricityLongBusBarStatusInfoModel> _busBarStatusModels = []; // Changed to a list

  bool get isConnected => _isConnected;
  bool get isBusBarStatusProgress => _isBusBarStatusProgress;
  String get errorMessage => _errorMessage;
  List<ElectricityLongBusBarStatusInfoModel> get busBarStatusModels => _busBarStatusModels; // Updated getter

  Future<bool> fetchBusBarStatusData() async {
    _isBusBarStatusProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getBusBarStatusUrl);

      // log("getBusBarStatusUrl statusCode ==> ${response.statusCode}");
      // log("getBusBarStatusUrl body ==> ${response.body}");

     // Pretty-print the JSON response body
      const encoder = JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(jsonDecode(response.body));
      log("getBusBarStatusUrl statusCode  ==> ${response.statusCode}");
      log("getBusBarStatusUrl body ==> $prettyJson");

      _isBusBarStatusProgress = false;

      if (response.isSuccess) {
        final jsonData = response.body;

        // Check if jsonData is a List
        if (jsonData is List) {
          _busBarStatusModels = jsonData
              .map((item) => ElectricityLongBusBarStatusInfoModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (jsonData is Map<String, dynamic>) {
          // Handle single object case (optional, for backward compatibility)
          _busBarStatusModels = [ElectricityLongBusBarStatusInfoModel.fromJson(jsonData)];
        } else {
          _errorMessage = "Unexpected response format.";
          update();
          return false;
        }

        update();
        return true;
      } else {
        _errorMessage = "Failed to fetch busBar status data.";
        update();
        return false;
      }
    } catch (e) {
      _isBusBarStatusProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching busBar status data: $_errorMessage');
      _errorMessage = "Failed to fetch busBar status data.";

      update();
      return false;
    } finally {
      _isBusBarStatusProgress = false;
      update();
    }
  }
}
