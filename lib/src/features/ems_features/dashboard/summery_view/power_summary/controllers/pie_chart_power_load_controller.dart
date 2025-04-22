import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/pie_chart_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';


class PieChartPowerLoadController extends GetxController with InternetConnectivityCheckMixin,WidgetsBindingObserver {
  List<Data> pieChartDataList = [];
  bool isLoading = false;
  bool hasError = false;
  bool isConnected = true;
  bool isFirstTimeLoading = true;
  var errorMessage = '';
  Timer? _timer;

  PieChartDataModel pieChartDataModel = PieChartDataModel();

  bool _isComeFromBackGround = false;
  bool _isStopApiCall = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    ever(AuthUtilityController.accessTokenForApiCall, (String? token) {
      if (token != null) {
        fetchPieChartLoadData();
        _startPeriodicApiCall();
      } else {
        _stopPeriodicApiCall();
      }
    });
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden || state == AppLifecycleState.inactive) {

      _isComeFromBackGround  = true;
      _stopPeriodicApiCallWhenBackGround();
      update();

    } else if (state == AppLifecycleState.resumed) {

      if (!_isStopApiCall && _isComeFromBackGround) {
        fetchPieChartLoadData();
        _startPeriodicApiCall();
        _isComeFromBackGround  = false;
        _isStopApiCall = false;
        update();
      }

    }
  }

  void _startPeriodicApiCall() {
    _stopPeriodicApiCall();
    _timer = Timer.periodic(const Duration(seconds: kTimer), (timer) {
      fetchPieChartLoadData();
    });
    update();
  }

  void _stopPeriodicApiCall() {
    _isStopApiCall = true;
    _timer?.cancel();
    _timer = null;
    //update();
  }

  void _stopPeriodicApiCallWhenBackGround() {
    _timer?.cancel();
    _timer = null;

  }

  @override
  void onClose() {
    _stopPeriodicApiCall();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  void stopApiCallOnScreenChange() {
    if (Get.isRegistered<PieChartPowerLoadController>()) {
      final controller = Get.find<PieChartPowerLoadController>();
      controller._stopPeriodicApiCall();
      log("PieChartPowerLoadController Stop Api Call");
    }
  }

  void startApiCallOnScreenChange() {
    if (!Get.isRegistered<PieChartPowerLoadController>()) {
      final controller = Get.put(PieChartPowerLoadController());
      controller._startPeriodicApiCall();
    } else {
      final controller = Get.find<PieChartPowerLoadController>();
      controller._startPeriodicApiCall();
      log("PieChartPowerLoadController Start Api Call");

    }
    _isStopApiCall = false;
    update();
  }


  Future<void> fetchPieChartLoadData() async {
    isConnected = true;
    update();
    if (isFirstTimeLoading) {
      isLoading = true;
      update();
    }

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getLoadMachineWiseLiveDataUrl);

      isLoading = false;
      update();


      log('PieChartPowerLoadController getLoadMachineWiseLiveDataUrl: ${response.statusCode}');
    //   log('getLoadMachineWiseLiveDataUrl: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = response.body;


        if (jsonData is Map<String, dynamic>) {
          pieChartDataModel = PieChartDataModel.fromJson(jsonData);
          pieChartDataList = pieChartDataModel.data ?? [];
          hasError = false;

        } else {
          hasError = true;
          errorMessage= 'Unexpected data format';
        }
      } else {
        hasError = true;
        errorMessage = 'Failed to load pie chart data: ${response.body}';
      }
    } catch (e) {
      hasError = true;
      isLoading = false;
      if (e is AppException) {
        isConnected = false;
        hasError = false;
      }
      errorMessage = e.toString();
      update();
      log('Load Error: $e');
    } finally {
      isLoading = false;
      isFirstTimeLoading = false;
      update();
    }
  }
}


