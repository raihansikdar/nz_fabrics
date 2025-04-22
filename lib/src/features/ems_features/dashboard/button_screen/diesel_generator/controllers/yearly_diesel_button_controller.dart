import 'dart:developer';

import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/model/yearly_diesel_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class YearlyDieselButtonController extends GetxController with InternetConnectivityCheckMixin{


  bool _isConnected = true;
  bool _isYearlyDieselDataInProgress = false;
  String _errorMessage = '';
  List<YearlyDieselDataModel> _yearlyDieselDataList = <YearlyDieselDataModel>[];


  bool get isConnected => _isConnected;
  bool get isYearlyProgress => _isYearlyDieselDataInProgress;
  String get errorMessage => _errorMessage;
  List<YearlyDieselDataModel> get yearlyDieselDataList => _yearlyDieselDataList;

  int selectedYear = DateTime.now().year;

  void selectedYearMethod(int value){
    selectedYear = value;
    update();
  }


  Future<bool> fetchYearlyDieselData({required int selectedYearDate}) async {

    _isYearlyDieselDataInProgress = true;
    update();


    Map<String, int> requestBody = {
      "year": selectedYearDate,
    };

    log("Request Diesel year Date: $selectedYearDate");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.postYearlyDieselUrl,
        body: requestBody,
      );

      log("postYearlyDieselUrl statusCode ==> ${response.statusCode}");
      log("postYearlyDieselUrl body ==> ${response.body}");

      _isYearlyDieselDataInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
        _yearlyDieselDataList = jsonData.map((json) => YearlyDieselDataModel.fromJson(json as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch Yearly Diesel data";

        update();
        return false;
      }
    } catch (e) {
      _isYearlyDieselDataInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching Yearly data: $_errorMessage');

      _errorMessage = " Failed to fetch Yearly Diesel data";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
  }
}