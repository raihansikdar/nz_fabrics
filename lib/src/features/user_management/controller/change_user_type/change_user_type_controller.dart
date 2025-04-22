import 'dart:developer';
import 'package:nz_fabrics/src/features/user_management/model/approved_user_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

import 'package:get/get.dart';

class ChangeUserTypeController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isApprovedUserInProgress = false;
  bool _isApprovedUserInProgressWithoutLoading = false;
  String _errorMessage = '';
  List<ApprovedUserModel> _approvedUserList = <ApprovedUserModel>[];
  List<ApprovedUserModel> _onlySuperAdminList = <ApprovedUserModel>[];
  List<ApprovedUserModel> _onlyUserList = <ApprovedUserModel>[];
  List<ApprovedUserModel> _onlyAdminList = <ApprovedUserModel>[];


  bool get isConnected => _isConnected;
  bool get isApprovedUserInProgress => _isApprovedUserInProgress;
  bool get isApprovedUserInProgressWithoutLoading => _isApprovedUserInProgressWithoutLoading;
  String get errorMessage => _errorMessage;
  List<ApprovedUserModel> get approvedUserList => _approvedUserList;
  List<ApprovedUserModel> get onlySuperAdminList => _onlySuperAdminList;
  List<ApprovedUserModel> get onlyUserList => _onlyUserList;
  List<ApprovedUserModel> get onlyAdminList => _onlyAdminList;



  Future<bool> fetchApprovedUserData() async {

    _isApprovedUserInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getApprovedUserUrl);

      log("getApprovedUser statusCode ==> ${response.statusCode}");
       log("getApprovedUser body ==> ${response.body}");

      _isApprovedUserInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
        _approvedUserList = jsonData.map((json) => ApprovedUserModel.fromJson(json as Map<String, dynamic>)).toList();

        _onlySuperAdminList = jsonData
            .where((json)=>(json['is_superuser'] == true && json['is_staff'] == true))
            .map((json) => ApprovedUserModel.fromJson(json as Map<String, dynamic>)).toList();

        _onlyUserList = jsonData
            .where((json)=>(json['is_superuser'] == false && json['is_staff'] == false))
            .map((json) => ApprovedUserModel.fromJson(json as Map<String, dynamic>)).toList();

        _onlyAdminList = jsonData
            .where((json)=>(json['is_superuser'] == false && json['is_staff'] == true))
            .map((json) => ApprovedUserModel.fromJson(json as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch approved user.";
        update();
        return false;
      }
    } catch (e) {
      _isApprovedUserInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching approved user : $_errorMessage');
      _errorMessage = " Failed to fetch approved user.";

      return false;
    }
  }

  Future<bool> fetchApprovedUserDataWithOutLoading() async {

    _isApprovedUserInProgressWithoutLoading = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getApprovedUserUrl);

      // log("getApprovedUser statusCode ==> ${response.statusCode}");
      // log("getApprovedUser body ==> ${response.body}");

      _isApprovedUserInProgressWithoutLoading = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
        _approvedUserList = jsonData.map((json) => ApprovedUserModel.fromJson(json as Map<String, dynamic>)).toList();

        _onlySuperAdminList = jsonData
            .where((json)=>(json['is_superuser'] == true && json['is_staff'] == true))
            .map((json) => ApprovedUserModel.fromJson(json as Map<String, dynamic>)).toList();

        _onlyUserList = jsonData
            .where((json)=>(json['is_superuser'] == false && json['is_staff'] == false))
            .map((json) => ApprovedUserModel.fromJson(json as Map<String, dynamic>)).toList();

        _onlyAdminList = jsonData
            .where((json)=>(json['is_superuser'] == false && json['is_staff'] == true))
            .map((json) => ApprovedUserModel.fromJson(json as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch approved user.";
        update();
        return false;
      }
    } catch (e) {
      _isApprovedUserInProgressWithoutLoading = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching approved user : $_errorMessage');
      _errorMessage = " Failed to fetch approved user.";

      return false;
    }
  }






  /*-------------------------- UI ---------------------------*/
  int selectedButton = 1;

  void updateSelectedButton({required int value}) {
    selectedButton = value;
    update();
  }

  bool myAnimation = false;

  void startAnimation() {
    myAnimation = true;
    update();
  }

}

