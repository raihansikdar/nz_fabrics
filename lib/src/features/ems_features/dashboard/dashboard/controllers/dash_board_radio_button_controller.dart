import 'dart:developer';

import 'package:get/get.dart';

class DashBoardRadioButtonController extends GetxController{

  int selectedValue = 1;

  void updateSelectedValue(int value){
    selectedValue = value;
    log("--------------->$selectedValue");
    update();
  }



  int selectedSourceLoadValue = 1;

  void updateSourceLoadSelectedValue(int value){
    selectedSourceLoadValue = value;
    update();
  }


  int selectedChip = 1;

  void updateSelectedChipValue(int value){
    selectedChip = value;
    update();
  }

}