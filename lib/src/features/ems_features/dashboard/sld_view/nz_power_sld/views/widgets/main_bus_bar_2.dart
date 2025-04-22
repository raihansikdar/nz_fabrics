import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';

class MainBusBarTrue extends StatelessWidget {
  final bool sensorStatus;
  final double value;
  final String nodeName;
  final String color;
  final Color textColor;
  final double loadBoxHeight;
  final double loadBoxWidth;
  final VoidCallback onTap;
  final String unit;
  final dynamic percentage;
  final dynamic capacity;

  const MainBusBarTrue({
    Key? key,
    required this.sensorStatus,
    required this.value,
    required this.nodeName,
    required this.color,
    required this.textColor,
    required this.loadBoxHeight,
    required this.loadBoxWidth,
    required this.onTap,
    required this.unit,
    required this.percentage,
    required this.capacity,
  }) : super(key: key);


  Color hexToColor(String hex) {
    return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
  }


  @override
  Widget build(BuildContext context) {
    final double? parsedPercentage = double.tryParse(percentage ?? 0.00);

    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: loadBoxWidth,
            height: loadBoxHeight,
            decoration: BoxDecoration(
              border: Border.all(color:  hexToColor(color), width: 4), // Special border for main bus bar
            ),
            child: Stack(
              children: [

                 Container(
                    width: (loadBoxWidth * parsedPercentage! / 100).clamp(0.0, loadBoxWidth), // Full width
                    height: loadBoxHeight ,
                    decoration: BoxDecoration(
                      color: hexToColor(color),
                    ),
                  ),



                Positioned(
                  top: 5,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nodeName,
                        style: const TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                         Text(
                        '($percentage% / $capacity $unit)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${value.toStringAsFixed(2)} $unit',
                        style: const TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
        );
    }
}


