import 'dart:developer';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/water/water_this_day_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class WaterThisDayDataController extends GetxController with InternetConnectivityCheckMixin {
  bool _isConnected = true;
  bool _hasError = false;
  bool _isLoading = false;
  String _errorMessage = '';
  WaterThisDayDataModel _thisDayData = WaterThisDayDataModel();

  bool get isConnected => _isConnected;
  bool get isError => _hasError;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  WaterThisDayDataModel get thisDayData => _thisDayData;

  Future<bool> fetchThisDayData({required String sourceName}) async {
    _isLoading = true;
    _isConnected = true;
    update();
    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.thisDayDataUrl(sourceName));

      // log("thisDayDataUrl statusCode ==> ${response.statusCode}");
      // log("thisDayDataUrl body ==> ${response.body}");

      _isLoading = false;

      if (response.isSuccess) {
        _thisDayData = WaterThisDayDataModel.fromJson(response.body);
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

      log('Error in thisDayDataUrl: $_errorMessage');

      update();
      return false;
    }
  }
}
