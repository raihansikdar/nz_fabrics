import 'dart:developer';

import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/model/daily_diesel_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DailyDieselButtonController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isDailyDieselDataInProgress = false;
  String _errorMessage = '';
  List<DailyDieselDataModel> _dailyDieselDataList = <DailyDieselDataModel>[];

  bool get isConnected => _isConnected;
  bool get isDayProgress => _isDailyDieselDataInProgress;
  String get errorMessage => _errorMessage;
  List<DailyDieselDataModel> get dailyDieselDataList => _dailyDieselDataList;


  Future<bool> fetchDailyDieselData() async {

    _isDailyDieselDataInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getDailyDieselUrl);

      // log("getDailyDieselUrl statusCode ==> ${response.statusCode}");
      // log("getDailyDieselUrl body ==> ${response.body}");

      _isDailyDieselDataInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
        _dailyDieselDataList = jsonData.map((json) => DailyDieselDataModel.fromJson(json as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch daily Diesel data";
        update();
        return false;
      }
    } catch (e) {
      _isDailyDieselDataInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching day data: $_errorMessage');
      _errorMessage = " Failed to fetch daily Diesel data";
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