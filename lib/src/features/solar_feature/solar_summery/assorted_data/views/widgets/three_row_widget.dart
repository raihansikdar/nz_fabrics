import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/controllers/assorted_data_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/views/widgets/solar_container_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/views/widgets/temperature_data_widget.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ThreeRowWidget extends StatelessWidget {
  const ThreeRowWidget({super.key, required this.size});
  final Size size;
  @override
  Widget build(BuildContext context) {

    final TabController tabController = DefaultTabController.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SolarContainerWidget(
              height: size.height * 0.35,
              size: size,

              child: GetBuilder<AssortedDataController>(
                  builder: (assortedDataController) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: size.height * k16TextSize,right: size.height * k16TextSize,top: size.height * k8TextSize ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextComponent(text: "Active AC Power",color: AppColors.secondaryTextColor,),
                              GestureDetector(
                                  onTap: (){
                                    tabController.animateTo(4);
                                  },
                                  child: SvgPicture.asset(AssetsPath.listIconSVG))
                            ],
                          ),
                        ),
                        Divider(color: Colors.grey.shade300,),
                        SizedBox(
                            height: size.height * 0.150,
                            child: SfRadialGauge(
                              axes: <RadialAxis>[RadialAxis(
                                  minimum: 0, // Set the minimum value here
                                  maximum: 3500,
                                  interval: 800,
                                  pointers:  <GaugePointer>[
                                    RangePointer(value: assortedDataController.plantLiveDataModel.totalAcPower ?? 0.0, width: 0.14,
                                        color: AppColors.primaryColor, sizeUnit: GaugeSizeUnit.factor,enableAnimation: true,
                                    ),
                                    NeedlePointer(value: assortedDataController.plantLiveDataModel.totalAcPower ?? 0.0,
                                        needleColor: AppColors.primaryColor,
                                        needleStartWidth: 0.6, needleEndWidth: 5,enableAnimation: true,
                                        knobStyle: const KnobStyle(knobRadius: 0.05, borderColor: AppColors.primaryColor,
                                            borderWidth: 0.02,
                                            color:AppColors.whiteTextColor
                                        )
                                    )]
                              )],
                            )
                        ),

                        SizedBox(height: size.height * k16TextSize,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.height * 0.076,vertical: size.height * 0.004),
                          child: const Divider(),
                        ),
                        SizedBox(height: size.height * k16TextSize,),
                        const TextComponent(text: "AC Power",color: AppColors.secondaryTextColor,),
                        TextComponent(text: "${assortedDataController.plantLiveDataModel.totalAcPower?.toStringAsFixed(2) ?? 0.0} kW",fontSize: size.height * k24TextSize,),
                      ],
                    );
                  }
              ),
            ),
            SolarContainerWidget(
              height: size.height * 0.35,
              size: size,

              child: TemperatureDataWidget(size: size),
            ),
          ],
        ),

        SizedBox(height: size.height * k18TextSize,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SolarContainerWidget(
              height: size.height * 0.10,
              size: size,

              child: GetBuilder<AssortedDataController>(
                  builder: (assortedDataController) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: size.height * k16TextSize,right: size.height * k16TextSize,top: size.height * k8TextSize ),
                          child: Center(child: TextComponent(text: "Live PR",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,fontSize: size.height * k20TextSize,)),
                        ),
                        Divider(color: Colors.grey.shade300,),

                        TextComponent(text: assortedDataController.plantLiveDataModel.livePr?.toStringAsFixed(2)?? '0.0',fontSize: size.height * k24TextSize,),
                      ],
                    );
                  }
              ),
            ),
            SolarContainerWidget(
              height: size.height * 0.10,
              size: size,

              child: GetBuilder<AssortedDataController>(
                  builder: (assortedDataController) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: size.height * k16TextSize,right: size.height * k16TextSize,top: size.height * k8TextSize ),
                          child: Center(child: TextComponent(text: "Daily Cum.",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,fontSize: size.height * k20TextSize,)),
                        ),
                        Divider(color: Colors.grey.shade300,),


                        TextComponent(text: "${assortedDataController.plantLiveDataModel.cumulativePr?.toStringAsFixed(2) ?? 0.0} w/m²",fontSize: size.height * k24TextSize,),
                      ],
                    );
                  }
              ),
            ),

          ],
        ),

        SizedBox(height: size.height * k18TextSize,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SolarContainerWidget(
              height: size.height * 0.10,
              size: size,

              child: GetBuilder<AssortedDataController>(
                  builder: (assortedDataController) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: size.height * k16TextSize,right: size.height * k16TextSize,top: size.height * k8TextSize ),
                          child: Center(child: TextComponent(text: "Irr Avg.",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,fontSize: size.height * k20TextSize,)),
                        ),
                        Divider(color: Colors.grey.shade300,),

                        TextComponent(text: "${assortedDataController.plantLiveDataModel.avgIrr?.toStringAsFixed(2) ?? 0.0} w/m²",fontSize: size.height * k24TextSize,),
                      ],
                    );
                  }
              ),
            ),
            SolarContainerWidget(
              height: size.height * 0.10,
              size: size,

              child: GetBuilder<AssortedDataController>(
                  builder: (assortedDataController) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: size.height * k16TextSize,right: size.height * k16TextSize,top: size.height * k8TextSize ),
                          child: Center(child: TextComponent(text: "Gross Profit",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,fontSize: size.height * k20TextSize,)),
                        ),
                        Divider(color: Colors.grey.shade300,),
                        TextComponent(text: "${assortedDataController.plantLiveDataModel.profit?.toStringAsFixed(2) ?? 0.0} ৳",fontSize: size.height * k24TextSize,),
                      ],
                    );
                  }
              ),
            ),

          ],
        ),
      ],
    );
  }
}
