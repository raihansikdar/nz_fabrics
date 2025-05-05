
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';

class SteamShortCircleWithIcon extends StatelessWidget {
  final double value;
  final IconData icon;
  final String text;
  final double width;
  final double height;
  final VoidCallback onTap;
  final String unit;
  final bool sensorStatus;
  final String borderColor;

  const SteamShortCircleWithIcon({
    required this.value,
    required this.icon,
    required this.text,
    required this.width,
    required this.height,
    required this.onTap,
    required this.unit,
    required this.sensorStatus,
    required this.borderColor,
    super.key,
  });

  Color hexToColor(String hex) {
    return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
  }

  @override
  Widget build(BuildContext context) {
    double diameter = width < height ? width : height;

    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: diameter,
            height: diameter,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: hexToColor(borderColor), width: 2.5),
            ),

            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: AutoSizeText(
                      '${value.toStringAsFixed(2)} $unit',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      minFontSize: 6,
                      stepGranularity: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: AutoSizeText(
                      text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      minFontSize: 6,
                      stepGranularity: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            ),
        );
    }
}