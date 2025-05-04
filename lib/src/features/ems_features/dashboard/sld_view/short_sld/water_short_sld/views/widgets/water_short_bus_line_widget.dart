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

          bool startSensorStatus = liveData[startItem.id]?.sensorStatus ?? false;
          bool endSensorStatus = liveData[endItem.id]?.sensorStatus ?? false;
          bool shouldSkipAnimation = checkIfShouldSkipAnimation(startItem, endItem, line);
          bool reverseDirection = checkReverseDirection(startItem, endItem, line, liveData);

          if (line.points.isNotEmpty) {
            ui.Path path = createLinePath(line);
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
            }
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

  void drawVerticalAnimatedPointer(
      Canvas canvas,
      ui.Path path,
      double animatedValue,
      String? lineColor,
      bool reverseDirection,
      List<Point> points,
      WaterShortViewPageModel startItem,
      WaterShortViewPageModel endItem,
      ) {
    ui.PathMetrics pathMetrics = path.computeMetrics();
    ui.PathMetric pathMetric = pathMetrics.first;
    double length = pathMetric.length;
    ui.Tangent? tangent = pathMetric.getTangentForOffset(length * animatedValue);
    if (tangent != null) {
      canvas.save();
      canvas.translate(tangent.position.dx, tangent.position.dy);

      double finalAngle;
      bool isVertical = tangent.vector.dy.abs() > tangent.vector.dx.abs();

      if (isVertical) {
        if (tangent.vector.dy < 0) {
          finalAngle = -math.pi / 2;
        } else {
          finalAngle = math.pi / 2;
        }
      } else {
        if (tangent.vector.dx < 0) {
          finalAngle = math.pi;
        } else {
          finalAngle = 0;
        }
      }

      if (reverseDirection) {
        finalAngle += math.pi;
      }

      canvas.rotate(finalAngle);

      final arrowPath = ui.Path();
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

      if (isVertical) {
        final debugPaint = Paint()
          ..color = Colors.white.withOpacity(0.5)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

        canvas.drawLine(const Offset(-20, 0), const Offset(-arrowLength, 0), debugPaint);
      }

      canvas.restore();
    }
  }

  double getVerticalDirection(List<Point> points, double animatedValue) {
    if (points.length < 2) return 0;

    int currentIndex = (animatedValue * (points.length - 1)).floor();
    currentIndex = currentIndex.clamp(0, points.length - 2);

    Point current = points[currentIndex];
    Point next = points[currentIndex + 1];

    double dy = next.y - current.y;
    double dx = next.x - current.x;

    return math.atan2(dy, dx);
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
}