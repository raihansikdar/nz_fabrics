import 'dart:developer';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/model/yearly_gas_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class YearlyGasGeneratorButtonController extends GetxController with InternetConnectivityCheckMixin{


  bool _isConnected = true;
  bool _isYearlyGasGeneratorDataInProgress = false;
  String _errorMessage = '';
  List<YearlyGasDataModel> _yearlyGasGeneratorDataList = <YearlyGasDataModel>[];


  bool get isConnected => _isConnected;
  bool get isYearlyGasGeneratorDataInProgress => _isYearlyGasGeneratorDataInProgress;
  String get errorMessage => _errorMessage;
  List<YearlyGasDataModel> get yearlyGasGeneratorDataList => _yearlyGasGeneratorDataList;

  int selectedYear = DateTime.now().year;

  void selectedYearMethod(int value){
    selectedYear = value;
    update();
  }


  Future<bool> fetchYearlyGasGeneratorData({required int selectedYearDate}) async {

    _isYearlyGasGeneratorDataInProgress = true;
    update();


    Map<String, int> requestBody = {
      "year": selectedYearDate,
    };

    log("Request Gas Generator year Date: $selectedYearDate");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.postYearlyGasGeneratorUrl,
        body: requestBody,
      );

      log("postYearlyGasGeneratorUrl statusCode ==> ${response.statusCode}");
      log("postYearlyGasGeneratorUrl body ==> ${response.body}");

      _isYearlyGasGeneratorDataInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
        _yearlyGasGeneratorDataList = jsonData.map((json) => YearlyGasDataModel.fromJson(json as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch Yearly Gas generator data";

        update();
        return false;
      }
    } catch (e) {
      _isYearlyGasGeneratorDataInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching Yearly gas generator data: $_errorMessage');

      _errorMessage = " Failed to fetch Yearly Gas generator data";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
  }
}