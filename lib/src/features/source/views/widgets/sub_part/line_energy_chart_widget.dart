import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/source/controller/over_all_source_data_controller.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/energy_line_pie_chart_widget.dart';
import 'package:nz_fabrics/src/features/source/views/widgets/sub_part/energyChartContainerWidget.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class LineEnergyChartWidget extends StatelessWidget {
  const LineEnergyChartWidget({
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
          child:  EnergyLinePieChartWidget(size: size),
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
                    color: Colors.deepPurpleAccent,
                    title: "Total",
                    energyText: "${controller.lineChartModel.individualTotals?.total?.toStringAsFixed(2) ?? '0.00'} kWh ",
                    costText: "${controller.lineChartModel.individualTotalCost?.total?.toStringAsFixed(2) ?? '0.00'} ৳ ",
                  ),
                  SizedBox(height: size.height * k8TextSize,),


                  EnergyChartContainerWidget(
                    size: size,
                    color: Color.lerp(const Color(0xFF66D6FF), const Color(0xFF4FA3CC),0.5)!,
                    title: "Grid",
                    energyText: "${controller.lineChartModel.individualTotals?.grid?.toStringAsFixed(2) ?? '0.00'} kWh (${controller.lineChartModel.percentages?.grid?.toStringAsFixed(2) ?? '0.00'}%)",
                    costText: "${controller.lineChartModel.individualTotalCost?.grid.toStringAsFixed(2) ?? '0.00'} ৳ ",
                  ),
                  SizedBox(height: size.height * k8TextSize,),
                  EnergyChartContainerWidget(
                    size: size,
                    color: Color.lerp(const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!,
                    title: "Solar",
                    energyText: "${controller.lineChartModel.individualTotals?.solar?.toStringAsFixed(2) ?? '0.00'} kWh (${controller.lineChartModel.percentages?.solar?.toStringAsFixed(2) ?? '0.00'}%)",
                    costText: "${controller.lineChartModel.individualTotalCost?.solar?.toStringAsFixed(2) ?? '0.00'} ৳ ",
                  ),
                  SizedBox(height: size.height * k8TextSize,),
                  EnergyChartContainerWidget(
                    size: size,
                    color:Color.lerp(const Color(0xFFFFA500), const Color(0xFFFF7F00), 0.5)!,
                    title: "DG",
                    energyText: "${controller.lineChartModel.individualTotals?.dieselGenerator?.toStringAsFixed(2) ?? '0.00'} kWh (${controller.lineChartModel.percentages?.dieselGenerator?.toStringAsFixed(2) ?? '0.00'}%)",
                    costText: "${controller.lineChartModel.individualTotalCost?.dieselGenerator?.toStringAsFixed(2) ?? '0.00'} ৳ ",
                  ),


                ],
              ),
            );

            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: size.height * 0.010,
                          width: size.height * 0.010,
                          decoration: BoxDecoration(
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(size.height * 0.005)
                          ),
                        ),
                        SizedBox(width: size.width * 0.010),
                        const TextComponent(text: "Total", color: AppColors.secondaryTextColor),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: size.height * 0.010,
                          width: size.height * 0.010,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(size.height * 0.005)
                          ),
                        ),
                        SizedBox(width: size.width * 0.010),
                        const TextComponent(text: "Grid", color: AppColors.secondaryTextColor),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: size.height * 0.010,
                          width: size.height * 0.010,
                          decoration: BoxDecoration(
                              color: Colors.tealAccent,
                              borderRadius: BorderRadius.circular(size.height * 0.005)
                          ),
                        ),
                        SizedBox(width: size.width * 0.010),
                        const TextComponent(text: "Diesel Gen", color: AppColors.secondaryTextColor),
                      ],
                    ),

                    Row(
                      children: [
                        Container(
                          height: size.height * 0.010,
                          width: size.height * 0.010,
                          decoration: BoxDecoration(
                              color: Colors.lightGreenAccent,
                              borderRadius: BorderRadius.circular(size.height * 0.005)
                          ),
                        ),
                        SizedBox(width: size.width * 0.010),
                        const TextComponent(text: "Solar", color: AppColors.secondaryTextColor),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: size.width * 0.03),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextComponent(text: ":"),
                    TextComponent(text: ":"),
                    TextComponent(text: ":"),
                    TextComponent(text: ":"),
                  ],
                ),
                SizedBox(width: size.width * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.65,
                      child: TextComponent(
                        text: "${controller.lineChartModel.individualTotals?.total?.toStringAsFixed(2) ?? '0.00'} kWh || ${controller.lineChartModel.individualTotalCost?.total?.toStringAsFixed(2) ?? '0.00'} ৳ ",
                        fontFamily: semiBoldFontFamily,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.65,
                      child: TextComponent(
                        text: "${controller.lineChartModel.individualTotals?.grid?.toStringAsFixed(2) ?? '0.00'} kWh (${controller.lineChartModel.percentages?.grid?.toStringAsFixed(2) ?? '0.00'}%) || ${controller.lineChartModel.individualTotalCost?.grid?.toStringAsFixed(2) ?? '0.00'} ৳",
                        fontFamily: semiBoldFontFamily,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.65,
                      child: TextComponent(
                        text: "${controller.lineChartModel.individualTotals?.dieselGenerator?.toStringAsFixed(2) ?? '0.00'} kWh (${controller.lineChartModel.percentages?.dieselGenerator?.toStringAsFixed(2) ?? '0.00'}%) || ${controller.lineChartModel.individualTotalCost?.dieselGenerator?.toStringAsFixed(2) ?? '0.00'} ৳",
                        fontFamily: semiBoldFontFamily,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(
                      width: size.width * 0.65,
                      child: TextComponent(
                        text: "${controller.lineChartModel.individualTotals?.solar?.toStringAsFixed(2) ?? '0.00'} kWh (${controller.lineChartModel.percentages?.solar?.toStringAsFixed(2) ?? '0.00'}%) || ${controller.lineChartModel.individualTotalCost?.solar?.toStringAsFixed(2) ?? '0.00'} ৳",
                        fontFamily: semiBoldFontFamily,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  ],
                ),

              ],
            );*/
          },
        ),
      ],
    );
  }
}