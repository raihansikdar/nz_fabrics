import 'dart:developer';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/power_and_energy/get_live_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class GetLiveDataController extends GetxController with InternetConnectivityCheckMixin {
  bool _isLoading = false;
  bool _isConnected = true;
  String _errorMessage = '';
  GetLiveDataModel _getLiveDataModel = GetLiveDataModel();

  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  String get errorMessage => _errorMessage;
  GetLiveDataModel get getLiveDataModel => _getLiveDataModel;

  Future<bool> fetchGetLiveData({required String meterName}) async {
    if (_isLoading) return false;

    _isLoading = true;
    _isConnected = true;
    _errorMessage = '';
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getLiveDataUrl(meterName));

      // log("getLiveDataUrl statusCode ==> ${response.statusCode}");
      //  log("getLiveDataUrl body ==> ${response.body}");

      _isLoading = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body);
        _getLiveDataModel = GetLiveDataModel.fromJson(jsonData);
        update();
        return true;

      } else {
        _errorMessage = "Failed to fetch get Live Data.";
        update();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;

      }

      log('Error in fetching get Live Data : $_errorMessage');
      _errorMessage = "Failed to fetch get Live Data.";

      return false;
    }
  }
}
