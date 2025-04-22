import 'package:animations/animations.dart';
import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/dash_board_radio_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/color_palette_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/machine_view_names_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_source_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/find_water_value_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/load_water_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/pie_chart_water_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/pie_chart_water_source_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/source_water_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/views/widgets/pie_chart_water_load_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/views/widgets/pie_chart_water_source_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/water/water_element_details_screen.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WaterSummaryChartScreen extends StatefulWidget {
  const WaterSummaryChartScreen({super.key});

  @override
  State<WaterSummaryChartScreen> createState() => _WaterSummaryChartScreenState();
}

class _WaterSummaryChartScreenState extends State<WaterSummaryChartScreen> {


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      /*------------- Start Api in Water ---------------*/
      Get.find<SourceWaterController>().startApiCallOnScreenChange();
      Get.find<LoadWaterController>().startApiCallOnScreenChange();
      Get.find<PieChartWaterSourceController>().startApiCallOnScreenChange();
      Get.find<PieChartWaterLoadController>().startApiCallOnScreenChange();
      /*------------- Stop Api in Water ---------------*/
      Get.find<PieChartPowerSourceController>().stopApiCallOnScreenChange();
      Get.find<PieChartPowerLoadController>().stopApiCallOnScreenChange();
      Get.find<CategoryWiseLiveDataController>().stopApiCallOnScreenChange();
      Get.find<MachineViewNamesDataController>().stopApiCallOnScreenChange();





     Get.find<SourceWaterController>().fetchSourceWaterData().then((_){

         Get.find<FindWaterValueController>().fetchFindWaterData(
           nodeNameList: Get.find<SourceWaterController>().waterList.map((e) => e.nodeName ?? '').toList(),
            );

     });

     Get.find<LoadWaterController>().fetchLoadWaterData().then((_){
       Future.delayed(const Duration(seconds: 1),(){
         Get.find<FindWaterValueController>().fetchFindWaterData(
           nodeNameList: Get.find<LoadWaterController>().waterList.map((e) => e.nodeName ?? '').toList(),
            );
       });
     });





    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async{
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.find<SourceWaterController>().fetchSourceWaterData().then((_){
              Get.find<FindWaterValueController>().fetchFindWaterData(
                nodeNameList: Get.find<SourceWaterController>().waterList.map((e) => e.nodeName ?? '').toList(),
              );
            });

            Get.find<LoadWaterController>().fetchLoadWaterData().then((_){
                Get.find<FindWaterValueController>().fetchFindWaterData(
                  nodeNameList: Get.find<LoadWaterController>().waterList.map((e) => e.nodeName ?? '').toList(),
                );
            });
          });
        },
        child: Column(
          children: [
            GetBuilder<DashBoardRadioButtonController>(
                builder: (dashBoardRadioButtonController) {
                  return SizedBox(height: size.height * .2, child: dashBoardRadioButtonController.selectedSourceLoadValue == 1 ? const PieChartWaterSourceWidget() :const PieChartWaterLoadWidget());
                }
            ),

            GetBuilder<DashBoardRadioButtonController>(
                builder: (dashBoardRadioButtonController) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomRectangularRadioButton<int>(
                        value: 1,
                        groupValue: dashBoardRadioButtonController.selectedSourceLoadValue,
                        onChanged: (value) {
                          dashBoardRadioButtonController.updateSourceLoadSelectedValue(value!);
                          dashBoardRadioButtonController.update();
                          // Get.find<SourceWaterController>().fetchSourceWaterData();
                      //    Get.find<PieChartWaterSourceController>().fetchPieChartData();
                        },
                        label: 'Source',
                      ),
                      CustomRectangularRadioButton<int>(
                        value: 2,
                        groupValue: dashBoardRadioButtonController.selectedSourceLoadValue,
                        onChanged: (value) {
                          dashBoardRadioButtonController.updateSourceLoadSelectedValue(value!);
                          dashBoardRadioButtonController.update();
                          // Get.find<LoadWaterController>().fetchLoadWaterData();
                        },
                        label: 'Consumer',
                      ),
                    ],
                  );
                }
            ),
            Padding(
              padding: EdgeInsets.symmetric( horizontal: size.height * k16TextSize),
              child: const Divider(thickness: 3,),
            ),
            GetBuilder<SourceWaterController>(
                builder: (controller) {
                  if(controller.hasError){
                    return Lottie.asset(AssetsPath.errorJson, height: size.height * 0.25);
                  }
                  return GetBuilder<DashBoardRadioButtonController>(
                      builder: (dashBoardRadioButtonController) {
                        return Expanded(
                          child: Padding(
                            padding:  EdgeInsets.all(size.height * k8TextSize),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.whiteTextColor,
                                  borderRadius: BorderRadius.circular(size.height * k8TextSize),
                                  border: Border.all(color:AppColors.containerBorderColor,width: 1.0)
                              ),
                              child: Scrollbar(
                                thumbVisibility: true,
                                trackVisibility: true,
                                radius: Radius.circular(size.height * k16TextSize),
                                thickness: 6,
                                child: dashBoardRadioButtonController.selectedSourceLoadValue== 1 ? GetBuilder<SourceWaterController>(
                                    builder: (sourceWaterController) {
                                      return   ListView.separated(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemCount: sourceWaterController.isLoading
                                            ? 4
                                            : sourceWaterController.waterList.isEmpty || sourceWaterController.hasError
                                            ? 1
                                            : sourceWaterController.waterList.length,
                                        itemBuilder: (context,index){
                                          if(sourceWaterController.isLoading){
                                            return Padding(
                                              padding: EdgeInsets.all(size.height * k8TextSize),
                                              child: CustomShimmerWidget(height: size.height * 0.09 , width: double.infinity,),
                                            );
                                          } else if(sourceWaterController.waterList.isEmpty){
                                            return Center(child: Lottie.asset(AssetsPath.emptyJson,height: size.height * 0.250));
                                          } else if(sourceWaterController.hasError){
                                            return  Lottie.asset(AssetsPath.errorJson,height: size.height * 0.250);
                                          }

                                          else{
                                            dynamic waterData = sourceWaterController.waterList[index];

                                            return OpenContainer(
                                                transitionDuration: const Duration(milliseconds: 1400),
                                                transitionType: ContainerTransitionType.fadeThrough,
                                                closedBuilder: (BuildContext _,VoidCallback openContainer){
                                                  return  Padding(
                                                    padding: EdgeInsets.only(right: size.height * k8TextSize),
                                                    child: Card(
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(size.height * k8TextSize),
                                                          side: const BorderSide(color: AppColors.containerBorderColor)
                                                      ),
                                                      color: AppColors.listTileColor,
                                                      child: GetBuilder<FindWaterValueController>(
                                                        builder: (findWaterValueController) {
                                                          return Column(
                                                            children: [
                                                              ListTile(
                                                                //'Solar','Diesel_Generator','Gas_Generator','Grid'
                                                                contentPadding: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize),
                                                                leading: SvgPicture.asset(AssetsPath.waterIconSVG,height: size.height * k24TextSize,),
                                                                title: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Container(
                                                                              height: size.height * k16TextSize,
                                                                              width: size.height * k16TextSize,
                                                                              decoration: BoxDecoration(
                                                                                  color: colorPalette[index % colorPalette.length],
                                                                                  borderRadius: BorderRadius.circular(size.height * 0.003)
                                                                              ),

                                                                            ),
                                                                            SizedBox(width: size.width * k16TextSize,),
                                                                            TextComponent(text: waterData.nodeName ?? ''),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                    const TextComponent(text: "Water Flow",color: AppColors.secondaryTextColor,),
                                                                                    SizedBox(width: size.height * k16TextSize,),
                                                                                    const TextComponent(text: "Total Cost",color: AppColors.secondaryTextColor,),
                                                                                    SizedBox(width: size.height * k16TextSize,),
                                                                                    const TextComponent(text: "Total Volume",color: AppColors.secondaryTextColor,),
                                                                              ],
                                                                            ),
                                                                            Column(
                                                                              children: [
                                                                                const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily),
                                                                                SizedBox(width: size.height * k16TextSize,),
                                                                                const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily),
                                                                                SizedBox(width: size.height * k16TextSize,),
                                                                                const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily),
                                                                              ],
                                                                            ),
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                TextComponent(text: " ${findWaterValueController.waterValues[waterData.nodeName]?.instantFlow?.toStringAsFixed(2) ?? '0.00'} m³/s"),
                                                                                SizedBox(width: size.height * k16TextSize,),
                                                                                TextComponent(text: " ${findWaterValueController.waterValues[waterData.nodeName]?.cost?.toStringAsFixed(2) ?? '0.00'} ৳"),
                                                                                SizedBox(width: size.height * k16TextSize,),
                                                                                TextComponent(text: " ${findWaterValueController.waterValues[waterData.nodeName]?.volume?.toStringAsFixed(2) ?? '0.00'} L"),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),

                                                                trailing: Icon(Icons.keyboard_arrow_right_outlined,color: AppColors.secondaryTextColor,size: size.height* k40TextSize,),
                                                              ),

                                                            ],
                                                          );
                                                        }
                                                      ),
                                                    ),
                                                  );
                                                }, openBuilder: (BuildContext _, VoidCallback __){
                                              return  WaterElementDetailsScreen(elementName: waterData.nodeName ?? '',
                                                  gaugeValue:  Get.find<FindWaterValueController>().waterValues[waterData.nodeName ?? '']?.instantFlow ?? 0.00 , gaugeUnit: 'm³/s',elementCategory: 'Water'
                                              );
                                            });
                                          }
                                        }, separatorBuilder: (context,index) => const SizedBox(height: 0,),);
                                    }
                                ) : GetBuilder<LoadWaterController>(
                                    builder: (loadWaterController) {
                                      return   ListView.separated(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemCount: loadWaterController.isLoading
                                            ? 3
                                            : loadWaterController.waterList.isEmpty || loadWaterController.hasError
                                            ? 1
                                            : loadWaterController.waterList.length,

                                        itemBuilder: (context,index){
                                          if(loadWaterController.isLoading){
                                            return Padding(
                                              padding: EdgeInsets.all(size.height * k8TextSize),
                                              child: CustomShimmerWidget(height: size.height * 0.09 , width: double.infinity,),
                                            );
                                          } else if(loadWaterController.waterList.isEmpty){
                                            return Center(child: Lottie.asset(AssetsPath.emptyJson,height: size.height * 0.250));
                                          } else if(loadWaterController.hasError){
                                            return  Lottie.asset(AssetsPath.errorJson,height: size.height * 0.250);
                                          }

                                          else{
                                            dynamic waterData = loadWaterController.waterList[index];

                                            return OpenContainer(
                                                transitionDuration: const Duration(milliseconds: 1400),
                                                transitionType: ContainerTransitionType.fadeThrough,
                                                closedBuilder: (BuildContext _,VoidCallback openContainer){
                                                  return  Padding(
                                                    padding: EdgeInsets.only(right: size.height * k8TextSize),
                                                    child: Card(
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(size.height * k8TextSize),
                                                          side: const BorderSide(color: AppColors.containerBorderColor)
                                                      ),
                                                      color: AppColors.listTileColor,
                                                      child: GetBuilder<FindWaterValueController>(
                                                        builder: (findWaterValueController) {

                                                          return Column(
                                                            children: [
                                                              ListTile(
                                                                //'Solar','Diesel_Generator','Gas_Generator','Grid'
                                                                contentPadding: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize),
                                                                leading: SvgPicture.asset(AssetsPath.waterIconSVG,height: size.height * k24TextSize,),

                                                                title: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          height: size.height * k16TextSize,
                                                                          width: size.height * k16TextSize,
                                                                          decoration: BoxDecoration(
                                                                              color: colorPalette[index % colorPalette.length],
                                                                              borderRadius: BorderRadius.circular(size.height * 0.003)
                                                                          ),

                                                                        ),
                                                                        SizedBox(width: size.width * k16TextSize,),
                                                                        TextComponent(text: waterData.nodeName ?? ''),
                                                                      ],
                                                                    ),

                                                                    Row(
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            const TextComponent(text: "Water Flow",color: AppColors.secondaryTextColor,),
                                                                            SizedBox(width: size.height * k16TextSize,),
                                                                            const TextComponent(text: "Total Cost",color: AppColors.secondaryTextColor,),
                                                                            SizedBox(width: size.height * k16TextSize,),
                                                                            const TextComponent(text: "Total Volume",color: AppColors.secondaryTextColor,),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,),
                                                                            SizedBox(width: size.height * k16TextSize,),
                                                                            const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily),
                                                                            SizedBox(width: size.height * k16TextSize,),
                                                                            const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            TextComponent(text: " ${findWaterValueController.waterValues[waterData.nodeName]?.instantFlow?.toStringAsFixed(2) ?? '0.00'} m³/s"),
                                                                            SizedBox(width: size.height * k16TextSize,),
                                                                            TextComponent(text: " ${findWaterValueController.waterValues[waterData.nodeName]?.cost?.toStringAsFixed(2) ?? '0.00'} ৳"),
                                                                            SizedBox(width: size.height * k16TextSize,),
                                                                            TextComponent(text: " ${findWaterValueController.waterValues[waterData.nodeName]?.volume?.toStringAsFixed(2) ?? '0.00'} L"),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                trailing: Icon(Icons.keyboard_arrow_right_outlined,color: AppColors.secondaryTextColor,size: size.height* k40TextSize,),
                                                              ),

                                                            ],
                                                          );
                                                        }
                                                      ),
                                                    ),
                                                  );
                                                }, openBuilder: (BuildContext _, VoidCallback __){
                                              return  WaterElementDetailsScreen(elementName: waterData.nodeName ?? '',
                                                  gaugeValue:   Get.find<FindWaterValueController>().waterValues[waterData.nodeName ?? '']?.instantFlow ?? 0.00 , gaugeUnit: 'm³/s',elementCategory: 'Water'
                                              );
                                            });
                                          }
                                        }, separatorBuilder: (context,index) => const SizedBox(height: 0,),);
                                    }
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}