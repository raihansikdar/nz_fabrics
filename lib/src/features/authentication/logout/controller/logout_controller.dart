import 'dart:developer';

import 'package:get/get.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';


class LogoutController extends GetxController with InternetConnectivityCheckMixin{



  bool _isConnected = true;
  bool _isLogoutInProgress = false;
  String _errorMessage = '';

  bool get isConnected => _isConnected;
  bool get isLogoutInProgress => _isLogoutInProgress;
  String get errorMessage => _errorMessage;

  Future<bool>logout() async{

    _isLogoutInProgress = true;
    update();

    // Map<String,String> requestBody = {
    //   "refresh_token": refreshToken,
    // };


    try{
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.logoutPostRequest(url: Urls.logoutUrl,/*body: requestBody*/);

      log("logoutPostRequest statusCode ==> ${response.statusCode}");
       log("logoutPostRequest body ==> ${response.body}");

      _isLogoutInProgress = false;

      if(response.isSuccess){
        var responseBody = response.body['success'];
        AuthUtilityController.setAccessToken(token: null);
        AuthUtilityController.setUserRole(userRole: null);


        log("========== responseBody ======= $responseBody");


        update();
        return true;
      }else{
        _errorMessage = "Logout failed";
        update();
        return false;
      }
    }catch(e){
      _isLogoutInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      _errorMessage = "Logout failed";
      log('Error in fetchProjectData: $_errorMessage');

      update();
      return false;
    }

  }





  /*----------------------------ui -------------------------*/
  bool showPassword = false;

  void showPasswordMethod(){
    showPassword = !showPassword;
    update();
  }



}