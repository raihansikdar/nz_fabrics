import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/pf_model/get_live_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/pf_model/inner_children_name_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/pf_model/main_bus_bar_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class MainBusBarController extends GetxController with InternetConnectivityCheckMixin,WidgetsBindingObserver {
  bool _isConnected = true;
  bool _isMainBusBarInProgress = false;
  String _errorMessage = '';
  List<String> _mainBusBarList = [];
  bool _isFirstApiCall = true;


  bool get isConnected => _isConnected;
  bool get isMainBusBarInProgress => _isMainBusBarInProgress;
  String get errorMessage => _errorMessage;
  List<String> get mainBusBarList => _mainBusBarList;




  String _liveDataErrorMessage = '';
  bool _isGetLiveDataInProgress = false;
  List<GetLiveDataModel> _getLiveDataModel = [];

  String get liveDataErrorMessage => _liveDataErrorMessage;
  bool get isGetLiveDataInProgress => _isGetLiveDataInProgress;
  List<GetLiveDataModel> get getLiveDataModel => _getLiveDataModel;



  bool _isInnerChildrenInProgress = false;
  String _innerChildrenErrorMessage = '';
  List<InnerChildrenNameModel> _innerChildrenNameModel = [];
  List<GetLiveDataModel> _getInnerChildrenList = [];

  bool get isInnerChildrenInProgress => _isInnerChildrenInProgress;
  String get innerChildrenErrorMessage => _innerChildrenErrorMessage;
  List<InnerChildrenNameModel> get innerChildrenNameModel => _innerChildrenNameModel;
  List<GetLiveDataModel> get getInnerChildrenList => _getInnerChildrenList;

  Timer? _timer;


  bool _isComeFromBackGround = false;
  bool _isStopApiCall = false;
  bool _isEnterGridScreen = false;

  @override
  onInit(){

    WidgetsBinding.instance.addObserver(this);
    ever(AuthUtilityController.accessTokenForApiCall, (String? token){
      if(token != null){
        fetchMainBusBar();
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
      fetchMainBusBar();
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
    if (Get.isRegistered<MainBusBarController>()) {
      final controller = Get.find<MainBusBarController>();
      controller._stopPeriodicApiCall();
      // Optionally, you can delete the controller if it's no longer needed
      // Get.delete<PieChartPowerSourceController>();
      log("MainBusBarController Stop Api Call");
    }
  }

  void startApiCallOnScreenChange() {
    if (!Get.isRegistered<MainBusBarController>()) {
      final controller = Get.put(MainBusBarController());
      controller._startPeriodicApiCall();
    } else {
      // If the controller is already registered, just restart the periodic API calls
      final controller = Get.find<MainBusBarController>();
      controller._startPeriodicApiCall();
      log("MainBusBarController Start Api Call");
    }
    _isStopApiCall = false;
    update();
  }


  Future<bool> fetchMainBusBar() async {


    if(_isFirstApiCall){
      _isMainBusBarInProgress = true;
      update();
    }



    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getMainBusBarNamesUrl);

      // log("getMainBusBarNamesUrl statusCode ==> ${Urls.getMainBusBarNamesUrl}");
       log("getMainBusBarNamesUrl statusCode ==> ${response.statusCode}");
      // log("getMainBusBarNamesUrl body ==> ${response.body}");



      if (response.isSuccess) {
        final MainBusBarModel mainBusBarModel = MainBusBarModel.fromJson(response.body);
        _mainBusBarList = mainBusBarModel.mainBusbars.reversed.toList();

        _getLiveDataModel.clear();

        for (var node in _mainBusBarList) {
          final GetLiveDataModel? liveData = await fetchGetLiveData(node);
          if (liveData != null) {
            _getLiveDataModel.add(liveData);
          }
        }
        _innerChildrenNameModel.clear();
        _getInnerChildrenList.clear();

        for (var node in _mainBusBarList) {
          final InnerChildrenNameModel? childrenNameData = await fetchInnerChildrenData(node);
          if (childrenNameData != null) {
            _innerChildrenNameModel.add(childrenNameData);

            for (var child in childrenNameData.children ?? []) {
              final GetLiveDataModel? liveData = await fetchGetLiveData(child.nodeName ?? '');
              if (liveData != null) {
                // log("============> ${liveData.node}");
                _getInnerChildrenList.add(liveData);
              }
            }
          }
        }


        update();
        return true;
      } else {
        _errorMessage = "Failed to fetch Main Bus Bars.";
        update();
        return false;
      }
    } catch (e) {
      _isMainBusBarInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching Main Bus Bars: $_errorMessage');
      _errorMessage = "Failed to fetch Main Bus Bars.";
      update();
      return false;
    }finally{
      _isMainBusBarInProgress = false;
      _isFirstApiCall = false;
      update();
    }
  }

  Future<GetLiveDataModel?> fetchGetLiveData(String sourceName) async {
    _isGetLiveDataInProgress = true;

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getLiveDataUrl(sourceName));

      // log("getLiveDataUrl statusCode ==> ${Urls.getLiveDataUrl(sourceName)}");
      // log("getLiveDataUrl statusCode ==> ${response.statusCode}");
      // log("getLiveDataUrl body ==> ${response.body}");

      _isGetLiveDataInProgress = false;

      if (response.isSuccess) {
        final GetLiveDataModel liveData = GetLiveDataModel.fromJson(response.body);
        return liveData;
      } else {
        _liveDataErrorMessage = "Failed to fetch Live Data for $sourceName.";
        return null;
      }
    } catch (e) {
      _isGetLiveDataInProgress = false;
      _liveDataErrorMessage = e.toString();

      if (e is AppException) {
        _liveDataErrorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching Live Data for $sourceName: $_liveDataErrorMessage');
      return null;
    }
  }

  Future<InnerChildrenNameModel?> fetchInnerChildrenData(String sourceName) async {
    _isInnerChildrenInProgress = true;

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getInnerChildrenDataUrl(sourceName));

      // log("getInnerChildrenDataUrl statusCode ==> ${Urls.getInnerChildrenDataUrl(sourceName)}");
      // log("getInnerChildrenDataUrl statusCode ==> ${response.statusCode}");
      // log("getInnerChildrenDataUrl body ==> ${response.body}");

      _isInnerChildrenInProgress = false;

      if (response.isSuccess) {
        final InnerChildrenNameModel childrenData = InnerChildrenNameModel.fromJson(response.body);

        return childrenData;
      } else {
        _innerChildrenErrorMessage = "Failed to fetch Inner Children Name for $sourceName.";

        return null;
      }
    } catch (e) {
      _isInnerChildrenInProgress = false;
      _innerChildrenErrorMessage = e.toString();

      if (e is AppException) {
        _innerChildrenErrorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching Inner Children Name for $sourceName: $_innerChildrenErrorMessage');
      return null;
    }
  }
}
