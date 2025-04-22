import 'dart:developer';

import 'package:nz_fabrics/src/common_widgets/custom_checkbox_button/custom_checkbox_button.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_monthly_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_yearly_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_day_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_month_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_year_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/analysis_pro_filter_result.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/bottom_sheet_filter_button_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/bottom_sheet_title_filter_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/date_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/multiple_items_choice_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/multiple_month_items_choice_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/multiple_yearly_items_choice_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/new/monthly_analysis_pro_column_chart_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/new/analysis_pro_day_line_chart.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/new/only_monthly_analysis_pro_column_chart_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/new/only_yearly_analysis_pro_column_chart_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/widget/new/yearly_analysis_pro_column_chart_widget.dart';
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
      // Get.find<AnalysisProDayButtonController>().fetchDayModelDGRData(
      //   fromDate: Get.find<AnalysisProDayButtonController>().fromDateTEController.text,
      //   toDate: Get.find<AnalysisProDayButtonController>().toDateTEController.text,
      // );
      // Get.find<AnalysisProDayButtonController>().fetchSelectedNodeData(
      //   fromDate: Get.find<AnalysisProDayButtonController>().fromDateTEController.text,
      //   toDate: Get.find<AnalysisProDayButtonController>().toDateTEController.text,
      // );


      Get.find<AnalysisProMonthlyButtonController>().fetchMonthDGRData(selectedMonth: Get.find<AnalysisProMonthlyButtonController>().selectedMonth.toString(), selectedYear: Get.find<AnalysisProMonthlyButtonController>().selectedYear.toString());
      Get.find<AnalysisProMonthlyButtonController>().fetchSelectedNodeData(selectedMonth: Get.find<AnalysisProMonthlyButtonController>().selectedMonth.toString(), selectedYear: Get.find<AnalysisProMonthlyButtonController>().selectedYear.toString());

      Get.find<AnalysisProYearlyButtonController>().fetchYearlyDGRData(selectedYearDate: Get.find<AnalysisProYearlyButtonController>().selectedYear);
      Get.find<AnalysisProYearlyButtonController>().fetchSelectedNodeData(selectedYear: Get.find<AnalysisProYearlyButtonController>().selectedYear);



      Get.find<ElectricityDayAnalysisProController>().fetchElectricityAnalysisPro();
      Get.find<ElectricityMonthAnalysisProController>().fetchMonthlyElectricityAnalysisPro();
      Get.find<ElectricityYearAnalysisProController>().fetchYearlyElectricityAnalysisPro();


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
             // Get.find<AnalysisProDayButtonController>().fromDateTEController.text =  DateFormat("dd-MM-yyyy").format(DateTime.now());
             // Get.find<AnalysisProDayButtonController>().toDateTEController.text =  DateFormat("dd-MM-yyyy").format(DateTime.now());

              Get.find<ElectricityDayAnalysisProController>().selectedGridItemsMapString.clear();
              Get.find<ElectricityDayAnalysisProController>().checkboxGroupStates.clear();
              Get.find<ElectricityDayAnalysisProController>().itemsList.clear();
              Get.find<ElectricityDayAnalysisProController>().removeList.clear();

              
              Get.find<ElectricityDayAnalysisProController>().clearFilterIngDate();
              Get.find<ElectricityDayAnalysisProController>().selectedIndices.clear();


              Get.find<ElectricityMonthAnalysisProController>().selectedGridItemsMapString.clear();
              Get.find<ElectricityMonthAnalysisProController>().checkboxGroupStates.clear();
              Get.find<ElectricityMonthAnalysisProController>().itemsList.clear();
              Get.find<ElectricityMonthAnalysisProController>().removeList.clear();
              Get.find<ElectricityMonthAnalysisProController>().selectedIndices.clear();


              Get.find<ElectricityYearAnalysisProController>().selectedGridItemsMapString.clear();
              Get.find<ElectricityYearAnalysisProController>().checkboxGroupStates.clear();
              Get.find<ElectricityYearAnalysisProController>().itemsList.clear();
              Get.find<ElectricityYearAnalysisProController>().removeList.clear();
              Get.find<ElectricityYearAnalysisProController>().selectedIndices.clear();


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
                      child: GetBuilder<ElectricityDayAnalysisProController>(
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
                              GetBuilder<ElectricityDayAnalysisProController>(
                                  builder: (controller) {
                                    var validKeys = controller.selectedGridItemsMapString.keys.where(
                                            (key) => controller.selectedGridItemsMapString[key]?.isNotEmpty ?? false
                                    ).toList();

                                    return Container(
                                      height: size.height * 0.18,///-------------Day-------------
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
                              GetBuilder<ElectricityMonthAnalysisProController>(
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
                           ) : GetBuilder<ElectricityYearAnalysisProController>(
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
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: (){
                                   controller.selectedButton == 1 ? controller.downloadDataSheet(context) : controller.selectedButton == 2 ? Get.find<ElectricityMonthAnalysisProController>().downloadDataSheet(context) : Get.find<ElectricityYearAnalysisProController>().downloadYearlyDataSheet(context);
                                  },
                                  child: CustomContainer(
                                    height: size.height * 0.050,
                                    width:  size.width * 0.3,
                                    borderRadius: BorderRadius.circular(size.height * k8TextSize),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          TextComponent(text: "Download"),
                                          Icon(Icons.download)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                               GetBuilder<ElectricityDayAnalysisProController>(
                                 builder: (controller) {
                                   return CustomContainer(
                                        height: size.height * 0.48,
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
                                            GetBuilder<ElectricityDayAnalysisProController>(
                                              builder: (controller) {
                                                if(controller.isElectricityAnalysisProInProgress){
                                                  return CustomShimmerWidget(height: 300, width: size.width -30);
                                                }
                                                return SizedBox(
                                                    height: size.height * 0.4,
                                                    width: double.infinity,
                                                    child: controller.selectedButton == 1 ?
                                                    controller.graphType == "Line-Chart" ?   AnalysisProLineChartWidget(
                                                      sourceData: controller.dailySourceData,
                                                      loadData: controller.dailyLoadData,
                                                      controller: controller,
                                                    ) : controller.graphType == 'Monthly-Bar-Chart' ?  AnalysisProMonthlyColumnChartWidget(
                                                      monthlySourceData: controller.monthlySourceData,
                                                      monthlyLoadData: controller.monthlyLoadData,
                                                      controller: controller,
                                                    ) : AnalysisProYearlyColumnChartWidget(
                                                      yearlySourceData: controller.yearlySourceData,
                                                      yearlyLoadData: controller.yearlyLoadData,
                                                      controller: controller,
                                                    ) : controller.selectedButton == 2 ? GetBuilder<ElectricityMonthAnalysisProController>(
                                                      builder: (controller) {
                                                        return OnlyMonthlyAnalysisProColumnChartWidget(
                                                          monthlySourceData: controller.onlyMonthlySourceData,
                                                          monthlyLoadData: controller.onlyMonthlyLoadData,
                                                          controller: controller,
                                                        );
                                                      },
                                                    )
                                                        : GetBuilder<ElectricityYearAnalysisProController>(
                                                      builder: (controller) {
                                                        return OnlyAnalysisProYearlyColumnChartWidget(
                                                          yearlySourceData: controller.onlyYearlySourceData,
                                                          yearlyLoadData: controller.onlyYearlyLoadData,
                                                          controller: controller,
                                                        );
                                                      },
                                                    )
                                                );
                                              }
                                            ),

                                           // DownloadButtonWidget(size: size),
                                          ],
                                        ),
                                    );
                                 }
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
   ScrollController _gridSecondScrollController = ScrollController();
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
                                    child: GetBuilder<ElectricityDayAnalysisProController>(
                                      builder: (electricityAnalysisProDayButtonController) {
                                        return electricityAnalysisProDayButtonController.selectedButton == 1 ?
                                        Column(
                                          children: [
                                            DGRExpendableContainerWidget(
                                              firstScrollController: _gridScrollController,
                                              secondScrollController: _gridSecondScrollController,
                                              animationController1: _dgrController1,
                                              animationController2: _dgrController2,
                                              animation1: _dgrAnimation1,
                                              animation2: _dgrAnimation2,
                                              electricityAnalysisProDayController : electricityAnalysisProDayButtonController,
                                              selectedButton: 1,
                                    ),
                                          ],
                                        ) : electricityAnalysisProDayButtonController.selectedButton == 2 ? GetBuilder<ElectricityMonthAnalysisProController>(
                                          builder: (electricityMonthAnalysisProController) {
                                            return Column(
                                              children: [
                                                DGRExpendableContainerWidget(
                                                  firstScrollController: _gridScrollController,
                                                  secondScrollController: _gridSecondScrollController,
                                                  animationController1: _dgrController1,
                                                  animationController2: _dgrController2,
                                                  animation1: _dgrAnimation1,
                                                  animation2: _dgrAnimation2,
                                                  electricityMonthAnalysisProController: electricityMonthAnalysisProController,
                                                  selectedButton: 2,
                                                ),

                                              ],
                                            );
                                          }
                                        ) : GetBuilder<ElectricityYearAnalysisProController>(
                                            builder: (electricityYearAnalysisProController) {
                                              return Column(
                                                children: [
                                                  DGRExpendableContainerWidget(
                                                    firstScrollController: _gridScrollController,
                                                    secondScrollController: _gridSecondScrollController,
                                                    animationController1: _dgrController1,
                                                    animationController2: _dgrController2,
                                                    animation1: _dgrAnimation1,
                                                    animation2: _dgrAnimation2,
                                                    electricityYearAnalysisProController: electricityYearAnalysisProController,
                                                    selectedButton: 3,
                                                  ),

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
                        child: GetBuilder<ElectricityDayAnalysisProController>(
                          builder: (electricityDayAnalysisProController) {
                            return GestureDetector(
                              onTap: (){
                                Navigator.of(context).pop();
                                electricityDayAnalysisProController.selectedButton == 1 ?
                                electricityDayAnalysisProController.fetchSelectedNodeData(
                                   fromDate: electricityDayAnalysisProController.fromDateTEController.text,
                                   toDate: electricityDayAnalysisProController.toDateTEController.text,
                                 nodes: electricityDayAnalysisProController.itemsList.toList()
                               )

                                :  electricityDayAnalysisProController.selectedButton == 2
                                     ? Get.find<ElectricityMonthAnalysisProController>().fetchSelectedMonthDGRData(
                                    selectedMonth: Get.find<ElectricityMonthAnalysisProController>().selectedMonth.toString(),
                                    selectedYear: Get.find<ElectricityMonthAnalysisProController>().selectedYear.toString(),
                                  nodes: Get.find<ElectricityMonthAnalysisProController>().itemsList.toList(),
                                )
                                     : Get.find<ElectricityYearAnalysisProController>().fetchSelectedYearDGRData(
                                    selectedYear: Get.find<ElectricityYearAnalysisProController>().selectedYear.toString(),
                                    nodes: Get.find<ElectricityYearAnalysisProController>().itemsList.toList(),
                                );

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
     this.electricityAnalysisProDayController,
     this.electricityMonthAnalysisProController,
     this.electricityYearAnalysisProController,

  });

  final ScrollController firstScrollController;
  final ScrollController secondScrollController;

  final AnimationController animationController1;
  final Animation<double> animation1;
  final AnimationController animationController2;
  final Animation<double> animation2;

  final ElectricityDayAnalysisProController ? electricityAnalysisProDayController;
  final ElectricityMonthAnalysisProController? electricityMonthAnalysisProController;
  final ElectricityYearAnalysisProController? electricityYearAnalysisProController;
  final int selectedButton;


  @override
  Widget build(BuildContext context) {
    log("dgrMonthDataSourceList: ${electricityMonthAnalysisProController?.electricityMonthAnalysisProSourceList.length}");
    log("is source is notEmpty: ${electricityMonthAnalysisProController?.electricityMonthAnalysisProSourceList.isNotEmpty}");
   log("selectedButton: ${ electricityAnalysisProDayController?.selectedButton}");
   log("added selectedButton: $selectedButton");
    Size size = MediaQuery.of(context).size;
    return selectedButton == 1 ?  Column(
      children: [
        electricityAnalysisProDayController!.electricityAnalysisProSourceList.isNotEmpty ? Container(
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
                          initialValue: electricityAnalysisProDayController?.checkboxGroupStates['source']?.any((e) => e) ?? true,
                          checkedIcon: AssetsPath.checkboxIconSVG,
                          uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                          onChanged: (bool value) {
                            electricityAnalysisProDayController?.checkboxGroupStates['source'] ??= List.filled(100, true);
                            electricityAnalysisProDayController?.toggleGroup('source', value);


                            if (value) {
                              for (var item in electricityAnalysisProDayController!.electricityAnalysisProSourceList) {
                                electricityAnalysisProDayController?.selectedGridItemsMapString['Source'] ??= [];
                                electricityAnalysisProDayController?.selectedGridItemsMapString['Source']!.add(item.nodeName!);

                                electricityAnalysisProDayController?.removeList.remove(item.nodeName!);
                                electricityAnalysisProDayController?.itemsList.add(item.nodeName!);
                              }
                            } else {
                              for(var removeItem in electricityAnalysisProDayController!.electricityAnalysisProSourceList){
                                electricityAnalysisProDayController?.removeList.add(removeItem.nodeName!);
                                electricityAnalysisProDayController?.itemsList.remove(removeItem.nodeName);
                              }
                              electricityAnalysisProDayController?.selectedGridItemsMapString['Source']?.clear();
                            }

                           // log("====All item in List===== ${electricityAnalysisProDayButtonController?.itemsList}");
                            electricityAnalysisProDayController?.update();
                          },
                        ),


                        SizedBox(width: size.width * k30TextSize),
                        TextComponent(
                          text: "Source",
                          color: electricityAnalysisProDayController!.checkboxGroupStates['source']?.any((e) => e) ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
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
                          child: Scrollbar(
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
                                  itemCount: electricityAnalysisProDayController!.electricityAnalysisProSourceList.length,


                                  itemBuilder: (context, gridIndex) {
                                    final nodeName = electricityAnalysisProDayController?.electricityAnalysisProSourceList[gridIndex].nodeName ?? "";

                                    return Row(
                                      children: [
                                        CustomIconCheckbox(
                                          initialValue: electricityAnalysisProDayController?.itemsList.contains(nodeName) ?? true,
                                          checkedIcon: AssetsPath.checkboxIconSVG,
                                          uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                          onChanged: (bool value) {
                                            // Synchronize checkbox state with itemsList
                                            electricityAnalysisProDayController?.checkboxGroupStates['source']?[gridIndex] = value;

                                            // Ensure only the first item is checked if required
                                            if (gridIndex == 0) {
                                              electricityAnalysisProDayController!.checkboxGroupStates['source']?[gridIndex] = true;
                                            } else {
                                              electricityAnalysisProDayController!.checkboxGroupStates['source']?[gridIndex] = false;
                                            }

                                            // Update selected items and synchronize state
                                            electricityAnalysisProDayController?.updateSelectedGridItems('Source', nodeName, value);
                                            electricityAnalysisProDayController?.update();
                                          },
                                        ),
                                        SizedBox(width: size.width * k30TextSize),
                                        SizedBox(
                                          width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                          child: TextComponent(
                                            text: nodeName,
                                            color: electricityAnalysisProDayController?.checkboxGroupStates['source']?[gridIndex] ?? false
                                                ? AppColors.primaryColor
                                                : AppColors.secondaryTextColor,
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


//-----------------------------------------------Day Load -------------------------------
        electricityAnalysisProDayController!.electricityAnalysisProSourceList.isNotEmpty ?   SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
        electricityAnalysisProDayController!.electricityAnalysisProLoadList.isNotEmpty ?
        Container(
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
                      initialValue: electricityAnalysisProDayController!.checkboxGroupStates['load']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        electricityAnalysisProDayController!.checkboxGroupStates['load'] ??= List.filled(1000, true);
                        electricityAnalysisProDayController!.toggleGroup('load', value);

                        if (value) {
                          for (var item in electricityAnalysisProDayController!.electricityAnalysisProLoadList) {
                            electricityAnalysisProDayController!.selectedGridItemsMapString['Load'] ??= [];
                            electricityAnalysisProDayController!.selectedGridItemsMapString['Load']!.add(item.nodeName!);

                            electricityAnalysisProDayController!.removeList.remove(item.nodeName!);
                            electricityAnalysisProDayController!.itemsList.add(item.nodeName!);
                          }
                        } else {
                          for(var removeItem in electricityAnalysisProDayController!.electricityAnalysisProLoadList){
                            electricityAnalysisProDayController!.removeList.add(removeItem.nodeName!);
                            electricityAnalysisProDayController!.itemsList.remove(removeItem.nodeName);
                          }

                          electricityAnalysisProDayController!.selectedGridItemsMapString['Load']?.clear();

                        }
                        electricityAnalysisProDayController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Load",
                      color:  electricityAnalysisProDayController!.checkboxGroupStates['load']?.any((e) => e) ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
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
                      child: electricityAnalysisProDayController!.electricityAnalysisProLoadList.length < 10 ? Card(
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
                            itemCount: electricityAnalysisProDayController!.electricityAnalysisProLoadList.length,
                        /*    itemBuilder: (context, gridIndex) {
                              //  bool isSelected = analysisProButtonController.isGridItemSelected(index, gridIndex);

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: electricityAnalysisProDayButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      electricityAnalysisProDayButtonController!.checkboxGroupStates['load'] ??= List.filled(1000, true);
                                      electricityAnalysisProDayButtonController!.checkboxGroupStates['load']![gridIndex] = value;
                                      bool anyChecked = electricityAnalysisProDayButtonController!.checkboxGroupStates['load']!.any((e) => e);

                                      if (!anyChecked) {
                                        electricityAnalysisProDayButtonController!.toggleGroup('load', false);
                                      }

                                      electricityAnalysisProDayButtonController!.updateSelectedGridItems('Load', electricityAnalysisProDayButtonController!.electricityAnalysisProLoadList[gridIndex].nodeName!, value);
                                      electricityAnalysisProDayButtonController!.update();
                                    },
                                  ),
                                  SizedBox(width: size.width * k30TextSize),
                                  SizedBox(
                                    width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                    child: TextComponent(
                                      text: electricityAnalysisProDayButtonController!.electricityAnalysisProLoadList[gridIndex].nodeName ??  ' ',
                                      color: electricityAnalysisProDayButtonController!.checkboxGroupStates['load']?[gridIndex] ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
                                      fontSize: size.height * k16TextSize,
                                      fontFamily: mediumFontFamily,
                                    ),
                                  ),
                                ],
                              );

                            }*/

                            itemBuilder: (context, gridIndex) {
                              final nodeName = electricityAnalysisProDayController?.electricityAnalysisProLoadList[gridIndex].nodeName ?? "";

                              return Row(
                                children: [
                                  CustomIconCheckbox(
                                    initialValue: electricityAnalysisProDayController?.itemsList.contains(nodeName) ?? true,
                                    checkedIcon: AssetsPath.checkboxIconSVG,
                                    uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                    onChanged: (bool value) {
                                      // Synchronize checkbox state with itemsList
                                      electricityAnalysisProDayController?.checkboxGroupStates['load']?[gridIndex] = value;

                                      // Ensure only the first item is checked if required
                                      if (gridIndex == 0) {
                                        electricityAnalysisProDayController!.checkboxGroupStates['load']?[gridIndex] = true;
                                      } else {
                                        electricityAnalysisProDayController!.checkboxGroupStates['load']?[gridIndex] = false;
                                      }

                                      // Update selected items and synchronize state
                                      electricityAnalysisProDayController?.updateSelectedGridItems('Load', nodeName, value);
                                      electricityAnalysisProDayController?.update();
                                    },
                                  ),
                                  SizedBox(width: size.width * k30TextSize),
                                  SizedBox(
                                    width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                    child: TextComponent(
                                      text: nodeName,
                                      color: electricityAnalysisProDayController?.checkboxGroupStates['load']?[gridIndex] ?? false
                                          ? AppColors.primaryColor
                                          : AppColors.secondaryTextColor,
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
                              itemCount: electricityAnalysisProDayController!.electricityAnalysisProLoadList.length,
                              itemBuilder: (context, gridIndex) {
                                final nodeName = electricityAnalysisProDayController?.electricityAnalysisProLoadList[gridIndex].nodeName ?? "";

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: electricityAnalysisProDayController?.itemsList.contains(nodeName) ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        // Synchronize checkbox state with itemsList
                                        electricityAnalysisProDayController?.checkboxGroupStates['load']?[gridIndex] = value;

                                        // Ensure only the first item is checked if required
                                        if (gridIndex == 0) {
                                          electricityAnalysisProDayController!.checkboxGroupStates['load']?[gridIndex] = true;
                                        } else {
                                          electricityAnalysisProDayController!.checkboxGroupStates['load']?[gridIndex] = false;
                                        }

                                        // Update selected items and synchronize state
                                        electricityAnalysisProDayController?.updateSelectedGridItems('Load', nodeName, value);
                                        electricityAnalysisProDayController?.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    SizedBox(
                                      width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                      child: TextComponent(
                                        text: nodeName,
                                        color: electricityAnalysisProDayController?.checkboxGroupStates['load']?[gridIndex] ?? false
                                            ? AppColors.primaryColor
                                            : AppColors.secondaryTextColor,
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
    )
        : selectedButton == 2
        ?  Column(
      children: [
        //----------------------------------------------- Month Source -------------------------------
        electricityMonthAnalysisProController!.electricityMonthAnalysisProSourceList.isNotEmpty ? Container(
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
                      initialValue: electricityMonthAnalysisProController?.checkboxGroupStates['source']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        electricityMonthAnalysisProController?.checkboxGroupStates['source'] ??= List.filled(100, true);
                        electricityMonthAnalysisProController?.toggleGroup('source', value);


                        if (value) {
                          for (var item in electricityMonthAnalysisProController!.electricityMonthAnalysisProSourceList) {
                            electricityMonthAnalysisProController?.selectedGridItemsMapString['Source'] ??= [];
                            electricityMonthAnalysisProController?.selectedGridItemsMapString['Source']!.add(item.nodeName!);

                            electricityMonthAnalysisProController?.removeList.remove(item.nodeName!);
                            electricityMonthAnalysisProController?.itemsList.add(item.nodeName!);
                          }
                        } else {
                          for(var removeItem in electricityMonthAnalysisProController!.electricityMonthAnalysisProSourceList){
                            electricityMonthAnalysisProController?.removeList.add(removeItem.nodeName!);
                            electricityMonthAnalysisProController?.itemsList.remove(removeItem.nodeName);
                          }
                          electricityMonthAnalysisProController?.selectedGridItemsMapString['Source']?.clear();
                        }

                        // log("====All item in List===== ${electricityAnalysisProDayButtonController?.itemsList}");
                        electricityMonthAnalysisProController?.update();
                      },
                    ),


                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Source",
                      color: electricityMonthAnalysisProController!.checkboxGroupStates['source']?.any((e) => e) ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
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
                      child: Scrollbar(
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
                              itemCount: electricityMonthAnalysisProController!.electricityMonthAnalysisProSourceList.length,


                              itemBuilder: (context, gridIndex) {
                                final nodeName = electricityMonthAnalysisProController?.electricityMonthAnalysisProSourceList[gridIndex].nodeName ?? "";

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: electricityMonthAnalysisProController?.itemsList.contains(nodeName) ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        // Synchronize checkbox state with itemsList
                                        electricityMonthAnalysisProController?.checkboxGroupStates['source']?[gridIndex] = value;

                                        // Ensure only the first item is checked if required
                                        if (gridIndex == 0) {
                                          electricityMonthAnalysisProController!.checkboxGroupStates['source']?[gridIndex] = true;
                                        } else {
                                          electricityMonthAnalysisProController!.checkboxGroupStates['source']?[gridIndex] = false;
                                        }

                                        // Update selected items and synchronize state
                                        electricityMonthAnalysisProController?.updateSelectedGridItems('Source', nodeName, value);
                                        electricityMonthAnalysisProController?.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    SizedBox(
                                      width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                      child: TextComponent(
                                        text: nodeName,
                                        color: electricityMonthAnalysisProController?.checkboxGroupStates['source']?[gridIndex] ?? false
                                            ? AppColors.primaryColor
                                            : AppColors.secondaryTextColor,
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


//----------------------------------------------- Month Load -------------------------------
        electricityMonthAnalysisProController!.electricityMonthAnalysisProSourceList.isNotEmpty ?   SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
        electricityMonthAnalysisProController!.electricityMonthAnalysisProLoadList.isNotEmpty ?
        Container(
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
                      initialValue: electricityMonthAnalysisProController!.checkboxGroupStates['load']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        electricityMonthAnalysisProController!.checkboxGroupStates['load'] ??= List.filled(1000, true);
                        electricityMonthAnalysisProController!.toggleGroup('load', value);

                        if (value) {
                          for (var item in electricityMonthAnalysisProController!.electricityMonthAnalysisProLoadList) {
                            electricityMonthAnalysisProController!.selectedGridItemsMapString['Load'] ??= [];
                            electricityMonthAnalysisProController!.selectedGridItemsMapString['Load']!.add(item.nodeName!);

                            electricityMonthAnalysisProController!.removeList.remove(item.nodeName!);
                            electricityMonthAnalysisProController!.itemsList.add(item.nodeName!);
                          }
                        } else {
                          for(var removeItem in electricityMonthAnalysisProController!.electricityMonthAnalysisProLoadList){
                            electricityMonthAnalysisProController!.removeList.add(removeItem.nodeName!);
                            electricityMonthAnalysisProController!.itemsList.remove(removeItem.nodeName);
                          }

                          electricityMonthAnalysisProController!.selectedGridItemsMapString['Load']?.clear();

                        }
                        electricityMonthAnalysisProController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Load",
                      color:  electricityMonthAnalysisProController!.checkboxGroupStates['load']?.any((e) => e) ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
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
                      child: Scrollbar(
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
                              itemCount: electricityMonthAnalysisProController!.electricityMonthAnalysisProLoadList.length,
                              itemBuilder: (context, gridIndex) {
                                final nodeName = electricityMonthAnalysisProController?.electricityMonthAnalysisProLoadList[gridIndex].nodeName ?? "";

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: electricityMonthAnalysisProController?.itemsList.contains(nodeName) ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        // Synchronize checkbox state with itemsList
                                        electricityMonthAnalysisProController?.checkboxGroupStates['load']?[gridIndex] = value;

                                        // Ensure only the first item is checked if required
                                        if (gridIndex == 0) {
                                          electricityMonthAnalysisProController?.checkboxGroupStates['load']?[gridIndex] = true;
                                        } else {
                                          electricityMonthAnalysisProController?.checkboxGroupStates['load']?[gridIndex] = false;
                                        }

                                        // Update selected items and synchronize state
                                        electricityMonthAnalysisProController?.updateSelectedGridItems('Load', nodeName, value);
                                        electricityMonthAnalysisProController?.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    SizedBox(
                                      width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                      child: TextComponent(
                                        text: nodeName,
                                        color: electricityMonthAnalysisProController?.checkboxGroupStates['load']?[gridIndex] ?? false
                                            ? AppColors.primaryColor
                                            : AppColors.secondaryTextColor,
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
    )
        : Column(
      children: [
        //----------------------------------------------- Year Source -------------------------------
        electricityYearAnalysisProController!.electricityYearlyAnalysisProSourceList.isNotEmpty ? Container(
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
                      initialValue: electricityYearAnalysisProController?.checkboxGroupStates['source']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        electricityYearAnalysisProController?.checkboxGroupStates['source'] ??= List.filled(100, true);
                        electricityYearAnalysisProController?.toggleGroup('source', value);


                        if (value) {
                          for (var item in electricityYearAnalysisProController!.electricityYearlyAnalysisProSourceList) {
                            electricityYearAnalysisProController?.selectedGridItemsMapString['Source'] ??= [];
                            electricityYearAnalysisProController?.selectedGridItemsMapString['Source']!.add(item.nodeName!);

                            electricityYearAnalysisProController?.removeList.remove(item.nodeName!);
                            electricityYearAnalysisProController?.itemsList.add(item.nodeName!);
                          }
                        } else {
                          for(var removeItem in electricityYearAnalysisProController!.electricityYearlyAnalysisProSourceList){
                            electricityYearAnalysisProController?.removeList.add(removeItem.nodeName!);
                            electricityYearAnalysisProController?.itemsList.remove(removeItem.nodeName);
                          }
                          electricityYearAnalysisProController?.selectedGridItemsMapString['Source']?.clear();
                        }

                        // log("====All item in List===== ${electricityAnalysisProDayButtonController?.itemsList}");
                        electricityYearAnalysisProController?.update();
                      },
                    ),


                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Source",
                      color: electricityYearAnalysisProController!.checkboxGroupStates['source']?.any((e) => e) ?? true ? AppColors.primaryColor : AppColors.secondaryTextColor,
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
                      child: Scrollbar(
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
                              itemCount: electricityYearAnalysisProController!.electricityYearlyAnalysisProSourceList.length,


                              itemBuilder: (context, gridIndex) {
                                final nodeName = electricityYearAnalysisProController?.electricityYearlyAnalysisProSourceList[gridIndex].nodeName ?? "";

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: electricityYearAnalysisProController?.itemsList.contains(nodeName) ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        // Synchronize checkbox state with itemsList
                                        electricityYearAnalysisProController?.checkboxGroupStates['source']?[gridIndex] = value;

                                        // Ensure only the first item is checked if required
                                        if (gridIndex == 0) {
                                          electricityYearAnalysisProController!.checkboxGroupStates['source']?[gridIndex] = true;
                                        } else {
                                          electricityYearAnalysisProController!.checkboxGroupStates['source']?[gridIndex] = false;
                                        }

                                        // Update selected items and synchronize state
                                        electricityYearAnalysisProController?.updateSelectedGridItems('Source', nodeName, value);
                                        electricityYearAnalysisProController?.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    SizedBox(
                                      width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                      child: TextComponent(
                                        text: nodeName,
                                        color: electricityYearAnalysisProController?.checkboxGroupStates['source']?[gridIndex] ?? false
                                            ? AppColors.primaryColor
                                            : AppColors.secondaryTextColor,
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


//----------------------------------------------- Year Load -------------------------------
        electricityYearAnalysisProController!.electricityYearlyAnalysisProSourceList.isNotEmpty ?   SizedBox(height: size.height * k16TextSize,) : const SizedBox(),
        electricityYearAnalysisProController!.electricityYearlyAnalysisProLoadList.isNotEmpty ?
        Container(
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
                      initialValue: electricityYearAnalysisProController!.checkboxGroupStates['load']?.any((e) => e) ?? true,
                      checkedIcon: AssetsPath.checkboxIconSVG,
                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                      onChanged: (bool value) {
                        electricityYearAnalysisProController!.checkboxGroupStates['load'] ??= List.filled(1000, true);
                        electricityYearAnalysisProController!.toggleGroup('load', value);

                        if (value) {
                          for (var item in electricityYearAnalysisProController!.electricityYearlyAnalysisProLoadList) {
                            electricityYearAnalysisProController!.selectedGridItemsMapString['Load'] ??= [];
                            electricityYearAnalysisProController!.selectedGridItemsMapString['Load']!.add(item.nodeName!);

                            electricityYearAnalysisProController!.removeList.remove(item.nodeName!);
                            electricityYearAnalysisProController!.itemsList.add(item.nodeName!);
                          }
                        } else {
                          for(var removeItem in electricityYearAnalysisProController!.electricityYearlyAnalysisProLoadList){
                            electricityYearAnalysisProController!.removeList.add(removeItem.nodeName!);
                            electricityYearAnalysisProController!.itemsList.remove(removeItem.nodeName);
                          }

                          electricityYearAnalysisProController!.selectedGridItemsMapString['Load']?.clear();

                        }
                        electricityYearAnalysisProController!.update();
                      },
                    ),

                    SizedBox(width: size.width * k30TextSize),
                    TextComponent(
                      text: "Load",
                      color:  electricityYearAnalysisProController!.checkboxGroupStates['load']?.any((e) => e) ?? true ? AppColors.primaryColor :  AppColors.secondaryTextColor,
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
                      child: Scrollbar(
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
                              itemCount: electricityYearAnalysisProController!.electricityYearlyAnalysisProLoadList.length,
                              itemBuilder: (context, gridIndex) {
                                final nodeName = electricityYearAnalysisProController?.electricityYearlyAnalysisProLoadList[gridIndex].nodeName ?? "";

                                return Row(
                                  children: [
                                    CustomIconCheckbox(
                                      initialValue: electricityYearAnalysisProController?.itemsList.contains(nodeName) ?? true,
                                      checkedIcon: AssetsPath.checkboxIconSVG,
                                      uncheckedIcon: AssetsPath.uncheckedCheckboxIconSVG,
                                      onChanged: (bool value) {
                                        // Synchronize checkbox state with itemsList
                                        electricityYearAnalysisProController?.checkboxGroupStates['load']?[gridIndex] = value;

                                        // Ensure only the first item is checked if required
                                        if (gridIndex == 0) {
                                          electricityYearAnalysisProController?.checkboxGroupStates['load']?[gridIndex] = true;
                                        } else {
                                          electricityYearAnalysisProController?.checkboxGroupStates['load']?[gridIndex] = false;
                                        }

                                        // Update selected items and synchronize state
                                        electricityYearAnalysisProController?.updateSelectedGridItems('Load', nodeName, value);
                                        electricityYearAnalysisProController?.update();
                                      },
                                    ),
                                    SizedBox(width: size.width * k30TextSize),
                                    SizedBox(
                                      width: size.width > 600 ? size.width * 0.25 : size.width * 0.29,
                                      child: TextComponent(
                                        text: nodeName,
                                        color: electricityYearAnalysisProController?.checkboxGroupStates['load']?[gridIndex] ?? false
                                            ? AppColors.primaryColor
                                            : AppColors.secondaryTextColor,
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
    );

  }
}




