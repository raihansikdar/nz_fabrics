
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/busbar_status_info_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/model/electricity_short_live_all_node_power_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/model/electricity_short_view_page_model.dart';

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