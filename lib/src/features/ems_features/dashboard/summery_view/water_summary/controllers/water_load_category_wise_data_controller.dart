import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/model/water_load_category_wise_live_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class WaterLoadCategoryWiseDataController extends GetxController with InternetConnectivityCheckMixin,WidgetsBindingObserver {
  bool _isLoading = false;
  bool _isConnected = true;
  bool _hasError = false;
  bool isFirstTimeLoading = true;
  String _errorMessage = '';
  WaterLoadCategoryWiseLiveDataModel _waterLoadCategoryWiseLiveData = WaterLoadCategoryWiseLiveDataModel();

  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  WaterLoadCategoryWiseLiveDataModel get waterLoadCategoryWiseLiveData => _waterLoadCategoryWiseLiveData;

  Timer? _timer;

  bool _isComeFromBackGround = false;
  bool _isStopApiCall = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    ever(AuthUtilityController.accessTokenForApiCall, (String? token) {
      if (token != null) {
        fetchWaterCategoryWiseLiveData();
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
        fetchWaterCategoryWiseLiveData();
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
      fetchWaterCategoryWiseLiveData();
    });
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
    update();
  }

  @override
  void onClose() {
    _stopPeriodicApiCall();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }



  void stopApiCallOnScreenChange() {
    if (Get.isRegistered<WaterLoadCategoryWiseDataController>()) {
      final controller = Get.find<WaterLoadCategoryWiseDataController>();
      controller._stopPeriodicApiCall();
      // Optionally, you can delete the controller if it's no longer needed
      // Get.delete<PieChartPowerSourceController>();
      log("CategoryWiseLiveDataController Stop Api Call");
    }
  }

  void startApiCallOnScreenChange() {
    if (!Get.isRegistered<WaterLoadCategoryWiseDataController>()) {
      final controller = Get.put(WaterLoadCategoryWiseDataController());
      controller._startPeriodicApiCall();
    } else {
      // If the controller is already registered, just restart the periodic API calls
      final controller = Get.find<WaterLoadCategoryWiseDataController>();
      controller._startPeriodicApiCall();
      log("CategoryWiseLiveDataController Start Api Call");
    }
    _isStopApiCall = false;
    update();
  }


  Future<bool> fetchWaterCategoryWiseLiveData() async {

    _isConnected = true;
    _hasError = false;
    _errorMessage = '';
    update();

    if (isFirstTimeLoading) {
      _isLoading = true;
      update();
    }



    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getWaterLoadMachineWiseLiveDataUrl);

      log("getWaterLoadMachineWiseLiveDataUrl: ${response.statusCode}");
      log("getWaterLoadMachineWiseLiveDataUrl: ${response.body}");


      if(response.isSuccess){
        // _waterSourceCategoryWiseLiveData = ((response.body )['data'] as List<dynamic>).map((json)=> WaterSourceCategoryWiseLiveDataModel.fromJson(json)).toList();
        _waterLoadCategoryWiseLiveData =  WaterLoadCategoryWiseLiveDataModel.fromJson(response.body);

        _hasError = false;
        update();
        return true;
      }else{
        _errorMessage = "Can't fetch water load category wise live data";

        _hasError = true;
        update();
        return false;
      }

    } catch (e) {
      if (e is AppException) {
        _isConnected = false;
        _errorMessage = e.error.toString();
        _hasError = false;
        update();
      } else {
        _errorMessage = e.toString();
        log('Error water load category wise live data: $_errorMessage');
        _hasError = true;
        update();
      }
      return false;

    } finally {
      _isLoading = false;
      isFirstTimeLoading = false;
      update();

    }
  }
}