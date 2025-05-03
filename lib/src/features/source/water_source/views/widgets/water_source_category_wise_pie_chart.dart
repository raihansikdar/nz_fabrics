import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/features/source/water_source/controller/water_source_category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';

import '../../model/source_category_wise_live_data_model.dart';

class WaterSourceCategoryWisePieChart extends StatelessWidget {
  final Size size;

  const WaterSourceCategoryWisePieChart({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WaterSourceCategoryWiseLiveDataController>(
      builder: (controller) {
        if (controller.isSourceCategoryInProgress) {
          return Center(
            child: Lottie.asset(
              AssetsPath.loadingJson,
              height: size.height * 0.12,
            ),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage));
        }

        final List<SourceCategoryWiseLiveDataModel> timeUsage =
            controller.sourceCategoryWiseLiveDataModel.data ?? [];


        final List<ChartData> chartData = timeUsage
            .where((item) => item.category == "Sub_Mersible" || item.category == "WTP")
            .map((item) {
          Color color;
          switch (item.category) {
            case "Sub_Mersible":
              color = Color.lerp(const Color(0xFF66D6FF), const Color(0xFF4FA3CC), 0.5)!;
              break;
            case "WTP":
              color = Color.lerp(const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!;
              break;
            default:
              color = Colors.grey;
          }
          return ChartData(
            item.category, // Non-nullable, so no need for ?? ""
            item.totalInstantFlow ?? 0.0, // Use total_instant_flow for chart value
            color,
          );
        }).toList();

        return SfCircularChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          series: <CircularSeries>[
            PieSeries<ChartData, String>(
              enableTooltip: true,
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              pointColorMapper: (ChartData data, _) => data.color,
              //dataLabelSettings: const DataLabelSettings(isVisible: true),
              // dataLabelMapper: (ChartData data, _) {
              //   final total = chartData.fold<double>(0, (sum, item) => sum + item.y);
              //   final percentage = (data.y / total) * 100;
              //   return '${percentage.toStringAsFixed(1)}%';
              // },
            ),
          ],
        );
      },
    );
  }
}

class ChartData {
  final String x;
  final dynamic y;
  final Color color;

  ChartData(this.x, this.y, this.color);
}

