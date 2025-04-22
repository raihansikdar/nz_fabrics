import 'package:nz_fabrics/src/features/user_management/controller/change_user_type/change_user_type_controller.dart';
import 'package:nz_fabrics/src/features/user_management/controller/pendin_request/pending_user_controller.dart';
import 'package:get/get.dart';

class UserManagementController extends GetxController{

  int selectedIndex = 0;

  void setActiveBox(int index) {
    if(index !=2){
      Get.find<ChangeUserTypeController>().myAnimation = false;
    }if(index !=1){
      Get.find<PendingUserController>().pendingCardAnimation = false;
    }
    selectedIndex = index;
    update();
  }
}

