import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/custom_color_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/controllers/daily_natural_gas_button_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class DailyNaturalGasListWidget extends StatelessWidget {
  final Size size;
  final DailyNaturalGasButtonController controller;
  const DailyNaturalGasListWidget({super.key, required this.size, required this.controller});

  @override
  Widget build(BuildContext context) {

    if(controller.isDailyGasGeneratorDataInProgress){
      return  Padding(
        padding:  EdgeInsets.only(top:size.height * 0.20),
        child: Center(child: Lottie.asset(AssetsPath.loadingJson, height: size.height * 0.12)),
      );

    }


    if(controller.dailyNaturalGasDataList.isEmpty){
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
        itemCount: controller.dailyNaturalGasDataList.length,
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
                  TextComponent(text: controller.dailyNaturalGasDataList[index].node ?? ''),
                  SizedBox(height: size.height * k16TextSize),
                  _buildDataRow(size: size, label: "Pressure", value: "${controller.dailyNaturalGasDataList[index].instantFlow ?? "0.0"} cf", textColor: const Color(0xFF793BE8), backgroundColor: const Color(0xFFf2ecfd)),
                  // SizedBox(height: size.height * k10TextSize),
                  // _buildDataRow(size: size, label: "Energy", value: controller.dailyGasDataList[index].energy.toString(), textColor: const Color(0xFFf0bb6d), backgroundColor: const Color(0xFFfdf6ea)),
                  SizedBox(height: size.height * k10TextSize),
                  _buildDataRow(size: size, label: "Cost", value: "${controller.dailyNaturalGasDataList[index].cost ?? "0.0"} BDT", textColor: const Color(0xFF7dcece), backgroundColor: const Color(0xFFe8f7f7)),
                  SizedBox(height: size.height * k10TextSize),
                  _buildDataRow(size: size, label: "Run Time", value:formatRuntime(controller.dailyNaturalGasDataList[index].runtime.toString()), textColor: const Color(0xFFa67def), backgroundColor: const Color(0xFFf2ecfd)),
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