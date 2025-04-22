import 'dart:developer';

import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateModuleCleaningController extends GetxController with InternetConnectivityCheckMixin{
  bool _isConnected = true;
  bool _isModuleInProgress = false;
  String _errorMessage = '';

  bool get isConnected => _isConnected;
  bool get isModuleInProgress => _isModuleInProgress;
  String get errorMessage => _errorMessage;

  Future<bool>createModuleCleaning({required String date, required String shedName}) async{

    _isModuleInProgress = true;
    update();
    final formattedFromDate = DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(date));

    Map<String,String> requestBody = {
      "date": formattedFromDate,
      "shed_name": shedName,
    };
   log(formattedFromDate);
   log(shedName);

    try{
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(url: Urls.createModuleCleaningUrl, body: requestBody);

      log("createModuleCleaningUrl statusCode ==> ${response.statusCode}");
      log("createModuleCleaningUrl body ==> ${response.body}");

      _isModuleInProgress = false;

      if(response.isSuccess){
        update();
        return true;
      }else{
        _errorMessage = "Failed to crease schedule";
        update();
        return false;
      }
    }catch(e){
      _isModuleInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      _errorMessage = "Failed to crease schedule";
      log('Error in Module Cleaning: $_errorMessage');

      update();
      return false;
    }

  }

  final TextEditingController _selectedDateTEController = TextEditingController();
  final RxBool _clearDate = false.obs;

  RxBool get clearDate => _clearDate;
  TextEditingController get selectedDateTEController => _selectedDateTEController;

  void selectDatePicker(BuildContext context) async {
    DateTime? picker = await showDatePicker(
      context: context,
      initialDate: _selectedDateTEController.text.isNotEmpty
          ? DateFormat("dd-MM-yyyy").parse(_selectedDateTEController.text)
          : DateTime.now(),

      firstDate: DateTime(2024),
      lastDate: DateTime(2130),
    );

    if (picker != null) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(picker);
      _selectedDateTEController.text = formattedDate;
      _clearDate.value = true;
      update();

    }
  }
}