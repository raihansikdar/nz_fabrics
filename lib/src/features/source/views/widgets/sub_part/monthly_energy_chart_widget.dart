import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/source/controller/over_all_source_data_controller.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/energy_monthly_pie_chart_widget.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/sub_part/energyChartContainerWidget.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class MonthlyEnergyChartWidget extends StatelessWidget {
  const MonthlyEnergyChartWidget({
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
          child:  EnergyMonthlyPieChartWidget(size: size),
        ),
        GetBuilder<OverAllSourceDataController>(
          builder: (controller) {
            // if(controller.isFilterSpecificNodeInProgress){
            //   return CircularProgressIndicator();
            // }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  EnergyChartContainerWidget(
                    size: size,
                    color: Colors.deepPurple,
                    title: "Total",
                    energyText: "${controller.monthlyBarchartModel.individualTotals?.total?.toStringAsFixed(2) ?? '0.00'} kWh ",
                    costText: "${controller.monthlyBarchartModel.individualTotalCost?.total?.toStringAsFixed(2) ?? '0.00'} ৳ ",
                  ),
                  SizedBox(height: size.height * k8TextSize,),



                  EnergyChartContainerWidget(
                    size: size,
                    color:  Color.lerp(const Color(0xFF66D6FF), const Color(0xFF4FA3CC),0.5)!,
                    title: "Grid",
                    energyText: "${controller.monthlyBarchartModel.individualTotals?.grid?.toStringAsFixed(2) ?? '0.00'} kWh (${controller.monthlyBarchartModel.percentages?.grid?.toStringAsFixed(2) ?? '0.00'}%)",
                    costText: "${controller.monthlyBarchartModel.individualTotalCost?.grid.toStringAsFixed(2) ?? '0.00'} ৳ ",
                  ),
                  SizedBox(height: size.height * k8TextSize,),
                  EnergyChartContainerWidget(
                    size: size,
                    color: Color.lerp(const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!,
                    title: "Solar",
                    energyText: "${controller.monthlyBarchartModel.individualTotals?.solar?.toStringAsFixed(2) ?? '0.00'} kWh (${controller.monthlyBarchartModel.percentages?.solar?.toStringAsFixed(2) ?? '0.00'}%)",
                    costText: "${controller.monthlyBarchartModel.individualTotalCost?.solar?.toStringAsFixed(2) ?? '0.00'} ৳ ",
                  ),
                  SizedBox(height: size.height * k8TextSize,),
                  EnergyChartContainerWidget(
                    size: size,
                    color: Color.lerp(const Color(0xFFFFA500), const Color(0xFFFF7F00), 0.5)!,
                    title: "DG",
                    energyText: "${controller.monthlyBarchartModel.individualTotals?.dieselGenerator?.toStringAsFixed(2) ?? '0.00'} kWh (${controller.monthlyBarchartModel.percentages?.dieselGenerator?.toStringAsFixed(2) ?? '0.00'}%)",
                    costText: "${controller.monthlyBarchartModel.individualTotalCost?.dieselGenerator?.toStringAsFixed(2) ?? '0.00'} ৳ ",
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