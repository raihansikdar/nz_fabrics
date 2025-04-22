
import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/common_widgets/custom_box_shadow_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_color_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class RunTimeInformationWidget extends StatelessWidget {
  const RunTimeInformationWidget({
    super.key,
    required this.size,
    required this.elementName,
    required this.todayRuntime,
    required this.thisDay,
    required this.thisMonth,
    required this.thisYear,
    required this.viewName,
    required this.elementCategory,
    this.generator,
  });

  final String viewName;
  final Size size;
  final String elementName;
  final String elementCategory;
  final String todayRuntime;
  final double thisDay;
  final double thisMonth;
  final dynamic thisYear;
  final String? generator;

  @override
  Widget build(BuildContext context) {
    List<String> runtimeParts = todayRuntime.split(":");
    String formattedRuntime;
    if (runtimeParts.length == 2) {
      formattedRuntime = "${runtimeParts[0]} hrs. ${runtimeParts[1]} min";
    } else {
      formattedRuntime = "0 hrs. 0 min ";
    }

    return Padding(
      padding: EdgeInsets.only(
        left: size.height * k16TextSize,
        right: size.height * k16TextSize,
        bottom: size.height * k16TextSize,
      ),
      child: CustomBoxShadowContainer(
        height: generator == 'True' ? size.height * 0.25 : size.height * 0.33,
        size: size,
        child: Padding(
          padding: EdgeInsets.all(size.height * k16TextSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextComponent(
                text: generator == 'True'
                    ? "$elementName $elementCategory Information"
                    : viewName == 'revenueView'
                    ? "$elementName Cost & Runtime Information"
                    : "$elementName $elementCategory & Runtime Information",
                color: AppColors.secondaryTextColor,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: size.height * k8TextSize),
              if (generator != 'True') ...[
                _buildDataRow(
                  "Today Runtime",
                  formattedRuntime,
                  const Color(0xFF793BE8),
                  const Color(0xFFf2ecfd),
                ),
                SizedBox(height: size.height * k8TextSize),
              ],
              _buildDataRow(
                "This Day",
                _formatValue(thisDay, elementCategory, viewName),
                const Color(0xFF45a4ef),
                const Color(0xFFebf5fe),
              ),
              SizedBox(height: size.height * k8TextSize),
              _buildDataRow(
                "This Month",
                _formatValue(thisMonth, elementCategory, viewName),
                const Color(0xFFf0bb6d),
                const Color(0xFFfdf6ea),
              ),
              SizedBox(height: size.height * k8TextSize),
              _buildDataRow(
                "This Year",
                _formatValue(thisYear, elementCategory, viewName),
                const Color(0xFF68c6c6),
                const Color(0xFFe8f7f7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value, Color textColor, Color backgroundColor) {
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

  String _formatValue(dynamic value, String category, String viewName) {
    if (viewName == 'revenueView') {
      return "৳ ${value.toStringAsFixed(2)}";
    } else if (category == 'Water') {
      return "${value.toStringAsFixed(2)} m³";
    } else if (category == 'Natural Gas') {
      return "${value.toStringAsFixed(2)} cf"; // Assuming 'cf' for cubic feet
    } else {
      return "${value.toStringAsFixed(2)} kWh";
    }
  }
}