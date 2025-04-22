import 'dart:developer';

import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class AdminApprovalPendingRequest extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isAdminApprovalPendingRequestInProgress = false;
  String _errorMessage = '';

  bool get isConnected => _isConnected;
  bool get isAdminApprovalPendingRequestInProgress => _isAdminApprovalPendingRequestInProgress;
  String get errorMessage => _errorMessage;

  Future<bool> adminApprovalPendingUserRequest({required int id}) async {

    _isAdminApprovalPendingRequestInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.putRequestWithoutBody(url: Urls.putAdminApprovalUrl(id));

      // log("adminApprovalUrl statusCode ==> ${response.statusCode}");
      // log("adminApprovalUrl body ==> ${response.body}");

      _isAdminApprovalPendingRequestInProgress = false;
      update();

      if (response.isSuccess) {
        update();
        return true;

      } else {
        _errorMessage = "Failed to approve user.";
        update();
        return false;
      }
    } catch (e) {
      _isAdminApprovalPendingRequestInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in approve user: $_errorMessage');
      _errorMessage = "Failed to approve user.";

      return false;
    }
  }

}