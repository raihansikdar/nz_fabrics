import 'package:get/get.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';


class LiveDataController extends GetxController with InternetConnectivityCheckMixin{

   int selectedValue = 1;

   void updateSelectedValue(int value){
     selectedValue = value;
     update();
   }
}