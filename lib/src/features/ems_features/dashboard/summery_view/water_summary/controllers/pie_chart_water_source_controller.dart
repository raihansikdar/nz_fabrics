import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/model/water_pie_chart_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/model/water_pie_chart_total_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class PieChartWaterSourceController extends GetxController with InternetConnectivityCheckMixin,WidgetsBindingObserver {
  List<WaterPieChartDataModel> waterPieChartDataList = [];
  WaterPieChartTotalDataModel waterPieChartTotalSourceList = WaterPieChartTotalDataModel();
  bool isLoading = false;
  bool hasError = false;
  bool isConnected = true;
  bool isFirstTimeLoading = true;
  var errorMessage = ''.obs;

  Timer? _timer;


  bool _isComeFromBackGround = false;
  bool _isStopApiCall = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    ever(AuthUtilityController.accessTokenForApiCall, (String? token) {
      if (token != null) {
        fetchPieChartData();
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
        fetchPieChartData();
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
      fetchPieChartData();
    });
  }

  void _stopPeriodicApiCall() {
    _isStopApiCall = true;

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
    if (Get.isRegistered<PieChartWaterSourceController>()) {
      final controller = Get.find<PieChartWaterSourceController>();
      controller._stopPeriodicApiCall();
      // Optionally, you can delete the controller if it's no longer needed
      // Get.delete<PieChartPowerSourceController>();
      log("PieChartWaterSourceController Stop Api Call");
    }
  }

  void startApiCallOnScreenChange() {
    if (!Get.isRegistered<PieChartWaterSourceController>()) {
      final controller = Get.put(PieChartWaterSourceController());
      controller._startPeriodicApiCall();
    } else {
      // If the controller is already registered, just restart the periodic API calls
      final controller = Get.find<PieChartWaterSourceController>();
      controller._startPeriodicApiCall();
      log("PieChartWaterSourceController Start Api Call");
    }
    _isStopApiCall = false;
    update();

  }



  Future<void> fetchPieChartData() async {
    isConnected = true;
    update();


    if (isFirstTimeLoading) {
      isLoading = true;
      update();
    }

    try {

      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.pieChartWaterSourceUrl);
     log("pieChartWaterSourceUrl status: ${response.statusCode}");
    // log("pieChartWaterSourceUrl body: ${response.body}");

      isLoading = false;
      update();

      if (response.statusCode == 200) {
        final jsonData = response.body;

       // log('Pie Chart Water Data : $jsonData');

        if (jsonData is Map<String, dynamic>) {
          // Extract relevant data
          waterPieChartDataList = jsonData.entries
              .where((entry) =>
          (entry.value is double || entry.value is int) &&
              entry.key != 'total' &&
              entry.key != 'total_cost')
              .map((entry) =>
              WaterPieChartDataModel(entry.key, (entry.value as num).toDouble()))
              .toList();

          waterPieChartTotalSourceList = WaterPieChartTotalDataModel.fromJson(jsonData);
        } else {
          hasError = true;
          throw Exception('Unexpected data format for water');
        }

      } else {
        hasError = true;
        throw Exception('Failed to load Water data: ${response.statusCode}');
      }
    } catch (e) {
      hasError = true;
      isLoading = false;
      if (e is AppException) {
        isConnected = false;
        hasError = false;
      }
      update();
      log('Water Pie Chart Source fetching error data: $e');
    } finally {
      isLoading = false;
       isFirstTimeLoading = false;
      update();
    }
  }
}
