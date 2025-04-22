import 'dart:developer';

import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/model/schedule_chart_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';


class ScheduleChartController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isScheduleChartInProgress = false;
  String _errorMessage = '';

  List<ScheduleChartModel> _scheduleChartList = <ScheduleChartModel>[];

  bool get isConnected => _isConnected;
  bool get isScheduleChartInProgress => _isScheduleChartInProgress;
  String get errorMessage => _errorMessage;
  List<ScheduleChartModel> get scheduleChartList => _scheduleChartList;

  Future<bool>fetchScheduleChart() async{

    _isScheduleChartInProgress = true;
    update();


    try{
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getModuleCleaningUrl);

      log("getModuleCleaningUrl statusCode ==> ${response.statusCode}");
      log("getModuleCleaningUrl body ==> ${response.body}");

      _isScheduleChartInProgress = false;

      if(response.isSuccess){
        if (response.body is List) {
          _scheduleChartList = (response.body as List).map((json) => ScheduleChartModel.fromJson(json as Map<String, dynamic>)).toList();
        } else {
          _errorMessage = "Unexpected data format";
          update();
          return false;
        }


        update();
        return true;
      }else{
        _errorMessage = "Failed to fetch schedule chart";
        update();
        return false;
      }
    }catch(e){
      _isScheduleChartInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in Module Cleaning: $_errorMessage');
      _errorMessage = "Failed to fetch schedule chart";

      update();
      return false;
    }

  }

}