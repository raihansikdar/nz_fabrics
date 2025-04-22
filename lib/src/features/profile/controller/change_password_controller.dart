import 'dart:developer';

import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isChangePasswordInProgress = false;
  String _errorMessage = '';

  bool get isConnected => _isConnected;
  bool get isChangePasswordInProgress => _isChangePasswordInProgress;
  String get errorMessage => _errorMessage;


  Future<bool>changePassword({required String oldPassword, required String newPassword}) async {

    _isChangePasswordInProgress = true;
    update();


    Map<String,String> requestBody = {
      "old_password": oldPassword,
      "new_password": newPassword,
    };


    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(url: Urls.postChangePasswordUrl,body: requestBody);

      // log("postChangePasswordUrl statusCode ==> ${response.statusCode}");
      // log("postChangePasswordUrl body ==> ${response.body}");

      _isChangePasswordInProgress = false;
      update();

      if (response.isSuccess) {

        update();
        return true;

      } else {
        _errorMessage = (response.body)['message'];

        if(_errorMessage == "Password change unsuccessful. Old password does not match."){
          _errorMessage  = "Old password does not match.";
        }else{
          _errorMessage = "Failed to change password!";
        }

        update();
        return false;
      }
    } catch (e) {
      _isChangePasswordInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in change password: $_errorMessage');

      _errorMessage = "Failed to change password!";

      return false;
    }
  }



  /*-------------- UI ------------------*/
  bool showOldPassword = false;

  void showOldPasswordMethod(){
    showOldPassword = !showOldPassword;
    update();
  }


  bool showNewPassword = false;

  void showNewPasswordMethod(){
    showNewPassword = !showNewPassword;
    update();
  }




}