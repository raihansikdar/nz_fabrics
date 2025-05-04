// import 'dart:math' as math;
// import 'dart:ui' as ui;
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/model/water_long_sld_view_page_model.dart';
//
// import '../screens/water_long_sld_screen.dart';
//
// class WaterLongSLDAnimatedLinePainter extends CustomPainter {
//   final List<ViewPageModel> viewPageData;
//   final Map<dynamic, LiveDataModel> liveData;
//   final double minX;
//   final double minY;
//   final Animation<double> animation;
//
//   WaterLongSLDAnimatedLinePainter({
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
//   bool checkIfShouldSkipAnimation(ViewPageModel startItem, ViewPageModel endItem, Line line) {
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
//   bool checkReverseDirection(ViewPageModel startItem, ViewPageModel endItem, Line line,
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
//   bool shouldRepaint(WaterLongSLDAnimatedLinePainter oldDelegate) {
//     return oldDelegate.animation != animation;
//     }
// }

/*
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/model/water_long_sld_view_page_model.dart';

class WaterLongSLDAnimatedLinePainter extends CustomPainter {
  final List<ViewPageModel> viewPageData;
  final Map<dynamic, LiveDataModel> liveData;
  final double minX;
  final double minY;
  final Animation<double> animation;

  WaterLongSLDAnimatedLinePainter({
    required this.viewPageData,
    required this.liveData,
    required this.minX,
    required this.minY,
    required this.animation,
  }) : super(repaint: animation);

  Color hexToColor(String hex) {
    return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var item in viewPageData) {
      if (item.lines != null) {
        for (var line in item.lines) {
          var startItem = firstWhereOrNull(viewPageData, (element) => element.id == line.startItemId);
          var endItem = firstWhereOrNull(viewPageData, (element) => element.id == line.endItemId);
          if (startItem == null || endItem == null) continue;

          bool startSensorStatus = liveData[startItem.id]?.sensorStatus ?? false;
          bool endSensorStatus = liveData[endItem.id]?.sensorStatus ?? false;
          bool shouldSkipAnimation = checkIfShouldSkipAnimation(startItem, endItem, line);
          bool reverseDirection = checkReverseDirection(startItem, endItem, line, liveData);

          if (line.points.isNotEmpty) {
            Path path = createLinePath(line);
            drawAnimatedLine(canvas, path, line, reverseDirection);

            if (!shouldSkipAnimation && (startSensorStatus || endSensorStatus)) {
              double animatedValue = reverseDirection ? 1.0 - animation.value : animation.value;
              drawVerticalAnimatedPointer(
                canvas,
                path,
                animatedValue,
                line.lineColor,
                reverseDirection,
                line.points,
                startItem,
                endItem,
              );
            }
          }
        }
      }
    }
  }

  Path createLinePath(Line line) {
    Path path = Path();
    var firstPoint = Offset(line.points.first.x - minX, line.points.first.y - minY);
    path.moveTo(firstPoint.dx, firstPoint.dy);

    for (int i = 1; i < line.points.length; i++) {
      var point = line.points[i];
      path.lineTo(point.x - minX, point.y - minY);
    }
    return path;
  }

  void drawAnimatedLine(Canvas canvas, Path path, Line line, bool reverseDirection) {
    final lineColor = line.lineColor != null ? hexToColor(line.lineColor!) : Colors.blue;
    const double lineWidth = 6.0; // Adjusted for visibility of water effect

    // Draw the base pipe with solid color
    final pipePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, pipePaint);

    // Draw semi-transparent blue liquid layer for flowing effect
    ui.PathMetrics pathMetrics = path.computeMetrics();
    for (var metric in pathMetrics) {
      double length = metric.length;
      double animatedValue = reverseDirection ? 1.0 - animation.value : animation.value;
      double liquidOffset = (animatedValue % 1.0) * length;

      // Extract a segment of the path for the liquid effect
      Path liquidPath = metric.extractPath(
        liquidOffset - length * 0.5, // Start half a length behind
        liquidOffset + length * 0.5, // End half a length ahead
      );

      final liquidPaint = Paint()
        ..color = Colors.blue.withOpacity(0.2) // Match CleanVerticalFlowPainter
        ..style = PaintingStyle.stroke
        ..strokeWidth = lineWidth * 0.8 // Slightly narrower to fit inside pipe
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(liquidPath, liquidPaint);

      // Draw small white bubbles along the path
      const int numBubbles = 8; // Number of bubbles
      final random = math.Random(line.hashCode); // Consistent random seed per line
      final bubblePaint = Paint()
        ..color = Colors.white.withOpacity(0.7) // Match CleanVerticalFlowPainter
        ..style = PaintingStyle.fill;

      for (int i = 0; i < numBubbles; i++) {
        double bubbleOffset = ((animatedValue + (i / numBubbles)) % 1.0) * length;
        ui.Tangent? tangent = metric.getTangentForOffset(bubbleOffset);
        if (tangent != null) {
          double bubbleSize = lineWidth * (0.2 + random.nextDouble() * 0.3);
          // Offset bubbles slightly left and right to simulate two lines
          double offsetX = random.nextBool() ? lineWidth * 0.2 : -lineWidth * 0.2;
          canvas.drawCircle(
            tangent.position + Offset(offsetX, 0),
            bubbleSize,
            bubblePaint,
          );
        }
      }
    }
  }

  void drawVerticalAnimatedPointer(
      Canvas canvas,
      Path path,
      double animatedValue,
      String? lineColor,
      bool reverseDirection,
      List<Point> points,
      ViewPageModel startItem,
      ViewPageModel endItem,
      ) {
    ui.PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.first;
    double length = pathMetric.length;
    Tangent? tangent = pathMetric.getTangentForOffset(length * animatedValue);
    if (tangent != null) {
      canvas.save();
      canvas.translate(tangent.position.dx, tangent.position.dy);

      double finalAngle;
      bool isVertical = tangent.vector.dy.abs() > tangent.vector.dx.abs();

      if (isVertical) {
        finalAngle = tangent.vector.dy < 0 ? -math.pi / 2 : math.pi / 2;
      } else {
        finalAngle = tangent.vector.dx < 0 ? math.pi : 0;
      }

      if (reverseDirection) {
        finalAngle += math.pi;
      }

      canvas.rotate(finalAngle);

      final arrowPath = Path();
      const arrowLength = 20.0;
      const arrowWidth = 16.0;

      arrowPath.moveTo(0, 0);
      arrowPath.lineTo(-arrowLength, -arrowWidth / 2);
      arrowPath.lineTo(-arrowLength, arrowWidth / 2);
      arrowPath.close();

      Color arrowColor = (lineColor != null ? hexToColor(lineColor) : Colors.purple);

      final arrowPaint = Paint()
        ..color = arrowColor
        ..style = PaintingStyle.fill;

      final arrowOutlinePaint = Paint()
        ..color = hexToColor(lineColor ?? '#000000')
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawPath(arrowPath, arrowPaint);
      canvas.drawPath(arrowPath, arrowOutlinePaint);

      canvas.restore();
    }
  }

  bool checkIfShouldSkipAnimation(ViewPageModel startItem, ViewPageModel endItem, Line line) {
    return (startItem.sourceType == "BusCoupler" &&
        (line.startEdgeIndex == 2 || line.endEdgeIndex == 2)) ||
        (endItem.sourceType == "BusCoupler" &&
            (line.startEdgeIndex == 2 || line.endEdgeIndex == 2)) ||
        (startItem.sourceType == "Loop" &&
            !(line.startEdgeIndex == 2 ||
                line.endEdgeIndex == 2 ||
                line.startEdgeIndex == 0 ||
                line.endEdgeIndex == 0)) ||
        (endItem.sourceType == "Loop" &&
            !(line.startEdgeIndex == 2 ||
                line.endEdgeIndex == 2 ||
                line.startEdgeIndex == 0 ||
                line.endEdgeIndex == 0));
  }

  bool checkReverseDirection(
      ViewPageModel startItem, ViewPageModel endItem, Line line, Map<dynamic, LiveDataModel> liveData) {
    if (startItem.sourceType == "BusCoupler" ||
        endItem.sourceType == "BusCoupler" ||
        startItem.sourceType == "Loop" ||
        endItem.sourceType == "Loop") {
      double? power = liveData[startItem.id]?.power ?? liveData[endItem.id]?.power;
      if (power != null && power < 0) {
        return true;
      }
    }
    const List<String> reverseNodes = ["BBT 02", "BBT 04", "BBT 07", "BBT 08"];
    const List<String> ltBusBars = ["LT-01 A", "LT-01 B", "LT-02 A", "LT-02 B"];

    bool isStartNodeReverse = reverseNodes.contains(startItem.nodeName);
    bool isEndNodeReverse = reverseNodes.contains(endItem.nodeName);
    bool isStartBusBar = ltBusBars.contains(startItem.nodeName);
    bool isEndBusBar = ltBusBars.contains(endItem.nodeName);

    double? startPower = liveData[startItem.id]?.power;
    double? endPower = liveData[endItem.id]?.power;

    if ((isStartNodeReverse && isEndBusBar && startPower != null && startPower < 0) ||
        (isEndNodeReverse && isStartBusBar && endPower != null && endPower < 0)) {
      return true;
    }

    return false;
  }

  @override
  bool shouldRepaint(WaterLongSLDAnimatedLinePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.viewPageData != viewPageData ||
        oldDelegate.liveData != liveData;
  }
}

// Utility function to find the first element matching a condition
T? firstWhereOrNull<T>(List<T> list, bool Function(T) test) {
  for (var item in list) {
    if (test(item)) return item;
  }
  return null;
}*/







// import 'dart:math' as math;
// import 'dart:ui' as ui;
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/model/water_long_sld_view_page_model.dart';
//
// class WaterLongSLDAnimatedLinePainter extends CustomPainter {
//   final List<WaterViewPageModel> viewPageData;
//   final Map<dynamic, LiveDataModel> liveData;
//   final double minX;
//   final double minY;
//   final Animation<double> animation;
//
//   WaterLongSLDAnimatedLinePainter({
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
//             drawAnimatedLine(canvas, path, line, reverseDirection);
//
//             if (!shouldSkipAnimation && (startSensorStatus || endSensorStatus)) {
//               double animatedValue = reverseDirection ? 1.0 - animation.value : animation.value;
//               drawVerticalAnimatedPointer(
//                 canvas,
//                 path,
//                 animatedValue,
//                 line.lineColor,
//                 reverseDirection,
//                 line.points,
//                 startItem,
//                 endItem,
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
//   void drawAnimatedLine(Canvas canvas, Path path, Line line, bool reverseDirection) {
//     final lineColor = line.lineColor != null ? hexToColor(line.lineColor!) : Colors.blue;
//     const double lineWidth = 10.0; // Adjusted to match the image proportions
//
//     // Draw the base pipe with solid color
//     final pipePaint = Paint()
//       ..color = lineColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = lineWidth
//       ..strokeCap = StrokeCap.round;
//
//     canvas.drawPath(path, pipePaint);
//
//     // Draw semi-transparent blue liquid layer for flowing effect
//     ui.PathMetrics pathMetrics = path.computeMetrics();
//     for (var metric in pathMetrics) {
//       double length = metric.length;
//       double animatedValue = reverseDirection ? 1.0 - animation.value : animation.value;
//       double liquidOffset = (animatedValue % 1.0) * length;
//
//       // Extract a segment of the path for the liquid effect
//       Path liquidPath = metric.extractPath(
//         liquidOffset - length, // Start a full length behind
//         liquidOffset, // End at the current offset
//       );
//
//       final liquidPaint = Paint()
//         ..color = Colors.blue.withOpacity(0.3) // Slightly more opaque to match the image
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = lineWidth * 0.5 // Slightly narrower to fit inside pipe
//         ..strokeCap = StrokeCap.round;
//
//       canvas.drawPath(liquidPath, liquidPaint);
//
//       // Draw small white bubbles along the path in two staggered lines
//       const int numBubblesPerLine = 5; // Number of bubbles per line to match the image
//       final random = math.Random(line.hashCode); // Consistent random seed per line
//       final bubblePaint = Paint()
//         ..color = Colors.white.withOpacity(0.7) // Match the image
//         ..style = PaintingStyle.fill;
//
//       // Define offsets for two lines of bubbles (left and right within the pipe)
//       final leftLineOffset = -lineWidth * 0.25; // 25% from the center to the left
//       final rightLineOffset = lineWidth * 0.25; // 25% from the center to the right
//
//       for (int i = 0; i < numBubblesPerLine; i++) {
//         // Left line bubble
//         double leftBubbleOffset = ((animatedValue + (i / numBubblesPerLine)) % 1.0) * length;
//         ui.Tangent? leftTangent = metric.getTangentForOffset(leftBubbleOffset);
//         if (leftTangent != null) {
//           double bubbleSize = lineWidth * (0.15 + random.nextDouble() * 0.1); // Smaller bubbles
//           // Calculate the perpendicular vector to offset the bubble
//           Offset perpendicular = Offset(-leftTangent.vector.dy, leftTangent.vector.dx).normalized();
//           Offset bubblePosition = leftTangent.position + perpendicular * leftLineOffset;
//           canvas.drawCircle(bubblePosition, bubbleSize, bubblePaint);
//         }
//
//         // Right line bubble (staggered by adding an offset to the animation value)
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
//
//   void drawVerticalAnimatedPointer(
//       Canvas canvas,
//       Path path,
//       double animatedValue,
//       String? lineColor,
//       bool reverseDirection,
//       List<Point> points,
//       WaterViewPageModel startItem,
//       WaterViewPageModel endItem,
//       ) {
//     ui.PathMetrics pathMetrics = path.computeMetrics();
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
//         finalAngle = tangent.vector.dy < 0 ? -math.pi / 2 : math.pi / 2;
//       } else {
//         finalAngle = tangent.vector.dx < 0 ? math.pi : 0;
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
//       arrowPath.moveTo(0, 0);
//       arrowPath.lineTo(-arrowLength, -arrowWidth / 2);
//       arrowPath.lineTo(-arrowLength, arrowWidth / 2);
//       arrowPath.close();
//
//       Color arrowColor = (lineColor != null ? hexToColor(lineColor) : Colors.purple);
//
//       final arrowPaint = Paint()
//         ..color = arrowColor
//         ..style = PaintingStyle.fill;
//
//       final arrowOutlinePaint = Paint()
//         ..color = hexToColor(lineColor ?? '#000000')
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 1.5;
//
//       canvas.drawPath(arrowPath, arrowPaint);
//       canvas.drawPath(arrowPath, arrowOutlinePaint);
//
//       canvas.restore();
//     }
//   }
//
//   bool checkIfShouldSkipAnimation(WaterViewPageModel startItem, WaterViewPageModel endItem, Line line) {
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
//       WaterViewPageModel startItem, WaterViewPageModel endItem, Line line, Map<dynamic, LiveDataModel> liveData) {
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
//         oldDelegate.liveData != liveData;
//   }
// }
//
// // Utility function to find the first element matching a condition
// T? firstWhereOrNull<T>(List<T> list, bool Function(T) test) {
//   for (var item in list) {
//     if (test(item)) return item;
//   }
//   return null;
// }
//
// // Extension to normalize Offset
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
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/model/water_long_sld_view_page_model.dart';

class WaterLongSLDAnimatedLinePainter extends CustomPainter {
  final List<WaterLongSLDViewPageModel> viewPageData;
  final Map<dynamic, LiveDataModel> liveData;
  final double minX;
  final double minY;
  final Animation<double> animation;
  final bool debugBaseLineOnly;

  WaterLongSLDAnimatedLinePainter({
    required this.viewPageData,
    required this.liveData,
    required this.minX,
    required this.minY,
    required this.animation,
    this.debugBaseLineOnly = false,
  }) : super(repaint: animation);

  Color hexToColor(String hex) {
    return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var item in viewPageData) {
      if (item.lines != null) {
        for (var line in item.lines) {
          var startItem = firstWhereOrNull(viewPageData, (element) => element.id == line.startItemId);
          var endItem = firstWhereOrNull(viewPageData, (element) => element.id == line.endItemId);
          if (startItem == null || endItem == null) continue;

          bool startSensorStatus = liveData[startItem.id]?.sensorStatus ?? false;
          bool endSensorStatus = liveData[endItem.id]?.sensorStatus ?? false;
          bool shouldSkipAnimation = checkIfShouldSkipAnimation(startItem, endItem, line);
          bool reverseDirection = checkReverseDirection(startItem, endItem, line, liveData);

          if (line.points.isNotEmpty) {
            Path path = createLinePath(line);
            drawAnimatedLine(canvas, path, line, reverseDirection);

            if (!debugBaseLineOnly && !shouldSkipAnimation && (startSensorStatus || endSensorStatus)) {
              double animatedValue = reverseDirection ? 1.0 - animation.value : animation.value;
              drawVerticalAnimatedPointer(
                canvas,
                path,
                animatedValue,
                line.lineColor,
                reverseDirection,
                line.points,
                startItem,
                endItem,
              );
            }
          }
        }
      }
    }
  }

  Path createLinePath(Line line) {
    Path path = Path();
    if (line.points.isEmpty) return path;

    var firstPoint = Offset(line.points.first.x - minX, line.points.first.y - minY);
    path.moveTo(firstPoint.dx, firstPoint.dy);

    for (int i = 1; i < line.points.length; i++) {
      var point = line.points[i];
      var adjustedPoint = Offset(point.x - minX, point.y - minY);
      path.lineTo(adjustedPoint.dx, adjustedPoint.dy);
    }
    return path;
  }

  void drawAnimatedLine(Canvas canvas, Path path, Line line, bool reverseDirection) {
    final lineColor = line.lineColor != null ? hexToColor(line.lineColor!) : Colors.blue;
    const double lineWidth = 10.0;

    final pipePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round; // Added to smooth corners and ensure consistent width

    canvas.drawPath(path, pipePaint);

    if (debugBaseLineOnly) return;

    ui.PathMetrics pathMetrics = path.computeMetrics();
    for (var metric in pathMetrics) {
      double length = metric.length;
      double animatedValue = reverseDirection ? 1.0 - animation.value : animation.value;

      const int numBubblesPerLine = 5;
      final random = math.Random(line.hashCode);
      final bubblePaint = Paint()
        ..color = Colors.white.withOpacity(0.7)
        ..style = PaintingStyle.fill;

      final leftLineOffset = -lineWidth * 0.25;
      final rightLineOffset = lineWidth * 0.25;

      for (int i = 0; i < numBubblesPerLine; i++) {
        double leftBubbleOffset = ((animatedValue + (i / numBubblesPerLine)) % 1.0) * length;
        ui.Tangent? leftTangent = metric.getTangentForOffset(leftBubbleOffset);
        if (leftTangent != null) {
          double bubbleSize = lineWidth * (0.15 + random.nextDouble() * 0.1);
          Offset perpendicular = Offset(-leftTangent.vector.dy, leftTangent.vector.dx).normalized();
          Offset bubblePosition = leftTangent.position + perpendicular * leftLineOffset;
          canvas.drawCircle(bubblePosition, bubbleSize, bubblePaint);
        }

        double rightBubbleOffset = ((animatedValue + (i / numBubblesPerLine) + 0.3) % 1.0) * length;
        ui.Tangent? rightTangent = metric.getTangentForOffset(rightBubbleOffset);
        if (rightTangent != null) {
          double bubbleSize = lineWidth * (0.15 + random.nextDouble() * 0.1);
          Offset perpendicular = Offset(-rightTangent.vector.dy, rightTangent.vector.dx).normalized();
          Offset bubblePosition = rightTangent.position + perpendicular * rightLineOffset;
          canvas.drawCircle(bubblePosition, bubbleSize, bubblePaint);
        }
      }
    }
  }

  void drawVerticalAnimatedPointer(
      Canvas canvas,
      Path path,
      double animatedValue,
      String? lineColor,
      bool reverseDirection,
      List<Point> points,
      WaterLongSLDViewPageModel startItem,
      WaterLongSLDViewPageModel endItem,
      ) {
    ui.PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.first;
    double length = pathMetric.length;
    Tangent? tangent = pathMetric.getTangentForOffset(length * animatedValue);
    if (tangent != null) {
      canvas.save();
      canvas.translate(tangent.position.dx, tangent.position.dy);

      double finalAngle;
      bool isVertical = tangent.vector.dy.abs() > tangent.vector.dx.abs();

      if (isVertical) {
        finalAngle = tangent.vector.dy < 0 ? -math.pi / 2 : math.pi / 2;
      } else {
        finalAngle = tangent.vector.dx < 0 ? math.pi : 0;
      }

      if (reverseDirection) {
        finalAngle += math.pi;
      }

      canvas.rotate(finalAngle);

      final arrowPath = Path();
      const arrowLength = 20.0;
      const arrowWidth = 16.0;

      arrowPath.moveTo(0, 0);
      arrowPath.lineTo(-arrowLength, -arrowWidth / 2);
      arrowPath.lineTo(-arrowLength, arrowWidth / 2);
      arrowPath.close();

      Color arrowColor = (lineColor != null ? hexToColor(lineColor) : Colors.purple);

      final arrowPaint = Paint()
        ..color = arrowColor
        ..style = PaintingStyle.fill;

      final arrowOutlinePaint = Paint()
        ..color = hexToColor(lineColor ?? '#000000')
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawPath(arrowPath, arrowPaint);
      canvas.drawPath(arrowPath, arrowOutlinePaint);

      canvas.restore();
    }
  }

  bool checkIfShouldSkipAnimation(WaterLongSLDViewPageModel startItem, WaterLongSLDViewPageModel endItem, Line line) {
    return (startItem.sourceType == "BusCoupler" &&
        (line.startEdgeIndex == 2 || line.endEdgeIndex == 2)) ||
        (endItem.sourceType == "BusCoupler" &&
            (line.startEdgeIndex == 2 || line.endEdgeIndex == 2)) ||
        (startItem.sourceType == "Loop" &&
            !(line.startEdgeIndex == 2 ||
                line.endEdgeIndex == 2 ||
                line.startEdgeIndex == 0 ||
                line.endEdgeIndex == 0)) ||
        (endItem.sourceType == "Loop" &&
            !(line.startEdgeIndex == 2 ||
                line.endEdgeIndex == 2 ||
                line.startEdgeIndex == 0 ||
                line.endEdgeIndex == 0));
  }

  bool checkReverseDirection(
      WaterLongSLDViewPageModel startItem, WaterLongSLDViewPageModel endItem, Line line, Map<dynamic, LiveDataModel> liveData) {
    if (startItem.sourceType == "BusCoupler" ||
        endItem.sourceType == "BusCoupler" ||
        startItem.sourceType == "Loop" ||
        endItem.sourceType == "Loop") {
      double? power = liveData[startItem.id]?.power ?? liveData[endItem.id]?.power;
      if (power != null && power < 0) {
        return true;
      }
    }
    const List<String> reverseNodes = ["BBT 02", "BBT 04", "BBT 07", "BBT 08"];
    const List<String> ltBusBars = ["LT-01 A", "LT-01 B", "LT-02 A", "LT-02 B"];

    bool isStartNodeReverse = reverseNodes.contains(startItem.nodeName);
    bool isEndNodeReverse = reverseNodes.contains(endItem.nodeName);
    bool isStartBusBar = ltBusBars.contains(startItem.nodeName);
    bool isEndBusBar = ltBusBars.contains(endItem.nodeName);

    double? startPower = liveData[startItem.id]?.power;
    double? endPower = liveData[endItem.id]?.power;

    if ((isStartNodeReverse && isEndBusBar && startPower != null && startPower < 0) ||
        (isEndNodeReverse && isStartBusBar && endPower != null && endPower < 0)) {
      return true;
    }

    return false;
  }

  @override
  bool shouldRepaint(WaterLongSLDAnimatedLinePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.viewPageData != viewPageData ||
        oldDelegate.liveData != liveData ||
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