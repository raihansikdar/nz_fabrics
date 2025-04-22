import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class SuperBusBarWidget extends StatelessWidget {
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

  const SuperBusBarWidget({
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
  });


  Color hexToColor(String hex) {
    return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
  }



  @override
  Widget build(BuildContext context) {

    double totalPercentage = gridPercentage + generatorPercentage + solarPercentage;

    if (totalPercentage == 0) {
      totalPercentage = 1;
    }

    double normalizedGrid = (gridPercentage / totalPercentage) * 100;
    double normalizedGenerator = (generatorPercentage / totalPercentage) * 100;
    double normalizedSolar = (solarPercentage / totalPercentage) * 100;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: loadBoxWidth,
        height: loadBoxHeight,
        decoration: BoxDecoration(
          border: Border.all(color: hexToColor(borderColor), width: 2),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                // Grid Percentage
                Expanded(
                  flex: normalizedGrid.toInt(),
                  child: Container(
                    color: hexToColor(gridColor),
                  ),
                ),
                // Generator Percentage
                Expanded(
                  flex: normalizedGenerator.toInt(),
                  child: Container(
                    color: hexToColor(generatorColor),
                  ),
                ),
                // Solar Percentage
                Expanded(
                  flex: normalizedSolar.toInt(),
                  child: Container(
                    color: hexToColor(solarColor),
                  ),
                ),
              ],
            ),
            Center(
              child: Text(
                nodeName,
                style: TextStyle(color: textColor, fontSize: 18,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               if(gridPercentage > 0.00)
                 Row(
                   children: [
                     Container(
                       transform: Matrix4.translationValues(0, y, 0),
                       height: 20,
                       width: 20,
                       decoration: BoxDecoration(
                           color: hexToColor(gridColor),
                           borderRadius: BorderRadius.circular(10)
                       ),
                     ),
                     const SizedBox(width: 10,),
                     Container(
                       transform: Matrix4.translationValues(0, y, 0),
                       child: const TextComponent(text: 'Grid: ',fontFamily: boldFontFamily,),
                     ),
                     Container(
                       transform: Matrix4.translationValues(0, y, 0),
                       child:  TextComponent(text: "${gridValue.toStringAsFixed(2)} kW (${gridPercentage.toStringAsFixed(2)}%)",fontFamily: boldFontFamily,),
                     ),
                   ],
                 ),
                const SizedBox(width: 15,),
                if(solarPercentage > 0.00)
                  Row(
                    children: [
                      Container(
                        transform: Matrix4.translationValues(0, y, 0),
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            color: hexToColor(solarColor),
                            borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Container(
                        transform: Matrix4.translationValues(0, y, 0),
                        child: const TextComponent(text: 'Solar: ',fontFamily: boldFontFamily,),
                      ),
                      Container(
                        transform: Matrix4.translationValues(0, y, 0),
                        child:  TextComponent(text: "${solarValue.toStringAsFixed(2)} kW (${solarPercentage.toStringAsFixed(2)}%)",fontFamily: boldFontFamily,),
                      ),
                    ],
                  ),
                const SizedBox(width: 15,),
               if(generatorPercentage > 0.00)
                 Row(
                   children: [
                     Container(
                       transform: Matrix4.translationValues(0, y, 0),
                       height: 20,
                       width: 20,
                       decoration: BoxDecoration(
                           color: hexToColor(generatorColor),
                           borderRadius: BorderRadius.circular(10)
                       ),
                     ),
                     const SizedBox(width: 10,),
                     Container(
                       transform: Matrix4.translationValues(0, y, 0),
                       child: const TextComponent(text: 'Generator: ',fontFamily: boldFontFamily,),
                     ),
                     Container(
                       transform: Matrix4.translationValues(0, y, 0),
                       child:  TextComponent(text: "${generatorValue.toStringAsFixed(2)} kW (${generatorPercentage.toStringAsFixed(2)}%)",fontFamily: boldFontFamily,),
                     ),
                   ],
                 ),
              ],
            ),
          ),
        )

          ],
        ),
      ),
    );
  }
}


