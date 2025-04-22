import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';

mixin InternetConnectivityCheckMixin {
  Future<void> internetConnectivityCheck() async {
    final connectivity = Get.find<Connectivity>();
    final List<ConnectivityResult> connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw AppException("Internet connection lost");
    }
  }
}