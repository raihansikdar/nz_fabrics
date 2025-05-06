import 'package:get/get.dart';

class ShedViewController extends GetxController {

  int selectedButton = 1;

  void updateButton({required int value}){
    selectedButton = value;
    update();
  }

}