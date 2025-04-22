import 'dart:async';
import 'dart:developer';

import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/model/dash_board_button_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class DashBoardButtonController extends GetxController with InternetConnectivityCheckMixin {
  bool _isConnected = true;
  bool _hasError = false;
  bool _isLoading = false;
  String _errorMessage = '';
  List<DashBoardButtonModel> _buttonList = [];

  bool get isConnected => _isConnected;
  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<DashBoardButtonModel> get buttonList => _buttonList;

  bool makeButtonTrue = false;

  @override
  void onInit() {
    super.onInit();

    ever(AuthUtilityController.accessTokenForApiCall, (String? token){
      if(token != null){
        fetchButton();
      }
    });

  }

  Future<bool> fetchButton() async {
    _isConnected = true;
    _isLoading = true;
    update();
    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getButtonInfoUrl);

     //  log("getButtonInfoUrl statusCode ==> ${response.statusCode}");
     // log("getButtonInfoUrl body ==> ${response.body}");

      _isLoading = false;

      if (response.isSuccess) {
        // _buttonList = (response.body as List).map((data) => DashBoardButtonModel.fromJson(data)).toList();
        _buttonList = (response.body as List).where((data)=> data['type'] != 'summary').map((data) => DashBoardButtonModel.fromJson(data)).toList();

        _hasError = false;
        update();
        return true;
      } else {
        _errorMessage = "Can't load button data";
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
      _errorMessage = "Can't load button data";
      update();
      return false;

    }
  }
}