import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/color_palette_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/pie_chart_water_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/pie_chart_water_source_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/water_each_load_category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/water_load_category_wise_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/water_source_category_wise_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/water/water_element_details_screen.dart';
import 'package:nz_fabrics/src/features/error_page/error_page.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class TotalWaterLoadElementScreen extends StatefulWidget {
  final String categoryName;
  const TotalWaterLoadElementScreen({super.key, required this.categoryName});

  @override
  State<TotalWaterLoadElementScreen> createState() => _TotalWaterLoadElementScreenState();
}

class _TotalWaterLoadElementScreenState extends State<TotalWaterLoadElementScreen> {


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<WaterEachLoadCategoryWiseLiveDataController>().fetchEachCategoryLiveData(categoryName: widget.categoryName);

      Get.find<WaterSourceCategoryWiseDataController>().stopApiCallOnScreenChange();
      Get.find<WaterLoadCategoryWiseDataController>().stopApiCallOnScreenChange();
      Get.find<PieChartWaterSourceController>().stopApiCallOnScreenChange();
      Get.find<PieChartWaterLoadController>().stopApiCallOnScreenChange();

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBarWidget(text: widget.categoryName, backPreviousScreen: true,onBackButtonPressed: (){
        Get.find<WaterSourceCategoryWiseDataController>().startApiCallOnScreenChange();
        Get.find<WaterLoadCategoryWiseDataController>().startApiCallOnScreenChange();
        Get.find<PieChartWaterSourceController>().startApiCallOnScreenChange();
        Get.find<PieChartWaterLoadController>().startApiCallOnScreenChange();
      },),
      body:  GetBuilder<WaterEachLoadCategoryWiseLiveDataController>(
          builder: (waterEachLoadCategoryWiseLiveDataController) {
            return ListView.separated(
              padding: EdgeInsets.only(top: size.height * k8TextSize,bottom: size.height * k8TextSize),

              itemCount: waterEachLoadCategoryWiseLiveDataController.isLoading ? 8 :
              waterEachLoadCategoryWiseLiveDataController.waterEachLoadCategoryDataList.isEmpty ?
              1 :  waterEachLoadCategoryWiseLiveDataController.hasError ? 1 :
              waterEachLoadCategoryWiseLiveDataController.waterEachLoadCategoryDataList.length,
              itemBuilder: (context,index){
                if(waterEachLoadCategoryWiseLiveDataController.isLoading){
                  return Padding(
                    padding: EdgeInsets.all(size.height * k8TextSize),
                    child: CustomShimmerWidget(height: size.height * 0.09 , width: double.infinity,),
                  );
                } else if(waterEachLoadCategoryWiseLiveDataController.waterEachLoadCategoryDataList.isEmpty || waterEachLoadCategoryWiseLiveDataController.hasError){
                  return Center(child: Lottie.asset(AssetsPath.emptyJson,height: size.height * 0.250));
                } else if(waterEachLoadCategoryWiseLiveDataController.hasError){
                  return ErrorPage(onRetry: (){
                    waterEachLoadCategoryWiseLiveDataController.fetchEachCategoryLiveData(categoryName: widget.categoryName);
                  });
                }

                else{
                  dynamic waterCategoryData = waterEachLoadCategoryWiseLiveDataController.waterEachLoadCategoryDataList[index];


                  return  Padding(
                    padding: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize,),
                    child: GestureDetector(
                      onTap: (){

                        Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>  WaterElementDetailsScreen(elementName: waterCategoryData.node ?? '',
                                  gaugeValue: waterCategoryData.instantFlow ?? 0.00 , gaugeUnit: 'm³/h',elementCategory: 'Water'
                              )

                              /*PowerAndEnergyElementDetailsScreen(
                                elementName: waterCategoryData.node ?? '',
                                gaugeValue: waterCategoryData.instantFlow ?? 0.00,
                                gaugeUnit: 'kW',
                                elementCategory: 'Power',
                                solarCategory: widget.categoryName,
                              )*/,
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 0)
                          ),
                        );

                      },
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(size.height * k8TextSize),
                            side: const BorderSide(color: AppColors.containerBorderColor)
                        ),
                        color: AppColors.listTileColor,
                        child:  Column(
                          children: [
                            ListTile(

                              contentPadding: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize),
                              // leading: widget.categoryName == 'Grid' ?  SvgPicture.asset(AssetsPath.gridIconSVG,height: size.height * k24TextSize,) : widget.categoryName  == 'Gas_Generator' ?  SvgPicture.asset(AssetsPath.gasGeneratorIconSVG,height: size.height * k24TextSize,)
                              //
                              //     : widget.categoryName  == 'Diesel_Generator' ?  SvgPicture.asset(AssetsPath.dieselGeneratorIconSVG,height: size.height * k24TextSize,) : SvgPicture.asset(AssetsPath.solarCellIconSVG,height: size.height * k24TextSize,),
                              title: Padding(
                                padding: EdgeInsets.only(left: size.height * k8TextSize),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: size.height * k16TextSize,
                                          width: size.height * k16TextSize,
                                          decoration: BoxDecoration(
                                              color: colorPalette[index % colorPalette.length],
                                              borderRadius: BorderRadius.circular(size.height * 0.003)
                                          ),

                                        ),
                                        SizedBox(width: size.width * k16TextSize,),
                                        TextComponent(text: waterCategoryData.node ?? ''),
                                        waterCategoryData.status == true  ?
                                        const TextComponent(text: "(Active)",color: AppColors.primaryColor, ) :  const TextComponent(text: " (Inactive)",color: Colors.red ) ,


                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const TextComponent(text: "Water Flow ",color: AppColors.secondaryTextColor,),
                                            SizedBox(width: size.height * k16TextSize,),
                                            const TextComponent(text: "Today Volume ",color: AppColors.secondaryTextColor,),
                                          ],
                                        ),

                                        Column(
                                          children: [
                                            const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,),
                                            SizedBox(width: size.height * k16TextSize,),
                                            const TextComponent(text: " : ",color: AppColors.secondaryTextColor,fontFamily: boldFontFamily,),
                                          ],
                                        ),

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            TextComponent(text: " ${waterCategoryData.instantFlow?.toStringAsFixed(2) ?? '0.0'} m³/h",),
                                            TextComponent(text: " ${waterCategoryData.volume?.toStringAsFixed(2) ?? '0.00'} m³"),
                                          ],
                                        )

                                      ],
                                    )

                                  ],
                                ),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_right_outlined,color: AppColors.secondaryTextColor,size: size.height* k40TextSize,),
                            ),

                          ],
                        ),

                      ),
                    ),
                  );
                }
              }, separatorBuilder: (context,index) => const SizedBox(height: 0,),);
          }
      ),
    );
  }
  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }
}
