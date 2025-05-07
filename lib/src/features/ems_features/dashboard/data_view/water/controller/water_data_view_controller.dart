import 'package:get/get.dart';

class WaterDataViewUIController extends GetxController{
  int selectedValue = 1;

  void updateSelectedValue(int value){
    selectedValue = value;
    update();
  }
}