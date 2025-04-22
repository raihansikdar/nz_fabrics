import 'dart:developer';

import 'package:nz_fabrics/src/common_widgets/custom_checkbox_button/custom_checkbox_button.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_day_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_monthly_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_yearly_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/analysis_pro_filter_result.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/bottom_sheet_filter_button_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/bottom_sheet_title_filter_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/date_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/download_button_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/monthly_bar_chart_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/multiple_items_choice_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/multiple_month_items_choice_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/multiple_yearly_items_choice_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/spline_chat_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/yearly_bar_chart_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/machine_view_names_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_source_controller.dart';
import 'package:nz_fabrics/src/features/notification/controller/notification_controller.dart';
import 'package:nz_fabrics/src/features/notification/views/screens/notification_screens.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
class AnalysisProScreen extends StatefulWidget {
  final String buttonName;
  const AnalysisProScreen({super.key, required this.buttonName});

  @override
  State<AnalysisProScreen> createState() => _AnalysisProScreenState();
}

class _AnalysisProScreenState extends State<AnalysisProScreen> with  TickerProviderStateMixin{
  // final Map<int, AnimationController> _controllers = {};
  // final Map<int, Animation<double>> _animations = {};
  late AnimationController _dgrController1;
  late AnimationController _dgrController2;
  late AnimationController _waterController1;
  late AnimationController _waterController2;
  late AnimationController _naturalGasController1;
  late AnimationController _naturalGasController2;


  late  Animation<double> _dgrAnimation1;
  late  Animation<double> _dgrAnimation2;
  late  Animation<double> _waterAnimation1;
  late  Animation<double> _waterAnimation2;
  late  Animation<double> _naturalGasAnimation1;
  late  Animation<double> _naturalGasAnimation2;


  @override
  void initState() {
    super.initState();


    _dgrController1 = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _dgrController2 = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _waterController1 = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _waterController2 = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _naturalGasController1 = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _naturalGasController2 = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);


    _dgrAnimation1 = Tween<double>(begin: 0, end: 0.5).animate(_dgrController1);
    _dgrAnimation2 = Tween<double>(begin: 0, end: 0.5).animate(_dgrController2);

    _waterAnimation1 = Tween<double>(begin: 0, end: 0.5).animate(_waterController1);
    _waterAnimation2 = Tween<double>(begin: 0, end: 0.5).animate(_waterController2);

    _naturalGasAnimation1 = Tween<double>(begin: 0, end: 0.5).animate(_naturalGasController1);
    _naturalGasAnimation2 = Tween<double>(begin: 0, end: 0.5).animate(_naturalGasController2);


    //log( "==>${Get.find<AnalysisProButtonController>().allWaterSourceItems}");


   // log( "==>${Get.find<AnalysisProButtonController>().selectedGridItemsMapString}");
   // log( "=***======>${Get.find<AnalysisProButtonController>().allSelectedGridItemsMap.values.first}");


    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<AnalysisProDayButtonController>().fetchDayModelDGRData(
        fromDate: Get.find<AnalysisProDayButtonController>().fromDateTEController.text,
        toDate: Get.find<AnalysisProDayButtonController>().toDateTEController.text,
      );
      Get.find<AnalysisProDayButtonController>().fetchSelectedNodeData(
        fromDate: Get.find<AnalysisProDayButtonController>().fromDateTEController.text,
        toDate: Get.find<AnalysisProDayButtonController>().toDateTEController.text,
      );


      Get.find<AnalysisProMonthlyButtonController>().fetchMonthDGRData(selectedMonth: Get.find<AnalysisProMonthlyButtonController>().selectedMonth.toString(), selectedYear: Get.find<AnalysisProMonthlyButtonController>().selectedYear.toString());
      Get.find<AnalysisProMonthlyButtonController>().fetchSelectedNodeData(selectedMonth: Get.find<AnalysisProMonthlyButtonController>().selectedMonth.toString(), selectedYear: Get.find<AnalysisProMonthlyButtonController>().selectedYear.toString());

      Get.find<AnalysisProYearlyButtonController>().fetchYearlyDGRData(selectedYearDate: Get.find<AnalysisProYearlyButtonController>().selectedYear);
      Get.find<AnalysisProYearlyButtonController>().fetchSelectedNodeData(selectedYear: Get.find<AnalysisProYearlyButtonController>().selectedYear);



      Get.find<PieChartPowerSourceController>().stopApiCallOnScreenChange();
      Get.find<PieChartPowerLoadController>().stopApiCallOnScreenChange();
      Get.find<CategoryWiseLiveDataController>().stopApiCallOnScreenChange();
      Get.find<MachineViewNamesDataController>().stopApiCallOnScreenChange();

    });

  }


  @override
  void dispose() {
    // _controllers.forEach((index, controller) => controller.dispose());
    _dgrController1.dispose();
    _dgrController2.dispose();
    _waterController1.dispose();
    _waterController2.dispose();
    _naturalGasController1.dispose();
    _naturalGasController2.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar:AppBar(
          backgroundColor: AppColors.whiteTextColor,
          toolbarHeight: size.height * 0.056,
          title: TextComponent(text: widget.buttonName, fontSize: size.height * k22TextSize),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<AnalysisProDayButtonController>().fromDateTEController.text =  DateFormat("dd-MM-yyyy").format(DateTime.now());
              Get.find<AnalysisProDayButtonController>().toDateTEController.text =  DateFormat("dd-MM-yyyy").format(DateTime.now());

              Get.find<AnalysisProDayButtonController>().selectedGridItemsMapString.clear();
              Get.find<AnalysisProDayButtonController>().checkboxGroupStates.clear();
              Get.find<AnalysisProDayButtonController>().itemsList.clear();
              Get.find<AnalysisProDayButtonController>().removeList.clear();



              Get.find<PieChartPowerSourceController>().startApiCallOnScreenChange();
              Get.find<PieChartPowerLoadController>().startApiCallOnScreenChange();
              Get.find<CategoryWiseLiveDataController>().startApiCallOnScreenChange();
              Get.find<MachineViewNamesDataController>().startApiCallOnScreenChange();


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
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 1.5,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: size.height * k12TextSize,right: size.height * k12TextSize,left: size.height * k12TextSize,bottom: size.height * k50TextSize),
              child: Stack(
                children: [
                  const DateWidget(),
                  Positioned(
                    top: size.height * .210,
                    child: SizedBox(
                      //height: size.height * 0.20,
                      width: MediaQuery.of(context).size.width - size.width * 0.050,
                      child: GetBuilder<AnalysisProDayButtonController>(
                        builder: (controller) {
                          return Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - size.width * 0.055,
                                child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(size.height * k16TextSize),
                                        side: const BorderSide(color: AppColors.containerBorderColor),
                                      ),
                                      margin: EdgeInsets.zero,
                                      color: AppColors.whiteTextColor,
                                      child: Padding(
                                        padding: EdgeInsets.all(size.height * k8TextSize),
                                        child: controller.selectedButton == 1
                                               ?  const MultipleItemsChoiceWidget()
                                               : controller.selectedButton == 2
                                               ? const MultipleMonthItemsChoiceWidget() : const MultipleYearlyItemsChoiceWidget(),
                                      ),
                                    )

                              ),
                              SizedBox(height: size.height * k30TextSize),

                              controller.selectedButton == 1 ?
                              GetBuilder<AnalysisProDayButtonController>(
                                  builder: (controller) {
                                    var validKeys = controller.selectedGridItemsMapString.keys.where(
                                            (key) => controller.selectedGridItemsMapString[key]?.isNotEmpty ?? false
                                    ).toList();

                                    return Container(
                                      height: size.height * 0.18,///-------------change here-------------
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteTextColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(size.height * k16TextSize)
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  filterBottomSheet(size: size);
                                                },
                                                child: BottomSheetFilterButtonWidget(size: size),
                                              ),
                                              SizedBox(width: size.width > 800 ? size.width * 0.300 : size.width * 0.120),
                                              AnalysisProFilterResult(size: size),
                                            ],
                                          ),
                                          Container(
                                            //elevation: 0.0,
                                            height: size.height * 0.12, ///-------------change here-------------
                                            decoration: BoxDecoration(
                                                color: AppColors.whiteTextColor,
                                                borderRadius: BorderRadius.circular(size.height * k16TextSize)
                                            ),
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: validKeys.length,
                                              itemBuilder: (context, index) {
                                                String listViewIndex = validKeys.elementAt(index);
                                              //  log("=====> See Map ==> $listViewIndex : ${controller.selectedGridItemsMapString[listViewIndex]?.join(", ")}");

                                                return Padding(
                                                    padding: EdgeInsets.only(
                                                      right: size.height * k16TextSize,
                                                      left: size.height * k16TextSize,
                                                    ),
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text: '$listViewIndex : ',
                                                              style: TextStyle(
                                                                color: AppColors.primaryColor,
                                                                fontSize: size.height * k18TextSize,
                                                                fontWeight: FontWeight.w600,
                                                                letterSpacing: 0.30,
                                                              )
                                                          ),
                                                          TextSpan(
                                                              text: '${controller.selectedGridItemsMapString[listViewIndex]?.join(", ")}',
                                                              style: TextStyle(
                                                                  color: AppColors.primaryTextColor,
                                                                  fontSize: size.height * k16TextSize,
                                                                  fontWeight: FontWeight.normal
                                                              )
                                                          ),

                                                        ],
                                                      ),
                                                    )
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  )
                               : controller.selectedButton == 2 ?
                              GetBuilder<AnalysisProMonthlyButtonController>(
                             builder: (controller) {
                               var validKeys = controller.selectedGridItemsMapString.keys.where(
                                       (key) => controller.selectedGridItemsMapString[key]?.isNotEmpty ?? false
                               ).toList();

                               return Container(
                                 height: size.height * 0.18, ///-------------change here-------------
                                 decoration: BoxDecoration(
                                   color: AppColors.whiteTextColor,
                                     boxShadow: [
                                       BoxShadow(
                                         color: Colors.black.withOpacity(0.1),
                                         spreadRadius: 1,
                                         blurRadius: 3,
                                         offset: const Offset(0, 2),
                                       ),
                                     ],
                                   borderRadius: BorderRadius.circular(size.height * k16TextSize)
                                 ),
                                 child: Column(
                                   children: [
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         GestureDetector(
                                           onTap: () {
                                             filterBottomSheet(size: size);
                                           },
                                           child: BottomSheetFilterButtonWidget(size: size),
                                         ),
                                         SizedBox(width: size.width > 800 ? size.width * 0.300 : size.width * 0.120),
                                         AnalysisProFilterResult(size: size),
                                       ],
                                     ),
                                     Container(
                                       height: size.height * 0.12,  ///-------------change here-------------
                                       decoration: BoxDecoration(
                                           color: AppColors.whiteTextColor,
                                           borderRadius: BorderRadius.circular(size.height * k16TextSize)
                                       ),
                                       child: ListView.builder(
                                         shrinkWrap: true,
                                         itemCount: validKeys.length,
                                         itemBuilder: (context, index) {
                                           String listViewIndex = validKeys.elementAt(index);
                                             log("=====> See Month Map ==> $listViewIndex : ${controller.selectedGridItemsMapString[listViewIndex]?.join(", ")}");

                                           return Padding(
                                               padding: EdgeInsets.only(
                                                 right: size.height * k16TextSize,
                                                 left: size.height * k16TextSize,
                                               ),
                                               child: Text.rich(
                                                 TextSpan(
                                                   children: [
                                                     TextSpan(
                                                         text: '$listViewIndex : ',
                                                         style: TextStyle(
                                                           color: AppColors.primaryColor,
                                                           fontSize: size.height * k18TextSize,
                                                           fontWeight: FontWeight.w600,
                                                           letterSpacing: 0.30,
                                                         )
                                                     ),
                                                     TextSpan(
                                                         text: '${controller.selectedGridItemsMapString[listViewIndex]?.join(", ")}',
                                                         style: TextStyle(
                                                             color: AppColors.primaryTextColor,
                                                             fontSize: size.height * k16TextSize,
                                                             fontWeight: FontWeight.normal
                                                         )
                                                     ),
                                                   ],
                                                 ),
                                               )
                                           );
                                         },
                                       ),
                                     ),
                                   ],
                                 ),
                               );
                             },
                           ) : GetBuilder<AnalysisProYearlyButtonController>(
                                builder: (controller) {
                                  var validKeys = controller.selectedGridItemsMapString.keys.where(
                                          (key) => controller.selectedGridItemsMapString[key]?.isNotEmpty ?? false
                                  ).toList();

                                  return Container(
                                    height: size.height * 0.18,  ///-------------change here-------------
                                    decoration: BoxDecoration(
                                        color: AppColors.whiteTextColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(size.height * k16TextSize)
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                filterBottomSheet(size: size);
                                              },
                                              child: BottomSheetFilterButtonWidget(size: size),
                                            ),
                                            SizedBox(width: size.width > 800 ? size.width * 0.300 : size.width * 0.120),
                                            AnalysisProFilterResult(size: size),
                                          ],
                                        ),
                                        Container(
                                          height: size.height * 0.12,  ///-------------change here-------------
                                          decoration: BoxDecoration(
                                              color: AppColors.whiteTextColor,
                                              borderRadius: BorderRadius.circular(size.height * k16TextSize)
                                          ),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: validKeys.length,
                                            itemBuilder: (context, index) {
                                              String listViewIndex = validKeys.elementAt(index);
                                            //  log("=====> See Year Map ==> $listViewIndex : ${controller.selectedGridItemsMapString[listViewIndex]?.join(", ")}");

                                              return Padding(
                                                  padding: EdgeInsets.only(
                                                    right: size.height * k16TextSize,
                                                    left: size.height * k16TextSize,
                                                  ),
                                                  child: Text.rich(
                                                    TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: '$listViewIndex : ',
                                                            style: TextStyle(
                                                              color: AppColors.primaryColor,
                                                              fontSize: size.height * k18TextSize,
                                                              fontWeight: FontWeight.w600,
                                                              letterSpacing: 0.30,
                                                            )
                                                        ),
                                                        TextSpan(
                                                            text: '${controller.selectedGridItemsMapString[listViewIndex]?.join(", ")}',
                                                            style: TextStyle(
                                                                color: AppColors.primaryTextColor,
                                                                fontSize: size.height * k16TextSize,
                                                                fontWeight: FontWeight.normal
                                                            )
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              SizedBox(height: size.height * 0.02),
                               CustomContainer(
                                    height: size.height * 0.4,
                                    width: double.infinity,
                                    borderRadius: BorderRadius.circular(size.height * k8TextSize),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: size.height * k16TextSize,left: size.height * k16TextSize,right: size.height * k16TextSize,bottom: size.height * k8TextSize, ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(AssetsPath.lineChartIconSVG),
                                              SizedBox(width: size.width * k16TextSize,),
                                              const TextComponent(text: "Power Chart",fontFamily: boldFontFamily,),
                                            ],
                                          ),
                                        ),
                                        const Divider(color: AppColors.containerBorderColor,),
                                        SizedBox(
                                            height: size.height * 0.283,
                                            width: double.infinity,
                                            child: controller.selectedButton == 1 ?  const SplineChartWidget() : controller.selectedButton == 2 ? const MonthlyBarChartWidget() : const YearlyBarChartWidget(),
                                        ),

                                       // DownloadButtonWidget(size: size),
                                      ],
                                    ),
                                ),
                              SizedBox(height: size.height * k20TextSize)
                            ],
                          );
                        }
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ));
  }

  void filterBottomSheet({required Size size}) {
   ScrollController _gridScrollController = ScrollController();
   ScrollController _secondGridScrollController = ScrollController();
   ScrollController _waterGridScrollController = ScrollController();
   ScrollController _waterSecondGridScrollController = ScrollController();
   ScrollController _naturalGasGridScrollController = ScrollController();
   ScrollController _naturalGasSecondGridScrollController = ScrollController();
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.8,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.whiteTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size.height * k16TextSize),
                  topRight: Radius.circular(size.height * k16TextSize),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                   BottomSheetTitleFilterWidget(size: size,),
                  SizedBox(height: size.height * 0.004),
                  TextComponent(
                    text: "Select Chart Components",
                    color: AppColors.primaryColor,
                    fontSize: size.height * k18TextSize,
                    fontFamily: boldFontFamily,
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: size.height * k16TextSize, right: size.height * k16TextSize,bottom: size.height * k16TextSize,top: size.height * k8TextSize, ),
                        child: CustomContainer(
                          height: size.width > 800 ?  size.height * 0.600 : size.height * 0.700,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(size.height * k16TextSize),
                          child:  SingleChildScrollView(
                            child: Padding(
                                    padding: EdgeInsets.all(size.height * k12TextSize),
                                    child: GetBuilder<AnalysisProDayButtonController>(
                                      builder: (analysisProDayButtonController) {
                                        return analysisProDayButtonController.selectedButton == 1 ?
                                        Column(
                                          children: [
                                            DGRExpendableContainerWidget(
                                              firstScrollController: _gridScrollController,
                                              secondScrollController: _secondGridScrollController,
                                              animationController1: _dgrController1,
                                              animationController2: _dgrController2,
                                              animation1: _dgrAnimation1,
                                              animation2: _dgrAnimation2,
                                              analysisProDayButtonController : analysisProDayButtonController,
                                              selectedButton: 1,
                                    ),


                                            (analysisProDayButtonController.dgrDayDataSourceList.isNotEmpty && analysisProDayButtonController.dgrDayDataLoadList.isNotEmpty ) ?   SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
                                            //>----------------------Water-------------------------------
                            
                                            WaterExpendableContainerWidget(
                                              firstScrollController: _waterGridScrollController,
                                              secondScrollController: _waterSecondGridScrollController,
                                              animationController1: _waterController1,
                                              animationController2: _waterController2,
                                              animation1: _waterAnimation1,
                                              animation2: _waterAnimation2,
                                              analysisProDayButtonController: analysisProDayButtonController,
                                            ),

                                            (analysisProDayButtonController.waterDayDataSourceList.isNotEmpty && analysisProDayButtonController.waterDayDataLoadList.isNotEmpty ) ?    SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
                                            //>----------------------Natural Gas-------------------------------

                                            NaturalGasExpendableContainerWidget(
                                              firstScrollController: _naturalGasGridScrollController,
                                              secondScrollController: _naturalGasSecondGridScrollController,
                                              animationController1: _naturalGasController1,
                                              animationController2: _naturalGasController2,
                                              animation1: _naturalGasAnimation1,
                                              animation2: _naturalGasAnimation2,
                                              analysisProDayButtonController: analysisProDayButtonController,
                                            ),

                                          ],
                                        ) : analysisProDayButtonController.selectedButton == 2 ? GetBuilder<AnalysisProMonthlyButtonController>(
                                          builder: (analysisProMonthlyButtonController) {
                                            return Column(
                                              children: [
                                                DGRExpendableContainerWidget(
                                                  firstScrollController: _gridScrollController,
                                                  secondScrollController: _secondGridScrollController,
                                                  animationController1: _dgrController1,
                                                  animationController2: _dgrController2,
                                                  animation1: _dgrAnimation1,
                                                  animation2: _dgrAnimation2,
                                                  analysisProMonthlyButtonController: analysisProMonthlyButtonController,
                                                  selectedButton: 2,
                                                ),


                                                (analysisProMonthlyButtonController.dgrMonthDataSourceList.isNotEmpty && analysisProMonthlyButtonController.dgrMonthDataLoadList.isNotEmpty ) ?   SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
                                                //>----------------------Water-------------------------------

                                                // WaterExpendableContainerWidget(
                                                //   firstScrollController: _waterGridScrollController,
                                                //   secondScrollController: _waterSecondGridScrollController,
                                                //   animationController1: _waterController1,
                                                //   animationController2: _waterController2,
                                                //   animation1: _waterAnimation1,
                                                //   animation2: _waterAnimation2,
                                                //   analysisProMonthlyButtonController: analysisProMonthlyButtonController,
                                                // ),

                                                (analysisProMonthlyButtonController.waterMonthDataSourceList.isNotEmpty && analysisProMonthlyButtonController.waterMonthDataLoadList.isNotEmpty ) ?    SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
                                                //>----------------------Natural Gas-------------------------------

                                                // NaturalGasExpendableContainerWidget(
                                                //   firstScrollController: _naturalGasGridScrollController,
                                                //   secondScrollController: _naturalGasSecondGridScrollController,
                                                //   animationController1: _naturalGasController1,
                                                //   animationController2: _naturalGasController2,
                                                //   animation1: _naturalGasAnimation1,
                                                //   animation2: _naturalGasAnimation2,
                                                //   analysisProMonthlyButtonController: analysisProMonthlyButtonController,
                                                // ),

                                              ],
                                            );
                                          }
                                        ) : GetBuilder<AnalysisProYearlyButtonController>(
                                            builder: (analysisProYearlyButtonController) {
                                              return Column(
                                                children: [
                                                  DGRExpendableContainerWidget(
                                                    firstScrollController: _gridScrollController,
                                                    secondScrollController: _secondGridScrollController,
                                                    animationController1: _dgrController1,
                                                    animationController2: _dgrController2,
                                                    animation1: _dgrAnimation1,
                                                    animation2: _dgrAnimation2,
                                                    analysisProYearlyButtonController: analysisProYearlyButtonController,
                                                    selectedButton: 3,
                                                  ),


                                                  (analysisProYearlyButtonController.dgrYearlyDataSourceList.isNotEmpty && analysisProYearlyButtonController.dgrYearlyDataLoadList.isNotEmpty ) ?   SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
                                                  //>----------------------Water-------------------------------

                                                  // WaterExpendableContainerWidget(
                                                  //   firstScrollController: _waterGridScrollController,
                                                  //   secondScrollController: _waterSecondGridScrollController,
                                                  //   animationController1: _waterController1,
                                                  //   animationController2: _waterController2,
                                                  //   animation1: _waterAnimation1,
                                                  //   animation2: _waterAnimation2,
                                                  //   analysisProYearlyButtonController: analysisProYearlyButtonController,
                                                  // ),

                                                  (analysisProYearlyButtonController.waterYearlyDataSourceList.isNotEmpty && analysisProYearlyButtonController.waterYearlyDataLoadList.isNotEmpty ) ?    SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
                                                  //>----------------------Natural Gas-------------------------------

                                                  // NaturalGasExpendableContainerWidget(
                                                  //   firstScrollController: _naturalGasGridScrollController,
                                                  //   secondScrollController: _naturalGasSecondGridScrollController,
                                                  //   animationController1: _naturalGasController1,
                                                  //   animationController2: _naturalGasController2,
                                                  //   animation1: _naturalGasAnimation1,
                                                  //   animation2: _naturalGasAnimation2,
                                                  //   analysisProYearlyButtonController: analysisProYearlyButtonController,
                                                  // ),

                                                ],
                                              );
                                            }
                                        );
                                      }
                                    )
                                  ),
                             ),

                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: size.height * 0.006,
                        child: GetBuilder<AnalysisProDayButtonController>(
                          builder: (analysisProButtonController) {
                            return GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                                analysisProButtonController.selectedButton == 1 ?
                                Get.find<AnalysisProDayButtonController>().fetchSelectedNodeData(fromDate: analysisProButtonController.fromDateTEController.text, toDate: analysisProButtonController.toDateTEController.text)

                                    :  analysisProButtonController.selectedButton == 2
                                    ? Get.find<AnalysisProMonthlyButtonController>().fetchSelectedNodeData(selectedMonth: Get.find<AnalysisProMonthlyButtonController>().selectedMonth.toString(), selectedYear: Get.find<AnalysisProMonthlyButtonController>().selectedYear.toString())
                                    : Get.find<AnalysisProYearlyButtonController>().fetchSelectedNodeData(selectedYear: Get.find<AnalysisProYearlyButtonController>().selectedYear);

                              },
                              child: Container(
                                height: size.height * 0.050,
                                width: size.width * 0.4,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(size.height * k12TextSize),
                                ),
                                child: Center(
                                  child: TextComponent(
                                    text: "Show Filter Result",
                                    color: AppColors.whiteTextColor,
                                    fontSize: size.height * k18TextSize,
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                      ),
                    ],
                  ),
              ],
              ),
            ),
          );
         },
       );
   }
}

class DGRExpendableContainerWidget extends StatelessWidget {
  const DGRExpendableContainerWidget({
    super.key,
    required this.firstScrollController,
    required this.secondScrollController,

    required this.animationController1,
    required this.animation1,
    required this.animationController2,
    required this.animation2,
    required this.selectedButton,
     this.analysisProDayButtonController,
     this.analysisProMonthlyButtonController,
     this.analysisProYearlyButtonController,

  });

  final ScrollController firstScrollController;
  final ScrollController secondScrollController;

  final AnimationController animationController1;
  final Animation<double> animation1;
  final AnimationController animationController2;
  final Animation<double> animation2;

  final AnalysisProDayButtonController? analysisProDayButtonController;
  final AnalysisProMonthlyButtonController? analysisProMonthlyButtonController;
  final AnalysisProYearlyButtonController? analysisProYearlyButtonController;
  final int selectedButton;


  @override
  Widget build(BuildContext context) {
   log("dgrMonthDataSourceList: ${analysisProMonthlyButtonController?.dgrMonthDataSourceList.length}");
   log("is source is notEmpty: ${analysisProMonthlyButtonController?.dgrMonthDataSourceList.isNotEmpty}");
   log("selectedButton: ${ analysisProDayButtonController?.selectedButton}");
   log("added selectedButton: $selectedButton");
    Size size = MediaQuery.of(context).size;
    return analysisProDayButtonController?.selectedButton == 1 ?  Column(
      children: [
        analysisProDayButtonController!.dgrDayDataSourceList.isNotEmpty ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
           // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              expansionTileTheme: const ExpansionTileThemeData(
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
              ),
            ),
            child:  ExpansionTile(
                    backgroundColor: Colors.transparent,
                    initiallyExpanded: true,
                    showTrailingIcon: false,
                    title:  Row(
                      children: [
                        CustomIconCheckbox(
                          initialValue: analysisProDayButtonController!.checkboxGroupStates['source']?.any((e) => e) ?? true,
                          checkedIcon: AssetsPath.checkboxIconSVG,
                          uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                          onChanged: (bool value) {
                          //  analysisProButtonController.checkboxGroupStates['source'] ??= List.filled(100, true);
                            analysisProDayButtonController!.toggleGroup('source', value);


                            if (value) {
                              for (var item in analysisProDayButtonController!.dgrDayDataSourceList) {
                                analysisProDayButtonController!.selectedGridItemsMapString['Source'] ??= [];
                                analysisProDayButtonController!.selectedGridItemsMapString['Source']!.add(item.node!);

                                analysisProDayButtonController!.removeList.remove(item.node!);
                                analysisProDayButtonController!.itemsList.add(item.node!);
                              }
                            } else {
                              for(var removeItem in analysisProDayButtonController!.dgrDayDataSourceList){
                                analysisProDayButtonController!.removeList.add(removeItem.node!);
                                analysisProDayButtonController!.itemsList.remove(removeItem.node);
                              }
                              analysisProDayButtonController!.selectedGridItemsMapString['Source']?.clear();
                            }

                            analysisProDayButtonController!.update();
                          },
                        ),


                        SizedBox(width: size.width * k30TextSize),
                        TextComponent(
                          text: "Source",
                          color: analysisProDayButtonController!.checkboxGroupStates['source']?.any((e) => e) ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                          fontSize:  size.height * k20TextSize,
                          fontFamily: boldFontFamily,
                        ),
                        const Spacer(),

                        RotationTransition(
                          turns: animation1,
                          child: SvgPicture.asset(
                            AssetsPath.spinArrowIconSVG,
                            height: size.height * k25TextSize,
                          ),
                        ),

                      ],
                    ),
                    children: [
                      // SizedBox(height: size.height * 0.002),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.height * k16TextSize,
                            vertical: 0
                        ),
                        child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: size.height * k16TextSize,
                          right: size.height * k16TextSize,
                          bottom: size.height * k16TextSize,
                          top: size.height * k8TextSize,
                        ),
                        child: Theme(
                          data: ThemeData(
                            highlightColor: AppColors.primaryColor,
                          ),
                          child:  analysisProDayButtonController!.dgrDayDataSourceList.length < 10 ? Card(
                            elevation: 0.0,
                            color: AppColors.whiteTextColor,
                            child: GridView.builder(
                                controller: firstScrollController,
                                primary: false,
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 0,
                                  childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                                ),
                                itemCount: analysisProDayButtonController!.dgrDayDataSourceList.length,
                                itemBuilder: (context, gridIndex) {

                                  return Row(
                                    children: [

                                      CustomIconCheckbox(
                                        initialValue: analysisProDayButtonController!.checkboxGroupStates['source']?[gridIndex] ?? true,
                                        checkedIcon: AssetsPath.checkboxIconSVG,
                                        uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                        onChanged: (bool value) {
                                          analysisProDayButtonController!.checkboxGroupStates['source'] ??= List.filled(1000, true);
                                          analysisProDayButtonController!.checkboxGroupStates['source']![gridIndex] = value;
                                          bool anyChecked = analysisProDayButtonController!.checkboxGroupStates['source']!.any((e) => e);

                                          if (!anyChecked) {
                                            analysisProDayButtonController!.toggleGroup('source', false);
                                          }

                                          analysisProDayButtonController!.updateSelectedGridItems('Source', analysisProDayButtonController!.dgrDayDataSourceList[gridIndex].node!, value);
                                          analysisProDayButtonController!.update();
                                        },
                                      ),

                                      SizedBox(width: size.width * k30TextSize),
                                      SizedBox(
                                        width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                        child: TextComponent(
                                          text: analysisProDayButtonController!.dgrDayDataSourceList[gridIndex].node ??  ' ',
                                          color: analysisProDayButtonController!.checkboxGroupStates['source']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                          fontSize: size.height * k16TextSize,
                                          fontFamily: mediumFontFamily,
                                        ),
                                      ),
                                    ],
                                  );

                                }
                            ),
                          ) :
                          Scrollbar(
                            thumbVisibility: true,
                            controller: firstScrollController,
                            radius: Radius.circular(size.height * k20TextSize),
                            child: SizedBox(
                              height: size.height * 0.2,
                              child: GridView.builder(
                                  controller: firstScrollController,
                                  primary: false,
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 0,
                                    childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                                  ),
                                  itemCount: analysisProDayButtonController!.dgrDayDataSourceList.length,
                                  itemBuilder: (context, gridIndex) {

                                    return Row(
                                      children: [
                                        CustomIconCheckbox(
                                          initialValue: analysisProDayButtonController!.checkboxGroupStates['source']?[gridIndex] ?? true,
                                          checkedIcon: AssetsPath.checkboxIconSVG,
                                          uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                          onChanged: (bool value) {
                                            analysisProDayButtonController!.checkboxGroupStates['source'] ??= List.filled(1000, true);
                                            analysisProDayButtonController!.checkboxGroupStates['source']![gridIndex] = value;
                                            bool anyChecked = analysisProDayButtonController!.checkboxGroupStates['source']!.any((e) => e);

                                            if (!anyChecked) {
                                              analysisProDayButtonController!.toggleGroup('source', false);
                                            }

                                            analysisProDayButtonController!.updateSelectedGridItems('Source', analysisProDayButtonController!.dgrDayDataSourceList[gridIndex].node!, value);
                                            analysisProDayButtonController!.update();
                                          },
                                        ),
                                        SizedBox(width: size.width * k30TextSize),
                                        SizedBox(
                                          width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                          child: TextComponent(
                                            text: analysisProDayButtonController!.dgrDayDataSourceList[gridIndex].node ??  ' ',
                                            color: analysisProDayButtonController!.checkboxGroupStates['source']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                            fontSize: size.height * k16TextSize,
                                            fontFamily: mediumFontFamily,
                                          ),
                                        ),
                                      ],
                                    );

                                  }
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    onExpansionChanged: (bool expanded) {
                      if (expanded) {
                        animationController1.reverse();
                      } else {
                        animationController1.forward();
                      }
                    },
                  )

          ),
        ) : Container(),

//-----------------------------------------------Second-------------------------------
        analysisProDayButtonController!.dgrDayDataSourceList.isNotEmpty ?   SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
        analysisProDayButtonController!.dgrDayDataLoadList.isNotEmpty ?    Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
               showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProDayButtonController!.checkboxGroupStates['load']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProDayButtonController!.checkboxGroupStates['load'] ??= List.filled(1000, true);
                        analysisProDayButtonController!.toggleGroup('load', value);

                        if (value) {
                          for (var item in analysisProDayButtonController!.dgrDayDataLoadList) {
                            analysisProDayButtonController!.selectedGridItemsMapString['Load'] ??= [];
                            analysisProDayButtonController!.selectedGridItemsMapString['Load']!.add(item.node!);

                            analysisProDayButtonController!.removeList.remove(item.node!);
                            analysisProDayButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProDayButtonController!.dgrDayDataLoadList){
                            analysisProDayButtonController!.removeList.add(removeItem.node!);
                            analysisProDayButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProDayButtonController!.selectedGridItemsMapString['Load']?.clear();

                        }
                        analysisProDayButtonController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Load",
                      color:  analysisProDayButtonController!.checkboxGroupStates['load']?.any((e) => e) ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),
                    RotationTransition(
                      turns: animation2,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),
                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(padding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize, vertical: 0),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child: analysisProDayButtonController!.dgrDayDataLoadList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child: GridView.builder(
                            controller: secondScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProDayButtonController!.dgrDayDataLoadList.length,
                            itemBuilder: (context, gridIndex) {
                              //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: analysisProDayButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProDayButtonController!.checkboxGroupStates['load'] ??= List.filled(1000, true);
                                      analysisProDayButtonController!.checkboxGroupStates['load']![gridIndex] = value;
                                      bool anyChecked = analysisProDayButtonController!.checkboxGroupStates['load']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProDayButtonController!.toggleGroup('load', false);
                                      }

                                      analysisProDayButtonController!.updateSelectedGridItems('Load', analysisProDayButtonController!.dgrDayDataLoadList[gridIndex].node!, value);
                                      analysisProDayButtonController!.update();
                                    },
                                  ),
                                  SizedBox(width: size.width * k30TextSize),
                                  SizedBox(
                                    width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                    child: TextComponent(
                                      text: analysisProDayButtonController!.dgrDayDataLoadList[gridIndex].node ??  ' ',
                                      color: analysisProDayButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ),
                                ],
                              );

                            }
                        ),
                      )


                      : Scrollbar(
                        thumbVisibility: true,
                        controller: secondScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: secondScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProDayButtonController!.dgrDayDataLoadList.length,
                              itemBuilder: (context, gridIndex) {
                                //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                                return Row(
                                  children: [

                                    CustomIconCheckbox(
                                      initialValue: analysisProDayButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProDayButtonController!.checkboxGroupStates['load'] ??= List.filled(1000, true);
                                        analysisProDayButtonController!.checkboxGroupStates['load']![gridIndex] = value;
                                        bool anyChecked = analysisProDayButtonController!.checkboxGroupStates['load']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProDayButtonController!.toggleGroup('load', false);
                                        }

                                        analysisProDayButtonController!.updateSelectedGridItems('Load', analysisProDayButtonController!.dgrDayDataLoadList[gridIndex].node!, value);
                                        analysisProDayButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    SizedBox(
                                      width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                      child: TextComponent(
                                        text: analysisProDayButtonController!.dgrDayDataLoadList[gridIndex].node ??  ' ',
                                        color: analysisProDayButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
                                        fontSize: size.height * k16TextSize,
                                        fontFamily: mediumFontFamily,
                                      ),
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController2.reverse();
                  } else {
                    animationController2.forward();
                  }
                },
              )

          ),
        ) : Container(),
      ],
    ) :
           selectedButton == 2 ?



           Column(children: [
        (analysisProMonthlyButtonController != null && analysisProMonthlyButtonController!.dgrMonthDataSourceList.isNotEmpty) ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
           //  color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [

                    CustomIconCheckbox(
                      initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['source']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        //  analysisProButtonController.checkboxGroupStates['source'] ??= List.filled(100, true);
                        analysisProMonthlyButtonController!.toggleGroup('source', value);


                        if (value) {
                          for (var item in analysisProMonthlyButtonController!.dgrMonthDataSourceList) {
                            analysisProMonthlyButtonController!.selectedGridItemsMapString['Source'] ??= [];
                            analysisProMonthlyButtonController!.selectedGridItemsMapString['Source']!.add(item.node!);

                            analysisProMonthlyButtonController!.removeList.remove(item.node!);
                            analysisProMonthlyButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProMonthlyButtonController!.dgrMonthDataSourceList){
                            analysisProMonthlyButtonController!.removeList.add(removeItem.node!);
                            analysisProMonthlyButtonController!.itemsList.remove(removeItem.node);
                          }
                          analysisProMonthlyButtonController!.selectedGridItemsMapString['Source']?.clear();
                        }

                        analysisProMonthlyButtonController!.update();
                      },
                    ),


                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Source",
                      color: analysisProMonthlyButtonController!.checkboxGroupStates['source']?.any((e) => e) ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),

                    RotationTransition(
                      turns: animation1,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),

                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child:  analysisProMonthlyButtonController!.dgrMonthDataSourceList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child: GridView.builder(
                            controller: firstScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProMonthlyButtonController!.dgrMonthDataSourceList.length,
                            itemBuilder: (context, gridIndex) {
                              log("dgrMonthDataSourceList: ${analysisProMonthlyButtonController!.dgrMonthDataSourceList.length}");
                              return Row(
                                children: [

                                  CustomIconCheckbox(
                                    initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['source']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProMonthlyButtonController!.checkboxGroupStates['source'] ??= List.filled(1000, true);
                                      analysisProMonthlyButtonController!.checkboxGroupStates['source']![gridIndex] = value;
                                      bool anyChecked = analysisProMonthlyButtonController!.checkboxGroupStates['source']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProMonthlyButtonController!.toggleGroup('source', false);
                                      }

                                      analysisProMonthlyButtonController!.updateSelectedGridItems('Source', analysisProMonthlyButtonController!.dgrMonthDataSourceList[gridIndex].node!, value);
                                      analysisProMonthlyButtonController!.update();
                                    },
                                  ),

                                  SizedBox(width: size.width * k30TextSize),
                                  SizedBox(
                                    width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                    child: TextComponent(
                                      text: analysisProMonthlyButtonController!.dgrMonthDataSourceList[gridIndex].node ??  ' ',
                                      color: analysisProMonthlyButtonController!.checkboxGroupStates['source']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ),
                                ],
                              );

                            }
                        ),
                      ) :
                      Scrollbar(
                        thumbVisibility: true,
                        controller: firstScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: firstScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProMonthlyButtonController!.dgrMonthDataSourceList.length,
                              itemBuilder: (context, gridIndex) {

                                log("dgrMonthDataSourceList scroll: ${analysisProMonthlyButtonController!.dgrMonthDataSourceList.length}");


                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['source']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProMonthlyButtonController!.checkboxGroupStates['source'] ??= List.filled(1000, true);
                                        analysisProMonthlyButtonController!.checkboxGroupStates['source']![gridIndex] = value;
                                        bool anyChecked = analysisProMonthlyButtonController!.checkboxGroupStates['source']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProMonthlyButtonController!.toggleGroup('source', false);
                                        }

                                        analysisProMonthlyButtonController!.updateSelectedGridItems('Source', analysisProMonthlyButtonController!.dgrMonthDataSourceList[gridIndex].node!, value);
                                        analysisProMonthlyButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    SizedBox(
                                      width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                      child: TextComponent(
                                        text: analysisProMonthlyButtonController!.dgrMonthDataSourceList[gridIndex].node ??  ' ',
                                        color: analysisProMonthlyButtonController!.checkboxGroupStates['source']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                        fontSize: size.height * k16TextSize,
                                        fontFamily: mediumFontFamily,
                                      ),
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController1.reverse();
                  } else {
                    animationController1.forward();
                  }
                },
              )

          ),
        )
            : Container(),

//-----------------------------------------------Second-------------------------------
        analysisProMonthlyButtonController!.dgrMonthDataSourceList.isNotEmpty ?   SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
        analysisProMonthlyButtonController!.dgrMonthDataLoadList.isNotEmpty ?    Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['load']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProMonthlyButtonController!.checkboxGroupStates['load'] ??= List.filled(1000, true);
                        analysisProMonthlyButtonController!.toggleGroup('load', value);

                        if (value) {
                          for (var item in analysisProMonthlyButtonController!.dgrMonthDataLoadList) {
                            analysisProMonthlyButtonController!.selectedGridItemsMapString['Load'] ??= [];
                            analysisProMonthlyButtonController!.selectedGridItemsMapString['Load']!.add(item.node!);

                            analysisProMonthlyButtonController!.removeList.remove(item.node!);
                            analysisProMonthlyButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProMonthlyButtonController!.dgrMonthDataLoadList){
                            analysisProMonthlyButtonController!.removeList.add(removeItem.node!);
                            analysisProMonthlyButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProMonthlyButtonController!.selectedGridItemsMapString['Load']?.clear();

                        }


                        analysisProMonthlyButtonController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Load",
                      color:  analysisProMonthlyButtonController!.checkboxGroupStates['load']?.any((e) => e) ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),
                    RotationTransition(
                      turns: animation2,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),
                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(padding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize, vertical: 0),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child: analysisProMonthlyButtonController!.dgrMonthDataLoadList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child: GridView.builder(
                            controller: secondScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProMonthlyButtonController!.dgrMonthDataLoadList.length,
                            itemBuilder: (context, gridIndex) {
                              //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProMonthlyButtonController!.checkboxGroupStates['load'] ??= List.filled(1000, true);
                                      analysisProMonthlyButtonController!.checkboxGroupStates['load']![gridIndex] = value;
                                      bool anyChecked = analysisProMonthlyButtonController!.checkboxGroupStates['load']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProMonthlyButtonController!.toggleGroup('load', false);
                                      }

                                      analysisProMonthlyButtonController!.updateSelectedGridItems('Load', analysisProMonthlyButtonController!.dgrMonthDataLoadList[gridIndex].node!, value);
                                      analysisProMonthlyButtonController!.update();
                                    },
                                  ),
                                  SizedBox(width: size.width * k30TextSize),
                                  SizedBox(
                                    width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                    child: TextComponent(
                                      text: analysisProMonthlyButtonController!.dgrMonthDataLoadList[gridIndex].node ??  ' ',
                                      color: analysisProMonthlyButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ),
                                ],
                              );

                            }
                        ),
                      )


                          : Scrollbar(
                        thumbVisibility: true,
                        controller: secondScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: secondScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProMonthlyButtonController!.dgrMonthDataLoadList.length,
                              itemBuilder: (context, gridIndex) {
                                //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                                return Row(
                                  children: [

                                    CustomIconCheckbox(
                                      initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProMonthlyButtonController!.checkboxGroupStates['load'] ??= List.filled(1000, true);
                                        analysisProMonthlyButtonController!.checkboxGroupStates['load']![gridIndex] = value;
                                        bool anyChecked = analysisProMonthlyButtonController!.checkboxGroupStates['load']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProMonthlyButtonController!.toggleGroup('load', false);
                                        }

                                        analysisProMonthlyButtonController!.updateSelectedGridItems('Load', analysisProMonthlyButtonController!.dgrMonthDataLoadList[gridIndex].node!, value);
                                        analysisProMonthlyButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    SizedBox(
                                      width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                      child: TextComponent(
                                        text: analysisProMonthlyButtonController!.dgrMonthDataLoadList[gridIndex].node ??  ' ',
                                        color: analysisProMonthlyButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
                                        fontSize: size.height * k16TextSize,
                                        fontFamily: mediumFontFamily,
                                      ),
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController2.reverse();
                  } else {
                    animationController2.forward();
                  }
                },
              )

          ),
        ) : Container(),
      ]) : Column(children: [
             (analysisProYearlyButtonController != null && analysisProYearlyButtonController!.dgrYearlyDataSourceList.isNotEmpty)  ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [

                    CustomIconCheckbox(
                      initialValue: analysisProYearlyButtonController!.checkboxGroupStates['source']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        //  analysisProButtonController.checkboxGroupStates['source'] ??= List.filled(100, true);
                        analysisProYearlyButtonController!.toggleGroup('source', value);


                        if (value) {
                          for (var item in analysisProYearlyButtonController!.dgrYearlyDataSourceList) {
                            analysisProYearlyButtonController!.selectedGridItemsMapString['Source'] ??= [];
                            analysisProYearlyButtonController!.selectedGridItemsMapString['Source']!.add(item.node!);

                            analysisProYearlyButtonController!.removeList.remove(item.node!);
                            analysisProYearlyButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProYearlyButtonController!.dgrYearlyDataSourceList){
                            analysisProYearlyButtonController!.removeList.add(removeItem.node!);
                            analysisProYearlyButtonController!.itemsList.remove(removeItem.node);
                          }
                          analysisProYearlyButtonController!.selectedGridItemsMapString['Source']?.clear();
                        }

                        analysisProYearlyButtonController!.update();
                      },
                    ),


                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Source",
                      color: analysisProYearlyButtonController!.checkboxGroupStates['source']?.any((e) => e) ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),

                    RotationTransition(
                      turns: animation1,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),

                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child:  analysisProYearlyButtonController!.dgrYearlyDataSourceList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child: GridView.builder(
                            controller: firstScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProYearlyButtonController!.dgrYearlyDataSourceList.length,
                            itemBuilder: (context, gridIndex) {

                              return Row(
                                children: [

                                  CustomIconCheckbox(
                                    initialValue: analysisProYearlyButtonController!.checkboxGroupStates['source']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProYearlyButtonController!.checkboxGroupStates['source'] ??= List.filled(1000, true);
                                      analysisProYearlyButtonController!.checkboxGroupStates['source']![gridIndex] = value;
                                      bool anyChecked = analysisProYearlyButtonController!.checkboxGroupStates['source']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProYearlyButtonController!.toggleGroup('source', false);
                                      }

                                      analysisProYearlyButtonController!.updateSelectedGridItems('Source', analysisProYearlyButtonController!.dgrYearlyDataSourceList[gridIndex].node!, value);
                                      analysisProYearlyButtonController!.update();
                                    },
                                  ),

                                  SizedBox(width: size.width * k30TextSize),
                                  SizedBox(
                                    width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                    child: TextComponent(
                                      text: analysisProYearlyButtonController!.dgrYearlyDataSourceList[gridIndex].node ??  ' ',
                                      color: analysisProYearlyButtonController!.checkboxGroupStates['source']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ),
                                ],
                              );

                            }
                        ),
                      ) :
                      Scrollbar(
                        thumbVisibility: true,
                        controller: firstScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: firstScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProYearlyButtonController!.dgrYearlyDataSourceList.length,
                              itemBuilder: (context, gridIndex) {

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProYearlyButtonController!.checkboxGroupStates['source']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProYearlyButtonController!.checkboxGroupStates['source'] ??= List.filled(1000, true);
                                        analysisProYearlyButtonController!.checkboxGroupStates['source']![gridIndex] = value;
                                        bool anyChecked = analysisProYearlyButtonController!.checkboxGroupStates['source']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProYearlyButtonController!.toggleGroup('source', false);
                                        }

                                        analysisProYearlyButtonController!.updateSelectedGridItems('Source', analysisProYearlyButtonController!.dgrYearlyDataSourceList[gridIndex].node!, value);
                                        analysisProYearlyButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    SizedBox(
                                      width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                      child: TextComponent(
                                        text: analysisProYearlyButtonController!.dgrYearlyDataSourceList[gridIndex].node ??  ' ',
                                        color: analysisProYearlyButtonController!.checkboxGroupStates['source']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                        fontSize: size.height * k16TextSize,
                                        fontFamily: mediumFontFamily,
                                      ),
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController1.reverse();
                  } else {
                    animationController1.forward();
                  }
                },
              )

          ),
        ) : Container(),

//-----------------------------------------------Yearly Second-------------------------------
             (analysisProYearlyButtonController != null && analysisProYearlyButtonController!.dgrYearlyDataSourceList.isNotEmpty )?   SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
             (analysisProYearlyButtonController!= null && analysisProYearlyButtonController!.dgrYearlyDataLoadList.isNotEmpty )?    Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProYearlyButtonController!.checkboxGroupStates['load']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProYearlyButtonController!.checkboxGroupStates['load'] ??= List.filled(1000, true);
                        analysisProYearlyButtonController!.toggleGroup('load', value);

                        if (value) {
                          for (var item in analysisProYearlyButtonController!.dgrYearlyDataLoadList) {
                            analysisProYearlyButtonController!.selectedGridItemsMapString['Load'] ??= [];
                            analysisProYearlyButtonController!.selectedGridItemsMapString['Load']!.add(item.node!);

                            analysisProYearlyButtonController!.removeList.remove(item.node!);
                            analysisProYearlyButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProYearlyButtonController!.dgrYearlyDataLoadList){
                            analysisProYearlyButtonController!.removeList.add(removeItem.node!);
                            analysisProYearlyButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProYearlyButtonController!.selectedGridItemsMapString['Load']?.clear();

                        }


                        analysisProYearlyButtonController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Load",
                      color:  analysisProYearlyButtonController!.checkboxGroupStates['load']?.any((e) => e) ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),
                    RotationTransition(
                      turns: animation2,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),
                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(padding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize, vertical: 0),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child: analysisProYearlyButtonController!.dgrYearlyDataLoadList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child: GridView.builder(
                            controller: secondScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProYearlyButtonController!.dgrYearlyDataLoadList.length,
                            itemBuilder: (context, gridIndex) {
                              //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: analysisProYearlyButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProYearlyButtonController!.checkboxGroupStates['load'] ??= List.filled(1000, true);
                                      analysisProYearlyButtonController!.checkboxGroupStates['load']![gridIndex] = value;
                                      bool anyChecked = analysisProYearlyButtonController!.checkboxGroupStates['load']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProYearlyButtonController!.toggleGroup('load', false);
                                      }

                                      analysisProYearlyButtonController!.updateSelectedGridItems('Load', analysisProYearlyButtonController!.dgrYearlyDataLoadList[gridIndex].node!, value);
                                      analysisProYearlyButtonController!.update();
                                    },
                                  ),
                                  SizedBox(width: size.width * k30TextSize),
                                  SizedBox(
                                    width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                    child: TextComponent(
                                      text: analysisProYearlyButtonController!.dgrYearlyDataLoadList[gridIndex].node ??  ' ',
                                      color: analysisProYearlyButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ),
                                ],
                              );

                            }
                        ),
                      )


                          : Scrollbar(
                        thumbVisibility: true,
                        controller: secondScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: secondScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProYearlyButtonController!.dgrYearlyDataLoadList.length,
                              itemBuilder: (context, gridIndex) {
                                //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                                return Row(
                                  children: [

                                    CustomIconCheckbox(
                                      initialValue: analysisProYearlyButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProYearlyButtonController!.checkboxGroupStates['load'] ??= List.filled(1000, true);
                                        analysisProYearlyButtonController!.checkboxGroupStates['load']![gridIndex] = value;
                                        bool anyChecked = analysisProYearlyButtonController!.checkboxGroupStates['load']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProYearlyButtonController!.toggleGroup('load', false);
                                        }

                                        analysisProYearlyButtonController!.updateSelectedGridItems('Load', analysisProYearlyButtonController!.dgrYearlyDataLoadList[gridIndex].node!, value);
                                        analysisProYearlyButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    SizedBox(
                                      width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                      child: TextComponent(
                                        text: analysisProYearlyButtonController!.dgrYearlyDataLoadList[gridIndex].node ??  ' ',
                                        color: analysisProYearlyButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
                                        fontSize: size.height * k16TextSize,
                                        fontFamily: mediumFontFamily,
                                      ),
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController2.reverse();
                  } else {
                    animationController2.forward();
                  }
                },
              )

          ),
        ) : Container(),
      ]) ;
  }
}

class WaterExpendableContainerWidget extends StatelessWidget {
  const WaterExpendableContainerWidget({
    super.key,
    required this.firstScrollController,
    required this.secondScrollController,

    required this.animationController1,
    required this.animation1,
    required this.animationController2,
    required this.animation2,

     this.analysisProDayButtonController,
     this.analysisProMonthlyButtonController,
     this.analysisProYearlyButtonController,
  });

  final ScrollController firstScrollController;
  final ScrollController secondScrollController;

  final AnimationController animationController1;
  final Animation<double> animation1;
  final AnimationController animationController2;
  final Animation<double> animation2;

  final AnalysisProDayButtonController? analysisProDayButtonController;
  final AnalysisProMonthlyButtonController? analysisProMonthlyButtonController;
  final AnalysisProYearlyButtonController? analysisProYearlyButtonController;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return analysisProDayButtonController?.selectedButton == 1 ? Column(
      children: [
        analysisProDayButtonController!.waterDayDataSourceList.isNotEmpty ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProDayButtonController!.checkboxGroupStates['waterSource']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProDayButtonController!.checkboxGroupStates['waterSource'] ??= List.filled(1000, true);
                        analysisProDayButtonController!.toggleGroup('waterSource', value);

                        if (value) {
                          for (var item in analysisProDayButtonController!.waterDayDataSourceList) {
                            analysisProDayButtonController!.selectedGridItemsMapString['Water Source'] ??= [];
                            analysisProDayButtonController!.selectedGridItemsMapString['Water Source']!.add(item.node!);


                            analysisProDayButtonController!.removeList.remove(item.node!);
                            analysisProDayButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProDayButtonController!.waterDayDataSourceList){
                            analysisProDayButtonController!.removeList.add(removeItem.node!);
                            analysisProDayButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProDayButtonController!.selectedGridItemsMapString['Water Source']?.clear();

                        }

                        analysisProDayButtonController!.update();
                      },
                    ),


                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Water Source",
                      color: analysisProDayButtonController!.checkboxGroupStates['waterSource']?.any((e) => e) ?? true ? AppColors.primaryColor :   AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),

                    RotationTransition(
                      turns: animation1,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),

                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child:  analysisProDayButtonController!.waterDayDataSourceList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child: GridView.builder(
                            controller: firstScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProDayButtonController!.waterDayDataSourceList.length,
                            itemBuilder: (context, gridIndex) {

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: analysisProDayButtonController!.checkboxGroupStates['waterSource']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProDayButtonController!.checkboxGroupStates['waterSource'] ??= List.filled(1000, true);
                                      analysisProDayButtonController!.checkboxGroupStates['waterSource']![gridIndex] = value;
                                      bool anyChecked = analysisProDayButtonController!.checkboxGroupStates['waterSource']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProDayButtonController!.toggleGroup('waterSource', false);
                                      }

                                      analysisProDayButtonController!.updateSelectedGridItems('Water Source', analysisProDayButtonController!.waterDayDataSourceList[gridIndex].node!, value);
                                      analysisProDayButtonController!.update();
                                    },
                                  ),
                                  SizedBox(width: size.width * k30TextSize),
                                  TextComponent(
                                    text: analysisProDayButtonController!.waterDayDataSourceList[gridIndex].node ??  ' ',
                                    color: analysisProDayButtonController!.checkboxGroupStates['waterSource']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                    fontSize: size.height * k16TextSize,
                                    fontFamily: mediumFontFamily,
                                  ),
                                ],
                              );

                            }
                        ),
                      )

                      : Scrollbar(
                        thumbVisibility: true,
                        controller: firstScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: firstScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProDayButtonController!.waterDayDataSourceList.length,
                              itemBuilder: (context, gridIndex) {

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProDayButtonController!.checkboxGroupStates['waterSource']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProDayButtonController!.checkboxGroupStates['waterSource'] ??= List.filled(1000, true);
                                        analysisProDayButtonController!.checkboxGroupStates['waterSource']![gridIndex] = value;
                                        bool anyChecked = analysisProDayButtonController!.checkboxGroupStates['waterSource']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProDayButtonController!.toggleGroup('waterSource', false);
                                        }

                                        analysisProDayButtonController!.updateSelectedGridItems('Water Source', analysisProDayButtonController!.waterDayDataSourceList[gridIndex].node!, value);
                                        analysisProDayButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    TextComponent(
                                      text: analysisProDayButtonController!.waterDayDataSourceList[gridIndex].node ??  ' ',
                                      color: analysisProDayButtonController!.checkboxGroupStates['waterSource']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController1.reverse();
                  } else {
                    animationController1.forward();
                  }
                },
              )

          ),
        ) : Container(),

//-----------------------------------------------Second-------------------------------
        analysisProDayButtonController!.waterDayDataSourceList.isNotEmpty ? SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
        analysisProDayButtonController!.waterDayDataLoadList.isNotEmpty ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProDayButtonController!.checkboxGroupStates['waterLoad']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProDayButtonController!.checkboxGroupStates['waterLoad'] ??= List.filled(1000, true);
                        analysisProDayButtonController!.toggleGroup('waterLoad', value);


                        if (value) {
                          for (var item in analysisProDayButtonController!.waterDayDataLoadList) {
                            analysisProDayButtonController!.selectedGridItemsMapString['Water Load'] ??= [];
                            analysisProDayButtonController!.selectedGridItemsMapString['Water Load']!.add(item.node!);

                            analysisProDayButtonController!.removeList.remove(item.node!);
                            analysisProDayButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProDayButtonController!.waterDayDataLoadList){
                            analysisProDayButtonController!.removeList.add(removeItem.node!);
                            analysisProDayButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProDayButtonController!.selectedGridItemsMapString['Water Load']?.clear();

                        }

                        analysisProDayButtonController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Water Load",
                      color: analysisProDayButtonController!.checkboxGroupStates['waterLoad']?.any((e) => e) ?? true ? AppColors.primaryColor :   AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),
                    RotationTransition(
                      turns: animation2,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),
                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child: analysisProDayButtonController!.waterDayDataLoadList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child: GridView.builder(
                            controller: secondScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProDayButtonController!.waterDayDataLoadList.length,
                            itemBuilder: (context, gridIndex) {
                              //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                              return Row(
                                children: [

                                  CustomIconCheckbox(
                                    initialValue: analysisProDayButtonController!.checkboxGroupStates['waterLoad']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProDayButtonController!.checkboxGroupStates['waterLoad'] ??= List.filled(1000, true);
                                      analysisProDayButtonController!.checkboxGroupStates['waterLoad']![gridIndex] = value;
                                      bool anyChecked = analysisProDayButtonController!.checkboxGroupStates['waterLoad']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProDayButtonController!.toggleGroup('waterLoad', false);
                                      }

                                      analysisProDayButtonController!.updateSelectedGridItems('Water Load', analysisProDayButtonController!.waterDayDataLoadList[gridIndex].node!, value);
                                      analysisProDayButtonController!.update();
                                    },
                                  ),


                                  SizedBox(width: size.width * k30TextSize),
                                  TextComponent(
                                    text: analysisProDayButtonController!.waterDayDataLoadList[gridIndex].node ??  ' ',
                                    color: analysisProDayButtonController!.checkboxGroupStates['waterLoad']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                    fontSize: size.height * k16TextSize,
                                    fontFamily: mediumFontFamily,
                                  ),
                                ],
                              );

                            }
                        ),
                      )


                      : Scrollbar(
                        thumbVisibility: true,
                        controller: secondScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: secondScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProDayButtonController!.waterDayDataLoadList.length,
                              itemBuilder: (context, gridIndex) {
                                //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProDayButtonController!.checkboxGroupStates['waterLoad']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProDayButtonController!.checkboxGroupStates['waterLoad'] ??= List.filled(1000, true);
                                        analysisProDayButtonController!.checkboxGroupStates['waterLoad']![gridIndex] = value;
                                        bool anyChecked = analysisProDayButtonController!.checkboxGroupStates['waterLoad']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProDayButtonController!.toggleGroup('waterLoad', false);
                                        }

                                        analysisProDayButtonController!.updateSelectedGridItems('Water Load', analysisProDayButtonController!.waterDayDataLoadList[gridIndex].node!, value);
                                        analysisProDayButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    TextComponent(
                                      text: analysisProDayButtonController!.waterDayDataLoadList[gridIndex].node ??  ' ',
                                      color: analysisProDayButtonController!.checkboxGroupStates['waterLoad']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController2.reverse();
                  } else {
                    animationController2.forward();
                  }
                },
              )

          ),
        ) : Container(),
      ],
    ) : analysisProDayButtonController?.selectedButton == 2 ?
    Column(
      children: [
        analysisProMonthlyButtonController!.waterMonthDataSourceList.isNotEmpty ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['waterSource']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProMonthlyButtonController!.checkboxGroupStates['waterSource'] ??= List.filled(1000, true);
                        analysisProMonthlyButtonController!.toggleGroup('waterSource', value);

                        if (value) {
                          for (var item in analysisProMonthlyButtonController!.waterMonthDataSourceList) {
                            analysisProMonthlyButtonController!.selectedGridItemsMapString['Water Source'] ??= [];
                            analysisProMonthlyButtonController!.selectedGridItemsMapString['Water Source']!.add(item.node!);


                            analysisProMonthlyButtonController!.removeList.remove(item.node!);
                            analysisProMonthlyButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProMonthlyButtonController!.waterMonthDataSourceList){
                            analysisProMonthlyButtonController!.removeList.add(removeItem.node!);
                            analysisProMonthlyButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProMonthlyButtonController!.selectedGridItemsMapString['Water Source']?.clear();

                        }

                        analysisProMonthlyButtonController!.update();
                      },
                    ),


                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Water Source",
                      color: analysisProMonthlyButtonController!.checkboxGroupStates['waterSource']?.any((e) => e) ?? true ? AppColors.primaryColor :   AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),

                    RotationTransition(
                      turns: animation1,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),

                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child:  analysisProMonthlyButtonController!.waterMonthDataSourceList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child: GridView.builder(
                            controller: firstScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProMonthlyButtonController!.waterMonthDataSourceList.length,
                            itemBuilder: (context, gridIndex) {

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['waterSource']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProMonthlyButtonController!.checkboxGroupStates['waterSource'] ??= List.filled(1000, true);
                                      analysisProMonthlyButtonController!.checkboxGroupStates['waterSource']![gridIndex] = value;
                                      bool anyChecked = analysisProMonthlyButtonController!.checkboxGroupStates['waterSource']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProMonthlyButtonController!.toggleGroup('waterSource', false);
                                      }

                                      analysisProMonthlyButtonController!.updateSelectedGridItems('Water Source', analysisProMonthlyButtonController!.waterMonthDataSourceList[gridIndex].node!, value);
                                      analysisProMonthlyButtonController!.update();
                                    },
                                  ),
                                  SizedBox(width: size.width * k30TextSize),
                                  TextComponent(
                                    text: analysisProMonthlyButtonController!.waterMonthDataSourceList[gridIndex].node ??  ' ',
                                    color: analysisProMonthlyButtonController!.checkboxGroupStates['waterSource']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                    fontSize: size.height * k16TextSize,
                                    fontFamily: mediumFontFamily,
                                  ),
                                ],
                              );

                            }
                        ),
                      )

                          : Scrollbar(
                        thumbVisibility: true,
                        controller: firstScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: firstScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProMonthlyButtonController!.waterMonthDataSourceList.length,
                              itemBuilder: (context, gridIndex) {

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['waterSource']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProMonthlyButtonController!.checkboxGroupStates['waterSource'] ??= List.filled(1000, true);
                                        analysisProMonthlyButtonController!.checkboxGroupStates['waterSource']![gridIndex] = value;
                                        bool anyChecked = analysisProMonthlyButtonController!.checkboxGroupStates['waterSource']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProMonthlyButtonController!.toggleGroup('waterSource', false);
                                        }

                                        analysisProMonthlyButtonController!.updateSelectedGridItems('Water Source', analysisProMonthlyButtonController!.waterMonthDataSourceList[gridIndex].node!, value);
                                        analysisProMonthlyButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    TextComponent(
                                      text: analysisProMonthlyButtonController!.waterMonthDataSourceList[gridIndex].node ??  ' ',
                                      color: analysisProMonthlyButtonController!.checkboxGroupStates['waterSource']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController1.reverse();
                  } else {
                    animationController1.forward();
                  }
                },
              )

          ),
        ) : Container(),

//-----------------------------------------------Second-------------------------------
        analysisProMonthlyButtonController!.waterMonthDataSourceList.isNotEmpty ? SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
        analysisProMonthlyButtonController!.waterMonthDataLoadList.isNotEmpty ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['waterLoad']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProMonthlyButtonController!.checkboxGroupStates['waterLoad'] ??= List.filled(1000, true);
                        analysisProMonthlyButtonController!.toggleGroup('waterLoad', value);


                        if (value) {
                          for (var item in analysisProMonthlyButtonController!.waterMonthDataLoadList) {
                            analysisProMonthlyButtonController!.selectedGridItemsMapString['Water Load'] ??= [];
                            analysisProMonthlyButtonController!.selectedGridItemsMapString['Water Load']!.add(item.node!);

                            analysisProMonthlyButtonController!.removeList.remove(item.node!);
                            analysisProMonthlyButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProMonthlyButtonController!.waterMonthDataLoadList){
                            analysisProMonthlyButtonController!.removeList.add(removeItem.node!);
                            analysisProMonthlyButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProMonthlyButtonController!.selectedGridItemsMapString['Water Load']?.clear();

                        }

                        analysisProMonthlyButtonController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Water Load",
                      color: analysisProMonthlyButtonController!.checkboxGroupStates['waterLoad']?.any((e) => e) ?? true ? AppColors.primaryColor :   AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),
                    RotationTransition(
                      turns: animation2,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),
                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child: analysisProMonthlyButtonController!.waterMonthDataLoadList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child: GridView.builder(
                            controller: secondScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProMonthlyButtonController!.waterMonthDataLoadList.length,
                            itemBuilder: (context, gridIndex) {
                              //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                              return Row(
                                children: [

                                  CustomIconCheckbox(
                                    initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['waterLoad']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProMonthlyButtonController!.checkboxGroupStates['waterLoad'] ??= List.filled(1000, true);
                                      analysisProMonthlyButtonController!.checkboxGroupStates['waterLoad']![gridIndex] = value;
                                      bool anyChecked = analysisProMonthlyButtonController!.checkboxGroupStates['waterLoad']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProMonthlyButtonController!.toggleGroup('waterLoad', false);
                                      }

                                      analysisProMonthlyButtonController!.updateSelectedGridItems('Water Load', analysisProMonthlyButtonController!.waterMonthDataLoadList[gridIndex].node!, value);
                                      analysisProMonthlyButtonController!.update();
                                    },
                                  ),


                                  SizedBox(width: size.width * k30TextSize),
                                  TextComponent(
                                    text: analysisProMonthlyButtonController!.waterMonthDataLoadList[gridIndex].node ??  ' ',
                                    color: analysisProMonthlyButtonController!.checkboxGroupStates['waterLoad']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                    fontSize: size.height * k16TextSize,
                                    fontFamily: mediumFontFamily,
                                  ),
                                ],
                              );

                            }
                        ),
                      )


                          : Scrollbar(
                        thumbVisibility: true,
                        controller: secondScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: secondScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProMonthlyButtonController!.waterMonthDataLoadList.length,
                              itemBuilder: (context, gridIndex) {
                                //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['waterLoad']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProMonthlyButtonController!.checkboxGroupStates['waterLoad'] ??= List.filled(1000, true);
                                        analysisProMonthlyButtonController!.checkboxGroupStates['waterLoad']![gridIndex] = value;
                                        bool anyChecked = analysisProMonthlyButtonController!.checkboxGroupStates['waterLoad']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProMonthlyButtonController!.toggleGroup('waterLoad', false);
                                        }

                                        analysisProMonthlyButtonController!.updateSelectedGridItems('Water Load', analysisProMonthlyButtonController!.waterMonthDataLoadList[gridIndex].node!, value);
                                        analysisProMonthlyButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    TextComponent(
                                      text: analysisProMonthlyButtonController!.waterMonthDataLoadList[gridIndex].node ??  ' ',
                                      color: analysisProMonthlyButtonController!.checkboxGroupStates['waterLoad']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController2.reverse();
                  } else {
                    animationController2.forward();
                  }
                },
              )

          ),
        ) : Container(),
      ],
    ) :  Column(
      children: [
        analysisProYearlyButtonController!.waterYearlyDataSourceList.isNotEmpty ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProYearlyButtonController!.checkboxGroupStates['waterSource']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProYearlyButtonController!.checkboxGroupStates['waterSource'] ??= List.filled(1000, true);
                        analysisProYearlyButtonController!.toggleGroup('waterSource', value);

                        if (value) {
                          for (var item in analysisProYearlyButtonController!.waterYearlyDataSourceList) {
                            analysisProYearlyButtonController!.selectedGridItemsMapString['Water Source'] ??= [];
                            analysisProYearlyButtonController!.selectedGridItemsMapString['Water Source']!.add(item.node!);


                            analysisProYearlyButtonController!.removeList.remove(item.node!);
                            analysisProYearlyButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProYearlyButtonController!.waterYearlyDataSourceList){
                            analysisProYearlyButtonController!.removeList.add(removeItem.node!);
                            analysisProYearlyButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProYearlyButtonController!.selectedGridItemsMapString['Water Source']?.clear();

                        }

                        analysisProYearlyButtonController!.update();
                      },
                    ),


                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Water Source",
                      color: analysisProYearlyButtonController!.checkboxGroupStates['waterSource']?.any((e) => e) ?? true ? AppColors.primaryColor :   AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),

                    RotationTransition(
                      turns: animation1,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),

                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child:  analysisProYearlyButtonController!.waterYearlyDataSourceList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child: GridView.builder(
                            controller: firstScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProYearlyButtonController!.waterYearlyDataSourceList.length,
                            itemBuilder: (context, gridIndex) {

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: analysisProYearlyButtonController!.checkboxGroupStates['waterSource']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProYearlyButtonController!.checkboxGroupStates['waterSource'] ??= List.filled(1000, true);
                                      analysisProYearlyButtonController!.checkboxGroupStates['waterSource']![gridIndex] = value;
                                      bool anyChecked = analysisProYearlyButtonController!.checkboxGroupStates['waterSource']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProYearlyButtonController!.toggleGroup('waterSource', false);
                                      }

                                      analysisProYearlyButtonController!.updateSelectedGridItems('Water Source', analysisProYearlyButtonController!.waterYearlyDataSourceList[gridIndex].node!, value);
                                      analysisProYearlyButtonController!.update();
                                    },
                                  ),
                                  SizedBox(width: size.width * k30TextSize),
                                  TextComponent(
                                    text: analysisProYearlyButtonController!.waterYearlyDataSourceList[gridIndex].node ??  ' ',
                                    color: analysisProYearlyButtonController!.checkboxGroupStates['waterSource']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                    fontSize: size.height * k16TextSize,
                                    fontFamily: mediumFontFamily,
                                  ),
                                ],
                              );

                            }
                        ),
                      )

                          : Scrollbar(
                        thumbVisibility: true,
                        controller: firstScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: firstScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProYearlyButtonController!.waterYearlyDataSourceList.length,
                              itemBuilder: (context, gridIndex) {

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProYearlyButtonController!.checkboxGroupStates['waterSource']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProYearlyButtonController!.checkboxGroupStates['waterSource'] ??= List.filled(1000, true);
                                        analysisProYearlyButtonController!.checkboxGroupStates['waterSource']![gridIndex] = value;
                                        bool anyChecked = analysisProYearlyButtonController!.checkboxGroupStates['waterSource']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProYearlyButtonController!.toggleGroup('waterSource', false);
                                        }

                                        analysisProYearlyButtonController!.updateSelectedGridItems('Water Source', analysisProYearlyButtonController!.waterYearlyDataSourceList[gridIndex].node!, value);
                                        analysisProYearlyButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    TextComponent(
                                      text: analysisProYearlyButtonController!.waterYearlyDataSourceList[gridIndex].node ??  ' ',
                                      color: analysisProYearlyButtonController!.checkboxGroupStates['waterSource']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController1.reverse();
                  } else {
                    animationController1.forward();
                  }
                },
              )

          ),
        ) : Container(),

//-----------------------------------------------Second-------------------------------
        analysisProYearlyButtonController!.waterYearlyDataSourceList.isNotEmpty ? SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
        analysisProYearlyButtonController!.waterYearlyDataLoadList.isNotEmpty ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProYearlyButtonController!.checkboxGroupStates['waterLoad']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProYearlyButtonController!.checkboxGroupStates['waterLoad'] ??= List.filled(1000, true);
                        analysisProYearlyButtonController!.toggleGroup('waterLoad', value);


                        if (value) {
                          for (var item in analysisProYearlyButtonController!.waterYearlyDataLoadList) {
                            analysisProYearlyButtonController!.selectedGridItemsMapString['Water Load'] ??= [];
                            analysisProYearlyButtonController!.selectedGridItemsMapString['Water Load']!.add(item.node!);

                            analysisProYearlyButtonController!.removeList.remove(item.node!);
                            analysisProYearlyButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProYearlyButtonController!.waterYearlyDataLoadList){
                            analysisProYearlyButtonController!.removeList.add(removeItem.node!);
                            analysisProYearlyButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProYearlyButtonController!.selectedGridItemsMapString['Water Load']?.clear();

                        }

                        analysisProYearlyButtonController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Water Load",
                      color: analysisProYearlyButtonController!.checkboxGroupStates['waterLoad']?.any((e) => e) ?? true ? AppColors.primaryColor :   AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),
                    RotationTransition(
                      turns: animation2,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),
                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child: analysisProYearlyButtonController!.waterYearlyDataLoadList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child: GridView.builder(
                            controller: secondScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProYearlyButtonController!.waterYearlyDataLoadList.length,
                            itemBuilder: (context, gridIndex) {
                              //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                              return Row(
                                children: [

                                  CustomIconCheckbox(
                                    initialValue: analysisProYearlyButtonController!.checkboxGroupStates['waterLoad']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProYearlyButtonController!.checkboxGroupStates['waterLoad'] ??= List.filled(1000, true);
                                      analysisProYearlyButtonController!.checkboxGroupStates['waterLoad']![gridIndex] = value;
                                      bool anyChecked = analysisProYearlyButtonController!.checkboxGroupStates['waterLoad']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProYearlyButtonController!.toggleGroup('waterLoad', false);
                                      }

                                      analysisProYearlyButtonController!.updateSelectedGridItems('Water Load', analysisProYearlyButtonController!.waterYearlyDataLoadList[gridIndex].node!, value);
                                      analysisProYearlyButtonController!.update();
                                    },
                                  ),


                                  SizedBox(width: size.width * k30TextSize),
                                  TextComponent(
                                    text: analysisProYearlyButtonController!.waterYearlyDataLoadList[gridIndex].node ??  ' ',
                                    color: analysisProYearlyButtonController!.checkboxGroupStates['waterLoad']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                    fontSize: size.height * k16TextSize,
                                    fontFamily: mediumFontFamily,
                                  ),
                                ],
                              );

                            }
                        ),
                      )


                          : Scrollbar(
                        thumbVisibility: true,
                        controller: secondScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: secondScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProYearlyButtonController!.waterYearlyDataLoadList.length,
                              itemBuilder: (context, gridIndex) {
                                //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProYearlyButtonController!.checkboxGroupStates['waterLoad']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProYearlyButtonController!.checkboxGroupStates['waterLoad'] ??= List.filled(1000, true);
                                        analysisProYearlyButtonController!.checkboxGroupStates['waterLoad']![gridIndex] = value;
                                        bool anyChecked = analysisProYearlyButtonController!.checkboxGroupStates['waterLoad']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProYearlyButtonController!.toggleGroup('waterLoad', false);
                                        }

                                        analysisProYearlyButtonController!.updateSelectedGridItems('Water Load', analysisProYearlyButtonController!.waterYearlyDataLoadList[gridIndex].node!, value);
                                        analysisProYearlyButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    TextComponent(
                                      text: analysisProYearlyButtonController!.waterYearlyDataLoadList[gridIndex].node ??  ' ',
                                      color: analysisProYearlyButtonController!.checkboxGroupStates['waterLoad']?[gridIndex] ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController2.reverse();
                  } else {
                    animationController2.forward();
                  }
                },
              )

          ),
        ) : Container(),
      ],
    );
  }
}

class NaturalGasExpendableContainerWidget extends StatelessWidget {
  const NaturalGasExpendableContainerWidget({
    super.key,
    required this.firstScrollController,
    required this.secondScrollController,

    required this.animationController1,
    required this.animation1,
    required this.animationController2,
    required this.animation2,

     this.analysisProDayButtonController,
     this.analysisProMonthlyButtonController,
     this.analysisProYearlyButtonController,
  });

  final ScrollController firstScrollController;
  final ScrollController secondScrollController;

  final AnimationController animationController1;
  final Animation<double> animation1;
  final AnimationController animationController2;
  final Animation<double> animation2;

  final AnalysisProDayButtonController? analysisProDayButtonController;
  final AnalysisProMonthlyButtonController? analysisProMonthlyButtonController;
  final AnalysisProYearlyButtonController? analysisProYearlyButtonController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return analysisProDayButtonController?.selectedButton ==1 ? Column(
      children: [
        analysisProDayButtonController!.naturalGasDayDataSourceList.isNotEmpty ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProDayButtonController!.checkboxGroupStates['naturalGasSource']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProDayButtonController!.checkboxGroupStates['naturalGasSource'] ??= List.filled(1000, true);
                        analysisProDayButtonController!.toggleGroup('naturalGasSource', value);

                        // if (value) {
                        //   for (var item in analysisProButtonController.naturalGasDayDataSourceList) {
                        //     analysisProButtonController.selectedGridItemsMapString['Natural Gas Source'] ??= [];
                        //     analysisProButtonController.selectedGridItemsMapString['Natural Gas Source']!.add(item.node!);
                        //   }
                        // } else {
                        //   analysisProButtonController.selectedGridItemsMapString['Natural Gas Source']?.clear();
                        // }

                        if (value) {
                          for (var item in analysisProDayButtonController!.naturalGasDayDataSourceList) {
                            analysisProDayButtonController!.selectedGridItemsMapString['Natural Gas Source'] ??= [];
                            analysisProDayButtonController!.selectedGridItemsMapString['Natural Gas Source']!.add(item.node!);


                            analysisProDayButtonController!.removeList.remove(item.node!);
                            analysisProDayButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProDayButtonController!.naturalGasDayDataSourceList){
                            analysisProDayButtonController!.removeList.add(removeItem.node!);
                            analysisProDayButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProDayButtonController!.selectedGridItemsMapString['Natural Gas Source']?.clear();

                        }

                        analysisProDayButtonController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Natural Gas Source",
                      color: analysisProDayButtonController!.checkboxGroupStates['naturalGasSource']?.any((e) => e) ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),

                    RotationTransition(
                      turns: animation1,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),

                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child:  analysisProDayButtonController!.naturalGasDayDataSourceList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child:  GridView.builder(
                            controller: firstScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProDayButtonController!.naturalGasDayDataSourceList.length,
                            itemBuilder: (context, gridIndex) {

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: analysisProDayButtonController!.checkboxGroupStates['naturalGasSource']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProDayButtonController!.checkboxGroupStates['naturalGasSource'] ??= List.filled(1000, true);
                                      analysisProDayButtonController!.checkboxGroupStates['naturalGasSource']![gridIndex] = value;
                                      bool anyChecked = analysisProDayButtonController!.checkboxGroupStates['naturalGasSource']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProDayButtonController!.toggleGroup('naturalGasSource', false);
                                      }

                                      analysisProDayButtonController!.updateSelectedGridItems('Natural Gas Source', analysisProDayButtonController!.naturalGasDayDataSourceList[gridIndex].node!, value);
                                      analysisProDayButtonController!.update();
                                    },
                                  ),

                                  SizedBox(width: size.width * k30TextSize),
                                  TextComponent(
                                    text: analysisProDayButtonController!.naturalGasDayDataSourceList[gridIndex].node ??  ' ',
                                    color: analysisProDayButtonController!.checkboxGroupStates['naturalGasSource']?[gridIndex] ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                                    fontSize: size.height * k16TextSize,
                                    fontFamily: mediumFontFamily,
                                  ),
                                ],
                              );

                            }
                        ),
                      )
                      : Scrollbar(
                        thumbVisibility: true,
                        controller: firstScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: firstScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProDayButtonController!.naturalGasDayDataSourceList.length,
                              itemBuilder: (context, gridIndex) {

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProDayButtonController!.checkboxGroupStates['naturalGasSource']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProDayButtonController!.checkboxGroupStates['naturalGasSource'] ??= List.filled(1000, true);
                                        analysisProDayButtonController!.checkboxGroupStates['naturalGasSource']![gridIndex] = value;
                                        bool anyChecked = analysisProDayButtonController!.checkboxGroupStates['naturalGasSource']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProDayButtonController!.toggleGroup('naturalGasSource', false);
                                        }

                                        analysisProDayButtonController!.updateSelectedGridItems('Natural Gas Source', analysisProDayButtonController!.naturalGasDayDataSourceList[gridIndex].node!, value);
                                        analysisProDayButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    TextComponent(
                                      text: analysisProDayButtonController!.naturalGasDayDataSourceList[gridIndex].node ??  ' ',
                                      color: analysisProDayButtonController!.checkboxGroupStates['naturalGasSource']?[gridIndex] ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController1.reverse();
                  } else {
                    animationController1.forward();
                  }
                },
              )

          ),
        ) : Container(),

//-----------------------------------------------Second-------------------------------
        analysisProDayButtonController!.naturalGasDayDataSourceList.isNotEmpty ? SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
        analysisProDayButtonController!.naturalGasDayDataLoadList.isNotEmpty ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProDayButtonController!.checkboxGroupStates['naturalGasLoad']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProDayButtonController!.checkboxGroupStates['naturalGasLoad'] ??= List.filled(1000, true);
                        analysisProDayButtonController!.toggleGroup('naturalGasLoad', value);

                        // if (value) {
                        //   for (var item in analysisProButtonController.naturalGasDayDataLoadList) {
                        //     analysisProButtonController.selectedGridItemsMapString['Natural Gas Load'] ??= [];
                        //     analysisProButtonController.selectedGridItemsMapString['Natural Gas Load']!.add(item.node!);
                        //   }
                        // } else {
                        //   analysisProButtonController.selectedGridItemsMapString['Natural Gas Load']?.clear();
                        // }


                        if (value) {
                          for (var item in analysisProDayButtonController!.naturalGasDayDataLoadList) {
                            analysisProDayButtonController!.selectedGridItemsMapString['Natural Gas Load'] ??= [];
                            analysisProDayButtonController!.selectedGridItemsMapString['Natural Gas Load']!.add(item.node!);


                            analysisProDayButtonController!.removeList.remove(item.node!);
                            analysisProDayButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProDayButtonController!.naturalGasDayDataLoadList){
                            analysisProDayButtonController!.removeList.add(removeItem.node!);
                            analysisProDayButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProDayButtonController!.selectedGridItemsMapString['Natural Gas Load']?.clear();

                        }



                        analysisProDayButtonController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Natural Gas Load",
                      color: analysisProDayButtonController!.checkboxGroupStates['naturalGasLoad']?.any((e) => e) ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),
                    RotationTransition(
                      turns: animation2,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),
                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child: analysisProDayButtonController!.naturalGasDayDataLoadList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child:   GridView.builder(
                            controller: secondScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProDayButtonController!.naturalGasDayDataLoadList.length,
                            itemBuilder: (context, gridIndex) {
                              //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: analysisProDayButtonController!.checkboxGroupStates['naturalGasLoad']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProDayButtonController!.checkboxGroupStates['naturalGasLoad'] ??= List.filled(1000, true);
                                      analysisProDayButtonController!.checkboxGroupStates['naturalGasLoad']![gridIndex] = value;
                                      bool anyChecked = analysisProDayButtonController!.checkboxGroupStates['naturalGasLoad']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProDayButtonController!.toggleGroup('naturalGasLoad', false);
                                      }

                                      analysisProDayButtonController!.updateSelectedGridItems('Natural Gas Load', analysisProDayButtonController!.naturalGasDayDataLoadList[gridIndex].node!, value);
                                      analysisProDayButtonController!.update();
                                    },
                                  ),

                                  SizedBox(width: size.width * k30TextSize),
                                  TextComponent(
                                    text: analysisProDayButtonController!.naturalGasDayDataLoadList[gridIndex].node ??  ' ',
                                    color: analysisProDayButtonController!.checkboxGroupStates['naturalGasLoad'] ? [gridIndex] ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                                    fontSize: size.height * k16TextSize,
                                    fontFamily: mediumFontFamily,
                                  ),
                                ],
                              );

                            }
                        ),
                      )
                      : Scrollbar(
                        thumbVisibility: true,
                        controller: secondScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: secondScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProDayButtonController!.naturalGasDayDataLoadList.length,
                              itemBuilder: (context, gridIndex) {
                                //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProDayButtonController!.checkboxGroupStates['naturalGasLoad']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProDayButtonController!.checkboxGroupStates['naturalGasLoad'] ??= List.filled(1000, true);
                                        analysisProDayButtonController!.checkboxGroupStates['naturalGasLoad']![gridIndex] = value;
                                        bool anyChecked = analysisProDayButtonController!.checkboxGroupStates['naturalGasLoad']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProDayButtonController!.toggleGroup('naturalGasLoad', false);
                                        }

                                        analysisProDayButtonController!.updateSelectedGridItems('Natural Gas Load', analysisProDayButtonController!.naturalGasDayDataLoadList[gridIndex].node!, value);
                                        analysisProDayButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    TextComponent(
                                      text: analysisProDayButtonController!.naturalGasDayDataLoadList[gridIndex].node ??  ' ',
                                      color: analysisProDayButtonController!.checkboxGroupStates['naturalGasLoad']?[gridIndex] ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController2.reverse();
                  } else {
                    animationController2.forward();
                  }
                },
              )

          ),
        ) :  Container(),
      ],
    ) : analysisProDayButtonController?.selectedButton == 2 ?
    Column(
      children: [
        analysisProMonthlyButtonController!.naturalGasMonthDataSourceList.isNotEmpty ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasSource']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasSource'] ??= List.filled(1000, true);
                        analysisProMonthlyButtonController!.toggleGroup('naturalGasSource', value);

                        // if (value) {
                        //   for (var item in analysisProButtonController.naturalGasDayDataSourceList) {
                        //     analysisProButtonController.selectedGridItemsMapString['Natural Gas Source'] ??= [];
                        //     analysisProButtonController.selectedGridItemsMapString['Natural Gas Source']!.add(item.node!);
                        //   }
                        // } else {
                        //   analysisProButtonController.selectedGridItemsMapString['Natural Gas Source']?.clear();
                        // }

                        if (value) {
                          for (var item in analysisProMonthlyButtonController!.naturalGasMonthDataSourceList) {
                            analysisProMonthlyButtonController!.selectedGridItemsMapString['Natural Gas Source'] ??= [];
                            analysisProMonthlyButtonController!.selectedGridItemsMapString['Natural Gas Source']!.add(item.node!);


                            analysisProMonthlyButtonController!.removeList.remove(item.node!);
                            analysisProMonthlyButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProMonthlyButtonController!.naturalGasMonthDataSourceList){
                            analysisProMonthlyButtonController!.removeList.add(removeItem.node!);
                            analysisProMonthlyButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProMonthlyButtonController!.selectedGridItemsMapString['Natural Gas Source']?.clear();

                        }

                        analysisProMonthlyButtonController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Natural Gas Source",
                      color: analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasSource']?.any((e) => e) ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),

                    RotationTransition(
                      turns: animation1,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),

                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child:  analysisProMonthlyButtonController!.naturalGasMonthDataSourceList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child:  GridView.builder(
                            controller: firstScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProMonthlyButtonController!.naturalGasMonthDataSourceList.length,
                            itemBuilder: (context, gridIndex) {

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasSource']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasSource'] ??= List.filled(1000, true);
                                      analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasSource']![gridIndex] = value;
                                      bool anyChecked = analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasSource']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProMonthlyButtonController!.toggleGroup('naturalGasSource', false);
                                      }

                                      analysisProMonthlyButtonController!.updateSelectedGridItems('Natural Gas Source', analysisProMonthlyButtonController!.naturalGasMonthDataSourceList[gridIndex].node!, value);
                                      analysisProMonthlyButtonController!.update();
                                    },
                                  ),

                                  SizedBox(width: size.width * k30TextSize),
                                  TextComponent(
                                    text: analysisProMonthlyButtonController!.naturalGasMonthDataSourceList[gridIndex].node ??  ' ',
                                    color: analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasSource']?[gridIndex] ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                                    fontSize: size.height * k16TextSize,
                                    fontFamily: mediumFontFamily,
                                  ),
                                ],
                              );

                            }
                        ),
                      )
                          : Scrollbar(
                        thumbVisibility: true,
                        controller: firstScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: firstScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProMonthlyButtonController!.naturalGasMonthDataSourceList.length,
                              itemBuilder: (context, gridIndex) {

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasSource']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasSource'] ??= List.filled(1000, true);
                                        analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasSource']![gridIndex] = value;
                                        bool anyChecked = analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasSource']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProMonthlyButtonController!.toggleGroup('naturalGasSource', false);
                                        }

                                        analysisProMonthlyButtonController!.updateSelectedGridItems('Natural Gas Source', analysisProMonthlyButtonController!.naturalGasMonthDataSourceList[gridIndex].node!, value);
                                        analysisProMonthlyButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    TextComponent(
                                      text: analysisProMonthlyButtonController!.naturalGasMonthDataSourceList[gridIndex].node ??  ' ',
                                      color: analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasSource']?[gridIndex] ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController1.reverse();
                  } else {
                    animationController1.forward();
                  }
                },
              )

          ),
        ) : Container(),

//-----------------------------------------------Second-------------------------------
        analysisProMonthlyButtonController!.naturalGasMonthDataSourceList.isNotEmpty ? SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
        analysisProMonthlyButtonController!.naturalGasMonthDataLoadList.isNotEmpty ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad'] ??= List.filled(1000, true);
                        analysisProMonthlyButtonController!.toggleGroup('naturalGasLoad', value);

                        // if (value) {
                        //   for (var item in analysisProButtonController.naturalGasDayDataLoadList) {
                        //     analysisProButtonController.selectedGridItemsMapString['Natural Gas Load'] ??= [];
                        //     analysisProButtonController.selectedGridItemsMapString['Natural Gas Load']!.add(item.node!);
                        //   }
                        // } else {
                        //   analysisProButtonController.selectedGridItemsMapString['Natural Gas Load']?.clear();
                        // }


                        if (value) {
                          for (var item in analysisProMonthlyButtonController!.naturalGasMonthDataLoadList) {
                            analysisProMonthlyButtonController!.selectedGridItemsMapString['Natural Gas Load'] ??= [];
                            analysisProMonthlyButtonController!.selectedGridItemsMapString['Natural Gas Load']!.add(item.node!);


                            analysisProMonthlyButtonController!.removeList.remove(item.node!);
                            analysisProMonthlyButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProMonthlyButtonController!.naturalGasMonthDataLoadList){
                            analysisProMonthlyButtonController!.removeList.add(removeItem.node!);
                            analysisProMonthlyButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProMonthlyButtonController!.selectedGridItemsMapString['Natural Gas Load']?.clear();

                        }



                        analysisProMonthlyButtonController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Natural Gas Load",
                      color: analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad']?.any((e) => e) ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),
                    RotationTransition(
                      turns: animation2,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),
                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child: analysisProMonthlyButtonController!.naturalGasMonthDataLoadList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child:   GridView.builder(
                            controller: secondScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProMonthlyButtonController!.naturalGasMonthDataLoadList.length,
                            itemBuilder: (context, gridIndex) {
                              //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad'] ??= List.filled(1000, true);
                                      analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad']![gridIndex] = value;
                                      bool anyChecked = analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProMonthlyButtonController!.toggleGroup('naturalGasLoad', false);
                                      }

                                      analysisProMonthlyButtonController!.updateSelectedGridItems('Natural Gas Load', analysisProMonthlyButtonController!.naturalGasMonthDataLoadList[gridIndex].node!, value);
                                      analysisProMonthlyButtonController!.update();
                                    },
                                  ),

                                  SizedBox(width: size.width * k30TextSize),
                                  TextComponent(
                                    text: analysisProMonthlyButtonController!.naturalGasMonthDataLoadList[gridIndex].node ??  ' ',
                                    color: analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad'] ? [gridIndex] ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                                    fontSize: size.height * k16TextSize,
                                    fontFamily: mediumFontFamily,
                                  ),
                                ],
                              );

                            }
                        ),
                      )
                          : Scrollbar(
                        thumbVisibility: true,
                        controller: secondScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: secondScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProMonthlyButtonController!.naturalGasMonthDataLoadList.length,
                              itemBuilder: (context, gridIndex) {
                                //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad'] ??= List.filled(1000, true);
                                        analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad']![gridIndex] = value;
                                        bool anyChecked = analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProMonthlyButtonController!.toggleGroup('naturalGasLoad', false);
                                        }

                                        analysisProMonthlyButtonController!.updateSelectedGridItems('Natural Gas Load', analysisProMonthlyButtonController!.naturalGasMonthDataLoadList[gridIndex].node!, value);
                                        analysisProMonthlyButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    TextComponent(
                                      text: analysisProMonthlyButtonController!.naturalGasMonthDataLoadList[gridIndex].node ??  ' ',
                                      color: analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad']?[gridIndex] ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController2.reverse();
                  } else {
                    animationController2.forward();
                  }
                },
              )

          ),
        ) :  Container(),
      ],
    ) : Column(
      children: [
        analysisProYearlyButtonController!.naturalGasYearlyDataSourceList.isNotEmpty ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProYearlyButtonController!.checkboxGroupStates['naturalGasSource']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProYearlyButtonController!.checkboxGroupStates['naturalGasSource'] ??= List.filled(1000, true);
                        analysisProYearlyButtonController!.toggleGroup('naturalGasSource', value);

                        // if (value) {
                        //   for (var item in analysisProButtonController.naturalGasDayDataSourceList) {
                        //     analysisProButtonController.selectedGridItemsMapString['Natural Gas Source'] ??= [];
                        //     analysisProButtonController.selectedGridItemsMapString['Natural Gas Source']!.add(item.node!);
                        //   }
                        // } else {
                        //   analysisProButtonController.selectedGridItemsMapString['Natural Gas Source']?.clear();
                        // }

                        if (value) {
                          for (var item in analysisProYearlyButtonController!.naturalGasYearlyDataSourceList) {
                            analysisProYearlyButtonController!.selectedGridItemsMapString['Natural Gas Source'] ??= [];
                            analysisProYearlyButtonController!.selectedGridItemsMapString['Natural Gas Source']!.add(item.node!);


                            analysisProYearlyButtonController!.removeList.remove(item.node!);
                            analysisProYearlyButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProYearlyButtonController!.naturalGasYearlyDataSourceList){
                            analysisProYearlyButtonController!.removeList.add(removeItem.node!);
                            analysisProYearlyButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProYearlyButtonController!.selectedGridItemsMapString['Natural Gas Source']?.clear();

                        }

                        analysisProYearlyButtonController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Natural Gas Source",
                      color: analysisProYearlyButtonController!.checkboxGroupStates['naturalGasSource']?.any((e) => e) ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),

                    RotationTransition(
                      turns: animation1,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),

                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child:  analysisProYearlyButtonController!.naturalGasYearlyDataSourceList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child:  GridView.builder(
                            controller: firstScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProYearlyButtonController!.naturalGasYearlyDataSourceList.length,
                            itemBuilder: (context, gridIndex) {

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: analysisProYearlyButtonController!.checkboxGroupStates['naturalGasSource']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProYearlyButtonController!.checkboxGroupStates['naturalGasSource'] ??= List.filled(1000, true);
                                      analysisProYearlyButtonController!.checkboxGroupStates['naturalGasSource']![gridIndex] = value;
                                      bool anyChecked = analysisProYearlyButtonController!.checkboxGroupStates['naturalGasSource']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProYearlyButtonController!.toggleGroup('naturalGasSource', false);
                                      }

                                      analysisProYearlyButtonController!.updateSelectedGridItems('Natural Gas Source', analysisProYearlyButtonController!.naturalGasYearlyDataSourceList[gridIndex].node!, value);
                                      analysisProYearlyButtonController!.update();
                                    },
                                  ),

                                  SizedBox(width: size.width * k30TextSize),
                                  TextComponent(
                                    text: analysisProYearlyButtonController!.naturalGasYearlyDataSourceList[gridIndex].node ??  ' ',
                                    color: analysisProYearlyButtonController!.checkboxGroupStates['naturalGasSource']?[gridIndex] ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                                    fontSize: size.height * k16TextSize,
                                    fontFamily: mediumFontFamily,
                                  ),
                                ],
                              );

                            }
                        ),
                      )
                          : Scrollbar(
                        thumbVisibility: true,
                        controller: firstScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: firstScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProYearlyButtonController!.naturalGasYearlyDataSourceList.length,
                              itemBuilder: (context, gridIndex) {

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProYearlyButtonController!.checkboxGroupStates['naturalGasSource']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProYearlyButtonController!.checkboxGroupStates['naturalGasSource'] ??= List.filled(1000, true);
                                        analysisProYearlyButtonController!.checkboxGroupStates['naturalGasSource']![gridIndex] = value;
                                        bool anyChecked = analysisProYearlyButtonController!.checkboxGroupStates['naturalGasSource']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProYearlyButtonController!.toggleGroup('naturalGasSource', false);
                                        }

                                        analysisProYearlyButtonController!.updateSelectedGridItems('Natural Gas Source', analysisProYearlyButtonController!.naturalGasYearlyDataSourceList[gridIndex].node!, value);
                                        analysisProYearlyButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    TextComponent(
                                      text: analysisProYearlyButtonController!.naturalGasYearlyDataSourceList[gridIndex].node ??  ' ',
                                      color: analysisProYearlyButtonController!.checkboxGroupStates['naturalGasSource']?[gridIndex] ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController1.reverse();
                  } else {
                    animationController1.forward();
                  }
                },
              )

          ),
        ) : Container(),

//-----------------------------------------------Second-------------------------------
        analysisProYearlyButtonController!.naturalGasYearlyDataSourceList.isNotEmpty ? SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
        analysisProYearlyButtonController!.naturalGasYearlyDataLoadList.isNotEmpty ? Container(
          //height: size.height * 0.20,
          decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
          ),
          child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                expansionTileTheme: const ExpansionTileThemeData(
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                ),
              ),
              child:  ExpansionTile(
                backgroundColor: Colors.transparent,
                initiallyExpanded: true,
                showTrailingIcon: false,
                title:  Row(
                  children: [
                    CustomIconCheckbox(
                      initialValue: analysisProYearlyButtonController!.checkboxGroupStates['naturalGasLoad']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        analysisProYearlyButtonController!.checkboxGroupStates['naturalGasLoad'] ??= List.filled(1000, true);
                        analysisProYearlyButtonController!.toggleGroup('naturalGasLoad', value);

                        // if (value) {
                        //   for (var item in analysisProButtonController.naturalGasDayDataLoadList) {
                        //     analysisProButtonController.selectedGridItemsMapString['Natural Gas Load'] ??= [];
                        //     analysisProButtonController.selectedGridItemsMapString['Natural Gas Load']!.add(item.node!);
                        //   }
                        // } else {
                        //   analysisProButtonController.selectedGridItemsMapString['Natural Gas Load']?.clear();
                        // }


                        if (value) {
                          for (var item in analysisProYearlyButtonController!.naturalGasYearlyDataLoadList) {
                            analysisProYearlyButtonController!.selectedGridItemsMapString['Natural Gas Load'] ??= [];
                            analysisProYearlyButtonController!.selectedGridItemsMapString['Natural Gas Load']!.add(item.node!);


                            analysisProYearlyButtonController!.removeList.remove(item.node!);
                            analysisProYearlyButtonController!.itemsList.add(item.node!);
                          }
                        } else {
                          for(var removeItem in analysisProYearlyButtonController!.naturalGasYearlyDataLoadList){
                            analysisProYearlyButtonController!.removeList.add(removeItem.node!);
                            analysisProYearlyButtonController!.itemsList.remove(removeItem.node);
                          }

                          analysisProYearlyButtonController!.selectedGridItemsMapString['Natural Gas Load']?.clear();

                        }



                        analysisProYearlyButtonController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Natural Gas Load",
                      color: analysisProYearlyButtonController!.checkboxGroupStates['naturalGasLoad']?.any((e) => e) ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
                      fontSize:  size.height * k20TextSize,
                      fontFamily: boldFontFamily,
                    ),
                    const Spacer(),
                    RotationTransition(
                      turns: animation2,
                      child: SvgPicture.asset(
                        AssetsPath.spinArrowIconSVG,
                        height: size.height * k25TextSize,
                      ),
                    ),
                  ],
                ),
                children: [
                  // SizedBox(height: size.height * 0.002),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.height * k16TextSize,
                        vertical: 0
                    ),
                    child: const Divider(height: 1, thickness: 0.8, color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: size.height * k16TextSize,
                      right: size.height * k16TextSize,
                      bottom: size.height * k16TextSize,
                      top: size.height * k8TextSize,
                    ),
                    child: Theme(
                      data: ThemeData(
                        highlightColor: AppColors.primaryColor,
                      ),
                      child: analysisProYearlyButtonController!.naturalGasYearlyDataLoadList.length < 10 ? Card(
                        elevation: 0.0,
                        color: AppColors.whiteTextColor,
                        child:   GridView.builder(
                            controller: secondScrollController,
                            primary: false,
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 0,
                              childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                            ),
                            itemCount: analysisProYearlyButtonController!.naturalGasYearlyDataLoadList.length,
                            itemBuilder: (context, gridIndex) {
                              //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: analysisProYearlyButtonController!.checkboxGroupStates['naturalGasLoad']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      analysisProYearlyButtonController!.checkboxGroupStates['naturalGasLoad'] ??= List.filled(100, true);
                                      analysisProYearlyButtonController!.checkboxGroupStates['naturalGasLoad']![gridIndex] = value;
                                      bool anyChecked = analysisProYearlyButtonController!.checkboxGroupStates['naturalGasLoad']!.any((e) => e);

                                      if (!anyChecked) {
                                        analysisProYearlyButtonController!.toggleGroup('naturalGasLoad', false);
                                      }

                                      analysisProYearlyButtonController!.updateSelectedGridItems('Natural Gas Load', analysisProYearlyButtonController!.naturalGasYearlyDataLoadList[gridIndex].node!, value);
                                      analysisProYearlyButtonController!.update();
                                    },
                                  ),

                                  SizedBox(width: size.width * k30TextSize),
                                  TextComponent(
                                    text: analysisProYearlyButtonController!.naturalGasYearlyDataLoadList[gridIndex].node ??  ' ',
                                    color: analysisProYearlyButtonController!.checkboxGroupStates['naturalGasLoad'] ? [gridIndex] ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                                    fontSize: size.height * k16TextSize,
                                    fontFamily: mediumFontFamily,
                                  ),
                                ],
                              );

                            }
                        ),
                      )
                          : Scrollbar(
                        thumbVisibility: true,
                        controller: secondScrollController,
                        radius: Radius.circular(size.height * k20TextSize),
                        child: SizedBox(
                          height: size.height * 0.2,
                          child: GridView.builder(
                              controller: secondScrollController,
                              primary: false,
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 0,
                                childAspectRatio: size.width > 1000 ? size.height * 0.015 : size.height * 0.0050,
                              ),
                              itemCount: analysisProYearlyButtonController!.naturalGasYearlyDataLoadList.length,
                              itemBuilder: (context, gridIndex) {
                                //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: analysisProYearlyButtonController!.checkboxGroupStates['naturalGasLoad']?[gridIndex] ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        analysisProYearlyButtonController!.checkboxGroupStates['naturalGasLoad'] ??= List.filled(1000, true);
                                        analysisProYearlyButtonController!.checkboxGroupStates['naturalGasLoad']![gridIndex] = value;
                                        bool anyChecked = analysisProYearlyButtonController!.checkboxGroupStates['naturalGasLoad']!.any((e) => e);

                                        if (!anyChecked) {
                                          analysisProYearlyButtonController!.toggleGroup('naturalGasLoad', false);
                                        }

                                        analysisProYearlyButtonController!.updateSelectedGridItems('Natural Gas Load', analysisProYearlyButtonController!.naturalGasYearlyDataLoadList[gridIndex].node!, value);
                                        analysisProYearlyButtonController!.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    TextComponent(
                                      text: analysisProMonthlyButtonController!.naturalGasMonthDataLoadList[gridIndex].node ??  ' ',
                                      color: analysisProMonthlyButtonController!.checkboxGroupStates['naturalGasLoad']?[gridIndex] ?? true ?  AppColors.primaryColor :  AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ],
                                );

                              }
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  if (expanded) {
                    animationController2.reverse();
                  } else {
                    animationController2.forward();
                  }
                },
              )

          ),
        ) :  Container(),
      ],
    );
  }
}
