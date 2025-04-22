import 'dart:developer';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class EmailVerifyController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isError = false;
  bool _isEmailVerifyInProgress = false;
  String _errorMessage = '';
  String _resetLink = '';
  int _otp = 0;

  bool get isConnected => _isConnected;
  bool get isError => _isError;
  bool get isEmailVerifyInProgress => _isEmailVerifyInProgress;
  String get errorMessage => _errorMessage;
  String get resetLink => _resetLink;
  int get otp => _otp;


  Future<bool> verifyEmail({required String email}) async {
    _isEmailVerifyInProgress = true;
    update();

    Map<String, String> requestBody = {
      "email": email,
    };

    try{
      await internetConnectivityCheck();
      NetworkResponse response = await NetworkCaller.postRegisterRequest(
        url: Urls.emailVerifyUrl,
        body: requestBody,
      );

      // log("verifyEmailRequest statusCode ==> ${response.statusCode}");
      // log("verifyEmailRequest body ==> ${response.body}");

      _isEmailVerifyInProgress = false;

      if (response.isSuccess) {
        var responseBody = response.body;
        _resetLink = responseBody['resent_link'];
        _otp = responseBody['otp'];

        update();
        return true;
      } else {
        _errorMessage = "Something went wrong";
        update();
        return false;
      }
    }catch(e){
      _isError = true;
      _isEmailVerifyInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
        _isError = false;
      }

      log('Error in email verification: $_errorMessage');
      _errorMessage = "Something went wrong";

      update();
      return false;
    }
  }


/*--------------------- ui -----------------------------*/

  bool  isEmailError = false;

  void changeErrorCondition({required bool emailErrorValue}) {
    isEmailError = emailErrorValue;
    update();
  }

}