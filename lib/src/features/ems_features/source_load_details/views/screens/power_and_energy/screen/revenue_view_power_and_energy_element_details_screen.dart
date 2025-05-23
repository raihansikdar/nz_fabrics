import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/filter_specific_node_data/filter_specific_node_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/plot_controller/plot_line_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/daily_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/monthly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/this_day_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/this_month_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/this_year_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/today_runtime_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/yearly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/widgets/daily_line_chart_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/widgets/filter_cost_chart_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/widgets/monthly_bar_card_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/widgets/run_time_information_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/widgets/table_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/widgets/power_date_widget.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../widgets/yearly_bar_chart_widget.dart';

class RevenueViewPowerAndEnergyElementDetailsScreen extends StatefulWidget {
  final String elementName;
  final String elementCategory;
  final String solarCategory;
  final String generator;
  const RevenueViewPowerAndEnergyElementDetailsScreen({super.key, required this.elementName, required this.elementCategory, required this.solarCategory, required this.generator});

  @override
  State<RevenueViewPowerAndEnergyElementDetailsScreen> createState() => _RevenueViewPowerAndEnergyElementDetailsScreenState();
}

class _RevenueViewPowerAndEnergyElementDetailsScreenState extends State<RevenueViewPowerAndEnergyElementDetailsScreen> with  TickerProviderStateMixin {
  late AnimationController _controller1;
  late  Animation<double> _animation1;
  late AnimationController _controller2;
  late  Animation<double> _animation2;
  late AnimationController _controller3;
  late  Animation<double> _animation3;

  PlotLineController plotLineController = Get.put(PlotLineController());




  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   Get.find<FilterSpecificNodeDataController>().fetchFilterSpecificData(nodeName: widget.elementName, fromDate: Get.find<FilterSpecificNodeDataController>().fromDateTEController.text, toDate: Get.find<FilterSpecificNodeDataController>().toDateTEController.text);
    //   plotLineController.fetchMaxMachineData(nodeName: widget.elementName);
    // });


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



    Get.find<ThisDayDataController>().fetchThisDayData(sourceName: widget.elementName);
    Get.find<ThisMonthDataController>().fetchThisMonthData(sourceName: widget.elementName);
    Get.find<ThisYearDataController>().fetchThisYearData(sourceName: widget.elementName);

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
      body: SingleChildScrollView(
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
                child: GetBuilder<FilterSpecificNodeDataController>(
                  builder: (filterSpecificNodeDataController) {
                    return Column(
                      children: [
                        SizedBox(height: size.height * k50TextSize),
        
                        GetBuilder<TodayRuntimeDataController>(
                          builder: (controller) {
        
                            final thisDayController = Get.find<ThisDayDataController>();
                            final thisMonthController = Get.find<ThisMonthDataController>();
                            final thisYearController = Get.find<ThisYearDataController>();
        
                            return RunTimeInformationWidget(
                              viewName: 'revenueView',
                              elementCategory: 'Energy',
                              generator: widget.generator,
                              size: size,
                              elementName: widget.elementName,
                              todayRuntime: controller.todayRunTimeData.runtimeToday.toString(),
                              thisDay: thisDayController.thisDayData.cost ?? 0.00,
                              thisMonth: thisMonthController.thisMonthData.isNotEmpty ? thisMonthController.thisMonthData[0].cost ?? 0.00 : 0.00,
                              thisYear: thisYearController.thisYearData.costSum ?? 0.00,
                            );
                          }
                        ),
        
                        SizedBox(height: size.height * k8TextSize),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.height * k16TextSize,
                            //vertical: size.height * k8TextSize,
                          ),
                          child: PowerDateWidget(nodeName: widget.elementName,),
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
        
                                          widget.solarCategory == 'Solar' ?   Expanded(child: TextComponent(text: "Today ${widget.elementName} Revenue (BDT)",fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,maxLines: 1,))
                                              : Expanded(child: TextComponent(text: "Today ${widget.elementName} Cost (BDT)",fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,maxLines: 1,)),
        
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
                                    GetBuilder<DailyDataController>(
                                        builder: (dailyDataController) {
                                          if(dailyDataController.isLoading){
                                            return CustomShimmerWidget(height:  size.height * .28, width: double.infinity);
                                          }else if(!dailyDataController.isConnected){
                                            return Lottie.asset(AssetsPath.noInternetJson, height: size.height * 0.23);
                                          }
                                          else if(dailyDataController.hasError){
                                            return Lottie.asset(AssetsPath.errorJson, height: size.height * 0.25);
                                          }
        
                                          return GetBuilder<FilterSpecificNodeDataController>(
                                              builder: (controller) {
                                                return SizedBox(
                                                    height: size.height * .35,
                                                    child: controller.selectedButton == 2 ?
                                                    FilterCostChartWidget(size,controller.graphType,controller.lineChartDataList,controller.monthlyBarChartDataList,controller.yearlyBarChartDataList)
                                                        :  DailyLineChartWidget(elementName: widget.elementName,viewName: 'powerView', dailyDataList: dailyDataController.dailyDataList, /*screenName: 'powerAndEnergy', machineMaxPowerModel: plotLineController.plotMachineMaxPower,*/ )
                                                );
                                              }
                                          );
        
        
                                          /*return SizedBox(
                                              height: size.height * .35,
                                              child:  DailyLineChartWidget(elementName: widget.elementName,viewName: 'revenueView', dailyDataList: dailyDataController.dailyDataList, screenName: 'powerAndEnergy',));*/
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
        
                        filterSpecificNodeDataController.selectedButton == 1 ?
                       Column(
                         children: [
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
                                             widget.solarCategory == 'Solar' ?   Expanded(child: TextComponent(text: "This month ${widget.elementName} Revenue (BDT)",fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,maxLines: 1,)) :
                                             Expanded(child: TextComponent(text: "This month ${widget.elementName} Cost (BDT)",fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,maxLines: 1,)),
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
                                       GetBuilder<MonthlyDataController>(
                                           builder: (monthlyDataController) {
                                             if(monthlyDataController.isLoading){
                                               return CustomShimmerWidget(height:  size.height * .28, width: double.infinity);
                                             }else if(!monthlyDataController.isConnected){
                                               return Lottie.asset(AssetsPath.noInternetJson, height: size.height * 0.23);
                                             }
                                             else if(monthlyDataController.hasError){
                                               return Lottie.asset(AssetsPath.errorJson, height: size.height * 0.25);
                                             }
                                             return SizedBox(
                                                 height: size.height * .35,
                                                 child: MonthlyDetailsBarChartWidget(elementName: widget.elementName,solarCategory: widget.solarCategory,viewName: 'revenueView',monthlyDataModelList:monthlyDataController.monthlyDataList, screenName: 'PowerScreen',));
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
                                             widget.solarCategory == 'Solar' ?   Expanded(child: TextComponent(text: "This year ${widget.elementName} Revenue (BDT)",fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,maxLines: 1,))
                                                 : Expanded(child: TextComponent(text: "This year ${widget.elementName} Cost (BDT)",fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,maxLines: 1,)),
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
                                       GetBuilder<YearlyDataController>(
                                           builder: (yearlyDataController) {
                                             if(yearlyDataController.isLoading){
                                               return CustomShimmerWidget(height:  size.height * .28, width: double.infinity);
                                             }else if(!yearlyDataController.isConnected){
                                               return Lottie.asset(AssetsPath.noInternetJson, height: size.height * 0.23);
                                             }
                                             else if(yearlyDataController.hasError){
                                               return Lottie.asset(AssetsPath.errorJson, height: size.height * 0.25);
                                             }
                                             return SizedBox(
                                                 height: size.height * .35,
                                                 child: YearlyBarChartWidget(elementName: widget.elementName,screenName: 'powerScreen', yearlyDataModelList: yearlyDataController.yearlyDataList, viewName: 'revenueView',));
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
                       ) :  Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: (){
                                  filterSpecificNodeDataController.downloadDataSheet(context);
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
                              child: SpecificNodeDataTable(
                                tableData: filterSpecificNodeDataController.filterSpecificNodeTableModel,
                              ),
                            ),
                          ],
                        ),
        
                        SizedBox(height: size.height * 0.4,)
        
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




