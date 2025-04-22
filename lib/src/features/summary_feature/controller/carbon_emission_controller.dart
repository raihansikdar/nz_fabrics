import 'dart:developer';

import 'package:nz_fabrics/src/features/summary_feature/model/carbon_emission_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class CarbonEmissionController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isCarbonEmissionInProgress = false;
  String _errorMessage = '';

  List<CarbonEmissionModel> _carbonEmissionList = <CarbonEmissionModel>[];

  bool get isConnected => _isConnected;
  bool get isCarbonEmissionInProgress => _isCarbonEmissionInProgress;
  String get errorMessage => _errorMessage;
  List<CarbonEmissionModel> get carbonEmissionList => _carbonEmissionList;

  Future<bool>fetchCarbonEmissionData() async{

    _isCarbonEmissionInProgress = true;
    update();


    try{
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getCarbonEmissionUrl);

    //  log("carbonEmissionUrl statusCode ==> ${response.statusCode}");
      log("carbonEmissionUrl body ==> ${response.body}");

      _isCarbonEmissionInProgress = false;

      if(response.isSuccess){
        // var jsonData = response.body as Map<String, dynamic>;
        // _carbonEmissionList = [CarbonEmissionModel.fromJson(jsonData)];
        // update();
        // return true;

        var jsonData = response.body as Map<String, dynamic>;
        _carbonEmissionList = [CarbonEmissionModel.fromJson(jsonData)];
        update();
        return true;


      }else{
        _errorMessage = "Failed to fetch schedule chart";
        update();
        return false;
      }
    }catch(e){
      _isCarbonEmissionInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in carbon emission: $_errorMessage');
      _errorMessage = "Failed to fetch carbon emission";

      update();
      return false;
    }

  }

}