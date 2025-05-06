import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/electricity/views/screens/machine_screen/model/acknowledge_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class AcknowledgeDataController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isAcknowledgeHistoryInProgress = false;
  bool _isFirstTimeAcknowledgeHistory = true;
  String _errorMessage = '';
  List <AcknowledgedDataModel> _pfHistoryList = [];

  bool get isConnected => _isConnected;
  bool get isAcknowledgeHistoryInProgress => _isAcknowledgeHistoryInProgress;
  String get errorMessage => _errorMessage;
  List <AcknowledgedDataModel> get pfHistoryList => _pfHistoryList;

  Map<String, List<AcknowledgedDataModel>> groupedPFNotifications = {};

  Future<bool> fetchAcknowledgeHistory({required String nodeName}) async {


    if(_isFirstTimeAcknowledgeHistory){
      _isAcknowledgeHistoryInProgress = true;
      update();
    }


    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getAcKnowledgeHistoryUrl(nodeName));

     log("getAcKnowledgeHistoryUrl statusCode ==> ${response.statusCode}");
      log("getAcKnowledgeHistoryUrl body ==> ${response.body}");

      _isAcknowledgeHistoryInProgress = false;


      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
        _pfHistoryList = jsonData.map((json)=> AcknowledgedDataModel.fromJson(json)).toList();
        groupNotificationsByDate();

        update();
        return true;

      } else {
        _errorMessage = "Failed to fetch acknowledge History.";
        update();
        return false;
      }
    } catch (e) {
      _isAcknowledgeHistoryInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching PF History : $_errorMessage');
      _errorMessage = "Failed to fetch acknowledge History.";

      return false;
    }finally{
      _isFirstTimeAcknowledgeHistory = false;
      update();
    }
  }

  void groupNotificationsByDate() {
    Map<String, List<AcknowledgedDataModel>> groupedData = {};

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    for (var notification in _pfHistoryList) {
      try {
        DateTime notificationDate = DateTime.parse(notification.timedate!); // Parse the string to DateTime

        DateTime dateOnly = DateTime(
          notificationDate.year,
          notificationDate.month,
          notificationDate.day,
        );

        String key;

        if (dateOnly == today) {
          key = "Today";
        } else if (dateOnly == yesterday) {
          key = "Yesterday";
        } else {
          key = DateFormat('d MMM yyyy').format(dateOnly);
        }

        if (!groupedData.containsKey(key)) {
          groupedData[key] = [];
        }
        groupedData[key]!.add(notification);
      } catch (e) {
        log("Error parsing date for acknowledge History notification: ${notification.timedate}, error: $e");
      }
    }

    groupedPFNotifications = groupedData;
    update();
  }


}

