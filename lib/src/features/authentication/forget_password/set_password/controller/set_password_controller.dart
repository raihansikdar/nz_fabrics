import 'dart:developer';

import 'package:nz_fabrics/src/features/authentication/forget_password/email_verify/controller/email_verify_controller.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class SetPasswordController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isSetPassWordInProgress = false;
  String _errorMessage = '';


  bool get isConnected => _isConnected;
  bool get isSetPassWordInProgress => _isSetPassWordInProgress;
  String get errorMessage => _errorMessage;


  Future<bool>setPassword({required String otp,required String password}) async{

    _isSetPassWordInProgress = true;
    update();

    Map<String,dynamic> requestBody = {
      "password": password,
      "otp": otp
    };

    try{

      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRegisterRequest(url: Get.find<EmailVerifyController>().resetLink, body: requestBody);

      // log("forgetPasswordRequest statusCode ==> ${response.statusCode}");
      // log("forgetPasswordRequest body ==> ${response.body}");

      _isSetPassWordInProgress = false;

      if(response.isSuccess){
        update();
        return true;
      }else{
        _errorMessage = "Reset password failed";
        update();
        return false;
      }
    }catch(e){
      _isSetPassWordInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in set password: $_errorMessage');

      update();
      return false;
    }
  }








  /*------------------------ ui controller -----------------------*/
  bool showPassword = false;

  void showPasswordMethod(){
    showPassword = !showPassword;
    update();
  }

  bool showConfirmPassword = false;

  void showConfirmPasswordMethod(){
    showConfirmPassword = !showConfirmPassword;
    update();
  }

}