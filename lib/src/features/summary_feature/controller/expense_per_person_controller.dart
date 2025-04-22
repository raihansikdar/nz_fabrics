import 'dart:developer';

import 'package:nz_fabrics/src/features/summary_feature/model/extense_per_person_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class ExpensePerPersonController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isExpensePerPersonInProgress = false;
  String _errorMessage = '';

  List<ExpensePerPersonModel> _expensePerPersonList = <ExpensePerPersonModel>[];

  bool get isConnected => _isConnected;
  bool get isExpensePerPersonInProgress => _isExpensePerPersonInProgress;
  String get errorMessage => _errorMessage;
  List<ExpensePerPersonModel> get expensePerPersonList => _expensePerPersonList;

  Future<bool>fetchExpensePerPersonData() async{

    _isExpensePerPersonInProgress = true;
    update();


    try{
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getExpensePerPersonUrl);

     // log("getExpensePerPersonUrl statusCode ==> ${response.statusCode}");
      log("getExpensePerPersonUrl body ==> ${response.body}");

      _isExpensePerPersonInProgress = false;

      if(response.isSuccess){

        var jsonData = response.body as Map<String, dynamic>;
        _expensePerPersonList = [ExpensePerPersonModel.fromJson(jsonData)];
        update();
        return true;


      }else{
        _errorMessage = "Failed to fetch Expense Per Person";
        update();
        return false;
      }
    }catch(e){
      _isExpensePerPersonInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in expense per person: $_errorMessage');
      _errorMessage = "Failed to fetch Expense Per Person";

      update();
      return false;
    }

  }

}