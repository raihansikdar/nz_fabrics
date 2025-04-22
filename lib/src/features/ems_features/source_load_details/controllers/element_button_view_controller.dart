import 'dart:developer';

import 'package:get/get.dart';

class ElementButtonViewController extends GetxController{
  int selectedValue = 1;

  void updateSelectedValue(int value){
    selectedValue = value;
    update();
    //log(selectedValue.toString());
  }

}