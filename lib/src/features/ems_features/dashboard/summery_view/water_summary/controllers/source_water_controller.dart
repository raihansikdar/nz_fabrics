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
// class SourceWaterController extends GetxController with InternetConnectivityCheckMixin,WidgetsBindingObserver {
//   List<PowerModel> waterList = [];
//   bool isLoading = false;
//   bool hasError = false;
//   bool isConnected = true;
//   bool isFirstTimeLoading = true;
//   Timer? _timer;
//
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
//         fetchSourceWaterData();
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
//       fetchSourceWaterData();
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
//     if (Get.isRegistered<SourceWaterController>()) {
//       final controller = Get.find<SourceWaterController>();
//       controller._stopPeriodicApiCall();
//       // Optionally, you can delete the controller if it's no longer needed
//       // Get.delete<PieChartPowerSourceController>();
//       log("SourceWaterController Stop Api Call");
//     }
//   }
//
//   void startApiCallOnScreenChange() {
//     if (!Get.isRegistered<SourceWaterController>()) {
//       final controller = Get.put(SourceWaterController());
//       controller._startPeriodicApiCall();
//     } else {
//       // If the controller is already registered, just restart the periodic API calls
//       final controller = Get.find<SourceWaterController>();
//       controller._startPeriodicApiCall();
//       log("SourceWaterController Start Api Call");
//     }
//     _isStopApiCall = false;
//     update();
//
//   }
//
//
//   Future<void> fetchSourceWaterData() async {
//
//     isConnected = true;
//     update();
//
//
//     if (isFirstTimeLoading) {
//       isLoading = true;
//       update();
//     }
//
//       try {
//
//         await internetConnectivityCheck();
//         NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getAllInfoUrl);
//
//          log('SourceWaterController Status Code: ${response.statusCode}');
//          // log('Water summary Body: ${response.body}');
//
//         if (response.statusCode == 200) {
//           List<dynamic> waterListData = response.body;
//           waterList = waterListData.map((item) => PowerModel.fromJson(item)).toList();
//           waterList = waterList.where((water) {
//             return water.sourceCategory == 'Water' && water.sourceType == 'Source';
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
//         log("Water Source fetching error data: $e");
//         hasError = true;
//       } finally {
//         isLoading = false;
//         isFirstTimeLoading = false;
//         update();
//       }
//
//      }
//
// }