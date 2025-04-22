// import 'package:nz_ums/src/common_widgets/app_bar/custom_app_bar_widget.dart';
// import 'package:nz_ums/src/common_widgets/custom_container_widget.dart';
// import 'package:nz_ums/src/common_widgets/custom_radio_button/custom_radio_button.dart';
// import 'package:nz_ums/src/common_widgets/text_component.dart';
// import 'package:nz_ums/src/features/ems_features/all_live_data/controllers/all_live_info_controller.dart';
// import 'package:nz_ums/src/features/ems_features/all_live_data/controllers/busbar_load_connected_controller.dart';
// import 'package:nz_ums/src/features/ems_features/all_live_data/controllers/busbar_source_connected_controller.dart';
// import 'package:nz_ums/src/features/ems_features/all_live_data/controllers/live_data_controller.dart';
// import 'package:nz_ums/src/features/ems_features/all_live_data/controllers/live_data_load_pie_chart_controller.dart';
// import 'package:nz_ums/src/features/ems_features/all_live_data/controllers/live_data_source_pie_chart_controller.dart';
// import 'package:nz_ums/src/features/ems_features/all_live_data/model/get_all_info_model.dart';
// import 'package:nz_ums/src/features/ems_features/all_live_data/views/widgets/all_live_data_load_pie_chart_widget.dart';
// import 'package:nz_ums/src/features/ems_features/all_live_data/views/widgets/all_live_data_source_pie_chart_widget.dart';
// import 'package:nz_ums/src/features/ems_features/all_live_data/views/widgets/live_table_widget.dart';
// import 'package:nz_ums/src/utility/assets_path/assets_path.dart';
// import 'package:nz_ums/src/utility/style/app_colors.dart';
// import 'package:nz_ums/src/utility/style/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
//
// class AllLiveDataScreen extends StatefulWidget {
//   final String? nodeName;
//   const AllLiveDataScreen({super.key,  this.nodeName});
//
//   @override
//   State<AllLiveDataScreen> createState() => _AllLiveDataScreenState();
// }
//
// class _AllLiveDataScreenState extends State<AllLiveDataScreen> with  TickerProviderStateMixin {
//   final Map<int, AnimationController> _controllers = {};
//   final Map<int, Animation<double>> _animations = {};
//
//   @override
//   void initState() {
//     _chosenModel = widget.nodeName ?? '';
//     Get.find<AllLiveInfoController>().fetchAllLiveData();
//     Get.find<BusBarLoadConnectedController>().fetchLoadConnectedData(nodeName: widget.nodeName ?? '');
//     Get.find<BusBarSourceConnectedController>().fetchSourceConnectedData(nodeName: widget.nodeName ?? '');
//
//     Get.find<LiveDataSourcePieChartController>().fetchLivePieChartData(nodeName: widget.nodeName ?? '');
//     Get.find<LiveDataLoadPieChartController>().fetchLivePieChartData(nodeName: widget.nodeName ?? '');
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controllers.forEach((index, controller) => controller.dispose());
//     super.dispose();
//   }
//    String? _chosenModel;
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       appBar: const CustomAppBarWidget(
//         text: "All Live Data",
//         backPreviousScreen: true,
//       ),
//       body: Stack(
//         children: [
//           Positioned(
//             top: size.height * 0.150,
//             left: 0,
//             right: 0,
//             child: Container(
//               width: size.width,
//               height: size.height,
//               decoration: BoxDecoration(
//                 color: AppColors.whiteTextColor,
//                 border:
//                 Border.all(color: AppColors.containerBorderColor, width: 1.5),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(size.height * k30TextSize),
//                   topRight: Radius.circular(size.height * k30TextSize),
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.only(bottom: size.height * 0.2),
//                   child: GetBuilder<LiveDataController>(
//                     builder: (liveDataController) {
//                       return Column(
//                         children: [
//                           SizedBox(height: size.height * k50TextSize),
//                           SizedBox(
//                               height: size.height * 0.385,
//                               width: size.width,
//                               child: liveDataController.selectedValue == 1 ? const AllLiveDataSourcePieChartWidget() : const AllLiveDataLoadPieChartWidget()),
//                           SizedBox(height: size.height * k8TextSize),
//                           liveDataController.selectedValue == 1? ConstrainedBox(
//                             constraints: BoxConstraints(
//                               maxHeight: MediaQuery.of(context).size.height,
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.only(bottom: size.height * k10TextSize),
//                               child: GetBuilder<BusBarSourceConnectedController>(
//                                   builder: (busBarSourceConnectedController) {
//                                     return ListView.builder(
//                                       shrinkWrap: true,
//                                       primary: false,
//                                       itemCount: busBarSourceConnectedController.busBarSourceConnectedList.length,
//                                       itemBuilder: (context, index) {
//
//                                         var sourceBusBar = busBarSourceConnectedController.busBarSourceConnectedList[index];
//
//                                         _controllers[index] ??= AnimationController(
//                                           duration: const Duration(milliseconds: 400),
//                                           vsync: this,
//                                         );
//
//                                         _animations[index] ??= Tween<double>(begin: 0, end: 0.5).animate(_controllers[index]!);
//
//                                         return Padding(
//                                           padding: EdgeInsets.symmetric(
//                                             horizontal: size.height * k16TextSize,
//                                             vertical: size.height * k8TextSize,
//                                           ),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                               BorderRadius.circular(size.height * k16TextSize),
//                                               border: Border.all(
//                                                   color: AppColors.containerBorderColor,
//                                                   width: 1.0),
//                                             ),
//                                             child: ClipRRect(
//                                               borderRadius:
//                                               BorderRadius.circular(size.height * k16TextSize),
//                                               child: Theme(
//                                                 data: Theme.of(context).copyWith(
//                                                   dividerColor: Colors.transparent,
//                                                   hoverColor: Colors.transparent,
//                                                   highlightColor: Colors.transparent,
//                                                   splashColor: Colors.transparent,
//                                                   expansionTileTheme: const ExpansionTileThemeData(
//                                                     backgroundColor: Colors.transparent,
//                                                     collapsedBackgroundColor: Colors.transparent,
//                                                   ),
//                                                 ),
//                                                 child: ExpansionTile(
//                                                   backgroundColor: Colors.transparent,
//                                                   showTrailingIcon: false,
//                                                   title: Stack(
//                                                     children: [
//                                                       Row(
//                                                         children: [
//                                                           const Column(
//                                                             crossAxisAlignment:
//                                                             CrossAxisAlignment.start,
//                                                             children: [
//                                                               TextComponent(text: "Name", color: AppColors.secondaryTextColor),
//                                                               TextComponent(text: "Live Power", color: AppColors.secondaryTextColor),
//                                                               TextComponent(text: "Frequency", color: AppColors.secondaryTextColor),
//                                                               TextComponent(text: "Today Energy", color: AppColors.secondaryTextColor),
//                                                             ],
//                                                           ),
//                                                           SizedBox(width: size.width * k40TextSize),
//                                                           const Column(
//                                                             children: [
//                                                               TextComponent(text: ":"),
//                                                               TextComponent(text: ":"),
//                                                               TextComponent(text: ":"),
//                                                               TextComponent(text: ":"),
//                                                             ],
//                                                           ),
//                                                           SizedBox(width: size.width * k40TextSize),
//                                                           Column(
//                                                             crossAxisAlignment:
//                                                             CrossAxisAlignment.start,
//                                                             children: [
//                                                               TextComponent(text: sourceBusBar.node ?? '', color: AppColors.primaryTextColor),
//                                                               TextComponent(text: "${sourceBusBar.power?.toStringAsFixed(2) ?? ''} kW", color: AppColors.primaryTextColor),
//                                                               TextComponent(text: sourceBusBar.frequency?.toStringAsFixed(2) ?? '', color: AppColors.primaryTextColor),
//                                                               TextComponent(text: "${sourceBusBar.netEnergy?.toStringAsFixed(2) ?? ''} kWh", color: AppColors.primaryTextColor),
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       Positioned(
//                                                         right: 0,
//                                                         bottom: 0,
//                                                         child: RotationTransition(
//                                                           turns: _animations[index]!,
//                                                           child: SvgPicture.asset(
//                                                             AssetsPath.spinArrowIconSVG,
//                                                             height: size.height * k25TextSize,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   children: [
//                                                     Padding(
//                                                       padding: EdgeInsets.symmetric(horizontal: size.width * k40TextSize),
//                                                       child: const Divider(thickness: 2),
//                                                     ),
//                                                     Column(
//                                                       children: [
//                                                         TextComponent(
//                                                           text: "Live Voltage",
//                                                           color: AppColors.primaryColor,
//                                                           fontSize: size.height * k18TextSize,
//                                                           fontFamily: semiBoldFontFamily,
//                                                         ),
//                                                         SizedBox(height: size.height * k8TextSize),
//                                                         Padding(
//                                                           padding: EdgeInsets.symmetric(horizontal: size.width * k40TextSize),
//                                                           child: LiveTableWidget(
//                                                             size: size,
//                                                             color: const Color(0xFF3CB64A).withOpacity(0.15),
//                                                             line1: "${sourceBusBar.voltage1?.toStringAsFixed(2) ?? '0.0'} V",
//                                                             line2: "${sourceBusBar.voltage2?.toStringAsFixed(2) ?? '0.0'} V",
//                                                             line3: "${sourceBusBar.voltage3?.toStringAsFixed(2) ?? '0.0'} V",
//                                                           ),
//                                                         ),
//                                                         SizedBox(height: size.height * k20TextSize),
//                                                         TextComponent(
//                                                           text: "Live Current",
//                                                           color: AppColors.blueTextColor,
//                                                           fontSize: size.height * k18TextSize,
//                                                           fontFamily: semiBoldFontFamily,
//                                                         ),
//                                                         SizedBox(height: size.height * k8TextSize),
//                                                         Padding(
//                                                           padding: EdgeInsets.symmetric(horizontal: size.width * k40TextSize),
//                                                           child: LiveTableWidget(
//                                                             size: size,
//                                                             color:
//                                                             const Color(0xFF2D98ED).withOpacity(0.15),
//                                                             line1: "${sourceBusBar.current1?.toStringAsFixed(2) ?? '0.0'} A",
//                                                             line2: "${sourceBusBar.current2?.toStringAsFixed(2) ?? '0.0'} A",
//                                                             line3: "${sourceBusBar.current3?.toStringAsFixed(2) ?? '0.0'} A",
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     SizedBox(height: size.height * k20TextSize),
//                                                   ],
//                                                   onExpansionChanged: (bool expanded) {
//                                                     if (expanded) {
//                                                       _controllers[index]!.forward();
//                                                     } else {
//                                                       _controllers[index]!.reverse();
//                                                     }
//                                                   },
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   }
//                               ),
//                             ),
//                           ) :  ConstrainedBox(
//                             constraints: BoxConstraints(
//                               maxHeight: MediaQuery.of(context).size.height,
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.only(bottom: size.height * k10TextSize),
//                               child: GetBuilder<BusBarLoadConnectedController>(
//                                 builder: (busBarLoadConnectedController) {
//                                   return ListView.builder(
//                                     shrinkWrap: true,
//                                     primary: false,
//                                     itemCount: busBarLoadConnectedController.busBarLoadConnectedList.length,
//                                     itemBuilder: (context, index) {
//
//                                       var loadBusBar = busBarLoadConnectedController.busBarLoadConnectedList[index];
//
//                                       _controllers[index] ??= AnimationController(
//                                         duration: const Duration(milliseconds: 400),
//                                         vsync: this,
//                                       );
//
//                                       _animations[index] ??= Tween<double>(begin: 0, end: 0.5).animate(_controllers[index]!);
//
//                                       return Padding(
//                                         padding: EdgeInsets.symmetric(
//                                           horizontal: size.height * k16TextSize,
//                                           vertical: size.height * k8TextSize,
//                                         ),
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                             BorderRadius.circular(size.height * k16TextSize),
//                                             border: Border.all(
//                                                 color: AppColors.containerBorderColor,
//                                                 width: 1.0),
//                                           ),
//                                           child: ClipRRect(
//                                             borderRadius:
//                                             BorderRadius.circular(size.height * k16TextSize),
//                                             child: Theme(
//                                               data: Theme.of(context).copyWith(
//                                                 dividerColor: Colors.transparent,
//                                                 hoverColor: Colors.transparent,
//                                                 highlightColor: Colors.transparent,
//                                                 splashColor: Colors.transparent,
//                                                 expansionTileTheme: const ExpansionTileThemeData(
//                                                   backgroundColor: Colors.transparent,
//                                                   collapsedBackgroundColor: Colors.transparent,
//                                                 ),
//                                               ),
//                                               child: ExpansionTile(
//                                                 backgroundColor: Colors.transparent,
//                                                 showTrailingIcon: false,
//                                                 title: Stack(
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         const Column(
//                                                           crossAxisAlignment:
//                                                           CrossAxisAlignment.start,
//                                                           children: [
//                                                             TextComponent(text: "Name", color: AppColors.secondaryTextColor),
//                                                             TextComponent(text: "Live Power", color: AppColors.secondaryTextColor),
//                                                             TextComponent(text: "Frequency", color: AppColors.secondaryTextColor),
//                                                             TextComponent(text: "Today Energy", color: AppColors.secondaryTextColor),
//                                                           ],
//                                                         ),
//                                                         SizedBox(width: size.width * k40TextSize),
//                                                         const Column(
//                                                           children: [
//                                                             TextComponent(text: ":"),
//                                                             TextComponent(text: ":"),
//                                                             TextComponent(text: ":"),
//                                                             TextComponent(text: ":"),
//                                                           ],
//                                                         ),
//                                                         SizedBox(width: size.width * k40TextSize),
//                                                          Column(
//                                                           crossAxisAlignment:
//                                                           CrossAxisAlignment.start,
//                                                           children: [
//                                                             TextComponent(text: loadBusBar.node ?? '', color: AppColors.primaryTextColor),
//                                                             TextComponent(text: "${loadBusBar.power?.toStringAsFixed(2) ?? ''} kW", color: AppColors.primaryTextColor),
//                                                             TextComponent(text: loadBusBar.frequency?.toStringAsFixed(2) ?? '', color: AppColors.primaryTextColor),
//                                                             TextComponent(text: "${loadBusBar.netEnergy?.toStringAsFixed(2) ?? ''} kWh", color: AppColors.primaryTextColor),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Positioned(
//                                                       right: 0,
//                                                       bottom: 0,
//                                                       child: RotationTransition(
//                                                         turns: _animations[index]!,
//                                                         child: SvgPicture.asset(
//                                                           AssetsPath.spinArrowIconSVG,
//                                                           height: size.height * k25TextSize,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 children: [
//                                                   Padding(
//                                                     padding: EdgeInsets.symmetric(horizontal: size.width * k40TextSize),
//                                                     child: const Divider(thickness: 2),
//                                                   ),
//                                                   Column(
//                                                     children: [
//                                                       TextComponent(
//                                                         text: "Live Voltage",
//                                                         color: AppColors.primaryColor,
//                                                         fontSize: size.height * k18TextSize,
//                                                         fontFamily: semiBoldFontFamily,
//                                                       ),
//                                                       SizedBox(height: size.height * k8TextSize),
//                                                       Padding(
//                                                         padding: EdgeInsets.symmetric(horizontal: size.width * k40TextSize),
//                                                         child: LiveTableWidget(
//                                                           size: size,
//                                                           color: const Color(0xFF3CB64A).withOpacity(0.15),
//                                                           line1: "${loadBusBar.voltage1?.toStringAsFixed(2) ?? '0.0'} V",
//                                                           line2: "${loadBusBar.voltage2?.toStringAsFixed(2) ?? '0.0'} V",
//                                                           line3: "${loadBusBar.voltage3?.toStringAsFixed(2) ?? '0.0'} V",
//                                                         ),
//                                                       ),
//                                                       SizedBox(height: size.height * k20TextSize),
//                                                       TextComponent(
//                                                         text: "Live Current",
//                                                         color: AppColors.blueTextColor,
//                                                         fontSize: size.height * k18TextSize,
//                                                         fontFamily: semiBoldFontFamily,
//                                                       ),
//                                                       SizedBox(height: size.height * k8TextSize),
//                                                       Padding(
//                                                         padding: EdgeInsets.symmetric(horizontal: size.width * k40TextSize),
//                                                         child: LiveTableWidget(
//                                                           size: size,
//                                                           color:
//                                                           const Color(0xFF2D98ED).withOpacity(0.15),
//                                                           line1: "${loadBusBar.current1?.toStringAsFixed(2) ?? '0.0'} A",
//                                                           line2: "${loadBusBar.current2?.toStringAsFixed(2) ?? '0.0'} A",
//                                                           line3: "${loadBusBar.current3?.toStringAsFixed(2) ?? '0.0'} A",
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   SizedBox(height: size.height * k20TextSize),
//                                                 ],
//                                                 onExpansionChanged: (bool expanded) {
//                                                   if (expanded) {
//                                                     _controllers[index]!.forward();
//                                                   } else {
//                                                     _controllers[index]!.reverse();
//                                                   }
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   );
//                                 }
//                               ),
//                             ),
//                           )
//                         ],
//                       );
//                     }
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 85,
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: size.width * k40TextSize,
//                 vertical: size.height * k20TextSize,
//               ),
//               child: GetBuilder<LiveDataController>(
//                   builder: (radioButtonController) {
//                     return CustomContainer(
//                         height: size.height * 0.070,
//                         width: double.infinity,
//                         borderRadius: BorderRadius.circular(size.height * k16TextSize),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             CustomRectangularRadioButton<int>(
//                               value: 1,
//                               groupValue: radioButtonController.selectedValue,
//                               onChanged: (value) {
//                                 radioButtonController.updateSelectedValue(value!);
//                               },
//                               label: 'Source',
//                             ),
//                             CustomRectangularRadioButton<int>(
//                               value: 2,
//                               groupValue: radioButtonController.selectedValue,
//                               onChanged: (value) {
//                                 radioButtonController.updateSelectedValue(value!);
//                               },
//                               label: 'Load',
//                             ),
//                           ],
//                         ));
//                   }),
//             ),
//           ),
//
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: size.width * k40TextSize,
//                 vertical: size.height * k20TextSize,
//               ),
//               child: GetBuilder<AllLiveInfoController>(
//                   builder: (allLiveInfoController) {
//                     return  CustomContainer(
//                       height: size.height * 0.070,
//                       width: double.infinity,
//                       borderRadius: BorderRadius.circular(size.height * k16TextSize),
//                       child: Center(
//                         child: DropdownButton(
//                             underline: const SizedBox(),
//                           value: _chosenModel,
//                           items: allLiveInfoController.allLiveInfoList
//                               .map<DropdownMenuItem<String>>((GetAllLiveInfoModel model) {
//                             return DropdownMenuItem<String>(
//                               value: model.nodeName, // Replace with the property of GetAllLiveInfoModel you want as the value
//                               child: Text(model.nodeName?? ''), // Replace with the display text property
//                             );
//                           }).toList(),
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               _chosenModel = newValue;
//                               Get.find<BusBarLoadConnectedController>().fetchLoadConnectedData(nodeName: newValue?? '');
//                               Get.find<BusBarSourceConnectedController>().fetchSourceConnectedData(nodeName: newValue ?? '');
//
//                               Get.find<LiveDataSourcePieChartController>().fetchLivePieChartData(nodeName: newValue ?? '');
//                               Get.find<LiveDataLoadPieChartController>().fetchLivePieChartData(nodeName: newValue ?? '');
//                             });
//                           },
//                           hint: const TextComponent(text: "Choose BusBar")
//                         ),
//
//                       ),
//                     );
//                   }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
