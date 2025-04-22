
import 'dart:developer';

import 'package:nz_fabrics/src/features/plant_over_view/model/layout_model.dart';
import 'package:nz_fabrics/src/features/plant_over_view/model/layout_summary_details_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class PlantLayoutController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isLayoutListInProgress = false;
  String _errorMessage = '';
  List<LayoutImageModel> _layoutNameList = [];


  bool get isConnected => _isConnected;
  bool get isLayoutListInProgress => _isLayoutListInProgress;
  String get errorMessage => _errorMessage;
  List<LayoutImageModel> get layoutNameList => _layoutNameList;

  bool _isLayoutSummaryListInProgress = false;
  String _layoutSummaryErrorMessage = '';
  List<Map<String,List<LayoutSummaryDetailsModel>>> _layoutSummaryDetailsList = [];

  bool get isLayoutSummaryListInProgress => _isLayoutSummaryListInProgress;
  String get layoutSummaryErrorMessage => _layoutSummaryErrorMessage;
  List<Map<String,List<LayoutSummaryDetailsModel>>> get layoutSummaryDetailsList => _layoutSummaryDetailsList;


  Future<bool> fetchLayoutData() async {
    _isLayoutListInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getLayoutImageUrl);

      //log("getLayoutImageUrl statusCode ==> ${response.statusCode}");
      //log("getLayoutImageUrl body ==> ${response.body}");

      _isLayoutListInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
        _layoutNameList = jsonData.map((json) => LayoutImageModel.fromJson(json)).toList();

        _layoutSummaryDetailsList.clear();

        for (var layout in _layoutNameList) {
          final List<LayoutSummaryDetailsModel> liveDataList = await fetchLayoutDetailsData(layout.name ?? '');
          _layoutSummaryDetailsList.add({layout.name ?? '': liveDataList});
        }

        update();
        return true;
      } else {
        _errorMessage = "Failed to fetch Layout Data.";
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

      log('Error in fetching Layout Data: $_errorMessage');
      _errorMessage = "Failed to fetch Layout Data.";

      return false;
    }
  }
  Future<List<LayoutSummaryDetailsModel>> fetchLayoutDetailsData(String layoutName) async {
    _isLayoutSummaryListInProgress = true;

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.getLayoutSummaryDetailsUrl(layoutName),
      );

      // log("getLayoutSummaryDetailsUrl ==> ${Urls.getLayoutSummaryDetailsUrl(layoutName)}");
      // log("getLayoutSummaryDetailsUrl statusCode ==> ${response.statusCode}");
      // log("getLayoutSummaryDetailsUrl body ==> ${response.body}");

      _isLayoutSummaryListInProgress = false;

      if (response.isSuccess) {
        final jsonData = response.body;

        // Ensure the structure matches the expected format
        if (jsonData is Map<String, dynamic> && jsonData['result'] is List) {
          // Parse the result field into a list of LayoutSummaryDetailsModel
          return (jsonData['result'] as List)
              .map((item) => LayoutSummaryDetailsModel.fromJson(item))
              .toList();
        } else {
          throw Exception("Unexpected API response format: Missing 'result' key or incorrect structure.");
        }
      } else {
        _layoutSummaryErrorMessage = "Failed to fetch live data for $layoutName.";
        return [];
      }
    } catch (e) {
      _isLayoutSummaryListInProgress = false;
      _layoutSummaryErrorMessage = e.toString();

      if (e is AppException) {
        _layoutSummaryErrorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching live data for $layoutName: $_layoutSummaryErrorMessage');
      return [];
 }
    }



}
