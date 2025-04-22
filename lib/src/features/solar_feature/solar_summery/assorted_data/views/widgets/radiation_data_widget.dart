import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/controllers/assorted_data_controller.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RadiationDataWidget extends StatelessWidget {
  const RadiationDataWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextComponent(text: "East",color: AppColors.secondaryTextColor,),
            SizedBox(height: size.height * k8TextSize,),
            const TextComponent(text: "West",color: AppColors.secondaryTextColor,),
            SizedBox(height: size.height * k8TextSize,),
            const TextComponent(text: "North",color: AppColors.secondaryTextColor,),
            SizedBox(height: size.height * k8TextSize,),
            const TextComponent(text: "South",color: AppColors.secondaryTextColor,),
            SizedBox(height: size.height * k8TextSize,),
            const TextComponent(text: "S15",color: AppColors.secondaryTextColor,),
          ],
        ),

        Column(
          children: [
            const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
            SizedBox(height: size.height * k8TextSize,),
            const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
            SizedBox(height: size.height * k8TextSize,),
            const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
            SizedBox(height: size.height * k8TextSize,),
            const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
            SizedBox(height: size.height * k8TextSize,),
            const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
          ],
        ),

        GetBuilder<AssortedDataController>(
            builder: (assortedDataController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextComponent(text: "${assortedDataController.plantLiveDataModel.irrEast?.toStringAsFixed(2) ?? 0.0} W/m²",),
                  SizedBox(height: size.height * k8TextSize,),
                  TextComponent(text: "${assortedDataController.plantLiveDataModel.irrWest?.toStringAsFixed(2) ?? 0.0} W/m²",),
                  SizedBox(height: size.height * k8TextSize,),
                  TextComponent(text: "${assortedDataController.plantLiveDataModel.irrNorth?.toStringAsFixed(2) ?? 0.0} W/m²",),
                  SizedBox(height: size.height * k8TextSize,),
                  TextComponent(text: "${assortedDataController.plantLiveDataModel.irrSouth?.toStringAsFixed(2) ?? 0.0} W/m²",),
                  SizedBox(height: size.height * k8TextSize,),
                  TextComponent(text: "${assortedDataController.plantLiveDataModel.irrSouth15?.toStringAsFixed(2) ?? 0.0} °C",),

                ],
              );
            }
        ),

      ],
    );
  }
}