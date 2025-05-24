
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/electricity_long_live_all_node_power_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';


class ElectricityLongSLDLiveAllNodePowerController extends GetxController
    with InternetConnectivityCheckMixin, WidgetsBindingObserver {
  bool _isConnected = true;
  bool _isLiveAllNodePowerInProgress = false;
  String _errorMessage = '';
  // Change to RxList to make it observable
  final List<ElectricityLongLiveAllNodePowerModel> _liveAllNodePowerModel = <ElectricityLongLiveAllNodePowerModel>[].obs;

  bool get isConnected => _isConnected;
  bool get isLiveAllNodePowerInProgress => _isLiveAllNodePowerInProgress;
  String get errorMessage => _errorMessage;
  // Update getter to return RxList
  List<ElectricityLongLiveAllNodePowerModel> get liveAllNodePowerModel => _liveAllNodePowerModel;

  Timer? _timer;
  bool _isComeFromBackGround = false;
  bool _isStopApiCall = false;



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      _isComeFromBackGround = true;
      log("===> isComeFromBackGround true");
      _stopPeriodicApiCall();
    } else if (state == AppLifecycleState.resumed) {
      log("===> App resumed");
      if (!_isStopApiCall && _isComeFromBackGround) {
        log("===> Resuming API calls...");
        startApiCallOnScreenChange();
        _isComeFromBackGround = false;
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
    if (Get.isRegistered<ElectricityLongSLDLiveAllNodePowerController>()) {
      final controller = Get.find<ElectricityLongSLDLiveAllNodePowerController>();
      controller._stopPeriodicApiCall();
    }
  }

  void startApiCallOnScreenChange() {
    if (!Get.isRegistered<ElectricityLongSLDLiveAllNodePowerController>()) {
      final controller = Get.put(ElectricityLongSLDLiveAllNodePowerController());
      controller._startPeriodicApiCall();
    } else {
      final controller = Get.find<ElectricityLongSLDLiveAllNodePowerController>();
      controller._startPeriodicApiCall();

    }
    _isStopApiCall = false;
    update();
  }


  Future<bool> fetchLiveAllNodePower() async {
    if (_isLiveAllNodePowerInProgress) return false;
    _isLiveAllNodePowerInProgress = true;

    try {
      await internetConnectivityCheck();
      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getElectricityLiveAllNodePowerUrl);

      log('-----electricity Long getElectricityLiveAllNodePowerUrl------>>> ${Urls.getElectricityLiveAllNodePowerUrl}');
      // log('-----electricity Long Body ------>>> ${response.body}');

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
        final newData = jsonData.map((json) => ElectricityLongLiveAllNodePowerModel.fromJson(json)).toList();

        if (!_areListsEqual(_liveAllNodePowerModel, newData)) {
          _liveAllNodePowerModel.assignAll(newData);
          update();
         // log('Updated liveAllNodePowerModel with ${newData.length} nodes');
        }
        update();
        _isConnected = true;
        return true;
      } else {
        _errorMessage = "Failed to fetch Live All Node Power Data: ${response.statusCode}";
        update(['error']);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error fetching Live All Node Power Data: $_errorMessage');
      update(['error']);
      return false;
    } finally {
      _isLiveAllNodePowerInProgress = false;
    }
  }

  bool _areListsEqual(List<ElectricityLongLiveAllNodePowerModel> oldList, List<ElectricityLongLiveAllNodePowerModel> newList) {
    if (oldList.length != newList.length) return false;
    for (int i = 0; i < oldList.length; i++) {
      if (oldList[i].node != newList[i].node ||
          oldList[i].power != newList[i].power ||
          oldList[i].percentage != newList[i].percentage ||
          oldList[i].capacity != newList[i].capacity) {
        return false;
      }
    }
    return true;
    }
}