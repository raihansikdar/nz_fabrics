
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/electricity_long_sld/model/busbar_status_info_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/water_short_sld/model/water_short_live_all_node_power_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/water_short_sld/model/water_short_view_page_model.dart';


class WaterShortAnimatedLinePainter extends CustomPainter {
  final List<WaterShortViewPageModel> viewPageData;
  final List<WaterShortLiveAllNodePowerModel> liveAllNodeModel;
  final List<BusBarStatusInfoModel> busBarStatusModels;
  final double minX;
  final double minY;
  final Animation<double> animation;
  final bool debugBaseLineOnly;

  WaterShortAnimatedLinePainter({
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
        //debugPrint('--->>> Short live node lineID: $lineId (sensorStatus: true: ${liveNode.node})');
        return true;
      }
    }

    // Check busbar status model for sensorStatus
    for (var busBarStatus in busBarStatusModels) {
      if (busBarStatus.connectedWithDetails == null) continue;

      for (var connectedDetail in busBarStatus.connectedWithDetails!) {
        if (connectedDetail.sensorStatus != true || connectedDetail.lineID != lineId) continue;

        // Match busbar connected details with the lineId
        //debugPrint('--->> Short busbar connected lineID: $lineId--->> (sensorStatus: true: ${connectedDetail.nodeName})');
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
  bool shouldRepaint(WaterShortAnimatedLinePainter oldDelegate) {
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