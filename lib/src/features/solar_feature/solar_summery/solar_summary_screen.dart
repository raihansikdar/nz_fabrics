import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/notification/controller/notification_controller.dart';
import 'package:nz_fabrics/src/features/notification/views/screens/notification_screens.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/ac_power/views/screen/ac_power_screen.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/active_power_controller/views/screen/active_power_controller_screen.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/views/screens/assorted_data_screen.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/controllers/dgr_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/views/screen/solar_dgr_screen.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/energy/views/screen/energy_screen.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/sensor_data/views/screens/sensor_data_screen.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;


class SolarSummaryScreen extends StatefulWidget {
  const SolarSummaryScreen({super.key});

  @override
  State<SolarSummaryScreen> createState() => _SolarSummaryScreenState();
}

class _SolarSummaryScreenState extends State<SolarSummaryScreen> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 6,
      child: Scaffold(

    body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            title:TextComponent(text: "Solar Summary", fontSize: size.height * k20TextSize),
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
              Future.delayed(const Duration(seconds: 1)).then((_){
                Get.find<DgrController>().clearFilterIngDate();
                Get.find<DgrController>().fetchDgrData( fromDate: Get.find<DgrController>().fromDateTEController.text, toDate: Get.find<DgrController>().toDateTEController.text);
              });
            }, icon: const Icon(Icons.arrow_back)),
            centerTitle: true,
            pinned: true,
            floating: true,
           // backgroundColor: AppColors.primaryColor,
            toolbarHeight: size.height * 0.036,
            elevation: 4,
           // iconTheme: const IconThemeData(color: AppColors.whiteTextColor),
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
            bottom: TabBar(
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                labelColor: AppColors.primaryColor,
                labelStyle: TextStyle(fontSize: size.height * k16TextSize,fontFamily: boldFontFamily),
                unselectedLabelColor: AppColors.secondaryTextColor,
                unselectedLabelStyle: TextStyle(fontSize: size.height * k16TextSize,fontFamily: semiBoldFontFamily),
                indicatorColor:  AppColors.primaryColor,
                indicatorWeight: 5,
                // indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                        Tab(text: "Assorted Data"),
                        Tab(text: "DGR"),
                        Tab(text: "Energy"),
                        Tab(text: "Sensor Data"),
                        Tab(text: "Ac Power"),
                        Tab(text: "Active Power Control"),

                ]
            ),
          ),

        ],

        body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
                    AssortedDataScreen(),
                    SolarDgrScreen(),
                    EnergyScreen(),
                    SensorDataScreen(),
                    AcPowerScreen(),
                    ActivePowerControllerScreen()
            ])
    ),
      ),
    );
  }
}

