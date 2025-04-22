import 'dart:developer';

import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class UpdateModuleController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isUpdateModuleInProgress = false;
  String _errorMessage = '';

  bool get isConnected => _isConnected;
  bool get isUpdateModuleInProgress => _isUpdateModuleInProgress;
  String get errorMessage => _errorMessage;

  Future<bool>updateModuleDone({required int id,required String status}) async{

    _isUpdateModuleInProgress = true;
    update();

    Map<String,String> requestBody = {
      "cleaning_status": status,
    };

    try{
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.putRequest(url: Urls.updateModuleCleaningUrl(id), body: requestBody);

      log("updateModuleCleaningUrl statusCode ==> ${response.statusCode}");
      log("updateModuleCleaningUrl body ==> ${response.body}");

      _isUpdateModuleInProgress = false;

      if(response.isSuccess){
        update();
        return true;
      }else{
        _errorMessage = "Failed to update module";
        update();
        return false;
      }
    }catch(e){
      _isUpdateModuleInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in update module : $_errorMessage');
      _errorMessage = "Failed to update module";

      update();
      return false;
    }

  }
}