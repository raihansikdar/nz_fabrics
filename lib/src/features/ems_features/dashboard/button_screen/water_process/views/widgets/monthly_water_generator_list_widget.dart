
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/custom_color_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/controllers/monthly_water_button_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class MonthlyWaterListWidget extends StatefulWidget {
  final Size size;

  const MonthlyWaterListWidget({super.key, required this.size});

  @override
  State<MonthlyWaterListWidget> createState() => _MonthlyWaterListWidgetState();
}

class _MonthlyWaterListWidgetState extends State<MonthlyWaterListWidget> {

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  @override
  void initState() {
    Get.find <MonthlyWaterButtonController>().fetchMonthlyWaterData(selectedMonth: selectedMonth.toString(), selectedYear: selectedYear.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return GetBuilder<MonthlyWaterButtonController>(
        builder: (controller) {
          if(controller.isMonthlyWaterDataInProgress){
            return  Padding(
              padding:  EdgeInsets.only(top: widget.size.height * 0.20),
              child: Center(
                child: SpinKitFadingCircle(
                  color: AppColors.primaryColor,
                  size: 50.0,
                ),
              ),
            );

          }

          if(controller.monthlyWaterDataList.isEmpty){
            return  Padding(
              padding:  EdgeInsets.only(top: widget.size.height * 0.20),
              child: Center(child: Lottie.asset(AssetsPath.emptyJson, height: widget.size.height * 0.26)),
            );

          }

          return Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: widget.size.height * k16TextSize),
              shrinkWrap: true,
              primary: false,
              itemCount: controller.monthlyWaterDataList.length,
              itemBuilder: (context, index) {
                return CustomContainer(
                  height: widget.size.height * 0.25,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(widget.size.height * k16TextSize),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.size.height * k16TextSize,
                      vertical: widget.size.height * k8TextSize,
                    ),
                    child: Column(
                      children: [
                        TextComponent(text: controller.monthlyWaterDataList[index].node ?? ''),
                        SizedBox(height: widget.size.height * k16TextSize),
                        _buildDataRow(size: widget.size, label: "Pressure", value: "${controller.monthlyWaterDataList[index].instantFlow?.toStringAsFixed(2) ?? '0.0'} L", textColor: const Color(0xFF793BE8), backgroundColor: const Color(0xFFf2ecfd)),
                        // SizedBox(height: size.height * k10TextSize),
                        // _buildDataRow(size: size, label: "Energy", value: controller.dailyGasDataList[index].energy.toString(), textColor: const Color(0xFFf0bb6d), backgroundColor: const Color(0xFFfdf6ea)),
                        SizedBox(height: widget.size.height * k10TextSize),
                        _buildDataRow(size: widget.size, label: "Cost", value: "${controller.monthlyWaterDataList[index].cost?.toStringAsFixed(2) ?? '0.0'} BDT", textColor: const Color(0xFF7dcece), backgroundColor: const Color(0xFFe8f7f7)),
                        SizedBox(height: widget.size.height * k10TextSize),
                        _buildDataRow(size: widget.size, label: "Run Time", value: formatRuntime(controller.monthlyWaterDataList[index].runtime.toString()), textColor: const Color(0xFFa67def), backgroundColor: const Color(0xFFf2ecfd)),
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