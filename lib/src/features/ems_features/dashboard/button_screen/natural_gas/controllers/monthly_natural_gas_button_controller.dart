import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/model/monthly_natural_gas_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class MonthlyNaturalGasButtonController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isMonthlyNaturalGasDataInProgress = false;
  String _errorMessage = '';
  List<MonthlyNaturalGasDataModel> _monthlyNaturalGasDataList = <MonthlyNaturalGasDataModel>[];


  bool get isConnected => _isConnected;
  bool get isMonthlyNaturalGasDataInProgress => _isMonthlyNaturalGasDataInProgress;
  String get errorMessage => _errorMessage;
  List<MonthlyNaturalGasDataModel> get monthlyNaturalGasDataList => _monthlyNaturalGasDataList;


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





  Future<bool> fetchMonthlyNaturalGasData({required String selectedMonth, required String selectedYear}) async {

    _isMonthlyNaturalGasDataInProgress = true;
    update();


    Map<String, String> requestBody = {
      "month": selectedMonth,
      "year": selectedYear,
    };

    log("Request Gas month Date: $selectedMonth $selectedYear");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.postMonthlyNaturalGasUrl,
        body: requestBody,
      );

      log("postMonthlyGasGeneratorUrl statusCode ==> ${response.statusCode}");
      log("postMonthlyGasGeneratorUrl body ==> ${response.body}");

      _isMonthlyNaturalGasDataInProgress = false;
      update();
      if (response.isSuccess) {
        final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
        _monthlyNaturalGasDataList = jsonData.map((json) => MonthlyNaturalGasDataModel.fromJson(json as Map<String, dynamic>)).toList();

        log(_monthlyNaturalGasDataList.length.toString());

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch Monthly Gas data";
        update();
        return false;
      }
    } catch (e) {
      _isMonthlyNaturalGasDataInProgress = false;
      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching Monthly Gas data: $_errorMessage');
      _errorMessage = " Failed to fetch Monthly Gas data";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
  }


}
