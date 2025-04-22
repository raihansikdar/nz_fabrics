import 'dart:developer';
import 'package:nz_fabrics/src/features/summary_feature/model/todays_total_energy_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class TodayTotalEnergyController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isTodayTotalEnergyInProgress = false;
  String _errorMessage = '';
  TodayTotalEnergyModel _todayTotalEnergyModel = TodayTotalEnergyModel();

  bool get isConnected => _isConnected;
  bool get isTodayTotalEnergyInProgress => _isTodayTotalEnergyInProgress;
  String get errorMessage => _errorMessage;
  TodayTotalEnergyModel get todayTotalEnergyModel => _todayTotalEnergyModel;

  Future<bool>fetchTodayTotalEnergyData() async{

    _isTodayTotalEnergyInProgress = true;
    update();


    try{
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getTodayTotalEnergyUrl);

     // log("getTodayTotalEnergyUrl statusCode ==> ${response.statusCode}");
      log("getTodayTotalEnergyUrl body ==> ${response.body}");

      _isTodayTotalEnergyInProgress = false;

      if(response.isSuccess){
        var jsonData = response.body as Map<String, dynamic>;
        _todayTotalEnergyModel = TodayTotalEnergyModel.fromJson(jsonData);

        update();
        return true;


      }else{
        _errorMessage = "Failed to fetch Today Total Energy";
        update();
        return false;
      }
    }catch(e){
      _isTodayTotalEnergyInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in  Today Total Energy: $_errorMessage');
      _errorMessage = "Failed to fetch Today Total Energy";

      update();
      return false;
    }

  }

}