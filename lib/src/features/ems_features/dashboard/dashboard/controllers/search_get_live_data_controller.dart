import 'dart:developer';

import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/model/search_live_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class SearchGetLiveDataController extends GetxController with InternetConnectivityCheckMixin{

  bool _isLoading  = false;
  bool _isConnected = true;
  String _errorMessage = '';
  SearchLiveDataModel _searchLiveDataModel  = SearchLiveDataModel();

  bool get isLoading  => _isLoading;
  bool get isConnected => _isConnected;
  String get errorMessage => _errorMessage;
  SearchLiveDataModel get searchLiveDataModel  => _searchLiveDataModel;

  Future<bool> fetchSearchLiveData({required String searchQueryName}) async {
    _isLoading = true;
    _isConnected = true;
    update();
    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getLiveDataUrl(searchQueryName));

      log("getLiveDataUrl statusCode ==> ${response.statusCode}");
      log("getLiveDataUrl body ==> ${response.body}");

      _isLoading = false;

      if (response.isSuccess) {
        _searchLiveDataModel = SearchLiveDataModel.fromJson(response.body);

        update();
        return true;
      } else {
        _errorMessage = "Can't load data";

        update();
        return false;
      }
    } catch (e) {

      _isLoading = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in isSearchInProgress: $_errorMessage');

      update();
      return false;
    }

  }

}