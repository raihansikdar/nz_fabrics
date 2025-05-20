// import 'dart:math' as math;
// import 'dart:ui' as ui;
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/busbar_status_info_model.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/electricity_long_view_page_model.dart';
//
// class ElectricityLongSLDAnimatedLinePainter extends CustomPainter {
//   final List<ElectricityLongViewPageModel> viewPageData;
//   final List<ConnectedWithDetails> connectedDetails;
//   final double minX;
//   final double minY;
//   final Animation<double> animation;
//
//   ElectricityLongSLDAnimatedLinePainter({
//     required this.viewPageData,
//     required this.connectedDetails,
//     required this.minX,
//     required this.minY,
//     required this.animation,
//   }) : super(repaint: animation);
//
//   Color hexToColor(String hex) {
//     hex = hex.isEmpty ? '#000000' : hex.replaceAll('#', '');
//     try {
//       return Color(int.parse('0xFF$hex'));
//     } catch (e) {
//       return Colors.black;
//     }
//   }
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     for (var item in viewPageData) {
//       if (item.lines == null) continue;
//
//       for (var line in item.lines) {
//         var startItem = firstWhereOrNull(viewPageData, (element) => element.id == line.startItemId);
//         var endItem = firstWhereOrNull(viewPageData, (element) => element.id == line.endItemId);
//         if (startItem == null || endItem == null) {
//           debugPrint('Skipping line: startItem or endItem is null');
//           continue;
//         }
//
//         bool startSensorStatus = getSensorStatus(startItem.nodeName);
//         bool endSensorStatus = getSensorStatus(endItem.nodeName);
//         bool shouldSkipAnimation = checkIfShouldSkipAnimation(startItem, endItem, line);
//         bool reverseDirection = checkReverseDirection(startItem, endItem, line);
//
//         if (line.points.isNotEmpty) {
//           Path path = createLinePath(line);
//           drawAnimatedLine(canvas, path, line);
//
//           // Only show animation if sensorStatus is explicitly true for start or end
//           if (!shouldSkipAnimation && (startSensorStatus == true || endSensorStatus == true)) {
//             double animatedValue = reverseDirection ? 1.0 - animation.value : animation.value;
//             drawVerticalAnimatedPointer(
//               canvas,
//               path,
//               animatedValue,
//               line.lineColor,
//               reverseDirection,
//               line.points,
//               startItem,
//               endItem,
//             );
//           } else {
//             //debugPrint('Skipping animation ${startItem.nodeName} -------->> ${endItem.nodeName}: endSensor=$endSensorStatus');
//           }
//         }
//       }
//     }
//   }
//
//   bool getSensorStatus(String? nodeName) {
//     if (nodeName == null) {
//       debugPrint('NodeName is null');
//       return false;
//     }
//     var detail = connectedDetails.firstWhere(
//           (detail) => detail.nodeName == nodeName && detail.sensorStatus != null,
//       orElse: () => ConnectedWithDetails(sensorStatus: false),
//     );
//     bool sensorStatus = detail.sensorStatus ?? false;
//     if (sensorStatus == false || detail.sensorStatus == null) {
//       debugPrint('---->>NodeName: $nodeName, SensorStatus: ${detail.sensorStatus}');
//     }
//     return sensorStatus;
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
//
//   void drawVerticalAnimatedPointer(
//       Canvas canvas,
//       Path path,
//       double animatedValue,
//       String? lineColor,
//       bool reverseDirection,
//       List<Point> points,
//       ElectricityLongViewPageModel startItem,
//       ElectricityLongViewPageModel endItem,
//       ) {
//     PathMetrics pathMetrics = path.computeMetrics();
//     PathMetric pathMetric = pathMetrics.first;
//     double length = pathMetric.length;
//     Tangent? tangent = pathMetric.getTangentForOffset(length * animatedValue);
//     if (tangent == null) {
//       debugPrint('No tangent found for animated pointer');
//       return;
//     }
//
//     canvas.save();
//     canvas.translate(tangent.position.dx, tangent.position.dy);
//
//     double finalAngle;
//     bool isVertical = tangent.vector.dy.abs() > tangent.vector.dx.abs();
//
//     if (isVertical) {
//       finalAngle = tangent.vector.dy < 0 ? -math.pi / 2 : math.pi / 2;
//     } else {
//       finalAngle = tangent.vector.dx < 0 ? math.pi : 0;
//     }
//
//     if (reverseDirection) {
//       finalAngle += math.pi;
//     }
//
//     canvas.rotate(finalAngle);
//
//     final arrowPath = Path();
//     const arrowLength = 20.0;
//     const arrowWidth = 16.0;
//
//     arrowPath.moveTo(0, 0);
//     arrowPath.lineTo(-arrowLength, -arrowWidth / 2);
//     arrowPath.lineTo(-arrowLength, arrowWidth / 2);
//     arrowPath.close();
//
//     Color arrowColor = lineColor != null ? hexToColor(lineColor) : Colors.purple;
//
//     final arrowPaint = Paint()
//       ..color = arrowColor
//       ..style = PaintingStyle.fill;
//
//     final arrowOutlinePaint = Paint()
//       ..color = hexToColor(lineColor ?? '#000000')
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;
//
//     canvas.drawPath(arrowPath, arrowPaint);
//     canvas.drawPath(arrowPath, arrowOutlinePaint);
//
//     canvas.restore();
//   }
//
//   bool checkIfShouldSkipAnimation(ElectricityLongViewPageModel startItem, ElectricityLongViewPageModel endItem, Line line) {
//     bool skip = (startItem.sourceType == "BusCoupler" &&
//         (line.startEdgeIndex == 2 || line.endEdgeIndex == 2)) ||
//         (endItem.sourceType == "BusCoupler" &&
//             (line.startEdgeIndex == 2 || line.endEdgeIndex == 2)) ||
//         (startItem.sourceType == "Loop" &&
//             !(line.startEdgeIndex == 2 || line.endEdgeIndex == 2 || line.startEdgeIndex == 0 || line.endEdgeIndex == 0)) ||
//         (endItem.sourceType == "Loop" &&
//             !(line.startEdgeIndex == 2 || line.endEdgeIndex == 2 || line.startEdgeIndex == 0 || line.endEdgeIndex == 0));
//
//     return skip;
//   }
//
//   bool checkReverseDirection(ElectricityLongViewPageModel startItem, ElectricityLongViewPageModel endItem, Line line) {
//     const List<String> reverseNodes = ["BBT 02", "BBT 04", "BBT 07", "BBT 08"];
//     const List<String> ltBusBars = ["LT-01 A", "LT-01 B", "LT-02 A", "LT-02 B"];
//
//     bool isStartNodeReverse = reverseNodes.contains(startItem.nodeName);
//     bool isEndNodeReverse = reverseNodes.contains(endItem.nodeName);
//     bool isStartBusBar = ltBusBars.contains(startItem.nodeName);
//     bool isEndBusBar = ltBusBars.contains(endItem.nodeName);
//
//     bool startSensorStatus = getSensorStatus(startItem.nodeName);
//     bool endSensorStatus = getSensorStatus(endItem.nodeName);
//
//     if ((isStartNodeReverse && isEndBusBar && startSensorStatus == true) ||
//         (isEndNodeReverse && isStartBusBar && endSensorStatus == true)) {
//       return true;
//     }
//
//     return false;
//   }
//
//   @override
//   bool shouldRepaint(ElectricityLongSLDAnimatedLinePainter oldDelegate) {
//     return oldDelegate.animation != animation ||
//         oldDelegate.connectedDetails != connectedDetails ||
//         oldDelegate.viewPageData != viewPageData;
//   }
//
//   T? firstWhereOrNull<T>(List<T> list, bool Function(T) test) {
//     for (var item in list) {
//       if (test(item)) return item;
//     }
//     return null;
//   }
// }






// import 'dart:math' as math;
// import 'dart:ui' as ui;
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/electricity_long_view_page_model.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/busbar_status_info_model.dart';
//
// class ElectricityLongSLDAnimatedLinePainter extends CustomPainter {
//   final List<ElectricityLongViewPageModel> viewPageData;
//   final List<ElectricityLongBusBarStatusInfoModel> sensorStatusData;
//   final double minX;
//   final double minY;
//   final Animation<double> animation;
//
//   ElectricityLongSLDAnimatedLinePainter({
//     required this.viewPageData,
//     required this.sensorStatusData,
//     required this.minX,
//     required this.minY,
//     required this.animation,
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
//   Color getLineColor(Line line) {
//     if (line.lineId == null) {
//       debugPrint('lineId is null, using line.lineColor');
//       return hexToColor(line.lineColor);
//     }
//
//     for (var statusInfo in sensorStatusData) {
//       if (statusInfo.connectedWithDetails != null) {
//         for (var connectedDetail in statusInfo.connectedWithDetails!) {
//           if (connectedDetail.lineID == line.lineId && connectedDetail.color != null) {
//             debugPrint('Using color from connectedWithDetails for lineID: ${line.lineId}');
//             return hexToColor(connectedDetail.color);
//           }
//         }
//       }
//     }
//     debugPrint('Using line.lineColor for lineID: ${line.lineId}');
//     return hexToColor(line.lineColor);
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
//           Path path = createLinePath(line);
//           Color lineColor = getLineColor(line);
//
//           drawStaticLine(canvas, path, lineColor);
//
//           if (shouldAnimateLine(line.lineId)) {
//             drawAnimatedPointer(canvas, path, animation.value, lineColor, line.points);
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
//     final linePaint = Paint()
//       ..strokeWidth = 3
//       ..style = PaintingStyle.stroke
//       ..color = lineColor
//       ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
//
//     canvas.drawPath(path, linePaint);
//   }
//
//   void drawAnimatedPointer(
//       Canvas canvas,
//       Path path,
//       double animatedValue,
//       Color lineColor,
//       List<Point> points,
//       ) {
//     debugPrint('Animation value: $animatedValue');
//     PathMetrics pathMetrics = path.computeMetrics();
//     if (!pathMetrics.iterator.moveNext()) {
//       debugPrint('No valid path metrics');
//       return;
//     }
//
//     PathMetric pathMetric = pathMetrics.iterator.current;
//     double length = pathMetric.length;
//     if (length == 0) {
//       debugPrint('Path length is zero');
//       return;
//     }
//
//     double offset = length * animatedValue;
//     Tangent? tangent = pathMetric.getTangentForOffset(offset);
//     if (tangent == null) {
//       debugPrint('No tangent found for offset: $offset');
//       return;
//     }
//
//     canvas.save();
//     canvas.translate(tangent.position.dx, tangent.position.dy);
//
//     double finalAngle;
//     bool isVertical = tangent.vector.dy.abs() > tangent.vector.dx.abs();
//     if (isVertical) {
//       finalAngle = tangent.vector.dy < 0 ? -math.pi / 2 : math.pi / 2;
//     } else {
//       finalAngle = tangent.vector.dx < 0 ? math.pi : 0;
//     }
//
//     canvas.rotate(finalAngle);
//
//     final arrowPath = Path();
//     const arrowLength = 20.0;
//     const arrowWidth = 16.0;
//     arrowPath.moveTo(0, 0);
//     arrowPath.lineTo(-arrowLength, -arrowWidth / 2);
//     arrowPath.lineTo(-arrowLength, arrowWidth / 2);
//     arrowPath.close();
//
//     final arrowPaint = Paint()
//       ..color = lineColor
//       ..style = PaintingStyle.fill;
//
//     final arrowOutlinePaint = Paint()
//       ..color = lineColor.withOpacity(0.8)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;
//
//     canvas.drawPath(arrowPath, arrowPaint);
//     canvas.drawPath(arrowPath, arrowOutlinePaint);
//
//     canvas.restore();
//   }
//
//   @override
//   bool shouldRepaint(ElectricityLongSLDAnimatedLinePainter oldDelegate) {
//     return oldDelegate.animation != animation ||
//         oldDelegate.viewPageData != viewPageData ||
//         oldDelegate.sensorStatusData != sensorStatusData;
//   }
// }


import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/electricity_long_view_page_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/busbar_status_info_model.dart';

class ElectricityLongSLDAnimatedLinePainter extends CustomPainter {
  final List<ElectricityLongViewPageModel> viewPageData;
  final List<BusBarStatusInfoModel> sensorStatusData;
  final double minX;
  final double minY;
  final Animation<double> animation;

  ElectricityLongSLDAnimatedLinePainter({
    required this.viewPageData,
    required this.sensorStatusData,
    required this.minX,
    required this.minY,
    required this.animation,
  }) : super(repaint: animation);

  Color hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) {
      debugPrint('Hex color is null or empty, using black');
      return Colors.black;
    }
    hex = hex.replaceAll('#', '');
    try {
      return Color(int.parse('0xFF$hex'));
    } catch (e) {
      debugPrint('Error parsing hex color: $hex, error: $e');
      return Colors.black;
    }
  }

  bool shouldAnimateLine(String? lineId) {
    if (lineId == null || sensorStatusData.isEmpty) {
      debugPrint('LineID is null or sensorStatusData is empty for lineID: $lineId');
      return false;
    }

    for (var statusInfo in sensorStatusData) {
      if (statusInfo.connectedWithDetails != null) {
        for (var connectedDetail in statusInfo.connectedWithDetails!) {
          if (connectedDetail.lineID == lineId && connectedDetail.sensorStatus == true) {
            debugPrint('Animation enabled for lineID: $lineId (sensorStatus: true)');
            return true;
          }
        }
      }
    }
    debugPrint('Animation disabled for lineID: $lineId (no active sensorStatus)');
    return false;
  }

  Color getLineColor(Line line) {
    // For lines without lineId (usually bus bar connections), always use the original line color
    if (line.lineId == null || line.lineId!.isEmpty) {
      debugPrint('lineId is null/empty, using line.lineColor: ${line.lineColor}');
      return hexToColor(line.lineColor);
    }

    // For lines with lineId, check if there's a dynamic color from sensor data
    for (var statusInfo in sensorStatusData) {
      if (statusInfo.connectedWithDetails != null) {
        for (var connectedDetail in statusInfo.connectedWithDetails!) {
          if (connectedDetail.lineID == line.lineId) {
            // If color is provided and not the default white/light colors, use it
            if (connectedDetail.color != null &&
                connectedDetail.color != "#FBFBFB" &&
                connectedDetail.color!.isNotEmpty) {
              debugPrint('Using dynamic color from connectedWithDetails for lineID: ${line.lineId}, color: ${connectedDetail.color}');
              return hexToColor(connectedDetail.color);
            }
          }
        }
      }
    }

    // Fallback to original line color
    debugPrint('Using fallback line.lineColor for lineID: ${line.lineId}, color: ${line.lineColor}');
    return hexToColor(line.lineColor);
  }

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint('Canvas size: ${size.width}x${size.height}');
    if (viewPageData.isEmpty) {
      debugPrint('viewPageData is empty');
      return;
    }

    for (var item in viewPageData) {
      if (item.lines == null || item.lines!.isEmpty) {
        debugPrint('No lines in item');
        continue;
      }

      for (var line in item.lines!) {
        if (line.points.isEmpty) {
          debugPrint('Line has no points');
          continue;
        }

        try {
          Path path = createLinePath(line);
          Color lineColor = getLineColor(line);

          // Always draw the static line - this ensures bus bar lines are always visible
          drawStaticLine(canvas, path, lineColor);

          // Only add animation for lines that should be animated
          if (shouldAnimateLine(line.lineId)) {
            drawAnimatedPointer(canvas, path, animation.value, lineColor, line.points);
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
      debugPrint('First point: (${firstPoint.dx}, ${firstPoint.dy})');
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
    // Ensure the color has proper opacity - don't make it transparent
    final effectiveColor = lineColor.alpha == 0 ? lineColor.withOpacity(1.0) : lineColor;

    final linePaint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..color = effectiveColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    debugPrint('Drawing static line with color: ${effectiveColor.toString()}');
    canvas.drawPath(path, linePaint);
  }

  void drawAnimatedPointer(
      Canvas canvas,
      Path path,
      double animatedValue,
      Color lineColor,
      List<Point> points,
      ) {
    debugPrint('Animation value: $animatedValue');
    PathMetrics pathMetrics = path.computeMetrics();
    if (!pathMetrics.iterator.moveNext()) {
      debugPrint('No valid path metrics');
      return;
    }

    PathMetric pathMetric = pathMetrics.iterator.current;
    double length = pathMetric.length;
    if (length == 0) {
      debugPrint('Path length is zero');
      return;
    }

    double offset = length * animatedValue;
    Tangent? tangent = pathMetric.getTangentForOffset(offset);
    if (tangent == null) {
      debugPrint('No tangent found for offset: $offset');
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
  bool shouldRepaint(ElectricityLongSLDAnimatedLinePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.viewPageData != viewPageData ||
        oldDelegate.sensorStatusData != sensorStatusData ||
        oldDelegate.minX != minX ||
        oldDelegate.minY!=minY;
    }
}




/*import 'dart:math' as math;

class ElectricityLongSLDAnimatedLinePainter extends CustomPainter {
  final List<ElectricityLongViewPageModel> viewPageData;
 // final List<ElectricityLongLiveAllNodePowerModel> liveAllNodeModel;
 // final List<BusBarStatusInfoModel> busBarStatusModels;
  final double minX;
  final double minY;
  final Animation<double> animation;
  final bool debugBaseLineOnly;

  ElectricityLongSLDAnimatedLinePainter({
    required this.viewPageData,
  //  required this.liveAllNodeModel,
   // required this.busBarStatusModels,
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
        debugPrint('--->>>  live node lineID: $lineId (sensorStatus: true: ${liveNode.node})');
        return true;
      }
    }

    // Check busbar status model for sensorStatus
    for (var busBarStatus in busBarStatusModels) {
      if (busBarStatus.connectedWithDetails == null) continue;

      for (var connectedDetail in busBarStatus.connectedWithDetails!) {
        if (connectedDetail.sensorStatus != true || connectedDetail.lineID != lineId) continue;

        // Match busbar connected details with the lineId
        debugPrint('--->>  busbar connected lineID: $lineId--->> (sensorStatus: true: ${connectedDetail.nodeName})');
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

          // Draw pointer animation if applicable
          if (!debugBaseLineOnly && shouldAnimateLine(line.lineId)) {
            drawAnimatedLine(canvas, path, lineColor, line.points);
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

  void drawAnimatedLine(
      Canvas canvas,
      Path path,
      Color lineColor,
      List<Point> points,
      ) {
    // debugPrint('Drawing animated line');
    PathMetrics pathMetrics = path.computeMetrics();
    if (!pathMetrics.iterator.moveNext()) {
      debugPrint('No valid path metrics');
      return;
    }

    PathMetric pathMetric = pathMetrics.iterator.current;
    double length = pathMetric.length;
    if (length == 0) {
      debugPrint('Path length is zero');
      return;
    }

    double offset = length * animation.value;
    Tangent? tangent = pathMetric.getTangentForOffset(offset);
    if (tangent == null) {
      debugPrint('No tangent found for offset: $offset');
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
      ..color = lineColor // Changed to white for the triangle fill
      ..style = PaintingStyle.fill;

    final arrowOutlinePaint = Paint()
      ..color = Colors.black.withOpacity(0.8) // Changed to black with opacity for outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(arrowPath, arrowPaint);
    canvas.drawPath(arrowPath, arrowOutlinePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(ElectricityLongSLDAnimatedLinePainter oldDelegate) {
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
}*/
