import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/source/water_source/controller/over_all_source_water_data_controller.dart';
import 'package:nz_fabrics/src/features/source/water_source/views/widgets/sub_part/waterChartContainerWidget.dart';
import 'package:nz_fabrics/src/features/source/water_source/views/widgets/water_line_pie_chart_widget.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class LineWaterChartWidget extends StatelessWidget {
  const LineWaterChartWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.27,
          child: WaterLinePieChartWidget(size: size),
        ),
        GetBuilder<OverAllWaterSourceDataController>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  WaterChartContainerWidget(
                    size: size,
                    color: Colors.deepPurpleAccent,
                    title: "Total",
                    energyText: "${controller.lineChartModel.individualTotals?.values?['Total']?.toStringAsFixed(2) ?? '0.00'} m³",
                    costText: "${controller.lineChartModel.individualTotalCost?.values?['Total']?.toStringAsFixed(2) ?? '0.00'} ৳",
                  ),
                  // SizedBox(height: size.height * k8TextSize),
                  // EnergyChartContainerWidget(
                  //   size: size,
                  //   color: Color.lerp(const Color(0xFF66D6FF), const Color(0xFF4FA3CC), 0.5)!,
                  //   title: "Total Source",
                  //   energyText: "${controller.lineChartModel.individualTotals?.values?['Total_Source']?.toStringAsFixed(2) ?? '0.00'} m³ (${controller.lineChartModel.percentages?.values?['Total_Source']?.toStringAsFixed(2) ?? '0.00'}%)",
                  //   costText: "${controller.lineChartModel.individualTotalCost?.values?['Total_Source']?.toStringAsFixed(2) ?? '0.00'} ৳",
                  // ),
                  SizedBox(height: size.height * k8TextSize),
                  WaterChartContainerWidget(
                    size: size,
                    color: Color.lerp(const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!,
                    title: "Sub Mersible",
                    energyText: "${controller.lineChartModel.individualTotals?.values?['Sub_Mersible']?.toStringAsFixed(2) ?? '0.00'} m³ (${controller.lineChartModel.percentages?.values?['Sub_Mersible']?.toStringAsFixed(2) ?? '0.00'}%)",
                    costText: "${controller.lineChartModel.individualTotalCost?.values?['Sub_Mersible']?.toStringAsFixed(2) ?? '0.00'} ৳",
                  ),
                  SizedBox(height: size.height * k8TextSize),
                  WaterChartContainerWidget(
                    size: size,
                    color: Color.lerp(const Color(0xFFFFA500), const Color(0xFFFF7F00), 0.5)!,
                    title: "WTP",
                    energyText: "${controller.lineChartModel.individualTotals?.values?['WTP']?.toStringAsFixed(2) ?? '0.00'} m³ (${controller.lineChartModel.percentages?.values?['WTP']?.toStringAsFixed(2) ?? '0.00'}%)",
                    costText: "${controller.lineChartModel.individualTotalCost?.values?['WTP']?.toStringAsFixed(2) ?? '0.00'} ৳",
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}