import 'package:animations/animations.dart';
import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/empty_page_widget/empty_page_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/dash_board_radio_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/search_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/controller/electricity_long_sld_live_all_node_power_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/controller/electricity_long_sld_lt_production_vs_capacity_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/color_palette_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/machine_view_names_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_source_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/views/screens/demo_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/views/screens/load_element_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/views/screens/total_power_element_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/views/widgets/pie_chart_power_load_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/views/widgets/pie_chart_power_source_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/pie_chart_water_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/pie_chart_water_source_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/water_load_category_wise_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/water_source_category_wise_data_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class PowerSummaryChartScreen extends StatefulWidget {
  const PowerSummaryChartScreen({super.key});

  @override
  State<PowerSummaryChartScreen> createState() => _PowerSummaryChartScreenState();
}

class _PowerSummaryChartScreenState extends State<PowerSummaryChartScreen> {


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      /*------------- Start Api in Electricity---------------*/
      Get.find<PieChartPowerSourceController>().startApiCallOnScreenChange();
      Get.find<PieChartPowerLoadController>().startApiCallOnScreenChange();
     // Get.find<CategoryWiseLiveDataController>().startApiCallOnScreenChange();
    //  Get.find<MachineViewNamesDataController>().startApiCallOnScreenChange();


      /*------------- Stop Api in Electricity ---------------*/
      Get.find<WaterSourceCategoryWiseDataController>().stopApiCallOnScreenChange();
      Get.find<WaterLoadCategoryWiseDataController>().stopApiCallOnScreenChange();
      Get.find<PieChartWaterSourceController>().stopApiCallOnScreenChange();
      Get.find<PieChartWaterLoadController>().stopApiCallOnScreenChange();
      Get.find<ElectricityLongSLDLtProductionVsCapacityController>().stopApiCallOnScreenChange();
      Get.find<ElectricityLongSLDLiveAllNodePowerController>().stopApiCallOnScreenChange();
    });
    super.initState();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (Get.find<SearchDataController>().isSearching) {
          Get.find<SearchDataController>().changeSearchStatus(false);
        }
      },
      child: Column(
          children: [
            GetBuilder<DashBoardRadioButtonController>(
              builder: (dashBoardRadioButtonController) {
                return SizedBox(height: size.height * .2, child: dashBoardRadioButtonController.selectedSourceLoadValue == 1 ?  const PieChartPowerSourceWidget() : const PieChartPowerLoadWidget());
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
                     //  Get.find<PieChartPowerSourceController>().startApiCallOnScreenChange();
                     //  Get.find<PieChartPowerLoadController>().stopApiCallOnScreenChange();
                     },
                     label: 'Source',
                   ),
                   CustomRectangularRadioButton<int>(
                     value: 2,
                     groupValue: dashBoardRadioButtonController.selectedSourceLoadValue,
                     onChanged: (value) {
                       dashBoardRadioButtonController.updateSourceLoadSelectedValue(value!);
                       dashBoardRadioButtonController.update();
                       //Get.find<PieChartPowerLoadController>().startApiCallOnScreenChange();
                       //Get.find<PieChartPowerSourceController>().stopApiCallOnScreenChange();
                     },
                     label: 'Load',
                   ),
                 ],
               );
             }
           ),
            Padding(
              padding: EdgeInsets.symmetric( horizontal: size.height * k16TextSize),
              child: const Divider(thickness: 3,),
            ),
            GetBuilder<CategoryWiseLiveDataController>(
              builder: (controller) {

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
                            thumbVisibility: false,
                            trackVisibility: false,
                            radius: Radius.circular(size.height * k16TextSize),
                            thickness: 6,
                            child: dashBoardRadioButtonController.selectedSourceLoadValue== 1 ? GetBuilder<CategoryWiseLiveDataController>(
                              builder: (categoryWiseLiveDataController) {
                                return   ListView.separated(
                                  shrinkWrap: true,
                                    primary: false,
                                    itemCount: categoryWiseLiveDataController.isLoading ?
                                    4 : categoryWiseLiveDataController.categoryWiseLiveData.isEmpty /*|| categoryWiseLiveDataController.hasError*/ ? 1 :
                                    categoryWiseLiveDataController.categoryWiseLiveData.length,
                                   itemBuilder: (context,index){
                                    if(categoryWiseLiveDataController.isLoading){
                                      return Padding(
                                        padding: EdgeInsets.all(size.height * k8TextSize),
                                        child: CustomShimmerWidget(height: size.height * 0.09 , width: double.infinity,),
                                      );
                                    } else if(categoryWiseLiveDataController.categoryWiseLiveData.isEmpty /*|| categoryWiseLiveDataController.hasError*/){
                                      return EmptyPageWidget(size: size);
                                    }

                                    else{
                                      dynamic powerData = categoryWiseLiveDataController.categoryWiseLiveData[index];

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
                                                child:  Column(
                                                      children: [
                                                        ListTile(
                                                          //'Solar','Diesel_Generator','Gas_Generator','Grid'
                                                          contentPadding: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize),
                                                          leading: powerData.category == 'Grid' ?  SvgPicture.asset(AssetsPath.gridIconSVG,height: size.height * k24TextSize,) : powerData.category == 'Gas_Generator' ?  SvgPicture.asset(AssetsPath.gasGeneratorIconSVG,height: size.height * k24TextSize,)

                                                              : powerData.category == 'Diesel_Generator' ?  SvgPicture.asset(AssetsPath.dieselGeneratorIconSVG,height: size.height * k24TextSize,) : SvgPicture.asset(AssetsPath.solarCellIconSVG,height: size.height * k24TextSize,),
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
                                                                  TextComponent(text: powerData.category ?? ''),
                                                                  SizedBox(width: size.width * k16TextSize,),
                                                                  TextComponent(text: "(${categoryWiseLiveDataController.categoryWiseLiveData[index].powerPercentage?.toStringAsFixed(2) ?? '0.0'}%)"),

                                                                ],
                                                              ),
                                                              SizedBox(height: size.height * k5TextSize,),
                                                              Row(
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                          const TextComponent(text: "Total Power ",color: AppColors.secondaryTextColor,),
                                                                          SizedBox(width: size.height * k16TextSize,),
                                                                          const TextComponent(text: "Today Energy ",color: AppColors.secondaryTextColor,),
                                                                          SizedBox(width: size.height * k16TextSize,),
                                                                          TextComponent(text: categoryWiseLiveDataController.categoryWiseLiveData[index].category == "Solar" ? "Today Revenue " : "Today Cost ",color: AppColors.secondaryTextColor,),
                                                                    ],
                                                                  ),

                                                                  Column(
                                                                    children: [
                                                                      const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,),
                                                                      SizedBox(width: size.height * k16TextSize,),
                                                                      const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,),
                                                                      SizedBox(width: size.height * k16TextSize,),
                                                                      const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,),
                                                                    ],
                                                                  ),

                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      TextComponent(text: " ${categoryWiseLiveDataController.categoryWiseLiveData[index].totalPower?.toStringAsFixed(2) ?? '0.0'} kW",),
                                                                      TextComponent(text: " ${categoryWiseLiveDataController.categoryWiseLiveData[index].totalNetEnergy?.toStringAsFixed(2) ?? '0.00'} kWh"),
                                                                      TextComponent(text: " ${categoryWiseLiveDataController.categoryWiseLiveData[index].totalCost?.toStringAsFixed(2) ?? '0.00'} ৳"),
                                                                    ],
                                                                  )

                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          trailing: Icon(Icons.keyboard_arrow_right_outlined,color: AppColors.secondaryTextColor,size: size.height* k40TextSize,),
                                                        ),

                                                      ],
                                                    ),

                                              ),
                                            );
                                          }, openBuilder: (BuildContext _, VoidCallback __){

                                            if(powerData.category == 'Grid'){
                                              return DemoScreen(categoryName: powerData.category,);
                                            }else{
                                              return TotalPowerElementScreen(categoryName: powerData.category,);
                                            }
                                      });
                                    }
                                }, separatorBuilder: (context,index) => const SizedBox(height: 0,),);


                              }
                            ) : GetBuilder<MachineViewNamesDataController>(
                                builder: (machineViewNamesDataController) {
                                  return   ListView.separated(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: machineViewNamesDataController.isLoading
                                        ? 4
                                        : machineViewNamesDataController.machineViewNamesDataList.isEmpty /*|| machineViewNamesDataController.hasError*/
                                        ? 1
                                        : machineViewNamesDataController.machineViewNamesDataList.length,

                                    itemBuilder: (context,index){
                                      if(machineViewNamesDataController.isLoading){
                                        return Padding(
                                          padding: EdgeInsets.all(size.height * k8TextSize),
                                          child: CustomShimmerWidget(height: size.height * 0.09 , width: double.infinity,),
                                        );
                                      } else if(machineViewNamesDataController.machineViewNamesDataList.isEmpty || machineViewNamesDataController.hasError){
                                        return EmptyPageWidget(size: size);
                                      }
                                      // else if(machineViewNamesDataController.hasError){
                                      //   return  Lottie.asset(AssetsPath.errorJson,height: size.height * 0.250);
                                      // }

                                     else{
                                        dynamic machineViewData = machineViewNamesDataController.machineViewNamesDataList[index];

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
                                                  child: Column(
                                                        children: [
                                                          ListTile(
                                                            contentPadding: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize),
                                                            leading: SvgPicture.asset(AssetsPath.loadIconSVG,height: size.height * k24TextSize,),
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
                                                                    TextComponent(text: "${machineViewData.category} (${machineViewData.powerPercentage.toStringAsFixed(2)}%)"),
                                                                  ],
                                                                ),

                                                                Row(
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        const TextComponent(text: "Total Power ",color: AppColors.secondaryTextColor,),
                                                                        SizedBox(width: size.height * k16TextSize,),
                                                                        const TextComponent(text: "Today Energy ",color: AppColors.secondaryTextColor,),
                                                                        SizedBox(width: size.height * k16TextSize,),
                                                                        const TextComponent(text: "Today Cost ",color: AppColors.secondaryTextColor,),
                                                                      ],
                                                                    ),

                                                                    Column(
                                                                      children: [
                                                                        const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,),
                                                                        SizedBox(width: size.height * k16TextSize,),
                                                                        const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,),
                                                                        SizedBox(width: size.height * k16TextSize,),
                                                                        const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,),
                                                                      ],
                                                                    ),

                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        TextComponent(text: " ${machineViewData.totalPower.toStringAsFixed(2) ?? '0.00'} kW"),
                                                                        TextComponent(text: " ${machineViewData.totalNetEnergy.toStringAsFixed(2) ?? '0.00'} kWh"),
                                                                        TextComponent(text: " ${machineViewData.totalCost.toStringAsFixed(2) ?? '0.00'} ৳"),
                                                                      ],
                                                                    )

                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                            trailing: Icon(Icons.keyboard_arrow_right_outlined,color: AppColors.secondaryTextColor,size: size.height* k40TextSize,),
                                                          ),

                                                        ],
                                                      ),

                                                ),
                                              );
                                            }, openBuilder: (BuildContext _, VoidCallback __){

                                          return LoadElementScreen(categoryName: machineViewData.category,);

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

    );
  }

  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', ''); // Remove the '#' if present
    return Color(int.parse('FF$hexColor', radix: 16)); // Add 'FF' for full opacity
  }
}
