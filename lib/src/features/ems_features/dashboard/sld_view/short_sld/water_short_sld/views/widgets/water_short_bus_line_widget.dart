/*
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/water_short_sld/model/water_short_view_page_model.dart';

class WaterShortAnimatedLinePainter extends CustomPainter {
  final List<WaterShortViewPageModel> viewPageData;
  final Map<dynamic, WaterLiveDataModel> liveData;
  final double minX;
  final double minY;
  final Animation<double> animation;

  WaterShortAnimatedLinePainter({
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
          var startItem = viewPageData.firstWhereOrNull((element) => element.id == line.startItemId);
          var endItem = viewPageData.firstWhereOrNull((element) => element.id == line.endItemId);
          if (startItem == null || endItem == null) continue;

          if (line.points.isNotEmpty) {
            ui.Path path = createLinePath(line);
            drawAnimatedLine(canvas, path, line);

            // Arrow drawing removed
          }
        }
      }
    }
  }

  ui.Path createLinePath(Line line) {
    ui.Path path = ui.Path();
    var firstPoint = ui.Offset(line.points.first.x - minX, line.points.first.y - minY);
    path.moveTo(firstPoint.dx, firstPoint.dy);

    for (int i = 1; i < line.points.length; i++) {
      var point = line.points[i];
      path.lineTo(point.x - minX, point.y - minY);
    }
    return path;
  }

  void drawAnimatedLine(Canvas canvas, ui.Path path, Line line) {
    final linePaint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..color = line.lineColor != null ? hexToColor(line.lineColor!) : Colors.black
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(path, linePaint);
  }

  bool checkIfShouldSkipAnimation(WaterShortViewPageModel startItem, WaterShortViewPageModel endItem, Line line) {
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
      WaterShortViewPageModel startItem,
      WaterShortViewPageModel endItem,
      Line line,
      Map<dynamic, WaterLiveDataModel> liveData,
      ) {
    if (startItem.sourceType == "BusCoupler" ||
        endItem.sourceType == "BusCoupler" ||
        startItem.sourceType == "Loop" ||
        endItem.sourceType == "Loop") {
      double? power = liveData[startItem.id]?.power ?? liveData[endItem.id]?.power;

      if (power != null) {
        if (power < 0) {
          return true;
        }
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
  bool shouldRepaint(WaterShortAnimatedLinePainter oldDelegate) {
    return oldDelegate.animation != animation;
    }
}*/


import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/water_short_sld/model/water_short_view_page_model.dart';

class WaterShortAnimatedLinePainter extends CustomPainter {
  final List<WaterShortViewPageModel> viewPageData;
  final Map<dynamic, WaterLiveDataModel> liveData;
  final double minX;
  final double minY;
  final Animation<double> animation;
  final bool debugBaseLineOnly; // Added for debugging option

  WaterShortAnimatedLinePainter({
    required this.viewPageData,
    required this.liveData,
    required this.minX,
    required this.minY,
    required this.animation,
    this.debugBaseLineOnly = false, // Default to false
  }) : super(repaint: animation);

  Color hexToColor(String hex) {
    return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var item in viewPageData) {
      if (item.lines != null) {
        for (var line in item.lines) {
          var startItem = viewPageData.firstWhereOrNull((element) => element.id == line.startItemId);
          var endItem = viewPageData.firstWhereOrNull((element) => element.id == line.endItemId);
          if (startItem == null || endItem == null) continue;

          bool reverseDirection = checkReverseDirection(startItem, endItem, line, liveData);

          if (line.points.isNotEmpty) {
            ui.Path path = createLinePath(line);
            drawAnimatedLine(canvas, path, line, reverseDirection, startItem, endItem);
          }
        }
      }
    }
  }

  ui.Path createLinePath(Line line) {
    ui.Path path = ui.Path();
    var firstPoint = ui.Offset(line.points.first.x - minX, line.points.first.y - minY);
    path.moveTo(firstPoint.dx, firstPoint.dy);

    for (int i = 1; i < line.points.length; i++) {
      var point = line.points[i];
      path.lineTo(point.x - minX, point.y - minY);
    }
    return path;
  }

  void drawAnimatedLine(Canvas canvas, ui.Path path, Line line, bool reverseDirection, WaterShortViewPageModel startItem, WaterShortViewPageModel endItem) {
    const double lineWidth = 3.0; // Match original stroke width
    final lineColor = line.lineColor != null ? hexToColor(line.lineColor!) : Colors.black;

    final linePaint = Paint()
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..color = lineColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
      ..strokeCap = StrokeCap.round // Added for smoother line ends
      ..strokeJoin = StrokeJoin.round; // Added for smoother corners

    // Always draw the base line
    canvas.drawPath(path, linePaint);

    if (debugBaseLineOnly) return;

    // Check if flow is available (power is non-zero and not null)
    double? power = liveData[startItem.id]?.power ?? liveData[endItem.id]?.power;
    if (power == null || power == 0) return; // Skip animation if no flow

    // Bubble animation for active flow
    ui.PathMetrics pathMetrics = path.computeMetrics();
    for (var metric in pathMetrics) {
      double length = metric.length;
      double animatedValue = reverseDirection ? 1.0 - animation.value : animation.value;

      const int numBubblesPerLine = 3; // Fewer bubbles for thinner lines
      final random = math.Random(line.hashCode);
      final bubblePaint = Paint()
        ..color = Colors.white.withOpacity(0.7)
        ..style = PaintingStyle.fill;

      final leftLineOffset = -lineWidth * 0.25;
      final rightLineOffset = lineWidth * 0.25;

      for (int i = 0; i < numBubblesPerLine; i++) {
        // Left side bubbles
        double leftBubbleOffset = ((animatedValue + (i / numBubblesPerLine)) % 1.0) * length;
        ui.Tangent? leftTangent = metric.getTangentForOffset(leftBubbleOffset);
        if (leftTangent != null) {
          double bubbleSize = lineWidth * (0.15 + random.nextDouble() * 0.1);
          Offset perpendicular = Offset(-leftTangent.vector.dy, leftTangent.vector.dx).normalized();
          Offset bubblePosition = leftTangent.position + perpendicular * leftLineOffset;
          canvas.drawCircle(bubblePosition, bubbleSize, bubblePaint);
        }

        // Right side bubbles (offset for visual variation)
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

  bool checkIfShouldSkipAnimation(WaterShortViewPageModel startItem, WaterShortViewPageModel endItem, Line line) {
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
      WaterShortViewPageModel startItem,
      WaterShortViewPageModel endItem,
      Line line,
      Map<dynamic, WaterLiveDataModel> liveData,
      ) {
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
  bool shouldRepaint(WaterShortAnimatedLinePainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.viewPageData != viewPageData ||
        oldDelegate.liveData != liveData ||
        oldDelegate.debugBaseLineOnly != debugBaseLineOnly;
  }
}

// Extension for normalizing Offset (used in bubble positioning)
extension OffsetExtension on Offset {
  Offset normalized() {
    final double magnitude = distance;
    if (magnitude == 0) return Offset.zero;
    return this / magnitude;
    }
}