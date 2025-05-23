
import 'dart:developer';

import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/model/water_each_load_category_wise_live_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class WaterEachLoadCategoryWiseLiveDataController extends GetxController with InternetConnectivityCheckMixin {
  bool _isLoading = false;
  bool _isConnected = true;
  bool _hasError = true;
  String _errorMessage = '';
  List<WaterEachLoadCategoryWiseLiveDataModel> _waterEachLoadCategoryDataList = [];

  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<WaterEachLoadCategoryWiseLiveDataModel> get waterEachLoadCategoryDataList => _waterEachLoadCategoryDataList;

  Future<bool> fetchEachCategoryLiveData({required String categoryName}) async {

    _isLoading = true;
    _isConnected = true;

    _errorMessage = '';
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getWaterLoadEachCategoryLiveDataUrl(categoryName));

      //log("${Urls.getWaterLoadEachCategoryLiveDataUrl(categoryName)}");
      log("getWaterLoadEachCategoryLiveDataUrl: ${response.statusCode}");
      log("getWaterLoadEachCategoryLiveDataUrl: ${response.body}");

      if(response.isSuccess){
        _waterEachLoadCategoryDataList = ((response.body )['data'] as List<dynamic>).map((json)=> WaterEachLoadCategoryWiseLiveDataModel.fromJson(json)).toList();

        _hasError = false;
        update();
        return true;
      }else{
        _errorMessage = "Can't fetch water each load category live data";
        update();
        _hasError = true;
        return false;
      }

    } catch (e) {
      if (e is AppException) {
        _isConnected = false;
        _errorMessage = e.error.toString();
        _hasError = false;
      } else {
        _errorMessage = e.toString();
        log('Error water each category load wise live data: $_errorMessage');
        _hasError = true;
      }
      return false;

    } finally {
      _isLoading = false;
      update();

    }
  }
}