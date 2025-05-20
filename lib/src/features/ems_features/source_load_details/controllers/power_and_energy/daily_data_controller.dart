import 'dart:developer';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/power_and_energy/daily_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class DailyDataController extends GetxController with InternetConnectivityCheckMixin {
  bool isConnected = true;
  bool hasError = false;
  bool isLoading = false;
  String errorMessage = '';
  List<DailyDataModel> dailyDataList = <DailyDataModel>[];

  Future<bool> fetchDailyData({required String elementName}) async {
    isLoading = true;
    isConnected = true;
    update();
    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.dailyDataUrl(elementName));
      isLoading = false;


      // log(" dailyDataUrl url ==> ${Urls.dailyDataUrl(elementName)}");
      // log(" dailyDataUrl statusCode ==> ${response.statusCode}");
      // log(" dailyDataUrl body ==> ${response.body}");


      if (response.isSuccess) {
         List<dynamic> dataList = response.body;
          dailyDataList = dataList.map((data) => DailyDataModel.fromJson(data as Map<String, dynamic>)).toList();
          update();
          return true;

      } else {
        errorMessage = "Can't load daily line data";
        hasError = true;
        update();
        return false;
      }
    } catch (e) {
      hasError = true;
      isLoading = false;

      errorMessage = e.toString();
      if (e is AppException) {
        errorMessage = e.error.toString();
        isConnected = false;
        hasError = false;
      }

      log('Error in fetching daily data: $errorMessage');
      update();
      return false;
    }
  }
}