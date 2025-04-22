import 'dart:developer';

import 'package:nz_fabrics/src/features/user_management/model/pending_user_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class PendingUserController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isPendingUserInProgress = false;
  String _errorMessage = '';
  List<PendingUserModel> _pendingUserList = <PendingUserModel>[];

  bool get isConnected => _isConnected;
  bool get isPendingUserInProgress => _isPendingUserInProgress;
  String get errorMessage => _errorMessage;
  List<PendingUserModel> get pendingUserList => _pendingUserList;


  Future<bool> fetchPendingUserData() async {

    _isPendingUserInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getPendingUserUrl);

     // log("getPendingUserUrl statusCode ==> ${response.statusCode}");
    //  log("getPendingUserUrl body ==> ${response.body}");

      _isPendingUserInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
        _pendingUserList = jsonData.map((json) => PendingUserModel.fromJson(json as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch pending user.";
        update();
        return false;
      }
    } catch (e) {
      _isPendingUserInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching  pending user : $_errorMessage');
      _errorMessage = " Failed to fetch pending user.";

      return false;
    }
  }


  int selectedButton = 1;
  void updateSelectedButton({required int value}) {
    selectedButton = value;
    log("selected button $selectedButton");
    update();
  }

  bool pendingCardAnimation = false;

  void startPendingAnimation() {
    pendingCardAnimation = true;
    update();
  }

}