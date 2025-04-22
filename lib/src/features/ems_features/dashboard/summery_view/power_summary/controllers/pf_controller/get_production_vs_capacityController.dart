import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/pf_model/get_production_vs_capacity_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class GetProductionVsCapacityController extends GetxController with InternetConnectivityCheckMixin,WidgetsBindingObserver {
  bool _isConnected = true;
  bool _isProductionInProgress = false;
  String _errorMessage = '';
  List<GetProductionVsCapacityModel> _productionVsCapacityList = [];


  bool get isConnected => _isConnected;
  bool get isProductionInProgress => _isProductionInProgress;
  String get errorMessage => _errorMessage;
  List<GetProductionVsCapacityModel> get productionVsCapacityList => _productionVsCapacityList;



 /* Timer? timer;

  @override
  onInit(){
    ever(AuthUtilityController.accessTokenForApiCall, (String? token){
      if(token != null){
        fetchProductionVsCapacity();
        timer = Timer.periodic(const Duration(seconds: 30), (timer) {
          fetchProductionVsCapacity();
        });
      }
    });

    super.onInit();
  }*/

  Timer? _timer;


  bool _isComeFromBackGround = false;
  bool _isStopApiCall = false;
  bool _isEnterGridScreen = false;

  @override
  onInit(){

    WidgetsBinding.instance.addObserver(this);
    ever(AuthUtilityController.accessTokenForApiCall, (String? token){
      if(token != null){
        fetchProductionVsCapacity();
      }
    });

    super.onInit();
  }

  void enterGridScreenMethod(bool value){
    _isEnterGridScreen = value;
    update();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden || state == AppLifecycleState.inactive) {
      _isComeFromBackGround  = true;
      _stopPeriodicApiCallWhenBackGround();
      update();
    } else if (state == AppLifecycleState.resumed) {
      if (!_isStopApiCall && _isComeFromBackGround && _isEnterGridScreen ) {
        _startPeriodicApiCall();
        _isComeFromBackGround  = false;
        _isStopApiCall = false;
        update();
      }

    }
  }


  void _startPeriodicApiCall() {
    _stopPeriodicApiCall();
    _timer = Timer.periodic( const Duration(seconds: kTimer), (timer) {
      fetchProductionVsCapacity();
    });

  }

  void _stopPeriodicApiCall() {
    _isStopApiCall = true;
    _timer?.cancel();
    _timer = null;
    update();
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
    if (Get.isRegistered<GetProductionVsCapacityController>()) {
      final controller = Get.find<GetProductionVsCapacityController>();
      controller._stopPeriodicApiCall();
      // Optionally, you can delete the controller if it's no longer needed
      // Get.delete<PieChartPowerSourceController>();
      log("GetProductionVsCapacityController Stop Api Call");
    }
  }

  void startApiCallOnScreenChange() {
    if (!Get.isRegistered<GetProductionVsCapacityController>()) {
      final controller = Get.put(GetProductionVsCapacityController());
      controller._startPeriodicApiCall();
    } else {
      // If the controller is already registered, just restart the periodic API calls
      final controller = Get.find<GetProductionVsCapacityController>();
      controller._startPeriodicApiCall();
      log("GetProductionVsCapacityController Start Api Call");
    }
    _isStopApiCall = false;
    update();
  }







  Future<bool> fetchProductionVsCapacity() async {
    _isProductionInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getProductionVsCapacityUrl);

      // log("getProductionVsCapacityUrl statusCode ==> ${Urls.getMainBusBarNamesUrl}");
       log("getProductionVsCapacityUrl statusCode ==> ${response.statusCode}");
      // log("getProductionVsCapacityUrl body ==> ${response.body}");

      _isProductionInProgress = false;

      if (response.isSuccess) {
        final jsonData = response.body as List<dynamic>;
        _productionVsCapacityList =jsonData.map((json)=> GetProductionVsCapacityModel.fromJson(json)).toList();

        update();
        return true;
      } else {
        _errorMessage = "Failed to fetch Production vs Capacity.";
        update();
        return false;
      }
    } catch (e) {
      _isProductionInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching  Production vs Capacity : $_errorMessage');
      _errorMessage = "Failed to fetch  Production vs Capacity.";
      update();
      return false;
    }
  }

}
