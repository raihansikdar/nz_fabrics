import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_box_shadow_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/color_palette_widget.dart';
import 'package:nz_fabrics/src/features/summary_feature/controller/carbon_emission_controller.dart';
import 'package:nz_fabrics/src/features/summary_feature/controller/expense_per_person_controller.dart';
import 'package:nz_fabrics/src/features/summary_feature/controller/today_total_energy_controller.dart';
import 'package:nz_fabrics/src/features/summary_feature/model/sensor_data_model.dart';
import 'package:nz_fabrics/src/features/summary_feature/views/widgets/cost_and_prediction_widget.dart';
import 'package:nz_fabrics/src/features/summary_feature/views/widgets/monthly_power_cuts%20and%20agv%20duration.dart';
import 'package:nz_fabrics/src/features/summary_feature/views/widgets/yearly_number_of_power_cuts_and_avg.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {


List<SensorDataModel> sensorDataList = [
  SensorDataModel(SvgPicture.asset(AssetsPath.sensorTempIconSVG), "Module Temperature", 35),
  SensorDataModel(SvgPicture.asset(AssetsPath.sensorRadiationIconSVG), "Solar Radiation", 34),
];

    @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<CarbonEmissionController>().fetchCarbonEmissionData();
      Get.find<TodayTotalEnergyController>().fetchTodayTotalEnergyData();
      Get.find<ExpensePerPersonController>().fetchExpensePerPersonData();
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBarWidget(text: "Essential", backPreviousScreen: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * k16TextSize,),
              CustomBoxShadowContainer(
                height: size.height * 0.4,
                size: size,
                child: Column(
                  children: [
                    SizedBox(height: size.height * k10TextSize),
                    const TextComponent(text: "Energy Usage in Percentage"),
                    const Divider(color: AppColors.containerBorderColor),
                    SizedBox(
                        height: size.height * 0.34,
                        child: const CostAndPredictionWidget()),
                  ],
                ),
              ),
          
              SizedBox(height: size.height * k16TextSize,),
              CustomBoxShadowContainer(
                height: size.height * 0.375,
                size: size,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * k10TextSize),
                    TextComponent(text: "Energy Intensity",fontSize: size.height * k18TextSize,),
                    const Divider(color: AppColors.containerBorderColor),
                    GetBuilder<TodayTotalEnergyController>(
                      builder: (todayTotalEnergyController) {
                        return Stack(
                          children: [
                            SizedBox(
                              height: size.height * 0.3,
                                width: double.infinity,
                                child: SfRadialGauge(
                                  axes: <RadialAxis>[
                                  RadialAxis(
                                  minimum: 0,
                                  maximum: 100,
                                  showLabels: false,
                                  showTicks: false,
                                  radiusFactor: 0.75,
                                  axisLineStyle: const AxisLineStyle(
                                    cornerStyle: CornerStyle.bothCurve,
                                    color: Colors.black12,
                                    thickness: 25,
                                  ),
                                  pointers: <GaugePointer>[
                                    RangePointer(
                                      value: todayTotalEnergyController.todayTotalEnergyModel.totalEnergyPerSqft ?? 0,
                                      cornerStyle: CornerStyle.bothCurve,
                                      width: 25,
                                      sizeUnit: GaugeSizeUnit.logicalPixel,
                                      color: Colors.blue,

                                    ),
                                  ],
                                  annotations: <GaugeAnnotation>[
                                    GaugeAnnotation(
                                      angle: 90,
                                      axisValue: 5,
                                      positionFactor: 0.2,
                                      widget: TextComponent(text: todayTotalEnergyController.todayTotalEnergyModel.totalEnergyPerSqft?.toStringAsFixed(2) ?? "0.0",fontSize: size.height * k40TextSize,fontFamily: boldFontFamily,)
                                    ),
                                  ],
                                ),
                                ],
                                               ),
                            ),

                            Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: TextComponent(text: 'kWh/Sqft',color: AppColors.secondaryTextColor,fontSize: size.height *k20TextSize,),
                                ),
                            )
                          ],
                        );
                      }
                    ),

                  ],
                ),
              ),
              SizedBox(height: size.height * k16TextSize,),

              Column(
                children: [
                sensorDataList.length > 3 ?  CustomBoxShadowContainer(
                    height: size.height * 0.3,
                    size: size,
                    child: Column(
                      children: [
                        SizedBox(height: size.height * k10TextSize),
                        TextComponent(text: "Sensor Data",fontSize: size.height * k18TextSize,),
                        const Divider(color: AppColors.containerBorderColor),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.only(bottom: size.height * k10TextSize),
                            shrinkWrap: true,
                              primary: false,
                              itemCount: sensorDataList.length,
                              itemBuilder: (context,index){
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: size.height * k8TextSize),
                                  child: CustomContainer(
                                    height: size.height * 0.08,
                                    width: double.infinity,
                                    borderRadius: BorderRadius.circular(size.height * k10TextSize),
                                    child: ListTile(
                                      leading: sensorDataList[index].image,
                                      title: TextComponent(text: "${sensorDataList[index].temperature}°C"),
                                      subtitle: TextComponent(text: sensorDataList[index].name,color: AppColors.secondaryTextColor,),
                                    ),
                                  ),
                                );
                              }, separatorBuilder: (context,index) => SizedBox(height: size.height * k8TextSize,),
                          ),
                        ),
                      ],
                    ),
                  ) :
                  Card(
                   elevation: 3,
                    color: AppColors.whiteTextColor,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: size.height * k10TextSize),
                          TextComponent(text: "Sensor Data",fontSize: size.height * k18TextSize,),
                          const Divider(color: AppColors.containerBorderColor),
                          ListView.separated(
                            padding: EdgeInsets.only(bottom: size.height * k10TextSize),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: sensorDataList.length,
                            itemBuilder: (context,index){
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: size.height * k8TextSize),
                                child: CustomContainer(
                                  height: size.height * 0.08,
                                  width: double.infinity,
                                  borderRadius: BorderRadius.circular(size.height * k10TextSize),
                                  child: ListTile(
                                    leading: sensorDataList[index].image,
                                    title: TextComponent(text: "${sensorDataList[index].temperature}°C"),
                                    subtitle: TextComponent(text: sensorDataList[index].name,color: AppColors.secondaryTextColor,),
                                  ),
                                ),
                              );
                            }, separatorBuilder: (context,index) => SizedBox(height: size.height * k8TextSize,),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: size.height * k16TextSize,),

              GetBuilder<CarbonEmissionController>(
                builder: (carbonEmissionController) {
                    var emissionsMap = carbonEmissionController.carbonEmissionList.isNotEmpty
                    ? carbonEmissionController.carbonEmissionList[0].emissions
                        : {};

                    if(carbonEmissionController.isCarbonEmissionInProgress){
                    return CustomShimmerWidget(height: size.height * 0.05, width: double.infinity);
                    }

                  return Column(
                    children: [
                      carbonEmissionController.carbonEmissionList.length > 3 ?   CustomBoxShadowContainer(
                        height: size.height * 0.3,
                        size: size,
                        child: Column(
                              children: [
                                SizedBox(height: size.height * k10TextSize),
                                TextComponent(text: "Carbon Footprint/Emission (Source Wise)",fontSize: size.height * k18TextSize,),
                                const Divider(color: AppColors.containerBorderColor),
                                Expanded(
                                  child: ListView.separated(
                                    padding: EdgeInsets.only(bottom: size.height * k10TextSize),
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: carbonEmissionController.isCarbonEmissionInProgress ? 3 : emissionsMap?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      String key = emissionsMap?.keys.elementAt(index);
                                      double value = emissionsMap?[key];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: CustomContainer(
                                          height: size.height * 0.08,
                                          width: double.infinity,
                                          borderRadius: BorderRadius.circular(size.height * k10TextSize),
                                          child: ListTile(
                                            leading: key == "Generator" ?  SvgPicture.asset(AssetsPath.carbonGeneratorIconSVG) : SvgPicture.asset(AssetsPath.carbonGridIconSVG),
                                            title: TextComponent(text: "$value ton"),
                                            subtitle: TextComponent(text: key, color: AppColors.secondaryTextColor),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => SizedBox(height: size.height * k8TextSize),
                                  ),
                                ),
                              ],
                            ),

                      ) :

                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius:  BorderRadius.circular(size.height * k12TextSize),
                        ),
                        color: AppColors.whiteTextColor,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: size.height * k10TextSize),
                              TextComponent(text: "Carbon Footprint/Emission (Source Wise)",fontSize: size.height * k18TextSize,),
                              const Divider(color: AppColors.containerBorderColor),
                              ListView.separated(
                                padding: EdgeInsets.only(bottom: size.height * k10TextSize),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: carbonEmissionController.isCarbonEmissionInProgress ? 3 : emissionsMap?.length ?? 0,
                                itemBuilder: (context, index) {
                                  String key = emissionsMap?.keys.elementAt(index);
                                  double value = emissionsMap?[key];

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: CustomContainer(
                                      height: size.height * 0.08,
                                      width: double.infinity,
                                      borderRadius: BorderRadius.circular(size.height * k10TextSize),
                                      child: ListTile(
                                        leading: key == "Generator" ?  SvgPicture.asset(AssetsPath.carbonGeneratorIconSVG) : SvgPicture.asset(AssetsPath.carbonGridIconSVG),
                                        title: TextComponent(text: "$value ton"),
                                        subtitle: TextComponent(text: key, color: AppColors.secondaryTextColor),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => SizedBox(height: size.height * k8TextSize),
                              ),
                            ],
                          ),
                        ),

                      ),
                    ],
                  );
                }
              ),

              SizedBox(height: size.height * k16TextSize,),
              GetBuilder<ExpensePerPersonController>(
                builder: (expensePerPersonController) {
                  var expensePerPersonMap = expensePerPersonController.expensePerPersonList.isNotEmpty
                      ? expensePerPersonController.expensePerPersonList[0].expensePerPerson
                      : {};

                  if(expensePerPersonController.isExpensePerPersonInProgress){
                    return CustomShimmerWidget(height: size.height * 0.05, width: double.infinity);
                  }
                  return Column(
                    children: [
                      (expensePerPersonMap?.length ?? 0 ) > 3 ?  CustomBoxShadowContainer(
                        height: size.height * 0.28,
                        size: size,
                        child: Column(
                          children: [
                            SizedBox(height: size.height * k10TextSize),
                            TextComponent(text: "Expanse for Person",fontSize: size.height * k18TextSize,),
                            const Divider(color: AppColors.containerBorderColor),
                            Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.only(bottom: size.height * k10TextSize),
                                shrinkWrap: true,
                                primary: false,
                                itemCount:  expensePerPersonController.isExpensePerPersonInProgress ? 3 : expensePerPersonMap?.length ?? 0,
                                itemBuilder: (context,index){
                                  String key = expensePerPersonMap?.keys.elementAt(index);
                                  double value = expensePerPersonMap?[key];


                                  return ListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: size.height * k16TextSize),
                                    title: key == "total_energy_per_person" ?

                                    TextComponent(text: "Energy : ${value.toStringAsFixed(2)} kWh") : key == "total_cost_per_person" ?
                                    TextComponent(text: "Energy Cost: ${value.toStringAsFixed(2)} ৳") : key == "flow_rate_per_person" ?
                                    TextComponent(text: "Water Usage: ${value.toStringAsFixed(2)} L") : key == "flow_rate_cost" ?
                                    TextComponent(text: "Cost of Water: ${value.toStringAsFixed(2)} L") : key == "carbon_emission_dpdc_generator_per_person" ?
                                    TextComponent(text: "Energy Usages (Emission): ${value.toStringAsFixed(2)} ton") : key == "carbon_emission_dpdc_generator_per_machine" ?
                                    TextComponent(text: "Machine Usages (Emission): ${value.toStringAsFixed(2)} ton") : TextComponent(text: "$key: $value.toStringAsFixed(2)"),
                                    subtitle: ClipRRect(
                                      borderRadius: BorderRadius.circular( size.height * k12TextSize),
                                      child: LinearProgressIndicator(
                                        color: colorPalette[index % colorPalette.length],
                                        value: value/1000,
                                        semanticsLabel: 'Linear progress indicator',
                                        minHeight: 9, // Optional: To make it more visible
                                      ),
                                    ),
                                  );
                                }, separatorBuilder: (context,index) => const SizedBox(),
                              ),
                            ),
                          ],
                        ),
                      ) :
                      Card(
                        elevation: 3,
                        color: AppColors.whiteTextColor,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: size.height * k10TextSize),
                              TextComponent(text: "Expanse for Person",fontSize: size.height * k18TextSize,),
                              const Divider(color: AppColors.containerBorderColor),
                              ListView.separated(
                                padding: EdgeInsets.only(bottom: size.height * k10TextSize),
                                shrinkWrap: true,
                                primary: false,
                                itemCount:  expensePerPersonController.isExpensePerPersonInProgress ? 3 : expensePerPersonMap?.length ?? 0,
                                itemBuilder: (context,index){
                                  String key = expensePerPersonMap?.keys.elementAt(index);
                                  double value = expensePerPersonMap?[key];
                              
                              
                                  return ListTile(
                                    contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: size.height * k16TextSize),
                                    title: key == "total_energy_per_person" ?
                              
                                    TextComponent(text: "Energy : ${value.toStringAsFixed(2)} kWh") : key == "total_cost_per_person" ?
                                    TextComponent(text: "Energy Cost: ${value.toStringAsFixed(2)} ৳") : key == "flow_rate_per_person" ?
                                    TextComponent(text: "Water Usage: ${value.toStringAsFixed(2)} L") : key == "flow_rate_cost" ?
                                    TextComponent(text: "Cost of Water: ${value.toStringAsFixed(2)} L") : key == "carbon_emission_dpdc_generator_per_person" ?
                                    TextComponent(text: "Energy Usages (Emission): ${value.toStringAsFixed(2)} ton") : key == "carbon_emission_dpdc_generator_per_machine" ?
                                    TextComponent(text: "Machine Usages (Emission): ${value.toStringAsFixed(2)} ton") : TextComponent(text: "$key: $value.toStringAsFixed(2)"),
                                    subtitle: ClipRRect(
                                      borderRadius: BorderRadius.circular( size.height * k12TextSize),
                                      child: LinearProgressIndicator(
                                        color: colorPalette[index % colorPalette.length],
                                        value: value/100,
                                        semanticsLabel: 'Linear progress indicator',
                                        minHeight: 9, // Optional: To make it more visible
                                      ),
                                    ),
                                  );
                                }, separatorBuilder: (context,index) => const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              ),

              SizedBox(height: size.height * k16TextSize,),
              CustomContainer(
                  height: size.height * 0.67,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(size.height * k8TextSize),

                  child: const MonthlyPowerCutsAndAvgDuration()),
              SizedBox(height: size.height * k16TextSize,),
              CustomContainer(
                  height: size.height * 0.67,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(size.height * k8TextSize),

                  child: const YearlyNumberOfPowerCutsAndAvgWidget()),
              SizedBox(height: size.height * k16TextSize,),
            ],
          ),
        ),
      ),
    );
  }
}
