import 'dart:developer';

import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/all_live_data/model/busbar_load_connected_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';


class BusBarLoadConnectedController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _hasError = false;
  bool _isLoading = false;
  String _errorMessage = '';
  List<BusBarConnectedModel> _busBarLoadConnectedList = [];

  bool get isConnected => _isConnected;
  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<BusBarConnectedModel> get busBarLoadConnectedList => _busBarLoadConnectedList;

  Future<bool> fetchLoadConnectedData({required String nodeName}) async {
    _isConnected = true;
    _isLoading = true;
    update();
    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getBusBarLoadConnectedDataUrl(nodeName));

      log("getBusBarLoadConnectedDataUrl statusCode ==> ${response.statusCode}");
      log("getBusBarLoadConnectedDataUrl body ==> ${response.body}");

      _isLoading = false;

      if (response.isSuccess) {
        _busBarLoadConnectedList = (response.body as List).map((data) => BusBarConnectedModel.fromJson(data)).toList();
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
      _errorMessage = "Can't load data";
      update();
      return false;

    }
  }

}