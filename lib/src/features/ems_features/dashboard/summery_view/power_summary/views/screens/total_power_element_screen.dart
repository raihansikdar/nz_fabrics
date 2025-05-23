import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/common_widget/color_palette_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/each_category_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/machine_view_names_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/screen/power_and_energy_element_details_screen.dart';
import 'package:nz_fabrics/src/features/error_page/error_page.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class TotalPowerElementScreen extends StatefulWidget {
  final String categoryName;
  const TotalPowerElementScreen({super.key, required this.categoryName});

  @override
  State<TotalPowerElementScreen> createState() => _TotalPowerElementScreenState();
}

class _TotalPowerElementScreenState extends State<TotalPowerElementScreen> {


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<EachCategoryLiveDataController>().fetchEachCategoryLiveData(categoryName: widget.categoryName);


      Get.find<CategoryWiseLiveDataController>().stopApiCallOnScreenChange();
      Get.find<MachineViewNamesDataController>().stopApiCallOnScreenChange();

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBarWidget(text: widget.categoryName, backPreviousScreen: true,onBackButtonPressed: (){
        Get.find<CategoryWiseLiveDataController>().startApiCallOnScreenChange();
        Get.find<MachineViewNamesDataController>().startApiCallOnScreenChange();
      },),
      body:  GetBuilder<EachCategoryLiveDataController>(
        builder: (eachCategoryLiveDataController) {
          return ListView.separated(
            padding: EdgeInsets.only(top: size.height * k8TextSize,bottom: size.height * k8TextSize),

            itemCount: eachCategoryLiveDataController.isLoading ? 8 :
            eachCategoryLiveDataController.eachCategoryDataList.isEmpty ?
                1 :  eachCategoryLiveDataController.hasError ? 1 :
            eachCategoryLiveDataController.eachCategoryDataList.length,
            itemBuilder: (context,index){
              if(eachCategoryLiveDataController.isLoading){
                return Padding(
                  padding: EdgeInsets.all(size.height * k8TextSize),
                  child: CustomShimmerWidget(height: size.height * 0.09 , width: double.infinity,),
                );
              } else if(eachCategoryLiveDataController.eachCategoryDataList.isEmpty || eachCategoryLiveDataController.hasError){
                return Center(child: Lottie.asset(AssetsPath.emptyJson,height: size.height * 0.250));
              } else if(eachCategoryLiveDataController.hasError){
                return ErrorPage(onRetry: (){
                  eachCategoryLiveDataController.fetchEachCategoryLiveData(categoryName: widget.categoryName);
                });
              }

              else{
                dynamic categoryData = eachCategoryLiveDataController.eachCategoryDataList[index];


                      return  Padding(
                        padding: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize,),
                        child: GestureDetector(
                          onTap: (){

                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => PowerAndEnergyElementDetailsScreen(
                                  elementName: categoryData.node ?? '',
                                  gaugeValue: categoryData.power ?? 0.00,
                                  gaugeUnit: 'kW',
                                  elementCategory: 'Power',
                                  solarCategory: widget.categoryName,
                                ),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(milliseconds: 0)
                              ),
                            );

                            // Navigator.push(
                            //   context,
                            //   PageRouteBuilder(
                            //     transitionDuration: const Duration(seconds: 1),
                            //     pageBuilder: (context, animation, secondaryAnimation) =>
                            //         PowerAndEnergyElementDetailsScreen(
                            //           elementName: categoryData.node ?? '',
                            //           gaugeValue: categoryData.power ?? 0.00,
                            //           gaugeUnit: 'kW',
                            //           elementCategory: 'Power',
                            //           solarCategory: widget.categoryName,
                            //         ),
                            //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            //       const begin = Offset(1.0, 0.0); // Start from right
                            //       const end = Offset.zero; // End at current position
                            //       const curve = Curves.easeInOut;
                            //
                            //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            //       var offsetAnimation = animation.drive(tween);
                            //
                            //       return SlideTransition(
                            //         position: offsetAnimation,
                            //         child: child,
                            //       );
                            //     },
                            //   ),
                            // );



                            // log("===========> press card");
                            // log("===========> ${widget.categoryName}");
                            // log("===========> ${categoryData.node}");
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
                                                  TextComponent(text: categoryData.node ?? ''),
                                                  categoryData.status == true  ?
                                                  const TextComponent(text: "(Active)",color: AppColors.primaryColor, ) :  const TextComponent(text: " (Inactive)",color: Colors.red ) ,


                                                ],
                                              ),

                                              Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const TextComponent(text: "Total Power ",color: AppColors.secondaryTextColor,),
                                                      SizedBox(width: size.height * k16TextSize,),
                                                      const TextComponent(text: "Today Energy ",color: AppColors.secondaryTextColor,),
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
                                                      TextComponent(text: " ${categoryData.power?.toStringAsFixed(2) ?? '0.0'} kW",),
                                                      TextComponent(text: " ${categoryData.netEnergy?.toStringAsFixed(2) ?? '0.00'} kWh"),
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
    hexColor = hexColor.replaceAll('#', ''); // Remove the '#' if present
    return Color(int.parse('FF$hexColor', radix: 16)); // Add 'FF' for full opacity
  }
}
