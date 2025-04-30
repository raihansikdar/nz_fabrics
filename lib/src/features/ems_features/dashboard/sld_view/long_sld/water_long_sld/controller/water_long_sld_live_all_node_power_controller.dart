import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/model/water_long_sld_live_all_node_power_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class WaterLongSLDLiveAllNodePowerController extends GetxController with InternetConnectivityCheckMixin,WidgetsBindingObserver {


  bool _isConnected = true;
  bool _isLiveAllNodePowerInProgress = false;
  String _errorMessage = '';
  List<WaterLiveAllNodePowerModel>  _liveAllNodePowerModel = [];

  bool get isConnected => _isConnected;
  bool get isLiveAllNodePowerInProgress => _isLiveAllNodePowerInProgress;
  String get errorMessage => _errorMessage;
  List<WaterLiveAllNodePowerModel>  get liveAllNodePowerModel => _liveAllNodePowerModel;



  Timer? _timer;
  bool _isComeFromBackGround = false;
  bool _isStopApiCall = false;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addObserver(this);

    ever(AuthUtilityController.accessTokenForApiCall, (String? token) {
      if (token != null) {
        fetchLiveAllNodePower();
       // _startPeriodicApiCall();
      } /*else {
        _stopPeriodicApiCall();
      }*/
    });
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
      fetchLiveAllNodePower();
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
    if (Get.isRegistered<WaterLongSLDLiveAllNodePowerController>()) {
      final controller = Get.find<WaterLongSLDLiveAllNodePowerController>();
      controller._stopPeriodicApiCall();
      log("LiveAllNodePowerController Stop Api Call");
    }
  }

  void startApiCallOnScreenChange() {
    if (!Get.isRegistered<WaterLongSLDLiveAllNodePowerController>()) {
      final controller = Get.put(WaterLongSLDLiveAllNodePowerController());
      controller._startPeriodicApiCall();
    } else {
      final controller = Get.find<WaterLongSLDLiveAllNodePowerController>();
      controller._startPeriodicApiCall();
      log("LiveAllNodePowerController Start Api Call");
    }
    _isStopApiCall = false;
    update();

  }


  Future<bool> fetchLiveAllNodePower() async {

    _isLiveAllNodePowerInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getWaterLiveAllNodePowerUrl);

     // log("getLiveAllNodePowerUrl statusCode ==> ${response.statusCode}");
     // log("getLiveAllNodePowerUrl body ==> ${response.body}");

      _isLiveAllNodePowerInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
        _liveAllNodePowerModel = jsonData.map((json)=> WaterLiveAllNodePowerModel.fromJson(json)).toList();

        update();
        return true;

      } else {
        _errorMessage = "Failed to fetch Live All Node Power Data.";
        update();
        return false;
      }
    } catch (e) {
      _isLiveAllNodePowerInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching Live All Node Power Data : $_errorMessage');
      _errorMessage = "Failed to fetch Live All Node Power Data.";

      return false;
    }
  }

}