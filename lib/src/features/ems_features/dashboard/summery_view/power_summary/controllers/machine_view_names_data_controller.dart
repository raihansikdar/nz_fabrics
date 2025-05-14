import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/load_machine_wise_live_data.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/pie_chart_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class MachineViewNamesDataController extends GetxController with InternetConnectivityCheckMixin,WidgetsBindingObserver {
  bool _isLoading = false;
  bool _isConnected = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool isFirstTimeLoading = true;

  List<LoadMachineWiseLiveDataModel>_machineViewNamesDataList = [];
  PieChartDataModel pieChartDataModel = PieChartDataModel();
  List<Data> pieChartDataList = [];

  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<LoadMachineWiseLiveDataModel> get machineViewNamesDataList => _machineViewNamesDataList;

  Timer? _timer;

  bool _isComeFromBackGround = false;
  bool _isStopApiCall = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    ever(AuthUtilityController.accessTokenForApiCall, (String? token) {
      if (token != null) {
        fetchMachineViewNamesData();
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
        fetchMachineViewNamesData();
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
      fetchMachineViewNamesData();
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
    if (Get.isRegistered<MachineViewNamesDataController>()) {
      final controller = Get.find<MachineViewNamesDataController>();
      controller._stopPeriodicApiCall();
      // Optionally, you can delete the controller if it's no longer needed
      // Get.delete<PieChartPowerSourceController>();
      log("MachineViewNamesDataController Stop Api Call");
    }
  }

  void startApiCallOnScreenChange() {
    if (!Get.isRegistered<MachineViewNamesDataController>()) {
      final controller = Get.put(MachineViewNamesDataController());
      controller._startPeriodicApiCall();
    } else {
      // If the controller is already registered, just restart the periodic API calls
      final controller = Get.find<MachineViewNamesDataController>();
      controller._startPeriodicApiCall();
      log("MachineViewNamesDataController Start Api Call");
    }
    _isStopApiCall = false;
    update();
  }



  Future<bool> fetchMachineViewNamesData() async {

    _isConnected = true;
    update();


    if (isFirstTimeLoading) {
      _isLoading = true;
      update();
    }


    try {

      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getLoadMachineWiseLiveDataUrl);

     log("------------->> getLoadMachineWiseLiveDataUrl: ${Urls.getLoadMachineWiseLiveDataUrl}");
     // log("getLoadMachineWiseLiveDataUrl: ${response.statusCode}");
     //  log("getLoadMachineWiseLiveDataUrl: ${response.body}");

      if(response.isSuccess){
        final body = (response.body)['data'];

        _machineViewNamesDataList = (body as List<dynamic>).map((json) =>  LoadMachineWiseLiveDataModel.fromJson(json)).toList();

        pieChartDataModel = PieChartDataModel.fromJson(response.body );
        pieChartDataList = pieChartDataModel.data ?? [];

        update();
        return true;
      }else{
        _errorMessage = "Failed to fetch load summary data";
        update();
        return false;
      }


    } catch (e) {
      if (e is AppException) {
        _isConnected = false;
        _errorMessage = e.error.toString();
        _hasError = false;
        return false;
      } else {
        _errorMessage = e.toString();
        log('Error machine views name data: $_errorMessage');
        _hasError = true;
        return false;
      }

    } finally {
      _isLoading = false;
      isFirstTimeLoading = false;
      update();
    }
  }
}