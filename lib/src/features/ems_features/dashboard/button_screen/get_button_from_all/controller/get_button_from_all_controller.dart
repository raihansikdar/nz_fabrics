
import 'dart:developer';

import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/get_button_from_all/model/get_button_from_all.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class GetButtonFromAllController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isGetButtonFromGetAll = false;
  String _errorMessage = '';
  List<GetButtonFromGetAllModel> _getButtonFromGetAllList = [];

  bool get isConnected => _isConnected;
  bool get isGetButtonFromGetAll => _isGetButtonFromGetAll;
  String get errorMessage => _errorMessage;
  List<GetButtonFromGetAllModel> get getButtonFromGetAllList => _getButtonFromGetAllList;

 // Set uniqueData = {};
  List<String> uniqueDataList = [];


  @override
  onInit(){

    ever(AuthUtilityController.accessTokenForApiCall, (String? token){
      if(token != null){
        fetchButtonFromAllData();
      }
    });
    super.onInit();
  }


  Future<bool> fetchButtonFromAllData() async {

    _isGetButtonFromGetAll = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getAllButtonUrl);

      log("fetchButtonFromAllData statusCode ==> ${response.statusCode}");
       log("fetchButtonFromAllData body ==> ${response.body}");

      _isGetButtonFromGetAll = false;
      update();

      if (response.isSuccess) {
        uniqueDataList.clear();
        final jsonData = (response.body as List<dynamic>);
        // _getButtonFromGetAllList = jsonData.where((data)=> data['category'] == 'Grid' || data['category'] == 'Diesel_Generator' || data['category'] == "Water")
        // .map((json)=> GetButtonFromGetAllModel.fromJson(json)).toList();

        _getButtonFromGetAllList = jsonData.map((json)=> GetButtonFromGetAllModel.fromJson(json)).toList();


        for(var name in _getButtonFromGetAllList){
         if(name.category == "Grid"){
           uniqueDataList.add('Analysis Pro');
         }else if(name.category  == "Water" || name.category  == "WTP" || name.category  == "Sub_Mersible"){
           if(!uniqueDataList.contains("Water")){
             uniqueDataList.add('Water');
           }

         }
         else{
           uniqueDataList.add(name.category ?? '');
         }

        }
        // for(var name in uniqueData){
        //   uniqueDataList.add(name);
        //  //log(name.toString());
        // }
        update();
        return true;

      } else {
        _errorMessage = "Failed to fetch fetchButtonFromAllData.";
        update();
        return false;
      }
    } catch (e) {
      _isGetButtonFromGetAll = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching fetchButtonFromAllData : $_errorMessage');
      _errorMessage = "Failed to fetch fetchButtonFromAllData.";

      return false;
    }
  }

}