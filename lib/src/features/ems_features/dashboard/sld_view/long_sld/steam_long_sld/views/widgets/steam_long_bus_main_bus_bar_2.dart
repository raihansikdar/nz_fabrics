import 'package:flutter/material.dart';
import 'dart:math';

class SteamLongMainBusBarTrue extends StatelessWidget {
  final bool sensorStatus;
  final double value;
  final String nodeName;
  final String? color;
  final String? borderColor;
  final String? textColor;
  final double textSize;
  final double loadBoxHeight;
  final double loadBoxWidth;
  final VoidCallback onTap;
  final String unit;
  final dynamic percentage;
  final dynamic capacity;
  final String orientation;

  const SteamLongMainBusBarTrue({
    Key? key,
    required this.sensorStatus,
    required this.value,
    required this.nodeName,
    this.color,
    this.borderColor,
    this.textColor,
    required this.textSize,
    required this.loadBoxHeight,
    required this.loadBoxWidth,
    required this.onTap,
    required this.unit,
    required this.percentage,
    required this.capacity,
    required this.orientation,
  }) : super(key: key);

  Color hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) {
      debugPrint('hexToColor: Input is null or empty, returning Colors.transparent');
      return Colors.transparent;
    }
    hex = hex.replaceAll('#', '');
    try {
      return Color(int.parse('0xFF$hex'));
    } catch (e) {
      debugPrint('Invalid hex color: $hex, returning Colors.transparent');
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug orientation and dimensions
    debugPrint('MainBusBarTrue: nodeName=$nodeName, orientation=$orientation, '
        'width=$loadBoxWidth, height=$loadBoxHeight, '
        'color=$color, borderColor=$borderColor, textColor=$textColor, textSize=$textSize');

    // Safely parse percentage
    final double parsedPercentage = double.tryParse(percentage?.toString() ?? '0.0') ?? 0.0;

    // Determine if text should be vertical
    final isVertical = orientation.toLowerCase().trim() == 'vertical';

    // Adjust font size to prevent clipping
    final longestText = [
      nodeName,
      '($parsedPercentage% / $capacity $unit)',
      '${value.toStringAsFixed(2)} $unit'
    ].reduce((a, b) => a.length > b.length ? a : b);
    final textLength = longestText.length;
    final baseFontSize = textSize;
    final fontSize = textLength > 20 ? baseFontSize * 0.7 : textLength > 15 ? baseFontSize * 0.85 : baseFontSize;
    debugPrint('MainBusBarTrue: longestText="$longestText", baseFontSize=$baseFontSize, fontSize=$fontSize');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: loadBoxWidth,
        height: loadBoxHeight,
        decoration: BoxDecoration(
          color: hexToColor(color), // Background color from API or transparent
          border: Border.all(color: hexToColor(borderColor), width: 4),
        ),
        child: Stack(
          children: [
            // Percentage bar (semi-transparent, only if color is provided)
            if (color != null && color!.isNotEmpty)
              Container(
                width: (loadBoxWidth * parsedPercentage / 100).clamp(0.0, loadBoxWidth),
                height: loadBoxHeight,
                decoration: BoxDecoration(
                  color: hexToColor(color).withOpacity(0.7),
                ),
              ),
            // Text
            Positioned.fill(
              child: Align(
                alignment: isVertical ? Alignment.center : Alignment.topCenter,
                child: Padding(
                  padding: isVertical
                      ? const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0)
                      : const EdgeInsets.only(top: 2.0),
                  child: Transform.rotate(
                    angle: isVertical ? -pi / 2 : 0,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isVertical ? loadBoxHeight - 4 : loadBoxWidth - 4,
                        maxHeight: isVertical ? loadBoxWidth * 1.5 : loadBoxHeight - 4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              nodeName,
                              style: TextStyle(
                                color: textColor != null ? hexToColor(textColor!) : Colors.black,
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '($parsedPercentage% / $capacity $unit)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor != null ? hexToColor(textColor!) : Colors.black,
                                fontSize: fontSize,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '${value.toStringAsFixed(2)} $unit',
                              style: TextStyle(
                                color: textColor != null ? hexToColor(textColor!) : Colors.black,
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}