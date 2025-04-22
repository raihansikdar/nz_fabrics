import 'dart:developer';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/power_and_energy/monthly_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class MonthlyDataController extends GetxController with InternetConnectivityCheckMixin {
  bool isConnected = true;
  bool hasError = false;
  bool isLoading = false;
  String errorMessage = '';
  List<MonthlyDataModel> monthlyDataList = <MonthlyDataModel>[];


  double? minEnergy;
  double? maxEnergy;

  Future<bool> fetchMonthlyData({required String elementName}) async {
    isLoading = true;
    isConnected = true;
    update();

    try {
      await internetConnectivityCheck();
      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.monthlyDataUrl(elementName));

      isLoading = false;

      if (response.isSuccess) {
        List<dynamic> dataList = response.body;

        DateTime now = DateTime.now();
        DateTime startOfMonth = DateTime(now.year, now.month, 1);
        DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);

        monthlyDataList = dataList.where((data) {
          String? dateString = data['date'];
          if (dateString == null) return false;

          DateTime dataDate = DateTime.parse(dateString);
          return dataDate.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
              dataDate.isBefore(endOfMonth.add(const Duration(days: 1)));
        })
            .map((data) => MonthlyDataModel.fromJson(data as Map<String, dynamic>))
            .toList();

        // Extract energies and calculate min and max
        List<double> energies = monthlyDataList
            .where((data) => data.energy != null)
            .map((data) => data.energy as double)
            .toList();

        if (energies.isNotEmpty) {
          minEnergy = energies.reduce(min);
          maxEnergy = energies.reduce(max);
        }



        update();
        return true;
      } else {
        errorMessage = "Can't load data";
        hasError = true;
        update();
        return false;
      }
    } catch (e) {
      hasError = true;
      isLoading = false;

      errorMessage = e.toString();
      if (e is AppException) {
        errorMessage = e.error.toString();
        isConnected = false;
        hasError = false;
      }

      debugPrint('Error in fetching monthly data: $errorMessage');

      update();
      return false;
    }
  }



}