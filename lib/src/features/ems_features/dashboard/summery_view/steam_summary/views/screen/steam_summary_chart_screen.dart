import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';

class SteamSummaryChartScreen extends StatelessWidget {
  const SteamSummaryChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextComponent(text: 'No data available now',color: AppColors.secondaryTextColor,),
      ),
    );
  }
}
