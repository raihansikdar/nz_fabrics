import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/notification/controller/notification_controller.dart';
import 'package:nz_fabrics/src/features/notification/views/screens/notification_screens.dart';
import 'package:nz_fabrics/src/features/user_management/controller/change_user_type/change_user_type_controller.dart';
import 'package:nz_fabrics/src/features/user_management/controller/pendin_request/pending_user_controller.dart';
import 'package:nz_fabrics/src/features/user_management/controller/user_management_controller.dart';
import 'package:nz_fabrics/src/features/user_management/views/widget/management_widget.dart';
import 'package:nz_fabrics/src/features/user_management/views/widget/sub_screen/change_user_type_widget.dart';
import 'package:nz_fabrics/src/features/user_management/views/widget/sub_screen/create_user_widget.dart';
import 'package:nz_fabrics/src/features/user_management/views/widget/sub_screen/pending_request_widget.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;


class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<PendingUserController>().fetchPendingUserData();
      Get.find<ChangeUserTypeController>().fetchApprovedUserData();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      appBar:  AppBar(
        backgroundColor: AppColors.whiteTextColor,
        elevation: 4,
        toolbarHeight: size.height * 0.056,
        title: TextComponent(text: "User Management", fontSize: size.height * k22TextSize),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Future.delayed(const Duration(seconds: 1)).then((_){
              Get.find<UserManagementController>().setActiveBox(0);
              Get.find<ChangeUserTypeController>().myAnimation = false;
            });

          },
          icon: Icon(
            Icons.arrow_back_rounded,size: size.height * iconSize,
            color: AppColors.primaryTextColor,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: size.width * k30TextSize),
            child: GestureDetector(
              onTap: (){
                Get.find<NotificationController>().unseenCount = 0;
                Get.find<NotificationController>().update();
                Get.to(()=>const NotificationScreens(),transition: Transition.fadeIn,duration: const Duration(seconds: 0));
              },
              child: GetBuilder<NotificationController>(
                  builder: (notificationController) {

                    if(notificationController.unseenCount == 0){
                      return Icon(Icons.notifications_none_sharp,size: size.height * k30TextSize,);
                    }

                    return badges.Badge(
                      position: badges.BadgePosition.topEnd(top: -7, end: -6),
                      badgeContent: TextComponent(text: notificationController.unseenCount.toString(),color: Colors.white,),

                      badgeAnimation: const badges.BadgeAnimation.fade(
                        animationDuration: Duration(seconds: 1),
                        colorChangeAnimationDuration: Duration(seconds: 1),
                        loopAnimation: false,
                        curve: Curves.easeIn,
                        colorChangeAnimationCurve: Curves.easeIn,
                      ),


                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Colors.red,
                      ),
                      child: Icon(Icons.notifications_none_sharp,size: size.height * k30TextSize,), // widget to place the badge on
                    );
                  }
              ),
            ),
          ),
        ],
      ),
      body: GetBuilder<UserManagementController>(
        builder: (userManagementController) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(size.height * k8TextSize),
                child: ManagementRowWidget(size: size),
              ),
              SizedBox(height: size.height * k16TextSize,),
              userManagementController.selectedIndex == 0 ? Expanded(
                child: Container(
                  height: size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.whiteTextColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(size.height * k30TextSize),
                      topRight: Radius.circular(size.height * k30TextSize),
                
                    ),
                    border: Border.all(color: AppColors.blueTextColor)
                  ),
                
                  child: CreateUserWidget(size: size), // ------------------- Create user widget ----------------
                
                
                ),
              ) : userManagementController.selectedIndex == 1 ? Expanded(
                child: Container(
                  height: size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.whiteTextColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.height * k30TextSize),
                        topRight: Radius.circular(size.height * k30TextSize),
                
                      ),
                      border: Border.all(color: AppColors.mistyBoldTextColor)
                  ),
                  child: PendingRequestWidget(size: size),  // ------------------- Create user widget ----------------
                
                ),
              ) : Expanded(
                child: Container(
                  height: size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.whiteTextColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.height * k30TextSize),
                        topRight: Radius.circular(size.height * k30TextSize),
                
                      ),
                      border: Border.all(color: AppColors.greyBoldTextColor),
                
                  ),
                  child: ChangeUserTypeWidget(size: size),
                ),
              )
            ],
          );
        }
      ),
    );
  }
}








