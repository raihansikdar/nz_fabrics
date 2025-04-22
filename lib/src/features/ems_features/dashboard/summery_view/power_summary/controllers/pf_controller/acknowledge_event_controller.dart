import 'dart:developer';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/pf_model/acknowledge_event_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class AcknowledgeEventController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isAcknowledgeInProgress = false;
  String _errorMessage = '';
  AcknowledgeEventModel _acknowledgeEventModel = AcknowledgeEventModel();

  bool get isConnected => _isConnected;
  bool get isAcknowledgeInProgress => _isAcknowledgeInProgress;
  String get errorMessage => _errorMessage;
  AcknowledgeEventModel get acknowledgeEventModel => _acknowledgeEventModel;

  bool isEventSuccess = false;


  Future<bool> updateAcknowledgeEvent({required int id}) async {

    _isAcknowledgeInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.putRequestWithoutBody(url: Urls.putAcknowledgeEventUrl(id));

      //log("putAcknowledgeEventUrl statusCode ==> ${response.statusCode}");
    //  log("putAcknowledgeEventUrl body ==> ${response.body['message']}");

      _isAcknowledgeInProgress = false;
      update();

      if (response.isSuccess) {

        _acknowledgeEventModel = AcknowledgeEventModel.fromJson(response.body);

        if(_acknowledgeEventModel.message == "1 record(s) updated."){
           isEventSuccess = true;
        }else{
           isEventSuccess = false;
        }

        update();
        return true;

      } else {
        _errorMessage = "Failed to update Acknowledge";
        update();
        return false;
      }
    } catch (e) {
      _isAcknowledgeInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching PF History : $_errorMessage');
      _errorMessage = "Failed to update Acknowledge.";

      return false;
    }
  }




}

