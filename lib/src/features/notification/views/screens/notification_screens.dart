import 'package:nz_fabrics/src/common_widgets/custom_color_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/empty_page_widget/empty_page_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/notification/controller/all_notification_controller.dart';
import 'package:nz_fabrics/src/features/notification/controller/notification_controller.dart';
import 'package:nz_fabrics/src/features/notification/model/all_notification_data_model.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:badges/badges.dart' as badges;

class NotificationScreens extends StatefulWidget {
  const NotificationScreens({super.key});

  @override
  State<NotificationScreens> createState() => _NotificationScreensState();
}

class _NotificationScreensState extends State<NotificationScreens> {

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   AllNotificationController notificationController = Get.find<AllNotificationController>();
    //   notificationController.fetchNotificationData().then((_) {
    //     notificationController.groupNotificationsByDate();
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar:  AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        toolbarHeight: size.height * 0.056,
        title: TextComponent(text: "Notifications", fontSize: size.height * k22TextSize),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Get.find<NotificationController>().unseenCount;
          },
          icon: Icon(
            Icons.arrow_back_rounded,size: size.height * iconSize,
            color: AppColors.primaryTextColor,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: size.width * k30TextSize),
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
       /* child: GetBuilder<AllNotificationController>(
          builder: (allNotificationController) {
            final groupedData = allNotificationController.groupedNotifications;

            // Check if there are any notifications
            if (groupedData.isEmpty) {
              return EmptyPageWidget(size: size);
            }

            return ListView.builder(
              itemCount: groupedData.length,
              itemBuilder: (context, index) {
                String dateKey = groupedData.keys.elementAt(index);
                List<AllNotificationDataModel> notifications = groupedData[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header (Today, Yesterday, or specific date)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                      child: TextComponent(
                        text: dateKey,
                        fontSize: size.height * k18TextSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Notifications for the current date section
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notifications.length,
                      separatorBuilder: (context, _) => SizedBox(height: size.height * k8TextSize),
                      itemBuilder: (context, index) {
                        var notification = notifications[index];
                        String formattedTime = DateFormat('hh:mm a').format(notification.timedate!);

                        return Stack(
                          children: [
                            CustomColorContainer(
                              height: size.height * 0.07,
                              width: double.infinity,
                              color: notification.seen == false ? const Color(0xFFe7f2fb) : AppColors.whiteTextColor,
                              border: Border.all(color: AppColors.containerBorderColor),
                              size: size,
                              child: Padding(
                                padding: EdgeInsets.all(size.height * k8TextSize),
                                child: TextComponent(
                                  text: notification.notification ?? '',
                                  fontSize: size.height * k18TextSize,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: size.height * k5TextSize,
                              right: size.height * k10TextSize,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time_outlined,
                                    size: size.height * k22TextSize,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(width: size.height * k8TextSize),
                                  TextComponent(
                                    text: formattedTime,
                                    fontSize: size.height * k14TextSize,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),*/
      ),
    );
  }
}

