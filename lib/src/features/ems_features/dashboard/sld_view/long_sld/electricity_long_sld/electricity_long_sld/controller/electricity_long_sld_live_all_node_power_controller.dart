// import 'dart:async';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/electricity_long_live_all_node_power_model.dart';
// import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
// import 'package:nz_fabrics/src/services/network_caller.dart';
// import 'package:nz_fabrics/src/services/network_response.dart';
// import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
// import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
// import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
// import 'package:nz_fabrics/src/utility/style/constant.dart';
//
// class ElectricityLongSLDLiveAllNodePowerController extends GetxController with InternetConnectivityCheckMixin,WidgetsBindingObserver {
//
//
//   bool _isConnected = true;
//   bool _isLiveAllNodePowerInProgress = false;
//   String _errorMessage = '';
//   List<ElectricityLongLiveAllNodePowerModel>  _liveAllNodePowerModel = [];
//
//   bool get isConnected => _isConnected;
//   bool get isLiveAllNodePowerInProgress => _isLiveAllNodePowerInProgress;
//   String get errorMessage => _errorMessage;
//   List<ElectricityLongLiveAllNodePowerModel>  get liveAllNodePowerModel => _liveAllNodePowerModel;
//
//
//
//   Timer? _timer;
//   bool _isComeFromBackGround = false;
//   bool _isStopApiCall = false;
//
//   // @override
//   // void onInit() {
//   //   super.onInit();
//   //
//   //   WidgetsBinding.instance.addObserver(this);
//   //
//   //   ever(AuthUtilityController.accessTokenForApiCall, (String? token) {
//   //     if (token != null) {
//   //       fetchLiveAllNodePower();
//   //      // _startPeriodicApiCall();
//   //     } else {
//   //       _stopPeriodicApiCall();
//   //     }
//   //   });
//   // }
//
//
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden || state == AppLifecycleState.inactive) {
//       _isComeFromBackGround  = true;
//       log("===> isComeFromBackGround true");
//       _stopPeriodicApiCallWhenBackGround();
//       update();
//
//     } else if (state == AppLifecycleState.resumed) {
//       log("===> App resumed");
//       if (!_isStopApiCall && _isComeFromBackGround) {
//         log("===> Resuming API calls...");
//         _startPeriodicApiCall();
//         _isComeFromBackGround = false;
//         _isStopApiCall = false;
//         update();
//       }
//
//     }
//   }
//
//   void _startPeriodicApiCall() {
//     _stopPeriodicApiCall();
//     _timer = Timer.periodic(const Duration(seconds: kTimer), (timer) {
//       fetchLiveAllNodePower();
//     });
//   }
//
//   void _stopPeriodicApiCall() {
//     _isStopApiCall = true;
//
//     log("===> isStopApiCall $_isStopApiCall");
//
//     _timer?.cancel();
//     _timer = null;
//     // update();
//   }
//
//
//   void _stopPeriodicApiCallWhenBackGround() {
//     _timer?.cancel();
//     _timer = null;
//     update();
//   }
//
//
//
//
//   @override
//   void onClose() {
//     _stopPeriodicApiCall();
//     WidgetsBinding.instance.removeObserver(this);
//     super.onClose();
//   }
//
//   void stopApiCallOnScreenChange() {
//     if (Get.isRegistered<ElectricityLongSLDLiveAllNodePowerController>()) {
//       final controller = Get.find<ElectricityLongSLDLiveAllNodePowerController>();
//       controller._stopPeriodicApiCall();
//       log("LiveAllNodePowerController Stop Api Call");
//     }
//   }
//
//   void startApiCallOnScreenChange() {
//     if (!Get.isRegistered<ElectricityLongSLDLiveAllNodePowerController>()) {
//       final controller = Get.put(ElectricityLongSLDLiveAllNodePowerController());
//       controller._startPeriodicApiCall();
//     } else {
//       final controller = Get.find<ElectricityLongSLDLiveAllNodePowerController>();
//       controller._startPeriodicApiCall();
//       log("LiveAllNodePowerController Start Api Call");
//     }
//     _isStopApiCall = false;
//     //update();
//
//   }
//
//
//   Future<bool> fetchLiveAllNodePower() async {
//
//     _isLiveAllNodePowerInProgress = true;
//     //update();
//
//     try {
//       await internetConnectivityCheck();
//
//       NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getElectricityLiveAllNodePowerUrl);
//
//
//       log('-----electricity LOng------>>> ${Urls.baseUrl}/live-all-node-power/?type=electricity');
//
//      // log("getLiveAllNodePowerUrl statusCode ==> ${response.statusCode}");
//      // log("getLiveAllNodePowerUrl body ==> ${response.body}");
//
//       _isLiveAllNodePowerInProgress = false;
//       update();
//
//       if (response.isSuccess) {
//         final jsonData = (response.body as List<dynamic>);
//         _liveAllNodePowerModel = jsonData.map((json)=> ElectricityLongLiveAllNodePowerModel.fromJson(json)).toList();
//
//         update();
//         return true;
//
//       } else {
//         _errorMessage = "Failed to fetch Live All Node Power Data.";
//         update();
//         return false;
//       }
//     } catch (e) {
//       _isLiveAllNodePowerInProgress = false;
//       _errorMessage = e.toString();
//
//       if (e is AppException) {
//         _errorMessage = e.error.toString();
//         _isConnected = false;
//       }
//
//       log('Error in fetching Live All Node Power Data : $_errorMessage');
//       _errorMessage = "Failed to fetch Live All Node Power Data.";
//
//       return false;
//     }
//   }
//
// }

/*
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

class ElectricityLongSLDLiveAllNodePowerController extends GetxController with InternetConnectivityCheckMixin,WidgetsBindingObserver {


  bool _isConnected = true;
  bool _isLiveAllNodePowerInProgress = false;
  String _errorMessage = '';
  List<ElectricityLongLiveAllNodePowerModel>  _liveAllNodePowerModel = [];

  bool get isConnected => _isConnected;
  bool get isLiveAllNodePowerInProgress => _isLiveAllNodePowerInProgress;
  String get errorMessage => _errorMessage;
  List<ElectricityLongLiveAllNodePowerModel>  get liveAllNodePowerModel => _liveAllNodePowerModel;



  Timer? _timer;
  bool _isComeFromBackGround = false;
  bool _isStopApiCall = false;

  // @override
  // void onInit() {
  //   super.onInit();
  //
  //   WidgetsBinding.instance.addObserver(this);
  //
  //   ever(AuthUtilityController.accessTokenForApiCall, (String? token) {
  //     if (token != null) {
  //       fetchLiveAllNodePower();
  //      // _startPeriodicApiCall();
  //     } else {
  //       _stopPeriodicApiCall();
  //     }
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
    if (Get.isRegistered<ElectricityLongSLDLiveAllNodePowerController>()) {
      final controller = Get.find<ElectricityLongSLDLiveAllNodePowerController>();
      controller._stopPeriodicApiCall();
      log("LiveAllNodePowerController Stop Api Call");
    }
  }

  void startApiCallOnScreenChange() {
    if (!Get.isRegistered<ElectricityLongSLDLiveAllNodePowerController>()) {
      final controller = Get.put(ElectricityLongSLDLiveAllNodePowerController());
      controller._startPeriodicApiCall();
    } else {
      final controller = Get.find<ElectricityLongSLDLiveAllNodePowerController>();
      controller._startPeriodicApiCall();
      log("LiveAllNodePowerController Start Api Call");
    }
    _isStopApiCall = false;
    //update();

  }


  Future<bool> fetchLiveAllNodePower() async {
    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getElectricityLiveAllNodePowerUrl);

      log('-----electricity LOng------>>> ${Urls.baseUrl}/live-all-node-power/?type=electricity');

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
        final newData = jsonData.map((json) => ElectricityLongLiveAllNodePowerModel.fromJson(json)).toList();

        // Only update if data has changed to avoid unnecessary rebuilds
        if (!_areListsEqual(_liveAllNodePowerModel, newData)) {
          _liveAllNodePowerModel = newData;
          // Update specific GetBuilder IDs for changed nodes
          for (var node in _liveAllNodePowerModel) {
            update(['node_${node.node}']);
          }
        }
        return true;
      } else {
        _errorMessage = "Failed to fetch Live All Node Power Data.";
        update(['error']); // Update only error-related widgets if needed
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching Live All Node Power Data: $_errorMessage');
      _errorMessage = "Failed to fetch Live All Node Power Data.";
      update(['error']); // Update only error-related widgets if needed
      return false;
    }
  }

// Helper method to compare lists for equality
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
}*/
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
  final RxList<ElectricityLongLiveAllNodePowerModel> _liveAllNodePowerModel = <ElectricityLongLiveAllNodePowerModel>[].obs;

  bool get isConnected => _isConnected;
  bool get isLiveAllNodePowerInProgress => _isLiveAllNodePowerInProgress;
  String get errorMessage => _errorMessage;
  // Update getter to return RxList
  RxList<ElectricityLongLiveAllNodePowerModel> get liveAllNodePowerModel => _liveAllNodePowerModel;

  Timer? _timer;
  bool _isComeFromBackGround = false;
  bool _isStopApiCall = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    startApiCallOnScreenChange();
  }

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

  void startApiCallOnScreenChange() {
    _isStopApiCall = false;
    _startPeriodicApiCall();
    log("LiveAllNodePowerController Start Api Call");
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
    _stopPeriodicApiCall();
    log("LiveAllNodePowerController Stop Api Call");
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