import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/color_palette_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/each_category_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/machine_view_names_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pf_controller/get_production_vs_capacityController.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pf_controller/main_bus_bar_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/views/widgets/grid_widget/details_button_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/views/widgets/grid_widget/progress_indicator_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/views/widgets/grid_widget/reb_value_data_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/screen/power_and_energy_element_details_screen.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class DemoScreen extends StatefulWidget {
  final String categoryName;
  const DemoScreen({super.key, required this.categoryName});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<EachCategoryLiveDataController>().fetchEachCategoryLiveData(categoryName: widget.categoryName);

      Get.find<MainBusBarController>().fetchMainBusBar();

      Get.find<MainBusBarController>().startApiCallOnScreenChange();
      Get.find<GetProductionVsCapacityController>().startApiCallOnScreenChange();



      Get.find<CategoryWiseLiveDataController>().stopApiCallOnScreenChange();
      Get.find<MachineViewNamesDataController>().stopApiCallOnScreenChange();
      Get.find<MainBusBarController>().enterGridScreenMethod(true);
      Get.find<GetProductionVsCapacityController>().enterGridScreenMethod(true);


    });
    super.initState();
  }

  @override
  void dispose() {

    Get.find<MainBusBarController>().stopApiCallOnScreenChange();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar:  CustomAppBarWidget(
        text: "Grid",
        backPreviousScreen: true,
        onBackButtonPressed: (){

          Get.find<CategoryWiseLiveDataController>().startApiCallOnScreenChange();
          Get.find<MachineViewNamesDataController>().startApiCallOnScreenChange();


          Get.find<MainBusBarController>().stopApiCallOnScreenChange();
          Get.find<MainBusBarController>().enterGridScreenMethod(false);

          Get.find<GetProductionVsCapacityController>().stopApiCallOnScreenChange();
          Get.find<GetProductionVsCapacityController>().enterGridScreenMethod(false);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          Get.find<EachCategoryLiveDataController>().fetchEachCategoryLiveData(categoryName: widget.categoryName);

          Get.find<MainBusBarController>().startApiCallOnScreenChange();
          Get.find<GetProductionVsCapacityController>().startApiCallOnScreenChange();



          Get.find<CategoryWiseLiveDataController>().stopApiCallOnScreenChange();
          Get.find<MachineViewNamesDataController>().stopApiCallOnScreenChange();
          Get.find<MainBusBarController>().enterGridScreenMethod(true);
          Get.find<GetProductionVsCapacityController>().enterGridScreenMethod(true);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: GetBuilder<MainBusBarController>(
              builder: (mainBusBarController) {
                return ListView.separated(
                  itemCount: mainBusBarController.isMainBusBarInProgress ? 2 : mainBusBarController.mainBusBarList.isEmpty ? 1 :  mainBusBarController.mainBusBarList.length,
                  itemBuilder: (context, index) {

                    if(mainBusBarController.isMainBusBarInProgress){
                      return CustomShimmerWidget(height: size.height * 0.3, width: double.infinity);
                    }
                    if(mainBusBarController.mainBusBarList.isEmpty){
                      return Center(child: Lottie.asset(AssetsPath.emptyJson, height: size.height * 0.26));
                    }
                    if (index >= mainBusBarController.mainBusBarList.length) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [

                        SizedBox(height: size.height * k12TextSize,),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size.height * k8TextSize),
                                border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(size.height * k8TextSize),
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
                                  child: ExpansionTile(
                                    showTrailingIcon: false,
                                    tilePadding: EdgeInsets.zero,
                                    title: Card(
                                      elevation: 0,
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(size.height * k8TextSize),
                                        side: const BorderSide(color: Colors.transparent),
                                      ),
                                      color: AppColors.listTileColor,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: size.height * k8TextSize,),
                                            title: Padding(
                                              padding: EdgeInsets.only(left: size.height * k8TextSize),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    flex: 2,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: size.height * k16TextSize,
                                                              width: size.height * k16TextSize,
                                                              decoration: BoxDecoration(
                                                                color: colorPalette[index % colorPalette.length],
                                                                borderRadius: BorderRadius.circular(size.height * 0.003),
                                                              ),
                                                            ),
                                                            SizedBox(width: size.width * k16TextSize),
                                                            TextComponent(text: mainBusBarController.mainBusBarList[index].isNotEmpty ? mainBusBarController.mainBusBarList[index] : '' ),

                                                          ],
                                                        ),
                                                        // RebValueDataWidget(
                                                        //   size: size,
                                                        //   powerText:  mainBusBarController.getLiveDataModel.isNotEmpty
                                                        //       ? "${mainBusBarController.getLiveDataModel[index].power.toStringAsFixed(2)} kW"
                                                        //       : "0.00 kW",
                                                        //
                                                        //   energyText: mainBusBarController.getLiveDataModel.isNotEmpty
                                                        //       ? "${mainBusBarController.getLiveDataModel[index].todayEnergy.toStringAsFixed(2)} kWh"
                                                        //       : "0.00 kW",
                                                        //
                                                        //   costText: mainBusBarController.getLiveDataModel.isNotEmpty
                                                        //       ? "${mainBusBarController.getLiveDataModel[index].cost.toStringAsFixed(2)} ৳"
                                                        //       : "0.00 kW",
                                                        //
                                                        //   pfText: mainBusBarController.getLiveDataModel.isNotEmpty
                                                        //       ? "${mainBusBarController.getLiveDataModel[index].powerFactor.toStringAsFixed(4)} %"
                                                        //       : "0.00 kW",
                                                        // ),


                                                        // RebValueDataWidget(
                                                        //   size: size,
                                                        //   powerText: (mainBusBarController.getLiveDataModel.isNotEmpty && index < mainBusBarController.getLiveDataModel.length)
                                                        //       ? "${mainBusBarController.getLiveDataModel[index].power.toStringAsFixed(2)} kW"
                                                        //       : "0.00 kW",
                                                        //
                                                        //   energyText: (mainBusBarController.getLiveDataModel.isNotEmpty && index < mainBusBarController.getLiveDataModel.length)
                                                        //       ? "${mainBusBarController.getLiveDataModel[index].todayEnergy.toStringAsFixed(2)} kWh"
                                                        //       : "0.00 kWh",
                                                        //
                                                        //   costText: (mainBusBarController.getLiveDataModel.isNotEmpty && index < mainBusBarController.getLiveDataModel.length)
                                                        //       ? "${mainBusBarController.getLiveDataModel[index].cost.toStringAsFixed(2)} ৳"
                                                        //       : "0.00 ৳",
                                                        //
                                                        //   pfText: (mainBusBarController.getLiveDataModel.isNotEmpty && index < mainBusBarController.getLiveDataModel.length)
                                                        //       ? "${mainBusBarController.getLiveDataModel[index].powerFactor.toStringAsFixed(4)} %"
                                                        //       : "0.00 %",
                                                        // ),


                                                        RebValueDataWidget(
                                                          size: size,
                                                          powerText: (mainBusBarController.getLiveDataModel.isNotEmpty &&
                                                              index < mainBusBarController.getLiveDataModel.length &&
                                                              mainBusBarController.getLiveDataModel[index].power != null)
                                                              ? "${mainBusBarController.getLiveDataModel[index].power!.toStringAsFixed(2)} kW"
                                                              : "0.00 kW",

                                                          energyText: (mainBusBarController.getLiveDataModel.isNotEmpty &&
                                                              index < mainBusBarController.getLiveDataModel.length &&
                                                              mainBusBarController.getLiveDataModel[index].todayEnergy != null)
                                                              ? "${mainBusBarController.getLiveDataModel[index].todayEnergy!.toStringAsFixed(2)} kWh"
                                                              : "0.00 kWh",

                                                          costText: (mainBusBarController.getLiveDataModel.isNotEmpty &&
                                                              index < mainBusBarController.getLiveDataModel.length &&
                                                              mainBusBarController.getLiveDataModel[index].cost != null)
                                                              ? "${mainBusBarController.getLiveDataModel[index].cost!.toStringAsFixed(2)} ৳"
                                                              : "0.00 ৳",

                                                          pfText: (mainBusBarController.getLiveDataModel.isNotEmpty &&
                                                              index < mainBusBarController.getLiveDataModel.length &&
                                                              mainBusBarController.getLiveDataModel[index].powerFactor != null)
                                                              ? "${mainBusBarController.getLiveDataModel[index].powerFactor!.toStringAsFixed(4)} %"
                                                              : "0.00 %",
                                                        ),



                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                          GetBuilder<GetProductionVsCapacityController>(
                                              builder: (getProductionVsCapacityController) {
                                                String nodeName = '';
                                                dynamic percentage = '';
                                                for (var node in getProductionVsCapacityController.productionVsCapacityList)
                                                {
                                                  if(node.node == mainBusBarController.mainBusBarList[index]){
                                                    nodeName = node.node ?? '';
                                                    percentage = node.percentage ?? 0.00;
                                                  // Get.find<PFHistoryController>().fetchPFHistory(nodeName: node.node?? '');
                                                  }
                                                }
                                                return ProgressIndicatorWidget(size: size, percentage: percentage, nodeName: nodeName);
                                              }
                                          ),
                                        ],
                                      ),
                                    ),

                                    children: [

                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width * k40TextSize),
                                        child: const Divider(thickness: 2),
                                      ),

                                      if(index < mainBusBarController.mainBusBarList.length &&
                                          index < mainBusBarController.innerChildrenNameModel.length &&
                                          mainBusBarController.mainBusBarList[index] == mainBusBarController.innerChildrenNameModel[index].parent)

                                        Padding(
                                          padding: EdgeInsets.only(left: size.height * k16TextSize),
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            primary: false,
                                            padding: EdgeInsets.only(
                                              top: size.height * k8TextSize,
                                              bottom: size.height * k8TextSize,
                                            ),
                                            itemCount: mainBusBarController.innerChildrenNameModel[index].children?.length ?? 0 ,
                                            itemBuilder: (context, dataIndex) {

                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: size.height * k8TextSize),
                                                child: Card(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(size.height * k8TextSize),
                                                    side: const BorderSide(color: AppColors.containerBorderColor),
                                                  ),
                                                  color: AppColors.listTileColor,
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        contentPadding: EdgeInsets.symmetric(
                                                          horizontal: size.height * k8TextSize,
                                                        ),
                                                        title: Padding(
                                                          padding: EdgeInsets.only(left: size.height * k8TextSize),
                                                          child: Row(
                                                            children: [
                                                              Flexible(
                                                                flex: 2,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          height: size.height * k16TextSize,
                                                                          width: size.height * k16TextSize,
                                                                          decoration: BoxDecoration(
                                                                            color: colorPalette[dataIndex % colorPalette.length],
                                                                            borderRadius: BorderRadius.circular(size.height * 0.003),
                                                                          ),
                                                                        ),
                                                                        SizedBox(width: size.width * k16TextSize),
                                                                        TextComponent(text: "==>${mainBusBarController.innerChildrenNameModel[index].children?[dataIndex].nodeName ?? ''}" ),
                                                                        // categoryData.status == true ? const TextComponent(text: "(Active)", color: AppColors.primaryColor,)
                                                                        //     : const TextComponent(text: " (Inactive)", color: Colors.red,),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            const TextComponent(text: "Total Power ", color: AppColors.secondaryTextColor,),
                                                                            SizedBox(width: size.height * k16TextSize),
                                                                            const TextComponent(text: "Today Energy ", color: AppColors.secondaryTextColor,),
                                                                            SizedBox(width: size.height * k16TextSize),
                                                                            const TextComponent(text: "Today Cost ", color: AppColors.secondaryTextColor,),
                                                                            SizedBox(width: size.height * k16TextSize),
                                                                            const TextComponent(text: "PF ", color: AppColors.secondaryTextColor,),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            const TextComponent(text: " : ", color: AppColors.secondaryTextColor, fontFamily: boldFontFamily),
                                                                            SizedBox(width: size.height * k16TextSize),
                                                                            const TextComponent(text: " : ", color: AppColors.secondaryTextColor, fontFamily: boldFontFamily),
                                                                            const TextComponent(text: " : ", color: AppColors.secondaryTextColor, fontFamily: boldFontFamily),
                                                                            SizedBox(width: size.height * k16TextSize),
                                                                            const TextComponent(text: " : ", color: AppColors.secondaryTextColor, fontFamily: boldFontFamily),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [

                                                                            for (var data in mainBusBarController.getInnerChildrenList)
                                                                              if (data.node == mainBusBarController.innerChildrenNameModel[index].children?[dataIndex].nodeName)
                                                                                ...[
                                                                                  TextComponent(text: "${data.power.toStringAsFixed(2)} kW"),
                                                                                  TextComponent(text: "${data.todayEnergy.toStringAsFixed(2)} kWh"),
                                                                                  TextComponent(text: "${data.cost.toStringAsFixed(2)} ৳"),
                                                                                  TextComponent(text: " ${data.powerFactor.toStringAsFixed(4)}%"),
                                                                                ]

                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Column(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      for (var data in mainBusBarController.getInnerChildrenList) {
                                                                        if (data.node == mainBusBarController.innerChildrenNameModel[index].children?[dataIndex].nodeName) {
                                                                          Get.to(
                                                                                () => PowerAndEnergyElementDetailsScreen(
                                                                              elementName: data.node ?? '',
                                                                              gaugeValue: data.power,
                                                                              gaugeUnit: 'kW',
                                                                              elementCategory: 'Power',
                                                                              solarCategory: widget.categoryName,
                                                                            ),
                                                                            transition: Transition.rightToLeft,
                                                                            duration: const Duration(seconds: 1),
                                                                          );
                                                                          break;
                                                                        }
                                                                      }
                                                                    },

                                                                    child: DetailsButtonWidget(size: size),
                                                                  ),
                                                                  SizedBox(height: size.height * k8TextSize,),
                                                                 /*------------Old Code-------*/
                                                                 /* Stack(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: (){
                                                                          Get.to(()=> PfHistoryScreen(nodeName: mainBusBarController.innerChildrenNameModel[index].children?[dataIndex].nodeName ?? '' ,),  transition: Transition.fadeIn,
                                                                              duration: const Duration(seconds: 0));
                                                                        },
                                                                        child: CustomContainer(
                                                                          height: size.height * 0.045,
                                                                          width: size.width * 0.18,
                                                                          color: AppColors.redColor,
                                                                          borderRadius: BorderRadius.circular(size.height * k8TextSize),
                                                                          child: GetBuilder<PFHistoryController>(
                                                                            builder: (pfHistoryController) {

                                                                              return Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                children: [
                                                                                  for (var data in mainBusBarController.getInnerChildrenList)
                                                                                    if (data.node == mainBusBarController.innerChildrenNameModel[index].children?[dataIndex].nodeName)
                                                                                      ...[
                                                                                        var response = pfHistoryController.fetchPFHistory(nodeName: data.node?? '')
                                                                                         if(response){
                                                                                              TextComponent(
                                                                                              text: pfHistoryController.pfHistoryList.length.toString(),
                                                                                              color: AppColors.redColor,fontSize: size.height * k18TextSize,),

                                                                                           }
                                                                                      ],



                                                                                ],
                                                                              );
                                                                            }
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 5,
                                                                        right: 6,
                                                                        child:  SvgPicture.asset(AssetsPath.bellIconSVG,height: size.height * k22TextSize,),
                                                                      )
                                                                    ],

                                                                  ),*/
                                                                  // Stack(
                                                                  //   children: [
                                                                  //     GestureDetector(
                                                                  //       onTap: () {
                                                                  //         Get.to(
                                                                  //               () => PfHistoryScreen(
                                                                  //             nodeName: mainBusBarController.innerChildrenNameModel[index].children?[dataIndex].nodeName ?? '',
                                                                  //           ),
                                                                  //           transition: Transition.fadeIn,
                                                                  //           duration: const Duration(seconds: 0),
                                                                  //         );
                                                                  //       },
                                                                  //       child:/* CustomContainer(
                                                                  //         height: size.height * 0.045,
                                                                  //         width: size.width * 0.18,
                                                                  //         color: AppColors.redColor,
                                                                  //         borderRadius: BorderRadius.circular(size.height * k8TextSize),
                                                                  //         child: GetBuilder<PFHistoryController>(
                                                                  //           builder: (pfHistoryController) {
                                                                  //             // Find the matching data
                                                                  //             // var matchingData = mainBusBarController.getInnerChildrenList.firstWhere(
                                                                  //             //       (data) => data.node == mainBusBarController.innerChildrenNameModel[index].children?[dataIndex].nodeName,
                                                                  //             //   orElse: () => null,
                                                                  //             // );
                                                                  //             // var matchingData = mainBusBarController.getInnerChildrenList.firstWhere(
                                                                  //             //       (data) => data.node == mainBusBarController.innerChildrenNameModel[index].children?[dataIndex].nodeName,
                                                                  //             //   orElse: () => GetLiveDataModel(), // ✅ Use a valid default value
                                                                  //             // );
                                                                  //
                                                                  //
                                                                  //             // Fetch the PF history if data is found
                                                                  //             // if (matchingData != null) {
                                                                  //             //   log("=======>${matchingData.node}");
                                                                  //             //   pfHistoryController.fetchPFHistory(nodeName: matchingData.node ?? '');
                                                                  //             // }
                                                                  //
                                                                  //             // Return the UI
                                                                  //             return Row(
                                                                  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  //               children: [
                                                                  //                 TextComponent(
                                                                  //                   text: *//*pfHistoryController.pfHistoryList.length.toString()*//* "0",
                                                                  //                   color: AppColors.redColor,
                                                                  //                   fontSize: size.height * k18TextSize,
                                                                  //                 ),
                                                                  //               ],
                                                                  //             );
                                                                  //           },
                                                                  //         ),
                                                                  //       ),*/
                                                                  //
                                                                  //       CustomContainer(
                                                                  //         height: size.height * 0.045,
                                                                  //         width: size.width * 0.18,
                                                                  //         color: AppColors.redColor,
                                                                  //         borderRadius: BorderRadius.circular(size.height * k8TextSize),
                                                                  //         child: GetBuilder<PFHistoryController>(
                                                                  //           builder: (pfHistoryController) {
                                                                  //             // Find the matching data
                                                                  //             var nodeName = mainBusBarController.innerChildrenNameModel[index].children?[dataIndex].nodeName;
                                                                  //
                                                                  //             // Fetch the PF history if nodeName is not null
                                                                  //             if (nodeName != null && nodeName.isNotEmpty) {
                                                                  //               pfHistoryController.fetchPFHistory(nodeName: nodeName);
                                                                  //             }
                                                                  //
                                                                  //             // Return the UI
                                                                  //             return Row(
                                                                  //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  //               children: [
                                                                  //                 TextComponent(
                                                                  //                   text: pfHistoryController.pfHistoryList.length.toString(),
                                                                  //                   color: AppColors.redColor, // Changed to white for better visibility on red background
                                                                  //                   fontSize: size.height * k18TextSize,
                                                                  //                 ),
                                                                  //               ],
                                                                  //             );
                                                                  //           },
                                                                  //         ),
                                                                  //       ),
                                                                  //
                                                                  //     ),
                                                                  //     Positioned(
                                                                  //       top: 5,
                                                                  //       right: 6,
                                                                  //       child: SvgPicture.asset(
                                                                  //         AssetsPath.bellIconSVG,
                                                                  //         height: size.height * k22TextSize,
                                                                  //       ),
                                                                  //     ),
                                                                  //   ],
                                                                  // ),

                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      // GetBuilder<GetProductionVsCapacityController>(
                                                      //   builder: (getProductionVsCapacityController) {
                                                      //
                                                      //     String nodeName = '';
                                                      //     dynamic percentage = '';
                                                      //     for (var node in getProductionVsCapacityController.productionVsCapacityList)
                                                      //     {
                                                      //       if(node.node == mainBusBarController.innerChildrenNameModel[index].children?[dataIndex].nodeName){
                                                      //         nodeName = node.node ?? '';
                                                      //         percentage = node.percentage ?? 0.00;
                                                      //
                                                      //       }
                                                      //     }
                                                      //
                                                      //     return ProgressIndicatorWidget(size: size, percentage: percentage, nodeName: nodeName);
                                                      //   }
                                                      // ),

                                                      GetBuilder<GetProductionVsCapacityController>(
                                                        builder: (getProductionVsCapacityController) {
                                                          String nodeName = '';
                                                          dynamic percentage = 0.00;


                                                          var childrenList = mainBusBarController.innerChildrenNameModel[index].children;
                                                          if (childrenList == null || dataIndex >= childrenList.length) {
                                                            return SizedBox();
                                                          }

                                                          var targetNodeName = childrenList[dataIndex].nodeName;


                                                          if (getProductionVsCapacityController.productionVsCapacityList.isNotEmpty) {
                                                            for (var node in getProductionVsCapacityController.productionVsCapacityList) {
                                                              if (node.node == targetNodeName) {
                                                                nodeName = node.node ?? '';
                                                                percentage = node.percentage ?? 0.00;
                                                                break;
                                                              }
                                                            }
                                                          }

                                                          return ProgressIndicatorWidget(size: size, percentage: percentage, nodeName: nodeName);
                                                        },
                                                      ),



                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            separatorBuilder: (context, dataIndex) => const SizedBox(height: 0),
                                          ),

                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Positioned(
                            //   right: 10,
                            //   top: 5,
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       SizedBox(height: size.height * k8TextSize),
                            //       Stack(
                            //         children: [
                            //           GestureDetector(
                            //             onTap: () {
                            //               Get.to(
                            //                     () => PfHistoryScreen(
                            //                   nodeName: mainBusBarController.mainBusBarList[index] ?? '',
                            //                 ),
                            //                 transition: Transition.fadeIn,
                            //                 duration: const Duration(seconds: 0),
                            //               );
                            //             },
                            //             child: CustomContainer(
                            //               height: size.height * 0.045,
                            //               width: size.width * 0.18,
                            //               color: AppColors.redColor,
                            //               borderRadius: BorderRadius.circular(size.height * k8TextSize),
                            //               child: GetBuilder<PFHistoryController>(
                            //                 builder: (pfHistoryController) {
                            //                   // Get the cached count for this node
                            //                   int count = pfHistoryController.getHistoryCountForNode(
                            //                     mainBusBarController.mainBusBarList[index] ?? '',
                            //                   );
                            //
                            //                   return Row(
                            //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //                     children: [
                            //                       TextComponent(
                            //                         text: count.toString(),
                            //                         color: AppColors.redColor,
                            //                         fontSize: size.height * k18TextSize,
                            //                       ),
                            //                     ],
                            //                   );
                            //                 },
                            //               ),
                            //             ),
                            //           ),
                            //           Positioned(
                            //             top: 5,
                            //             right: 6,
                            //             child: SvgPicture.asset(
                            //               AssetsPath.bellIconSVG,
                            //               height: size.height * k22TextSize,
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // )
                          ],
                        ),

                      ],
                    );
                  },
                  separatorBuilder: (context, index) => mainBusBarController.isMainBusBarInProgress ? SizedBox(height: size.height * k10TextSize) :  const SizedBox(height: 0.0),
                );
              }
          ),
        ),
      ),
    );
  }
}






