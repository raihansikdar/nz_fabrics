import 'dart:developer';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/plot_line/machine_max_power_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

class PlotLineController extends GetxController with InternetConnectivityCheckMixin {
  bool isConnected = true;
  bool hasError = false;
  bool isMachineMaxPowerLoading = false;
  String errorMessage = '';
  MachineMaxPowerModel plotMachineMaxPower = MachineMaxPowerModel();

  Future<bool> fetchMaxMachineData({required String nodeName}) async {
    isMachineMaxPowerLoading = true;
    isConnected = true;
    update();
    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getMachineMaxPowerUrl(nodeName));
      isMachineMaxPowerLoading = false;


      // log("getMachineMaxPowerUrl Status : ${Urls.getMachineMaxPowerUrl(nodeName)}");
      // log("getMachineMaxPowerUrl Status : ${response.statusCode}");
      // log("getMachineMaxPowerUrl Body : ${response.body}");

      if (response.isSuccess) {

        plotMachineMaxPower = MachineMaxPowerModel.fromJson(response.body);
        update();
        return true;

      } else {
        errorMessage = "Can't load machine max power data";
        hasError = true;
        update();
        return false;
      }
    } catch (e) {
      hasError = true;
      isMachineMaxPowerLoading = false;

      errorMessage = e.toString();
      if (e is AppException) {
        errorMessage = e.error.toString();
        isConnected = false;
        hasError = false;
      }

      log('Error in fetching machine max power data: $errorMessage');
      update();
      return false;
    }
  }
}