import 'dart:developer';

import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class UpdateReasonModuleController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isUpdateReasonModuleInProgress = false;
  String _errorMessage = '';

  bool get isConnected => _isConnected;
  bool get isUpdateReasonModuleInProgress => _isUpdateReasonModuleInProgress;
  String get errorMessage => _errorMessage;

  Future<bool>updateReasonModuleDone({required int id,required String reason}) async{

    _isUpdateReasonModuleInProgress = true;
    update();

    Map<String,String> requestBody = {
      "reason": reason,
    };

    log(reason);
    try{
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.putRequest(url: Urls.updateReasonModuleCleaningUrl(id), body: requestBody);

      log("updateReasonModuleCleaningUrl statusCode ==> ${response.statusCode}");
      log("updateReasonModuleCleaningUrl body ==> ${response.body}");

      _isUpdateReasonModuleInProgress = false;

      if(response.isSuccess){
        update();
        return true;
      }else{
        _errorMessage = "Failed to update module";
        update();
        return false;
      }
    }catch(e){
      _isUpdateReasonModuleInProgress = false;

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