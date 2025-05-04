import 'package:flutter/material.dart';
import 'dart:math';

class ShortElectricityMeterBusBarWidget extends StatelessWidget {
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
  final String orientation;

  const ShortElectricityMeterBusBarWidget({
    super.key,
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
    required this.orientation,
  });

  Color hexToColor(String? hex, {bool isBorderOrText = false}) {
    if (hex == null || hex.isEmpty) {
      debugPrint('hexToColor: Input is null or empty, returning ${isBorderOrText ? "Colors.black" : "Colors.transparent"}');
      return isBorderOrText ? Colors.black : Colors.transparent;
    }
    hex = hex.replaceAll('#', '');
    try {
      return Color(int.parse('0xFF$hex'));
    } catch (e) {
      debugPrint('Invalid hex color: $hex, returning ${isBorderOrText ? "Colors.black" : "Colors.transparent"}');
      return isBorderOrText ? Colors.black : Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug orientation and dimensions
    debugPrint('MeterBusBarWidget: nodeName=$nodeName, orientation=$orientation, '
        'width=$loadBoxWidth, height=$loadBoxHeight, '
        'color=$color, borderColor=$borderColor, textColor=$textColor, textSize=$textSize');

    // Determine if text should be vertical
    final isVertical = orientation.toLowerCase().trim() == 'vertical';

    // Adjust font size to prevent clipping
    final displayText = '$nodeName\n${value.toStringAsFixed(2)} $unit';
    final textLength = displayText.length;
    final baseFontSize = textSize;
    final fontSize = textLength > 20 ? baseFontSize * 0.7 : textLength > 15 ? baseFontSize * 0.85 : baseFontSize;
    debugPrint('MeterBusBarWidget: displayText="$displayText", baseFontSize=$baseFontSize, fontSize=$fontSize');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: loadBoxWidth,
        height: loadBoxHeight,
        decoration: BoxDecoration(
          color: hexToColor(color), // Transparent if null/empty
          border: Border.all(color: hexToColor(borderColor, isBorderOrText: true), width: 3),
        ),
        child: Center(
          child: Padding(
            padding: isVertical ? const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0) : const EdgeInsets.all(2.0),
            child: Transform.rotate(
              angle: isVertical ? -pi / 2 : 0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isVertical ? loadBoxHeight - 4 : loadBoxWidth - 4,
                  maxHeight: isVertical ? loadBoxWidth * 1.5 : loadBoxHeight - 4,
                ),
                child: Text(
                  displayText,
                  style: TextStyle(
                    color: hexToColor(textColor, isBorderOrText: true),
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}