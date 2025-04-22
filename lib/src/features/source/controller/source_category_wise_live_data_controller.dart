import 'dart:developer';

import 'package:nz_fabrics/src/features/source/model/source_category_wise_live_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class SourceCategoryWiseLiveDataController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isSourceCategoryInProgress = false;
  String _errorMessage = '';
  SourceCategoryModel _sourceCategoryWiseLiveDataModel = SourceCategoryModel();

  bool get isConnected => _isConnected;
  bool get isSourceCategoryInProgress => _isSourceCategoryInProgress;
  String get errorMessage => _errorMessage;
  SourceCategoryModel get sourceCategoryWiseLiveDataModel => _sourceCategoryWiseLiveDataModel;


  Future<bool> fetchSourceCategoryWiseData() async {

    _isSourceCategoryInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getSourceCategoryWiseLiveDataDaUrl);

      log("getSourceCategoryWiseLiveDataDataUrl statusCode ==> ${response.statusCode}");
      log("getSourceCategoryWiseLiveDataDataUrl body ==> ${response.body}");

      _isSourceCategoryInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body);
        _sourceCategoryWiseLiveDataModel = SourceCategoryModel.fromJson(jsonData);

        update();
        return true;

      } else {
        _errorMessage = "Failed to fetch Source Category Wise Live Data .";
        update();
        return false;
      }
    } catch (e) {
      _isSourceCategoryInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching Source Category Wise Live Data : $_errorMessage');
      _errorMessage = "Failed to fetch Source Category Wise Live Data.";

      return false;
    }
  }

}