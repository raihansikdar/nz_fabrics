import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class GaugeWidget extends StatefulWidget {
  final double gaugeValue;
  final double gaugeMaxValue;
  const GaugeWidget({super.key, required this.gaugeValue, required this.gaugeMaxValue});

  @override
  GaugeWidgetState createState() => GaugeWidgetState();
}

class GaugeWidgetState extends State<GaugeWidget> {
  // final double _totalPower = 150.33;

  @override
  Widget build(BuildContext context) {
    Size  size = MediaQuery.of(context).size;
    return  SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration: 1000,
      axes: <RadialAxis>[
        RadialAxis(
          startAngle: 180,
          endAngle: 360,
          canScaleToFit: true,
          interval: widget.gaugeMaxValue >  1800 ? 600 : (widget.gaugeMaxValue <=  1800 && widget.gaugeMaxValue >  1000) ? 300 :(widget.gaugeMaxValue <=  1000 && widget.gaugeMaxValue >  500) ? 200 : (widget.gaugeMaxValue <=  500 && widget.gaugeMaxValue >=  250) ? 100 : 50,
          minimum: 0,
          maximum: widget.gaugeMaxValue,
          //labelFormat: '{value} kW',
          showLastLabel: true,
          showLabels: true,
          labelOffset: size. height * k13TextSize,
          radiusFactor: 1.30,
          majorTickStyle: const MajorTickStyle(
            length: 0.1,
            lengthUnit: GaugeSizeUnit.factor,
          ),
          minorTicksPerInterval: 1,
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              // startWidth: 11,
              // endWidth: 11,
              endValue: widget.gaugeValue, ///// api value will add here
              color: AppColors.primaryColor,
            ),
          ],
          pointers: <GaugePointer>[

            NeedlePointer(
              needleColor:AppColors.primaryColor,
              lengthUnit: GaugeSizeUnit.factor,
              needleLength: 0.50,
              needleStartWidth: 0.6,
              needleEndWidth: 5,
              knobStyle: const KnobStyle(
                knobRadius: 4,
                sizeUnit: GaugeSizeUnit.logicalPixel,
                color: AppColors.whiteTextColor,
                borderColor: AppColors.primaryColor,
                borderWidth: 2,
              ),
              value: widget.gaugeValue, /// api value add here
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                '',
                style: TextStyle(
                  fontSize: size.height * 13,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              angle: 90,
              positionFactor: 0.2,
            ),
          ],
        ),
      ],
    );
  }
}