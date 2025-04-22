// import 'package:animations/animations.dart';
// import 'package:nz_ums/src/common_widgets/custom_radio_button/custom_radio_button.dart';
// import 'package:nz_ums/src/common_widgets/custom_shimmer_widget.dart';
// import 'package:nz_ums/src/common_widgets/text_component.dart';
// import 'package:nz_ums/src/features/ems_features/dashboard/dashboard/controllers/dash_board_radio_button_controller.dart';
// import 'package:nz_ums/src/features/ems_features/dashboard/summery_view/common_widget/color_palette_widget.dart';
// import 'package:nz_ums/src/features/ems_features/dashboard/summery_view/natural_gas_summary/controllers/load_natural_gas_controller.dart';
// import 'package:nz_ums/src/features/ems_features/dashboard/summery_view/natural_gas_summary/controllers/source_natural_gas_controller.dart';
// import 'package:nz_ums/src/features/ems_features/dashboard/summery_view/natural_gas_summary/views/widgets/pie_chart_natural_gas_load_widget.dart';
// import 'package:nz_ums/src/features/ems_features/dashboard/summery_view/natural_gas_summary/views/widgets/pie_chart_water_source_widget.dart';
// import 'package:nz_ums/src/features/ems_features/source_load_details/views/screens/natural_gas/natural_gas_element_details_screen.dart';
// import 'package:nz_ums/src/utility/assets_path/assets_path.dart';
// import 'package:nz_ums/src/utility/style/app_colors.dart';
// import 'package:nz_ums/src/utility/style/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
//
// class NaturalGasSummaryChartScreen extends StatefulWidget {
//   const NaturalGasSummaryChartScreen({super.key});
//
//   @override
//   State<NaturalGasSummaryChartScreen> createState() => _NaturalGasSummaryChartScreenState();
// }
//
// class _NaturalGasSummaryChartScreenState extends State<NaturalGasSummaryChartScreen> {
//
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Get.find<SourceNaturalGasController>().fetchSourceNaturalGasData();
//       Get.find<LoadNaturalGasController>().fetchLoadNaturalGasData();
//       //Get.find<NaturalGasSLDController>().fetchData(['Natural_Gas']);
//     });
//
//
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: Column(
//             children: [
//               GetBuilder<DashBoardRadioButtonController>(
//                   builder: (dashBoardRadioButtonController) {
//                     return SizedBox(height: size.height * .2, child: dashBoardRadioButtonController.selectedSourceLoadValue == 1 ? const PieChartNaturalGasSourceWidget() :const PieChartNaturalGasLoadWidget());
//                   }
//               ),
//
//               GetBuilder<DashBoardRadioButtonController>(
//                   builder: (dashBoardRadioButtonController) {
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         CustomRectangularRadioButton<int>(
//                           value: 1,
//                           groupValue: dashBoardRadioButtonController.selectedSourceLoadValue,
//                           onChanged: (value) {
//                             dashBoardRadioButtonController.updateSourceLoadSelectedValue(value!);
//                             dashBoardRadioButtonController.update();
//                             //Get.find<SourceWaterController>().fetchSourceWaterData();
//
//                           },
//                           label: 'Source',
//                         ),
//                         CustomRectangularRadioButton<int>(
//                           value: 2,
//                           groupValue: dashBoardRadioButtonController.selectedSourceLoadValue,
//                           onChanged: (value) {
//                             dashBoardRadioButtonController.updateSourceLoadSelectedValue(value!);
//                             dashBoardRadioButtonController.update();
//                            // Get.find<LoadWaterController>().fetchLoadWaterData();
//                           },
//                           label: 'Consume',
//                         ),
//                       ],
//                     );
//                   }
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric( horizontal: size.height * k16TextSize),
//                 child: const Divider(thickness: 3,),
//               ),
//               GetBuilder<SourceNaturalGasController>(
//                   builder: (controller) {
//                     if(controller.hasError){
//                       return Lottie.asset(AssetsPath.errorJson, height: size.height * 0.25);
//                     }
//                     return GetBuilder<DashBoardRadioButtonController>(
//                         builder: (dashBoardRadioButtonController) {
//                           return Expanded(
//                             child: Padding(
//                               padding:  EdgeInsets.all(size.height * k8TextSize),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     color: AppColors.whiteTextColor,
//                                     borderRadius: BorderRadius.circular(size.height * k8TextSize),
//                                     border: Border.all(color:AppColors.containerBorderColor,width: 1.0)
//                                 ),
//                                 child: Scrollbar(
//                                   thumbVisibility: true,
//                                   trackVisibility: true,
//                                   radius: Radius.circular(size.height * k16TextSize),
//                                   thickness: 6,
//                                   child: dashBoardRadioButtonController.selectedSourceLoadValue== 1 ? GetBuilder<SourceNaturalGasController>(
//                                       builder: (sourceNaturalGasController) {
//                                         return   ListView.separated(
//                                           shrinkWrap: true,
//                                           primary: false,
//                                           itemCount: sourceNaturalGasController.isLoading
//                                               ? 3
//                                               : sourceNaturalGasController.naturalGasList.isEmpty || sourceNaturalGasController.hasError
//                                               ? 1
//                                               : sourceNaturalGasController.naturalGasList.length,
//
//                                           itemBuilder: (context,index){
//                                             if(sourceNaturalGasController.isLoading){
//                                               return Padding(
//                                                 padding: EdgeInsets.all(size.height * k8TextSize),
//                                                 child: CustomShimmerWidget(height: size.height * 0.09 , width: double.infinity,),
//                                               );
//                                             } else if(sourceNaturalGasController.naturalGasList.isEmpty){
//
//                                               return Center(child: Lottie.asset(AssetsPath.emptyJson,height: size.height * 0.250));
//                                             } else if(sourceNaturalGasController.hasError){
//
//                                               return  Lottie.asset(AssetsPath.errorJson,height: size.height * 0.250);
//                                             }
//
//
//                                             else{
//                                               dynamic waterData = sourceNaturalGasController.naturalGasList[index];
//
//                                               return OpenContainer(
//                                                   transitionDuration: const Duration(milliseconds: 1400),
//                                                   transitionType: ContainerTransitionType.fadeThrough,
//                                                   closedBuilder: (BuildContext _,VoidCallback openContainer){
//                                                     return  Padding(
//                                                       padding: EdgeInsets.only(right: size.height * k8TextSize),
//                                                       child: Card(
//                                                         elevation: 0,
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius: BorderRadius.circular(size.height * k8TextSize),
//                                                             side: const BorderSide(color: AppColors.containerBorderColor)
//                                                         ),
//                                                         color: AppColors.listTileColor,
//                                                         child: Column(
//                                                           children: [
//                                                             ListTile(
//                                                               //'Solar','Diesel_Generator','Gas_Generator','Grid'
//                                                               contentPadding: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize),
//                                                               leading: SvgPicture.asset(AssetsPath.gasGeneratorIconSVG,height: size.height * k24TextSize,),
//                                                               title: Column(
//                                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                                 children: [
//                                                                   Row(
//                                                                     children: [
//                                                                       Container(
//                                                                         height: size.height * k16TextSize,
//                                                                         width: size.height * k16TextSize,
//                                                                         decoration: BoxDecoration(
//                                                                             color: colorPalette[index % colorPalette.length],
//                                                                             borderRadius: BorderRadius.circular(size.height * 0.003)
//                                                                         ),
//
//                                                                       ),
//                                                                       SizedBox(width: size.width * k16TextSize,),
//                                                                       TextComponent(text: waterData.nodeName ?? ''),
//                                                                     ],
//                                                                   ),
//                                                                   Row(
//                                                                     children: [
//                                                                       const TextComponent(text: "Live Pressure : ",color: AppColors.secondaryTextColor,),
//                                                                       SizedBox(width: size.width * k16TextSize,),
//                                                                       GetBuilder<NaturalGasSLDController>(
//                                                                           builder: (naturalGasSLDController) {
//                                                                             return TextComponent(text: "${naturalGasSLDController.latestDataMap[Get.find<SourceNaturalGasController>().naturalGasList[index].nodeName ?? '']?.pressure?.toStringAsFixed(2) ?? '0.00'} cf");
//                                                                           }
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   Row(
//                                                                     children: [
//                                                                       const TextComponent(text: "Total Cost : ",color: AppColors.secondaryTextColor,),
//                                                                       SizedBox(width: size.width * k16TextSize,),
//                                                                       GetBuilder<NaturalGasSLDController>(
//                                                                           builder: (naturalGasSLDController) {
//                                                                             return TextComponent(text: "${naturalGasSLDController.latestDataMap[Get.find<SourceNaturalGasController>().naturalGasList[index].nodeName ?? '']?.cost?.toStringAsFixed(2) ?? '0.00'} ৳");
//                                                                           }
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                               trailing: Icon(Icons.keyboard_arrow_right_outlined,color: AppColors.secondaryTextColor,size: size.height* k40TextSize,),
//                                                             ),
//                                                             Padding(
//                                                               padding:  EdgeInsets.only(left: size.height * k30TextSize,bottom: size.height * k8TextSize,
//                                                                   right: size.height * k30TextSize),
//                                                               child: GetBuilder<NaturalGasSLDController>(
//                                                                   builder: (naturalGasSLDController) {
//                                                                     return ClipRRect(
//                                                                       borderRadius: BorderRadius.circular(12),
//                                                                       child:  LinearProgressIndicator(
//                                                                         color: colorPalette[index % colorPalette.length],
//                                                                         value: (naturalGasSLDController.latestDataMap[Get.find<SourceNaturalGasController>().naturalGasList[index].nodeName ?? '']?.pressure ?? 0.00)  / 100,
//                                                                         semanticsLabel: 'Linear progress indicator',
//                                                                         minHeight: 9, // Optional: To make it more visible
//                                                                       ),
//                                                                     );
//                                                                   }
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   }, openBuilder: (BuildContext _, VoidCallback __){
//                                                 return  NaturalGasElementDetailsScreen(elementName: waterData.nodeName ?? '',
//                                                     gaugeValue:  Get.find<NaturalGasSLDController>().latestDataMap[Get.find<SourceNaturalGasController>().naturalGasList[index].nodeName ?? '']?.pressure ?? 0.00, gaugeUnit: 'Pa',elementCategory: 'Natural Gas'
//                                                 );
//                                               });
//                                             }
//                                           }, separatorBuilder: (context,index) => const SizedBox(height: 0,),);
//                                       }
//                                   ) : GetBuilder<LoadNaturalGasController>(
//                                       builder: (loadNaturalGasController) {
//                                         return   ListView.separated(
//                                           shrinkWrap: true,
//                                           primary: false,
//                                           itemCount:  loadNaturalGasController.isLoading
//                                               ? 3
//                                               : loadNaturalGasController.naturalGasList.isEmpty || loadNaturalGasController.hasError
//                                               ? 1
//                                               : loadNaturalGasController.naturalGasList.length,
//
//                                           itemBuilder: (context,index){
//                                             if(loadNaturalGasController.isLoading){
//                                               return Padding(
//                                                 padding: EdgeInsets.all(size.height * k8TextSize),
//                                                 child: CustomShimmerWidget(height: size.height * 0.09 , width: double.infinity,),
//                                               );
//                                             } else if(loadNaturalGasController.naturalGasList.isEmpty){
//
//                                               return Center(child: Lottie.asset(AssetsPath.emptyJson,height: size.height * 0.250));
//                                             } else if(loadNaturalGasController.hasError){
//
//                                               return  Lottie.asset(AssetsPath.errorJson,height: size.height * 0.250);
//                                             }
//                                             else{
//                                               dynamic waterData = loadNaturalGasController.naturalGasList[index];
//
//                                               return OpenContainer(
//                                                   transitionDuration: const Duration(milliseconds: 1400),
//                                                   transitionType: ContainerTransitionType.fadeThrough,
//                                                   closedBuilder: (BuildContext _,VoidCallback openContainer){
//                                                     return  Padding(
//                                                       padding: EdgeInsets.only(right: size.height * k8TextSize),
//                                                       child: Card(
//                                                         elevation: 0,
//                                                         shape: RoundedRectangleBorder(
//                                                             borderRadius: BorderRadius.circular(size.height * k8TextSize),
//                                                             side: const BorderSide(color: AppColors.containerBorderColor)
//                                                         ),
//                                                         color: AppColors.listTileColor,
//                                                         child: Column(
//                                                           children: [
//                                                             ListTile(
//                                                               //'Solar','Diesel_Generator','Gas_Generator','Grid'
//                                                               contentPadding: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize),
//                                                               leading: SvgPicture.asset(AssetsPath.loadNaturalGasIconSVG,height: size.height * k24TextSize,)
//                                                               ,
//                                                               title: Column(
//                                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                                 children: [
//                                                                   Row(
//                                                                     children: [
//                                                                       Container(
//                                                                         height: size.height * k16TextSize,
//                                                                         width: size.height * k16TextSize,
//                                                                         decoration: BoxDecoration(
//                                                                             color: colorPalette[index % colorPalette.length],
//                                                                             borderRadius: BorderRadius.circular(size.height * 0.003)
//                                                                         ),
//
//                                                                       ),
//                                                                       SizedBox(width: size.width * k16TextSize,),
//                                                                       TextComponent(text: waterData.nodeName ?? ''),
//                                                                     ],
//                                                                   ),
//                                                                   Row(
//                                                                     children: [
//                                                                       const TextComponent(text: "Live Pressure : ",color: AppColors.secondaryTextColor,),
//                                                                       SizedBox(width: size.width * k16TextSize,),
//                                                                       GetBuilder<NaturalGasSLDController>(
//                                                                           builder: (naturalGasSLDController) {
//                                                                             return TextComponent(text: "${naturalGasSLDController.latestDataMap[Get.find<LoadNaturalGasController>().naturalGasList[index].nodeName ?? '']?.pressure?.toStringAsFixed(2) ?? '0.00'} cf");
//                                                                           }
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   Row(
//                                                                     children: [
//                                                                       const TextComponent(text: "Total Cost : ",color: AppColors.secondaryTextColor,),
//                                                                       SizedBox(width: size.width * k16TextSize,),
//                                                                       GetBuilder<NaturalGasSLDController>(
//                                                                           builder: (naturalGasSLDController) {
//                                                                             return TextComponent(text: "${naturalGasSLDController.latestDataMap[Get.find<LoadNaturalGasController>().naturalGasList[index].nodeName ?? '']?.cost?.toStringAsFixed(2) ?? '0.00'} ৳");
//                                                                           }
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                               trailing: Icon(Icons.keyboard_arrow_right_outlined,color: AppColors.secondaryTextColor,size: size.height* k40TextSize,),
//                                                             ),
//                                                             Padding(
//                                                               padding:  EdgeInsets.only(left: size.height * k30TextSize,bottom: size.height * k8TextSize,
//                                                                   right: size.height * k30TextSize),
//                                                               child:
//                                                               GetBuilder<NaturalGasSLDController>(
//                                                                   builder: (naturalGasSLDController) {
//                                                                     return ClipRRect(
//                                                                       borderRadius: BorderRadius.circular(12),
//                                                                       child:  LinearProgressIndicator(
//                                                                         color: colorPalette[index % colorPalette.length],
//                                                                         value: (naturalGasSLDController.latestDataMap[Get.find<LoadNaturalGasController>().naturalGasList[index].nodeName ?? '']?.pressure ?? 0.00)  / 100,
//                                                                         semanticsLabel: 'Linear progress indicator',
//                                                                         minHeight: 9, // Optional: To make it more visible
//                                                                       ),
//                                                                     );
//                                                                   }
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     );
//                                                   }, openBuilder: (BuildContext _, VoidCallback __){
//                                                 return  NaturalGasElementDetailsScreen(elementName: waterData.nodeName ?? '',
//                                                     gaugeValue:  Get.find<NaturalGasSLDController>().latestDataMap[Get.find<LoadNaturalGasController>().naturalGasList[index].nodeName ?? '']?.pressure ?? 0.00, gaugeUnit: 'Pa',elementCategory: 'Natural Gas'
//                                                 );
//                                               });
//                                             }
//                                           }, separatorBuilder: (context,index) => const SizedBox(height: 0,),);
//                                       }
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }
//                     );
//                   }
//               )
//             ],
//             ),
//        );
//     }
// }