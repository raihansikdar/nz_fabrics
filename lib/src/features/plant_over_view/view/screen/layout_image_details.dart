import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/screen/power_and_energy_element_details_screen.dart';
import 'package:nz_fabrics/src/features/notification/controller/notification_controller.dart';
import 'package:nz_fabrics/src/features/notification/views/screens/notification_screens.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'dart:convert';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:badges/badges.dart' as badges;

class LayoutImageDetails extends StatefulWidget {
  final String layoutImageUrl;
  final String layoutName;

  const LayoutImageDetails({super.key, required this.layoutImageUrl, required this.layoutName});

  @override
  State<LayoutImageDetails> createState() => _LayoutImageDetailsState();
}

class _LayoutImageDetailsState extends State<LayoutImageDetails> with SingleTickerProviderStateMixin {
  List<dynamic> layoutNodes = [];
  List<dynamic> layoutLines = [];
  Map<String, dynamic> nodeLiveData = {};
  bool isLoading = true;
  int selectedButton = 1;

  void updateSelectedButton({required int value}) {
    setState(() {
      selectedButton = value;
    });
  }

  final double imageWidth = 1970;
  final double imageHeight = 1220;

  double scale = 1.0;
  double rotation = 0.0;
  Offset position = Offset.zero;
  late AnimationController _controller;
  final PhotoViewController _photoViewController = PhotoViewController();
  final String token = AuthUtilityController.accessToken ?? '';

  Size viewportSize = Size.zero;
  bool isAnimating = true;

  @override
  void initState() {
    super.initState();
    fetchLayoutData();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    if (isAnimating) {
      _controller.repeat(reverse: false);
    }

    _photoViewController.outputStateStream.listen((state) {
      setState(() {
        scale = state.scale ?? 1.0;
        position = state.position;
        rotation = state.rotation;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _photoViewController.dispose();
    super.dispose();
  }

  Future<void> fetchLayoutData() async {
    try {
      setState(() => isLoading = true);
      var response = await http.get(
        Uri.parse(Urls.getLayoutNodePositionUrl),
        headers: {"Authorization": token},
      );

      if (response.statusCode == 200) {
        List<dynamic> nodes = json.decode(response.body);
        layoutNodes = nodes
            .where((node) => node["picture_name"] == widget.layoutName)
            .toList();
        layoutLines = layoutNodes.expand((node) => node["lines"] ?? []).toList();
        await fetchLiveDataForNodes();
      } else {
        log("Error fetching layout data: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching layout data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchLiveDataForNodes() async {
    try {
      List<Future> futures = [];
      for (var node in layoutNodes) {
        String nodeName = node["node_name"];
        futures.add(fetchNodeLiveData(nodeName));
      }
      await Future.wait(futures);
    } catch (e) {
      log("Error fetching live data for nodes: $e");
    }
  }

  Future<void> fetchNodeLiveData(String nodeName) async {
    try {
      var encodedNodeName = Uri.encodeComponent(nodeName);
      var response = await http.get(
        Uri.parse(Urls.imagegetdata(encodedNodeName)),
        headers: {"Authorization": token},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          nodeLiveData[nodeName] = data;
        });
      }
    } catch (e) {
      log("Error fetching live data for node $nodeName: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    viewportSize = screenSize;

    // Filter nodes based on selectedButton and resource_type
    String resourceType;
    switch (selectedButton) {
      case 2:
        resourceType = "Water";
        break;
      case 3:
        resourceType = "Steam";
        break;
      case 1:
      default:
        resourceType = "Electricity";
    }

    final filteredNodes = layoutNodes
        .where((node) => node["resource_type"] == resourceType)
        .toList();

    // Filter lines to only include those connected to filtered nodes
    final filteredNodeIds = filteredNodes.map((node) => node["id"]).toSet();
    final filteredLines = layoutLines
        .where((line) => filteredNodeIds.contains(line["startItemId"]))
        .toList();

    return Scaffold(
      appBar: CustomLayoutAppBar(
        layoutName: widget.layoutName,
        selectedButton: selectedButton,
        backPreviousScreen: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double scaleX = constraints.maxWidth / imageWidth;
          double scaleY = constraints.maxHeight / imageHeight;
          double scale = math.min(scaleX, scaleY);

          return Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: 1,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions.customChild(
                    childSize: Size(imageWidth * scale, imageHeight * scale),
                    minScale: PhotoViewComputedScale.contained * 0.2,
                    maxScale: PhotoViewComputedScale.contained * 4.0,
                    initialScale: PhotoViewComputedScale.contained,
                    basePosition: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                        child: Stack(
                          children: [
                            // Display the same image for all resource types
                            CachedNetworkImage(
                              imageUrl: widget.layoutImageUrl,
                              width: imageWidth,
                              height: imageHeight,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                            ),
                            // Overlay nodes
                            ...filteredNodes.map((node) {
                              return NodeWidget(
                                node: node,
                                imageWidth: imageWidth,
                                imageHeight: imageHeight,
                                liveData: nodeLiveData[node["node_name"]],
                                onTap: () {
                                  Get.to(
                                        () => PowerAndEnergyElementDetailsScreen(
                                      elementName: node["node_name"] ?? '',
                                      gaugeValue: nodeLiveData[node["node_name"]]["power"] ?? 0.00,
                                      gaugeUnit: resourceType == "Water" ? "m³/h" : resourceType == "Steam" ? "kg/h" : "kW",
                                      elementCategory: resourceType,
                                      solarCategory: "Load",
                                    ),
                                    transition: Transition.rightToLeft,
                                    duration: const Duration(seconds: 1),
                                  );
                                },
                              );
                            }),
                            // Lines
                            CustomPaint(
                              painter: LinePainter(
                                layoutLines: filteredLines,
                                animation: _controller,
                                nodeLiveData: nodeLiveData,
                                layoutNodes: filteredNodes,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.horizontal,
                backgroundDecoration: const BoxDecoration(color: Colors.white),
                gaplessPlayback: true,
              ),
              // Show loading indicator if data is being fetched
              if (isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'electric_button',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: selectedButton == 1
                  ? BorderSide(color: Colors.purpleAccent, width: 2)
                  : BorderSide.none,
            ),
            backgroundColor: selectedButton == 1 ? Colors.purpleAccent : AppColors.whiteTextColor,
            elevation: selectedButton == 1 ? 8.0 : 2.0,
            onPressed: () {
              updateSelectedButton(value: 1);
            },
            icon: const Icon(Icons.electric_bolt, color: Colors.black),
            label: Text(
              'Electricity',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 5),
          FloatingActionButton.extended(
            heroTag: 'water_button',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: selectedButton == 2
                  ? BorderSide(color: Colors.orange, width: 2)
                  : BorderSide.none,
            ),
            backgroundColor: selectedButton == 2 ? Colors.orange : AppColors.whiteTextColor,
            elevation: selectedButton == 2 ? 8.0 : 2.0,
            onPressed: () {
              updateSelectedButton(value: 2);
            },
            icon: const Icon(Icons.water, color: Colors.black),
            label: Text(
              'Water',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 5),
          FloatingActionButton.extended(
            heroTag: 'steam_button',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: selectedButton == 3
                  ? BorderSide(color: Colors.redAccent, width: 2)
                  : BorderSide.none,
            ),
            backgroundColor: selectedButton == 3 ? Colors.redAccent : AppColors.whiteTextColor,
            elevation: selectedButton == 3 ? 8.0 : 2.0,
            onPressed: () {
              updateSelectedButton(value: 3);
            },
            icon: const Icon(Icons.stream, color: Colors.black),
            label: Text(
              'Steam',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}


class NodeWidget extends StatelessWidget {
  final dynamic node;
  final double imageWidth;
  final double imageHeight;
  final dynamic liveData;
  final VoidCallback? onTap;

  const NodeWidget({
    super.key,
    required this.node,
    required this.imageWidth,
    required this.imageHeight,
    this.liveData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final nodeX = node["position_x"].toDouble() + 17;
    final nodeY = node["position_y"].toDouble() + 60;
    final nodeWidth = node["width"].toDouble();

    Color? nodeColor;
    String powerValue = "0.0";
    String unit = "kW";
    bool sensorStatus = false;

    if (liveData != null) {
      try {
        // Safely handle color
        nodeColor = liveData["color"] != null ? _hexToColor(liveData["color"]) : Colors.green;
        // Safely handle power
        powerValue = liveData["power"] != null ? "${liveData["power"].toStringAsFixed(1)}" : "0.0";
        // Determine unit based on resource_type
        unit = node["resource_type"] == "Water" ? "m³/h" : node["resource_type"] == "Steam" ? "kg/h" : "kW";
        // Safely handle sensor_status
        sensorStatus = liveData["sensor_status"] ?? false;
      } catch (e) {
        log("Error parsing live data for node ${node["node_name"]}: $e");
      }
    }

    return Positioned(
      left: nodeX,
      top: nodeY,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: nodeWidth,
          height: 27,
          decoration: BoxDecoration(
            color: nodeColor ?? Colors.green, // Fallback to green if nodeColor is null
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.white, width: 1),
            boxShadow: [
              BoxShadow(
                color: sensorStatus
                    ? Colors.greenAccent.withOpacity(0.3)
                    : Colors.redAccent.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: liveData != null
                ? AutoSizeText(
              "${node["node_name"]}: $powerValue $unit",
              maxLines: 1,
              minFontSize: 6,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    try {
      return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
    } catch (e) {
      return Colors.green; // Default color
    }
  }
}
class LinePainter extends CustomPainter {
  final List<dynamic> layoutLines;
  final Animation<double> animation;
  final Paint linePaint;
  final Paint progressPaint;
  final Map<String, dynamic> nodeLiveData;
  final List<dynamic> layoutNodes;

  LinePainter({
    required this.layoutLines,
    required this.animation,
    required this.nodeLiveData, // Add this parameter
    required this.layoutNodes, // Add this parameter
  }) :
        linePaint = Paint()
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke
          ..color = Colors.grey,
        progressPaint = Paint()
          ..strokeWidth = 4.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
        super(repaint: animation);

  Color hexToColor(String hex) {
    try {
      return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
    } catch (e) {
      return Colors.blue; // Default color
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (layoutLines.isEmpty) return;

    for (var line in layoutLines) {
      if (line["points"] == null || line["points"].isEmpty) continue;

      // Find the source node for this line
      final sourceNodeId = line["startItemId"];
      final sourceNode = layoutNodes.firstWhere(
            (node) => node["id"] == sourceNodeId,
        orElse: () => null,
      );

      // Check if source node exists and is a Meter_Bus_Bar
      bool isSourceMeterBusBar = sourceNode != null &&
          sourceNode["source_type"] == "Meter_Bus_Bar";

      // Check if power value is negative or zero
      bool shouldReverseAnimation = false;
      if (isSourceMeterBusBar && nodeLiveData.containsKey(sourceNode["node_name"])) {
        final power = nodeLiveData[sourceNode["node_name"]]["power"] ?? 0;
        shouldReverseAnimation = power <= 0;
      }

      // Draw the full path in grey first (as a background)
      Path fullPath = Path();

      // Get points in the right order
      List<dynamic> points = List.from(line["points"]);
      if (shouldReverseAnimation) {
        // Reverse the points array
        points = points.reversed.toList();
      }

      var firstPoint = Offset(
        points[0]["x"].toDouble() + 17,
        points[0]["y"].toDouble() + 57,
      );
      fullPath.moveTo(firstPoint.dx, firstPoint.dy);

      // Create a list of points for the animated path
      List<Offset> pathPoints = [];
      pathPoints.add(firstPoint);

      for (int i = 1; i < points.length; i++) {
        var point = points[i];
        var currentPoint = Offset(
          point["x"].toDouble() + 17,
          point["y"].toDouble() + 57,
        );
        fullPath.lineTo(currentPoint.dx, currentPoint.dy);
        pathPoints.add(currentPoint);
      }

      // Draw the full path in light grey
      canvas.drawPath(fullPath, linePaint);

      // Calculate the total length of the path
      double totalLength = 0;
      List<double> segmentLengths = [];

      for (int i = 0; i < pathPoints.length - 1; i++) {
        double segmentLength = (pathPoints[i] - pathPoints[i + 1]).distance;
        segmentLengths.add(segmentLength);
        totalLength += segmentLength;
      }

      // Calculate how much of the path to draw based on animation value
      double animatedLength = totalLength * animation.value;
      double drawnLength = 0;

      // Draw the animated part of the path
      Path animatedPath = Path();
      animatedPath.moveTo(pathPoints[0].dx, pathPoints[0].dy);

      for (int i = 0; i < segmentLengths.length; i++) {
        if (drawnLength + segmentLengths[i] <= animatedLength) {
          // Draw the full segment
          animatedPath.lineTo(pathPoints[i + 1].dx, pathPoints[i + 1].dy);
          drawnLength += segmentLengths[i];
        } else {
          // Draw a partial segment
          double remainingLength = animatedLength - drawnLength;
          double fraction = remainingLength / segmentLengths[i];

          // Interpolate between the current point and the next point
          double x = pathPoints[i].dx + (pathPoints[i + 1].dx - pathPoints[i].dx) * fraction;
          double y = pathPoints[i].dy + (pathPoints[i + 1].dy - pathPoints[i].dy) * fraction;

          animatedPath.lineTo(x, y);
          break;
        }
      }

      // Set color from the line data
      progressPaint.color = hexToColor(line["lineColor"] ?? "#1E88E5");

      // Add glow effect to the animated line
      progressPaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      // Draw the animated path
      canvas.drawPath(animatedPath, progressPaint);

      // Draw a dot at the end of the animated path
      if (animation.value > 0) {
        var pathMetrics = animatedPath.computeMetrics().toList();
        if (pathMetrics.isNotEmpty) {
          var lastPathMetric = pathMetrics.last;
          var tangent = lastPathMetric.getTangentForOffset(lastPathMetric.length);
          if (tangent != null) {
            canvas.drawCircle(
                tangent.position,
                6.0,
                Paint()..color = progressPaint.color
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.nodeLiveData != nodeLiveData;
  }
}

class CustomLayoutAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String layoutName;
  final bool backPreviousScreen;
  final int selectedButton;

  const CustomLayoutAppBar({
    super.key,
    required this.layoutName,
    required this.selectedButton,
    this.backPreviousScreen = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  State<CustomLayoutAppBar> createState() => _CustomLayoutAppBarState();
}

class _CustomLayoutAppBarState extends State<CustomLayoutAppBar> {
  bool isLoading = true;
  List<MachineTypeSummary> summaryList = [];
  double totalPower = 0.0;
  int totalMachines = 0;
  int activeMachines = 0;
  final String token = AuthUtilityController.accessToken ?? '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await LayoutApiService.fetchLayoutSummary(widget.layoutName, token);

      setState(() {
        summaryList = data;

        // Calculate totals
        for (var summary in summaryList) {
          totalPower += summary.totalPower;
          totalMachines += summary.totalMachine;
          activeMachines += summary.activeMachine;
        }

        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(

      automaticallyImplyLeading: widget.backPreviousScreen,
      titleSpacing: 0,
      title: TextComponent(text: widget.layoutName, fontSize: 22),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              if(widget.selectedButton == 1)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: summaryList.map((summary) =>
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            // backgroundColor: Colors.blue.shade700,
                            label: Text(
                              summary.formattedSummary,
                              style: const TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                    ).toList(),
                  ),
                )
              else if(widget.selectedButton == 2)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    // backgroundColor: Colors.blue.shade700,
                    label: Text(
                      'Water',
                      style: const TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              else if(widget.selectedButton == 3)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Chip(
                      // backgroundColor: Colors.blue.shade700,
                      label: Text(
                        'Steam',
                        style: const TextStyle(color: Colors.black, fontSize: 12,fontWeight: FontWeight.bold),
                      ),
                    ),
                  )




            ],
          ),
        ),
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: GestureDetector(
            onTap: (){
              Get.find<NotificationController>().unseenCount = 0;
              Get.find<NotificationController>().update();
              Get.to(()=>const NotificationScreens(),transition: Transition.fadeIn,duration: const Duration(seconds: 0));
            },
            child: GetBuilder<NotificationController>(
                builder: (notificationController) {

                  if(notificationController.unseenCount == 0){
                    return const Icon(Icons.notifications_none_sharp,size: 30,);
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
                    child: const Icon(Icons.notifications_none_sharp,size: 30,), // widget to place the badge on
                  );
                }
            ),
          ),
        ),
      ],

    );
  }
}

class MachineTypeSummary {
  final String machineType;
  final int activeMachine;
  final int totalMachine;
  final double totalPower;

  MachineTypeSummary({
    required this.machineType,
    required this.activeMachine,
    required this.totalMachine,
    required this.totalPower,
  });

  factory MachineTypeSummary.fromJson(Map<String, dynamic> json) {
    return MachineTypeSummary(
      machineType: json['machine_type'] ?? 'Unknown',
      activeMachine: int.parse(json['active_machine'].toString()),
      totalMachine: int.parse(json['total_machine'].toString()),
      totalPower: double.parse(json['total_power'].toString()),
    );
  }

  String get formattedSummary =>
      "$machineType -$activeMachine/$totalMachine(${totalPower.toStringAsFixed(2)} kW)";
}
class LayoutApiService {
  static  String baseUrl = '${Urls.baseUrl}/api';

  static Future<List<MachineTypeSummary>> fetchLayoutSummary(String layoutName, String token) async {
    try {
      final encodedLayoutName = Uri.encodeComponent(layoutName);
      final url = '$baseUrl/layout-summary/$encodedLayoutName/';

      final response = await http.get(
          Uri.parse(url),
          headers: {"Authorization": token}
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => MachineTypeSummary.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load layout summary: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching layout summary: $e');
    }
    }
}