import 'package:nz_fabrics/src/common_widgets/custom_box_shadow_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/filter_specific_node_data/water_filter_specific_node_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/get_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_daily_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_monthly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_this_day_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_this_month_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_this_year_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_today_runtime_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_yearly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/water/widgets/water_daily_line_chart_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/water/widgets/water_details_date_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/water/widgets/water_filter_chart_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/water/widgets/water_gauge_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/water/widgets/water_monthly_bar_card_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/water/widgets/water_run_time_information_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/water/widgets/water_table_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/water/widgets/water_yearly_bar_chart_widget.dart';

import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class PowerViewWaterElementDetailsScreen extends StatefulWidget {
  final String elementName;
  final String elementCategory;
  final double gaugeValue;
  final String gaugeUnit;
  const PowerViewWaterElementDetailsScreen({super.key, required this.elementName, required this.gaugeValue, required this.gaugeUnit, required this.elementCategory});

  @override
  State<PowerViewWaterElementDetailsScreen> createState() => _PowerViewWaterElementDetailsScreenState();
}

class _PowerViewWaterElementDetailsScreenState extends State<PowerViewWaterElementDetailsScreen> with  TickerProviderStateMixin {
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
      Get.find<WaterFilterSpecificNodeDataController>().fetchFilterSpecificData(nodeName: widget.elementName, fromDate: Get.find<WaterFilterSpecificNodeDataController>().fromDateTEController.text, toDate: Get.find<WaterFilterSpecificNodeDataController>().toDateTEController.text);
      Get.find<WaterFilterSpecificNodeDataController>().fetchFilterSpecificTableData(nodeName: widget.elementName, fromDate: Get.find<WaterFilterSpecificNodeDataController>().fromDateTEController.text, toDate: Get.find<WaterFilterSpecificNodeDataController>().toDateTEController.text);
      Get.find<GetLiveDataController>().fetchGetLiveData(meterName: widget.elementName);
      Get.find<WaterTodayRuntimeDataController>().fetchTodayRuntimeData(sourceName: widget.elementName);
      Get.find<WaterThisDayDataController>().fetchThisDayData(sourceName: widget.elementName);
      Get.find<WaterThisMonthDataController>().fetchThisMonthData(sourceName: widget.elementName);
      Get.find<WaterThisYearDataController>().fetchThisYearData(sourceName: widget.elementName);

      Get.find<WaterDailyDataController>().fetchDailyData(elementName: widget.elementName);
      Get.find<WaterMonthlyDataController>().fetchWaterMonthlyData(elementName: widget.elementName);
      Get.find<WaterYearlyDataController>().fetchWaterYearlyData(elementName: widget.elementName);
    });


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
      body: RefreshIndicator(
        onRefresh: ()async{
          WidgetsBinding.instance.addPostFrameCallback((_){
            Get.find<GetLiveDataController>().fetchGetLiveData(meterName: widget.elementName);
            Get.find<WaterTodayRuntimeDataController>().fetchTodayRuntimeData(sourceName: widget.elementName);
            Get.find<WaterThisDayDataController>().fetchThisDayData(sourceName: widget.elementName);
            Get.find<WaterThisMonthDataController>().fetchThisMonthData(sourceName: widget.elementName);
            Get.find<WaterThisYearDataController>().fetchThisYearData(sourceName: widget.elementName);

            Get.find<WaterDailyDataController>().fetchDailyData(elementName: widget.elementName);
            Get.find<WaterMonthlyDataController>().fetchWaterMonthlyData(elementName: widget.elementName);
            Get.find<WaterYearlyDataController>().fetchWaterYearlyData(elementName: widget.elementName);
          });
        },
        child: Column(
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
                child: GetBuilder<WaterFilterSpecificNodeDataController>(
                  builder: (waterFilterSpecificNodeDataController) {
                    return Column(
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
                                            child:  WaterGaugeWidget(gaugeValue: widget.gaugeValue, gaugeMaxValue: getLiveDataController.getLiveDataModel.maxMeterValue ?? 2000,));
                                      }
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        GetBuilder<WaterTodayRuntimeDataController>(
                          builder: (waterTodayRuntimeDataController) {
                            final thisDayController = Get.find<WaterThisDayDataController>();
                            final thisMonthController = Get.find<WaterThisMonthDataController>();
                            final thisYearController = Get.find<WaterThisYearDataController>();

                            return WaterRunTimeInformationWidget(
                              viewName: "Water",
                              elementCategory: widget.elementCategory,
                              size: size,
                              elementName: widget.elementName,
                              todayRuntime: waterTodayRuntimeDataController.todayRunTimeData.runtimeToday.toString(),
                              thisDay: thisDayController.thisDayData.thisDay ?? 0.00,
                              thisMonth: thisMonthController.thisMonthData.isNotEmpty ? thisMonthController.thisMonthData[0].instantFlow ?? 0.00 : 0.00,
                              thisYear: thisYearController.thisYearData.volume ?? 0.00,
                            );
                          }
                        ),



                        SizedBox(height: size.height * k8TextSize),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.height * k16TextSize,
                            //vertical: size.height * k8TextSize,
                          ),
                          child: WaterDetailsDateWidget(nodeName: widget.elementName,),
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
                                          Expanded(child: TextComponent(text: "${widget.elementName} Water Flow (m³/h)",fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,maxLines: 1,)),
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
                                      padding: EdgeInsets.symmetric(horizontal: size.width * k40TextSize),
                                      child: const Divider(thickness: 2),
                                    ),
                                    GetBuilder<WaterDailyDataController>(
                                        builder: (waterDailyDataController) {
                                          if(waterDailyDataController.isLoading){
                                            return CustomShimmerWidget(height:  size.height * .28, width: double.infinity);
                                          }else if(!waterDailyDataController.isConnected){
                                            return Lottie.asset(AssetsPath.noInternetJson, height: size.height * 0.23);
                                          }
                                          else if(waterDailyDataController.hasError){
                                            return Lottie.asset(AssetsPath.errorJson, height: size.height * 0.25);
                                          }
                                          // return SizedBox(
                                          //     height: size.height * .28,
                                          //     child:  WaterDailyLineChartWidget(elementName: widget.elementName,viewName: 'powerView', waterDailyDataList: waterDailyDataController.dailyDataList, screenName: 'water',),
                                          // );

                                          return GetBuilder<WaterFilterSpecificNodeDataController>(
                                              builder: (controller) {
                                                return SizedBox(
                                                    height: size.height * .35,
                                                    child: controller.selectedButton == 2 ?
                                                    WaterFilterSpecificChartWidget(size,controller.graphType,controller.lineChartDataList,controller.monthlyBarChartDataList,controller.yearlyBarChartDataList,controller.dateDifference)
                                                        :   WaterDailyLineChartWidget(elementName: widget.elementName,viewName: 'powerView', waterDailyDataList: waterDailyDataController.dailyDataList, /*screenName: 'water',*/),
                                                );
                                              }
                                          );
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
                        waterFilterSpecificNodeDataController.selectedButton == 1 ?
                        Column(
                          children: [

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize, vertical: size.height * k8TextSize,
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
                                              SvgPicture.asset(AssetsPath.barChartIconSVG,  height: size.height * k25TextSize,),
                                              SizedBox(width: size.width * k20TextSize,),
                                              Expanded(child: TextComponent(text: "This month ${widget.elementName} Water Flow (m³)",fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,maxLines: 1,)),
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
                                        GetBuilder<WaterMonthlyDataController>(
                                            builder: (waterMonthlyDataController) {
                                              if(waterMonthlyDataController.isLoading){
                                                return CustomShimmerWidget(height:  size.height * .28, width: double.infinity);
                                              }else if(!waterMonthlyDataController.isConnected){
                                                return Lottie.asset(AssetsPath.noInternetJson, height: size.height * 0.23);
                                              }
                                              else if(waterMonthlyDataController.hasError){
                                                return Lottie.asset(AssetsPath.errorJson, height: size.height * 0.25);
                                              }
                                              return SizedBox(
                                                  height: size.height * .28,
                                                  child: WaterMonthlyDetailsBarChartWidget(elementName: widget.elementName,solarCategory: 'water',viewName: 'powerView',waterMonthlyDataModel:waterMonthlyDataController.monthlyDataList, screenName: 'waterScreen',));
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
                                              SvgPicture.asset(AssetsPath.barChartIconSVG,  height: size.height * k25TextSize,),
                                              SizedBox(width: size.width * k20TextSize,),
                                              Expanded(child: TextComponent(text: "This year ${widget.elementName} Water Flow (m³)",fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,maxLines: 1,)),
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
                                        GetBuilder<WaterYearlyDataController>(
                                            builder: (waterYearlyDataController) {
                                              if(waterYearlyDataController.isLoading){
                                                return CustomShimmerWidget(height:  size.height * .28, width: double.infinity);
                                              }else if(!waterYearlyDataController.isConnected){
                                                return Lottie.asset(AssetsPath.noInternetJson, height: size.height * 0.23);
                                              }
                                              else if(waterYearlyDataController.hasError){
                                                return Lottie.asset(AssetsPath.errorJson, height: size.height * 0.25);
                                              }
                                              return SizedBox(
                                                  height: size.height * .28,
                                                  child: WaterYearlyBarChartWidget(elementName: widget.elementName,screenName: 'waterScreen', waterYearlyDataModelList: waterYearlyDataController.yearlyDataList, viewName: 'powerView',));
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
                          ],
                        ) : Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: (){
                                  waterFilterSpecificNodeDataController.downloadDataSheet(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: CustomContainer(
                                    height: size.height * 0.050,
                                    width:  size.width * 0.3,
                                    borderRadius: BorderRadius.circular(size.height * k8TextSize),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          TextComponent(text: "Download"),
                                          Icon(Icons.download)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 500,
                              width: double.infinity,
                              child: WaterSpecificNodeDataTable(
                                tableData: waterFilterSpecificNodeDataController.filterSpecificNodeTableModel,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: size.height * 0.2,)

                      ],
                    );
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




