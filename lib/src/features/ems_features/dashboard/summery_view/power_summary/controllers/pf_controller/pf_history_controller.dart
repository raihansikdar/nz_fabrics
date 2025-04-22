import 'dart:developer';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/pf_model/pf_history_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';

class PFHistoryController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isPFHistoryInProgress = false;
  String _errorMessage = '';
  bool _firstPFHistoryInProgress = true;
  List<PFHistoryModel> _pfHistoryList = [];

  // Cache to store history counts by node name
  Map<String, int> _historyCountCache = {};

  bool get isConnected => _isConnected;
  bool get isPFHistoryInProgress => _isPFHistoryInProgress;
  String get errorMessage => _errorMessage;
  List<PFHistoryModel> get pfHistoryList => _pfHistoryList;

  Map<String, List<PFHistoryModel>> groupedPFNotifications = {};

  // Method to get history count for a specific node
  int getHistoryCountForNode(String nodeName) {
    if (_historyCountCache.containsKey(nodeName)) {
      return _historyCountCache[nodeName] ?? 0;
    }

    // If not in cache, fetch it (this will update the cache)
    fetchPFHistoryCount(nodeName: nodeName);
    return 0; // Return 0 initially while fetching
  }

  // Method to fetch just the count without storing all history items
  Future<void> fetchPFHistoryCount({required String nodeName}) async {
    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getPFHistoryUrl(nodeName));

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
        int count = jsonData.length;

        // Update the cache
        _historyCountCache[nodeName] = count;
        update();
      }
    } catch (e) {
      log('Error in fetching PF History count: ${e.toString()}');
    }
  }

  Future<bool> fetchPFHistory({required String nodeName}) async {
    _pfHistoryList.clear();
      if(_firstPFHistoryInProgress){
    _isPFHistoryInProgress = true;
   // update();
  }

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getPFHistoryUrl(nodeName));

      _isPFHistoryInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
        _pfHistoryList = jsonData.map((json)=> PFHistoryModel.fromJson(json)).toList();

        // Update the cache with this count
        _historyCountCache[nodeName] = _pfHistoryList.length;

        groupNotificationsByDate();
        update();
        return true;
      } else {
        _errorMessage = "Failed to fetch PF History.";
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

      log('Error in fetching PF History: $_errorMessage');
      _errorMessage = "Failed to fetch PF History.";

      return false;
    } finally {
      _firstPFHistoryInProgress = false;
      update();
    }
  }

  void groupNotificationsByDate() {
    Map<String, List<PFHistoryModel>> groupedData = {};

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
        log("Error parsing date for notification: ${notification.timedate}, error: $e");
      }
    }

    groupedPFNotifications = groupedData;
    update();
  }

  // Preload history counts for a list of nodes
  Future<void> preloadHistoryCounts(List<String> nodeNames) async {
    for (var nodeName in nodeNames) {
      if (nodeName.isNotEmpty) {
        await fetchPFHistoryCount(nodeName: nodeName);
      }
    }
  }
}