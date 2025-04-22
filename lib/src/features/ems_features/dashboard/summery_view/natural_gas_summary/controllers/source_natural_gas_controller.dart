import 'dart:async';
import 'dart:developer';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/model/power_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:get/get.dart';

class SourceNaturalGasController extends GetxController with InternetConnectivityCheckMixin {
  List<PowerModel> naturalGasList = [];
  bool isLoading = false;
  bool hasError = false;
  bool isConnected = true;
  Timer? _timer;

// @override
//   void onInit() {
//   fetchSourceNaturalGasData();
//     super.onInit();
//   }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
  Future<void> fetchSourceNaturalGasData() async {



      try {
        isConnected = true;
        isLoading = true;
        update();

        await internetConnectivityCheck();
        NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getAllInfoUrl);

        // log('Water summary Body: ${response.body}');

        if (response.statusCode == 200) {
          List<dynamic> waterListData = response.body;

          // Map response data to PowerModel list
          naturalGasList = waterListData.map((item) => PowerModel.fromJson(item)).toList();

          // Filter only entries with sourceCategory 'Water' and exclude 'Bus_Bar' sourceType
          naturalGasList = naturalGasList.where((water) {
            return water.sourceCategory == 'Natural_Gas' && water.sourceType != 'Bus_Bar';
          }).toList();

          isLoading = false;

          // log("Filtered WaterList (excluding 'Bus_Bar'): $waterList");

          update();
          hasError = false;
        } else {
          log('Water fetching error data: ${response.statusCode}, ${response.body}');
          hasError = true;
        }
      } catch (e) {
        log("Water fetching error data: $e");
        hasError = true;
      } finally {
        isLoading = false;
        update();
      }

    }

}