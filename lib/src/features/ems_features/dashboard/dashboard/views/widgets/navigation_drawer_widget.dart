import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/authentication/login/views/screen/login_screen.dart';
import 'package:nz_fabrics/src/features/authentication/logout/controller/logout_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/all_live_data/controllers/all_live_info_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/views/screens/analysis_pro_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/views/screens/diesel_generator_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/views/screens/gas_generator_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/get_button_from_all/controller/get_button_from_all_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/views/screens/water_process_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/find_power_value_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/load_power_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/source_power_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/find_water_value_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/load_water_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/source_water_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/generators/generator_element_details_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/power_and_energy_element_details_screen.dart';
import 'package:nz_fabrics/src/features/plant_over_view/view/screen/plant_over_view_screen.dart';
import 'package:nz_fabrics/src/features/profile/views/screens/profile_screen.dart';
import 'package:nz_fabrics/src/features/solar_feature/inverter_data/views/screens/inverter_data_screen.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/views/screen/module_cleaning_screen.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/solar_summary_screen.dart';
import 'package:nz_fabrics/src/features/source/electricity/views/screen/source_screen.dart';
import 'package:nz_fabrics/src/features/source/water_source/views/screen/water_source_screen.dart';
import 'package:nz_fabrics/src/features/summary_feature/views/screen/summary_screen.dart';
import 'package:nz_fabrics/src/features/user_management/views/screens/user_management_screen.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({
    super.key,
  });

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      //Get.find<SourcePowerController>().fetchSourcePowerData();
      Get.find<AllLiveInfoController>().fetchAllLiveData();
      Get.find<SourcePowerController>().fetchSourcePowerData().then((_){
        Future.delayed(const Duration(milliseconds: 2000),(){
          Get.find<FindPowerValueController>().fetchFindPowerData(
            nodeNameList: Get.find<SourcePowerController>().powerList.map((e) => e.nodeName ?? '').toList(),
          );
         });
        });

      Get.find<LoadPowerController>().fetchLoadPowerData().then((_){
        Future.delayed(const Duration(milliseconds: 2000),(){
          Get.find<FindPowerValueController>().fetchFindPowerData(
            nodeNameList: Get.find<SourcePowerController>().powerList.map((e) => e.nodeName ?? '').toList(),
          );
        });
      });


      // Get.find<SourceWaterController>().fetchSourceWaterData().then((_){
      //   Get.find<FindWaterValueController>().fetchFindWaterData(
      //     nodeNameList: Get.find<SourceWaterController>().waterList.map((e) => e.nodeName ?? '').toList(),
      //   );
      // });
      //
      // Get.find<LoadWaterController>().fetchLoadWaterData().then((_){
      //   Get.find<FindWaterValueController>().fetchFindWaterData(
      //     nodeNameList: Get.find<LoadWaterController>().waterList.map((e) => e.nodeName ?? '').toList(),
      //   );
      // });




      });


    super.initState();
  }


  List<SolarAnalysisListModel>solarAnalysisList = [
    SolarAnalysisListModel(AssetsPath.solarAnalysisIconSVG,"Solar Summary"),
    SolarAnalysisListModel(AssetsPath.inverterItemIconSVG,"Inverter Data"),
    SolarAnalysisListModel(AssetsPath.moduleCleaningItemIconSVG,"Module Cleaning"),

  ];

  List<SourceListModel>sourceList = [
    SourceListModel(AssetsPath.solarAnalysisIconSVG,"Electricity"),
    SourceListModel(AssetsPath.inverterItemIconSVG,"Water"),
  ];


  List<Button>buttonList = [
    Button(AssetsPath.analysisProIconSVG,"Analysis Pro"),
    Button(AssetsPath.dieselGeneratorIconSVG,"Water"),
  ];


  ScrollController sourceScrollController = ScrollController();
  ScrollController loadScrollController = ScrollController();
  ScrollController waterScrollController = ScrollController();
  ScrollController gasScrollController = ScrollController();
  ScrollController solarAnalysisScrollController = ScrollController();
  ScrollController analyticsDataController = ScrollController();
  ScrollController singleChildScrollController = ScrollController();
  ScrollController sourceElectricityScrollController = ScrollController();



  @override
  void dispose() {
    // Dispose all ScrollControllers to prevent memory leaks
    sourceScrollController.dispose();
    loadScrollController.dispose();
    waterScrollController.dispose();
    gasScrollController.dispose();
    solarAnalysisScrollController.dispose();
    analyticsDataController.dispose();
    singleChildScrollController.dispose();
    sourceElectricityScrollController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Drawer(
    backgroundColor: AppColors.backgroundColor ,
      child: LayoutBuilder(
        builder: (context, constraints) {
        //  log("Drawer width: ${constraints.maxWidth}");
        //  log("Drawer width: ${constraints.maxWidth * 0.6}");
          return SingleChildScrollView(
            controller: singleChildScrollController,
            child: Column(
              children: [
                SizedBox(height: size.height * k40TextSize,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AssetsPath.drawerIconSVG),
                    TextComponent(text: "NZ Fabrics",fontSize: size.height * k30TextSize,fontFamily: boldFontFamily,),
                  ],
                ),
                SizedBox(height: size.height * k20TextSize,),
                Container(
                    height: size.height * k40TextSize,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                    ),
                    child: Center(child: TextComponent(text: "Net Metering is Activated",fontSize: size.height * k18TextSize,color: AppColors.whiteTextColor,)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.height * k16TextSize, right : size.width * k16TextSize,top: size.height * k16TextSize, bottom: size.height * k8TextSize),
                  child: ListView(
                    controller: singleChildScrollController,
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.zero,
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(AssetsPath.dashboardIconSVG,height: size.height * k25TextSize,),
                            SizedBox(width:  size.width * k40TextSize),
                            TextComponent(
                              textScalar: const TextScaler.linear(0.9),
                              text: "Dashboard",fontSize: size.height * k18TextSize,fontWeight: FontWeight.normal,fontFamily: regularFontFamily,),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * k16TextSize,),
                      GestureDetector(
                        onTap: (){
                          Get.to(()=> const SummaryScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(AssetsPath.summaryIconSVG,height: size.height * k25TextSize,),
                            SizedBox(width:  size.width * k40TextSize),
                            TextComponent(
                              textScalar: const TextScaler.linear(0.9),
                              text: "Essential",fontSize: size.height * k18TextSize,fontWeight: FontWeight.normal,fontFamily: regularFontFamily,),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * k16TextSize,),

                      // GestureDetector(
                      //   onTap: (){
                      //     Get.to(()=> const SourceScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
                      //   },
                      //   child: Row(
                      //     children: [
                      //       SvgPicture.asset(AssetsPath.sourceEnergyCostItemIconSVG,height: size.height * k25TextSize,),
                      //       SizedBox(width:  size.width * k40TextSize),
                      //       TextComponent(text: "Source",fontSize: size.height * k18TextSize,fontWeight: FontWeight.normal,fontFamily: regularFontFamily,),
                      //     ],
                      //   ),
                      // ),


                      GestureDetector(
                        onTap: (){
                          Get.to(()=> const PlantOverViewScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
                          //Get.to(()=> const PlantImageScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(AssetsPath.plantOverViewIconSVG,height: size.height * k25TextSize,),
                            SizedBox(width:  size.width * k40TextSize),
                            TextComponent(
                              textScalar: const TextScaler.linear(0.9),
                              text: "Plant Layout",fontSize: size.height * k18TextSize,fontWeight: FontWeight.normal,fontFamily: regularFontFamily,),
                          ],
                        ),
                      ),

                      Theme(
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
                        child: ListTileTheme(
                          minVerticalPadding: 0,
                          contentPadding: const EdgeInsets.all(0),
                          dense: true,
                          horizontalTitleGap: 0.0,
                          minLeadingWidth: 0,

                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding:  EdgeInsets.zero,
                            dense: true,
                            title: Row(
                              children: [
                                SvgPicture.asset(AssetsPath.sourceEnergyCostIconSVG,height: size.height * k25TextSize,),
                                SizedBox(width:  size.width * k40TextSize),
                                // const Text('Source Energy & Cost'),
                                TextComponent(text: "Source",fontSize: size.height * k18TextSize,fontWeight: FontWeight.normal,fontFamily: regularFontFamily, textScalar: const TextScaler.linear(0.9),),
                              ],
                            ),
                            children: <Widget>[
                              Scrollbar(
                                thumbVisibility: true,
                                trackVisibility: true,
                                controller: sourceElectricityScrollController,
                                radius: Radius.circular(size.height * k20TextSize),
                                child: SizedBox(
                                  height: size.height * 0.08,

                                  child: Padding(
                                    padding: EdgeInsets.only(top: size.height * k16TextSize),
                                    child: ListView.separated(
                                      padding: EdgeInsets.only(left: size.height * k30TextSize),
                                      shrinkWrap: true,
                                      itemCount: sourceList.length,
                                      controller: sourceElectricityScrollController,
                                      itemBuilder: (context,index){
                                        return GestureDetector(
                                          onTap: (){
                                            if(index == 0){
                                              Get.to(()=> const SourceScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
                                            }
                                            else if(index == 1){
                                              Get.to(()=> const WaterSourceScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));


                                            }
                                            // else{
                                            //   Get.to(()=> const WaterSourceScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
                                            //  // Get.to(()=>  const InverterDataScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
                                            // }

                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(AssetsPath.sourceEnergyCostItemIconSVG,height: size.height * k25TextSize,),
                                                  SizedBox(width:  size.width * k40TextSize),
                                                   TextComponent(text: sourceList[index].name, textScalar:  TextScaler.linear(0.9),)
                                                ],
                                              ),




                                            ],
                                          ),
                                        );

                                      }, separatorBuilder: (context,index) => SizedBox(height: size.height * k16TextSize,), ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),





                 /*     Theme(
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
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          childrenPadding:  EdgeInsets.zero,
                          title: Row(
                            children: [
                              SvgPicture.asset(AssetsPath.sourceEnergyCostIconSVG,height: size.height * k25TextSize,),
                              SizedBox(width:  size.width * k40TextSize),
                              SizedBox(
                                  width: size.width >600 ? size.width * 0.2 :  constraints.maxWidth * .62,
                                  child: TextComponent(text: "Source Energy & Cost",fontSize: size.height * k18TextSize,fontWeight: FontWeight.normal,fontFamily: regularFontFamily,)),
                            ],
                          ),
                          children: <Widget>[
                            GetBuilder<SourcePowerController>(
                              builder: (sourcePowerController) {
                                return Scrollbar(
                                  thumbVisibility: true,
                                  trackVisibility: true,
                                  controller: sourceScrollController,
                                  radius: Radius.circular(size.height * k20TextSize),
                                  child: sourcePowerController.powerList.length < 5 ?
                                  Card(
                                    color: AppColors.backgroundColor,
                                    elevation: 0,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: size.height * k16TextSize),
                                      child:
                                             ListView.separated(
                                              controller: sourceScrollController,
                                              padding: EdgeInsets.only(left: size.height * k30TextSize),
                                              shrinkWrap: true,
                                              itemCount: sourcePowerController.powerList.length,
                                              itemBuilder: (context,index){
                                                return GestureDetector(
                                                  onTap: (){

                                                    if(sourcePowerController.powerList[index].sourceCategory == 'Diesel_Generator' || sourcePowerController.powerList[index].sourceCategory ==  'Gas_Generator'){
                                                      Get.to(()=> GeneratorElementDetailsScreen(elementName: sourcePowerController.powerList[index].nodeName ?? '',
                                                          gaugeValue:  Get.find<FindPowerValueController>().electricityValues[sourcePowerController.powerList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power'),
                                                          transition: Transition.rightToLeft
                                                      );
                                                    } else{
                                                      Get.to(()=> PowerAndEnergyElementDetailsScreen(
                                                          elementName: sourcePowerController.powerList[index].nodeName ?? '',
                                                          gaugeValue:  Get.find<FindPowerValueController>().electricityValues[sourcePowerController.powerList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power', solarCategory: Get.find<SourcePowerController>().powerList[index].sourceCategory ?? ''),
                                                          transition: Transition.rightToLeft

                                                      );
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(AssetsPath.sourceEnergyCostItemIconSVG,height: size.height * k25TextSize),
                                                      SizedBox(width:  size.width * k40TextSize),
                                                      TextComponent(text: sourcePowerController.powerList[index].nodeName ?? '')
                                                    ],
                                                  ),
                                                );

                                              }, separatorBuilder: (context,index) => SizedBox(height: size.height * k16TextSize,), ),

                                    ),
                                  )
                                      :SizedBox(
                                    height: size.height * 0.2,
                                //    color: AppColors.primaryColor.withOpacity(0.1),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: size.height * k16TextSize),
                                      child: ListView.separated(
                                        controller: sourceScrollController,
                                        padding: EdgeInsets.only(left: size.height * k30TextSize),
                                        shrinkWrap: true,
                                        itemCount: sourcePowerController.powerList.length,
                                        itemBuilder: (context,index){
                                          return GestureDetector(
                                            onTap: (){

                                              if(sourcePowerController.powerList[index].sourceCategory == 'Diesel_Generator' || sourcePowerController.powerList[index].sourceCategory ==  'Gas_Generator'){
                                                Get.to(()=> GeneratorElementDetailsScreen(elementName: sourcePowerController.powerList[index].nodeName ?? '',
                                                    gaugeValue:  Get.find<FindPowerValueController>().electricityValues[sourcePowerController.powerList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power'),
                                                    transition: Transition.rightToLeft,duration: const Duration(seconds: 1)
                                                );
                                              } else{
                                                Get.to(()=> PowerAndEnergyElementDetailsScreen(
                                                    elementName: sourcePowerController.powerList[index].nodeName ?? '',
                                                    gaugeValue:  Get.find<FindPowerValueController>().electricityValues[sourcePowerController.powerList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power', solarCategory: Get.find<SourcePowerController>().powerList[index].sourceCategory ?? ''),
                                                    transition: Transition.rightToLeft,duration: const Duration(seconds: 1)

                                                );
                                              }

                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(AssetsPath.sourceEnergyCostItemIconSVG,height: size.height * k25TextSize),
                                                SizedBox(width:  size.width * k40TextSize),
                                                TextComponent(text: sourcePowerController.powerList[index].nodeName ?? '')
                                              ],
                                            ),
                                          );

                                        }, separatorBuilder: (context,index) => SizedBox(height: size.height * k16TextSize,), ),

                                    ),
                                  ),
                                );
                              }
                            )
                          ],
                        ),
                      ),

                      Theme(
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
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          childrenPadding:  EdgeInsets.zero,
                          title: Row(
                            children: [
                              SvgPicture.asset(AssetsPath.drawerLoadIconSVG,height: size.height * k25TextSize,),
                              SizedBox(width:  size.width * k40TextSize),
                              // const Text('Source Energy & Cost'),
                              SizedBox(
                                  width: size.width >600 ? size.width * 0.2 : constraints.maxWidth * .62,
                                  child: TextComponent(text: "Load Energy & Cost",fontSize: size.height * k18TextSize,fontWeight: FontWeight.normal,fontFamily: regularFontFamily,)),
                            ],
                          ),
                          children: <Widget>[
                            GetBuilder<LoadPowerController>(
                              builder: (loadPowerController) {
                                return Scrollbar(
                                  thumbVisibility: true,
                                  trackVisibility: true,
                                  controller: loadScrollController,
                                  radius: Radius.circular(size.height * k20TextSize),
                                  child: loadPowerController.powerList.length < 5 ?
                                  Card(
                                    color: AppColors.backgroundColor,
                                    elevation: 0,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: size.height * k16TextSize),
                                      child:
                                      ListView.separated(
                                        controller: loadScrollController,
                                        padding: EdgeInsets.only(left: size.height * k30TextSize),
                                        shrinkWrap: true,
                                        itemCount: loadPowerController.powerList.length,
                                        itemBuilder: (context,index){
                                          return GestureDetector(
                                            onTap: (){

                                              if(loadPowerController.powerList[index].sourceCategory == 'Diesel_Generator' || loadPowerController.powerList[index].sourceCategory ==  'Gas_Generator'){
                                                Get.to(()=> GeneratorElementDetailsScreen(elementName: loadPowerController.powerList[index].nodeName ?? '',
                                                    gaugeValue:  Get.find<FindPowerValueController>().electricityValues[loadPowerController.powerList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power'),
                                                    transition: Transition.rightToLeft
                                                );
                                              } else{
                                                Get.to(()=> PowerAndEnergyElementDetailsScreen(
                                                    elementName: loadPowerController.powerList[index].nodeName ?? '',
                                                    gaugeValue:  Get.find<FindPowerValueController>().electricityValues[loadPowerController.powerList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power', solarCategory: Get.find<SourcePowerController>().powerList[index].sourceCategory ?? ''),
                                                    transition: Transition.rightToLeft

                                                );
                                              }

                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(AssetsPath.sourceEnergyCostItemIconSVG,height: size.height * k25TextSize),
                                                SizedBox(width:  size.width * k40TextSize),
                                                TextComponent(text: loadPowerController.powerList[index].nodeName ?? '')
                                              ],
                                            ),
                                          );

                                        }, separatorBuilder: (context,index) => SizedBox(height: size.height * k16TextSize,), ),

                                    ),
                                  )
                                      :SizedBox(
                                  height: size.height * 0.2,
                                  //    color: AppColors.primaryColor.withOpacity(0.1),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: size.height * k16TextSize),
                                    child: ListView.separated(
                                      controller: loadScrollController,
                                      padding: EdgeInsets.only(left: size.height * k30TextSize),
                                      shrinkWrap: true,
                                      itemCount: loadPowerController.powerList.length,
                                      itemBuilder: (context,index){
                                        return GestureDetector(
                                          onTap: (){

                                            Get.to(()=> PowerAndEnergyElementDetailsScreen(
                                                elementName: loadPowerController.powerList[index].nodeName ?? '',
                                                gaugeValue:  Get.find<FindPowerValueController>().electricityValues[loadPowerController.powerList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power', solarCategory: Get.find<SourcePowerController>().powerList[index].sourceCategory ?? ''),
                                                transition: Transition.rightToLeft,duration: const Duration(seconds: 1));

                                          },
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(AssetsPath.sourceEnergyCostItemIconSVG,height: size.height * k25TextSize),
                                              SizedBox(width:  size.width * k40TextSize),
                                              TextComponent(text: loadPowerController.powerList[index].nodeName ?? '')
                                            ],
                                          ),
                                        );

                                      }, separatorBuilder: (context,index) => SizedBox(height: size.height * k16TextSize,), ),

                                  ),
                                                                ),

                                );
                              }
                            )
                          ],
                        ),
                      ),*/


               /*       if(Get.find<SourceWaterController>().waterList.isNotEmpty)...{
                        Theme(
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
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding:  EdgeInsets.zero,
                            title: Row(
                              children: [
                                SvgPicture.asset(AssetsPath.waterItemIconSVG,height: size.height * k25TextSize,),
                                SizedBox(width:  size.width * k40TextSize),
                                SizedBox(
                                    width: size.width >500 ? size.width * 0.2 :  constraints.maxWidth * .62,
                                    child: TextComponent(
                                      textScalar: const TextScaler.linear(0.9),
                                      text: "Water Source and Cost",fontSize: size.height * k18TextSize,fontWeight: FontWeight.normal,fontFamily: regularFontFamily,overflow: TextOverflow.ellipsis,maxLines: 1,)),
                              ],
                            ),
                            children: <Widget>[
                              GetBuilder<SourceWaterController>(
                                  builder: (sourceWaterController) {
                                    return Scrollbar(
                                      thumbVisibility: true,
                                      trackVisibility: true,
                                      controller: waterScrollController,
                                      radius: Radius.circular(size.height * k20TextSize),
                                      child: sourceWaterController.waterList.length < 5 ?
                                      Card(
                                        color: AppColors.backgroundColor,
                                        elevation: 0,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: size.height * k16TextSize),
                                          child:
                                          ListView.separated(
                                            controller: waterScrollController,
                                            padding: EdgeInsets.only(left: size.height * k30TextSize),
                                            shrinkWrap: true,
                                            itemCount: sourceWaterController.waterList.length,
                                            itemBuilder: (context,index){
                                              return GestureDetector(
                                                onTap: (){
                                                  if(sourceWaterController.waterList[index].sourceCategory == 'Diesel_Generator' || sourceWaterController.waterList[index].sourceCategory ==  'Gas_Generator'){
                                                    Get.to(()=> GeneratorElementDetailsScreen(elementName: sourceWaterController.waterList[index].nodeName ?? '',
                                                        gaugeValue:  Get.find<FindPowerValueController>().electricityValues[sourceWaterController.waterList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power'),
                                                        transition: Transition.rightToLeft
                                                    );
                                                  } else{
                                                    Get.to(()=> PowerAndEnergyElementDetailsScreen(
                                                        elementName: sourceWaterController.waterList[index].nodeName ?? '',
                                                        gaugeValue:  Get.find<FindPowerValueController>().electricityValues[sourceWaterController.waterList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power', solarCategory: Get.find<SourcePowerController>().powerList[index].sourceCategory ?? ''),
                                                        transition: Transition.rightToLeft

                                                    );
                                                  }

                                                },
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(AssetsPath.sourceEnergyCostItemIconSVG,height: size.height * k25TextSize),
                                                    SizedBox(width:  size.width * k40TextSize),
                                                    TextComponent(text: sourceWaterController.waterList[index].nodeName ?? '', textScalar: const TextScaler.linear(0.9),)
                                                  ],
                                                ),
                                              );

                                            }, separatorBuilder: (context,index) => SizedBox(height: size.height * k16TextSize,), ),

                                        ),
                                      )
                                          :SizedBox(
                                        height: size.height * 0.2,
                                        //    color: AppColors.primaryColor.withOpacity(0.1),
                                        child: Padding(
                                          padding: EdgeInsets.only(top: size.height * k16TextSize),
                                          child: ListView.separated(
                                            controller: waterScrollController,
                                            padding: EdgeInsets.only(left: size.height * k30TextSize),
                                            shrinkWrap: true,
                                            itemCount: sourceWaterController.waterList.length,
                                            itemBuilder: (context,index){
                                              return GestureDetector(
                                                onTap: (){

                                                  if(sourceWaterController.waterList[index].sourceCategory == 'Diesel_Generator' || sourceWaterController.waterList[index].sourceCategory ==  'Gas_Generator'){
                                                    Get.to(()=> GeneratorElementDetailsScreen(elementName: sourceWaterController.waterList[index].nodeName ?? '',
                                                        gaugeValue:  Get.find<FindPowerValueController>().electricityValues[sourceWaterController.waterList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power'),
                                                        transition: Transition.rightToLeft,duration: const Duration(seconds: 1)
                                                    );
                                                  } else{
                                                    Get.to(()=> PowerAndEnergyElementDetailsScreen(
                                                        elementName: sourceWaterController.waterList[index].nodeName ?? '',
                                                        gaugeValue:  Get.find<FindPowerValueController>().electricityValues[sourceWaterController.waterList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power', solarCategory: Get.find<SourcePowerController>().powerList[index].sourceCategory ?? ''),
                                                        transition: Transition.rightToLeft,duration: const Duration(seconds: 1)

                                                    );
                                                  }

                                                },
                                                child: Row(
                                                  children: [
                                                    SvgPicture.asset(AssetsPath.sourceEnergyCostItemIconSVG,height: size.height * k25TextSize),
                                                    SizedBox(width:  size.width * k40TextSize),
                                                    TextComponent(text: sourceWaterController.waterList[index].nodeName ?? '', textScalar: const TextScaler.linear(0.9),)
                                                  ],
                                                ),
                                              );

                                            }, separatorBuilder: (context,index) => SizedBox(height: size.height * k16TextSize,), ),

                                        ),
                                      ),
                                    );
                                  }
                              )
                            ],
                          ),
                        ),
                      }else...{
                        const SizedBox(),
                      },

                      if(Get.find<SourceWaterController>().waterList.isNotEmpty)...{
                        Theme(
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
                          child: ListTileTheme(
                            minVerticalPadding: 0,
                            contentPadding: const EdgeInsets.all(0),
                            dense: true,
                            horizontalTitleGap: 0.0,
                            minLeadingWidth: 0,
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.zero,
                              childrenPadding:  EdgeInsets.zero,
                              title: Row(
                                children: [
                                  SvgPicture.asset(AssetsPath.waterItemIconSVG,height: size.height * k25TextSize,),
                                  SizedBox(width:  size.width * k40TextSize),
                                  SizedBox(
                                      width: size.width >500 ? size.width * 0.2 :  constraints.maxWidth * .62,
                                      child: TextComponent(
                                        textScalar: const TextScaler.linear(0.9),
                                        text: "Water Load and Cost",fontSize: size.height * k18TextSize,fontWeight: FontWeight.normal,fontFamily: regularFontFamily,)),
                                ],
                              ),
                              children: <Widget>[
                                GetBuilder<LoadWaterController>(
                                    builder: (loadWaterController) {
                                      return Scrollbar(
                                        thumbVisibility: true,
                                        trackVisibility: true,
                                        controller: waterScrollController,
                                        radius: Radius.circular(size.height * k20TextSize),
                                        child: loadWaterController.waterList.length < 5 ?
                                        Card(
                                          color: AppColors.backgroundColor,
                                          elevation: 0,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: size.height * k16TextSize),
                                            child:
                                            ListView.separated(
                                              controller: waterScrollController,
                                              padding: EdgeInsets.only(left: size.height * k30TextSize),
                                              shrinkWrap: true,
                                              itemCount: loadWaterController.waterList.length,
                                              itemBuilder: (context,index){
                                                return GestureDetector(
                                                  onTap: (){
                                                    if(loadWaterController.waterList[index].sourceCategory == 'Diesel_Generator' || loadWaterController.waterList[index].sourceCategory ==  'Gas_Generator'){
                                                      Get.to(()=> GeneratorElementDetailsScreen(elementName: loadWaterController.waterList[index].nodeName ?? '',
                                                          gaugeValue:  Get.find<FindPowerValueController>().electricityValues[loadWaterController.waterList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power'),
                                                          transition: Transition.rightToLeft
                                                      );
                                                    } else{
                                                      Get.to(()=> PowerAndEnergyElementDetailsScreen(
                                                          elementName: loadWaterController.waterList[index].nodeName ?? '',
                                                          gaugeValue:  Get.find<FindPowerValueController>().electricityValues[loadWaterController.waterList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power', solarCategory: Get.find<SourcePowerController>().powerList[index].sourceCategory ?? ''),
                                                          transition: Transition.rightToLeft

                                                      );
                                                    }

                                                  },
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(AssetsPath.sourceEnergyCostItemIconSVG,height: size.height * k25TextSize),
                                                      SizedBox(width:  size.width * k40TextSize),
                                                      TextComponent(text: loadWaterController.waterList[index].nodeName ?? '', textScalar: const TextScaler.linear(0.9),)
                                                    ],
                                                  ),
                                                );

                                              }, separatorBuilder: (context,index) => SizedBox(height: size.height * k16TextSize,), ),

                                          ),
                                        )
                                            :SizedBox(
                                          height: size.height * 0.2,
                                          //    color: AppColors.primaryColor.withOpacity(0.1),
                                          child: Padding(
                                            padding: EdgeInsets.only(top: size.height * k16TextSize),
                                            child: ListView.separated(
                                              controller: waterScrollController,
                                              padding: EdgeInsets.only(left: size.height * k30TextSize),
                                              shrinkWrap: true,
                                              itemCount: loadWaterController.waterList.length,
                                              itemBuilder: (context,index){
                                                return GestureDetector(
                                                  onTap: (){

                                                    if(loadWaterController.waterList[index].sourceCategory == 'Diesel_Generator' || loadWaterController.waterList[index].sourceCategory ==  'Gas_Generator'){
                                                      Get.to(()=> GeneratorElementDetailsScreen(elementName: loadWaterController.waterList[index].nodeName ?? '',
                                                          gaugeValue:  Get.find<FindPowerValueController>().electricityValues[loadWaterController.waterList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power'),
                                                          transition: Transition.rightToLeft,duration: const Duration(seconds: 1)
                                                      );
                                                    } else{
                                                      Get.to(()=> PowerAndEnergyElementDetailsScreen(
                                                          elementName: loadWaterController.waterList[index].nodeName ?? '',
                                                          gaugeValue:  Get.find<FindPowerValueController>().electricityValues[loadWaterController.waterList[index].nodeName ?? '']?.power ?? 0.00, gaugeUnit: 'kW', elementCategory: 'Power', solarCategory: Get.find<SourcePowerController>().powerList[index].sourceCategory ?? ''),
                                                          transition: Transition.rightToLeft,duration: const Duration(seconds: 1)

                                                      );
                                                    }

                                                  },
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(AssetsPath.sourceEnergyCostItemIconSVG,height: size.height * k25TextSize),
                                                      SizedBox(width:  size.width * k40TextSize),
                                                      TextComponent(text: loadWaterController.waterList[index].nodeName ?? '', textScalar: const TextScaler.linear(0.9),)
                                                    ],
                                                  ),
                                                );

                                              }, separatorBuilder: (context,index) => SizedBox(height: size.height * k16TextSize,), ),

                                          ),
                                        ),
                                      );
                                    }
                                )
                              ],
                            ),
                          ),
                        ),
                      }else...{
                        const SizedBox(),
                      },*/








                     /* Theme(
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
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          childrenPadding:  EdgeInsets.zero,
                          title: Row(
                            children: [
                              SvgPicture.asset(AssetsPath.sourceEnergyCostIconSVG,height: size.height * k25TextSize,),
                              SizedBox(width:  size.width * k40TextSize),
                              TextComponent(text: "All BusBar",fontSize: size.height * k18TextSize,fontWeight: FontWeight.normal,fontFamily: regularFontFamily,),
                            ],
                          ),
                          children: <Widget>[
                            Scrollbar(
                              thumbVisibility: true,
                              trackVisibility: true,
                              controller: sourceScrollController,
                              radius: Radius.circular(size.height * k20TextSize),
                              child: SizedBox(
                                height: size.height * 0.2,
                                //    color: AppColors.primaryColor.withOpacity(0.1),
                                child: Padding(
                                  padding: EdgeInsets.only(top: size.height * k16TextSize),
                                  child: GetBuilder<AllLiveInfoController>(
                                      builder: (allLiveInfoController) {
                                        return ListView.separated(
                                          controller: sourceScrollController,
                                          padding: EdgeInsets.only(left: size.height * k30TextSize),
                                          shrinkWrap: true,
                                          itemCount: allLiveInfoController.allLiveInfoList.length,
                                          itemBuilder: (context,index){
                                            return GestureDetector(
                                              onTap: (){
                                            //  Get.to(()=> AllBusBarScreen(busBarName:allLiveInfoController.allLiveInfoList[index].nodeName ?? '',),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));

                                              },
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(AssetsPath.sourceEnergyCostItemIconSVG,height: size.height * k25TextSize),
                                                  SizedBox(width:  size.width * k40TextSize),
                                                  TextComponent(text: allLiveInfoController.allLiveInfoList[index].nodeName ?? '')
                                                ],
                                              ),
                                            );

                                          }, separatorBuilder: (context,index) => SizedBox(height: size.height * k16TextSize,), );
                                      }
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),*/

           /* ----------------------  Solar Summary  ----------------------- */
                    /*  Theme(
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
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          childrenPadding:  EdgeInsets.zero,
                          title: Row(
                            children: [
                              SvgPicture.asset(AssetsPath.solarAnalysisIconSVG,height: size.height * k25TextSize,),
                              SizedBox(width:  size.width * k40TextSize),
                              // const Text('Source Energy & Cost'),
                              Expanded(
                                child: TextComponent(
                                  text: "Solar Analysis",
                                  fontSize: size.height * k18TextSize,
                                  fontWeight: FontWeight.normal,fontFamily: regularFontFamily,
                                ),
                              ),
                            ],
                          ),
                          children: <Widget>[
                            Scrollbar(
                              thumbVisibility: true,
                              trackVisibility: true,
                              controller: solarAnalysisScrollController,
                              radius: Radius.circular(size.height * k20TextSize),
                              child: SizedBox(
                                height: size.height * 0.135,

                                child: Padding(
                                  padding: EdgeInsets.only(top: size.height * k16TextSize),
                                  child: ListView.separated(
                                    padding: EdgeInsets.only(left: size.height * k30TextSize),
                                    shrinkWrap: true,
                                    itemCount: solarAnalysisList.length,
                                    controller: solarAnalysisScrollController,
                                    itemBuilder: (context,index){
                                      return GestureDetector(
                                        onTap: (){
                                           if(index == 0){
                                          //   Get.to(()=> const SolarSummaryScreen());
                                             Get.to(()=> const SolarSummaryScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
                                           //  Navigator.pop(context);
                                           }
                                           else if(index == 2){
                                             Get.to(()=> const ModuleCleaningScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));


                                           }else{
                                             Get.to(()=>  const InverterDataScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
                                           }

                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(solarAnalysisList[index].image,height: size.height * k25TextSize),
                                            SizedBox(width:  size.width * k40TextSize),
                                            Expanded(
                                              child: TextComponent(
                                                text: solarAnalysisList[index].name,
                                                overflow: TextOverflow.ellipsis,maxLines: 1,
                                              ),
                                            )
                                          ],
                                        ),
                                      );

                                    }, separatorBuilder: (context,index) => SizedBox(height: size.height * k16TextSize,), ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),*/

                     // SizedBox(height: size.height * k8TextSize,),
                      Theme(
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
                        child: ListTileTheme(
                          minVerticalPadding: 0,
                          contentPadding: const EdgeInsets.all(0),
                          dense: true,
                          horizontalTitleGap: 0.0,
                          minLeadingWidth: 0,
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding:  EdgeInsets.zero,
                            title: Row(
                              children: [
                                SvgPicture.asset(AssetsPath.analyticsDataIconSVG,height: size.height * k25TextSize,),
                                SizedBox(width:  size.width * k40TextSize),
                                // const Text('Source Energy & Cost'),
                                Expanded(
                                  child: TextComponent(
                                    text: "Analytics Data",
                                    fontSize: size.height * k18TextSize,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: regularFontFamily,
                                    
                                  ),
                                ),
                              ],
                            ),
                            children: <Widget>[
                              Scrollbar(
                                thumbVisibility: true,
                                trackVisibility: true,
                                controller: analyticsDataController,
                                radius: Radius.circular(size.height * k20TextSize),
                                child: SizedBox(
                                  height: size.height * 0.100,

                                  child: Padding(
                                    padding: EdgeInsets.only(top: size.height * k16TextSize),
                                    child: GetBuilder<GetButtonFromAllController>(
                                      builder: (getButtonFromAllController) {

                                        log("------> ${getButtonFromAllController.uniqueDataList.length}");

                                        return ListView.separated(
                                          padding: EdgeInsets.only(left: size.height * k30TextSize),
                                          shrinkWrap: true,
                                          itemCount: getButtonFromAllController.uniqueDataList.length,
                                          controller: analyticsDataController,
                                          itemBuilder: (context, index) {
                                            String currentItem = getButtonFromAllController.uniqueDataList[index];

                                            String imagePath;
                                            switch (currentItem) {
                                              case "Analysis Pro":
                                                imagePath = AssetsPath.analysisProIconSVG;
                                                break;
                                              case "Water":
                                                imagePath = AssetsPath.waterIconSVG;
                                                break;
                                              case "Diesel_Generator":
                                                imagePath = AssetsPath.dieselGeneratorIconSVG;
                                                break;
                                              case "Gas_Generator":
                                                imagePath = AssetsPath.gasGeneratorIconSVG;
                                                break;
                                              default:
                                                imagePath = '';
                                            }

                                            return GestureDetector(
                                              onTap: () {
                                                if (currentItem == "Analysis Pro") {
                                                  Get.to(() => const AnalysisProScreen(buttonName: "Analysis Pro"), transition: Transition.rightToLeft, duration: const Duration(seconds: 1));
                                                } else if (currentItem == "Water") {
                                                  Get.to(() => const WaterGeneratorScreen(), transition: Transition.rightToLeft, duration: const Duration(seconds: 1));
                                                }else if (currentItem == "Diesel_Generator") {
                                                  Get.to(() => const DieselGeneratorScreen(), transition: Transition.rightToLeft, duration: const Duration(seconds: 1));
                                                }
                                                else if (currentItem == "Gas_Generator") {
                                                  Get.to(() => const GasGeneratorButtonScreen(), transition: Transition.rightToLeft, duration: const Duration(seconds: 1));
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    imagePath,
                                                    height: size.height * k25TextSize,
                                                  ),
                                                  SizedBox(width: size.width * k40TextSize),
                                                  Expanded(
                                                    child: TextComponent(
                                                      text: currentItem,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, index) => SizedBox(height: size.height * k16TextSize),
                                        );
                                      }
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),


                      //SizedBox(height: size.height * k8TextSize,),

                      // GestureDetector(
                      //   onTap: (){
                      //     Get.to(()=> const RoomEnvironmentScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
                      //   },
                      //   child: Row(
                      //     children: [
                      //       SvgPicture.asset(AssetsPath.roomEnvironmentIconSVG,height: size.height * k25TextSize,),
                      //       SizedBox(width:  size.width * k40TextSize),
                      //       SizedBox(
                      //           width: size.width >600 ? size.width * 0.20 :  size.width * 0.48,
                      //           child: TextComponent(text: "Room Environment",fontSize: size.height * k18TextSize,fontWeight: FontWeight.normal,fontFamily: regularFontFamily,)),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: size.height * k20TextSize,),

                      if(AuthUtilityController.userRole == 'super_admin' || AuthUtilityController.userRole == 'admin')
                        GestureDetector(
                          onTap: (){

                            Get.to(() => const UserManagementScreen(), transition: Transition.rightToLeft, duration: const Duration(seconds: 1));


                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(AssetsPath.userManagementIconSVG,height: size.height * k25TextSize,),
                              SizedBox(width:  size.width * k40TextSize),
                              Expanded(
                                child: TextComponent(
                                  text: "User Management",fontSize: size.height * k18TextSize,fontWeight: FontWeight.normal,fontFamily: regularFontFamily,),
                              ),
                            ],
                          ),
                        ),

                      (AuthUtilityController.userRole == 'super_admin' || AuthUtilityController.userRole == 'admin') ? SizedBox(height: size.height * k20TextSize,) : const SizedBox(),
                      GestureDetector(
                        onTap: (){
                          Get.to(()=> const ProfileScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));

                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(AssetsPath.profileIconSVG,height: size.height * k25TextSize,),
                            SizedBox(width:  size.width * k40TextSize),
                            TextComponent(
                              text: "Profile",fontSize: size.height * k18TextSize,fontWeight: FontWeight.normal,fontFamily: regularFontFamily,),
                          ],
                        ),
                      ),


                      SizedBox(height: size.height * 0.07,),
                      const Divider(color: AppColors.primaryTextColor,thickness: 1.5,),
                      GestureDetector(
                        onTap: (){
                          _showLogoutDialog(context,size);
                         // AuthUtilityController.clearInfo();
                          // Get.to(()=>LoginScreen(),transition: Transition.fadeIn,duration: const Duration(seconds: 1));
                        },
                        child: Row(
                          children: [
                           Icon(Icons.logout,size: size.height * k25TextSize,),
                            SizedBox(width:  size.width * k40TextSize),
                            TextComponent(text: "Log out",fontSize: size.height * k20TextSize,fontWeight: FontWeight.bold,fontFamily: regularFontFamily,),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * k24TextSize,),
                      SizedBox(
                        // width: 250.0,
                        child: DefaultTextStyle(
                          style:  GoogleFonts.kavivanar(color:AppColors.primaryTextColor,fontSize: size.height * k16TextSize,fontWeight: FontWeight.w600 ),
                          child: AnimatedTextKit(
                            repeatForever: false,
                            pause: const Duration(seconds: 5),
                            animatedTexts: [
                              TyperAnimatedText('Powered by Scube Technologies Ltd.',
                                  textStyle: const TextStyle(color: AppColors.primaryColor)
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * k20TextSize,),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }


  void _showLogoutDialog(BuildContext context,Size size) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.height * k8TextSize),
          ),
          title: Align(
            alignment: Alignment.center,
            child: Container(
              transform: Matrix4.translationValues(0, -size.height * k25TextSize, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AssetsPath.alertIconSVG,height: size.height * 0.045,),
                  SizedBox(height: size.height * k10TextSize),
                  TextComponent(
                    text: "Do you want to Logout?",
                    color: AppColors.primaryColor,
                    fontSize: size.height * k22TextSize,
                    fontFamily: semiBoldFontFamily,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.whiteTextColor,
                    minimumSize: size.height < smallScreenWidth ?   Size(size.width * 0.025, size.height * 0.070) : Size(size.width * 0.025, size.height * 0.050),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: size.height * k16TextSize,
                    ),
                  ),
                ),
                SizedBox(width: size.width *k16TextSize,),
                GetBuilder<LogoutController>(
                  builder: (logoutController) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        minimumSize: size.height < smallScreenWidth ?   Size(size.width * 0.025, size.height * 0.070) : Size(size.width * 0.025, size.height * 0.050),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () async{
                    
                        final response = await logoutController.logout(refreshToken: AuthUtilityController.refreshToken ?? '');
                        // final response = await logoutController.logout();
                         if(response){
                    
                           Get.offAll(()=> LoginScreen(),transition: Transition.fadeIn,duration: const Duration(milliseconds: 100));
                           await AuthUtilityController.clearInfo();
                           AuthUtilityController.accessTokenForApiCall.value = null;
                         }
                    
                      },
                      child:logoutController.isLogoutInProgress ?  SizedBox(
                          height: size.height * k20TextSize,
                          width: size.height * k20TextSize,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: size.height * 0.004,
                          )) : Text(
                        "Logout",
                        style: TextStyle(
                          color: AppColors.whiteTextColor,
                          fontSize: size.height * k16TextSize,
                        ),
                      ),
                    );
                  }
                ),
              ],
            ),
          ],
        );
      },
    );
  }



/*  void _checkUserDialog(BuildContext context,Size size) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.height * k8TextSize),
          ),
          title: Align(
            alignment: Alignment.center,
            child: Container(
              transform: Matrix4.translationValues(0, -size.height * k25TextSize, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AssetsPath.alertIconSVG,height: size.height * 0.045,),
                  SizedBox(height: size.height * k10TextSize),
                  TextComponent(
                    text: "You are just a user.",
                    color: Colors.red,
                    fontSize: size.height * k20TextSize,
                    fontFamily: semiBoldFontFamily,
                  ),
                ],
              ),
            ),
          ),
          content: Padding(
            padding: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize,bottom: size.height * k8TextSize),
            child: const TextComponent(text: "Only Higher Authority can access this part.",maxLines: 2,color: AppColors.primaryColor,),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: size.height < smallScreenHeight ?   Size(size.width * 0.04, size.height * 0.060) : Size(size.width * 0.04, size.height * 0.040),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Ok",
                  style: TextStyle(
                      color: AppColors.whiteTextColor,
                      fontSize: size.height * k16TextSize,
                      fontFamily: boldFontFamily
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }*/





}

class SolarAnalysisListModel {
   final String image;
   final String name;

  SolarAnalysisListModel(this.image, this.name);
}

class SourceListModel {
  final String image;
  final String name;

  SourceListModel(this.image, this.name);
}

class Button {
  final String image;
  final String buttonName;

  Button(this.image, this.buttonName);
}