import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/model/electricity_short_lt_production_vs_capacity_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';


class ElectricityShortSLDLtProductionVsCapacityController extends GetxController with InternetConnectivityCheckMixin,WidgetsBindingObserver {


  bool _isConnected = true;
  bool _isLtProductionVsCapacityInProgress = false;
  String _errorMessage = '';
  ElectricityShortLTProductionVsCapacityModel  _ltProductionVsCapacityModel = ElectricityShortLTProductionVsCapacityModel ();

  bool get isConnected => _isConnected;
  bool get isLtProductionVsCapacityInProgress => _isLtProductionVsCapacityInProgress;
  String get errorMessage => _errorMessage;
  ElectricityShortLTProductionVsCapacityModel  get ltProductionVsCapacityModel => _ltProductionVsCapacityModel;



  Timer? _timer;
  bool _isComeFromBackGround = false;
  bool _isStopApiCall = false;

  // @override
  // void onInit() {
  //   super.onInit();
  //   WidgetsBinding.instance.addObserver(this);
  //   ever(AuthUtilityController.accessTokenForApiCall, (String? token) {
  //     if (token != null) {
  //       fetchProductVsCapacityData();
  //       //_startPeriodicApiCall();
  //      }
  //     else {
  //       _stopPeriodicApiCall();
  //     }
  //   });
  // }

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden || state == AppLifecycleState.inactive) {
      _isComeFromBackGround  = true;
      log("===> isComeFromBackGround true");
      _stopPeriodicApiCallWhenBackGround();
      update();

    } else if (state == AppLifecycleState.resumed) {
      log("===> App resumed");
      if (!_isStopApiCall && _isComeFromBackGround) {
        log("===> Resuming API calls...");
        _startPeriodicApiCall();
        _isComeFromBackGround = false;
        _isStopApiCall = false;
        update();
      }

    }
  }

  void _startPeriodicApiCall() {
    _stopPeriodicApiCall();
    _timer = Timer.periodic(const Duration(seconds: kTimer), (timer) {
      fetchProductVsCapacityData();
    });
  }

  void _stopPeriodicApiCall() {
    _isStopApiCall = true;

    log("===> isStopApiCall $_isStopApiCall");

    _timer?.cancel();
    _timer = null;
    // update();
  }


  void _stopPeriodicApiCallWhenBackGround() {
    _timer?.cancel();
    _timer = null;
    update();
  }




  @override
  void onClose() {
    _stopPeriodicApiCall();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  void stopApiCallOnScreenChange() {
    if (Get.isRegistered<ElectricityShortSLDLtProductionVsCapacityController>()) {
      final controller = Get.find<ElectricityShortSLDLtProductionVsCapacityController>();
      controller._stopPeriodicApiCall();
      log("LtProductionVsCapacityController Stop Api Call");
    }
  }

  void startApiCallOnScreenChange() {
    if (!Get.isRegistered<ElectricityShortSLDLtProductionVsCapacityController>()) {
      final controller = Get.put(ElectricityShortSLDLtProductionVsCapacityController());
      controller._startPeriodicApiCall();
    } else {
      final controller = Get.find<ElectricityShortSLDLtProductionVsCapacityController>();
      controller._startPeriodicApiCall();
      log("LtProductionVsCapacityController Start Api Call");
    }
    _isStopApiCall = false;
    update();

  }



  Future<bool> fetchProductVsCapacityData() async {

    _isLtProductionVsCapacityInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getLTProductionVsCapacityUrl);
      log('-----electricity Short ElectricityShortSLDLtProductionVsCapacityController ------>>> ${Urls.getLTProductionVsCapacityUrl}');

      //log("getLTProductionVsCapacityUrl statusCode ==> ${response.statusCode}");
      // log("getLTProductionVsCapacityUrl body ==> ${response.body}");

      _isLtProductionVsCapacityInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body);
        _ltProductionVsCapacityModel = ElectricityShortLTProductionVsCapacityModel.fromJson(jsonData);

        update();
        return true;

      } else {
        _errorMessage = "Failed to fetch LT Production Vs Capacity Data.";
        update();
        return false;
      }
    } catch (e) {
      _isLtProductionVsCapacityInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching LT Production Vs Capacity Data : $_errorMessage');
      _errorMessage = "Failed to fetch LT Production Vs Capacity Data.";

      return false;
    }
  }

}