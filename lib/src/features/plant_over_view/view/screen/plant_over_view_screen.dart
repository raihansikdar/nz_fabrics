import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/empty_page_widget/empty_page_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/plant_over_view/controller/layout_controller.dart';
import 'package:nz_fabrics/src/features/plant_over_view/model/layout_summary_details_model.dart';
import 'package:nz_fabrics/src/features/plant_over_view/view/screen/layout_image_details.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class PlantOverViewScreen extends StatefulWidget {
  const PlantOverViewScreen({super.key});

  @override
  State<PlantOverViewScreen> createState() => _PlantOverViewScreenState();
}

class _PlantOverViewScreenState extends State<PlantOverViewScreen> {

  @override
  void initState() {
   WidgetsBinding.instance.addPostFrameCallback((_){
     Get.find<PlantLayoutController>().fetchLayoutData();
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBarWidget(text: "Plant OverView", backPreviousScreen: true),
      body: GetBuilder<PlantLayoutController>(
        builder: (layoutController) {
          if( layoutController.isLayoutListInProgress || layoutController.isLayoutSummaryListInProgress){
            return Center(child: Center(child: SpinKitFadingCircle(
              color: AppColors.primaryColor,
              size: 50.0,
            ),));

          } else if(layoutController.layoutSummaryDetailsList.isEmpty){
            return EmptyPageWidget(size: size);
          }
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: layoutController.layoutNameList.length,
            itemBuilder: (context, index) {

              String layoutName = layoutController.layoutNameList[index].name ?? '';
              List<LayoutSummaryDetailsModel> layoutDetails = layoutController.layoutSummaryDetailsList[index][layoutName] ?? [];

              return Theme(
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
                  showTrailingIcon: false,
                  title: Card(
                    color: AppColors.whiteTextColor,
                    child: Column(
                      children: [
                        Container(
                          height: size.height * 0.04,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.plantBlueTextColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(size.height * k16TextSize),
                              topRight: Radius.circular(size.height * k16TextSize),
                            ),
                          ),
                          child: Center(
                            child: TextComponent(text: layoutName, color: AppColors.whiteTextColor),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SizedBox(
                            height: size.width > 550 ?  size.height * 0.5 : size.height * 0.4,
                            child: Column(
                              children: [
                                GestureDetector(
                                    onTap: (){
                                      Get.to(()=> LayoutImageDetails(
                                        layoutImageUrl: layoutController.layoutNameList[index].imageUrl ?? '',
                                          layoutName: layoutName,
                                      ),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: layoutController.layoutNameList[index].imageUrl ?? '' ,
                                      placeholder: (context, url) => const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),

                                  /*Image.network(layoutController.layoutNameList[index].imageUrl ?? ''),*/

                                ),
                                Expanded(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    primary: false,
                                   // physics: const NeverScrollableScrollPhysics(),
                                    itemCount: layoutDetails.length,
                                    itemBuilder: (context, innerIndex) {
                                      LayoutSummaryDetailsModel detail = layoutDetails[innerIndex];

                                      return Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.height * k8TextSize, vertical: size.height * 0.006),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(size.height * k8TextSize),
                                            border: Border.all(color: AppColors.containerBorderColor, width: 1.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(size.height * k8TextSize),
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
                                                tilePadding: EdgeInsets.zero,
                                                title: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: size.height * k8TextSize),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          TextComponent(text: detail.machineType ?? ''),
                                                        ],
                                                      ),
                                                      SizedBox(width: size.width * k16TextSize),
                                                      const Column(
                                                        children: [
                                                          TextComponent(text: ":")
                                                        ],
                                                      ),
                                                      SizedBox(width: size.width * k16TextSize),
                                                       Column(
                                                        children: [
                                                          TextComponent(text: "${detail.activeMachine}/${detail.totalMachine}")
                                                        ],
                                                      ),
                                                      SizedBox(width: size.width * k16TextSize),
                                                       Column(
                                                        children: [
                                                          TextComponent(text: "(${detail.totalPower?.toStringAsFixed(2) ?? 0.00} kW)")
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                children: [

                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: size.width * k16TextSize),
                                                    child:  Divider(thickness: 1, color: Colors.grey.shade300),
                                                  ),
                                                  SingleChildScrollView(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(bottom: 8.0),
                                                      child: ListView.separated(
                                                        shrinkWrap: true,
                                                        primary: false,
                                                        itemCount: 1,
                                                        itemBuilder: (context, moreInnerIndex) {

                                                          return Padding(
                                                            padding: const EdgeInsets.only(left: 8.0),
                                                            child: Row(
                                                              children: [

                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: () {
                                                                    List<Widget> widgetList = [];

                                                                    for (int index = 0; index < (detail.data?.entries.length ?? 0); index++) {

                                                                      if (index % 2 != 0) {
                                                                        var entry = detail.data?.entries.elementAt(index);

                                                                        widgetList.add(
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                height: 10,
                                                                                width: 10,
                                                                                color: _getValidHexColor(entry?.value ?? ""),
                                                                              ),
                                                                              SizedBox(height: size.height * k22TextSize),
                                                                              SizedBox(width: size.width * k16TextSize),
                                                                              // TextComponent(text: "${entry?.value}"),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }
                                                                    }

                                                                    return widgetList;
                                                                  }(),
                                                                ),


                                                                SizedBox(width: size.width * k16TextSize),

                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: () {
                                                                    List<Widget> widgetList = [];

                                                                    for (int index = 0; index < (detail.data?.entries.length ?? 0); index++) {

                                                                      if (index % 2 == 0) {
                                                                        var entry = detail.data?.entries.elementAt(index);

                                                                        widgetList.add(
                                                                          Row(
                                                                            children: [
                                                                              TextComponent(text: "${entry?.key} ",color: AppColors.secondaryTextColor,),
                                                                              SizedBox(width: size.width * k16TextSize),
                                                                              // TextComponent(text: "${entry?.value}"),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }
                                                                    }

                                                                    return widgetList;
                                                                  }(),
                                                                ),


                                                                SizedBox(width: size.width * k16TextSize),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: () {
                                                                    List<Widget> widgetList = [];

                                                                    for (int index = 0; index < (detail.data?.entries.length ?? 0); index++) {
                                                                      if (index % 2 == 0) {
                                                                       // var entry = detail.data?.entries.elementAt(index);


                                                                        widgetList.add(
                                                                          Row(
                                                                            children: [
                                                                              const TextComponent(text: " : "),
                                                                              SizedBox(width: size.width * k16TextSize),
                                                                              // TextComponent(text: "${entry?.value}"),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }
                                                                    }

                                                                    return widgetList;
                                                                  }(),
                                                                ),
                                                                SizedBox(width: size.width * k16TextSize),
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: () {
                                                                    List<Widget> widgetList = [];

                                                                    for (int index = 0; index < (detail.data?.entries.length ?? 0); index++) {
                                                                      // Check if the index is even (0, 2, 4, ...)
                                                                      if (index % 2 == 0) {
                                                                        var entry = detail.data?.entries.elementAt(index);

                                                                        // Add the entry.key to the widget list
                                                                        widgetList.add(
                                                                          Row(
                                                                            children: [
                                                                              TextComponent(text: "${entry?.value.toStringAsFixed(2)} kW"),
                                                                              SizedBox(width: size.width * k16TextSize),
                                                                              // TextComponent(text: "${entry?.value}"),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }
                                                                    }

                                                                    return widgetList;
                                                                  }(),
                                                                ),

                                                              ],
                                                            ),
                                                          );
                                                        },


                                                        separatorBuilder: (context, index) => const SizedBox(height: 5,),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) => const SizedBox(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(),
          );

        }
      ),
    );
  }
}


Color _getValidHexColor(String hexColor) {
  if (hexColor == "No Color Data" || !hexColor.startsWith("#")) {
    // Fallback color if the color data is invalid or missing
    return Colors.grey;  // Or choose any default color you want
  }
  return HexColor(hexColor);
}

