import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/empty_page_widget/empty_page_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/machine_screen/controller/acknowledge_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pf_controller/acknowledge_event_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class AcKnowledgeHistoryScreen extends StatefulWidget {
  final String nodeName;
  const AcKnowledgeHistoryScreen({super.key, required this.nodeName});

  @override
  State<AcKnowledgeHistoryScreen> createState() => _AcKnowledgeHistoryScreenState();
}

class _AcKnowledgeHistoryScreenState extends State<AcKnowledgeHistoryScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AcknowledgeDataController>().fetchAcknowledgeHistory(nodeName: widget.nodeName);
    });
    log("ac ====>${widget.nodeName}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar:   CustomAppBarWidget(
        text: "Acknowledge ${widget.nodeName}",
        backPreviousScreen: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(size.height * k12TextSize),
        child: GetBuilder<AcknowledgeDataController>(
          builder: (acknowledgeDataController) {
            final groupedData = acknowledgeDataController.groupedPFNotifications;

            if(acknowledgeDataController.isAcknowledgeHistoryInProgress){
              return Center(child: Lottie.asset(AssetsPath.loadingJson, height: size.height * 0.12));


            }
            if(acknowledgeDataController.pfHistoryList.isEmpty){
              return EmptyPageWidget(size: size);

            }

            return ListView.builder(
              itemCount: groupedData.keys.length,
              itemBuilder: (context, groupIndex) {
                String groupKey = groupedData.keys.elementAt(groupIndex);
                List groupedItems = groupedData[groupKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Title (Today, Yesterday, or Date)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                      child: Text(
                        groupKey,
                        style: TextStyle(
                          fontSize: size.height * k16TextSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // List of Notifications in the Group
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: groupedItems.length,
                      itemBuilder: (context, index) {
                        final item = groupedItems[index];
                        String timeDate = item.timedate ?? '';
                        DateTime parsedDate = DateTime.parse(timeDate);
                        String formattedTime = DateFormat("yyyy MMM dd, h:mm a").format(parsedDate);


                        return GestureDetector(
                          onTap: ()async{
                            final response =  await Get.find<AcknowledgeEventController>().updateAcknowledgeEvent(id: acknowledgeDataController.pfHistoryList[index].id ?? 0);
                            if(response){
                              Get.find<AcknowledgeDataController>().fetchAcknowledgeHistory(nodeName: widget.nodeName);
                            }
                          },
                          child: Card(
                            color: acknowledgeDataController .pfHistoryList[index].acknowledged ?? false ? AppColors.whiteTextColor : AppColors.pfHistoryCardColor,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: acknowledgeDataController.pfHistoryList[index].acknowledged ?? false
                                    ? AppColors.containerBorderColor
                                    : AppColors.pfHistoryCardColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0), // Optional: Customize corner radius
                            ),
                            elevation: 0.0,
                            child: Padding(
                              padding: EdgeInsets.all(size.height * k10TextSize),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TextComponent(
                                        text: formattedTime,
                                        fontFamily: boldFontFamily,
                                        fontSize: size.height * k14TextSize,
                                      ),
                                      const Spacer(),
                                      acknowledgeDataController.pfHistoryList[index].acknowledged ?? false
                                          ? SvgPicture.asset(AssetsPath.pfSuccessIconSVG)
                                          : const SizedBox()

                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.002),
                                  Text.rich(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: item.nodeName,
                                          style: TextStyle(
                                            fontSize: size.height * k16TextSize,
                                            fontFamily: boldFontFamily,
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' is fail to connect, Please check the Tank & Solve it.',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: size.height * k5TextSize,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
