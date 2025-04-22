import 'dart:developer';

import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/model/plant_today_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class DailyPowerConsumptionController extends GetxController with InternetConnectivityCheckMixin{
  bool _isConnected = true;
  bool _isAssortedDataInProgress= false;
  String _errorMessage = '';
  List <PlantTodayDataModel> _plantLiveDataList = [];

  bool get isConnected => _isConnected;
  bool get isAssortedDataInProgress=> _isAssortedDataInProgress;
  String get errorMessage => _errorMessage;
  List <PlantTodayDataModel> get  plantLiveDataModel => _plantLiveDataList;


  Future<bool>fetchPlantTodayData()async{
    _isAssortedDataInProgress= true;
    update();

    try{
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getPlantTodayDataUrl);

       // log("getPlantTodayDataUrl statusCode ==> ${response.statusCode}");
       // log("getPlantTodayDataUrl body ==> ${response.body}");

      _isAssortedDataInProgress= false;
      update();

      if(response.isSuccess){

        var jsonData = response.body as List<dynamic>;

        _plantLiveDataList = jsonData.map((json)=> PlantTodayDataModel.fromJson(json)).toList();
        update();
        return true;
      }else{
        _errorMessage = "Can't fetch plant today data";
        update();
        return false;
      }

    }catch(e){
      _isAssortedDataInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetch plant day data: $_errorMessage');
      _errorMessage = "Can't fetch plant day data";

      return false;
    }
  }


}