import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/controllers/assorted_data_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TemperatureDataWidget extends StatelessWidget {
  const TemperatureDataWidget({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {

    final TabController tabController = DefaultTabController.of(context);

    return GetBuilder<AssortedDataController>(
        builder: (assortedDataController) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: size.height * k16TextSize,right: size.height * k16TextSize,top: size.height * k8TextSize ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextComponent(text: "Temperature",color: AppColors.secondaryTextColor,),
                    GestureDetector(
                        onTap:(){
                          tabController.animateTo(3);
                        },
                        child: SvgPicture.asset(AssetsPath.listIconSVG))
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade300,),

              SvgPicture.asset(AssetsPath.solarTemperatureImageSVG,width: size.height * 0.13,),
              SizedBox(height: size.height * k12TextSize,),

              SizedBox(height: size.height * k8TextSize,),
              const TextComponent(text: "Module Temp.",color: AppColors.secondaryTextColor,),
              TextComponent(text: "${assortedDataController.plantLiveDataModel.moduleTemperature?.toStringAsFixed(0) ?? 0.0} °C",fontSize: size.height * k24TextSize,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.076,vertical: size.height * 0.004),
                child: const Divider(),
              ),
              const TextComponent(text: "Ambient Temp.",color: AppColors.secondaryTextColor,),
              TextComponent(text: "${assortedDataController.plantLiveDataModel.ambientTemperature?.toStringAsFixed(0) ?? 0.0} °C",fontSize: size.height * k24TextSize,),
            ],
          );
        }
    );
  }
}