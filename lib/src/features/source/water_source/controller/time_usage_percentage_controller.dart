// import 'dart:developer';
//
// import 'package:nz_ums/src/features/water_source/model/time_usage_percentage_model.dart';
// import 'package:nz_ums/src/services/internet_connectivity_check_mixin.dart';
// import 'package:get/get.dart';
// import 'package:nz_ums/src/services/network_caller.dart';
// import 'package:nz_ums/src/services/network_response.dart';
// import 'package:nz_ums/src/utility/app_urls/app_urls.dart';
// import 'package:nz_ums/src/utility/exception/app_exception.dart';
//
// class TimeUsagePercentageController extends GetxController with InternetConnectivityCheckMixin {
//
//   bool _isConnected = true;
//   bool _isTimeUsagePercentageInProgress = false;
//   String _errorMessage = '';
//   TimeUsagePercentageModel _timeUsagePercentageModel = TimeUsagePercentageModel();
//
//   bool get isConnected => _isConnected;
//   bool get isTimeUsagePercentageInProgress => _isTimeUsagePercentageInProgress;
//   String get errorMessage => _errorMessage;
//   TimeUsagePercentageModel get timeUsagePercentageModel => _timeUsagePercentageModel;
//
//
//   Future<bool> fetchTimeUsagesPercentageData() async {
//
//     _isTimeUsagePercentageInProgress = true;
//     update();
//
//     try {
//       await internetConnectivityCheck();
//
//       NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getTimeUsageInPercentageUrl);
//
//     //  log("getTimeUsageInPercentageUrl statusCode ==> ${response.statusCode}");
//      // log("getTimeUsageInPercentageUrl body ==> ${response.body}");
//
//       _isTimeUsagePercentageInProgress = false;
//       update();
//
//       if (response.isSuccess) {
//         final jsonData = (response.body);
//         _timeUsagePercentageModel = TimeUsagePercentageModel.fromJson(jsonData);
//
//         update();
//         return true;
//
//       } else {
//         _errorMessage = "Failed to fetch time usage in percentage.";
//         update();
//         return false;
//       }
//     } catch (e) {
//       _isTimeUsagePercentageInProgress = false;
//       _errorMessage = e.toString();
//
//       if (e is AppException) {
//         _errorMessage = e.error.toString();
//         _isConnected = false;
//       }
//
//       log('Error in fetching time usage in percentage data : $_errorMessage');
//       _errorMessage = "Failed to fetch time usage in percentage data.";
//
//       return false;
//     }
//   }
//
// }