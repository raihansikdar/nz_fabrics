import 'dart:developer';

import 'package:nz_fabrics/src/features/profile/model/user_profile_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isUserProfileInProgress = false;
  bool _hasError = true;
  String _errorMessage = '';
  UserProfileModel _userProfileList = UserProfileModel();

  bool get isConnected => _isConnected;
  bool get isUserProfileInProgress => _isUserProfileInProgress;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  UserProfileModel get userProfileList => _userProfileList;


  Future<bool> fetchUserProfileData() async {

    _isUserProfileInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getUserProfileUrl);

        log("getUserProfileUrl statusCode ==> ${response.statusCode}");
       // log("getUserProfileUrl body ==> ${response.body}");

      _isUserProfileInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body);
        _userProfileList = UserProfileModel.fromJson(jsonData);

        _hasError = false;
        update();
        return true;

      } else {
        _errorMessage = "Failed to fetch user profile.";
        _hasError = true;
        update();
        return false;
      }
    } catch (e) {
      _isUserProfileInProgress = false;
      _errorMessage = e.toString();
      _hasError = true;
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
        _hasError = false;
      }

      log('Error in fetching user profile data : $_errorMessage');
      _errorMessage = "Failed to fetch user profile.";

      return false;
    }
  }

}