import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/model/monthly_water_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class MonthlyWaterButtonController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isMonthlyWaterDataInProgress = false;
  String _errorMessage = '';
  List<MonthlyWaterDataModel> _monthlyWaterDataList = <MonthlyWaterDataModel>[];


  bool get isConnected => _isConnected;
  bool get isMonthlyWaterDataInProgress => _isMonthlyWaterDataInProgress;
  String get errorMessage => _errorMessage;
  List<MonthlyWaterDataModel> get monthlyWaterDataList => _monthlyWaterDataList;


  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  void selectedMonthMethod(int value){
    selectedMonth = value;
    update();
  }

  void selectedYearMethod(int value){
    selectedYear = value;
    update();
  }


  Future<bool> fetchMonthlyWaterData({required String selectedMonth, required String selectedYear}) async {

    _isMonthlyWaterDataInProgress = true;
    update();


    Map<String, String> requestBody = {
      "month": selectedMonth,
      "year": selectedYear,
    };

    log("Request Water month Date: $selectedMonth $selectedYear");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.postMonthlyWaterUrl,
        body: requestBody,
      );

      log("postMonthlyWaterUrl statusCode ==> ${response.statusCode}");
      log("postMonthlyWaterUrl body ==> ${response.body}");

      _isMonthlyWaterDataInProgress = false;
      update();
      if (response.isSuccess) {
        final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
        _monthlyWaterDataList = jsonData.map((json) => MonthlyWaterDataModel.fromJson(json as Map<String, dynamic>)).toList();

        log(_monthlyWaterDataList.length.toString());

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch Monthly water data";
        update();
        return false;
      }
    } catch (e) {
      _isMonthlyWaterDataInProgress = false;
      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching Monthly water data: $_errorMessage');
      _errorMessage = " Failed to fetch Monthly water data";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
  }
}
