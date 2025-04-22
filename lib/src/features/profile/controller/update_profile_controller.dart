import 'dart:developer';

import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class UpdateProfileController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isUpdateProfileInProgress = false;
  String _errorMessage = '';

  bool get isConnected => _isConnected;
  bool get isUpdateProfileInProgress => _isUpdateProfileInProgress;
  String get errorMessage => _errorMessage;



  Future<bool>putUpdateProfile({required String name, required String phoneNumber, required String companyName, required String address}) async {

    _isUpdateProfileInProgress = true;
    update();


    Map<String,String> requestBody = {
      "first_name": name,
      "phone_no": phoneNumber,
      "company_name": companyName,
      "address": address,
    };


    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.putRequest(url: Urls.putUpdateProfileUrl,body: requestBody);

      // log("putUpdateProfileUrl statusCode ==> ${response.statusCode}");
      // log("putUpdateProfileUrl body ==> ${response.body}");

      _isUpdateProfileInProgress = false;
      update();

      if (response.isSuccess) {

        update();
        return true;

      } else {
        _errorMessage = " Failed to update profile!";
        update();
        return false;
      }
    } catch (e) {
      _isUpdateProfileInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in update profile: $_errorMessage');
      _errorMessage = " Failed to update profile!";

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