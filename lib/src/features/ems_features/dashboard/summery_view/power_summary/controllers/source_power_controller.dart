import 'dart:async';
import 'dart:developer';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/power_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:get/get.dart';

class SourcePowerController extends GetxController with InternetConnectivityCheckMixin {

  List<PowerModel> powerList = [];
  bool isLoading = false;
  bool hasError = false;
  bool isConnected = true;

  Future<void> fetchSourcePowerData() async {
    try {
      isConnected = true;
      isLoading = true;
      update();

      await internetConnectivityCheck();
      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getAllInfoUrl);


      // log('Response Status: ${response.statusCode}');
      // log('fetch  Source Power Data Body: ${response.body}');


      if (response.statusCode == 200) {
        List<dynamic> powerListData = response.body;
        powerList = powerListData.map((item) => PowerModel.fromJson(item)).toList();

        powerList = powerList.where((power) {

          return ((power.sourceCategory == 'Grid' || power.sourceCategory == 'Solar' || power.sourceCategory == 'Diesel_Generator' || power.sourceCategory == 'Gas_Generator') && power.sourceType == 'Source');

        }).toList();

        isLoading = false;
        hasError = false;
      } else {
        log('Error fetching data: ${response.statusCode}, ${response.body}');
        hasError = true;
      }
    } catch (e) {
      log("Error fetching data: $e");
      hasError = true;
    } finally {
      isLoading = false;
      update();
    }

  }
}

