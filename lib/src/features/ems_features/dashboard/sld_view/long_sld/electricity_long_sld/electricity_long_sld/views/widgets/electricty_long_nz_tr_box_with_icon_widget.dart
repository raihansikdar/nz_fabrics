import 'package:flutter/material.dart';



class ElectrictyLongTrBoxWithIconWidget extends StatelessWidget {
  final double value;
  final IconData icon;
  final String label;
  final double width;
  final double height;
  final String unit;
  final VoidCallback onTap;
  final bool sensorStatus;
  final String borderColor;
  final dynamic percentage;
  final dynamic capacity;

  const ElectrictyLongTrBoxWithIconWidget({
    super.key,
    required this.value,
    required this.icon,
    required this.label,
    required this.width,
    required this.height,
    required this.onTap,
    required this.unit,
    required this.sensorStatus,
    required this.borderColor,
    required this.percentage,
    required this.capacity,
  });

  Color hexToColor(String hex) {
    return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
  }

  @override
  Widget build(BuildContext context) {
    final double? parsedPercentage = double.tryParse(percentage ?? 0.00);

    double minDimension = width < height ? width : height;
    double iconSize = minDimension * 0.2;
    double fontSize = minDimension * 0.15;
    Size size = MediaQuery.of(context).size;


    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height  ,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: hexToColor(borderColor), width: 3),
        ),
        child: Stack(
          children: [
            Container(
              width: (width * parsedPercentage! / 100).clamp(0.0, width),
              height: height ,
              decoration: BoxDecoration(
                color: hexToColor(borderColor),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if(percentage != "0.00")
                    Flexible(
                      child: Text(
                        '($percentage% / $capacity $unit)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: fontSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  Flexible(
                    child: Text(
                      '${value.toStringAsFixed(2)} $unit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: fontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
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