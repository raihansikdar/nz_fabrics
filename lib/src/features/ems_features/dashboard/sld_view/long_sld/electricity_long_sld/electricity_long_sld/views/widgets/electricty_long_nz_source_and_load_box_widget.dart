import 'package:flutter/material.dart';
import 'dart:math';

// class ElectricityLongSourceAndLoadBoxWidget extends StatelessWidget {
//   final bool sensorStatus;
//   final double value;
//   final String nodeName;
//   final String? color;
//   final String? borderColor;
//   final String? textColor;
//   final double textSize;
//   final double loadBoxHeight;
//   final double loadBoxWidth;
//   final VoidCallback onTap;
//   final String unit;
//   final String orientation;
//
//   const ElectricityLongSourceAndLoadBoxWidget({
//     super.key,
//     required this.sensorStatus,
//     required this.value,
//     required this.nodeName,
//     this.color,
//     this.borderColor,
//     this.textColor,
//     required this.textSize,
//     required this.loadBoxHeight,
//     required this.loadBoxWidth,
//     required this.onTap,
//     required this.unit,
//     required this.orientation,
//   });
//
//   Color hexToColor(String? hex, {bool isBorderOrText = false}) {
//     if (hex == null || hex.isEmpty) {
//       debugPrint('hexToColor: Input is null or empty, returning ${isBorderOrText ? "Colors.black" : "Colors.transparent"}');
//       return isBorderOrText ? Colors.black : Colors.transparent;
//     }
//     hex = hex.replaceAll('#', '');
//     try {
//       return Color(int.parse('0xFF$hex'));
//     } catch (e) {
//       debugPrint('Invalid hex color: $hex, returning ${isBorderOrText ? "Colors.black" : "Colors.transparent"}');
//       return isBorderOrText ? Colors.black : Colors.transparent;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Debug orientation and dimensions
//     debugPrint('SourceAndLoadBoxWidget: nodeName=$nodeName, orientation=$orientation, '
//         'width=$loadBoxWidth, height=$loadBoxHeight, '
//         'color=$color, borderColor=$borderColor, textColor=$textColor, textSize=$textSize');
//
//     // Normalize orientation and check for vertical
//     final isVertical = orientation.toLowerCase().trim() == 'vertical';
//
//     // Adjust font size to prevent clipping
//     final longestText = [nodeName, '${value.toStringAsFixed(2)} $unit'].reduce((a, b) => a.length > b.length ? a : b);
//     final textLength = longestText.length;
//     final baseFontSize = textSize;
//     final fontSize = textLength > 20 ? baseFontSize * 0.7 : textLength > 15 ? baseFontSize * 0.85 : baseFontSize;
//     final valueFontSize = fontSize * 0.875; // Slightly smaller for value text
//     debugPrint('SourceAndLoadBoxWidget: longestText="$longestText", baseFontSize=$baseFontSize, fontSize=$fontSize, valueFontSize=$valueFontSize');
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: loadBoxWidth,
//         height: loadBoxHeight,
//         decoration: BoxDecoration(
//           color: hexToColor(color), // Transparent if null/empty
//           border: Border.all(color: hexToColor(borderColor, isBorderOrText: true), width: 3),
//         ),
//         child: Center(
//           child: Padding(
//             padding: isVertical ? const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0) : const EdgeInsets.all(2.0),
//             child: Transform.rotate(
//               angle: isVertical ? -pi / 2 : 0,
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxWidth: isVertical ? loadBoxHeight - 4 : loadBoxWidth - 4,
//                   maxHeight: isVertical ? loadBoxWidth * 1.5 : loadBoxHeight - 4,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Flexible(
//                       child: Text(
//                         nodeName,
//                         style: TextStyle(
//                           color: hexToColor(textColor, isBorderOrText: true),
//                           fontSize: fontSize,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.center,
//                         overflow: TextOverflow.visible,
//                         softWrap: true,
//                       ),
//                     ),
//                     Flexible(
//                       child: Text(
//                         '${value.toStringAsFixed(2)} $unit',
//                         style: TextStyle(
//                           color: hexToColor(textColor, isBorderOrText: true),
//                           fontSize: valueFontSize,
//                         ),
//                         textAlign: TextAlign.center,
//                         overflow: TextOverflow.visible,
//                         softWrap: true,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:auto_size_text/auto_size_text.dart';


class ElectricityLongSourceAndLoadBoxWidget extends StatelessWidget {
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

  const ElectricityLongSourceAndLoadBoxWidget({
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
    debugPrint('SourceAndLoadBoxWidget: nodeName=$nodeName, orientation=$orientation, '
        'width=$loadBoxWidth, height=$loadBoxHeight, '
        'color=$color, borderColor=$borderColor, textColor=$textColor, textSize=$textSize');

    // Normalize orientation and check for vertical
    final isVertical = orientation.toLowerCase().trim() == 'vertical';

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: AutoSizeText(
                        nodeName,
                        style: TextStyle(
                          color: hexToColor(textColor, isBorderOrText: true),
                          fontSize: textSize,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2, // Allow up to 2 lines for nodeName
                        minFontSize: textSize * 0.5, // Minimum font size to prevent excessive shrinking
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: AutoSizeText(
                        '${value.toStringAsFixed(2)} $unit',
                        style: TextStyle(
                          color: hexToColor(textColor, isBorderOrText: true),
                          fontSize: textSize * 0.875, // Slightly smaller for value text
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1, // Single line for value
                        minFontSize: textSize * 0.5, // Minimum font size
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}