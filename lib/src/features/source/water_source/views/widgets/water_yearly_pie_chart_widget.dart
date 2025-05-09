// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:nz_fabrics/src/common_widgets/text_component.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
// import 'package:nz_fabrics/src/features/water_source/controller/over_all_source_water_data_controller.dart';
//
// class EnergyYearlyPieChartWidget extends StatelessWidget {
//   final Size size;
//
//   const EnergyYearlyPieChartWidget({super.key, required this.size});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<OverAllWaterSourceDataController>(
//       builder: (controller) {
//         if (controller.isFilterSpecificNodeInProgress) {
//           return Center(
//             child: Lottie.asset(
//               AssetsPath.loadingJson,
//               height: size.height * 0.12,
//             ),
//           );
//         }
//
//         if (controller.yearlyBarChartModel.data == null || controller.yearlyBarChartModel.data!.isEmpty) {
//           return Center(
//             child: TextComponent(
//               text: "No data available",
//               color: Colors.grey.shade500,
//             ),
//           );
//         }
//         final percentages = controller.yearlyBarChartModel.percentages;
//         final List<ChartData> chartData = [
//           ChartData('Grid', percentages?.grid?.toDouble() ?? 0.0, Color.lerp(const Color(0xFF66D6FF), const Color(0xFF4FA3CC),0.5)!),
//           ChartData('Solar', percentages?.solar?.toDouble() ?? 0.0, Color.lerp(const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!),
//           ChartData('Diesel Generator', percentages?.dieselGenerator?.toDouble() ?? 0.0, Color.lerp(const Color(0xFFFFA500), const Color(0xFFFF7F00), 0.5)!),
//         ];
//         return SfCircularChart(
//             margin: EdgeInsets.zero,
//           tooltipBehavior: TooltipBehavior(enable: true),
//           legend: const Legend(isVisible: true, position: LegendPosition.bottom,),
//           series: <CircularSeries>[
//             PieSeries<ChartData, String>(
//               enableTooltip: true,
//               dataSource: chartData,
//               xValueMapper: (ChartData data, _) => data.x,
//               yValueMapper: (ChartData data, _) => data.y,
//               pointColorMapper: (ChartData data, _) => data.color,
//               dataLabelSettings: const DataLabelSettings(
//                 textStyle: TextStyle(
//                   color: Colors.white,
//                   fontSize: 13
//                 ),
//               ),
//                 dataLabelMapper: (ChartData data, _) {
//                   return data.y.toStringAsFixed(2);
//                 }
//
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class ChartData {
//   final String x;
//   final double y;
//   final Color color;
//
//   ChartData(this.x, this.y, this.color);
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/features/source/water_source/controller/over_all_source_water_data_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';

class WaterYearlyPieChartWidget extends StatelessWidget {
  final Size size;

  const WaterYearlyPieChartWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OverAllWaterSourceDataController>(
      builder: (controller) {
        if (controller.isFilterSpecificNodeInProgress) {
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

        final percentages = controller.yearlyBarChartModel.percentages;

        if (percentages == null || percentages.values == null || percentages.values!.isEmpty) {
          print('No percentages data available: ${percentages?.toJson()}');
          return const Center(child: Text("No data available"));
        }

        final List<ChartData> chartData = [
       //   ChartData('Total Source', double.tryParse(percentages.values!['Total_Source']?.toString() ?? '0') ?? 0.0, Color.lerp(const Color(0xFF66D6FF), const Color(0xFF4FA3CC), 0.5)!),
          ChartData('Sub Mersible', double.tryParse(percentages.values!['Sub_Mersible']?.toString() ?? '0') ?? 0.0, Color.lerp(const Color(0xFFC5A4FF), const Color(0xFF9F77CC), 0.5)!),
          ChartData('WTP', double.tryParse(percentages.values!['WTP']?.toString() ?? '0') ?? 0.0, Color.lerp(const Color(0xFFFFA500), const Color(0xFFFF7F00), 0.5)!),
        ];

        print('ChartData: ${chartData.map((e) => '${e.x}: ${e.y}').toList()}');

        if (chartData.every((data) => data.y == 0.0)) {
          return const Center(child: Text("All data values are zero"));
        }

        return SfCircularChart(
          margin: EdgeInsets.zero,
          tooltipBehavior: TooltipBehavior(enable: true),
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          series: <CircularSeries>[
            PieSeries<ChartData, String>(
              enableTooltip: true,
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              pointColorMapper: (ChartData data, _) => data.color,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(color: Colors.white, fontSize: 13),
              ),
              dataLabelMapper: (ChartData data, _) => data.y.toStringAsFixed(2),
            ),
          ],
        );
      },
    );
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData(this.x, this.y, this.color);
}