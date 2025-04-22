import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/notification/controller/notification_controller.dart';
import 'package:nz_fabrics/src/features/notification/views/screens/notification_screens.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarWidget({
    super.key, required this.text, required this.backPreviousScreen,this.onBackButtonPressed
  });
  final String text;
  final bool backPreviousScreen;
  final Function? onBackButtonPressed;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
           backgroundColor: Colors.white,
            elevation: 4,
            toolbarHeight: size.height * 0.056,
            title: TextComponent(text: text, fontSize: size.height * k22TextSize),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                if (onBackButtonPressed != null) {
                  onBackButtonPressed!();
                  Navigator.pop(context);
                } else if (onBackButtonPressed == null) {
                  Navigator.pop(context);
                }
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

    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}