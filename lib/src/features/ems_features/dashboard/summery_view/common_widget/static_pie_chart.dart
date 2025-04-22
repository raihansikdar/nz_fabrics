import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StaticPieChart extends StatelessWidget {
  const StaticPieChart({
    super.key,
    required this.size,
    required TooltipBehavior tooltipBehavior,
    required this.chartData, required this.titleText, required this.unitText
  }) : _tooltipBehavior = tooltipBehavior;

  final Size size;
  final TooltipBehavior _tooltipBehavior;
  final List<ChartData> chartData;
  final String titleText;
  final String? unitText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox(
          height: size.height * .2,
          child: SfCircularChart(
            tooltipBehavior: _tooltipBehavior,
            series: <CircularSeries>[
              DoughnutSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                pointColorMapper: (ChartData data, int index) =>
                //colorPalette[index % colorPalette.length],
               Colors.blue[700],
                innerRadius: '80%',

              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: size.height * k16TextSize),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style:  TextStyle(
                fontSize: size.height * k14TextSize,
                color: Colors.black, // or any color you prefer
              ),
              children: [
                TextSpan(
                  text: '$titleText \n',
                  style: TextStyle(
                    fontSize: size.height * k15TextSize,
                    color:  Colors.grey ,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(
                  text: "0.00\n",
                  style:  TextStyle(
                    fontSize: size.height * k18TextSize,
                    color: AppColors.primaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                TextSpan(
                  text: unitText,
                  style: TextStyle(
                    fontSize: size.height * k14TextSize,
                    color:  Colors.grey ,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}