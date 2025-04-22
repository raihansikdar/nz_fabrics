import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/model/daily_gas_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class DailyGasGeneratorButtonController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isDailyGasGeneratorDataInProgress = false;
  String _errorMessage = '';
  List<DailyGasDataModel> _dailyGasGeneratorDataList = <DailyGasDataModel>[];

  bool get isConnected => _isConnected;
  bool get isDailyGasGeneratorDataInProgress => _isDailyGasGeneratorDataInProgress;
  String get errorMessage => _errorMessage;
  List<DailyGasDataModel> get dailyGasGeneratorDataList => _dailyGasGeneratorDataList;


  Future<bool> fetchDailyGasGeneratorData() async {

    _isDailyGasGeneratorDataInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getDailyGasGeneratorUrl);

      // log("getDailyGasGeneratorUrl statusCode ==> ${response.statusCode}");
      // log("getDailyGasGeneratorUrl body ==> ${response.body}");

      _isDailyGasGeneratorDataInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
        _dailyGasGeneratorDataList = jsonData.map((json) => DailyGasDataModel.fromJson(json as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch daily gas generator data";
        update();
        return false;
      }
    } catch (e) {
      _isDailyGasGeneratorDataInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching day Gas generator data: $_errorMessage');
      _errorMessage = " Failed to fetch daily Gas generator data";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
  }


  int selectedButton = 1;
  void updateSelectedButton({required int value}) {
    selectedButton = value;
    log("selected button $selectedButton");
    update();
  }


}