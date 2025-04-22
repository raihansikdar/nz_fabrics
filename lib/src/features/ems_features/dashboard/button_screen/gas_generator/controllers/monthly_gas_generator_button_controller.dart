import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/model/monthly_gas_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class MonthlyGasGeneratorButtonController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isMonthlyGasGeneratorDataInProgress = false;
  String _errorMessage = '';
  List<MonthlyGasDataModel> _monthlyGasGeneratorDataList = <MonthlyGasDataModel>[];


  bool get isConnected => _isConnected;
  bool get isMonthlyGasGeneratorDataInProgress => _isMonthlyGasGeneratorDataInProgress;
  String get errorMessage => _errorMessage;
  List<MonthlyGasDataModel> get monthlyGasGeneratorDataList => _monthlyGasGeneratorDataList;


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





  Future<bool> fetchMonthlyGasGeneratorData({required String selectedMonth, required String selectedYear}) async {

    _isMonthlyGasGeneratorDataInProgress = true;
    update();


    Map<String, String> requestBody = {
      "month": selectedMonth,
      "year": selectedYear,
    };

    log("Request Gas generator month Date: $selectedMonth $selectedYear");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.postMonthlyGasGeneratorUrl,
        body: requestBody,
      );

      log("postMonthlyGasGeneratorUrl statusCode ==> ${response.statusCode}");
      log("postMonthlyGasGeneratorUrl body ==> ${response.body}");

      _isMonthlyGasGeneratorDataInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
        _monthlyGasGeneratorDataList = jsonData.map((json) => MonthlyGasDataModel.fromJson(json as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch Monthly Gas generator data";
        update();
        return false;
      }
    } catch (e) {
      _isMonthlyGasGeneratorDataInProgress = false;
      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching Monthly Gas generator data: $_errorMessage');
      _errorMessage = " Failed to fetch Monthly Gas generator data";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
  }


}
