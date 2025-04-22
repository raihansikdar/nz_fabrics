import 'dart:developer';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/model/monthly_diesel_data_model.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class MonthlyDieselButtonController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isMonthlyDieselDataInProgress = false;
  String _errorMessage = '';
  List<MonthlyDieselDataModel> _monthlyDieselDataList = <MonthlyDieselDataModel>[];


  bool get isConnected => _isConnected;
  bool get isMonthProgress => _isMonthlyDieselDataInProgress;
  String get errorMessage => _errorMessage;
  List<MonthlyDieselDataModel> get monthlyDieselDataList => _monthlyDieselDataList;


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





  Future<bool> fetchMonthlyDieselData({required String selectedMonth, required String selectedYear}) async {

    _isMonthlyDieselDataInProgress = true;
    update();


    Map<String, String> requestBody = {
      "month": selectedMonth,
      "year": selectedYear,
    };

    log("Request Diesel month Date: $selectedMonth $selectedYear");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.postMonthlyDieselUrl,
        body: requestBody,
      );

      log("postMonthlyDieselUrl statusCode ==> ${response.statusCode}");
      log("postMonthlyDieselUrl body ==> ${response.body}");

      _isMonthlyDieselDataInProgress = false;
      update();
      if (response.isSuccess) {
        final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
        _monthlyDieselDataList = jsonData.map((json) => MonthlyDieselDataModel.fromJson(json as Map<String, dynamic>)).toList();

        log(_monthlyDieselDataList.length.toString());

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch Monthly Diesel data";
        update();
        return false;
      }
    } catch (e) {
      _isMonthlyDieselDataInProgress = false;
      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching Monthly Diesel data: $_errorMessage');
      _errorMessage = " Failed to fetch Monthly Diesel data";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
  }


}


