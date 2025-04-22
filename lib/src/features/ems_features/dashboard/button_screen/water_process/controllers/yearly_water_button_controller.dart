import 'dart:developer';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/model/yearly_water_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class YearlyWaterButtonController extends GetxController with InternetConnectivityCheckMixin{


  bool _isConnected = true;
  bool _isYearlyWaterDataInProgress = false;
  String _errorMessage = '';
  List<YearlyWaterDataModel> _yearlyWaterDataList = <YearlyWaterDataModel>[];


  bool get isConnected => _isConnected;
  bool get isYearlyWaterDataInProgress => _isYearlyWaterDataInProgress;
  String get errorMessage => _errorMessage;
  List<YearlyWaterDataModel> get yearlyWaterDataList => _yearlyWaterDataList;

  int selectedYear = DateTime.now().year;

  void selectedYearMethod(int value){
    selectedYear = value;
    update();
  }


  Future<bool> fetchYearlyWaterData({required int selectedYearDate}) async {

    _isYearlyWaterDataInProgress = true;
    update();


    Map<String, int> requestBody = {
      "year": selectedYearDate,
    };

    log("Request water year Date: $selectedYearDate");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.postYearlyWaterUrl,
        body: requestBody,
      );

      log("postYearlyWaterUrl statusCode ==> ${response.statusCode}");
      log("postYearlyWaterUrl body ==> ${response.body}");

      _isYearlyWaterDataInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
        _yearlyWaterDataList = jsonData.map((json) => YearlyWaterDataModel.fromJson(json as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch Yearly Water data";

        update();
        return false;
      }
    } catch (e) {
      _isYearlyWaterDataInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching Yearly water data: $_errorMessage');

      _errorMessage = " Failed to fetch Yearly water data";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
  }
}