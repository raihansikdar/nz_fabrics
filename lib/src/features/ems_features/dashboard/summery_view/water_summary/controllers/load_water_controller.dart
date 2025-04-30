// import 'dart:async';
// import 'dart:developer';
// import 'package:flutter/cupertino.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/model/power_model.dart';
// import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
// import 'package:nz_fabrics/src/services/network_caller.dart';
// import 'package:nz_fabrics/src/services/network_response.dart';
// import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
// import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
// import 'package:get/get.dart';
// import 'package:nz_fabrics/src/utility/style/constant.dart';
//
// class LoadWaterController extends GetxController with InternetConnectivityCheckMixin,WidgetsBindingObserver {
//   List<PowerModel> waterList = [];
//   bool isLoading = false;
//   bool hasError = false;
//   bool isConnected = true;
//   bool isFirstTimeLoading = true;
//   Timer? _timer;
//
//   bool _isComeFromBackGround = false;
//   bool _isStopApiCall = false;
//
//   @override
//   void onInit() {
//     super.onInit();
//     WidgetsBinding.instance.addObserver(this);
//
//     ever(AuthUtilityController.accessTokenForApiCall, (String? token) {
//       if (token != null) {
//         fetchLoadWaterData();
//       }
//     });
//   }
//
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden || state == AppLifecycleState.inactive) {
//       _isComeFromBackGround  = true;
//       _stopPeriodicApiCallWhenBackGround();
//       update();
//
//     } else if (state == AppLifecycleState.resumed) {
//       if (!_isStopApiCall && _isComeFromBackGround) {
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
//       fetchLoadWaterData();
//     });
//   }
//
//   void _stopPeriodicApiCall() {
//     _isStopApiCall = true;
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
//   @override
//   void onClose() {
//     _stopPeriodicApiCall();
//     WidgetsBinding.instance.removeObserver(this);
//     super.onClose();
//   }
//
//
//   void stopApiCallOnScreenChange() {
//     if (Get.isRegistered<LoadWaterController>()) {
//       final controller = Get.find<LoadWaterController>();
//       controller._stopPeriodicApiCall();
//       // Optionally, you can delete the controller if it's no longer needed
//       // Get.delete<PieChartPowerSourceController>();
//       log("LoadWaterController Stop Api Call");
//     }
//   }
//
//   void startApiCallOnScreenChange() {
//     if (!Get.isRegistered<LoadWaterController>()) {
//       final controller = Get.put(LoadWaterController());
//       controller._startPeriodicApiCall();
//     } else {
//       // If the controller is already registered, just restart the periodic API calls
//       final controller = Get.find<LoadWaterController>();
//       controller._startPeriodicApiCall();
//       log("LoadWaterController Start Api Call");
//     }
//     _isStopApiCall = false;
//     update();
//
//   }
//
//
//
//   Future<void> fetchLoadWaterData() async {
//
//       try {
//         isConnected = true;
//         if (isFirstTimeLoading) {
//           isLoading = true;
//           update();
//         }
//
//         await internetConnectivityCheck();
//         NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getAllInfoUrl);
//
//          log('LoadWaterController Status Code: ${response.statusCode}');
//          //log('Water summary load Body: ${response.body}');
//
//         if (response.statusCode == 200) {
//           List<dynamic> waterListData = response.body;
//
//           waterList = waterListData.map((item) => PowerModel.fromJson(item)).toList();
//
//           waterList = waterList.where((water) {
//             return water.loadCategory == 'Water' && water.sourceType == 'Load';
//           }).toList();
//
//           isLoading = false;
//
//           update();
//           hasError = false;
//         } else {
//           log('Water fetching error data: ${response.statusCode}, ${response.body}');
//           hasError = true;
//         }
//       } catch (e) {
//         log("Water fetching error data: $e");
//         hasError = true;
//         update();
//       } finally {
//         isLoading = false;
//         isFirstTimeLoading = false;
//         update();
//       }
//
//
//   }
//
// }
