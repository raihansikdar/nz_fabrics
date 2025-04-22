import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/model/daily_water_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class DailyWaterButtonController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isDailyWaterDataInProgress = false;
  String _errorMessage = '';
  List<DailyWaterDataModel> _dailyWaterDataList = <DailyWaterDataModel>[];

  bool get isConnected => _isConnected;
  bool get isDailyWaterDataInProgress => _isDailyWaterDataInProgress;
  String get errorMessage => _errorMessage;
  List<DailyWaterDataModel> get dailyWaterDataList => _dailyWaterDataList;


  Future<bool> fetchDailyWaterData() async {

    _isDailyWaterDataInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getDailyWaterUrl);

      // log("getDailyWaterUrl statusCode ==> ${response.statusCode}");
      // log("getDailyWaterUrl body ==> ${response.body}");

      _isDailyWaterDataInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
        _dailyWaterDataList = jsonData.map((json) => DailyWaterDataModel.fromJson(json as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch daily water data";
        update();
        return false;
      }
    } catch (e) {
      _isDailyWaterDataInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching day water data: $_errorMessage');
      _errorMessage = " Failed to fetch daily water data";
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