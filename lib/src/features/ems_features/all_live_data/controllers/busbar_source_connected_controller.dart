import 'dart:developer';

import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/all_live_data/model/busbar_load_connected_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';


class BusBarSourceConnectedController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _hasError = false;
  bool _isLoading = false;
  String _errorMessage = '';
  List<BusBarConnectedModel> _busBarSourceConnectedList = [];

  bool get isConnected => _isConnected;
  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<BusBarConnectedModel> get busBarSourceConnectedList => _busBarSourceConnectedList;

  Future<bool> fetchSourceConnectedData({required String nodeName}) async {
    _isConnected = true;
    _isLoading = true;
    update();
    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getBusBarSourceConnectedDataUrl(nodeName));

      log("getBusBarSourceConnectedDataUrl statusCode ==> ${response.statusCode}");
      log("getBusBarSourceConnectedDataUrl body ==> ${response.body}");

      _isLoading = false;

      if (response.isSuccess) {
        _busBarSourceConnectedList = (response.body as List).map((data) => BusBarConnectedModel.fromJson(data)).toList();
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

      log('Error in fetchProjectData: $_errorMessage');
      _errorMessage = "Can't Source data";
      update();
      return false;

    }
  }
}