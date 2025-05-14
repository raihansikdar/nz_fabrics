// import 'dart:math' as math;
// import 'dart:ui' as ui;
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/electricity_long_view_page_model.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/views/screens/electricity_long_sld_screen.dart';
//
// class ElectricityLongSLDAnimatedLinePainter extends CustomPainter {
//   final List<ElectricityLongViewPageModel> viewPageData; // Use Long model
//   final Map<dynamic, LiveDataModel> liveData; // LiveDataModel from long_sld
//   final double minX;
//   final double minY;
//   final Animation<double> animation;
//   final ElectricityLongSLDGetAllInfoUIControllers controller; // Reuse controller (assuming compatibility)
//
//   ElectricityLongSLDAnimatedLinePainter({
//     required this.viewPageData,
//     required this.liveData,
//     required this.minX,
//     required this.minY,
//     required this.animation,
//     required this.controller,
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
//           bool reverseDirection = checkReverseDirection(startItem, endItem, line, liveData, controller);
//
//           if (line.points.isNotEmpty) {
//             Path path = createLinePath(line);
//             drawAnimatedLine(canvas, path, line);
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
//     if (tangent != null) {
//       canvas.save();
//       canvas.translate(tangent.position.dx, tangent.position.dy);
//
//       double finalAngle;
//       bool isVertical = tangent.vector.dy.abs() > tangent.vector.dx.abs();
//
//       if (isVertical) {
//         if (tangent.vector.dy < 0) {
//           finalAngle = -math.pi / 2;
//         } else {
//           finalAngle = math.pi / 2;
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
//   bool checkIfShouldSkipAnimation(
//       ElectricityLongViewPageModel startItem, ElectricityLongViewPageModel endItem, Line line) {
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
//       ElectricityLongViewPageModel startItem,
//       ElectricityLongViewPageModel endItem,
//       Line line,
//       Map<dynamic, LiveDataModel> liveData,
//       ElectricityLongSLDGetAllInfoUIControllers controller,
//       ) {
//     if (startItem.sourceType == "BusCoupler" ||
//         endItem.sourceType == "BusCoupler" ||
//         startItem.sourceType == "Loop" ||
//         endItem.sourceType == "Loop") {
//       double? power = controller.powerMeterMap[startItem.nodeName] ??
//           controller.powerMeterMap[endItem.nodeName] ??
//           liveData[startItem.id]?.power ??
//           liveData[endItem.id]?.power;
//
//       if (power != null && power < 0) {
//         return true;
//       }
//     }
//
//     const List<String> reverseNodes = ["BBT 02", "BBT 04", "BBT 07", "BBT 08"];
//     const List<String> ltBusBars = ["LT-01 A", "LT-01 B", "LT-02 A", "LT-02 B"];
//
//     bool isStartNodeReverse = reverseNodes.contains(startItem.nodeName);
//     bool isEndNodeReverse = reverseNodes.contains(endItem.nodeName);
//     bool isStartBusBar = ltBusBars.contains(startItem.nodeName);
//     bool isEndBusBar = ltBusBars.contains(endItem.nodeName);
//
//     double? startPower = controller.powerMeterMap[startItem.nodeName] ?? liveData[startItem.id]?.power;
//     double? endPower = controller.powerMeterMap[endItem.nodeName] ?? liveData[endItem.id]?.power;
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
//   bool shouldRepaint(ElectricityLongSLDAnimatedLinePainter oldDelegate) {
//     return oldDelegate.animation != animation ||
//         oldDelegate.liveData != liveData ||
//         oldDelegate.controller.powerMeterMap != controller.powerMeterMap;
//   }
// }
//
// T? firstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
//   for (T item in items) {
//     if (test(item)) return item;
//   }
//   return null;
// }


// import 'dart:math' as math;
// import 'dart:ui' as ui;
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/electricity_long_view_page_model.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/views/screens/electricity_long_sld_screen.dart';
//
// class ElectricityLongSLDAnimatedLinePainter extends CustomPainter {
//   final List<ElectricityLongViewPageModel> viewPageData;
//   final Map<dynamic, LiveDataModel> liveData;
//   final double minX;
//   final double minY;
//   final Animation<double> animation;
//   final ElectricityLongSLDGetAllInfoUIControllers controller;
//
//   ElectricityLongSLDAnimatedLinePainter({
//     required this.viewPageData,
//     required this.liveData,
//     required this.minX,
//     required this.minY,
//     required this.animation,
//     required this.controller,
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
//           if (startItem == null || endItem == null) {
//             debugPrint('Skipping line: startItem or endItem is null');
//             continue;
//           }
//
//           // Check power values
//           double? startPower = liveData[startItem.nodeName]?.power ?? 0.0;
//           double? endPower = liveData[endItem.nodeName]?.power ?? 0.0;
//           bool hasPower = startPower != 0.0 || endPower != 0.0;
//
//           bool shouldSkipAnimation = checkIfShouldSkipAnimation(startItem, endItem, line);
//           bool reverseDirection = checkReverseDirection(startItem, endItem, line, liveData, controller);
//
//           debugPrint('Line from ${startItem.nodeName} to ${endItem.nodeName}: '
//               'startPower=$startPower, endPower=$endPower, hasPower=$hasPower, '
//               'shouldSkipAnimation=$shouldSkipAnimation');
//
//           if (line.points.isNotEmpty) {
//             Path path = createLinePath(line);
//             drawAnimatedLine(canvas, path, line);
//
//             if (hasPower && !shouldSkipAnimation) {
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
//       Color arrowColor = lineColor != null ? hexToColor(lineColor) : Colors.purple;
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
//   bool checkIfShouldSkipAnimation(
//       ElectricityLongViewPageModel startItem, ElectricityLongViewPageModel endItem, Line line) {
//     // Simplify logic to allow animation when power is available
//     bool isBusCoupler = startItem.sourceType == "BusCoupler" || endItem.sourceType == "BusCoupler";
//     bool isLoop = startItem.sourceType == "Loop" || endItem.sourceType == "Loop";
//     bool isEdgeRestricted = line.startEdgeIndex == 2 || line.endEdgeIndex == 2;
//
//     if (isBusCoupler && isEdgeRestricted) {
//       return true;
//     }
//     if (isLoop && !(line.startEdgeIndex == 0 || line.endEdgeIndex == 0 || line.startEdgeIndex == 2 || line.endEdgeIndex == 2)) {
//       return true;
//     }
//     return false;
//   }
//
//   bool checkReverseDirection(
//       ElectricityLongViewPageModel startItem,
//       ElectricityLongViewPageModel endItem,
//       Line line,
//       Map<dynamic, LiveDataModel> liveData,
//       ElectricityLongSLDGetAllInfoUIControllers controller,
//       ) {
//     double? power = controller.powerMeterMap[startItem.nodeName] ??
//         controller.powerMeterMap[endItem.nodeName] ??
//         liveData[startItem.nodeName]?.power ??
//         liveData[endItem.nodeName]?.power;
//
//     if (power != null && power < 0) {
//       return true;
//     }
//
//     const List<String> reverseNodes = ["BBT 02", "BBT 04", "BBT 07", "BBT 08"];
//     const List<String> ltBusBars = ["LT-01 A", "LT-01 B", "LT-02 A", "LT-02 B"];
//
//     bool isStartNodeReverse = reverseNodes.contains(startItem.nodeName);
//     bool isEndNodeReverse = reverseNodes.contains(endItem.nodeName);
//     bool isStartBusBar = ltBusBars.contains(startItem.nodeName);
//     bool isEndBusBar = ltBusBars.contains(endItem.nodeName);
//
//     double? startPower = controller.powerMeterMap[startItem.nodeName] ?? liveData[startItem.nodeName]?.power;
//     double? endPower = controller.powerMeterMap[endItem.nodeName] ?? liveData[endItem.nodeName]?.power;
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
//   bool shouldRepaint(ElectricityLongSLDAnimatedLinePainter oldDelegate) {
//     return oldDelegate.animation != animation ||
//         oldDelegate.liveData != liveData ||
//         oldDelegate.controller.powerMeterMap != controller.powerMeterMap ||
//         oldDelegate.viewPageData != viewPageData;
//     }
// }

import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/electricity_long_view_page_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/views/screens/electricity_long_sld_screen.dart';

class ElectricityLongSLDAnimatedLinePainter extends CustomPainter {
  final List<ElectricityLongViewPageModel> viewPageData;
  final Map<dynamic, LiveDataModel> liveData;
  final double minX;
  final double minY;
  final Animation<double> animation;

  ElectricityLongSLDAnimatedLinePainter({
    required this.viewPageData,
    required this.liveData,
    required this.minX,
    required this.minY,
    required this.animation,
  }) : super(repaint: animation);

  Color hexToColor(String hex) {
    hex = hex.isEmpty ? '#000000' : hex.replaceAll('#', '');
    try {
      return Color(int.parse('0xFF$hex'));
    } catch (e) {
      return Colors.black;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var item in viewPageData) {
      if (item.lines == null) continue;

      for (var line in item.lines) {
        var startItem = firstWhereOrNull(viewPageData, (element) => element.id == line.startItemId);
        var endItem = firstWhereOrNull(viewPageData, (element) => element.id == line.endItemId);
        if (startItem == null || endItem == null) {
          debugPrint('Skipping line: startItem or endItem is null');
          continue;
        }

        bool startSensorStatus = liveData[startItem.id]?.power != null && liveData[startItem.id]!.power! != 0.0;
        bool endSensorStatus = liveData[endItem.id]?.power != null && liveData[endItem.id]!.power! != 0.0;
        bool shouldSkipAnimation = checkIfShouldSkipAnimation(startItem, endItem, line);
        bool reverseDirection = checkReverseDirection(startItem, endItem, line, liveData);

        if (line.points.isNotEmpty) {
          Path path = createLinePath(line);
          drawAnimatedLine(canvas, path, line);

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
          } else {
            debugPrint('Skipping animation for line from ${startItem.nodeName} to ${endItem.nodeName}: '
                'shouldSkip=$shouldSkipAnimation, startSensor=$startSensorStatus, endSensor=$endSensorStatus');
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

  void drawAnimatedLine(Canvas canvas, Path path, Line line) {
    final linePaint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..color = line.lineColor != null ? hexToColor(line.lineColor!) : Colors.black
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(path, linePaint);
  }

  void drawVerticalAnimatedPointer(
      Canvas canvas,
      Path path,
      double animatedValue,
      String? lineColor,
      bool reverseDirection,
      List<Point> points,
      ElectricityLongViewPageModel startItem,
      ElectricityLongViewPageModel endItem,
      ) {
    PathMetrics pathMetrics = path.computeMetrics();
    PathMetric pathMetric = pathMetrics.first;
    double length = pathMetric.length;
    Tangent? tangent = pathMetric.getTangentForOffset(length * animatedValue);
    if (tangent == null) {
      debugPrint('No tangent found for animated pointer');
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

    Color arrowColor = lineColor != null ? hexToColor(lineColor) : Colors.purple;

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

  bool checkIfShouldSkipAnimation(ElectricityLongViewPageModel startItem, ElectricityLongViewPageModel endItem, Line line) {
    bool skip = (startItem.sourceType == "BusCoupler" &&
        (line.startEdgeIndex == 2 || line.endEdgeIndex == 2)) ||
        (endItem.sourceType == "BusCoupler" &&
            (line.startEdgeIndex == 2 || line.endEdgeIndex == 2)) ||
        (startItem.sourceType == "Loop" &&
            !(line.startEdgeIndex == 2 || line.endEdgeIndex == 2 || line.startEdgeIndex == 0 || line.endEdgeIndex == 0)) ||
        (endItem.sourceType == "Loop" &&
            !(line.startEdgeIndex == 2 || line.endEdgeIndex == 2 || line.startEdgeIndex == 0 || line.endEdgeIndex == 0));

    return skip;
  }

  bool checkReverseDirection(ElectricityLongViewPageModel startItem, ElectricityLongViewPageModel endItem, Line line,
      Map<dynamic, LiveDataModel> liveData) {
    if (startItem.sourceType == "BusCoupler" || endItem.sourceType == "BusCoupler" ||
        startItem.sourceType == "Loop" || endItem.sourceType == "Loop") {
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
  bool shouldRepaint(ElectricityLongSLDAnimatedLinePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.liveData != liveData ||
        oldDelegate.viewPageData != viewPageData;
  }
}