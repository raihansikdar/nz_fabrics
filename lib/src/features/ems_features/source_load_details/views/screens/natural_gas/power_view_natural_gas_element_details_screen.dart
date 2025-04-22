import 'dart:developer';

import 'package:nz_fabrics/src/common_widgets/custom_box_shadow_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_daily_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_monthly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_this_day_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_this_month_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_this_year_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_yearly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/get_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_today_runtime_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/widgets/daily_line_chart_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/widgets/gauge_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/widgets/monthly_bar_card_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/widgets/run_time_information_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/widgets/yearly_bar_chart_widget.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class PowerViewNaturalGasElementDetailsScreen extends StatefulWidget {
  final String elementName;
  final String elementCategory;
  final double gaugeValue;
  final String gaugeUnit;
  const PowerViewNaturalGasElementDetailsScreen({super.key, required this.elementName, required this.gaugeValue, required this.gaugeUnit, required this.elementCategory});

  @override
  State<PowerViewNaturalGasElementDetailsScreen> createState() => _PowerViewNaturalGasElementDetailsScreenState();
}

class _PowerViewNaturalGasElementDetailsScreenState extends State<PowerViewNaturalGasElementDetailsScreen> with  TickerProviderStateMixin {
  late AnimationController _controller1;
  late  Animation<double> _animation1;
  late AnimationController _controller2;
  late  Animation<double> _animation2;
  late AnimationController _controller3;
  late  Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<GetLiveDataController>().fetchGetLiveData(meterName: widget.elementName);
    });

    log(widget.elementCategory);
    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _controller3 = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation1 = Tween<double>(begin: 0, end: 0.5).animate(_controller1);
    _animation2 = Tween<double>(begin: 0, end: 0.5).animate(_controller2);
    _animation3 = Tween<double>(begin: 0, end: 0.5).animate(_controller3);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              border:
              Border.all(color: AppColors.containerBorderColor, width: 1.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.height * k30TextSize),
                topRight: Radius.circular(size.height * k30TextSize),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: size.height * k40TextSize),

                  Padding(
                    padding:  EdgeInsets.all( size.height * k16TextSize),
                    child: CustomBoxShadowContainer(
                      height:  size.height * 0.15,
                      size: size,
                      child: Padding(
                        padding:  EdgeInsets.all(size.height * k16TextSize),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextComponent(text: "Live ${widget.elementCategory} ${widget.elementName}",color: AppColors.secondaryTextColor,maxLines: 1,),
                                  SizedBox(height: size.height * k8TextSize),
                                  TextComponent(text: "${widget.gaugeValue.toStringAsFixed(2)} ${widget.gaugeUnit}",color: AppColors.primaryTextColor,fontSize: size.height * k24TextSize,fontFamily: boldFontFamily,),
                                ],
                              ),
                            ),
                            SizedBox(width: size.width * k20TextSize),
                            Expanded(
                              child: GetBuilder<GetLiveDataController>(
                                builder: (getLiveDataController) {
                                  return SizedBox(
                                      height: size.height * 0.400,
                                      width: size.width * 0.400,
                                      child:  GaugeWidget(gaugeValue: widget.gaugeValue, gaugeMaxValue: getLiveDataController.getLiveDataModel.maxMeterValue,));
                                }
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  RunTimeInformationWidget(
                    viewName: "power",
                    elementCategory: widget.elementCategory,
                    size: size,
                    elementName: widget.elementName,
                    todayRuntime: Get.find<WaterTodayRuntimeDataController>().todayRunTimeData.runtimeToday.toString(),
                    thisDay: Get.find<NaturalGasThisDayDataController>().thisDayData.thisDay ?? 0.00,
                    thisMonth: Get.find<NaturalGasThisMonthDataController>().thisMonthData.isNotEmpty ? Get.find<NaturalGasThisMonthDataController>().thisMonthData[0].volume ?? 0.00 : 0.00,
                    thisYear: Get.find<NaturalGasThisYearDataController>().thisYearData.volume ?? 0.00,
                  ),



                  SizedBox(height: size.height * k8TextSize),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.height * k16TextSize,
                      vertical: size.height * k8TextSize,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(size.height * k16TextSize),
                        border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
                      ),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(size.height * k16TextSize),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            expansionTileTheme: const ExpansionTileThemeData(
                              backgroundColor: Colors.transparent,
                              collapsedBackgroundColor: Colors.transparent,
                            ),
                          ),
                          child: ExpansionTile(
                            backgroundColor: Colors.transparent,
                            initiallyExpanded: true,
                            showTrailingIcon: false,
                            title: Stack(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AssetsPath.lineChartIconSVG,  height: size.height * k25TextSize,),
                                    SizedBox(width: size.width * k20TextSize,),
                                    Expanded(child: TextComponent(text: "Today ${widget.elementName} Pressure (Pa)",fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: RotationTransition(
                                    turns: _animation1,
                                    child: SvgPicture.asset(
                                      AssetsPath.upArrowIconSVG,
                                      height: size.height * k25TextSize,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * k40TextSize),
                                child: const Divider(thickness: 2),
                              ),
                              GetBuilder<NaturalGasDailyDataController>(
                                  builder: (naturalGasDailyDataController) {
                                    if(naturalGasDailyDataController.isLoading){
                                      return CustomShimmerWidget(height:  size.height * .28, width: double.infinity);
                                    }else if(!naturalGasDailyDataController.isConnected){
                                      return Lottie.asset(AssetsPath.noInternetJson, height: size.height * 0.23);
                                    }
                                    else if(naturalGasDailyDataController.hasError){
                                      return Lottie.asset(AssetsPath.errorJson, height: size.height * 0.25);
                                    }
                                    return SizedBox(
                                        height: size.height * .28,
                                        child:  DailyLineChartWidget(elementName: widget.elementName,viewName: 'powerView', naturalGasDailyDataList: naturalGasDailyDataController.dailyDataList, screenName: 'naturalGasScreen',));
                                  }
                              ),
                              SizedBox(height: size.height * k20TextSize),
                            ],
                            onExpansionChanged: (bool expanded) {
                              if (expanded) {
                                _controller1.reverse();
                              } else {
                                _controller1.forward();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * k8TextSize),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.height * k16TextSize,
                      vertical: size.height * k8TextSize,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(size.height * k16TextSize),
                        border: Border.all(
                            color: AppColors.containerBorderColor,
                            width: 1.0),
                      ),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(size.height * k16TextSize),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            expansionTileTheme: const ExpansionTileThemeData(
                              backgroundColor: Colors.transparent,
                              collapsedBackgroundColor: Colors.transparent,
                            ),
                          ),
                          child: ExpansionTile(
                            backgroundColor: Colors.transparent,
                            initiallyExpanded: true,
                            showTrailingIcon: false,
                            title: Stack(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AssetsPath.barChartIconSVG,  height: size.height * k25TextSize,),
                                    SizedBox(width: size.width * k20TextSize,),
                                    Expanded(child: TextComponent(text: "This month ${widget.elementName} Volume (cf)",fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: RotationTransition(
                                    turns: _animation2,
                                    child: SvgPicture.asset(
                                      AssetsPath.upArrowIconSVG,
                                      height: size.height * k25TextSize,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * k40TextSize),
                                child: const Divider(thickness: 2),
                              ),
                              GetBuilder<NaturalGasMonthlyDataController>(
                                  builder: (naturalGasMonthlyDataController) {
                                    if(naturalGasMonthlyDataController.isLoading){
                                      return CustomShimmerWidget(height:  size.height * .28, width: double.infinity);
                                    }else if(!naturalGasMonthlyDataController.isConnected){
                                      return Lottie.asset(AssetsPath.noInternetJson, height: size.height * 0.23);
                                    }
                                    else if(naturalGasMonthlyDataController.hasError){
                                      return Lottie.asset(AssetsPath.errorJson, height: size.height * 0.25);
                                    }
                                    return SizedBox(
                                        height: size.height * .28,
                                        child: MonthlyBarChartWidget(elementName: widget.elementName,solarCategory: 'Natural Gas',viewName: 'powerView',naturalGasMonthlyDataModel:naturalGasMonthlyDataController.monthlyDataList, screenName: 'naturalGasScreen',));
                                  }
                              ),
                              SizedBox(height: size.height * k20TextSize),
                            ],
                            onExpansionChanged: (bool expanded) {
                              if (expanded) {
                                _controller2.reverse();
                              } else {
                                _controller2.forward();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * k8TextSize),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.height * k16TextSize,
                      vertical: size.height * k8TextSize,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(size.height * k16TextSize),
                        border: Border.all(
                            color: AppColors.containerBorderColor,
                            width: 1.0),
                      ),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(size.height * k16TextSize),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            expansionTileTheme: const ExpansionTileThemeData(
                              backgroundColor: Colors.transparent,
                              collapsedBackgroundColor: Colors.transparent,
                            ),
                          ),
                          child: ExpansionTile(
                            backgroundColor: Colors.transparent,
                            initiallyExpanded: true,
                            showTrailingIcon: false,
                            title: Stack(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(AssetsPath.barChartIconSVG,  height: size.height * k25TextSize,),
                                    SizedBox(width: size.width * k20TextSize,),
                                    Expanded(child: TextComponent(text: "This year ${widget.elementName} Volume (cf)",fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: RotationTransition(
                                    turns: _animation3,
                                    child: SvgPicture.asset(
                                      AssetsPath.upArrowIconSVG,
                                      height: size.height * k25TextSize,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * k40TextSize),
                                child: const Divider(thickness: 2),
                              ),
                              GetBuilder<NaturalGasYearlyDataController>(
                                  builder: (naturalGasYearlyDataController) {
                                    if(naturalGasYearlyDataController.isLoading){
                                      return CustomShimmerWidget(height:  size.height * .28, width: double.infinity);
                                    }else if(!naturalGasYearlyDataController.isConnected){
                                      return Lottie.asset(AssetsPath.noInternetJson, height: size.height * 0.23);
                                    }
                                    else if(naturalGasYearlyDataController.hasError){
                                      return Lottie.asset(AssetsPath.errorJson, height: size.height * 0.25);
                                    }
                                    return SizedBox(
                                        height: size.height * .28,
                                        child: YearlyBarChartWidget(elementName: widget.elementName,screenName: 'naturalGasScreen', naturalGasYearlyDataModelList: naturalGasYearlyDataController.yearlyDataList, viewName: 'powerView',));
                                  }
                              ),
                              SizedBox(height: size.height * k20TextSize),
                            ],
                            onExpansionChanged: (bool expanded) {
                              if (expanded) {
                                _controller3.reverse();
                              } else {
                                _controller3.forward();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.2,)

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




