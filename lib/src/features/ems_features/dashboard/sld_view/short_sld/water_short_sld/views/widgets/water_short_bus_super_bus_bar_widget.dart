// import 'package:flutter/material.dart';
// import 'package:nz_fabrics/src/common_widgets/text_component.dart';
// import 'package:nz_fabrics/src/utility/style/constant.dart';
// import 'dart:math';
//
// class WaterShortSuperBusBarWidget extends StatelessWidget {
//   final bool sensorStatus;
//   final double value;
//   final String nodeName;
//   final String backgroundColor;
//   final String borderColor;
//   final Color textColor;
//   final double loadBoxHeight;
//   final double loadBoxWidth;
//   final VoidCallback onTap;
//   final String unit;
//   final String gridColor;
//   final String solarColor;
//   final String generatorColor;
//   final dynamic gridPercentage;
//   final dynamic solarPercentage;
//   final dynamic generatorPercentage;
//   final dynamic gridValue;
//   final dynamic solarValue;
//   final dynamic generatorValue;
//   final double y;
//   final String orientation;
//
//   const WaterShortSuperBusBarWidget({
//     super.key,
//     required this.sensorStatus,
//     required this.value,
//     required this.nodeName,
//     required this.backgroundColor,
//     required this.borderColor,
//     required this.textColor,
//     required this.loadBoxHeight,
//     required this.loadBoxWidth,
//     required this.onTap,
//     required this.unit,
//     required this.gridColor,
//     required this.solarColor,
//     required this.generatorColor,
//     required this.gridPercentage,
//     required this.solarPercentage,
//     required this.generatorPercentage,
//     required this.gridValue,
//     required this.solarValue,
//     required this.generatorValue,
//     required this.y,
//     required this.orientation,
//   });
//
//   Color hexToColor(String hex) {
//     return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double totalPercentage = (gridPercentage + generatorPercentage + solarPercentage).toDouble();
//     totalPercentage = totalPercentage == 0 ? 1 : totalPercentage;
//
//     double normalizedGrid = (gridPercentage / totalPercentage) * 100;
//     double normalizedGenerator = (generatorPercentage / totalPercentage) * 100;
//     double normalizedSolar = (solarPercentage / totalPercentage) * 100;
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: loadBoxWidth,
//         height: loadBoxHeight,
//         decoration: BoxDecoration(
//           border: Border.all(color: hexToColor(borderColor), width: 2),
//         ),
//         child: Stack(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   flex: normalizedGrid.toInt(),
//                   child: Container(
//                     color: hexToColor(gridColor),
//                   ),
//                 ),
//                 Expanded(
//                   flex: normalizedGenerator.toInt(),
//                   child: Container(
//                     color: hexToColor(generatorColor),
//                   ),
//                 ),
//                 Expanded(
//                   flex: normalizedSolar.toInt(),
//                   child: Container(
//                     color: hexToColor(solarColor),
//                   ),
//                 ),
//               ],
//             ),
//             Center(
//               child: Transform.rotate(
//                 angle: orientation == 'vertical' ? -pi / 2 : 0,
//                 child: Text(
//                   nodeName,
//                   style: TextStyle(
//                     color: textColor,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Align(
//                 alignment: Alignment.center,
//                 child: Transform.rotate(
//                   angle: orientation == 'vertical' ? -pi / 2 : 0,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (gridPercentage > 0.00)
//                         Row(
//                           children: [
//                             Container(
//                               transform: Matrix4.translationValues(0, y, 0),
//                               height: 20,
//                               width: 20,
//                               decoration: BoxDecoration(
//                                 color: hexToColor(gridColor),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Container(
//                               transform: Matrix4.translationValues(0, y, 0),
//                               child: const TextComponent(
//                                 text: 'Grid: ',
//                                 fontFamily: boldFontFamily,
//                               ),
//                             ),
//                             Container(
//                               transform: Matrix4.translationValues(0, y, 0),
//                               child: TextComponent(
//                                 text:
//                                 "${gridValue.toStringAsFixed(2)} kW (${gridPercentage.toStringAsFixed(2)}%)",
//                                 fontFamily: boldFontFamily,
//                               ),
//                             ),
//                           ],
//                         ),
//                       const SizedBox(width: 15),
//                       if (solarPercentage > 0.00)
//                         Row(
//                           children: [
//                             Container(
//                               transform: Matrix4.translationValues(0, y, 0),
//                               height: 20,
//                               width: 20,
//                               decoration: BoxDecoration(
//                                 color: hexToColor(solarColor),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Container(
//                               transform: Matrix4.translationValues(0, y, 0),
//                               child: const TextComponent(
//                                 text: 'Solar: ',
//                                 fontFamily: boldFontFamily,
//                               ),
//                             ),
//                             Container(
//                               transform: Matrix4.translationValues(0, y, 0),
//                               child: TextComponent(
//                                 text:
//                                 "${solarValue.toStringAsFixed(2)} kW (${solarPercentage.toStringAsFixed(2)}%)",
//                                 fontFamily: boldFontFamily,
//                               ),
//                             ),
//                           ],
//                         ),
//                       const SizedBox(width: 15),
//                       if (generatorPercentage > 0.00)
//                         Row(
//                           children: [
//                             Container(
//                               transform: Matrix4.translationValues(0, y, 0),
//                               height: 20,
//                               width: 20,
//                               decoration: BoxDecoration(
//                                 color: hexToColor(generatorColor),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Container(
//                               transform: Matrix4.translationValues(0, y, 0),
//                               child: const TextComponent(
//                                 text: 'Generator: ',
//                                 fontFamily: boldFontFamily,
//                               ),
//                             ),
//                             Container(
//                               transform: Matrix4.translationValues(0, y, 0),
//                               child: TextComponent(
//                                 text:
//                                 "${generatorValue.toStringAsFixed(2)} kW (${generatorPercentage.toStringAsFixed(2)}%)",
//                                 fontFamily: boldFontFamily,
//                               ),
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:math';

class WaterShortSuperBusBarWidget extends StatelessWidget {
  final bool sensorStatus;
  final double value;
  final String nodeName;
  final String backgroundColor;
  final String borderColor;
  final Color textColor;
  final double loadBoxHeight;
  final double loadBoxWidth;
  final VoidCallback onTap;
  final String unit;
  final String gridColor;
  final String solarColor;
  final String generatorColor;
  final dynamic gridPercentage;
  final dynamic solarPercentage;
  final dynamic generatorPercentage;
  final dynamic gridValue;
  final dynamic solarValue;
  final dynamic generatorValue;
  final double y;
  final String orientation;

  const WaterShortSuperBusBarWidget({
    super.key,
    required this.sensorStatus,
    required this.value,
    required this.nodeName,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.loadBoxHeight,
    required this.loadBoxWidth,
    required this.onTap,
    required this.unit,
    required this.gridColor,
    required this.solarColor,
    required this.generatorColor,
    required this.gridPercentage,
    required this.solarPercentage,
    required this.generatorPercentage,
    required this.gridValue,
    required this.solarValue,
    required this.generatorValue,
    required this.y,
    required this.orientation,
  });

  Color hexToColor(String hex) {
    return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
  }

  @override
  Widget build(BuildContext context) {
    double totalPercentage = (gridPercentage + generatorPercentage + solarPercentage).toDouble();
    totalPercentage = totalPercentage == 0 ? 1 : totalPercentage;

    double normalizedGrid = (gridPercentage / totalPercentage) * 100;
    double normalizedGenerator = (generatorPercentage / totalPercentage) * 100;
    double normalizedSolar = (solarPercentage / totalPercentage) * 100;

    // Normalize orientation for case-insensitive comparison
    final normalizedOrientation = orientation.toLowerCase();
    final effectiveWidth = loadBoxWidth;
    final effectiveHeight = loadBoxHeight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: effectiveWidth,
        height: effectiveHeight,
        decoration: BoxDecoration(
          border: Border.all(color: hexToColor(borderColor), width: 2),
        ),
        child: Stack(
          children: [
            // Colored bars (always horizontal)
            Row(
              children: [
                Expanded(
                  flex: normalizedGrid.toInt(),
                  child: Container(
                    color: hexToColor(gridColor),
                  ),
                ),
                Expanded(
                  flex: normalizedGenerator.toInt(),
                  child: Container(
                    color: hexToColor(generatorColor),
                  ),
                ),
                Expanded(
                  flex: normalizedSolar.toInt(),
                  child: Container(
                    color: hexToColor(solarColor),
                  ),
                ),
              ],
            ),
            // Node name and value text (rotated if vertical)
            Center(
              child: Transform.rotate(
                angle: normalizedOrientation == 'vertical' ? -pi / 2 : 0,
                alignment: Alignment.center,
                child: Container(
                  width: effectiveWidth,
                  height: effectiveHeight * 0.6, // Limit to 60% of height
                  padding: const EdgeInsets.all(2.0), // Reduced padding
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: effectiveHeight * 0.6 - 4, // Account for padding
                      maxWidth: effectiveWidth - 4,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: AutoSizeText(
                            nodeName,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            minFontSize: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 2), // Reduced spacing
                        Flexible(
                          child: AutoSizeText(
                            '${value.toStringAsFixed(2)} $unit',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            minFontSize: 8,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom text (Grid, Solar, Generator info, rotated if vertical)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: normalizedOrientation == 'vertical' ? -pi / 2 : 0,
                  alignment: Alignment.center,
                  child: Container(
                    width: effectiveWidth,
                    height: effectiveHeight * 0.4, // Limit to 40% of height
                    padding: const EdgeInsets.all(4.0), // Reduced padding
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: effectiveHeight * 0.4 - 8, // Account for padding
                        maxWidth: effectiveWidth - 8,
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8, // Reduced from 15
                        runSpacing: 5, // Reduced from 10
                        children: [
                          if (gridPercentage > 0.00)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0, y, 0),
                                  height: 16, // Reduced size
                                  width: 16,
                                  decoration: BoxDecoration(
                                    color: hexToColor(gridColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(width: 6), // Reduced spacing
                                Flexible(
                                  child: AutoSizeText(
                                    'Grid: ${gridValue.toStringAsFixed(2)} kW (${gridPercentage.toStringAsFixed(2)}%)',
                                    style: const TextStyle(
                                      fontFamily: 'boldFontFamily',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    minFontSize: 8,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          if (solarPercentage > 0.00)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0, y, 0),
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                    color: hexToColor(solarColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: AutoSizeText(
                                    'Solar: ${solarValue.toStringAsFixed(2)} kW (${solarPercentage.toStringAsFixed(2)}%)',
                                    style: const TextStyle(
                                      fontFamily: 'boldFontFamily',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    minFontSize: 8,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          if (generatorPercentage > 0.00)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  transform: Matrix4.translationValues(0, y, 0),
                                  height: 16,
                                  width: 16,
                                  decoration: BoxDecoration(
                                    color: hexToColor(generatorColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: AutoSizeText(
                                    'Generator: ${generatorValue.toStringAsFixed(2)} kW (${generatorPercentage.toStringAsFixed(2)}%)',
                                    style: const TextStyle(
                                      fontFamily: 'boldFontFamily',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    minFontSize: 8,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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