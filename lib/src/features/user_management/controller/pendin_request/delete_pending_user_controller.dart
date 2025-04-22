import 'dart:developer';

import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class DeletePendingUserController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isDeleteUserInProgress = false;
  String _errorMessage = '';

  bool get isConnected => _isConnected;
  bool get isDeleteUserInProgress => _isDeleteUserInProgress;
  String get errorMessage => _errorMessage;

  Future<bool> deletePendingUserRequest({required int id}) async {

    _isDeleteUserInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.deleteRequest(url: Urls.deleteUserUrl(id));

      // log("deleteUserUrl statusCode ==> ${response.statusCode}");
      // log("deleteUserUrl body ==> ${response.body}");

      _isDeleteUserInProgress = false;
      update();

      if (response.isSuccess) {
        update();
        return true;

      } else {
        _errorMessage = "Failed to delete user.";
        update();
        return false;
      }
    } catch (e) {
      _isDeleteUserInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in delete user: $_errorMessage');
      _errorMessage = "Failed to delete user.";

      return false;
    }
  }

}