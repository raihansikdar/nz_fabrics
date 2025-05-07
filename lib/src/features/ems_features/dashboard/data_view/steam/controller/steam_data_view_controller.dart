import 'package:get/get.dart';

class SteamDataViewUIController extends GetxController{
  int selectedValue = 1;

  void updateSelectedValue(int value){
    selectedValue = value;
    update();
  }
}