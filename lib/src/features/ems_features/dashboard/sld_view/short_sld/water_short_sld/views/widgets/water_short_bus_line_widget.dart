


import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/water_short_sld/model/water_short_view_page_model.dart';

class WaterShortAnimatedLinePainter extends CustomPainter {
  final List<WaterShortViewPageModel> viewPageData;
  final Map<dynamic, LiveDataModel> liveData;
  final double minX;
  final double minY;
  final Animation<double> animation;
  final bool debugBaseLineOnly;

  WaterShortAnimatedLinePainter({
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

          bool reverseDirection = checkReverseDirection(startItem, endItem, line, liveData);

          if (line.points.isNotEmpty) {
            Path path = createLinePath(line);
            drawAnimatedLine(canvas, path, line, reverseDirection);

            // Arrow drawing removed
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
      ..strokeJoin = StrokeJoin.round;

    // Always draw the base line (pipe)
    canvas.drawPath(path, pipePaint);

    if (debugBaseLineOnly) return;

    // Check if flow is available (power is non-zero and not null)
    var startItem = firstWhereOrNull(viewPageData, (element) => element.id == line.startItemId);
    var endItem = firstWhereOrNull(viewPageData, (element) => element.id == line.endItemId);
    double? power = liveData[startItem?.id]?.power ?? liveData[endItem?.id]?.power;

    // Skip bubble animation if power is null or zero (no flow)
    if (power == null || power == 0) return;

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
      WaterShortViewPageModel startItem, WaterShortViewPageModel endItem, Line line, Map<dynamic, LiveDataModel> liveData) {
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