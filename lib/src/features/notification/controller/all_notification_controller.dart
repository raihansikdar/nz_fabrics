
import 'dart:developer';

import 'package:nz_fabrics/src/features/notification/model/all_notification_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllNotificationController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isNotificationInProgress = false;
  String _errorMessage = '';
  List<AllNotificationDataModel> _allNotificationList = [];
  List<AllNotificationDataModel> _unSeenNotification = [];
  Map<String, List<AllNotificationDataModel>> groupedNotifications = {};

  bool get isConnected => _isConnected;
  bool get isNotificationInProgress => _isNotificationInProgress;
  String get errorMessage => _errorMessage;
  List<AllNotificationDataModel> get allNotificationList => _allNotificationList;
  List<AllNotificationDataModel> get unSeenNotification => _unSeenNotification;


  Future<bool> fetchNotificationData() async {

    _isNotificationInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getNotificationUrl);

    //  log("getNotificationUrl statusCode ==> ${response.statusCode}");
    //  log("getNotificationUrl body ==> ${response.body}");

      _isNotificationInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
        _allNotificationList = jsonData.map((json)=> AllNotificationDataModel.fromJson(json)).toList();
        _unSeenNotification = _allNotificationList.where((notification) => notification.seen == false).toList();

        groupNotificationsByDate();

        update();
        return true;

      } else {
        _errorMessage = "Failed to fetch notification.";
        update();
        return false;
     }
    } catch (e) {
      _isNotificationInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching user notification data : $_errorMessage');
      _errorMessage = "Failed to fetch notification.";

      return false;
    }
  }

  void groupNotificationsByDate() {
    Map<String, List<AllNotificationDataModel>> groupedData = {};

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    for (var notification in _allNotificationList) {
      DateTime notificationDate = DateTime(
        notification.timedate!.year,
        notification.timedate!.month,
        notification.timedate!.day,
      );

      String key;

      if (notificationDate == today) {
        key = "Today";
      } else if (notificationDate == yesterday) {
        key = "Yesterday";
      } else {
        key = DateFormat('d/MMM/yyyy').format(notificationDate);
      }

      if (!groupedData.containsKey(key)) {
        groupedData[key] = [];
      }
      groupedData[key]!.add(notification);
    }

    // Assign grouped data to the controller property
    groupedNotifications = groupedData;
    update();
  }

}