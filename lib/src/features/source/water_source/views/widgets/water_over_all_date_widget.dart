import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/small_button_circular_progress_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/source/water_source/controller/over_all_source_water_data_controller.dart';
import 'package:nz_fabrics/src/features/source/water_source/views/widgets/sub_part/water_source_table_widget.dart';

import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class OverAllDateWidget extends StatefulWidget {
  const OverAllDateWidget({super.key});

  @override
  State<OverAllDateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<OverAllDateWidget> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GetBuilder<OverAllWaterSourceDataController>(
            builder: (filterSpecificNodeDataController) {
              return CustomContainer(
                  height: size.height * 0.14,
                  width: double.infinity,
                  borderRadius:
                  BorderRadius.circular(size.height * k16TextSize),
                  child: Stack(
                    children: [
                      Positioned(
                        top: size.height * 0.020,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize),
                          child:  Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GetBuilder<OverAllWaterSourceDataController>(
                                      builder: (controller) {
                                        return SizedBox(
                                          width: size.width * 0.42,
                                          child: TextFormField(
                                            onTap: () async {

                                              controller.formDatePicker(context);
                                            },

                                            style: TextStyle(fontSize: size.height * k18TextSize),
                                            controller: controller.fromDateTEController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  top: 0,
                                                  bottom: 0,
                                                  left: size.height * k16TextSize),
                                              hintText: "From Date",
                                              suffixIcon: Icon(
                                                Icons.calendar_today_outlined,
                                                size: size.height * k24TextSize,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                  SizedBox(
                                    width: size.width * 0.04,
                                  ),
                                  GetBuilder<OverAllWaterSourceDataController>(
                                      builder: (controller) {
                                        return SizedBox(
                                          width: size.width * 0.43,
                                          child: TextFormField(
                                            onTap: () {
                                              controller.toDatePicker(context);
                                            },
                                            style: TextStyle(fontSize: size.height * k18TextSize),
                                            controller: controller.toDateTEController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: size.height * k16TextSize),
                                              hintText: "To Date",
                                              suffixIcon: Icon(
                                                Icons.calendar_today_outlined,
                                                size: size.height * k24TextSize,
                                              ),
                                            ),
                                            // validator: validator,
                                          ),
                                        );
                                      }),
                                ],
                              ),
                              SizedBox(height: size.width > 600 ? size.height * k16TextSize : size.height * k8TextSize,),
                              SizedBox(
                                height: size.width > 600 ? size.height * 0.05 :  size.width * 0.1,
                                width: size.width * 0.4,
                                child: GetBuilder<OverAllWaterSourceDataController>(
                                    builder: (controller) {
                                      return ElevatedButton(

                                          onPressed: () async {
                                            controller.dateDifferenceDates(context);
                                            await controller.fetchOverAllSourceData(fromDate:  controller.fromDateTEController.text, toDate:  controller.toDateTEController.text,fromButton: true);
                                            Get.find<WaterSourceDataController>().fetchData(controller.fromDateTEController.text,controller.toDateTEController.text);
                                          }, child: controller.isFilterButtonProgress ? SmallButtonCircularProgressBarWidget(size: size)  : const TextComponent(text: "Submit",color: AppColors.whiteTextColor,));
                                    }
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ));
            })
      ],
    );
  }

  void fetchData(DateTime fromDate, DateTime toDate) {
    // Implement the logic to fetch data based on the selected date range.
    // For example:
    debugPrint('Fetching data from $fromDate to $toDate');
  }
}