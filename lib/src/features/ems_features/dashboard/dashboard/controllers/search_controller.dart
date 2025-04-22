import 'dart:developer';

import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/model/search_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class SearchDataController extends GetxController with InternetConnectivityCheckMixin {
  bool _isConnected = true;
  bool _isError = false;
  bool _isSearchInProgress = false;
  String _errorMessage = '';
  List<SearchModel> _searchList = [];

  bool get isConnected => _isConnected;
  bool get isError => _isError;
  bool get isSearchInProgress => _isSearchInProgress;
  String get errorMessage => _errorMessage;
  List<SearchModel> get searchList => _searchList;

  Future<bool> fetchSearchData({required String searchData}) async {
    _isSearchInProgress = true;
    _isConnected = true;
    update();
    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.searchDataUrl(searchData));

     // log("isSearchInProgress statusCode ==> ${response.statusCode}");
    //  log("isSearchInProgress body ==> ${response.body}");

      _isSearchInProgress = false;

      if (response.isSuccess) {
        _searchList = SearchModel.fromJsonList(response.body);
        _isError = false;
        update();
        return true;
      } else {
        _errorMessage = "Can't load data";
        _isError = true;
        update();
        return false;
      }
    } catch (e) {
      _isError = true;
      _isSearchInProgress = false;

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
        _isError = false;
      }

      log('Error in isSearchInProgress: $_errorMessage');

      update();
      return false;
    }
  }




  // *--------------------->ui<-------------------------*

  bool _isSearching = false;

  bool get isSearching => _isSearching;

  void changeSearchStatus(bool value){
    _isSearching = value;
    update();
  }







}
