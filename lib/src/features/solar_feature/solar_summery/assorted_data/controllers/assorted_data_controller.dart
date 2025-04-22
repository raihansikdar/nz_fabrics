import 'dart:developer';

import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/model/plant_live_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class AssortedDataController extends GetxController with InternetConnectivityCheckMixin{
  bool _isConnected = true;
  bool _isAssortedDataInProgress= false;
  String _errorMessage = '';
  PlantLiveDataModel _plantLiveDataModel = PlantLiveDataModel();

  bool get isConnected => _isConnected;
  bool get isAssortedDataInProgress=> _isAssortedDataInProgress;
  String get errorMessage => _errorMessage;
  PlantLiveDataModel get  plantLiveDataModel => _plantLiveDataModel;


  Future<bool>fetchPlantLiveData()async{
    _isAssortedDataInProgress= true;
    update();

    try{
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getPlantLiveDataUrl);

    //  log("getPlantLiveDataUrl statusCode ==> ${response.statusCode}");
    //  log("getPlantLiveDataUrl body ==> ${response.body}");

      _isAssortedDataInProgress= false;
      update();

      if(response.isSuccess){
        _plantLiveDataModel = PlantLiveDataModel.fromJson(response.body);
        update();
        return true;
      }else{
        _errorMessage = "Can't fetch plant live data";
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

      log('Error in fetching plant live data": $_errorMessage');
      _errorMessage = "Can't fetch plant live data";

      return false;
    }
  }


}