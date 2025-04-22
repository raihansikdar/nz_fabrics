import 'package:get/get.dart';

class GeneratorDataController extends GetxController{
  // ->>----------------------->>UI <<------------------------<<-
  int selectedButton = 1;

  void updateSelectedButton({required int value}){
    selectedButton = value;
    update();
  }
}