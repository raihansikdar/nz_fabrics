import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/custom_color_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/controllers/custom_gas_generator_button_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class CustomGasGeneratorListWidget extends StatefulWidget {
  final Size size;
  const CustomGasGeneratorListWidget({super.key, required this.size,});

  @override
  State<CustomGasGeneratorListWidget> createState() => _CustomNaturalGasListWidgetState();
}

class _CustomNaturalGasListWidgetState extends State<CustomGasGeneratorListWidget> {

  @override
  void initState() {
    super.initState();

    Get.find<CustomGasGeneratorButtonController>().fetchCustomGasGeneratorData(fromDate:  Get.find<CustomGasGeneratorButtonController>().fromDateTEController.text, toDate:  Get.find<CustomGasGeneratorButtonController>().toDateTEController.text);
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CustomGasGeneratorButtonController>(
        builder: (controller) {
          if(controller.customGasGeneratorDataList.isEmpty){
            return  Padding(
              padding:  EdgeInsets.only(top: widget.size.height * 0.20),
              child: Center(child: Lottie.asset(AssetsPath.emptyJson, height: widget.size.height * 0.12)),
            );

          }
          return Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: widget.size.height * k16TextSize),
              shrinkWrap: true,
              primary: false,
              itemCount: controller.customGasGeneratorDataList.length,
              itemBuilder: (context, index) {
                return CustomContainer(
                  height: widget.size.height * 0.315,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(widget.size.height * k16TextSize),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.size.height * k16TextSize,
                      vertical: widget.size.height * k8TextSize,
                    ),
                    child: Column(
                      children: [
                        TextComponent(text: controller.customGasGeneratorDataList[index].node ?? ''),
                        SizedBox(height: widget.size.height * k16TextSize),
                        _buildDataRow(size: widget.size, label: "Fuel", value: "${controller.customGasGeneratorDataList[index].totalFuel ?? '0.0'} L", textColor: const Color(0xFF793BE8), backgroundColor: const Color(0xFFf2ecfd)),
                        SizedBox(height: widget.size.height * k10TextSize),
                        _buildDataRow(size: widget.size, label: "Energy", value: "${controller.customGasGeneratorDataList[index].totalEnergy ?? '0.0'} kWh", textColor: const Color(0xFFf0bb6d), backgroundColor: const Color(0xFFfdf6ea)),
                        SizedBox(height: widget.size.height * k10TextSize),
                        _buildDataRow(size: widget.size, label: "Cost", value: "${controller.customGasGeneratorDataList[index].totalCost ?? '0.0.'} BDT", textColor: const Color(0xFF7dcece), backgroundColor: const Color(0xFFe8f7f7)),
                        SizedBox(height: widget.size.height * k10TextSize),
                        _buildDataRow(size: widget.size, label: "Run Time", value: formatRuntime(controller.customGasGeneratorDataList[index].totalRuntime.toString()), textColor: const Color(0xFFa67def), backgroundColor: const Color(0xFFf2ecfd)),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: widget.size.height * k8TextSize),
            ),
          );
        }
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