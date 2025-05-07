import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/custom_color_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/controllers/daily_water_button_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class DailyWaterListWidget extends StatelessWidget {
  final Size size;
  final DailyWaterButtonController controller;
  const DailyWaterListWidget({super.key, required this.size, required this.controller});

  @override
  Widget build(BuildContext context) {

    if(controller.isDailyWaterDataInProgress){
      return  Padding(
        padding:  EdgeInsets.only(top:size.height * 0.20),
        child: Center(
          child: SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: 50.0,
          ),
        ),
      );

    }


    if(controller.dailyWaterDataList.isEmpty){
      return  Padding(
        padding:  EdgeInsets.only(top: size.height * 0.20),
        child: Center(child: Lottie.asset(AssetsPath.emptyJson, height: size.height * 0.26)),
      );

    }
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.only(bottom: size.height * k16TextSize),
        shrinkWrap: true,
        primary: false,
        itemCount: controller.dailyWaterDataList.length,
        itemBuilder: (context, index) {
          return CustomContainer(
            height: size.height * 0.25,
            width: double.infinity,
            borderRadius: BorderRadius.circular(size.height * k16TextSize),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.height * k16TextSize,
                vertical: size.height * k8TextSize,
              ),
              child: Column(
                children: [
                  TextComponent(text: controller.dailyWaterDataList[index].node ?? ''),
                  SizedBox(height: size.height * k16TextSize),
                  _buildDataRow(size: size, label: "Pressure", value: "${controller.dailyWaterDataList[index].instantFlow?.toStringAsFixed(2) ?? '0.0'} L", textColor: const Color(0xFF793BE8), backgroundColor: const Color(0xFFf2ecfd)),
                  // SizedBox(height: size.height * k10TextSize),
                  // _buildDataRow(size: size, label: "Energy", value: controller.dailyGasDataList[index].energy.toString(), textColor: const Color(0xFFf0bb6d), backgroundColor: const Color(0xFFfdf6ea)),
                  SizedBox(height: size.height * k10TextSize),
                  _buildDataRow(size: size, label: "Cost", value: "${controller.dailyWaterDataList[index].cost?.toStringAsFixed(2) ?? '0.0'} BDT", textColor: const Color(0xFF7dcece), backgroundColor: const Color(0xFFe8f7f7)),
                  SizedBox(height: size.height * k10TextSize),
                  _buildDataRow(size: size, label: "Run Time", value: formatRuntime(controller.dailyWaterDataList[index].runtime.toString()), textColor: const Color(0xFFa67def), backgroundColor: const Color(0xFFf2ecfd)),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: size.height * k8TextSize),
      ),
    );
  }

  String formatRuntime(String runtime) {
    try {
      final parts = runtime.split(':');
      if (parts.length != 2) return '0 hrs. 0 min';

      int hours = double.parse(parts[0]).toInt();
      int minutes = double.parse(parts[1]).toInt();

      return '${hours.toString().padLeft(1, '0')} hrs. ${minutes.toString().padLeft(1, '0')} min';
    } catch (e) {
      return '0 hrs. 0 min';
    }
  }



  Widget _buildDataRow({
    required Size size,
    required String label,
    required String value,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return CustomColorContainer(
      height: size.height * 0.055,
      width: double.infinity,
      color: backgroundColor,
      size: size,
      child: Padding(
        padding: EdgeInsets.all(size.height * k16TextSize),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextComponent(
                text: label,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Center(
              child: TextComponent(
                text: ":",
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextComponent(
                  text: value,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
/// Helper method to format runtime
String _getFormattedRuntime(String totalRuntime) {
  // Check if totalRuntime is empty or invalid
  if (totalRuntime.isEmpty || !totalRuntime.contains(':')) {
    return "0 hrs. 0 min";
  }

  // Split hours and minutes using ':' separator
  List<String> parts = totalRuntime.split(':');

  // Extract hours and minutes (get integer part)
  String hours = parts[0].split('.')[0]; // Hours
  String minutes = parts[1].split('.')[0]; // Minutes

  // Return formatted string
  return "$hours hrs. $minutes min";
}

Widget _buildDataRow({
  required Size size,
  required String label,
  required String value,
  required Color textColor,
  required Color backgroundColor,
}) {
  return CustomColorContainer(
    height: size.height * 0.055,
    width: double.infinity,
    color: backgroundColor,
    size: size,
    child: Padding(
      padding: EdgeInsets.all(size.height * k16TextSize),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextComponent(
              text: label,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Center(
            child: TextComponent(
              text: ":",
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: TextComponent(
                text: value,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}