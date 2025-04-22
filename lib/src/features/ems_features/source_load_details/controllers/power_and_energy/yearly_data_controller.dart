import 'dart:developer';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/power_and_energy/yearly_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class YearlyDataController extends GetxController with InternetConnectivityCheckMixin {
  bool isConnected = true;
  bool hasError = false;
  bool isLoading = false;
  String errorMessage = '';
  List<YearlyDataModel> yearlyDataList = <YearlyDataModel>[];

  Future<bool> fetchYearlyData({required String elementName}) async {
    isLoading = true;
    isConnected = true;
    update();

    try {
      await internetConnectivityCheck();
      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.yearlyDataUrl(elementName));

      isLoading = false;

      // log("thisYearDataUrl ========> statusCode ==> ${response.statusCode}");
      // log("thisYearDataUrl ==========> body ==> ${response.body}");

      if (response.isSuccess) {
        List<dynamic> dataList = response.body;
        yearlyDataList = dataList.map((data) => YearlyDataModel.fromJson(data as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        errorMessage = "Can't load data";
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

      log('Error in fetching Yearly data: $errorMessage');

      update();
      return false;
    }
  }
}
