import 'dart:async';
import 'dart:developer';

import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/pie_chart_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';


enum PageState  {loading,error,success,noInternet}

class PieChartPowerSourceController extends GetxController with InternetConnectivityCheckMixin, WidgetsBindingObserver {

  List<Data> pieChartDataList = [];
  // bool isLoading = false;
  // bool hasError = true;
  PageState pageState = PageState.loading;
  bool isConnected = true;
  bool isFirstTimeLoading = true;
  var errorMessage = '';
  Timer? _timer;

  PieChartDataModel pieChartDataModel = PieChartDataModel();


  bool _isComeFromBackGround = false;
  bool _isStopApiCall = false;

  // @override
  // void onInit() {
  //   super.onInit();
  //   WidgetsBinding.instance.addObserver(this);
  //
  //   ever(AuthUtilityController.accessTokenForApiCall, (String? token) {
  //     if (token != null) {
  //       fetchPieChartData();
  //      // _startPeriodicApiCall();
  //     } /*else {
  //       _stopPeriodicApiCall();
  //     }*/
  //   });
  // }



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
    if (Get.isRegistered<PieChartPowerSourceController>()) {
      final controller = Get.find<PieChartPowerSourceController>();
      controller._stopPeriodicApiCall();
      // Optionally, you can delete the controller if it's no longer needed
      // Get.delete<PieChartPowerSourceController>();
      log("PieChartPowerSourceController Stop Api Call");
    }
  }

  void startApiCallOnScreenChange() {
    if (!Get.isRegistered<PieChartPowerSourceController>()) {
      final controller = Get.put(PieChartPowerSourceController());
      controller._startPeriodicApiCall();
    } else {
      // If the controller is already registered, just restart the periodic API calls
      final controller = Get.find<PieChartPowerSourceController>();
      controller._startPeriodicApiCall();
      log("PieChartPowerSourceController Start Api Call");
    }
    _isStopApiCall = false;
   update();

  }

  Future<void> fetchPieChartData() async {
    isConnected = true;
    update();

    if (isFirstTimeLoading) {
       pageState = PageState.loading;
      update();
    }

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: "Urls.getSourceCategoryWiseLiveDataUrl");

     log('PieChartPowerSourceController Status: ${response.statusCode}');
    // log('getSourceCategoryWiseLiveDataUrl Data Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = response.body;

        if (jsonData is Map<String, dynamic>) {
          pieChartDataModel = PieChartDataModel.fromJson(jsonData);
          pieChartDataList = pieChartDataModel.data ?? [];
           pageState = PageState.success;

        } else {
          pageState = PageState.error;
          errorMessage = 'Unexpected data format';
        }
      } else {
        pageState = PageState.error;
        errorMessage = 'Failed to load data: ${response.body}';
      }
    } catch (e) {

      if (e is AppException) {
        isConnected = false;
        pageState = PageState.noInternet;

      }else{
        pageState = PageState.error;
      }
      errorMessage = e.toString();
    } finally {

      isFirstTimeLoading = false;
      update();
    }
  }

}

