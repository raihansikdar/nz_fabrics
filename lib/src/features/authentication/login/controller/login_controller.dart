
import 'dart:developer';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/shared_preferences/save_user_info_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class LoginController extends GetxController with InternetConnectivityCheckMixin {
  bool _isConnected = true;
  bool _isLoginInProgress = false;
  String _errorMessage = '';
  String _userEmail = '';

  bool get isConnected => _isConnected;
  bool get isLoginInProgress => _isLoginInProgress;
  String get errorMessage => _errorMessage;
  String get userEmail => _userEmail;

  Future<bool> login({required String email, required String password}) async {
    _isLoginInProgress = true;
    _userEmail = email;
    update();

    Map<String, String> requestBody = {
      "email": email,
      "password": password,
    };

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.loginRegiPostRequest(url: Urls.loginUrl, body: requestBody);

      log("---------loginPostRequest statusCode ==> ${response.statusCode}");
      log("-------------loginPostRequest body ==> ${response.body}");

      _isLoginInProgress = false;

      if (response.isSuccess) {
        var responseBody = response.body;
        AuthUtilityController.setAccessToken(token: "Bearer ${responseBody['access_token']}");
        AuthUtilityController.setRefreshToken(refreshToken: responseBody['refresh_token']);
        AuthUtilityController.setUserRole(userRole: responseBody['role']);

        if (saveUser) {
          SaveUserInfoController.setUserEmail(email: email);
        } else {
          SaveUserInfoController.clearUserEmail();
        }

        log("==========Token======= Bearer ${responseBody['access_token']}");
        log("==========refresh token======= ${responseBody['refresh_token']}");

        update();
        return true;
      } else {
        _errorMessage = "Login failed";
        update();
        return false;
      }
    } catch (e) {
      _isLoginInProgress = false;
      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      _errorMessage = "Login failed";
      log('Error in fetchProjectData: $_errorMessage');

      update();
      return false;
    }
  }

  bool showPassword = false;

  void showPasswordMethod() {
    showPassword = !showPassword;
    update();
  }


  bool saveUser = true;

  void toggleSaveUser({required bool value}) {
    saveUser = value;
    update();
  }
}