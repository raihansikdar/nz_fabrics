// import 'dart:math' as math;
// import 'dart:ui' as ui;
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/model/electricity_short_view_page_model.dart';
//
// import '../screens/electricity_short_sld.dart';
//
// class ElectricityShortSLDAnimatedLinePainter extends CustomPainter {
//   final List<ElectricityShortViewPageModel> viewPageData;
//   final Map<dynamic, LiveDataModel> liveData;
//   final double minX;
//   final double minY;
//   final Animation<double> animation;
//
//   ElectricityShortSLDAnimatedLinePainter({
//     required this.viewPageData,
//     required this.liveData,
//     required this.minX,
//     required this.minY,
//     required this.animation,
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
//           bool startSensorStatus = liveData[startItem.id]?.sensorStatus ?? false;
//           bool endSensorStatus = liveData[endItem.id]?.sensorStatus ?? false;
//           bool shouldSkipAnimation = checkIfShouldSkipAnimation(startItem, endItem, line);
//           bool reverseDirection = checkReverseDirection(startItem, endItem, line, liveData);
//
//           if (line.points.isNotEmpty) {
//             Path path = createLinePath(line);
//             drawAnimatedLine(canvas, path, line);
//
//             if (!shouldSkipAnimation && (startSensorStatus || endSensorStatus)) {
//               double animatedValue = reverseDirection ? 1.0 - animation.value : animation.value;
//               drawVerticalAnimatedPointer(
//                   canvas,
//                   path,
//                   animatedValue,
//                   line.lineColor,
//                   reverseDirection,
//                   line.points,
//                   startItem,
//                   endItem
//               );
//             }
//           }
//         }
//       }
//     }
//   }
//
//   Path createLinePath(Line line) {
//     Path path = Path();
//     var firstPoint = Offset(line.points.first.x - minX, line.points.first.y - minY);
//     path.moveTo(firstPoint.dx, firstPoint.dy);
//
//     for (int i = 1; i < line.points.length; i++) {
//       var point = line.points[i];
//       path.lineTo(point.x - minX, point.y - minY);
//     }
//     return path;
//   }
//
//   void drawAnimatedLine(Canvas canvas, Path path, Line line) {
//     final linePaint = Paint()
//       ..strokeWidth = 3
//       ..style = PaintingStyle.stroke
//       ..color = line.lineColor != null ? hexToColor(line.lineColor!) : Colors.black
//       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
//
//     canvas.drawPath(path, linePaint);
//   }
// /*
//   void drawVerticalAnimatedPointer(
//       Canvas canvas,
//       Path path,
//       double animatedValue,
//       String? lineColor,
//       bool reverseDirection,
//       List<Point> points,
//       ViewPageModel startItem,
//       ViewPageModel endItem,
//       ) {
//     PathMetrics pathMetrics = path.computeMetrics();
//     PathMetric pathMetric = pathMetrics.first;
//     double length = pathMetric.length;
//     Tangent? tangent = pathMetric.getTangentForOffset(length * animatedValue);
//
//     if (tangent != null) {
//       canvas.save();
//       canvas.translate(tangent.position.dx, tangent.position.dy);
//
//       // Calculate base angle from the tangent
//       double angle = tangent.angle;
//
//
//       // Calculate base angle from the tangent
//       double finalAngle = tangent.angle;
//
//       // Detect horizontal movement
//       if (tangent.vector.dy.abs() < tangent.vector.dx.abs()) {
//         // Horizontal movement: Adjust for left or right direction
//         if (tangent.vector.dx < 0) {
//           finalAngle += math.pi; // Flip arrow for left movement
//          // finalAngle = 90;
//          // finalAngle = -math.pi;
//         }
//
//         if (tangent.vector.dx > 0) {
//             finalAngle += math.pi;
//          // finalAngle = math.pi;
//         }
//       }
//       // Detect vertical movement
//       else {
//         // Vertical movement: Adjust for upward or downward direction
//         if ( tangent.vector.dy > 0) {
//           finalAngle += math.pi; // Flip arrow for downward movement
//         }
//
//
//       }
//
//       // Adjust for reverse direction
//       if (reverseDirection) {
//         finalAngle += math.pi;
//       }
//
//       // Add vertical adjustment
//       double verticalDirection = getVerticalDirection(points, animatedValue);
//       finalAngle += verticalDirection;
//
//       // Normalize the angle to avoid overflow
//       finalAngle = finalAngle % (2 * math.pi);
//
//       // Apply the rotation
//       canvas.rotate(finalAngle);
//
//
//
//       // Create arrow path
//       final arrowPath = Path();
//       const arrowBaseWidth = 10.0;
//       const arrowHeight = 15.0;
//
//       // Draw arrow
//       arrowPath.moveTo(0, -arrowHeight/2);
//       arrowPath.lineTo(-arrowBaseWidth/2, arrowHeight/2);
//       arrowPath.lineTo(arrowBaseWidth/2, arrowHeight/2);
//       arrowPath.close();
//
//       // Add notch
//       const notchSize = 3.0;
//       arrowPath.moveTo(0, arrowHeight/2);
//       arrowPath.lineTo(-notchSize, arrowHeight/2 + notchSize);
//       arrowPath.lineTo(notchSize, arrowHeight/2 + notchSize);
//       arrowPath.close();
//
//       // Create gradient
//       const gradientRect = Rect.fromLTWH(
//           -arrowBaseWidth/2,
//           -arrowHeight/2,
//           arrowBaseWidth,
//           arrowHeight
//       );
//
//       final gradient = LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [
//           (lineColor != null ? hexToColor(lineColor) : Colors.white).withOpacity(0.9),
//           (lineColor != null ? hexToColor(lineColor) : Colors.grey).withOpacity(0.8),
//         ],
//       );
//
//       final arrowFillPaint = Paint()
//         ..shader = gradient.createShader(gradientRect)
//         ..style = PaintingStyle.fill;
//
//       final arrowGlowPaint = Paint()
//         ..color = (lineColor != null ? hexToColor(lineColor) : Colors.white).withOpacity(0.3)
//         ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
//
//       final pulseScale = 1.0 + 0.1 * math.sin(animation.value * 2 * math.pi);
//       canvas.scale(pulseScale, pulseScale);
//
//       canvas.drawPath(arrowPath, arrowGlowPaint);
//       canvas.drawPath(arrowPath, arrowFillPaint);
//
//       canvas.restore();
//     }
//   }*/
//
//   void drawVerticalAnimatedPointer(
//       Canvas canvas,
//       Path path,
//       double animatedValue,
//       String? lineColor,
//       bool reverseDirection,
//       List<Point> points,
//       ElectricityShortViewPageModel startItem,
//       ElectricityShortViewPageModel endItem,
//       ) {
//     PathMetrics pathMetrics = path.computeMetrics();
//     PathMetric pathMetric = pathMetrics.first;
//     double length = pathMetric.length;
//     Tangent? tangent = pathMetric.getTangentForOffset(length * animatedValue);
//     if (tangent != null) {
//       canvas.save();
//       canvas.translate(tangent.position.dx, tangent.position.dy);
//
//       double finalAngle;
//       bool isVertical = tangent.vector.dy.abs() > tangent.vector.dx.abs();
//
//       if (isVertical) {
//         if (tangent.vector.dy < 0) {
//           finalAngle = -math.pi/2;
//         } else {
//           finalAngle = math.pi/2;
//         }
//       } else {
//         if (tangent.vector.dx < 0) {
//           finalAngle = math.pi;
//         } else {
//           finalAngle = 0;
//         }
//       }
//
//       if (reverseDirection) {
//         finalAngle += math.pi;
//       }
//
//       canvas.rotate(finalAngle);
//
//       final arrowPath = Path();
//       const arrowLength = 20.0;
//       const arrowWidth = 16.0;
//
//
//       arrowPath.moveTo(0, 0);
//       arrowPath.lineTo(-arrowLength, -arrowWidth/2);
//       arrowPath.lineTo(-arrowLength, arrowWidth/2);
//       arrowPath.close();
//
//
//       Color arrowColor = (lineColor != null ? hexToColor(lineColor) : Colors.purple);
//
//       final arrowPaint = Paint()
//         ..color = arrowColor
//         ..style = PaintingStyle.fill;
//
//       final arrowOutlinePaint = Paint()
//         ..color =  hexToColor(lineColor ?? '#000000')
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 1.5;
//
//
//       canvas.drawPath(arrowPath, arrowPaint);
//       canvas.drawPath(arrowPath, arrowOutlinePaint);
//
//
//       if (isVertical) {
//         final debugPaint = Paint()
//           ..color = Colors.white.withOpacity(0.5)
//           ..strokeWidth = 1.0
//           ..style = PaintingStyle.stroke;
//
//         canvas.drawLine(const Offset(-20, 0), const Offset(-arrowLength, 0), debugPaint);
//       }
//
//       canvas.restore();
//     }
//   }
//
//   double getVerticalDirection(List<Point> points, double animatedValue) {
//     if (points.length < 2) return 0;
//
//     int currentIndex = (animatedValue * (points.length - 1)).floor();
//     currentIndex = currentIndex.clamp(0, points.length - 2);
//
//     Point current = points[currentIndex];
//     Point next = points[currentIndex + 1];
//
//     double dy = next.y - current.y;
//     double dx = next.x - current.x;
//
//     return math.atan2(dy, dx);
//   }
//
//
//   bool checkIfShouldSkipAnimation(ElectricityShortViewPageModel startItem, ElectricityShortViewPageModel endItem, Line line) {
//     return (startItem.sourceType == "BusCoupler" &&
//         (line.startEdgeIndex == 2 || line.endEdgeIndex == 2)) ||
//         (endItem.sourceType == "BusCoupler" &&
//             (line.startEdgeIndex == 2 || line.endEdgeIndex == 2)) ||
//         (startItem.sourceType == "Loop" &&
//             !(line.startEdgeIndex == 2 || line.endEdgeIndex == 2 ||
//                 line.startEdgeIndex == 0 || line.endEdgeIndex == 0)) ||
//         (endItem.sourceType == "Loop" &&
//             !(line.startEdgeIndex == 2 || line.endEdgeIndex == 2 ||
//                 line.startEdgeIndex == 0 || line.endEdgeIndex == 0));
//   }
//
//   bool checkReverseDirection(ElectricityShortViewPageModel startItem, ElectricityShortViewPageModel endItem, Line line,
//       Map<dynamic, LiveDataModel> liveData) {
//     if (startItem.sourceType == "BusCoupler" || endItem.sourceType == "BusCoupler" ||
//         startItem.sourceType == "Loop" || endItem.sourceType == "Loop") {
//       double? power = liveData[startItem.id]?.power ?? liveData[endItem.id]?.power;
//
//
//       if (power != null) {
//         if (power < 0) {
//           return true;
//         }
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
//     }
//
//   @override
//   bool shouldRepaint(ElectricityShortSLDAnimatedLinePainter oldDelegate) {
//     return oldDelegate.animation != animation;
//     }
// }



import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/busbar_status_info_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/model/electricity_short_live_all_node_power_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/model/electricity_short_view_page_model.dart';
import '../screens/electricity_short_sld.dart';






class ElectricityShortSLDAnimatedLinePainter extends CustomPainter {
  final List<ElectricityShortViewPageModel> viewPageData;
  final List<ElectricityShortLiveAllNodePowerModel> liveAllNodeModel;
  final List<BusBarStatusInfoModel> busBarStatusModels;
  final double minX;
  final double minY;
  final Animation<double> animation;
  final bool debugBaseLineOnly;

  ElectricityShortSLDAnimatedLinePainter({
    required this.viewPageData,
    required this.liveAllNodeModel,
    required this.busBarStatusModels,
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
    if (lineId == null || lineId.isEmpty || viewPageData.isEmpty) {
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
      return false;
    }

    // Get the startNode only
    var startNode = firstWhereOrNull(viewPageData, (node) => node.id == targetLine!.startItemId);
    if (startNode == null) return false;

    // Check live node power model for sensorStatus == true
    for (var liveNode in liveAllNodeModel) {
      if (liveNode.sensorStatus == true &&
          (startNode.nodeId?.contains(liveNode.node ?? '') == true ||
              startNode.nodeName == liveNode.node)) {
        return true;
      }
    }

    // Check busbar connections (for this line) where startNode is involved
    for (var busBarStatus in busBarStatusModels) {
      if (busBarStatus.connectedWithDetails == null) continue;

      for (var connectedDetail in busBarStatus.connectedWithDetails!) {
        if (connectedDetail.lineID == lineId &&
            connectedDetail.sensorStatus == true &&
            (startNode.nodeId?.contains(connectedDetail.nodeName ?? '') == true ||
                startNode.nodeName == connectedDetail.nodeName)) {
          return true;
        }
      }
    }

    return false;
  }


  @override
  void paint(Canvas canvas, Size size) {
    if (viewPageData.isEmpty) {
      return;
    }

    for (var item in viewPageData) {
      if (item.lines == null || item.lines!.isEmpty) {
        continue;
      }

      for (var line in item.lines!) {
        if (line.points.isEmpty) {
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

          // Draw pointer animation if applicable
          if (!debugBaseLineOnly && shouldAnimateLine(line.lineId)) {
            // drawAnimatedLine(canvas, path, lineColor, line.points);
            drawAnimatedPointer(canvas, path, animation.value, lineColor, line.points);
          }
        } catch (e) {
         // debugPrint('Error drawing line: $e');
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
      //debugPrint('Error creating path: $e');
    }
    return path;
  }

  // void drawStaticLine(Canvas canvas, Path path, Color lineColor) {
  //   final effectiveColor = lineColor.alpha == 0 ? lineColor.withOpacity(1.0) : lineColor;
  //
  //   final linePaint = Paint()
  //     ..strokeWidth = 10.0
  //     ..style = PaintingStyle.stroke
  //     ..color = effectiveColor
  //     ..strokeCap = StrokeCap.butt
  //     ..strokeJoin = StrokeJoin.round;
  //
  //   // debugPrint('Drawing static line with color: ${effectiveColor.toString()}');
  //   canvas.drawPath(path, linePaint);
  // }



  void drawStaticLine(Canvas canvas, Path path, Color lineColor) {
    // Ensure the color has proper opacity - don't make it transparent
    final effectiveColor = lineColor.alpha == 0 ? lineColor.withOpacity(1.0) : lineColor;

    final linePaint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..color = effectiveColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

   // debugPrint('Drawing static line with color: ${effectiveColor.toString()}');
    canvas.drawPath(path, linePaint);
  }



  void drawAnimatedPointer(
      Canvas canvas,
      Path path,
      double animatedValue,
      Color lineColor,
      List<Point> points,
      ) {
   // debugPrint('Animation value: $animatedValue');
    PathMetrics pathMetrics = path.computeMetrics();
    if (!pathMetrics.iterator.moveNext()) {
     // debugPrint('No valid path metrics');
      return;
    }

    PathMetric pathMetric = pathMetrics.iterator.current;
    double length = pathMetric.length;
    if (length == 0) {
     // debugPrint('Path length is zero');
      return;
    }

    double offset = length * animatedValue;
    Tangent? tangent = pathMetric.getTangentForOffset(offset);
    if (tangent == null) {
     // debugPrint('No tangent found for offset: $offset');
      return;
    }

    canvas.save();
    canvas.translate(tangent.position.dx, tangent.position.dy);

    double finalAngle;
    bool isVertical = tangent.vector.dy.abs() > tangent.vector.dx.abs();
    if (isVertical) {
      finalAngle = tangent.vector.dy < 0 ? -math.pi / 2 : math.pi / 2;
    } else {
      finalAngle = tangent.vector.dx < 0 ? math.pi : 0;
    }

    canvas.rotate(finalAngle);

    final arrowPath = Path();
    const arrowLength = 20.0;
    const arrowWidth = 16.0;
    arrowPath.moveTo(0, 0);
    arrowPath.lineTo(-arrowLength, -arrowWidth / 2);
    arrowPath.lineTo(-arrowLength, arrowWidth / 2);
    arrowPath.close();

    final arrowPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final arrowOutlinePaint = Paint()
      ..color = lineColor.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(arrowPath, arrowPaint);
    canvas.drawPath(arrowPath, arrowOutlinePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(ElectricityShortSLDAnimatedLinePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.viewPageData != viewPageData ||
        oldDelegate.liveAllNodeModel != liveAllNodeModel ||
        oldDelegate.busBarStatusModels != busBarStatusModels ||
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