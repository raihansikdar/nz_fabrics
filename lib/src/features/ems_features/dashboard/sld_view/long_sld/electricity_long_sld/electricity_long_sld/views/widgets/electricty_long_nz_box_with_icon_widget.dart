import 'package:flutter/material.dart';



class ElectricityLongBoxWithIconWidget extends StatelessWidget {
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

  const ElectricityLongBoxWithIconWidget({
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

    double minDimension = width < height ? width : height;
    double iconSize = minDimension * 0.2;
    double fontSize = minDimension * 0.15;
    Size size = MediaQuery.of(context).size;

    // Set border color based on sensorStatus
  //  Color borderColor = sensorStatus ? const Color(0xFF3CB64A) : Colors.red;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height+5  ,
        padding: EdgeInsets.all(size.height * 0.01), // Adjust as needed
        decoration: BoxDecoration(
          color: Colors.white,
         // borderRadius: BorderRadius.circular(size.height * 0.01), // Adjust as needed
          border: Border.all(color: hexToColor(borderColor), width: 3), // Border color changes here
        ),
        child: Center(
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
      ),
    );
  }
}

