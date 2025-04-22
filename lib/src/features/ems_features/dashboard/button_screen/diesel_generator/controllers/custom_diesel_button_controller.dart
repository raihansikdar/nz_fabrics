import 'dart:developer';

import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/model/custom_diesel_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomDieselButtonController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isCustomDieselButtonInProgress = false;
  String _errorMessage = '';
  List<CustomDieselDataModel> _customDieselDataList = <CustomDieselDataModel>[];

  bool get isConnected => _isConnected;
  bool get isDayProgress => _isCustomDieselButtonInProgress;
  String get errorMessage => _errorMessage;
  List<CustomDieselDataModel> get customDieselDataList => _customDieselDataList;

  @override
  void onInit() {
    super.onInit();
    String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    _fromMonthTEController.text = todayDate;
    _toMonthTEController.text = todayDate;
  }

  Future<bool> fetchCustomDieselData({required String fromDate, required String toDate}) async {

    _isCustomDieselButtonInProgress = true;
    update();

    final formattedFromDate = DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(fromDate));
    final parsedToDate = DateFormat("dd-MM-yyyy").parse(toDate);
    final adjustedToDate = parsedToDate.add(const Duration(hours: 23, minutes: 59, seconds: 59));
    final formattedToDate = DateFormat("yyyy-MM-dd").format(adjustedToDate);

    Map<String, String> requestBody = {
      "start": formattedFromDate,
      "end": formattedToDate,
    };

     log("Request Custom Body Date: $requestBody");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.postFilterDieselUrl,
        body: requestBody,
      );

      log("postFilterDieselUrl statusCode ==> ${Urls.postFilterDieselUrl}");

      log("postFilterDieselUrl statusCode ==> ${response.statusCode}");
      log("postFilterDieselUrl body ==> ${response.body}");

      _isCustomDieselButtonInProgress = false;
      update();

      if (response.isSuccess) {

        final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
        _customDieselDataList = jsonData.map((json) => CustomDieselDataModel.fromJson(json as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch custom Diesel data";
        update();
        return false;
      }
    } catch (e) {
      _isCustomDieselButtonInProgress = false;
      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching day data: $_errorMessage');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
  }



  final TextEditingController _fromMonthTEController = TextEditingController();
  final TextEditingController _toMonthTEController = TextEditingController();
  final RxBool _clearDate = false.obs;

  RxBool get clearDate => _clearDate;
  TextEditingController get fromDateTEController => _fromMonthTEController;
  TextEditingController get toDateTEController => _toMonthTEController;

  void formDatePicker(BuildContext context) async {
    DateTime? picker = await showDatePicker(
      context: context,
      initialDate:_fromMonthTEController.text.isNotEmpty
          ? DateFormat("dd-MM-yyyy").parse(_fromMonthTEController.text)
          : DateTime.now(),

      firstDate: DateTime(2024),
      lastDate: DateTime(2130),
    );

    if (picker != null) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(picker);
      _fromMonthTEController.text = formattedDate;
      _clearDate.value = true;
      update();
      validateDates(context);
    }
  }

  void toDatePicker(BuildContext context) async {
    DateTime? picker = await showDatePicker(
      context: context,
      initialDate: _toMonthTEController.text.isNotEmpty
          ? DateFormat("dd-MM-yyyy").parse(_toMonthTEController.text)
          : DateTime.now(),

      firstDate: DateTime(2024),
      lastDate: DateTime(2130),
    );

    if (picker != null) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(picker);
      _toMonthTEController.text = formattedDate;
      _clearDate.value = true;
      update();
      validateDates(context);
    }
  }

  void validateDates(BuildContext context) {
    final fromDate = DateFormat("dd-MM-yyyy").parse(_fromMonthTEController.text);
    final toDate = DateFormat("dd-MM-yyyy").parse(_toMonthTEController.text);

    if (fromDate.isAfter(toDate)) {
      AppToast.showWrongToast("Invalid Date Range");
    }
  }
}