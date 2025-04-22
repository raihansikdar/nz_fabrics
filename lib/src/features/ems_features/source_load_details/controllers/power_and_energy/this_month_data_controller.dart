import 'dart:developer';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/power_and_energy/this_month_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class ThisMonthDataController extends GetxController with InternetConnectivityCheckMixin {
  bool _isConnected = true;
  bool _hasError = false;
  bool _isLoading = false;
  String _errorMessage = '';
  List<ThisMonthDataModel> _thisMonthData = [];

  bool get isConnected => _isConnected;
  bool get isError => _hasError;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<ThisMonthDataModel> get thisMonthData => _thisMonthData;

  Future<bool> fetchThisMonthData({required String sourceName}) async {
    _isLoading = true;
    _isConnected = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.thisMonthDataUrl(sourceName));

    //  log("thisMonthDataUrl statusCode ==> ${response.statusCode}");
    //  log("thisMonthDataUrl body ==> ${response.body}");

      _isLoading = false;

      if (response.isSuccess) {
        if (response.body is List) {
          List<dynamic> dataList = response.body;
          _thisMonthData = dataList.map((data) => ThisMonthDataModel.fromJson(data as Map<String, dynamic>)).toList().reversed.toList();
        } else {
          _errorMessage = "Unexpected data format";
          _hasError = true;
        }

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

      log('Error in thisMonthDataUrl: $_errorMessage');

      update();
      return false;
    }
  }

}
