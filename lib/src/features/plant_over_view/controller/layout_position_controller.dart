
import 'dart:developer';

import 'package:nz_fabrics/src/features/plant_over_view/model/layout_node_position_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class LayoutPositionController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isLayoutListInProgress = false;
  String _errorMessage = '';
  List<LayoutNodePositionModel> _layoutPositionList = [];


  bool get isConnected => _isConnected;
  bool get isLayoutListInProgress => _isLayoutListInProgress;
  String get errorMessage => _errorMessage;
  List<LayoutNodePositionModel> get layoutPositionList => _layoutPositionList;


  Future<bool> fetchLayoutNodePositionData() async {
    _isLayoutListInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getLayoutNodePositionUrl);

     // log("getLayoutNodePositionUrl statusCode ==> ${response.statusCode}");
     // log("getLayoutNodePositionUrl body ==> ${response.body}");

      _isLayoutListInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
        _layoutPositionList = jsonData.map((json) => LayoutNodePositionModel.fromJson(json)).toList();



        update();
        return true;
      } else {
        _errorMessage = "Failed to fetch Layout Node Position Data.";
        update();
        return false;
      }
    } catch (e) {
      _isLayoutListInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching Layout Node Position Data : $_errorMessage');
      _errorMessage = "Failed to fetch Layout Node Position Data.";

      return false;
    }
  }









}
