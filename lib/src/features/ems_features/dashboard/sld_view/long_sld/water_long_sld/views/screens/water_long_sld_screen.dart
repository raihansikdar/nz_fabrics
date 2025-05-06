import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/controller/water_long_sld_live_all_node_power_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/controller/water_long_sld_live_pf_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/controller/water_long_sld_lt_production_vs_capacity_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/model/water_long_sld_live_all_node_power_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/model/water_long_sld_loop_and_bus_cupler_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/model/water_long_sld_view_page_model.dart'
    show LiveDataModel, WaterLongSLDViewPageModel;
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/views/screens/water_long_sld_main_bus_bar_true/screen/water_long_sld_main_bus_bar_true_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/views/widgets/water_long_sld_bus_couplar_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/views/widgets/water_long_sld_meter_bus_bar_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/views/widgets/water_long_sld_source_and_load_box_widget.dart'
    show WaterLongSLDSourceAndLoadBoxWidget;
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/views/widgets/water_long_sld_main_bus_bar_2.dart';

import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/machine_view_names_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_source_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/views/screens/pf_history_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/generators/generator_element_details_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/power_and_energy_element_details_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/water/water_element_details_screen.dart';
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
import 'dart:convert';
import 'dart:ui' as ui;

import '../../../../long_sld/water_long_sld/views/widgets/water_long_sld_circle_with_icon_widget.dart';
import '../../../../long_sld/water_long_sld/views/widgets/water_long_sld_super_bus_bar_widget.dart';
import '../../../../long_sld/water_long_sld/views/widgets/water_long_sld_box_with_icon_widget.dart';
import '../../../../long_sld/water_long_sld/views/widgets/water_long_sld_tr_box_with_icon_widget.dart';
import '../widgets/water_long_sld_line_widget.dart';

class WaterLongSldScreen extends StatefulWidget {
  const WaterLongSldScreen({super.key});

  @override
  State<WaterLongSldScreen> createState() => _WaterLongSldScreenState();
}

class _WaterLongSldScreenState extends State<WaterLongSldScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  List<WaterLongSLDViewPageModel> _viewPageData = [];
  Map<dynamic, LiveDataModel> _liveData = {};
  WaterLongSLDLoopAndBusCouplerModel loopAndBusCouplerModel = WaterLongSLDLoopAndBusCouplerModel();
  bool _isLoading = true;
  late AnimationController _controller;
  late ui.Image _mouseIcon;

  //Timer? _refreshTimer;
  Timer? _timer;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    super.initState();
    _loadMouseIcon();
    _loadCachedData();
    _fetchPFData();
    _initializeData();

    Get.find<WaterLongSLDLtProductionVsCapacityController>().fetchProductVsCapacityData();
    Get.find<WaterLongSLDLiveAllNodePowerController>().fetchLiveAllNodePower();
    Get.find<WaterLongSLDLtProductionVsCapacityController>().startApiCallOnScreenChange();
    Get.find<WaterLongSLDLiveAllNodePowerController>().startApiCallOnScreenChange();
    Get.find<PieChartPowerSourceController>().stopApiCallOnScreenChange();
    Get.find<PieChartPowerLoadController>().stopApiCallOnScreenChange();
    Get.find<CategoryWiseLiveDataController>().stopApiCallOnScreenChange();
    Get.find<MachineViewNamesDataController>().stopApiCallOnScreenChange();

  }

  Future<void> _loadCachedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load cached view page data if available
    String? cachedViewPageData = prefs.getString('cached_viewPageData');
    if (cachedViewPageData != null) {
      setState(() {
        _viewPageData = (json.decode(cachedViewPageData) as List)
            .map((data) => WaterLongSLDViewPageModel.fromJson(data))
            .toList();

        _isLoading = false;
      });
    }

    // Load cached live data if available
    String? cachedLiveData = prefs.getString('cached_liveData');
    if (cachedLiveData != null) {
      setState(() {
        _liveData = Map<int, LiveDataModel>.from(json
            .decode(cachedLiveData)
            .map((id, data) =>
            MapEntry(int.parse(id), LiveDataModel.fromJson(data))));
      });
    }
  }

  void _loadMouseIcon() async {
    final ByteData data =
    await rootBundle.load('assets/images/Rectangle 1816.png');
    final ui.Codec codec =
    await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo fi = await codec.getNextFrame();
    setState(() {
      _mouseIcon = fi.image;
    });
  }

  Future<void> _initializeData() async {
    await _fetchViewPageData();
    await _fetchLiveData();
    _cacheData(); // Cache data after fetching
  }

  Future<void> _cacheData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('cached_viewPageData',
        json.encode(_viewPageData.map((data) => data.toJson()).toList()));
    await prefs.setString(
        'cached_liveData',
        json.encode(_liveData
            .map((id, data) => MapEntry(id.toString(), data.toJson()))));
  }

/*  Future<void> _fetchLiveData() async {
    if (!mounted) return;

    final response = await http.get(
      Uri.parse('${Urls.baseUrl}/live-all-node-power/'),
      headers: {
        'Authorization': AuthUtilityController.accessToken ?? '',
      },
    );

    //  debugPrint("live-all-node-power -----> ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var fetchRequests = _viewPageData
          .where((item) => item.nodeName.isNotEmpty)
          .map((item) async {
        final nodeData = data.firstWhere(
              (node) => node['node'] == item.nodeName,
          orElse: () => null,
        );

        if (nodeData != null) {
          LiveDataModel liveDataModel = LiveDataModel(
            power: nodeData['power']?.toDouble() ?? 0.0,
            sensorStatus: nodeData['sensor_status'] ?? false,
            sourceType: nodeData['source_type'] ?? '',
            timedate: nodeData['timedate'] != null
                ? DateTime.tryParse(
                nodeData['timedate']) // Parse the string to DateTime
                : null,
          );

          return {item.id: liveDataModel};
        }
        return null;
      }).toList();

      final results = await Future.wait(fetchRequests);

    if(mounted){
      setState(() {
        for (var result in results) {
          if (result != null) {
            _liveData.addAll(result);
          }
        }
        _isLoading = false;
      });
    }
    } else {
      // Handle the error case when the API call fails
      debugPrint('-------Failed to fetch live data------------');
      setState(() {
        _isLoading = false;
      });
    }
  }*/
  Future<void> _fetchLiveData() async {
    if (!mounted) return;

    final response = await http.get(
      Uri.parse('${Urls.baseUrl}/live-all-node-power/?type=water'),
      headers: {
        'Authorization': AuthUtilityController.accessToken ?? '',
      },
    );

    //  debugPrint("live-all-node-power -----> ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var fetchRequests = _viewPageData
          .where((item) => item.nodeName.isNotEmpty)
          .map((item) async {
        final nodeData = data.firstWhere(
              (node) => node['node'] == item.nodeName,
          orElse: () => null,
        );

        if (nodeData != null) {
          LiveDataModel liveDataModel = LiveDataModel(
            power: nodeData['instant_flow']?.toDouble() ?? 0.0,
            sensorStatus: nodeData['sensor_status'] ?? false,
            sourceType: nodeData['source_type'] ?? '',
            timedate: nodeData['timedate'] != null
                ? DateTime.tryParse(
                nodeData['timedate']) // Parse the string to DateTime
                : null,
          );

          return {item.id: liveDataModel};
        }
        return null;
      }).toList();

      final results = await Future.wait(fetchRequests);

      if(mounted){
        setState(() {
          for (var result in results) {
            if (result != null) {
              _liveData.addAll(result);
            }
          }
          _isLoading = false;
        });
      }
    } else {
      // Handle the error case when the API call fails
      debugPrint('-------Failed to fetch live data------------');
      setState(() {
        _isLoading = false;
        });
    }
    }
  Future<void> _fetchViewPageData() async {
    if (!mounted) return;
    try {
      final response = await http.get(
        Uri.parse(Urls.longWateryUrl),
        headers: {'Authorization': "${AuthUtilityController.accessToken}"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _viewPageData = data.map((e) => WaterLongSLDViewPageModel.fromJson(e)).toList();
        });

        GetAllInfoControllersForWater controller = Get.find(); // Get controller instance

        for (var item in _viewPageData) {
          if (item.sourceType == 'BusCoupler' || item.sourceType == 'Loop') {
            fetchAndUpdatePowerMeter(item.nodeName, item.sourceType, controller);
          }
        }
      } else {
        throw Exception('Failed to load view page data');
      }
    } catch (e) {
      debugPrint('Error fetching view page data: $e');
    }
  }

  Future<void> fetchAndUpdatePowerMeter(String nodeName, String sourceType, GetAllInfoControllersForWater controller) async {
    try {
      final meterResponse = await http.get(
        Uri.parse(Urls.busCouplerConnectedMeterUrl(nodeName, sourceType)),
        headers: {'Authorization': "${AuthUtilityController.accessToken}"},
      );

      if (meterResponse.statusCode == 200) {
        final meterData = json.decode(meterResponse.body);
        double powerMeter = meterData['power_meter'] ?? 0.0;

        // Debug log
        debugPrint("Updating power meter for $nodeName -> $powerMeter");

        // Update power meter value in the map
        controller.updatePowerMeter(powerMeter, nodeName);
      }
    } catch (e) {
      debugPrint('Error fetching power meter data for $nodeName: $e');
    }
  }

  /*--------------Pf here----------*/
  List<Map<String, dynamic>> _pfData = [];

  Future<void> _fetchPFData() async {
    final response = await http.get(
      Uri.parse('${Urls.baseUrl}/api/get-pf-item-positions/'),
      headers: {
        'Authorization': '${AuthUtilityController.accessToken}',
      },
    );
    if (response.statusCode == 200) {
     if(mounted){
       setState(() {
         _pfData = List<Map<String, dynamic>>.from(json.decode(response.body));
       });
     }
    } else {
      debugPrint('Failed to fetch PF data');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      startTimer();
    } else {
      stopTimer();
    }
  }

  void startTimer() {
    stopTimer();
    _timer = Timer.periodic(const Duration(seconds: kTimer), (Timer timer) {
      _fetchLiveData();
      _fetchViewPageData();
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      stopTimer();
    } else if (state == AppLifecycleState.resumed) {
      startTimer();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
//  final PhotoViewController _photoViewController = PhotoViewController();




  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: 50.0,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWidget(text: "Water SLD", backPreviousScreen: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
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

            debugPrint('minX: $minX, minY: $minY, maxX: $maxX, maxY: $maxY');
            debugPrint('contentWidth: $contentWidth, contentHeight: $contentHeight, scale: $scale');

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
                              CustomPaint(
                                size: Size(contentWidth, contentHeight),
                                painter: WaterLongSLDAnimatedLinePainter(
                                  viewPageData: _viewPageData,
                                  liveData: _liveData,
                                  minX: minX,
                                  minY: minY,
                                  animation: _controller.view,
                                ),
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
      var controller = Get.put(WaterLongSldLivePfDataController(), tag: item['node_name']);
      controller.fetchLivePFData(nodeName: item['node_name']);

      return GetBuilder<WaterLongSldLivePfDataController>(
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
      final liveData = _liveData[item.id];
      final double power = liveData?.power ?? 0.0;
      final bool sensorStatus = power != 0.0;

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
          widget = WaterLongSLDCircleWithIcon(
            sensorStatus: liveData?.sensorStatus ?? true,
            value: power,
            // textColor: item.textColor,
            // textSize: item.textSize,
            borderColor: item.borderColor ?? '#FF0000',
            icon: FontAwesomeIcons.bolt,
            text: item.nodeName,
            width: item.width.toDouble(),
            height: item.height.toDouble(),
            onTap: () {
              debugPrint("----->CircleWithIcon<-----");

              Get.to(
                    () => WaterElementDetailsScreen(
                  elementName: item.nodeName,
                  gaugeValue: power,
                  gaugeUnit: 'm³/h',
                  elementCategory: 'Water',

                ),
                transition: Transition.rightToLeft,
                duration: const Duration(seconds: 1),
              );
            },
            unit: 'm³/h',
          );
          break;
        case 'LB_Meter':
          widget = GetBuilder<WaterLongSLDLiveAllNodePowerController>(builder: (controller) {
            final nodeData = controller.liveAllNodePowerModel.firstWhere(
                  (element) => element.node == item.nodeName,
              orElse: () => WaterLongSLDLiveAllNodePowerModel(),
            );
            return WaterLongSLDBoxWithIconWidget(
              sensorStatus: sensorStatus,
              value: power,
              icon: FontAwesomeIcons.solarPanel,
              label: item.nodeName,
              width: item.width.toDouble(),
              height: item.height.toDouble(),
              onTap: () {},
              unit: 'm³/h',
              // color: item.color ?? '#FF0000',
              // textColor: item.textColor,
              // textSize: item.textSize,
              borderColor: item.borderColor ?? '#FF0000',
              percentage: nodeData.percentage != null
                  ? nodeData.percentage.toStringAsFixed(2)
                  : "0.00",
              capacity: nodeData.capacity != null
                  ? nodeData.capacity.toStringAsFixed(2)
                  : "0.00",
            );
          });
          break;
        case 'box':
          widget = GetBuilder<WaterLongSLDLiveAllNodePowerController>(builder: (controller) {
            final nodeData = controller.liveAllNodePowerModel.firstWhere(
                  (element) => element.node == item.nodeName,
              orElse: () => WaterLongSLDLiveAllNodePowerModel(),
            );
            return WaterLongSLDTrBoxWithIconWidget(
              sensorStatus: liveData?.sensorStatus ?? true,
              value: power,
              icon: FontAwesomeIcons.solarPanel,
              label: item.nodeName,
              width: item.width.toDouble(),
              height: item.height.toDouble(),
              onTap: () {
                debugPrint("----->TrBoxWithIconWidget<-----");


                Get.to(
                      () => WaterElementDetailsScreen(
                    elementName: item.nodeName,
                    gaugeValue: power,
                    gaugeUnit: 'm³/h',
                    elementCategory: 'Water',

                  ),
                  transition: Transition.rightToLeft,
                  duration: const Duration(seconds: 1),
                );
              },
              unit: 'm³/h',
              borderColor: item.borderColor ?? '#FF0000',
              percentage: nodeData.percentage != null
                  ? nodeData.percentage.toStringAsFixed(2)
                  : "0.00",
              capacity: nodeData.capacity != null
                  ? nodeData.capacity.toStringAsFixed(2)
                  : "0.00",
            );
          });
          break;
        case 'Bus_Bar':
          if (item.sourceType == 'Super_Bus_Bar') {
            widget = GetBuilder<WaterLongSLDLtProductionVsCapacityController>(builder: (controller) {
              return WaterLongSLDSuperBusBarWidget(
                sensorStatus: liveData?.sensorStatus ?? true,
                value: power,
                nodeName: item.nodeName,
                backgroundColor: item.color ?? '#FF0000',
                borderColor: item.borderColor ?? '#FF0000',
                textColor: item.textColor != null ? hexToColor(item.textColor!) : Colors.black,
                loadBoxHeight: item.height.toDouble(),
                loadBoxWidth: item.width.toDouble(),
                onTap: () {},
                unit: 'm³/h',
                gridColor: controller.ltProductionVsCapacityModel.gridColor ?? '#ffffff',
                generatorColor: controller.ltProductionVsCapacityModel.generatorColor ?? '#ffffff',
                solarColor: controller.ltProductionVsCapacityModel.solarColor ?? '#ffffff',
                gridPercentage: item.nodeName == "LT-02 A"
                    ? controller.ltProductionVsCapacityModel.lt02AGridPercentage ?? 0.00
                    : item.nodeName == "LT-02 B"
                    ? controller.ltProductionVsCapacityModel.lt02BGridPercentage ?? 0.00
                    : item.nodeName == "LT-01 A"
                    ? controller.ltProductionVsCapacityModel.lt01AGridPercentage ?? 0.00
                    : item.nodeName == "LT-01 B"
                    ? controller.ltProductionVsCapacityModel.lt01BGridPercentage ?? 0.00
                    : 0.00,
                generatorPercentage: item.nodeName == "LT-02 A"
                    ? controller.ltProductionVsCapacityModel.lt02AGeneratorPercentage ?? 0.00
                    : item.nodeName == "LT-02 B"
                    ? controller.ltProductionVsCapacityModel.lt02BGeneratorPercentage ?? 0.00
                    : item.nodeName == "LT-01 A"
                    ? controller.ltProductionVsCapacityModel.lt01AGeneratorPercentage ?? 0.00
                    : item.nodeName == "LT-01 B"
                    ? controller.ltProductionVsCapacityModel.lt01BGeneratorPercentage ?? 0.00
                    : 0.00,
                solarPercentage: item.nodeName == "LT-02 A"
                    ? controller.ltProductionVsCapacityModel.lt02ASolarPercentage ?? 0.00
                    : item.nodeName == "LT-02 B"
                    ? controller.ltProductionVsCapacityModel.lt02BSolarPercentage ?? 0.00
                    : item.nodeName == "LT-01 A"
                    ? controller.ltProductionVsCapacityModel.lt01ASolarPercentage ?? 0.00
                    : item.nodeName == "LT-01 B"
                    ? controller.ltProductionVsCapacityModel.lt01BSolarPercentage ?? 0.00
                    : 0.00,
                gridValue: item.nodeName == "LT-02 A"
                    ? controller.ltProductionVsCapacityModel.lt02AGridPower ?? 0.00
                    : item.nodeName == "LT-02 B"
                    ? controller.ltProductionVsCapacityModel.lt02BGridPower ?? 0.00
                    : item.nodeName == "LT-01 A"
                    ? controller.ltProductionVsCapacityModel.lt01AGridPower ?? 0.00
                    : item.nodeName == "LT-01 B"
                    ? controller.ltProductionVsCapacityModel.lt01BGridPower ?? 0.00
                    : 0.00,
                generatorValue: item.nodeName == "LT-02 A"
                    ? controller.ltProductionVsCapacityModel.lt02AGeneratorPower ?? 0.00
                    : item.nodeName == "LT-02 B"
                    ? controller.ltProductionVsCapacityModel.lt02BGeneratorPower ?? 0.00
                    : item.nodeName == "LT-01 A"
                    ? controller.ltProductionVsCapacityModel.lt01AGeneratorPower ?? 0.00
                    : item.nodeName == "LT-01 B"
                    ? controller.ltProductionVsCapacityModel.lt01BGeneratorPower ?? 0.00
                    : 0.00,
                solarValue: item.nodeName == "LT-02 A"
                    ? controller.ltProductionVsCapacityModel.lt02ASolarPower ?? 0.00
                    : item.nodeName == "LT-02 B"
                    ? controller.ltProductionVsCapacityModel.lt02BSolarPower ?? 0.00
                    : item.nodeName == "LT-01 A"
                    ? controller.ltProductionVsCapacityModel.lt01ASolarPower ?? 0.00
                    : item.nodeName == "LT-01 B"
                    ? controller.ltProductionVsCapacityModel.lt01BSolarPower ?? 0.00
                    : 0.00,
                y: (item.nodeName == "LT-02 A" || item.nodeName == "LT-02 B") ? 40 : -95,
                orientation: item.orientation,
              );
            });
          } else if (item.sourceType == 'Load_Bus_Bar' || item.sourceType == 'Bus_Bar') {
            if (item.mainBusbar ?? false) {
              widget = GetBuilder<WaterLongSLDLiveAllNodePowerController>(builder: (controller) {
                final nodeData = controller.liveAllNodePowerModel.firstWhere(
                      (element) => element.node == item.nodeName,
                  orElse: () => WaterLongSLDLiveAllNodePowerModel(),
                );
                return WaterLongSLDMainBusBarTrue(
                  sensorStatus: liveData?.sensorStatus ?? true,
                  value: power,
                  nodeName: item.nodeName,
                  color: item.color ?? '#FF0000',
                 borderColor: item.borderColor ?? '#FF0000',
                 textColor: item.textColor,
                 textSize: item.textSize,
                  loadBoxHeight: item.height.toDouble(),
                  loadBoxWidth: item.width.toDouble(),
                  onTap: () {
                    Get.to(
                          () => WaterLongSLDMainBusBarTrueScreen(busBarName: item.nodeName),
                      transition: Transition.rightToLeft,
                      duration: const Duration(seconds: 1),
                    );
                  },
                  unit: 'm³/h',
                  percentage: nodeData.percentage != null
                      ? nodeData.percentage.toStringAsFixed(2)
                      : "0.00",
                  capacity: nodeData.capacity != null
                      ? nodeData.capacity.toStringAsFixed(2)
                      : "0.00",
                  orientation: item.orientation ?? 'horizontal',
                );
              });
            } else {
              widget = WaterLongSLDSourceAndLoadBoxWidget(
                sensorStatus: liveData?.sensorStatus ?? true,
                value: power,
                nodeName: item.nodeName,
                borderColor: item.borderColor ?? '#FF0000',
                textColor: item.textColor,
                textSize: item.textSize,
                loadBoxHeight: item.height.toDouble(),
                loadBoxWidth: item.width.toDouble(),
                color: item.color ?? '#FF0000',

                onTap: () {
                  Get.to(
                        () => WaterLongSLDMainBusBarTrueScreen(busBarName: item.nodeName),
                    transition: Transition.rightToLeft,
                    duration: const Duration(seconds: 1),
                  );
                },
                unit: 'm³/h',
                orientation: item.orientation,
              );
            }
          } else if (item.sourceType == 'Meter_Bus_Bar') {
            widget = WaterLongSLDMeterBusBarWidget(
              sensorStatus: liveData?.sensorStatus ?? true,
              value: power,
              nodeName: item.nodeName,
              color: item.color,
              borderColor: item.borderColor,
              textColor: item.textColor,
              textSize: item.textSize,
              loadBoxHeight: item.height.toDouble(),
              loadBoxWidth: item.width.toDouble(),
              onTap: () {},
              unit: 'm³/h',
              orientation: item.orientation,
            );
          } else {
            widget = const SizedBox.shrink();
          }
          break;
        case 'BusCoupler':
          widget = GetBuilder<GetAllInfoControllersForWater>(
            builder: (controller) {
              double powerMeter = controller.powerMeterMap[item.nodeName] ?? 0.0;
              bool isActive = powerMeter != 0.0;
              return WaterLongSLDBusCouplerWidget(
                key: ValueKey('${item.id}-${liveData?.sensorStatus}'),
                label: item.nodeName,
                width: item.width.toDouble(),
                height: item.height.toDouble(),
                status: isActive,
                shape: item.shape,
                sourceType: item.sourceType,
              );
            },
          );
          break;
        case 'Loop':
          widget = GetBuilder<GetAllInfoControllersForWater>(
            builder: (controller) {
              double powerMeter = controller.powerMeterMap[item.nodeName] ?? 0.0;
              bool isActive = powerMeter != 0.0;
              debugPrint("Loop ${item.nodeName}: Power = $powerMeter, Status = $isActive");
              return WaterLongSLDBusCouplerWidget(
                key: ValueKey('${item.id}-${liveData?.sensorStatus}'),
                label: item.nodeName,
                width: item.width.toDouble(),
                height: item.height.toDouble(),
                status: isActive,
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

class GetAllInfoControllersForWater extends GetxController {
  var powerMeterMap = <String, double>{}.obs;

  void updatePowerMeter(double powerMeter, String nodeName) {
    powerMeterMap[nodeName] = powerMeter;
    update();
  }
}