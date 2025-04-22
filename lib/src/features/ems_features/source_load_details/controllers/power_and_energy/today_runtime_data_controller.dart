import 'dart:developer';

import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/power_and_energy/today_runtime_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class TodayRuntimeDataController extends GetxController with InternetConnectivityCheckMixin {
  bool _isConnected = true;
  bool _hasError = false;
  bool _isLoading = false;
  String _errorMessage = '';
  TodayRunTimeDataModel _todayRunTimeData = TodayRunTimeDataModel();

  bool get isConnected => _isConnected;
  bool get isError => _hasError;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  TodayRunTimeDataModel get todayRunTimeData => _todayRunTimeData;

  Future<bool> fetchTodayRuntimeData({required String sourceName}) async {
    _isLoading = true;
    _isConnected = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.todayRuntimeDataUrl(sourceName));

     log("todayRuntimeDataUrl statusCode ==> ${response.statusCode}");
     log("todayRuntimeDataUrl body ==> ${response.body}");

      _isLoading = false;
      update();
      if (response.isSuccess) {
        _todayRunTimeData = TodayRunTimeDataModel.fromJson(response.body);
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
        _isConnected = false;
        _hasError = false;
      }

      log('Error in fetchProjectData: $_errorMessage');

      update();
      return false;
    }finally{
      update();
    }
  }
}
