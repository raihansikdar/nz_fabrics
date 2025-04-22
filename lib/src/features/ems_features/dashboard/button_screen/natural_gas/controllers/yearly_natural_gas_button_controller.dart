import 'dart:developer';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/model/yearly_natural_gas_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class YearlyNaturalGasButtonController extends GetxController with InternetConnectivityCheckMixin{


  bool _isConnected = true;
  bool _isYearlyNaturalGasDataInProgress = false;
  String _errorMessage = '';
  List<YearlyNaturalGasDataModel> _yearlyNaturalGasDataList = <YearlyNaturalGasDataModel>[];


  bool get isConnected => _isConnected;
  bool get isYearlyNaturalGasDataInProgress => _isYearlyNaturalGasDataInProgress;
  String get errorMessage => _errorMessage;
  List<YearlyNaturalGasDataModel> get yearlyNaturalGasDataList => _yearlyNaturalGasDataList;

  int selectedYear = DateTime.now().year;

  void selectedYearMethod(int value){
    selectedYear = value;
    update();
  }


  Future<bool> fetchYearlyNaturalGasData({required int selectedYearDate}) async {

    _isYearlyNaturalGasDataInProgress = true;
    update();


    Map<String, int> requestBody = {
      "year": selectedYearDate,
    };

    log("Request Natural Gas year Date: $selectedYearDate");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.postYearlyNaturalGasUrl,
        body: requestBody,
      );

      log("postYearlyGasGeneratorUrl statusCode ==> ${response.statusCode}");
      log("postYearlyGasGeneratorUrl body ==> ${response.body}");

      _isYearlyNaturalGasDataInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
        _yearlyNaturalGasDataList = jsonData.map((json) => YearlyNaturalGasDataModel.fromJson(json as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch Yearly Natural Gas data";

        update();
        return false;
      }
    } catch (e) {
      _isYearlyNaturalGasDataInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching Yearly gas data: $_errorMessage');

      _errorMessage = " Failed to fetch Yearly Natural Gas data";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
  }
}