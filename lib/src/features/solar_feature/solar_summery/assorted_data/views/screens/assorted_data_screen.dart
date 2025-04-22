import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/controllers/assorted_data_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/views/widgets/daily_power_consumption_cart.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/views/widgets/plant_live_data_Table.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/views/widgets/radiation_data_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/views/widgets/solar_container_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/views/widgets/three_row_widget.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AssortedDataScreen extends StatefulWidget {
  const AssortedDataScreen({super.key});

  @override
  State<AssortedDataScreen> createState() => _AssortedDataScreenState();
}

class _AssortedDataScreenState extends State<AssortedDataScreen> with TickerProviderStateMixin {


  late AnimationController _controller1;
  late  Animation<double> _animation1;


  @override
  void initState() {
    super.initState();


    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation1 = Tween<double>(begin: 0, end: 0.5).animate(_controller1);

    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<AssortedDataController>().fetchPlantLiveData();
    });

  }

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    final TabController tabController = DefaultTabController.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      body: SingleChildScrollView(
        primary: false,
        child: Padding(
          padding: EdgeInsets.all(size.height * k16TextSize),
          child: Column(
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
                             child: const Align(
                                 alignment: Alignment.topLeft,
                                 child: TextComponent(text: "Generator",color: AppColors.secondaryTextColor,)),
                           ),
                           Divider(color: Colors.grey.shade300,),

                           SvgPicture.asset(AssetsPath.solarGenerationImageSVG,width: size.height * 0.25,),
                           SizedBox(height: size.height * k8TextSize,),
                           const TextComponent(text: "Today’s Net",color: AppColors.secondaryTextColor,),
                           TextComponent(text: "${assortedDataController.plantLiveDataModel.todayEnergy?.toStringAsFixed(2) ?? 0.0} kWh",fontSize: size.height * k24TextSize,),
                           Padding(
                             padding: EdgeInsets.symmetric(horizontal: size.height * 0.076,vertical: size.height * 0.004),
                             child: const Divider(),
                           ),
                           const TextComponent(text: "Yesterday’s Net",color: AppColors.secondaryTextColor,),
                           TextComponent(text:  "${assortedDataController.plantLiveDataModel.yesterdayEnergy?.toStringAsFixed(2) ?? 0.0} kWh",fontSize: size.height * k24TextSize,),
                         ],
                       );
                     }
                   ),
                 ),

                 SolarContainerWidget(
                   height: size.height * 0.35,
                   size: size,

                   child: Column(
                     children: [
                       Padding(
                         padding: EdgeInsets.only(left: size.height * k16TextSize,right: size.height * k16TextSize,top: size.height * k8TextSize ),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             const TextComponent(text: "Radiation",color: AppColors.secondaryTextColor,),
                             GestureDetector(
                                 onTap: (){
                                    tabController.animateTo(3);
                                 },
                                 child: SvgPicture.asset(AssetsPath.listIconSVG))
                           ],
                         ),
                       ),
                       Divider(color: Colors.grey.shade300,),

                       SvgPicture.asset(AssetsPath.solarRadiationImageSVG,width: size.height * 0.19,),
                       SizedBox(height: size.height * k12TextSize,),

                       RadiationDataWidget(size: size),
                     ],
                   ),
                 ),
               ],
             ),

              SizedBox(height: size.height * k18TextSize,),

              ThreeRowWidget(size:size),
              SizedBox(height: size.height * k25TextSize,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ]
                ),
                  height: size.height * 0.34,
                  child: const PlantLiveDataTable()),
              SizedBox(height: size.height * k18TextSize,),
              Padding(
                padding: EdgeInsets.symmetric(

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
                      //////--------------------------------daily chart 1 ----------------
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
                                const Expanded(child: TextComponent(text: "Daily Plant Power Consumption  & Cost",fontWeight: FontWeight.w600,overflow: TextOverflow.ellipsis,maxLines: 1,)),
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
                            padding: EdgeInsets.symmetric(horizontal: size.width * k20TextSize),
                            child: const Divider(thickness: 2),
                          ),
                          GetBuilder<AssortedDataController>(
                              builder: (assortedDataController) {
                                // if(dailyDataController.isLoading){
                                //   return CustomShimmerWidget(height:  size.height * .28, width: double.infinity);
                                // }else if(!dailyDataController.isConnected){
                                //   return Lottie.asset(AssetsPath.noInternetJson, height: size.height * 0.23);
                                // }
                                // else if(dailyDataController.hasError){
                                //   return Lottie.asset(AssetsPath.errorJson, height: size.height * 0.25);
                                // }
                                return SizedBox(
                                    height: size.height * .42,
                                    child: const DailyPowerConsumptionCart() ,
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

            ],
          ),
        ),
      ),
    );
  }
}




