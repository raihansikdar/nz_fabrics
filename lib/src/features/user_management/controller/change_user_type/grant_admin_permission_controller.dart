import 'dart:developer';

import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';


class GrantAdminUserController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isGrantAdminPermissionInProgress = false;
  String _errorMessage = '';

  bool get isConnected => _isConnected;
  bool get isGrantAdminPermissionInProgress => _isGrantAdminPermissionInProgress;
  String get errorMessage => _errorMessage;

  Future<bool> grantAdminPermissionToChangeUser({required int id}) async {

    _isGrantAdminPermissionInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.putRequestWithoutBody(url: Urls.putGrantSuperuserUrl(id));

      // log("putGrantSuperuserUrl statusCode ==> ${response.statusCode}");
      // log("putGrantSuperuserUrl body ==> ${response.body}");

      _isGrantAdminPermissionInProgress = false;
      update();

      if (response.isSuccess) {
        update();
        return true;

      } else {
        _errorMessage = "Failed to change role.";
        update();
        return false;
      }
    } catch (e) {
      _isGrantAdminPermissionInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in approve user: $_errorMessage');
      _errorMessage = "Failed to change role.";

      return false;
    }
  }

}