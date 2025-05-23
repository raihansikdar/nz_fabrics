import 'dart:developer';

import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/steam_long_sld/model/steam_long_live_pf_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';


class SteamLongSldLivePfDataController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isPFHistoryInProgress = false;
  String _errorMessage = '';
  bool _firstPFHistoryInProgress = true;
  SteamLongLivePFDataModel _livePFDataModel = SteamLongLivePFDataModel();

  bool get isConnected => _isConnected;
  bool get isPFHistoryInProgress => _isPFHistoryInProgress;
  String get errorMessage => _errorMessage;
  SteamLongLivePFDataModel get livePFDataModel => _livePFDataModel;



  Future<bool> fetchLivePFData({required String nodeName}) async {

    if(_firstPFHistoryInProgress){
      _isPFHistoryInProgress = true;
      update();
    }


    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getLivePFDataUrl(nodeName));

     //  log("getLivePFDataUrl statusCode ==> ${response.statusCode}");
     //  log("getLivePFDataUrl body ==> ${response.body}");

      _isPFHistoryInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body);
        _livePFDataModel = SteamLongLivePFDataModel.fromJson(jsonData);

        update();
        return true;

      } else {
        _errorMessage = "Failed to fetch Live PF Data.";
        update();
        return false;
      }
    } catch (e) {
      _isPFHistoryInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching steam Live PF Data : $_errorMessage');
      _errorMessage = "Failed to steam fetch Live PF Data.";

      return false;
    }finally{
      _firstPFHistoryInProgress = false;
      update();
    }
  }

}
