import 'dart:developer';

import 'package:google_fonts/google_fonts.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_exit/flutter_smart_exit_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_day_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/screens/analysis_pro_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/views/screens/diesel_generator_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/views/screens/gas_generator_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/views/screens/natural_gas_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/views/screens/water_process_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/dash_board_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/dash_board_radio_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/search_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/tab_bar_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/views/widgets/navigation_drawer_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/data_tab_view_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/controller/electricity_long_sld_all_info_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/controller/electricity_long_sld_live_all_node_power_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/controller/electricity_long_sld_lt_production_vs_capacity_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/sld_tab_view/sld_tab_view_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/load_power_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/machine_view_names_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_source_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/views/screens/power_summary_chart_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/steam_summary/views/screen/steam_summary_chart_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/load_water_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/pie_chart_water_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/pie_chart_water_source_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/source_water_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/water_load_category_wise_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/water_source_category_wise_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/views/screens/water_summary_chart_screen.dart';
import 'package:nz_fabrics/src/features/error_page/error_page.dart';
import 'package:nz_fabrics/src/features/error_page/no_internet_page.dart';
import 'package:nz_fabrics/src/features/notification/controller/all_notification_controller.dart';
import 'package:nz_fabrics/src/features/notification/controller/notification_controller.dart';
import 'package:nz_fabrics/src/features/notification/local_notification_service/local_notification_service.dart';
import 'package:nz_fabrics/src/features/notification/views/screens/notification_screens.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:upgrader/upgrader.dart';

class EmsDashboardScreen extends StatefulWidget {
  const EmsDashboardScreen({super.key});

  @override
  State<EmsDashboardScreen> createState() => _EmsDashboardScreenState();
}

class _EmsDashboardScreenState extends State<EmsDashboardScreen>   with TickerProviderStateMixin {

  //late final TabController _tabController;
  late final ScrollController _scrollController;
  TextEditingController searchTEController = TextEditingController();

 //DashBoardButtonController controllerExitOrNot = Get.put(DashBoardButtonController());

 NotificationService notificationService = NotificationService();
  @override
  void initState() {
    super.initState();

    //_tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();

    // _notificationService = NotificationService();
   // _notificationService.showNotification();



      //notificationService.initNotification(); // off notification
      WidgetsBinding.instance.addPostFrameCallback((_){
       // Get.find<DashBoardButtonController>().fetchButton();
     // Get.find<AnalysisProDayButtonController>().fetchDayModelDGRData(fromDate:  Get.find<AnalysisProDayButtonController>().fromDateTEController.text, toDate:  Get.find<AnalysisProDayButtonController>().toDateTEController.text);
    //  Get.find<AnalysisProDayButtonController>().fetchSelectedNodeData(fromDate:  Get.find<AnalysisProDayButtonController>().fromDateTEController.text, toDate:  Get.find<AnalysisProDayButtonController>().toDateTEController.text);
      //Get.find<AllNotificationController>().fetchNotificationData();
      Get.find<LoadPowerController>().fetchLoadPowerData();

      Get.find<ElectricityLongSLDAllInfoController>().fetchSourcePowerData();



   //   Get.find<PieChartPowerLoadController>().fetchPieChartData();
      //Get.find<PieChartPowerSourceController>().fetchPieChartData();

    });
  }

  @override
  void dispose() {
    //_tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (Get.find<SearchDataController>().isSearching) {
          Get.find<SearchDataController>().changeSearchStatus(false);
        }
      },
      child: GetBuilder<SearchDataController>(
          builder: (searchDataController) {
            return UpgradeAlert(
              // dialogStyle: UpgradeDialogStyle.material,
              // showIgnore: false,
              // showLater: true,
              // upgrader: Upgrader(
              //  minAppVersion: '1.0.2',
              //   storeController: UpgraderStoreController(
              //     onAndroid: () => UpgraderPlayStore(),
              //    // oniOS: () => UpgraderAppcastStore(appcastURL: appcastURL),
              //   ),

              dialogStyle: UpgradeDialogStyle.material,
              showIgnore: false,
              showLater: false,
              shouldPopScope: () => false, // Prevent dismissing the dialog
              upgrader: Upgrader(
                minAppVersion: '1.0.2',
                durationUntilAlertAgain: Duration.zero, // Show update prompt every time
               // debugDisplayAlways: true, // Ensure it always shows (for testing)
                storeController: UpgraderStoreController(
                  onAndroid: () => UpgraderPlayStore(),
                  // oniOS: () => UpgraderAppcastStore(appcastURL: appcastURL),
                ),
              ),
              child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: AppColors.backgroundColor,
                appBar:  AppBar(
                  backgroundColor: AppColors.whiteTextColor,
                  toolbarHeight: size.height * 0.056,
                  centerTitle: true,
                  title: /*searchDataController.isSearching
                      ? SizedBox(
                    height: 45,
                    child: GetBuilder<SearchDataController>(
                      init: Get.find<SearchDataController>(),
                      builder: (controller) {
                        return SearchField<SearchModel>(
                          itemHeight:  size.height * k50TextSize,
                          controller: searchTEController,
                          hint: 'Search...',
                          onSearchTextChanged: (String value) {
                            controller.fetchSearchData(searchData: value.trim());
                            return;
                          },
                          suggestions: controller.searchList.map((e) => SearchFieldListItem<SearchModel>(
                              e.nodeName ?? '',
                              item: e,
                              child: GetBuilder<SearchGetLiveDataController>(
                                  init: SearchGetLiveDataController(),
                                  builder: (searchGetLiveDataController) {
                                    return GestureDetector(
                                      onTap: () {
                                        searchGetLiveDataController.fetchSearchLiveData(searchQueryName: e.nodeName ?? '');


                                        Future.delayed(const Duration(milliseconds: 500), () {
                                          if (searchGetLiveDataController.searchLiveDataModel != null) {

                                           // log("Power value: ${searchGetLiveDataController.searchLiveDataModel.power ?? 'No Power Data'}");

                                            if (e.category == "Grid" || e.category == "Solar") {

                                              Get.to(() => PowerAndEnergyElementDetailsScreen(elementName: e.nodeName ?? '', gaugeValue: searchGetLiveDataController.searchLiveDataModel.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power', solarCategory: e.category ?? ""), transition: Transition.rightToLeft);

                                              searchDataController.changeSearchStatus(false);

                                            } else if (e.category == "Electricity" && e.sourceType == "Load") {
                                              Get.to(() => GeneratorElementDetailsScreen(elementName: e.nodeName ?? '', gaugeValue: searchGetLiveDataController.searchLiveDataModel.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power'),transition: Transition.rightToLeft);
                                            }
                                          } else if(e.category == "Electricity" && e.sourceType == "Load") {
                                            Get.to(() => PowerAndEnergyElementDetailsScreen(elementName: e.nodeName ?? '', gaugeValue: searchGetLiveDataController.searchLiveDataModel.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power', solarCategory: e.category ?? ""), transition: Transition.rightToLeft);


                                          }else{
                                            AppToast.showWrongToast("No data available now");
                                             log("No data available now");
                                          }
                                        });
                                      },


                                      child: SizedBox(
                                        height: size.height * k40TextSize,
                                        width: double.infinity,
                                        child:  Padding(
                                            padding: EdgeInsets.only(top: size.height * k8TextSize),
                                            child: TextComponent(text: e.nodeName ?? '',fontSize: size.height * k16TextSize,fontFamily: semiBoldFontFamily,color: AppColors.secondaryTextColor,)
                                        ),
                                      ),
                                    );
                                  }
                              )
                          )).toList(),
                        );
                      },
                    ),
                  ) :  */ Text("NZ Fabrics",style: GoogleFonts.kadwa(color:AppColors.primaryColor,fontSize: size.height * 0.028,fontWeight: FontWeight.w700 )),
                  leading: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  actions: [
                    // Padding(
                    //   padding: EdgeInsets.only(right: size.width * k30TextSize),
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       bool currentStatus = !Get.find<SearchDataController>().isSearching;
                    //       Get.find<SearchDataController>().changeSearchStatus(currentStatus);
                    //     },
                    //     child: const Icon(Icons.search),
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(right: size.width * k30TextSize),
                      child: GestureDetector(
                        onTap: (){
                          Get.find<NotificationController>().unseenCount = 0;
                          Get.find<NotificationController>().update();
                          Get.to(()=>const NotificationScreens(),transition: Transition.fadeIn,duration: const Duration(milliseconds: 100));
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

                drawer: const NavigationDrawerWidget(),
                body: RefreshIndicator(
                  onRefresh: () async{
                    WidgetsBinding.instance.addPostFrameCallback((_){
                      Get.find<PieChartPowerSourceController>().fetchPieChartData();
                      Get.find<PieChartPowerLoadController>().fetchPieChartLoadData();
                      Get.find<CategoryWiseLiveDataController>().fetchCategoryWiseLiveData();
                      Get.find<MachineViewNamesDataController>().fetchMachineViewNamesData();

                    });
                  },
                  child: Scrollbar(
                    thumbVisibility: false,
                    trackVisibility: false,
                    controller: _scrollController,
                    child:  Padding(
                          padding:  EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize),
                          child: GetBuilder<DashBoardRadioButtonController>(
                            builder: (dController) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                physics: /*dController.selectedValue == 1 ?const AlwaysScrollableScrollPhysics() :*/ const NeverScrollableScrollPhysics(),
                                controller: _scrollController,
                  
                                child: GetBuilder<DashBoardRadioButtonController>(
                                    builder: (dashBoardRadioButtonController) {
                                      return SizedBox(
                                        height: (dController.selectedValue == 1 || dController.selectedValue == 2) ? size.height : size.width > 500 ? size.height * .99 :  size.height * 1.2 ,
                                        child: FlutterSmartExitWidget(
                                          exitOption: ExitOption.bottomSheet,
                                          child: Column(
                                              children: [
                                                SizedBox(height: size.height *k20TextSize,),
                                                GetBuilder<DashBoardRadioButtonController>(
                                                    builder: (dashBoardRadioButtonController) {
                                                      return/* Flexible(
                                                        flex:  controller.buttonList.isEmpty ? 7 : controller.buttonList.length >2 ? 4 : 6,
                                                        fit: FlexFit.tight,
                                                        child:*/ Container(
                                                           //  height:  size.width > 500 ? (controllerExitOrNot.buttonList.isEmpty ? dashBoardRadioButtonController.selectedValue != 3 ? size.height - 120 : size.height - 120  :  dashBoardRadioButtonController.selectedValue != 3 ?  size.height * 0.835 : size.height - 140)  :  (controllerExitOrNot.buttonList.isEmpty ? dashBoardRadioButtonController.selectedValue != 3 ? size.height - 100 : size.height + 30  :  dashBoardRadioButtonController.selectedValue != 3 ?  size.height * 0.835 : size.height + 100),
                                                             height:  size.width > 500 ? ( dashBoardRadioButtonController.selectedValue != 3 ? size.height - 120 : size.height - 120 )  :  ( dashBoardRadioButtonController.selectedValue != 3 ? size.height - 100 : size.height + 30 ),
                                                              // height: dashBoardRadioButtonController.selectedValue ==1 ?  size.height * .68 : dashBoardRadioButtonController.selectedValue == 2 ? size.height * 0.850 : size.height * .850,
                                                              width: double.infinity,
                                                              // borderRadius: BorderRadius.circular(size.height * k16TextSize),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(size.height * k16TextSize),
                                                                  border: Border.all(color: AppColors.containerBorderColor)
                                                              ),
                                                              child: GetBuilder<TabControllerLogicController>(
                                                                  builder: (controller) {
                                                                    if (controller.tabController == null || controller.tabNames.isEmpty) {
                                                                      return const Center(child: CircularProgressIndicator(),
                                                                      );
                                                                    }

                                                                    final double tabWidth = size.width > 800
                                                                        ? (size.width / controller.tabNames.length) * 0.95
                                                                        : (size.width / controller.tabNames.length) * 0.90;

                                                                    return Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                            color: AppColors.containerTopColor,
                                                                            borderRadius: BorderRadius.only(topRight: Radius.circular( size.height * k16TextSize),topLeft:  Radius.circular( size.height * k16TextSize)),
                                                                          ),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                            children: [
                                                                              Expanded(
                                                                                child: GestureDetector(
                                                                                  onTap: (){
                                                                                    dashBoardRadioButtonController.updateSelectedValue(1);
                                                                                   // Get.find<MachineViewController>().updateButton(value: 1);
                                                                                    log("----------Press-------- 1");
                                                                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                                      dashBoardRadioButtonController.updateSelectedValue(1);
                                                                                      Get.find<PieChartPowerSourceController>().startApiCallOnScreenChange();
                                                                                      Get.find<PieChartPowerLoadController>().startApiCallOnScreenChange();
                                                                                      Get.find<CategoryWiseLiveDataController>().startApiCallOnScreenChange();
                                                                                      Get.find<MachineViewNamesDataController>().startApiCallOnScreenChange();
                                                                                    });

                                                                                  },
                                                                                  child: Container(
                                                                                    height: size.height * 0.050,
                                                                                    decoration: BoxDecoration(
                                                                                        color: dashBoardRadioButtonController.selectedValue == 1 ?  /*const Color(0xFF2d98ed)*/ AppColors.primaryColor : Colors.transparent,
                                                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(size.height * k15TextSize))
                                                                                    ),
                                                                                    child: Center(child: TextComponent(text: "Summary",color: dashBoardRadioButtonController.selectedValue == 1 ?  AppColors.whiteTextColor : AppColors.secondaryTextColor)),),
                                                                                ),
                                                                              ),

                                                                                Expanded(
                                                                              child: GestureDetector(
                                                                                onTap: (){
                                                                                  dashBoardRadioButtonController.updateSelectedValue(2);
                                                                                  log("----------Press-------- 2");
                                                                                },
                                                                                child: Container(
                                                                                  height: size.height * 0.050,
                                                                                  decoration:  BoxDecoration(
                                                                                    color:  dashBoardRadioButtonController.selectedValue == 2 ?  AppColors.primaryColor :  Colors.transparent,
                                                                                       borderRadius: BorderRadius.circular(size.height * k5TextSize)
                                                                                  ),
                                                                                  child: Center(child: TextComponent(text: "SLD",color: dashBoardRadioButtonController.selectedValue == 2 ?  AppColors.whiteTextColor : AppColors.secondaryTextColor)),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                              Expanded(child: GestureDetector(
                                                                                onTap: (){
                                                                                  dashBoardRadioButtonController.updateSelectedValue(3);
                                                                                  log("----------Press-------- 3");

                                                                                  WidgetsBinding.instance.addPostFrameCallback((_) {

                                                                                    Get.find<PieChartPowerSourceController>().stopApiCallOnScreenChange();
                                                                                    Get.find<PieChartPowerLoadController>().stopApiCallOnScreenChange();
                                                                                    Get.find<CategoryWiseLiveDataController>().stopApiCallOnScreenChange();
                                                                                    Get.find<MachineViewNamesDataController>().stopApiCallOnScreenChange();
                                                                                  });



                                                                                },
                                                                                child: Container(
                                                                                  height: size.height * 0.050,
                                                                                  decoration: BoxDecoration(
                                                                                      color:   dashBoardRadioButtonController.selectedValue == 3 ? AppColors.primaryColor :  Colors.transparent,
                                                                                      borderRadius: BorderRadius.only(topRight: Radius.circular(size.height * k15TextSize))
                                                                                  ),

                                                                                  child: Center(child: TextComponent(text: "Data",color: dashBoardRadioButtonController.selectedValue == 3  ?  AppColors.whiteTextColor : AppColors.secondaryTextColor)),
                                                                                ),
                                                                              )),

                                                                            ],
                                                                          ),),


                                                                        dashBoardRadioButtonController.selectedValue == 1 ?      /*Padding(
                                                                          padding: EdgeInsets.symmetric(horizontal: size.height * k14TextSize),
                                                                          child: TabBar(
                                                                            controller: controller.tabController,
                                                                            dividerHeight: 3.5,
                                                                            labelStyle: TextStyle(
                                                                              fontSize: size.height * k17TextSize,
                                                                              fontFamily: boldFontFamily,
                                                                            ),
                                                                            unselectedLabelStyle: TextStyle(
                                                                              fontSize: size.height * k17TextSize,
                                                                              fontFamily: mediumFontFamily,
                                                                            ),
                                                                            labelColor: AppColors.primaryColor,
                                                                            unselectedLabelColor: AppColors.secondaryTextColor,
                                                                            tabs: controller.tabNames.map((name) => Tab(text: name)).toList(),
                                                                            indicator: RoundedRectangleTabIndicator(
                                                                              color: AppColors.primaryColor,
                                                                              weight: 3.5,
                                                                              width: tabWidth,
                                                                              radius: size.height * k20TextSize,
                                                                            ),
                                                                          ),
                                                                        )*/ SizedBox(
                                                                           // height:size.width > 500 ? controllerExitOrNot.buttonList.isEmpty ? size.height * 0.833 :    size.height * 0.77 : size.height * 0.83,
                                                                            height:size.width > 500 ?  size.height * 0.833  : size.height * 0.83,
                                                                            child: DefaultTabController(
                                                                                length: 3,
                                                                                child: Column(
                                                                                  children: [
                                                                                    // TabBar in the body
                                                                                    const TabBar(
                                                                                      tabs: [
                                                                                        Tab(text: 'Electricity'),
                                                                                        Tab(text: 'Water'),
                                                                                        Tab(text: 'Steam'),
                                                                                      ],
                                                                                    ),
                                                                                    // TabBarView takes the remaining space
                                                                                    Expanded(
                                                                                      child: TabBarView(
                                                                                        children: [
                                                                                          const PowerSummaryChartScreen(),
                                                                                           const WaterSummaryChartScreen(),
                                                                                          const SteamSummaryChartScreen(),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )

                                                                            ))/*: const SizedBox(),

                                                                        dashBoardRadioButtonController.selectedValue == 1 ?      Expanded(
                                                                          child: TabBarView(
                                                                            controller: controller.tabController,
                                                                            children: controller.tabNames.map((tabName) {
                                                                              return Padding(
                                                                                padding: EdgeInsets.only(bottom: size.height * k10TextSize),
                                                                                child: Center(
                                                                                  child: GetBuilder<DashBoardRadioButtonController>(
                                                                                    builder: (radioController) {
                                                                                      switch (tabName.toLowerCase()) {
                                                                                        case 'electricity':
                                                                                          return  const PowerSummaryChartScreen();

                                                                                        case 'water':

                                                                                          return const WaterSummaryChartScreen();

                                                                                        default:
                                                                                          return const Center(child: Text("No information available"));
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                          ),
                                                                        )*/ : dashBoardRadioButtonController.selectedValue == 2 ?


                                                                      SizedBox(
                                                                       //   height:size.width > 500 ? controllerExitOrNot.buttonList.isEmpty ? size.height * 0.833 :    size.height * 0.77 : size.height * 0.82,
                                                                          height:size.width > 500 ?  size.height * 0.833  : size.height * 0.82,

                                                                          child: const SldTabViewScreen(),
                                                                      ) : SizedBox(
                                                                            height: size.width > 500 ?  size.height * 0.833 : size.height * 0.95,


                                                                            child: const DataTabViewScreen()) ,
                                                                      ],
                                                                    );
                                                                  }
                                                              ),
                                                            );

                                                     // );
                                                    }
                                                ),
                  
                                                SizedBox(height: size.height * k16TextSize,),
                  
                  
                                                dashBoardRadioButtonController.selectedValue == 1 ? Expanded(
                                                    child: GetBuilder<DashBoardButtonController>(
                                                        builder: (dashBoardButtonController) {
                                                          bool isEven = false;
                                                          if(dashBoardButtonController.buttonList.length % 2 == 0){
                                                            isEven = true;
                                                          }else{
                                                            isEven = false;
                                                          }
                  
                                                          if(dashBoardButtonController.isLoading){
                                                            return GridView.builder(
                                                              physics: const NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount: isEven ? 2 : 3,
                                                                mainAxisSpacing: size.height * k10TextSize,
                                                                crossAxisSpacing:size.height * k10TextSize,
                                                                childAspectRatio: isEven ?  (size.width > 1000 ? size.height * 0.015: size.height * 0.0045) : (size.width > 1000 ? size.height * 0.01: size.height * 0.0030),
                                                              ),
                                                              itemCount: isEven ? 2 : 3,
                                                              itemBuilder: (context, index) {
                                                                return  CustomShimmerWidget(height:   size.height * 0.080, width: double.infinity);
                                                              },
                                                            );
                                                          }
                                                          return GridView.builder(
                                                            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: isEven ? 2 : 3,
                                                              mainAxisSpacing: size.height * k10TextSize,
                                                              crossAxisSpacing:size.height * k10TextSize,
                                                              childAspectRatio: isEven ?  (size.width > 1000 ? size.height * 0.015: size.height * 0.0045) : (size.width > 1000 ? size.height * 0.01: size.height * 0.0030),
                                                            ),
                                                            itemCount: dashBoardButtonController.buttonList.length,
                                                            itemBuilder: (context, index) {
                                                              final button =  dashBoardButtonController.buttonList[index];
                  
                                                              return  GestureDetector(
                                                                onTap: (){
                                                                  button.type == "analysis_pro" ?
                                                                  Get.to(()=> AnalysisProScreen(buttonName: button.name ?? ''),transition:Transition.fadeIn,duration: const Duration(seconds: 0) )
                                                                      :   button.type == "natural_gas" ? Get.to(()=> const NaturalGasScreen(),transition:Transition.fadeIn,duration: const Duration(seconds: 0))
                                                                  /*:  button.type == "summary" ? Get.to(()=> const PlantSummaryScreen(),transition:Transition.fadeIn,duration: const Duration(seconds: 0))*/
                                                                      : button.type == "water" ? Get.to(()=> const WaterGeneratorScreen(),transition:Transition.fadeIn,duration: const Duration(seconds: 0))
                                                                      :  button.type == "diesel_generator" ? Get.to(()=> const DieselGeneratorScreen(),transition:Transition.fadeIn,duration: const Duration(seconds: 0))
                                                                      : Get.to(()=> const  GasGeneratorButtonScreen(),transition:Transition.fadeIn,duration: const Duration(seconds: 0));
                                                                },
                                                                child: CustomContainer(
                                                                  height: size.height * k12TextSize,
                                                                  width: double.infinity,
                                                                  borderRadius: BorderRadius.circular(size.height * k10TextSize),
                                                                  child: Padding(
                                                                    padding:  EdgeInsets.all(size.height * k8TextSize),
                                                                    child: Row(
                                                                      children: [
                                                                        button.type == "analysis_pro" ? SvgPicture.asset(AssetsPath.analysisProIconSVG,height: size.height * k30TextSize,) :   button.type == "natural_gas" ? SvgPicture.asset(AssetsPath.naturalGasIconSVG,height: size.height * k30TextSize,) :  button.type == "summary" ? SvgPicture.asset(AssetsPath.plantSummaryIconSVG,height: size.height * k30TextSize,) : button.type == "water" ? SvgPicture.asset(AssetsPath.waterIconSVG,height: size.height * k30TextSize,) :  button.type == "diesel_generator" ? SvgPicture.asset(AssetsPath.dieselGeneratorIconSVG,height: size.height * k30TextSize,) : SvgPicture.asset(AssetsPath.gasGeneratorIconSVG,height: size.height * k30TextSize,) ,
                                                                        SizedBox(width: size.width * k16TextSize,),
                                                                        isEven ?  TextComponent(text: button.name ?? '',color: AppColors.secondaryTextColor,) : SizedBox(
                                                                          width: size.height * 0.085,
                                                                          child: TextComponent(
                                                                            text: button.name ?? '',
                                                                            color: AppColors.secondaryTextColor,
                                                                            fontSize: size.height * k15TextSize,
                                                                            maxLines: 2,
                                                                            overflow: TextOverflow.fade,
                                                                            height: 1,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                    )
                  
                                                ) : const Expanded(child: SizedBox())
                  
                                              ],
                                            ),
                                        ),
                  
                                      );
                                    }
                                ),
                              );
                            }
                          ),
                        )

                  ),
                ),

                onDrawerChanged: (isOpened) {
                  if (isOpened) {

                    Get.find<PieChartPowerSourceController>().stopApiCallOnScreenChange();
                    Get.find<PieChartPowerLoadController>().stopApiCallOnScreenChange();
                    Get.find<CategoryWiseLiveDataController>().stopApiCallOnScreenChange();
                    Get.find<MachineViewNamesDataController>().stopApiCallOnScreenChange();
                   // Get.find<SourceWaterController>().stopApiCallOnScreenChange();
                  //  Get.find<LoadWaterController>().stopApiCallOnScreenChange();

                  } else {
                    Get.find<PieChartPowerSourceController>().startApiCallOnScreenChange();
                    Get.find<PieChartPowerLoadController>().startApiCallOnScreenChange();
                    Get.find<CategoryWiseLiveDataController>().startApiCallOnScreenChange();
                    Get.find<MachineViewNamesDataController>().startApiCallOnScreenChange();
                  }
                },
              ),
            );
          }
      ),
    );
  }

}


class RoundedRectangleTabIndicator extends Decoration {
  final BoxPainter _painter;

  RoundedRectangleTabIndicator({
    required Color color,
    required double weight,
    required double width,
    required double radius,
  }) : _painter = _RoundedRectanglePainter(color, weight, width, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _RoundedRectanglePainter extends BoxPainter {
  final Paint _paint;
  final double weight;
  final double width;
  final double radius;

  _RoundedRectanglePainter(Color color, this.weight, this.width, this.radius)
      : _paint = Paint()
    ..color = color
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset pos = offset + Offset(cfg.size!.width / 2 - width / 2, cfg.size!.height - weight);
    final Rect rect = Rect.fromLTWH(pos.dx, pos.dy, width, weight);
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    canvas.drawRRect(rRect, _paint);
  }
}


