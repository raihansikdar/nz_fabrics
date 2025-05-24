import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/busbar_status_info_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:nz_fabrics/src/utility/exception/debug_logger.dart';

import '../../../../../../../../utility/style/constant.dart';

class BusBarStatusInfoController extends GetxController with InternetConnectivityCheckMixin,WidgetsBindingObserver {
  bool _isConnected = true;
  bool _isBusBarStatusProgress = false;
  String _errorMessage = '';
  List<BusBarStatusInfoModel> _busBarStatusModels = []; // Changed to a list

  bool get isConnected => _isConnected;
  bool get isBusBarStatusProgress => _isBusBarStatusProgress;
  String get errorMessage => _errorMessage;
  List<BusBarStatusInfoModel> get busBarStatusModels => _busBarStatusModels; // Updated getter

  Timer? _timer;
  bool _isStopApiCall = false;
  bool _isComeFromBackGround = false;

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
      stopApiCallOnScreenChange();
      _stopPeriodicApiCallWhenBackGround();
      update();
    } else if (state == AppLifecycleState.resumed) {

      if (!_isStopApiCall && _isComeFromBackGround) {
        fetchBusBarStatusData();
        _startPeriodicApiCall();
        _isComeFromBackGround = false;
        _isStopApiCall = false;
        update();
      }

    }
  }

  void _stopPeriodicApiCallWhenBackGround() {
    _timer?.cancel();
    _timer = null;
    update();
  }


  void _startPeriodicApiCall() {
    _stopPeriodicApiCall();
    _timer = Timer.periodic(const Duration(seconds: kTimer), (timer) {
      fetchBusBarStatusData();
    });
  }

  void _stopPeriodicApiCall() {
    _isStopApiCall = true;
    _timer?.cancel();
    _timer = null;
    log("===> isStopApiCall $_isStopApiCall");
  }

  @override
  void onClose() {
    _stopPeriodicApiCall();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  void stopApiCallOnScreenChange() {
    if (Get.isRegistered<BusBarStatusInfoController>()) {
      final controller = Get.find<BusBarStatusInfoController>();
      controller._stopPeriodicApiCall();
    }
  }

  void startApiCallOnScreenChange() {
    if (!Get.isRegistered<BusBarStatusInfoController>()) {
      final controller = Get.put(BusBarStatusInfoController());
      controller._startPeriodicApiCall();
    } else {
      final controller = Get.find<BusBarStatusInfoController>();
      controller._startPeriodicApiCall();

    }
    _isStopApiCall = false;
    update();
  }




  Future<bool> fetchBusBarStatusData() async {
    _isBusBarStatusProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getBusBarStatusUrl);

      // log("getBusBarStatusUrl statusCode ==> ${response.statusCode}");
      // log("getBusBarStatusUrl body ==> ${response.body}");

     // Pretty-print the JSON response body
      DebugLogger.printJsonResponse(
        url: Urls.getBusBarStatusUrl,
        tag: 'getBusBarStatusUrl',
        responseBody: response.body,
        statusCode: response.statusCode,
      );

      _isBusBarStatusProgress = false;

      if (response.isSuccess) {
        final jsonData = response.body;

        // Check if jsonData is a List
        if (jsonData is List) {
          _busBarStatusModels = jsonData
              .map((item) => BusBarStatusInfoModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (jsonData is Map<String, dynamic>) {
          // Handle single object case (optional, for backward compatibility)
          _busBarStatusModels = [BusBarStatusInfoModel.fromJson(jsonData)];
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
