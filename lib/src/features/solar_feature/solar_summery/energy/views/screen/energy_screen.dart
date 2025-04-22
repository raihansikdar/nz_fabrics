import 'package:nz_fabrics/src/features/solar_feature/solar_summery/energy/views/widget/shed_wise_today_yesterday_widget.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';

class EnergyScreen extends StatefulWidget {
  const EnergyScreen({super.key});

  @override
  State<EnergyScreen> createState() => _EnergyScreenState();
}

class _EnergyScreenState extends State<EnergyScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: size.height * k16TextSize),
          child: Column(
            children: [
              SizedBox(
                  height: size.height,
                  child: ShedWiseEnergyChartWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
