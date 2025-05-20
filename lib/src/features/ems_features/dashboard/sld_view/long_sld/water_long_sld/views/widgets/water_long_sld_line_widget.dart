// import 'dart:math' as math;
// import 'dart:ui' as ui;
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/electricity_long_live_all_node_power_model.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/model/water_long_sld_live_all_node_power_model.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/model/water_long_sld_view_page_model.dart';

// class WaterLongSLDAnimatedLinePainter extends CustomPainter {
//   final List<WaterLongSLDViewPageModel> viewPageData;
//   final Map<dynamic, LiveDataModel> liveData;
//   final double minX;
//   final double minY;
//   final Animation<double> animation;
//   final bool debugBaseLineOnly;
//
//   WaterLongSLDAnimatedLinePainter({
//     required this.viewPageData,
//     required this.liveData,
//     required this.minX,
//     required this.minY,
//     required this.animation,
//     this.debugBaseLineOnly = false,
//   }) : super(repaint: animation);
//
//   Color hexToColor(String hex) {
//     return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
//   }
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     for (var item in viewPageData) {
//       if (item.lines != null) {
//         for (var line in item.lines) {
//           var startItem = firstWhereOrNull(viewPageData, (element) => element.id == line.startItemId);
//           var endItem = firstWhereOrNull(viewPageData, (element) => element.id == line.endItemId);
//           if (startItem == null || endItem == null) continue;
//
//           bool reverseDirection = checkReverseDirection(startItem, endItem, line, liveData);
//
//           if (line.points.isNotEmpty) {
//             Path path = createLinePath(line);
//             drawAnimatedLine(canvas, path, line, reverseDirection);
//
//             // Arrow drawing removed
//           }
//         }
//       }
//     }
//   }
//
//   Path createLinePath(Line line) {
//     Path path = Path();
//     if (line.points.isEmpty) return path;
//
//     var firstPoint = Offset(line.points.first.x - minX, line.points.first.y - minY);
//     path.moveTo(firstPoint.dx, firstPoint.dy);
//
//     for (int i = 1; i < line.points.length; i++) {
//       var point = line.points[i];
//       var adjustedPoint = Offset(point.x - minX, point.y - minY);
//       path.lineTo(adjustedPoint.dx, adjustedPoint.dy);
//     }
//     return path;
//   }
//
//   void drawAnimatedLine(Canvas canvas, Path path, Line line, bool reverseDirection) {
//     final lineColor = line.lineColor != null ? hexToColor(line.lineColor!) : Colors.blue;
//     const double lineWidth = 10.0;
//
//     final pipePaint = Paint()
//       ..color = lineColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = lineWidth
//       ..strokeCap = StrokeCap.butt
//       ..strokeJoin = StrokeJoin.round;
//
//     // Always draw the base line (pipe)
//     canvas.drawPath(path, pipePaint);
//
//     if (debugBaseLineOnly) return;
//
//     // Check if flow is available (power is non-zero and not null)
//     var startItem = firstWhereOrNull(viewPageData, (element) => element.id == line.startItemId);
//     var endItem = firstWhereOrNull(viewPageData, (element) => element.id == line.endItemId);
//     double? power = liveData[startItem?.id]?.power ?? liveData[endItem?.id]?.power;
//
//     // Skip bubble animation if power is null or zero (no flow)
//     if (power == null || power == 0) return;
//
//     ui.PathMetrics pathMetrics = path.computeMetrics();
//     for (var metric in pathMetrics) {
//       double length = metric.length;
//       double animatedValue = reverseDirection ? 1.0 - animation.value : animation.value;
//
//       const int numBubblesPerLine = 5;
//       final random = math.Random(line.hashCode);
//       final bubblePaint = Paint()
//         ..color = Colors.white.withOpacity(0.7)
//         ..style = PaintingStyle.fill;
//
//       final leftLineOffset = -lineWidth * 0.25;
//       final rightLineOffset = lineWidth * 0.25;
//
//       for (int i = 0; i < numBubblesPerLine; i++) {
//         double leftBubbleOffset = ((animatedValue + (i / numBubblesPerLine)) % 1.0) * length;
//         ui.Tangent? leftTangent = metric.getTangentForOffset(leftBubbleOffset);
//         if (leftTangent != null) {
//           double bubbleSize = lineWidth * (0.15 + random.nextDouble() * 0.1);
//           Offset perpendicular = Offset(-leftTangent.vector.dy, leftTangent.vector.dx).normalized();
//           Offset bubblePosition = leftTangent.position + perpendicular * leftLineOffset;
//           canvas.drawCircle(bubblePosition, bubbleSize, bubblePaint);
//         }
//
//         double rightBubbleOffset = ((animatedValue + (i / numBubblesPerLine) + 0.3) % 1.0) * length;
//         ui.Tangent? rightTangent = metric.getTangentForOffset(rightBubbleOffset);
//         if (rightTangent != null) {
//           double bubbleSize = lineWidth * (0.15 + random.nextDouble() * 0.1);
//           Offset perpendicular = Offset(-rightTangent.vector.dy, rightTangent.vector.dx).normalized();
//           Offset bubblePosition = rightTangent.position + perpendicular * rightLineOffset;
//           canvas.drawCircle(bubblePosition, bubbleSize, bubblePaint);
//         }
//       }
//     }
//   }
//   bool checkIfShouldSkipAnimation(WaterLongSLDViewPageModel startItem, WaterLongSLDViewPageModel endItem, Line line) {
//     return (startItem.sourceType == "BusCoupler" &&
//         (line.startEdgeIndex == 2 || line.endEdgeIndex == 2)) ||
//         (endItem.sourceType == "BusCoupler" &&
//             (line.startEdgeIndex == 2 || line.endEdgeIndex == 2)) ||
//         (startItem.sourceType == "Loop" &&
//             !(line.startEdgeIndex == 2 ||
//                 line.endEdgeIndex == 2 ||
//                 line.startEdgeIndex == 0 ||
//                 line.endEdgeIndex == 0)) ||
//         (endItem.sourceType == "Loop" &&
//             !(line.startEdgeIndex == 2 ||
//                 line.endEdgeIndex == 2 ||
//                 line.startEdgeIndex == 0 ||
//                 line.endEdgeIndex == 0));
//   }
//
//   bool checkReverseDirection(
//       WaterLongSLDViewPageModel startItem, WaterLongSLDViewPageModel endItem, Line line, Map<dynamic, LiveDataModel> liveData) {
//     if (startItem.sourceType == "BusCoupler" ||
//         endItem.sourceType == "BusCoupler" ||
//         startItem.sourceType == "Loop" ||
//         endItem.sourceType == "Loop") {
//       double? power = liveData[startItem.id]?.power ?? liveData[endItem.id]?.power;
//       if (power != null && power < 0) {
//         return true;
//       }
//     }
//     const List<String> reverseNodes = ["BBT 02", "BBT 04", "BBT 07", "BBT 08"];
//     const List<String> ltBusBars = ["LT-01 A", "LT-01 B", "LT-02 A", "LT-02 B"];
//
//     bool isStartNodeReverse = reverseNodes.contains(startItem.nodeName);
//     bool isEndNodeReverse = reverseNodes.contains(endItem.nodeName);
//     bool isStartBusBar = ltBusBars.contains(startItem.nodeName);
//     bool isEndBusBar = ltBusBars.contains(endItem.nodeName);
//
//     double? startPower = liveData[startItem.id]?.power;
//     double? endPower = liveData[endItem.id]?.power;
//
//     if ((isStartNodeReverse && isEndBusBar && startPower != null && startPower < 0) ||
//         (isEndNodeReverse && isStartBusBar && endPower != null && endPower < 0)) {
//       return true;
//     }
//
//     return false;
//   }
//
//   @override
//   bool shouldRepaint(WaterLongSLDAnimatedLinePainter oldDelegate) {
//     return oldDelegate.animation != animation ||
//         oldDelegate.viewPageData != viewPageData ||
//         oldDelegate.liveData != liveData ||
//         oldDelegate.debugBaseLineOnly != debugBaseLineOnly;
//   }
// }
//
// T? firstWhereOrNull<T>(List<T> list, bool Function(T) test) {
//   for (var item in list) {
//     if (test(item)) return item;
//   }
//   return null;
// }
//
// extension OffsetExtension on Offset {
//   Offset normalized() {
//     final double magnitude = distance;
//     if (magnitude == 0) return Offset.zero;
//     return this / magnitude;
//     }
// }








// class WaterLongSLDAnimatedLinePainter extends CustomPainter {
//   final List<WaterLongSLDViewPageModel> viewPageData;
//   final List<BusBarStatusInfoModel> sensorStatusData;
//   final List<WaterLongSLDLiveAllNodePowerModel> liveAllNodeModel;
//   final double minX;
//   final double minY;
//   final Animation<double> animation;
//   final bool debugBaseLineOnly;
//
//   WaterLongSLDAnimatedLinePainter({
//     required this.viewPageData,
//     required this.sensorStatusData,
//     required this.liveAllNodeModel,
//     required this.minX,
//     required this.minY,
//     required this.animation,
//     this.debugBaseLineOnly = false,
//   }) : super(repaint: animation);
//
//   Color hexToColor(String? hex) {
//     if (hex == null || hex.isEmpty) {
//       debugPrint('Hex color is null or empty, using black');
//       return Colors.black;
//     }
//     hex = hex.replaceAll('#', '');
//     try {
//       return Color(int.parse('0xFF$hex'));
//     } catch (e) {
//       debugPrint('Error parsing hex color: $hex, error: $e');
//       return Colors.black;
//     }
//   }
//
//   bool shouldAnimateLine(String? lineId) {
//     if (lineId == null || sensorStatusData.isEmpty) {
//       debugPrint('LineID is null or sensorStatusData is empty for lineID: $lineId');
//       return false;
//     }
//
//     for (var statusInfo in sensorStatusData) {
//       if (statusInfo.connectedWithDetails != null) {
//         for (var connectedDetail in statusInfo.connectedWithDetails!) {
//           if (connectedDetail.lineID == lineId && connectedDetail.sensorStatus == true) {
//             debugPrint('Animation enabled for lineID: $lineId (sensorStatus: true)');
//             return true;
//           }
//         }
//       }
//     }
//     debugPrint('Animation disabled for lineID: $lineId (no active sensorStatus)');
//     return false;
//   }
//
//   bool checkReverseDirection(String? lineId) {
//     if (lineId == null) return false;
//
//     for (var statusInfo in sensorStatusData) {
//       if (statusInfo.connectedWithDetails != null) {
//         for (var connectedDetail in statusInfo.connectedWithDetails!) {
//           if (connectedDetail.lineID == lineId) {
//             bool reverse = connectedDetail.sensorStatus == false;
//             debugPrint('Reverse direction for lineID: $lineId: $reverse');
//             return reverse;
//           }
//         }
//       }
//     }
//     return false;
//   }
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     debugPrint('Canvas size: ${size.width}x${size.height}');
//     if (viewPageData.isEmpty) {
//       debugPrint('viewPageData is empty');
//       return;
//     }
//
//     for (var item in viewPageData) {
//       if (item.lines == null || item.lines!.isEmpty) {
//         debugPrint('No lines in item');
//         continue;
//       }
//
//       for (var line in item.lines!) {
//         if (line.points.isEmpty) {
//           debugPrint('Line has no points');
//           continue;
//         }
//
//         try {
//           var startItem = firstWhereOrNull(viewPageData, (element) => element.id == line.startItemId);
//           var endItem = firstWhereOrNull(viewPageData, (element) => element.id == line.endItemId);
//           if (startItem == null || endItem == null) {
//             debugPrint('Start or end item not found for lineID: ${line.lineId}');
//             continue;
//           }
//
//           Path path = createLinePath(line);
//           Color lineColor = hexToColor(line.lineColor); // Take color from Line
//           bool reverseDirection = checkReverseDirection(line.lineId);
//
//           // Always draw the static line
//           drawStaticLine(canvas, path, lineColor);
//
//           // Draw bubble animation if applicable
//           if (!debugBaseLineOnly && shouldAnimateLine(line.lineId)) {
//             drawAnimatedLine(canvas, path, lineColor, reverseDirection);
//           }
//         } catch (e) {
//           debugPrint('Error drawing line: $e');
//         }
//       }
//     }
//   }
//
//   Path createLinePath(Line line) {
//     Path path = Path();
//     try {
//       var firstPoint = Offset(line.points.first.x - minX, line.points.first.y - minY);
//       debugPrint('First point: (${firstPoint.dx}, ${firstPoint.dy})');
//       path.moveTo(firstPoint.dx, firstPoint.dy);
//       for (int i = 1; i < line.points.length; i++) {
//         var point = line.points[i];
//         path.lineTo(point.x - minX, point.y - minY);
//       }
//     } catch (e) {
//       debugPrint('Error creating path: $e');
//     }
//     return path;
//   }
//
//   void drawStaticLine(Canvas canvas, Path path, Color lineColor) {
//     final effectiveColor = lineColor.alpha == 0 ? lineColor.withOpacity(1.0) : lineColor;
//
//     final linePaint = Paint()
//       ..strokeWidth = 10.0
//       ..style = PaintingStyle.stroke
//       ..color = effectiveColor
//       ..strokeCap = StrokeCap.butt
//       ..strokeJoin = StrokeJoin.round;
//
//     debugPrint('Drawing static line with color: ${effectiveColor.toString()}');
//     canvas.drawPath(path, linePaint);
//   }
//
//   void drawAnimatedLine(Canvas canvas, Path path, Color lineColor, bool reverseDirection) {
//     debugPrint('Drawing animated line with reverse: $reverseDirection');
//     PathMetrics pathMetrics = path.computeMetrics();
//     for (var metric in pathMetrics) {
//       double length = metric.length;
//       if (length == 0) {
//         debugPrint('Path length is zero');
//         continue;
//       }
//
//       double animatedValue = reverseDirection ? 1.0 - animation.value : animation.value;
//       const int numBubblesPerLine = 5;
//       final random = math.Random(path.hashCode);
//       final bubblePaint = Paint()
//         ..color = Colors.white.withOpacity(0.7)
//         ..style = PaintingStyle.fill;
//
//       const double lineWidth = 10.0;
//       final leftLineOffset = -lineWidth * 0.25;
//       final rightLineOffset = lineWidth * 0.25;
//
//       for (int i = 0; i < numBubblesPerLine; i++) {
//         double leftBubbleOffset = ((animatedValue + (i / numBubblesPerLine)) % 1.0) * length;
//         Tangent? leftTangent = metric.getTangentForOffset(leftBubbleOffset);
//         if (leftTangent != null) {
//           double bubbleSize = lineWidth * (0.15 + random.nextDouble() * 0.1);
//           Offset perpendicular = Offset(-leftTangent.vector.dy, leftTangent.vector.dx).normalized();
//           Offset bubblePosition = leftTangent.position + perpendicular * leftLineOffset;
//           canvas.drawCircle(bubblePosition, bubbleSize, bubblePaint);
//         }
//
//         double rightBubbleOffset = ((animatedValue + (i / numBubblesPerLine) + 0.3) % 1.0) * length;
//         Tangent? rightTangent = metric.getTangentForOffset(rightBubbleOffset);
//         if (rightTangent != null) {
//           double bubbleSize = lineWidth * (0.15 + random.nextDouble() * 0.1);
//           Offset perpendicular = Offset(-rightTangent.vector.dy, rightTangent.vector.dx).normalized();
//           Offset bubblePosition = rightTangent.position + perpendicular * rightLineOffset;
//           canvas.drawCircle(bubblePosition, bubbleSize, bubblePaint);
//         }
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(WaterLongSLDAnimatedLinePainter oldDelegate) {
//     return oldDelegate.animation != animation ||
//         oldDelegate.viewPageData != viewPageData ||
//         oldDelegate.sensorStatusData != sensorStatusData ||
//         oldDelegate.minX != minX ||
//         oldDelegate.minY != minY ||
//         oldDelegate.debugBaseLineOnly != debugBaseLineOnly;
//   }
// }
//
// T? firstWhereOrNull<T>(List<T> list, bool Function(T) test) {
//   for (var item in list) {
//     if (test(item)) return item;
//   }
//   return null;
// }
//
// extension OffsetExtension on Offset {
//   Offset normalized() {
//     final double magnitude = distance;
//     if (magnitude == 0) return Offset.zero;
//     return this / magnitude;
//   }
// }

// import 'dart:math' as math;
// import 'package:flutter/material.dart';
//
// class WaterLongSLDAnimatedLinePainter extends CustomPainter {
//   final List<WaterLongSLDViewPageModel> viewPageData;
//   final List<WaterLongSLDLiveAllNodePowerModel> liveAllNodeModel;
//   final double minX;
//   final double minY;
//   final Animation<double> animation;
//   final bool debugBaseLineOnly;
//
//   WaterLongSLDAnimatedLinePainter({
//     required this.viewPageData,
//     required this.liveAllNodeModel,
//     required this.minX,
//     required this.minY,
//     required this.animation,
//     this.debugBaseLineOnly = false,
//   }) : super(repaint: animation);
//
//   Color hexToColor(String? hex) {
//     if (hex == null || hex.isEmpty) {
//       debugPrint('Hex color is null or empty, using black');
//       return Colors.black;
//     }
//     hex = hex.replaceAll('#', '');
//     try {
//       return Color(int.parse('0xFF$hex'));
//     } catch (e) {
//       debugPrint('Error parsing hex color: $hex, error: $e');
//       return Colors.black;
//     }
//   }
//
//   bool shouldAnimateLine(String? lineId) {
//     if (lineId == null || liveAllNodeModel.isEmpty || viewPageData.isEmpty) {
//       debugPrint('LineID is null, liveAllNodeModel or viewPageData is empty for lineID: $lineId');
//       return false;
//     }
//
//     // Find the line with the given lineId
//     Line? targetLine;
//     for (var item in viewPageData) {
//       if (item.lines != null) {
//         targetLine = item.lines!.firstWhere(
//               (line) => line.lineId == lineId,
//           orElse: () => Line(
//             lineId: '',
//             points: [],
//             startItemId: 0,
//             endItemId: 0,
//             startEdgeIndex: 0,
//             endEdgeIndex: 0,
//           ),
//         );
//         if (targetLine.lineId.isNotEmpty) break;
//       }
//     }
//
//     if (targetLine == null || targetLine.lineId.isEmpty) {
//       debugPrint('Line not found for lineID: $lineId');
//       return false;
//     }
//
//     // Find the start and end nodes of the line
//     var startNode = firstWhereOrNull(viewPageData, (node) => node.id == targetLine!.startItemId);
//     var endNode = firstWhereOrNull(viewPageData, (node) => node.id == targetLine!.endItemId);
//
//     if (startNode == null && endNode == null) {
//       debugPrint('Start and end nodes not found for lineID: $lineId');
//       return false;
//     }
//
//     // Check if any live node associated with start or end node has sensorStatus == true
//     for (var liveNode in liveAllNodeModel) {
//       if (liveNode.sensorStatus != true) continue;
//
//       // Match liveNode.node with startNode.nodeId or endNode.nodeId (or nodeName)
//       bool matchesStart = startNode != null &&
//           (startNode.nodeId?.contains(liveNode.node ?? '') == true ||
//               startNode.nodeName == liveNode.node);
//       bool matchesEnd = endNode != null &&
//           (endNode.nodeId?.contains(liveNode.node ?? '') == true ||
//               endNode.nodeName == liveNode.node);
//
//       if (matchesStart || matchesEnd) {
//         debugPrint('Animation enabled for lineID: $lineId (sensorStatus: true for node: ${liveNode.node})');
//         return true;
//       }
//     }
//
//     debugPrint('Animation disabled for lineID: $lineId (no active sensorStatus for associated nodes)');
//     return false;
//   }
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     debugPrint('Canvas size: ${size.width}x${size.height}');
//     if (viewPageData.isEmpty) {
//       debugPrint('viewPageData is empty');
//       return;
//     }
//
//     for (var item in viewPageData) {
//       if (item.lines == null || item.lines!.isEmpty) {
//         debugPrint('No lines in item');
//         continue;
//       }
//
//       for (var line in item.lines!) {
//         if (line.points.isEmpty) {
//           debugPrint('Line has no points');
//           continue;
//         }
//
//         try {
//           var startItem = firstWhereOrNull(viewPageData, (element) => element.id == line.startItemId);
//           var endItem = firstWhereOrNull(viewPageData, (element) => element.id == line.endItemId);
//           if (startItem == null || endItem == null) {
//             debugPrint('Start or end item not found for lineID: ${line.lineId}');
//             continue;
//           }
//
//           Path path = createLinePath(line);
//           Color lineColor = hexToColor(line.lineColor);
//
//           // Always draw the static line
//           drawStaticLine(canvas, path, lineColor);
//
//           // Draw bubble animation if applicable
//           if (!debugBaseLineOnly && shouldAnimateLine(line.lineId)) {
//             drawAnimatedLine(canvas, path, lineColor, false); // No reverse direction
//           }
//         } catch (e) {
//           debugPrint('Error drawing line: $e');
//         }
//       }
//     }
//   }
//
//   Path createLinePath(Line line) {
//     Path path = Path();
//     try {
//       var firstPoint = Offset(line.points.first.x - minX, line.points.first.y - minY);
//       debugPrint('First point: (${firstPoint.dx}, ${firstPoint.dy})');
//       path.moveTo(firstPoint.dx, firstPoint.dy);
//       for (int i = 1; i < line.points.length; i++) {
//         var point = line.points[i];
//         path.lineTo(point.x - minX, point.y - minY);
//       }
//     } catch (e) {
//       debugPrint('Error creating path: $e');
//     }
//     return path;
//   }
//
//   void drawStaticLine(Canvas canvas, Path path, Color lineColor) {
//     final effectiveColor = lineColor.alpha == 0 ? lineColor.withOpacity(1.0) : lineColor;
//
//     final linePaint = Paint()
//       ..strokeWidth = 10.0
//       ..style = PaintingStyle.stroke
//       ..color = effectiveColor
//       ..strokeCap = StrokeCap.butt
//       ..strokeJoin = StrokeJoin.round;
//
//     debugPrint('Drawing static line with color: ${effectiveColor.toString()}');
//     canvas.drawPath(path, linePaint);
//   }
//
//   void drawAnimatedLine(Canvas canvas, Path path, Color lineColor, bool reverseDirection) {
//     debugPrint('Drawing animated line with reverse: $reverseDirection');
//     PathMetrics pathMetrics = path.computeMetrics();
//     for (var metric in pathMetrics) {
//       double length = metric.length;
//       if (length == 0) {
//         debugPrint('Path length is zero');
//         continue;
//       }
//
//       double animatedValue = reverseDirection ? 1.0 - animation.value : animation.value;
//       const int numBubblesPerLine = 5;
//       final random = math.Random(path.hashCode);
//       final bubblePaint = Paint()
//         ..color = Colors.white.withOpacity(0.7)
//         ..style = PaintingStyle.fill;
//
//       const double lineWidth = 10.0;
//       final leftLineOffset = -lineWidth * 0.25;
//       final rightLineOffset = lineWidth * 0.25;
//
//       for (int i = 0; i < numBubblesPerLine; i++) {
//         double leftBubbleOffset = ((animatedValue + (i / numBubblesPerLine)) % 1.0) * length;
//         Tangent? leftTangent = metric.getTangentForOffset(leftBubbleOffset);
//         if (leftTangent != null) {
//           double bubbleSize = lineWidth * (0.15 + random.nextDouble() * 0.1);
//           Offset perpendicular = Offset(-leftTangent.vector.dy, leftTangent.vector.dx).normalized();
//           Offset bubblePosition = leftTangent.position + perpendicular * leftLineOffset;
//           canvas.drawCircle(bubblePosition, bubbleSize, bubblePaint);
//         }
//
//         double rightBubbleOffset = ((animatedValue + (i / numBubblesPerLine) + 0.3) % 1.0) * length;
//         Tangent? rightTangent = metric.getTangentForOffset(rightBubbleOffset);
//         if (rightTangent != null) {
//           double bubbleSize = lineWidth * (0.15 + random.nextDouble() * 0.1);
//           Offset perpendicular = Offset(-rightTangent.vector.dy, rightTangent.vector.dx).normalized();
//           Offset bubblePosition = rightTangent.position + perpendicular * rightLineOffset;
//           canvas.drawCircle(bubblePosition, bubbleSize, bubblePaint);
//         }
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(WaterLongSLDAnimatedLinePainter oldDelegate) {
//     return oldDelegate.animation != animation ||
//         oldDelegate.viewPageData != viewPageData ||
//         oldDelegate.liveAllNodeModel != liveAllNodeModel ||
//         oldDelegate.minX != minX ||
//         oldDelegate.minY != minY ||
//         oldDelegate.debugBaseLineOnly != debugBaseLineOnly;
//   }
// }
//
// T? firstWhereOrNull<T>(List<T> list, bool Function(T) test) {
//   for (var item in list) {
//     if (test(item)) return item;
//   }
//   return null;
// }
//
// extension OffsetExtension on Offset {
//   Offset normalized() {
//     final double magnitude = distance;
//     if (magnitude == 0) return Offset.zero;
//     return this / magnitude;
//   }
// }



import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/model/water_long_sld_live_all_node_power_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/model/water_long_sld_view_page_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/busbar_status_info_model.dart';

class WaterLongSLDAnimatedLinePainter extends CustomPainter {
  final List<WaterLongSLDViewPageModel> viewPageData;
  final List<WaterLongSLDLiveAllNodePowerModel> liveAllNodeModel;
  final List<BusBarStatusInfoModel> busBarStatusModels;
  final double minX;
  final double minY;
  final Animation<double> animation;
  final bool debugBaseLineOnly;

  WaterLongSLDAnimatedLinePainter({
    required this.viewPageData,
    required this.liveAllNodeModel,
    required this.busBarStatusModels, // Added parameter
    required this.minX,
    required this.minY,
    required this.animation,
    this.debugBaseLineOnly = false,
  }) : super(repaint: animation);

  Color hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) {
      //debugPrint('Hex color is null or empty, using black');
      return Colors.black;
    }
    hex = hex.replaceAll('#', '');
    try {
      return Color(int.parse('0xFF$hex'));
    } catch (e) {
     // debugPrint('Error parsing hex color: $hex, error: $e');
      return Colors.black;
    }
  }

  bool shouldAnimateLine(String? lineId) {
    if (lineId == null || (liveAllNodeModel.isEmpty && busBarStatusModels.isEmpty) || viewPageData.isEmpty) {
     // debugPrint('LineID is null, liveAllNodeModel/busBarStatusModels or viewPageData is empty for lineID: $lineId');
      return false;
    }

    // Find the line with the given lineId
    Line? targetLine;
    for (var item in viewPageData) {
      if (item.lines != null) {
        targetLine = item.lines!.firstWhere(
              (line) => line.lineId == lineId,
          orElse: () => Line(
            lineId: '',
            points: [],
            startItemId: 0,
            endItemId: 0,
            startEdgeIndex: 0,
            endEdgeIndex: 0,
          ),
        );
        if (targetLine.lineId.isNotEmpty) break;
      }
    }

    if (targetLine == null || targetLine.lineId.isEmpty) {
     // debugPrint('Line not found for lineID: $lineId');
      return false;
    }

    // Find the start and end nodes of the line
    var startNode = firstWhereOrNull(viewPageData, (node) => node.id == targetLine!.startItemId);
    var endNode = firstWhereOrNull(viewPageData, (node) => node.id == targetLine!.endItemId);

    if (startNode == null && endNode == null) {
     // debugPrint('Start and end nodes not found for lineID: $lineId');
      return false;
    }

    // Check live node power model for sensorStatus
    for (var liveNode in liveAllNodeModel) {
      if (liveNode.sensorStatus != true) continue;

      // Match liveNode.node with startNode.nodeId or endNode.nodeId (or nodeName)
      bool matchesStart = startNode != null &&
          (startNode.nodeId?.contains(liveNode.node ?? '') == true || startNode.nodeName == liveNode.node);
      bool matchesEnd = endNode != null &&
          (endNode.nodeId?.contains(liveNode.node ?? '') == true || endNode.nodeName == liveNode.node);

      if (matchesStart || matchesEnd) {
        debugPrint('--->>>live node lineID: $lineId (sensorStatus: true: ${liveNode.node})');
        return true;
      }
    }

    // Check busbar status model for sensorStatus
    for (var busBarStatus in busBarStatusModels) {
      if (busBarStatus.connectedWithDetails == null) continue;

      for (var connectedDetail in busBarStatus.connectedWithDetails!) {
        if (connectedDetail.sensorStatus != true || connectedDetail.lineID != lineId) continue;

        // Match busbar connected details with the lineId
        debugPrint('--->>busbar connected lineID: $lineId--->> (sensorStatus: true: ${connectedDetail.nodeName})');
        return true;
      }
    }

  //  debugPrint('Animation disabled for lineID: $lineId (no active sensorStatus for associated nodes or busbar details)');
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
   // debugPrint('Canvas size: ${size.width}x${size.height}');
    if (viewPageData.isEmpty) {
     // debugPrint('viewPageData is empty');
      return;
    }

    for (var item in viewPageData) {
      if (item.lines == null || item.lines!.isEmpty) {
      //  debugPrint('No lines in item');
        continue;
      }

      for (var line in item.lines!) {
        if (line.points.isEmpty) {
         // debugPrint('Line has no points');
          continue;
        }

        try {
          var startItem = firstWhereOrNull(viewPageData, (element) => element.id == line.startItemId);
          var endItem = firstWhereOrNull(viewPageData, (element) => element.id == line.endItemId);
          if (startItem == null || endItem == null) {
          //  debugPrint('Start or end item not found for lineID: ${line.lineId}');
            continue;
          }

          Path path = createLinePath(line);
          Color lineColor = hexToColor(line.lineColor);

          // Always draw the static line
          drawStaticLine(canvas, path, lineColor);

          // Draw bubble animation if applicable
          if (!debugBaseLineOnly && shouldAnimateLine(line.lineId)) {
            drawAnimatedLine(canvas, path, lineColor, false); // No reverse direction
          }
        } catch (e) {
          debugPrint('Error drawing line: $e');
        }
      }
    }
  }

  Path createLinePath(Line line) {
    Path path = Path();
    try {
      var firstPoint = Offset(line.points.first.x - minX, line.points.first.y - minY);
    //  debugPrint('First point: (${firstPoint.dx}, ${firstPoint.dy})');
      path.moveTo(firstPoint.dx, firstPoint.dy);
      for (int i = 1; i < line.points.length; i++) {
        var point = line.points[i];
        path.lineTo(point.x - minX, point.y - minY);
      }
    } catch (e) {
      debugPrint('Error creating path: $e');
    }
    return path;
  }

  void drawStaticLine(Canvas canvas, Path path, Color lineColor) {
    final effectiveColor = lineColor.alpha == 0 ? lineColor.withOpacity(1.0) : lineColor;

    final linePaint = Paint()
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke
      ..color = effectiveColor
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round;

   // debugPrint('Drawing static line with color: ${effectiveColor.toString()}');
    canvas.drawPath(path, linePaint);
  }

  void drawAnimatedLine(Canvas canvas, Path path, Color lineColor, bool reverseDirection) {
   // debugPrint('Drawing animated line with reverse: $reverseDirection');
    PathMetrics pathMetrics = path.computeMetrics();
    for (var metric in pathMetrics) {
      double length = metric.length;
      if (length == 0) {
       // debugPrint('Path length is zero');
        continue;
      }

      double animatedValue = reverseDirection ? 1.0 - animation.value : animation.value;
      const int numBubblesPerLine = 5;
      final random = math.Random(path.hashCode);
      final bubblePaint = Paint()
        ..color = Colors.white.withOpacity(0.7)
        ..style = PaintingStyle.fill;

      const double lineWidth = 10.0;
      final leftLineOffset = -lineWidth * 0.25;
      final rightLineOffset = lineWidth * 0.25;

      for (int i = 0; i < numBubblesPerLine; i++) {
        double leftBubbleOffset = ((animatedValue + (i / numBubblesPerLine)) % 1.0) * length;
        Tangent? leftTangent = metric.getTangentForOffset(leftBubbleOffset);
        if (leftTangent != null) {
          double bubbleSize = lineWidth * (0.15 + random.nextDouble() * 0.1);
          Offset perpendicular = Offset(-leftTangent.vector.dy, leftTangent.vector.dx).normalized();
          Offset bubblePosition = leftTangent.position + perpendicular * leftLineOffset;
          canvas.drawCircle(bubblePosition, bubbleSize, bubblePaint);
        }

        double rightBubbleOffset = ((animatedValue + (i / numBubblesPerLine) + 0.3) % 1.0) * length;
        Tangent? rightTangent = metric.getTangentForOffset(rightBubbleOffset);
        if (rightTangent != null) {
          double bubbleSize = lineWidth * (0.15 + random.nextDouble() * 0.1);
          Offset perpendicular = Offset(-rightTangent.vector.dy, rightTangent.vector.dx).normalized();
          Offset bubblePosition = rightTangent.position + perpendicular * rightLineOffset;
          canvas.drawCircle(bubblePosition, bubbleSize, bubblePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(WaterLongSLDAnimatedLinePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.viewPageData != viewPageData ||
        oldDelegate.liveAllNodeModel != liveAllNodeModel ||
        oldDelegate.busBarStatusModels != busBarStatusModels || // Added comparison
        oldDelegate.minX != minX ||
        oldDelegate.minY != minY ||
        oldDelegate.debugBaseLineOnly != debugBaseLineOnly;
  }
}

T? firstWhereOrNull<T>(List<T> list, bool Function(T) test) {
  for (var item in list) {
    if (test(item)) return item;
  }
  return null;
}

extension OffsetExtension on Offset {
  Offset normalized() {
    final double magnitude = distance;
    if (magnitude == 0) return Offset.zero;
    return this / magnitude;
    }
}