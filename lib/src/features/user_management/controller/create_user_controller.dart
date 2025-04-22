import 'dart:developer';

import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class CreateUserController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isCreateUserInProgress = false;
  String _errorMessage = '';

  bool get isConnected => _isConnected;
  bool get isCreateUserInProgress => _isCreateUserInProgress;
  String get errorMessage => _errorMessage;



  Future<bool>registerByAdmin({required String name, required String email, required String phoneNumber, required String companyName, required String address}) async {

    _isCreateUserInProgress = true;
    update();


    Map<String,String> requestBody = {
      "first_name": name,
      "email": email,
      "phone_no": phoneNumber,
      "company_name": companyName,
      "address": address,
    };


    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(url: Urls.postRegisterByAdminUrl,body: requestBody);

     // log("postRegisterByAdminUrl statusCode ==> ${response.statusCode}");
     // log("postRegisterByAdminUrl body ==> ${response.body}");

      _isCreateUserInProgress = false;
      update();

      if (response.isSuccess) {

        update();
        return true;

      } else {
        _errorMessage = " Failed to create user!";
        update();
        return false;
      }
    } catch (e) {
      _isCreateUserInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in create user: $_errorMessage');
      _errorMessage = " Failed to create user!";

      return false;
    }
  }




  /*------------------------------- UI ---------------------------------*/
  bool  isEmailError = false;

  void changeErrorCondition({required bool emailErrorValue}) {
    isEmailError = emailErrorValue;
    update();
  }

  bool  isPhoneNumberError = false;

  void changePhoneNumberCondition({required bool phoneNumberErrorValue}) {
    isPhoneNumberError = phoneNumberErrorValue;
    update();
  }


}

