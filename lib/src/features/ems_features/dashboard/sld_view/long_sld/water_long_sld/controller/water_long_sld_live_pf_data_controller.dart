import 'dart:developer';

import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/model/water_long_sld_live_pf_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';


class WaterLongSldLivePfDataController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isPFHistoryInProgress = false;
  String _errorMessage = '';
  bool _firstPFHistoryInProgress = true;
  WaterLongSLDLivePFDataModel _livePFDataModel = WaterLongSLDLivePFDataModel();

  bool get isConnected => _isConnected;
  bool get isPFHistoryInProgress => _isPFHistoryInProgress;
  String get errorMessage => _errorMessage;
  WaterLongSLDLivePFDataModel get livePFDataModel => _livePFDataModel;



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
        _livePFDataModel = WaterLongSLDLivePFDataModel.fromJson(jsonData);

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

      log('Error in fetching Live PF Data : $_errorMessage');
      _errorMessage = "Failed to fetch Live PF Data.";

      return false;
    }finally{
      _firstPFHistoryInProgress = false;
      update();
    }
  }

}
