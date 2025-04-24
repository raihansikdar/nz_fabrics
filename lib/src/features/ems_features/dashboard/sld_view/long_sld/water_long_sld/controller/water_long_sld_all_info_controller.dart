import 'dart:developer';

import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/model/loop_and_bus_cupler_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/power_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';

class WaterLongSLDAllInfoController extends GetxController with InternetConnectivityCheckMixin {

  List<PowerModel> powerList = [];
  LoopAndBusCouplerModel loopAndBusCouplerModel = LoopAndBusCouplerModel();
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


     // log('getAllInfoUrl Response Status: ${response.statusCode}');
      // log('getAllInfoUrl Body: ${response.body}');


      if (response.statusCode == 200) {
        List<dynamic> powerListData = response.body;
        powerList = powerListData.map((item) => PowerModel.fromJson(item)).toList();

        powerList = powerList.where((power) {

          return ((power.sourceType == 'BusCoupler' || power.sourceType == 'Loop'));

        }).toList();

        for( var power in powerList){
         // log(power.sourceType.toString());
          fetchMeterData(nodeName: power.nodeName ?? '', sourceType: power.sourceType ?? '');
        }

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

  Future<void> fetchMeterData({required String nodeName, required String sourceType}) async {
    try {
      isConnected = true;
      isLoading = true;
      update();

      await internetConnectivityCheck();
      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.busCouplerConnectedMeterUrl(nodeName, sourceType));


      // log('Response Status: ${response.statusCode}');
       //log('fetch  Source Power Data Body: ${response.body}');


      if (response.statusCode == 200) {
        loopAndBusCouplerModel =  LoopAndBusCouplerModel.fromJson(response.body);


        // log(loopAndBusCouplerModel.node!);
        // log(loopAndBusCouplerModel.powerMeter.toString());
        // log(loopAndBusCouplerModel.sourceType!);

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