import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/controller/busbar_status_info_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/controller/electricity_long_sld_live_all_node_power_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/controller/electricity_short_sld_live_all_node_power_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/controller/electricity_short_sld_live_pf_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/controller/electricity_short_sld_lt_production_vs_capacity_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/model/electricity_short_view_page_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/views/screens/electricity_short_sld_main_bus_bar_true/screen/electricity_short_sld_main_bus_bar_true_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/views/widgets/short_electricity_bus_couplar_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/views/widgets/short_electricity_line_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/views/widgets/short_electricity_main_bus_bar_2.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/views/widgets/short_electricity_meter_bus_bar_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/views/widgets/short_electricity_nz_box_with_icon_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/views/widgets/short_electricity_nz_circle_with_icon_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/views/widgets/short_electricity_nz_source_and_load_box_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/views/widgets/short_electricity_nz_tr_box_with_icon_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/views/widgets/short_electricity_super_bus_bar_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/machine_view_names_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/views/screens/pf_history_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/generators/generator_element_details_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/screen/power_and_energy_element_details_screen.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:ui' as ui;

import '../../model/electricity_short_live_all_node_power_model.dart';

// class ElectricityShortSld extends StatefulWidget {
//   const ElectricityShortSld({super.key});
//
//   @override
//   State<ElectricityShortSld> createState() => _ElectricityShortSldState();
// }
//
// class _ElectricityShortSldState extends State<ElectricityShortSld> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
//   // Keep state variables
//   List<ElectricityShortViewPageModel> _viewPageData = [];
//   Map<dynamic, LiveDataModel> _liveData = {};
//   bool _isLoading = true;
//   late AnimationController _controller;
//   late ui.Image _mouseIcon;
//   bool _isFetchingViewPageData = false;
//   bool _isFetchingPFData = false;
//   Timer? _timer;
//   List<Map<String, dynamic>> _pfData = [];
//
//   @override
//   void initState() {
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..repeat();
//
//     _loadMouseIcon();
//     _loadCachedData();
//
//    _fetchViewPageData();
//
//
//     Get.find<ElectricityShortSLDLiveAllNodePowerController>().fetchLiveAllNodePower();
//
//
//     // Stop other controllers
//     Get.find<CategoryWiseLiveDataController>().stopApiCallOnScreenChange();
//     Get.find<MachineViewNamesDataController>().stopApiCallOnScreenChange();
//     Get.find<WaterSourceCategoryWiseDataController>().stopApiCallOnScreenChange();
//     Get.find<WaterLoadCategoryWiseDataController>().stopApiCallOnScreenChange();
//     Get.find<ElectricityLongSLDLiveAllNodePowerController>().stopApiCallOnScreenChange();
//
//
//     WidgetsBinding.instance.addObserver(this);
//
//     super.initState();
//   }
//
//
//
//
//
//
//   void _loadMouseIcon() async {
//     final ByteData data = await rootBundle.load('assets/images/Rectangle 1816.png');
//     final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
//     final ui.FrameInfo fi = await codec.getNextFrame();
//     setState(() {
//       _mouseIcon = fi.image;
//     });
//   }
//
//   // OPTIMIZATION 1: Load cached data first without triggering full UI rebuilds
//   Future<void> _loadCachedData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Load cached view page data
//     String? cachedViewPageData = prefs.getString('cached_viewPageData');
//     String? viewPageCacheTime = prefs.getString('cached_viewPageData_time');
//     bool isCacheValid = false;
//
//     if (cachedViewPageData != null && viewPageCacheTime != null) {
//       DateTime cacheTime = DateTime.parse(viewPageCacheTime);
//       if (DateTime.now().difference(cacheTime).inMinutes < 5) { // Cache valid for 5 minutes
//         isCacheValid = true;
//         final List<ElectricityShortViewPageModel> parsedData = (json.decode(cachedViewPageData) as List)
//             .map((data) => ElectricityShortViewPageModel.fromJson(data))
//             .toList();
//
//         // Load cached live data
//         String? cachedLiveData = prefs.getString('cached_liveData');
//         Map<dynamic, LiveDataModel> parsedLiveData = {};
//
//         if (cachedLiveData != null) {
//           parsedLiveData = Map<int, LiveDataModel>.from(json
//               .decode(cachedLiveData)
//               .map((id, data) => MapEntry(int.parse(id), LiveDataModel.fromJson(data))));
//         }
//
//         // Set state only once
//         setState(() {
//           _viewPageData = parsedData;
//           _liveData = parsedLiveData;
//           _isLoading = false;
//
//           _liveData.forEach((key,value){
//             debugPrint('------------->>> $key +++> $value');
//           });
//
//         });
//       }
//     }
//
//     // Only fetch new data if cache is invalid or empty
//     if (!isCacheValid) {
//       Future.delayed(const Duration(seconds: kTimer), () {
//         if (!_isFetchingPFData) _fetchPFData();
//         if (!_isFetchingViewPageData) _initializeData();
//
//         // Start controllers for data fetching but not UI rebuilding
//         final productionController = Get.find<ElectricityShortSLDLtProductionVsCapacityController>();
//         final nodePowerController = Get.find<ElectricityShortSLDLiveAllNodePowerController>();
//
//         productionController.fetchProductVsCapacityData();
//         nodePowerController.fetchLiveAllNodePower();
//       });
//     } else {
//       // Even with valid cache, start periodic updates
//       Future.delayed(const Duration(seconds: kTimer), () {
//         startTimer();
//       });
//     }
//   }
//
//   // OPTIMIZATION 2: Separate initialization of data without full UI rebuilds
//   Future<void> _initializeData() async {
//     await _fetchViewPageData();
//     _cacheData(); // Cache data after fetching
//   }
//
//   // OPTIMIZATION 3: Cache data for future use
//   Future<void> _cacheData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     await prefs.setString(
//         'cached_viewPageData',
//         json.encode(_viewPageData.map((data) => data.toJson()).toList()));
//     await prefs.setString('cached_viewPageData_time', DateTime.now().toIso8601String());
//     await prefs.setString(
//         'cached_liveData',
//         json.encode(_liveData.map((id, data) => MapEntry(id.toString(), data.toJson()))));
//   }
//
//   // OPTIMIZATION 4: Fetch view page data without triggering full UI rebuilds
//   Future<void> _fetchViewPageData() async {
//     if (_isFetchingViewPageData || !mounted) return;
//     _isFetchingViewPageData = true;
//     final requestId = Uuid().v4(); // Unique ID for this request
//   //  debugPrint('[$requestId] Fetching view page data at ${DateTime.now()}');
//
//     try {
//       // Only show loading on initial load, not on refreshes
//       if (_viewPageData.isEmpty) {
//         setState(() {
//           _isLoading = true;
//         });
//       }
//
//       final response = await http.get(
//         Uri.parse(Urls.shortElectricityUrl),
//         headers: {'Authorization': "${AuthUtilityController.accessToken}"},
//       );
//     //  debugPrint('[$requestId] View page data response: ${response.statusCode} at ${DateTime.now()}');
//       debugPrint('----------------------->>> Electricity Short _fetchViewPageData api call-------------------');
//
//       if (response.statusCode == 200 && mounted) {
//         final List<dynamic> data = json.decode(response.body);
//         final newViewPageData = data.map((e) => ElectricityShortViewPageModel.fromJson(e)).toList();
//
//         // Only update the UI if data actually changed
//         if (!_compareViewPageData(_viewPageData, newViewPageData)) {
//           setState(() {
//             _viewPageData = newViewPageData;
//             if (_isLoading) _isLoading = false;
//           });
//         }
//
//         // Fetch bus coupler and loop data without rebuilding the whole UI
//         ElectricityShortSLDGetAllInfoUIControllers controller = Get.find();
//         final fetchRequests = _viewPageData
//             .where((item) => item.sourceType == 'BusCoupler' || item.sourceType == 'Loop')
//             .map((item) => fetchAndUpdatePowerMeter(item.nodeName, item.sourceType, controller, requestId))
//             .toList();
//
//         //debugPrint('[$requestId] Fetching ${fetchRequests.length} power meter requests');
//         await Future.wait(fetchRequests);
//       } else {
//         throw Exception('Failed to load view page data');
//       }
//     } catch (e) {
//       debugPrint('[$requestId] Error fetching view page data: $e');
//     } finally {
//       _isFetchingViewPageData = false;
//
//       // Only update loading state if we started loading in this method
//       if (_isLoading && mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//
//      // debugPrint('[$requestId] Fetch view page data completed at ${DateTime.now()}');
//     }
//   }
//
//   // Helper method to compare view page data to avoid unnecessary rebuilds
//   bool _compareViewPageData(List<ElectricityShortViewPageModel> oldData, List<ElectricityShortViewPageModel> newData) {
//     if (oldData.length != newData.length) return false;
//
//     for (int i = 0; i < oldData.length; i++) {
//       if (oldData[i].id != newData[i].id ||
//           oldData[i].nodeName != newData[i].nodeName ||
//           oldData[i].sourceType != newData[i].sourceType) {
//         return false;
//       }
//     }
//
//     return true;
//   }
//
//   // OPTIMIZATION 5: Update power meter data without triggering full UI rebuilds
//   Future<void> fetchAndUpdatePowerMeter(String nodeName, String sourceType,
//       ElectricityShortSLDGetAllInfoUIControllers controller, String parentRequestId) async {
//     final requestId = Uuid().v4();
//   //  debugPrint('[$requestId] Fetching power meter for $nodeName (Parent: $parentRequestId) at ${DateTime.now()}');
//
//     try {
//       final meterResponse = await http.get(
//         Uri.parse(Urls.busCouplerConnectedMeterUrl(nodeName, sourceType)),
//         headers: {'Authorization': "${AuthUtilityController.accessToken}"},
//       );
//      /// debugPrint('[$requestId] Power meter response for $nodeName: ${meterResponse.statusCode}');
//       debugPrint('----------------------->>> Electricity Short fetchAndUpdatePowerMeter api call-------------------');
//
//       if (meterResponse.statusCode == 200) {
//         final meterData = json.decode(meterResponse.body);
//         double powerMeter = meterData['power_meter'] ?? 0.0;
//        // debugPrint('[$requestId] Updating power meter for $nodeName -> $powerMeter');
//
//         // Update through controller without rebuilding entire widget
//         controller.updatePowerMeter(powerMeter, nodeName);
//       }
//     } catch (e) {
//       debugPrint('[$requestId] Error fetching power meter data for $nodeName: $e');
//     }
//   }
//
//   // OPTIMIZATION 6: Fetch PF data without triggering full UI rebuilds
//   Future<void> _fetchPFData() async {
//     if (_isFetchingPFData || !mounted) return;
//     _isFetchingPFData = true;
//     final requestId = Uuid().v4();
//   //  debugPrint('[$requestId] Fetching PF data at ${DateTime.now()}');
//
//     try {
//       final response = await http.get(
//         Uri.parse('/api/get-pf-item-positions/'),
//         headers: {'Authorization': '${AuthUtilityController.accessToken}'},
//       );
//
//       debugPrint('----------------------->>> Electricity Short _fetchPFData api call-------------------');
//
//
//
//
//       // debugPrint('[$requestId] PF data response: ${response.statusCode} at ${DateTime.now()}');
//
//       if (response.statusCode == 200 && mounted) {
//         final newPfData = List<Map<String, dynamic>>.from(json.decode(response.body));
//
//         // Only update if data actually changed
//         if (!_comparePFData(_pfData, newPfData)) {
//           setState(() {
//             _pfData = newPfData;
//           });
//         }
//       } else {
//         debugPrint('[$requestId] Failed to fetch PF data');
//       }
//     } catch (e) {
//       debugPrint('[$requestId] Error fetching PF data: $e');
//     } finally {
//       _isFetchingPFData = false;
//     //  debugPrint('[$requestId] Fetch PF data completed at ${DateTime.now()}');
//     }
//   }
//
//   // Helper method to compare PF data to avoid unnecessary rebuilds
//   bool _comparePFData(List<Map<String, dynamic>> oldData, List<Map<String, dynamic>> newData) {
//     if (oldData.length != newData.length) return false;
//
//     for (int i = 0; i < oldData.length; i++) {
//       if (oldData[i]['node_name'] != newData[i]['node_name']) {
//         return false;
//       }
//     }
//
//     return true;
//   }
//
//   // OPTIMIZATION 7: Smart timer management
//   void stopTimer() {
//     _timer?.cancel();
//     _timer = null;
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (ModalRoute.of(context)?.isCurrent ?? false) {
//       // Delay timer start to avoid overlap with initState
//       Future.delayed(const Duration(seconds: 2), () {
//         startTimer();
//       });
//     } else {
//       stopTimer();
//     }
//   }
//
//   // OPTIMIZATION 8: Timer only updates data, not UI
//   void startTimer() {
//     stopTimer();
//     _timer = Timer.periodic(const Duration(seconds: kTimer), (Timer timer) {
//       // Only fetch data if not already fetching
//       if (!_isFetchingViewPageData) _fetchViewPageData();
//       if (!_isFetchingPFData) _fetchPFData();
//
//       // Update controller data without rebuilding entire UI
//       final productionController = Get.find<ElectricityShortSLDLtProductionVsCapacityController>();
//       final nodePowerController = Get.find<ElectricityShortSLDLiveAllNodePowerController>();
//
//       productionController.fetchProductVsCapacityData();
//       nodePowerController.fetchLiveAllNodePower();
//     });
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     // Handle app lifecycle changes to manage timer efficiently
//     if (state == AppLifecycleState.resumed) {
//       // App came to foreground
//       if (ModalRoute.of(context)?.isCurrent ?? false) {
//         startTimer();
//       }
//     } else if (state == AppLifecycleState.paused) {
//       // App went to background
//       stopTimer();
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     stopTimer();
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child: SpinKitFadingCircle(
//             color: AppColors.primaryColor,
//             size: 50.0,
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             // Handle empty or invalid viewPageData
//             if (_viewPageData.isEmpty) {
//               return const Center(
//                 child: Text('No data available'),
//               );
//             }
//
//             // Calculate content dimensions with validation
//             double minX = _getMinX();
//             double minY = _getMinY();
//             double maxX = _getMaxX();
//             double maxY = _getMaxY();
//
//             // Ensure valid content dimensions
//             double contentWidth = maxX - minX;
//             double contentHeight = maxY - minY;
//
//             // Fallback dimensions to prevent division by zero
//             contentWidth = contentWidth.isFinite && contentWidth > 0 ? contentWidth : constraints.maxWidth;
//             contentHeight = contentHeight.isFinite && contentHeight > 0 ? contentHeight : constraints.maxHeight;
//
//             // Calculate scale to fit screen
//             double scaleX = constraints.maxWidth / contentWidth;
//             double scaleY = constraints.maxHeight / contentHeight;
//             double scale = min(scaleX, scaleY);
//
//             // Ensure scale is finite
//             scale = scale.isFinite ? scale : 1.0;
//
//           //  debugPrint('minX: $minX, minY: $minY, maxX: $maxX, maxY: $maxY');
//           //  debugPrint('contentWidth: $contentWidth, contentHeight: $contentHeight, scale: $scale');
//
//             return PhotoViewGallery.builder(
//               itemCount: 1,
//               builder: (context, index) {
//                 return PhotoViewGalleryPageOptions.customChild(
//                   childSize: Size(contentWidth * scale, contentHeight * scale),
//                   minScale: PhotoViewComputedScale.contained * 0.2,
//                   maxScale: PhotoViewComputedScale.contained * 8.0,
//                   initialScale: PhotoViewComputedScale.contained,
//                   basePosition: Alignment.center,
//                   child: Center(
//                     child: SizedBox(
//                       width: contentWidth * scale,
//                       height: contentHeight * scale,
//                       child: FittedBox(
//                         fit: BoxFit.contain,
//                         child: SizedBox(
//                           width: contentWidth,
//                           height: contentHeight,
//                           child: Stack(
//                             children: [
//                               CustomPaint(
//                                 size: Size(contentWidth, contentHeight),
//                                 painter: ElectricityShortSLDAnimatedLinePainter(
//                                   viewPageData: _viewPageData,
//                                   liveData: _liveData,
//                                   minX: minX,
//                                   minY: minY,
//                                   animation: _controller.view,
//                                 ),
//                               ),
//                               ..._buildWidgets(minX, minY),
//                               ..._buildPFWidgets(minX, minY),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               scrollDirection: Axis.horizontal,
//               backgroundDecoration: const BoxDecoration(color: Colors.white),
//               gaplessPlayback: true,
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   double _getMinX() {
//     if (_viewPageData.isEmpty) return 0.0;
//     return _viewPageData
//         .where((e) => e.positionX.isFinite)
//         .map((e) => e.positionX)
//         .reduce(min);
//   }
//
//   double _getMinY() {
//     if (_viewPageData.isEmpty) return 0.0;
//     return _viewPageData
//         .where((e) => e.positionY.isFinite)
//         .map((e) => e.positionY)
//         .reduce(min);
//   }
//
//   double _getMaxX() {
//     if (_viewPageData.isEmpty) return 0.0;
//     return _viewPageData
//         .where((e) => (e.positionX + e.width).isFinite)
//         .map((e) => e.positionX + e.width)
//         .reduce(max);
//   }
//
//   double _getMaxY() {
//     if (_viewPageData.isEmpty) return 0.0;
//     return _viewPageData
//         .where((e) => (e.positionY + e.height).isFinite)
//         .map((e) => e.positionY + e.height)
//         .reduce(max);
//   }
//
//
//   /*--------------Pf here----------*/
//   List<Widget> _buildPFWidgets(double minX, double minY) {
//     return _pfData.map((item) {
//       var controller = Get.put(ElectricityShortSldLivePfDataController(), tag: item['node_name']);
//       controller.fetchLivePFData(nodeName: item['node_name']);
//
//       return GetBuilder<ElectricityShortSldLivePfDataController>(
//         tag: item['node_name'],
//         builder: (controller) {
//           return Positioned(
//             left: item['position_x'] - minX,
//             top: item['position_y'] - minY,
//             child: Container(
//               width: item['width'].toDouble(),
//               height: item['height'].toDouble(),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.blue, width: 2),
//                 color: Colors.blue.withOpacity(0.3),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       color: Colors.white,
//                       child: Center(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 "PF : ",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 controller.livePFDataModel.powerFactor != null
//                                     ? controller.livePFDataModel.powerFactor
//                                     .toStringAsFixed(4)
//                                     .toString()
//                                     : '0',
//                                 style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold),
//                               )
//                             ],
//                           )),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Get.to(() => PfHistoryScreen(nodeName: item['node_name']),
//                         transition: Transition.fadeIn,
//                         duration: const Duration(seconds: 1),
//                       );
//                     },
//                     child: Stack(
//                       children: [
//                         Container(
//                           width: 50,
//                           color: Colors.red,
//                           child: Center(
//                             child: Text(
//                               controller.livePFDataModel.count != null
//                                   ? controller.livePFDataModel.count.toString()
//                                   : '0',
//                               style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                         const Positioned(
//                             left: 5,
//                             top: 3,
//                             child: Icon(
//                               Icons.notifications,
//                               size: 18,
//                               color: Colors.white,
//                             ))
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }).toList();
//   }
//
//   void loadMouseIcon() async {
//     final ByteData data =
//     await rootBundle.load('assets/images/Rectangle1484.png');
//     final ui.Codec codec =
//     await ui.instantiateImageCodec(data.buffer.asUint8List());
//     final ui.FrameInfo fi = await codec.getNextFrame();
//     setState(() {
//       _mouseIcon = fi.image;
//     });
//   }
//
//
//
//   List<Widget> _buildWidgets(double minX, double minY) {
//     return _viewPageData.map((item) {
//       Widget widget;
//
//       Color hexToColor(String hex) {
//         hex = hex.isEmpty ? '#000000' : hex.replaceAll('#', '');
//         try {
//           return Color(int.parse('0xFF$hex'));
//         } catch (e) {
//           debugPrint('Invalid hex color: $hex, using default #000000');
//           return const Color(0xFF000000);
//         }
//       }
//
//       switch (item.shape) {
//         case 'circle':
//           widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
//             id: 'node_${item.nodeName}',
//             builder: (controller) {
//               final nodeData = controller.liveAllNodePowerModel.firstWhere(
//                     (element) => element.node == item.nodeName,
//                 orElse: () => ElectricityShortLiveAllNodePowerModel(),
//               );
//               final bool hasData = nodeData.node != null;
//               if (!hasData) {
//                 debugPrint('No data for circle node: ${item.nodeName}, using power: 0.0');
//               }
//               final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
//               return ShortElectricityCircleWithIcon(
//                 sensorStatus: power != 0.0,
//                 value: power,
//                 borderColor: item.color ?? '#FF0000',
//                 icon: FontAwesomeIcons.bolt,
//                 text: item.nodeName,
//                 width: item.width.toDouble(),
//                 height: item.height.toDouble(),
//                 onTap: () {
//                   debugPrint("----->CircleWithIcon<-----");
//                   if (item.category == 'Diesel_Generator') {
//                     Get.to(
//                           () => GeneratorElementDetailsScreen(
//                         elementName: item.nodeName,
//                         gaugeValue: power,
//                         gaugeUnit: 'kW',
//                         elementCategory: 'Power',
//                       ),
//                       transition: Transition.rightToLeft,
//                       duration: const Duration(seconds: 1),
//                     );
//                   } else {
//                     Get.to(
//                           () => PowerAndEnergyElementDetailsScreen(
//                         elementName: item.nodeName,
//                         gaugeValue: power,
//                         gaugeUnit: 'kW',
//                         elementCategory: 'Power',
//                         solarCategory: item.category,
//                       ),
//                       transition: Transition.rightToLeft,
//                       duration: const Duration(seconds: 1),
//                     );
//                   }
//                 },
//                 unit: 'kW',
//               );
//             },
//           );
//           break;
//
//         case 'LB_Meter':
//           widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
//             id: 'node_${item.nodeName}',
//             builder: (controller) {
//               final nodeData = controller.liveAllNodePowerModel.firstWhere(
//                     (element) => element.node == item.nodeName,
//                 orElse: () => ElectricityShortLiveAllNodePowerModel(),
//               );
//               final bool hasData = nodeData.node != null;
//               if (!hasData) {
//                 debugPrint('No data for LB_Meter node: ${item.nodeName}, using power: 0.0');
//               }
//               final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
//               final String percentage = hasData && nodeData.percentage != null
//                   ? nodeData.percentage.toStringAsFixed(2)
//                   : "0.00";
//               final String capacity = hasData && nodeData.capacity != null
//                   ? nodeData.capacity.toStringAsFixed(2)
//                   : "0.00";
//               return ShortElectricityBoxWithIconWidget(
//                 sensorStatus: power != 0.0,
//                 value: power,
//                 icon: FontAwesomeIcons.solarPanel,
//                 label: item.nodeName,
//                 width: item.width.toDouble(),
//                 height: item.height.toDouble(),
//                 onTap: () {},
//                 unit: 'kW',
//                 borderColor: item.borderColor ?? '#FF0000',
//                 percentage: percentage,
//                 capacity: capacity,
//               );
//             },
//           );
//           break;
//
//         case 'box':
//           widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
//             id: 'node_${item.nodeName}',
//             builder: (controller) {
//               final nodeData = controller.liveAllNodePowerModel.firstWhere(
//                     (element) => element.node == item.nodeName,
//                 orElse: () => ElectricityShortLiveAllNodePowerModel(),
//               );
//               final bool hasData = nodeData.node != null;
//               if (!hasData) {
//                 debugPrint('No data for box node: ${item.nodeName}, using power: 0.0');
//               }
//               final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
//               final String percentage = hasData && nodeData.percentage != null
//                   ? nodeData.percentage.toStringAsFixed(2)
//                   : "0.00";
//               final String capacity = hasData && nodeData.capacity != null
//                   ? nodeData.capacity.toStringAsFixed(2)
//                   : "0.00";
//               return ShortElectrcityTrBoxWithIconWidget(
//                 sensorStatus: power != 0.0,
//                 value: power,
//                 icon: FontAwesomeIcons.solarPanel,
//                 label: item.nodeName,
//                 width: item.width.toDouble(),
//                 height: item.height.toDouble(),
//                 onTap: () {
//                   debugPrint("----->TrBoxWithIconWidget<-----");
//                   if (item.category == 'Diesel_Generator') {
//                     Get.to(
//                           () => GeneratorElementDetailsScreen(
//                         elementName: item.nodeName,
//                         gaugeValue: power,
//                         gaugeUnit: 'kW',
//                         elementCategory: 'Power',
//                       ),
//                       transition: Transition.rightToLeft,
//                       duration: const Duration(seconds: 1),
//                     );
//                   } else {
//                     Get.to(
//                           () => PowerAndEnergyElementDetailsScreen(
//                         elementName: item.nodeName,
//                         gaugeValue: power,
//                         gaugeUnit: 'kW',
//                         elementCategory: 'Power',
//                         solarCategory: item.category,
//                       ),
//                       transition: Transition.rightToLeft,
//                       duration: const Duration(seconds: 1),
//                     );
//                   }
//                 },
//                 unit: 'kW',
//                 borderColor: item.color ?? '#FF0000',
//                 percentage: percentage,
//                 capacity: capacity,
//               );
//             },
//           );
//           break;
//
//         case 'Bus_Bar':
//           if (item.sourceType == 'Super_Bus_Bar') {
//             widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
//               id: 'node_${item.nodeName}',
//               builder: (nodeController) {
//                 return GetBuilder<ElectricityShortSLDLtProductionVsCapacityController>(
//                   builder: (capacityController) {
//                     final nodeData = nodeController.liveAllNodePowerModel.firstWhere(
//                           (element) => element.node == item.nodeName,
//                       orElse: () => ElectricityShortLiveAllNodePowerModel(),
//                     );
//                     final bool hasData = nodeData.node != null;
//                     if (!hasData) {
//                       debugPrint('No data for Super_Bus_Bar node: ${item.nodeName}, using power: 0.0');
//                     }
//                     final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
//                     return ShortElectricitySuperBusBarWidget(
//                       sensorStatus: power != 0.0,
//                       value: power,
//                       nodeName: item.nodeName,
//                       backgroundColor: item.color ?? '#FF0000',
//                       borderColor: item.borderColor ?? '#FF0000',
//                       textColor: item.textColor != null ? hexToColor(item.textColor!) : Colors.black,
//                       loadBoxHeight: item.height.toDouble(),
//                       loadBoxWidth: item.width.toDouble(),
//                       onTap: () {},
//                       unit: 'kW',
//                       gridColor: capacityController.ltProductionVsCapacityModel.gridColor ?? '#ffffff',
//                       generatorColor: capacityController.ltProductionVsCapacityModel.generatorColor ?? '#ffffff',
//                       solarColor: capacityController.ltProductionVsCapacityModel.solarColor ?? '#ffffff',
//                       gridPercentage: item.nodeName == "LT-02 A"
//                           ? capacityController.ltProductionVsCapacityModel.lt02AGridPercentage ?? 0.00
//                           : item.nodeName == "LT-02 B"
//                           ? capacityController.ltProductionVsCapacityModel.lt02BGridPercentage ?? 0.00
//                           : item.nodeName == "LT-01 A"
//                           ? capacityController.ltProductionVsCapacityModel.lt01AGridPercentage ?? 0.00
//                           : item.nodeName == "LT-01 B"
//                           ? capacityController.ltProductionVsCapacityModel.lt01BGridPercentage ?? 0.00
//                           : 0.00,
//                       generatorPercentage: item.nodeName == "LT-02 A"
//                           ? capacityController.ltProductionVsCapacityModel.lt02AGeneratorPercentage ?? 0.00
//                           : item.nodeName == "LT-02 B"
//                           ? capacityController.ltProductionVsCapacityModel.lt02BGeneratorPercentage ?? 0.00
//                           : item.nodeName == "LT-01 A"
//                           ? capacityController.ltProductionVsCapacityModel.lt01AGeneratorPercentage ?? 0.00
//                           : item.nodeName == "LT-01 B"
//                           ? capacityController.ltProductionVsCapacityModel.lt01BGeneratorPercentage ?? 0.00
//                           : 0.00,
//                       solarPercentage: item.nodeName == "LT-02 A"
//                           ? capacityController.ltProductionVsCapacityModel.lt02ASolarPercentage ?? 0.00
//                           : item.nodeName == "LT-02 B"
//                           ? capacityController.ltProductionVsCapacityModel.lt02BSolarPercentage ?? 0.00
//                           : item.nodeName == "LT-01 A"
//                           ? capacityController.ltProductionVsCapacityModel.lt01ASolarPercentage ?? 0.00
//                           : item.nodeName == "LT-01 B"
//                           ? capacityController.ltProductionVsCapacityModel.lt01BSolarPercentage ?? 0.00
//                           : 0.00,
//                       gridValue: item.nodeName == "LT-02 A"
//                           ? capacityController.ltProductionVsCapacityModel.lt02AGridPower ?? 0.00
//                           : item.nodeName == "LT-02 B"
//                           ? capacityController.ltProductionVsCapacityModel.lt02BGridPower ?? 0.00
//                           : item.nodeName == "LT-01 A"
//                           ? capacityController.ltProductionVsCapacityModel.lt01AGridPower ?? 0.00
//                           : item.nodeName == "LT-01 B"
//                           ? capacityController.ltProductionVsCapacityModel.lt01BGridPower ?? 0.00
//                           : 0.00,
//                       generatorValue: item.nodeName == "LT-02 A"
//                           ? capacityController.ltProductionVsCapacityModel.lt02AGeneratorPower ?? 0.00
//                           : item.nodeName == "LT-02 B"
//                           ? capacityController.ltProductionVsCapacityModel.lt02BGeneratorPower ?? 0.00
//                           : item.nodeName == "LT-01 A"
//                           ? capacityController.ltProductionVsCapacityModel.lt01AGeneratorPower ?? 0.00
//                           : item.nodeName == "LT-01 B"
//                           ? capacityController.ltProductionVsCapacityModel.lt01BGeneratorPower ?? 0.00
//                           : 0.00,
//                       solarValue: item.nodeName == "LT-02 A"
//                           ? capacityController.ltProductionVsCapacityModel.lt02ASolarPower ?? 0.00
//                           : item.nodeName == "LT-02 B"
//                           ? capacityController.ltProductionVsCapacityModel.lt02BSolarPower ?? 0.00
//                           : item.nodeName == "LT-01 A"
//                           ? capacityController.ltProductionVsCapacityModel.lt01ASolarPower ?? 0.00
//                           : item.nodeName == "LT-01 B"
//                           ? capacityController.ltProductionVsCapacityModel.lt01BSolarPower ?? 0.00
//                           : 0.00,
//                       y: (item.nodeName == "LT-02 A" || item.nodeName == "LT-02 B") ? 40 : -95,
//                       orientation: item.orientation,
//                     );
//                   },
//                 );
//               },
//             );
//           } else if (item.sourceType == 'Load_Bus_Bar' || item.sourceType == 'Bus_Bar') {
//             if (item.mainBusbar ?? false) {
//               widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
//                 id: 'node_${item.nodeName}',
//                 builder: (controller) {
//                   final nodeData = controller.liveAllNodePowerModel.firstWhere(
//                         (element) => element.node == item.nodeName,
//                     orElse: () => ElectricityShortLiveAllNodePowerModel(),
//                   );
//                   final bool hasData = nodeData.node != null;
//                   if (!hasData) {
//                     debugPrint('No data for Bus_Bar node: ${item.nodeName}, using power: 0.0');
//                   }
//                   final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
//                   final String percentage = hasData && nodeData.percentage != null
//                       ? nodeData.percentage.toStringAsFixed(2)
//                       : "0.00";
//                   final String capacity = hasData && nodeData.capacity != null
//                       ? nodeData.capacity.toStringAsFixed(2)
//                       : "0.00";
//                   return ShortElectricityMainBusBarTrue(
//                     sensorStatus: power != 0.0,
//                     value: power,
//                     nodeName: item.nodeName,
//                     color: item.color ?? '#FF0000',
//                     borderColor: item.borderColor ?? '#FF0000',
//                     textColor: item.textColor,
//                     textSize: item.textSize,
//                     loadBoxHeight: item.height.toDouble(),
//                     loadBoxWidth: item.width.toDouble(),
//                     onTap: () {
//                       Get.to(
//                             () => ElectricityShortSLDMainBusBarTrueScreen(
//                           busBarName: item.nodeName,
//                         ),
//                         transition: Transition.rightToLeft,
//                         duration: const Duration(seconds: 1),
//                       );
//                     },
//                     unit: 'kW',
//                     percentage: percentage,
//                     capacity: capacity,
//                     orientation: item.orientation ?? 'horizontal',
//                   );
//                 },
//               );
//             } else {
//               widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
//                 id: 'node_${item.nodeName}',
//                 builder: (controller) {
//                   final nodeData = controller.liveAllNodePowerModel.firstWhere(
//                         (element) => element.node == item.nodeName,
//                     orElse: () => ElectricityShortLiveAllNodePowerModel(),
//                   );
//                   final bool hasData = nodeData.node != null;
//                   if (!hasData) {
//                     debugPrint('No data for Load_Bus_Bar/Bus_Bar node: ${item.nodeName}, using power: 0.0');
//                   }
//                   final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
//                   return ShortElectricitySourceAndLoadBoxWidget(
//                     sensorStatus: power != 0.0,
//                     value: power,
//                     nodeName: item.nodeName,
//                     borderColor: item.borderColor ?? '#FF0000',
//                     textColor: item.textColor,
//                     textSize: item.textSize,
//                     loadBoxHeight: item.height.toDouble(),
//                     loadBoxWidth: item.width.toDouble(),
//                     color: item.color ?? '#FF0000',
//                     onTap: () {
//                       Get.to(
//                             () => ElectricityShortSLDMainBusBarTrueScreen(busBarName: item.nodeName),
//                         transition: Transition.rightToLeft,
//                         duration: const Duration(seconds: 1),
//                       );
//                     },
//                     unit: 'kW',
//                     orientation: item.orientation,
//                   );
//                 },
//               );
//             }
//           } else if (item.sourceType == 'Meter_Bus_Bar') {
//             widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
//               id: 'node_${item.nodeName}',
//               builder: (controller) {
//                 final nodeData = controller.liveAllNodePowerModel.firstWhere(
//                       (element) => element.node == item.nodeName,
//                   orElse: () => ElectricityShortLiveAllNodePowerModel(),
//                 );
//                 final bool hasData = nodeData.node != null;
//                 if (!hasData) {
//                   debugPrint('No data for Meter_Bus_Bar node: ${item.nodeName}, using power: 0.0');
//                 }
//                 final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
//                 return ShortElectricityMeterBusBarWidget(
//                   sensorStatus: power != 0.0,
//                   value: power,
//                   nodeName: item.nodeName,
//                   color: item.color,
//                   borderColor: item.borderColor,
//                   textColor: item.textColor,
//                   textSize: item.textSize,
//                   loadBoxHeight: item.height.toDouble(),
//                   loadBoxWidth: item.width.toDouble(),
//                   onTap: () {},
//                   unit: 'kW',
//                   orientation: item.orientation,
//                 );
//               },
//             );
//           } else {
//             widget = const SizedBox.shrink();
//           }
//           break;
//
//         case 'BusCoupler':
//           widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
//             id: 'node_${item.nodeName}',
//             builder: (controller) {
//               final nodeData = controller.liveAllNodePowerModel.firstWhere(
//                     (element) => element.node == item.nodeName,
//
//                 orElse:  () => ElectricityShortLiveAllNodePowerModel(),
//               );
//               final bool hasData = nodeData.node != null;
//               if (!hasData) {
//                 debugPrint('No data for BusCoupler node: ${item.nodeName}, using power: 0.0');
//               }
//               final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
//               return ShortElectricityBusCouplerWidget(
//                 key: ValueKey('${item.id}-${power != 0.0}'),
//                 label: item.nodeName,
//                 width: item.width.toDouble(),
//                 height: item.height.toDouble(),
//                 status: power != 0.0,
//                 shape: item.shape,
//                 sourceType: item.sourceType,
//               );
//             },
//           );
//           break;
//
//         case 'Loop':
//           widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
//             id: 'node_${item.nodeName}',
//             builder: (controller) {
//               final nodeData = controller.liveAllNodePowerModel.firstWhere(
//                     (element) => element.node == item.nodeName,
//                 orElse: () => ElectricityShortLiveAllNodePowerModel(),
//               );
//               final bool hasData = nodeData.node != null;
//               if (!hasData) {
//                 debugPrint('No data for Loop node: ${item.nodeName}, using power: 0.0');
//               }
//               final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
//               return ShortElectricityBusCouplerWidget(
//                 key: ValueKey('${item.id}-${power != 0.0}'),
//                 label: item.nodeName,
//                 width: item.width.toDouble(),
//                 height: item.height.toDouble(),
//                 status: power != 0.0,
//                 shape: item.shape,
//                 sourceType: item.sourceType,
//               );
//             },
//           );
//           break;
//
//         default:
//           widget = const SizedBox.shrink();
//       }
//
//       return Positioned(
//         left: item.positionX.toDouble() - minX,
//         top: item.positionY.toDouble() - minY,
//         child: Opacity(
//           opacity: 1.0,
//           child: widget,
//         ),
//       );
//     }).toList();
//   }
//
//
// }
//
// T? firstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
//   for (T item in items) {
//     if (test(item)) return item;
//   }
//   return null;
// }
//
// class ElectricityShortSLDGetAllInfoUIControllers extends GetxController {
//   var powerMeterMap = <String, double>{}.obs;
//
//   void updatePowerMeter(double powerMeter, String nodeName) {
//     powerMeterMap[nodeName] = powerMeter;
//     update();
//     }
// }



class ElectricityShortSld extends StatefulWidget {
  const ElectricityShortSld({super.key});

  @override
  State<ElectricityShortSld> createState() => _ElectricityShortSldState();
}

class _ElectricityShortSldState extends State<ElectricityShortSld>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // Keep state variables
  List<ElectricityShortViewPageModel> _viewPageData = [];
  Map<dynamic, LiveDataModel> _liveData = {};
  bool _isLoading = true;
  late AnimationController _controller;
  late ui.Image _mouseIcon;
  bool _isFetchingViewPageData = false;
  bool _isFetchingPFData = false;
  Timer? _timer;
  List<Map<String, dynamic>> _pfData = [];

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    super.initState();
    _loadMouseIcon();
    _loadCachedData1();

    _fetchViewPageData();
    _fetchPFData();
    //_fetchLiveData();

       // Ensure controller is ready and fetches data
    final nodePowerController = Get.find<ElectricityShortSLDLiveAllNodePowerController>();
    nodePowerController.fetchLiveAllNodePower().then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false; // Only set loading false after data is fetched
        });
      }
    });

    // Stop other controllers

    Get.find<CategoryWiseLiveDataController>().stopApiCallOnScreenChange();
    Get.find<MachineViewNamesDataController>().stopApiCallOnScreenChange();
    Get.find<ElectricityLongSLDLiveAllNodePowerController>().stopApiCallOnScreenChange();

    WidgetsBinding.instance.addObserver(this);
  }

  void _loadMouseIcon() async {
    final ByteData data = await rootBundle.load('assets/images/Rectangle 1816.png');
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo fi = await codec.getNextFrame();
    setState(() {
      _mouseIcon = fi.image;
    });
  }

  // OPTIMIZATION 1: Load cached data first without triggering full UI rebuilds
  Future<void> _loadCachedData1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? cachedViewPageData = prefs.getString('electricity_short_sld_viewPageData');
    String? viewPageCacheTime = prefs.getString('electricity_short_sld_viewPageData_time');
    bool isCacheValid = false;

    if (cachedViewPageData != null && viewPageCacheTime != null) {
      DateTime cacheTime = DateTime.parse(viewPageCacheTime);
      if (DateTime.now().difference(cacheTime).inMinutes < 5) {
        isCacheValid = true;
        final List<ElectricityShortViewPageModel> parsedData = (json.decode(cachedViewPageData) as List)
            .map((data) => ElectricityShortViewPageModel.fromJson(data))
            .toList();

        String? cachedLiveData = prefs.getString('electricity_short_sld_liveData');
        Map<dynamic, LiveDataModel> parsedLiveData = {};

        if (cachedLiveData != null) {
          try {
            parsedLiveData = Map<dynamic, LiveDataModel>.from(
              json.decode(cachedLiveData).map(
                    (id, data) => MapEntry(id, LiveDataModel.fromJson(data)),
              ),
            );
          } catch (e) {
            debugPrint('Error parsing cached live data: $e');
          }
        }

        if (mounted) {
          setState(() {
            _viewPageData = parsedData;
            _liveData = parsedLiveData;
            _isLoading = false;
          });
        }
      }
    }

    if (!isCacheValid) {
      Future.delayed(const Duration(seconds: kTimer), () {
        if (!_isFetchingPFData) _fetchPFData();
        if (!_isFetchingViewPageData) _initializeData();
        //_fetchLiveData();
        final productionController = Get.find<ElectricityShortSLDLtProductionVsCapacityController>();
        final nodePowerController = Get.find<ElectricityShortSLDLiveAllNodePowerController>();
        productionController.fetchProductVsCapacityData();
        nodePowerController.fetchLiveAllNodePower();
      });
    } else {
      // Future.delayed(const Duration(seconds: 2), () {
      //   startTimer();
      // });

      startTimer();
    }
  }

  Future<void> _cacheData1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'electricity_short_sld_viewPageData',
      json.encode(_viewPageData.map((data) => data.toJson()).toList()),
    );
    await prefs.setString(
      'electricity_short_sld_viewPageData_time',
      DateTime.now().toIso8601String(),
    );
    await prefs.setString(
      'electricity_short_sld_liveData',
      json.encode(_liveData.map((id, data) => MapEntry(id.toString(), data.toJson()))),
    );
  }
 // OPTIMIZATION 2: Separate initialization of data without full UI rebuilds
  Future<void> _initializeData() async {
    await _fetchViewPageData();
    _cacheData1(); // Cache data after fetching
  }



  // OPTIMIZATION 4: Fetch view page data without triggering full UI rebuilds
  Future<void> _fetchViewPageData() async {
    if (!mounted) return;
  //  if (_isFetchingViewPageData || !mounted) return;
    _isFetchingViewPageData = true;
    final requestId = Uuid().v4(); // Unique ID for this request


    try {
      // Only show loading on initial load, not on refreshes
      if (_viewPageData.isEmpty) {
        setState(() {
          _isLoading = true;
        });
      }

      final response = await http.get(
        Uri.parse(Urls.shortElectricityUrl),
        headers: {'Authorization': "${AuthUtilityController.accessToken}"},
      );
      debugPrint('-----electricity Short  ------>>> ${Urls.shortElectricityUrl}');


      if (response.statusCode == 200 && mounted) {
        final List<dynamic> data = json.decode(response.body);
        final newViewPageData = data.map((e) => ElectricityShortViewPageModel.fromJson(e)).toList();

        // Only update the UI if data actually changed
        if (!_compareViewPageData(_viewPageData, newViewPageData)) {
          setState(() {
            _viewPageData = newViewPageData;
            if (_isLoading) _isLoading = false;
          });
        }

        // Fetch bus coupler and loop data without rebuilding the whole UI
        ElectricityShortSLDGetAllInfoUIControllers controller = Get.find();
        final fetchRequests = _viewPageData
            .where((item) => item.sourceType == 'BusCoupler' || item.sourceType == 'Loop')
            .map((item) => fetchAndUpdatePowerMeter(item.nodeName, item.sourceType, controller, requestId))
            .toList();

        //debugPrint('[$requestId] Fetching ${fetchRequests.length} power meter requests');
        await Future.wait(fetchRequests);
      } else {
        throw Exception('Failed to load view page data');
      }
    } catch (e) {
      debugPrint('[$requestId] Error fetching view page data: $e');
    } finally {
      _isFetchingViewPageData = false;

      // Only update loading state if we started loading in this method
      if (_isLoading && mounted) {
        setState(() {
          _isLoading = false;
        });
      }

     // debugPrint('[$requestId] Fetch view page data completed at ${DateTime.now()}');
    }
  }

  // Helper method to compare view page data to avoid unnecessary rebuilds
  bool _compareViewPageData(List<ElectricityShortViewPageModel> oldData, List<ElectricityShortViewPageModel> newData) {
    if (oldData.length != newData.length) return false;

    for (int i = 0; i < oldData.length; i++) {
      if (oldData[i].id != newData[i].id ||
          oldData[i].nodeName != newData[i].nodeName ||
          oldData[i].sourceType != newData[i].sourceType) {
        return false;
      }
    }

    return true;
  }

 /* Future<void> _fetchLiveData() async {
    if (!mounted) return;

    final requestId = Uuid().v4();
  //  debugPrint('[$requestId] Fetching live data at ${DateTime.now()}');

    try {
      final response = await http.get(
        Uri.parse('${Urls.baseUrl}/live-all-node-power/?type=electricity'),
        headers: {
          'Authorization': AuthUtilityController.accessToken ?? '',
        },
      );

    //  debugPrint('[$requestId] Live data response: ${response.statusCode}, body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is! List) {
          //debugPrint('[$requestId] Error: Expected List, got ${data.runtimeType}');
          return;
        }

        Map<dynamic, LiveDataModel> newLiveData = {};

        for (var item in _viewPageData) {
          if (item.nodeName.isEmpty) {
           // debugPrint('[$requestId] Skipping empty nodeName for item id: ${item.id}');
            continue;
          }

          final nodeData = data.firstWhere(
                (node) => node['node'] == item.nodeName,
            orElse: () => null,
          );

          if (nodeData != null) {
            LiveDataModel liveDataModel = LiveDataModel(
              power: nodeData['power']?.toDouble() ?? 0.0,
              sensorStatus: (nodeData['power']?.toDouble() ?? 0.0) != 0.0,
              sourceType: nodeData['source_type'] ?? '',
              timedate: nodeData['timedate'] != null
                  ? DateTime.tryParse(nodeData['timedate'])
                  : null,
            );
            newLiveData[item.id] = liveDataModel;
          //  debugPrint('[$requestId] Added live data for node: ${item.nodeName}, power: ${liveDataModel.power}, sensorStatus: ${liveDataModel.sensorStatus}');
          } else {
           // debugPrint('[$requestId] No live data found for node: ${item.nodeName}');
            newLiveData[item.id] = LiveDataModel(
              power: 0.0,
              sensorStatus: false,
              sourceType: item.sourceType,
              timedate: DateTime.now(),
            );
          }
        }

        if (mounted) {
          setState(() {
            _liveData = newLiveData;
            _isLoading = false;
          });
          await _cacheData1();
         // debugPrint('[$requestId] Updated _liveData with ${newLiveData.length} entries');
        }
      } else {
       // debugPrint('[$requestId] Failed to fetch live data: ${response.statusCode}');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e, stackTrace) {
      //debugPrint('[$requestId] Error fetching live data: $e');
      //debugPrint('[$requestId] Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }*/



  // OPTIMIZATION 5: Update power meter data without triggering full UI rebuilds
  Future<void> fetchAndUpdatePowerMeter(String nodeName, String sourceType,
      ElectricityShortSLDGetAllInfoUIControllers controller, String parentRequestId) async {

    if(!mounted) return;

    final requestId = Uuid().v4();
    debugPrint('[$requestId] Fetching power meter for $nodeName (Parent: $parentRequestId) at ${DateTime.now()}');

    try {
      final meterResponse = await http.get(
        Uri.parse(Urls.busCouplerConnectedMeterUrl(nodeName, sourceType)),
        headers: {'Authorization': "${AuthUtilityController.accessToken}"},
      );
     // debugPrint('[$requestId] Power meter response for $nodeName: ${meterResponse.statusCode}');

      if (meterResponse.statusCode == 200) {
        final meterData = json.decode(meterResponse.body);
        double powerMeter = meterData['power_meter'] ?? 0.0;
        debugPrint('[$requestId] Updating power meter for $nodeName -> $powerMeter');

        // Update through controller without rebuilding entire widget
        controller.updatePowerMeter(powerMeter, nodeName);
      }
    } catch (e) {
      debugPrint('[$requestId] Error fetching power meter data for $nodeName: $e');
    }
  }

  // OPTIMIZATION 6: Fetch PF data without triggering full UI rebuilds
  Future<void> _fetchPFData() async {
    //if (_isFetchingPFData || !mounted) return;
    if( !mounted) return;
    _isFetchingPFData = true;
    final requestId = Uuid().v4();


    try {
      final response = await http.get(
        Uri.parse('/api/get-pf-item-positions/'),
        headers: {'Authorization': '${AuthUtilityController.accessToken}'},
      );
      debugPrint('-----electricity Short  ------>>> /api/get-pf-item-positions/}');

      if (response.statusCode == 200 && mounted) {
        final newPfData = List<Map<String, dynamic>>.from(json.decode(response.body));

        // Only update if data actually changed
        if (!_comparePFData(_pfData, newPfData)) {
          setState(() {
            _pfData = newPfData;
          });
        }
      } else {
        debugPrint('[$requestId] Failed to fetch PF data');
      }
    } catch (e) {
      debugPrint('[$requestId] Error fetching PF data: $e');
    } finally {
      _isFetchingPFData = false;
      debugPrint('[$requestId] Fetch PF data completed at ${DateTime.now()}');
    }
  }

  // Helper method to compare PF data to avoid unnecessary rebuilds
  bool _comparePFData(List<Map<String, dynamic>> oldData, List<Map<String, dynamic>> newData) {
    if (oldData.length != newData.length) return false;

    for (int i = 0; i < oldData.length; i++) {
      if (oldData[i]['node_name'] != newData[i]['node_name']) {
        return false;
      }
    }

    return true;
  }

  // OPTIMIZATION 7: Smart timer management
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      // // Delay timer start to avoid overlap with initState
      // Future.delayed(const Duration(seconds: 2), () {
      //   startTimer();
      // });

      startTimer();
    } else {
      stopTimer();
    }
  }

  // OPTIMIZATION 8: Timer only updates data, not UI
  void startTimer() {
    stopTimer();
    _timer = Timer.periodic(const Duration(seconds: kTimer), (Timer timer) {
      // Only fetch data if not already fetching
      if (!_isFetchingViewPageData) _fetchViewPageData();
      if (!_isFetchingPFData) _fetchPFData();

      // Update controller data without rebuilding entire UI
      final productionController = Get.find<ElectricityShortSLDLtProductionVsCapacityController>();
      final nodePowerController = Get.find<ElectricityShortSLDLiveAllNodePowerController>();

      productionController.fetchProductVsCapacityData();
      nodePowerController.fetchLiveAllNodePower();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle changes to manage timer efficiently
    if (state == AppLifecycleState.resumed) {
      // App came to foreground
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        startTimer();
      }
    } else if (state == AppLifecycleState.paused) {
      // App went to background
      stopTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.stop();
    _controller.dispose();
    stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // if (_isLoading) {
    //   return const Scaffold(
    //     backgroundColor: Colors.white,
    //     body: Center(
    //       child: SpinKitFadingCircle(
    //         color: AppColors.primaryColor,
    //         size: 50.0,
    //       ),
    //     ),
    //   );
    // }

    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if(_isLoading){
              return  Center(
                child: SpinKitFadingCircle(
                  color: AppColors.primaryColor,
                  size: 50.0,
                ),
              );
            }

            // Handle empty or invalid viewPageData
            if (_viewPageData.isEmpty) {
              return const Center(
                child: Text('No data available'),
              );
            }

            // Calculate content dimensions with validation
            double minX = _getMinX();
            double minY = _getMinY();
            double maxX = _getMaxX();
            double maxY = _getMaxY();

            // Ensure valid content dimensions
            double contentWidth = maxX - minX;
            double contentHeight = maxY - minY;

            // Fallback dimensions to prevent division by zero
            contentWidth = contentWidth.isFinite && contentWidth > 0 ? contentWidth : constraints.maxWidth;
            contentHeight = contentHeight.isFinite && contentHeight > 0 ? contentHeight : constraints.maxHeight;

            // Calculate scale to fit screen
            double scaleX = constraints.maxWidth / contentWidth;
            double scaleY = constraints.maxHeight / contentHeight;
            double scale = min(scaleX, scaleY);

            // Ensure scale is finite
            scale = scale.isFinite ? scale : 1.0;

            // debugPrint('minX: $minX, minY: $minY, maxX: $maxX, maxY: $maxY');
            // debugPrint('contentWidth: $contentWidth, contentHeight: $contentHeight, scale: $scale');

            return PhotoViewGallery.builder(
              itemCount: 1,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions.customChild(
                  childSize: Size(contentWidth * scale, contentHeight * scale),
                  minScale: PhotoViewComputedScale.contained * 0.2,
                  maxScale: PhotoViewComputedScale.contained * 8.0,
                  initialScale: PhotoViewComputedScale.contained,
                  basePosition: Alignment.center,
                  child: Center(
                    child: SizedBox(
                      width: contentWidth * scale,
                      height: contentHeight * scale,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: contentWidth,
                          height: contentHeight,
                          child: Stack(
                            children: [
                              // CustomPaint(
                              //   size: Size(contentWidth, contentHeight),
                              //   painter: ElectricityShortSLDAnimatedLinePainter(
                              //     viewPageData: _viewPageData,
                              //     liveData: _liveData,
                              //     minX: minX,
                              //     minY: minY,
                              //     animation: _controller.view,
                              //   ),
                              // ),

                              GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
                                builder: (controller) {
                                  return GetBuilder<BusBarStatusInfoController>(
                                    builder: (electricityLongBusBarStatusInfoController) {
                                      return CustomPaint(
                                        size: Size(contentWidth, contentHeight),
                                        painter: ElectricityShortSLDAnimatedLinePainter(
                                          viewPageData: _viewPageData,
                                          liveAllNodeModel: controller.liveAllNodePowerModel,
                                          busBarStatusModels: electricityLongBusBarStatusInfoController.busBarStatusModels, // Pass busbar status
                                          minX: minX,
                                          minY: minY,
                                          animation: _controller.view,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),

                              ..._buildWidgets(minX, minY),
                              ..._buildPFWidgets(minX, minY),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
              backgroundDecoration: const BoxDecoration(color: Colors.white),
              gaplessPlayback: true,
            );
          },
        ),
      ),
    );
  }

  double _getMinX() {
    if (_viewPageData.isEmpty) return 0.0;
    return _viewPageData
        .where((e) => e.positionX.isFinite)
        .map((e) => e.positionX)
        .reduce(min);
  }

  double _getMinY() {
    if (_viewPageData.isEmpty) return 0.0;
    return _viewPageData
        .where((e) => e.positionY.isFinite)
        .map((e) => e.positionY)
        .reduce(min);
  }

  double _getMaxX() {
    if (_viewPageData.isEmpty) return 0.0;
    return _viewPageData
        .where((e) => (e.positionX + e.width).isFinite)
        .map((e) => e.positionX + e.width)
        .reduce(max);
  }

  double _getMaxY() {
    if (_viewPageData.isEmpty) return 0.0;
    return _viewPageData
        .where((e) => (e.positionY + e.height).isFinite)
        .map((e) => e.positionY + e.height)
        .reduce(max);
  }


  /*--------------Pf here----------*/
  List<Widget> _buildPFWidgets(double minX, double minY) {
    return _pfData.map((item) {
      var controller = Get.put(ElectricityShortSldLivePfDataController(), tag: item['node_name']);
      controller.fetchLivePFData(nodeName: item['node_name']);

      return GetBuilder<ElectricityShortSldLivePfDataController>(
        tag: item['node_name'],
        builder: (controller) {
          return Positioned(
            left: item['position_x'] - minX,
            top: item['position_y'] - minY,
            child: Container(
              width: item['width'].toDouble(),
              height: item['height'].toDouble(),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                color: Colors.blue.withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "PF : ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                controller.livePFDataModel.powerFactor != null
                                    ? controller.livePFDataModel.powerFactor
                                    .toStringAsFixed(4)
                                    .toString()
                                    : '0',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => PfHistoryScreen(nodeName: item['node_name']),
                        transition: Transition.fadeIn,
                        duration: const Duration(seconds: 1),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: 50,
                          color: Colors.red,
                          child: Center(
                            child: Text(
                              controller.livePFDataModel.count != null
                                  ? controller.livePFDataModel.count.toString()
                                  : '0',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const Positioned(
                            left: 5,
                            top: 3,
                            child: Icon(
                              Icons.notifications,
                              size: 18,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }).toList();
  }

  void loadMouseIcon() async {
    final ByteData data =
    await rootBundle.load('assets/images/Rectangle1484.png');
    final ui.Codec codec =
    await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo fi = await codec.getNextFrame();
    setState(() {
      _mouseIcon = fi.image;
    });
  }



  List<Widget> _buildWidgets(double minX, double minY) {
    return _viewPageData.map((item) {
      Widget widget;

      Color hexToColor(String hex) {
        hex = hex.isEmpty ? '#000000' : hex.replaceAll('#', '');
        try {
          return Color(int.parse('0xFF$hex'));
        } catch (e) {
          debugPrint('Invalid hex color: $hex, using default #000000');
          return const Color(0xFF000000);
        }
      }

      switch (item.shape) {
        case 'circle':
          widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
            id: 'node_${item.nodeName}',
            builder: (controller) {

              final nodeData = controller.liveAllNodePowerModel.firstWhere(
                    (element) => element.node == item.nodeName,
                orElse: () => ElectricityShortLiveAllNodePowerModel(),
              );
              final bool hasData = nodeData.node != null;
              final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;


              _liveData[item.id] = LiveDataModel(
                power: power,
                sensorStatus: power != 0.0,
                sourceType: item.sourceType,
                timedate: DateTime.now(),
              ); // Sync _liveData with controller
              return ShortElectricityCircleWithIcon(
                sensorStatus: power != 0.0,
                value: power,
                borderColor: item.color ?? '#FF0000',
                icon: FontAwesomeIcons.bolt,
                text: item.nodeName,
                width: item.width.toDouble(),
                height: item.height.toDouble(),
                onTap: () {
                  debugPrint("----->CircleWithIcon<-----");
                  if (item.category == 'Diesel_Generator') {
                    Get.to(
                          () => GeneratorElementDetailsScreen(
                        elementName: item.nodeName,
                        gaugeValue: power,
                        gaugeUnit: 'kW',
                        elementCategory: 'Power',
                      ),
                      transition: Transition.rightToLeft,
                      duration: const Duration(seconds: 1),
                    );
                  } else {
                    Get.to(
                          () => PowerAndEnergyElementDetailsScreen(
                        elementName: item.nodeName,
                        gaugeValue: power,
                        gaugeUnit: 'kW',
                        elementCategory: 'Power',
                        solarCategory: item.category,
                      ),
                      transition: Transition.rightToLeft,
                      duration: const Duration(seconds: 1),
                    );
                  }
                },
                unit: 'kW',
              );
            },
          );
          break;

        case 'LB_Meter':
          widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
            id: 'node_${item.nodeName}',
            builder: (controller) {

              final nodeData = controller.liveAllNodePowerModel.firstWhere(
                    (element) => element.node == item.nodeName,
                orElse: () => ElectricityShortLiveAllNodePowerModel(),
              );
              final bool hasData = nodeData.node != null;
              final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
              final String percentage = hasData && nodeData.percentage != null
                  ? nodeData.percentage.toStringAsFixed(2)
                  : "0.00";
              final String capacity = hasData && nodeData.capacity != null
                  ? nodeData.capacity.toStringAsFixed(2)
                  : "0.00";

              _liveData[item.id] = LiveDataModel(
                power: power,
                sensorStatus: power != 0.0,
                sourceType: item.sourceType,
                timedate: DateTime.now(),
              );
              return ShortElectricityBoxWithIconWidget(
                sensorStatus: power != 0.0,
                value: power,
                icon: FontAwesomeIcons.solarPanel,
                label: item.nodeName,
                width: item.width.toDouble(),
                height: item.height.toDouble(),
                onTap: () {},
                unit: 'kW',
                borderColor: item.borderColor ?? '#FF0000',
                percentage: percentage,
                capacity: capacity,
              );
            },
          );
          break;

      // Add similar updates for other cases ('box', 'Bus_Bar', 'BusCoupler', 'Loop') to sync _liveData
        case 'box':
          widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
            id: 'node_${item.nodeName}',
            builder: (controller) {

              final nodeData = controller.liveAllNodePowerModel.firstWhere(
                    (element) => element.node == item.nodeName,
                orElse: () => ElectricityShortLiveAllNodePowerModel(),
              );
              final bool hasData = nodeData.node != null;
              final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
              final String percentage = hasData && nodeData.percentage != null
                  ? nodeData.percentage.toStringAsFixed(2)
                  : "0.00";
              final String capacity = hasData && nodeData.capacity != null
                  ? nodeData.capacity.toStringAsFixed(2)
                  : "0.00";
              debugPrint('Box Node: ${item.nodeName}, Power: $power');
              _liveData[item.id] = LiveDataModel(
                power: power,
                sensorStatus: power != 0.0,
                sourceType: item.sourceType,
                timedate: DateTime.now(),
              );
              return ShortElectrcityTrBoxWithIconWidget(
                sensorStatus: power != 0.0,
                value: power,
                icon: FontAwesomeIcons.solarPanel,
                label: item.nodeName,
                width: item.width.toDouble(),
                height: item.height.toDouble(),
                onTap: () {
                  debugPrint("----->TrBoxWithIconWidget<-----");
                  if (item.category == 'Diesel_Generator') {
                    Get.to(() => GeneratorElementDetailsScreen(
                      elementName: item.nodeName,
                      gaugeValue: power,
                      gaugeUnit: 'kW',
                      elementCategory: 'Power',
                    ),
                      transition: Transition.rightToLeft,
                      duration: const Duration(seconds: 1),
                    );
                  } else {
                    Get.to(() => PowerAndEnergyElementDetailsScreen(
                      elementName: item.nodeName,
                      gaugeValue: power,
                      gaugeUnit: 'kW',
                      elementCategory: 'Power',
                      solarCategory: item.category,
                    ),
                      transition: Transition.rightToLeft,
                      duration: const Duration(seconds: 1),
                    );
                  }
                },
                unit: 'kW',
                borderColor: item.color ?? '#FF0000',
                percentage: percentage,
                capacity: capacity,
              );
            },
          );
          break;

        case 'Bus_Bar':
          if (item.sourceType == 'Super_Bus_Bar') {
            widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
              id: 'node_${item.nodeName}',
              builder: (nodeController) {

                return GetBuilder<ElectricityShortSLDLtProductionVsCapacityController>(
                  builder: (capacityController) {
                    final nodeData = nodeController.liveAllNodePowerModel.firstWhere(
                          (element) => element.node == item.nodeName,
                      orElse: () => ElectricityShortLiveAllNodePowerModel(),
                    );
                    final bool hasData = nodeData.node != null;
                    final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;

                    _liveData[item.id] = LiveDataModel(
                      power: power,
                      sensorStatus: power != 0.0,
                      sourceType: item.sourceType,
                      timedate: DateTime.now(),
                    );
                    return ShortElectricitySuperBusBarWidget(
                      sensorStatus: power != 0.0,
                      value: power,
                      nodeName: item.nodeName,
                      backgroundColor: item.color ?? '#FF0000',
                      borderColor: item.borderColor ?? '#FF0000',
                      textColor: item.textColor != null ? hexToColor(item.textColor!) : Colors.black,
                      loadBoxHeight: item.height.toDouble(),
                      loadBoxWidth: item.width.toDouble(),
                      onTap: () {},
                      unit: 'kW',
                      gridColor: capacityController.ltProductionVsCapacityModel.gridColor ?? '#ffffff',
                      generatorColor: capacityController.ltProductionVsCapacityModel.generatorColor ?? '#ffffff',
                      solarColor: capacityController.ltProductionVsCapacityModel.solarColor ?? '#ffffff',
                      gridPercentage: item.nodeName == "LT-02 A"
                          ? capacityController.ltProductionVsCapacityModel.lt02AGridPercentage ?? 0.00
                          : item.nodeName == "LT-02 B"
                          ? capacityController.ltProductionVsCapacityModel.lt02BGridPercentage ?? 0.00
                          : item.nodeName == "LT-01 A"
                          ? capacityController.ltProductionVsCapacityModel.lt01AGridPercentage ?? 0.00
                          : item.nodeName == "LT-01 B"
                          ? capacityController.ltProductionVsCapacityModel.lt01BGridPercentage ?? 0.00
                          : 0.00,
                      generatorPercentage: item.nodeName == "LT-02 A"
                          ? capacityController.ltProductionVsCapacityModel.lt02AGeneratorPercentage ?? 0.00
                          : item.nodeName == "LT-02 B"
                          ? capacityController.ltProductionVsCapacityModel.lt02BGeneratorPercentage ?? 0.00
                          : item.nodeName == "LT-01 A"
                          ? capacityController.ltProductionVsCapacityModel.lt01AGeneratorPercentage ?? 0.00
                          : item.nodeName == "LT-01 B"
                          ? capacityController.ltProductionVsCapacityModel.lt01BGeneratorPercentage ?? 0.00
                          : 0.00,
                      solarPercentage: item.nodeName == "LT-02 A"
                          ? capacityController.ltProductionVsCapacityModel.lt02ASolarPercentage ?? 0.00
                          : item.nodeName == "LT-02 B"
                          ? capacityController.ltProductionVsCapacityModel.lt02BSolarPercentage ?? 0.00
                          : item.nodeName == "LT-01 A"
                          ? capacityController.ltProductionVsCapacityModel.lt01ASolarPercentage ?? 0.00
                          : item.nodeName == "LT-01 B"
                          ? capacityController.ltProductionVsCapacityModel.lt01BSolarPercentage ?? 0.00
                          : 0.00,
                      gridValue: item.nodeName == "LT-02 A"
                          ? capacityController.ltProductionVsCapacityModel.lt02AGridPower ?? 0.00
                          : item.nodeName == "LT-02 B"
                          ? capacityController.ltProductionVsCapacityModel.lt02BGridPower ?? 0.00
                          : item.nodeName == "LT-01 A"
                          ? capacityController.ltProductionVsCapacityModel.lt01AGridPower ?? 0.00
                          : item.nodeName == "LT-01 B"
                          ? capacityController.ltProductionVsCapacityModel.lt01BGridPower ?? 0.00
                          : 0.00,
                      generatorValue: item.nodeName == "LT-02 A"
                          ? capacityController.ltProductionVsCapacityModel.lt02AGeneratorPower ?? 0.00
                          : item.nodeName == "LT-02 B"
                          ? capacityController.ltProductionVsCapacityModel.lt02BGeneratorPower ?? 0.00
                          : item.nodeName == "LT-01 A"
                          ? capacityController.ltProductionVsCapacityModel.lt01AGeneratorPower ?? 0.00
                          : item.nodeName == "LT-01 B"
                          ? capacityController.ltProductionVsCapacityModel.lt01BGeneratorPower ?? 0.00
                          : 0.00,
                      solarValue: item.nodeName == "LT-02 A"
                          ? capacityController.ltProductionVsCapacityModel.lt02ASolarPower ?? 0.00
                          : item.nodeName == "LT-02 B"
                          ? capacityController.ltProductionVsCapacityModel.lt02BSolarPower ?? 0.00
                          : item.nodeName == "LT-01 A"
                          ? capacityController.ltProductionVsCapacityModel.lt01ASolarPower ?? 0.00
                          : item.nodeName == "LT-01 B"
                          ? capacityController.ltProductionVsCapacityModel.lt01BSolarPower ?? 0.00
                          : 0.00,
                      y: (item.nodeName == "LT-02 A" || item.nodeName == "LT-02 B") ? 40 : -95,
                      orientation: item.orientation,
                    );
                  },
                );
              },
            );
          } else if (item.sourceType == 'Load_Bus_Bar' || item.sourceType == 'Bus_Bar') {
            if (item.mainBusbar ?? false) {
              widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
                id: 'node_${item.nodeName}',
                builder: (controller) {

                  final nodeData = controller.liveAllNodePowerModel.firstWhere(
                        (element) => element.node == item.nodeName,
                    orElse: () => ElectricityShortLiveAllNodePowerModel(),
                  );
                  final bool hasData = nodeData.node != null;
                  final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
                  final String percentage = hasData && nodeData.percentage != null
                      ? nodeData.percentage.toStringAsFixed(2)
                      : "0.00";
                  final String capacity = hasData && nodeData.capacity != null
                      ? nodeData.capacity.toStringAsFixed(2)
                      : "0.00";

                  _liveData[item.id] = LiveDataModel(
                    power: power,
                    sensorStatus: power != 0.0,
                    sourceType: item.sourceType,
                    timedate: DateTime.now(),
                  );
                  return ShortElectricityMainBusBarTrue(
                    sensorStatus: power != 0.0,
                    value: power,
                    nodeName: item

                        .nodeName,
                    color: item.color ?? '#FF0000',
                    borderColor: item.borderColor ?? '#FF0000',
                    textColor: item.textColor,
                    textSize: item.textSize,
                    loadBoxHeight: item.height.toDouble(),
                    loadBoxWidth: item.width.toDouble(),
                    onTap: () {
                      Get.to(
                            () => ElectricityShortSLDMainBusBarTrueScreen(
                          busBarName: item.nodeName,
                        ),
                        transition: Transition.rightToLeft,
                        duration: const Duration(seconds: 1),
                      );
                    },
                    unit: 'kW',
                    percentage: percentage,
                    capacity: capacity,
                    orientation: item.orientation ?? 'horizontal',
                  );
                },
              );
            } else {
              widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
                id: 'node_${item.nodeName}',
                builder: (controller) {
                  debugPrint('Rebuilding Load_Bus_Bar/Bus_Bar node: ${item.nodeName}');
                  final nodeData = controller.liveAllNodePowerModel.firstWhere(
                        (element) => element.node == item.nodeName,
                    orElse: () => ElectricityShortLiveAllNodePowerModel(),
                  );
                  final bool hasData = nodeData.node != null;
                  final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
                  debugPrint('Load_Bus_Bar/Bus_Bar Node: ${item.nodeName}, Power: $power');
                  _liveData[item.id] = LiveDataModel(
                    power: power,
                    sensorStatus: power != 0.0,
                    sourceType: item.sourceType,
                    timedate: DateTime.now(),
                  );
                  return ShortElectricitySourceAndLoadBoxWidget(
                    sensorStatus: power != 0.0,
                    value: power,
                    nodeName: item.nodeName,
                    borderColor: item.borderColor ?? '#FF0000',
                    textColor: item.textColor,
                    textSize: item.textSize,
                    loadBoxHeight: item.height.toDouble(),
                    loadBoxWidth: item.width.toDouble(),
                    color: item.color ?? '#FF0000',
                    onTap: () {
                      Get.to(() => ElectricityShortSLDMainBusBarTrueScreen(busBarName: item.nodeName),
                        transition: Transition.rightToLeft,
                        duration: const Duration(seconds: 1),
                      );
                    },
                    unit: 'kW',
                    orientation: item.orientation,
                  );
                },
              );
            }
          } else if (item.sourceType == 'Meter_Bus_Bar') {
            widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
              id: 'node_${item.nodeName}',
              builder: (controller) {

                final nodeData = controller.liveAllNodePowerModel.firstWhere(
                      (element) => element.node == item.nodeName,
                  orElse: () => ElectricityShortLiveAllNodePowerModel(),
                );
                final bool hasData = nodeData.node != null;
                final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
                debugPrint('Meter_Bus_Bar Node: ${item.nodeName}, Power: $power');
                _liveData[item.id] = LiveDataModel(
                  power: power,
                  sensorStatus: power != 0.0,
                  sourceType: item.sourceType,
                  timedate: DateTime.now(),
                );
                return ShortElectricityMeterBusBarWidget(
                  sensorStatus: power != 0.0,
                  value: power,
                  nodeName: item.nodeName,
                  color: item.color,
                  borderColor: item.borderColor,
                  textColor: item.textColor,
                  textSize: item.textSize,
                  loadBoxHeight: item.height.toDouble(),
                  loadBoxWidth: item.width.toDouble(),
                  onTap: () {},
                  unit: 'kW',
                  orientation: item.orientation,
                );
              },
            );
          } else {
            widget = const SizedBox.shrink();
          }
          break;

        case 'BusCoupler':
          widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
            id: 'node_${item.nodeName}',
            builder: (controller) {
              debugPrint('Rebuilding BusCoupler node: ${item.nodeName}');
              final nodeData = controller.liveAllNodePowerModel.firstWhere(
                    (element) => element.node == item.nodeName,
                orElse: () => ElectricityShortLiveAllNodePowerModel(),
              );
              final bool hasData = nodeData.node != null;
              final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
              debugPrint('BusCoupler Node: ${item.nodeName}, Power: $power');
              _liveData[item.id] = LiveDataModel(
                power: power,
                sensorStatus: power != 0.0,
                sourceType: item.sourceType,
                timedate: DateTime.now(),
              );
              return ShortElectricityBusCouplerWidget(
                key: ValueKey('${item.id}-${power != 0.0}'),
                label: item.nodeName,
                width: item.width.toDouble(),
                height: item.height.toDouble(),
                status: power != 0.0,
                shape: item.shape,
                sourceType: item.sourceType,
              );
            },
          );
          break;

        case 'Loop':
          widget = GetBuilder<ElectricityShortSLDLiveAllNodePowerController>(
            id: 'node_${item.nodeName}',
            builder: (controller) {
              debugPrint('Rebuilding Loop node: ${item.nodeName}');
              final nodeData = controller.liveAllNodePowerModel.firstWhere(
                    (element) => element.node == item.nodeName,
                orElse: () => ElectricityShortLiveAllNodePowerModel(),
              );
              final bool hasData = nodeData.node != null;
              final double power = hasData ? (nodeData.power ?? 0.0) : 0.0;
              debugPrint('Loop Node: ${item.nodeName}, Power: $power');
              _liveData[item.id] = LiveDataModel(
                power: power,
                sensorStatus: power != 0.0,
                sourceType: item.sourceType,
                timedate: DateTime.now(),
              );
              return ShortElectricityBusCouplerWidget(
                key: ValueKey('${item.id}-${power != 0.0}'),
                label: item.nodeName,
                width: item.width.toDouble(),
                height: item.height.toDouble(),
                status: power != 0.0,
                shape: item.shape,
                sourceType: item.sourceType,
              );
            },
          );
          break;

        default:
          widget = const SizedBox.shrink();
      }

      return Positioned(
        left: item.positionX.toDouble() - minX,
        top: item.positionY.toDouble() - minY,
        child: Opacity(
          opacity: 1.0,
          child: widget,
        ),
      );
    }).toList();
  }

}

T? firstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
  for (T item in items) {
    if (test(item)) return item;
  }
  return null;
}

class ElectricityShortSLDGetAllInfoUIControllers extends GetxController {
  var powerMeterMap = <String, double>{}.obs;

  void updatePowerMeter(double powerMeter, String nodeName) {
    powerMeterMap[nodeName] = powerMeter;
    update();
  }
}