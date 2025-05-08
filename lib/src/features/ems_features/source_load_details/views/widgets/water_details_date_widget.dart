import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:nz_fabrics/src/common_widgets/small_button_circular_progress_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/filter_specific_node_data/water_filter_specific_node_data_controller.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WaterDetailsDateWidget extends StatefulWidget {
  final String nodeName;
  const WaterDetailsDateWidget({super.key, required this.nodeName});

  @override
  State<WaterDetailsDateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<WaterDetailsDateWidget> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GetBuilder<WaterFilterSpecificNodeDataController>(
            builder: (filterSpecificNodeDataController) {
              return CustomContainer(
                  height: filterSpecificNodeDataController.selectedButton == 1 ? size.height * 0.05  : size.height * 0.2,
                  width: double.infinity,
                  borderRadius:
                  BorderRadius.circular(size.height * k16TextSize),
                  child: Stack(
                    children: [
                      Container(
                          height: size.height * 0.070,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(size.height * k16TextSize),
                              border: const Border(
                                bottom: BorderSide(
                                  color: AppColors.containerBorderColor,
                                  width: 1.0,
                                ),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomRectangularRadioButton<int>(
                                value: 1,
                                groupValue:
                                filterSpecificNodeDataController.selectedButton,
                                onChanged: (value) {
                                  filterSpecificNodeDataController.updateSelectedButton(value: value!);
                                },
                                label: 'Daily',
                              ),

                              CustomRectangularRadioButton<int>(
                                value: 2,
                                groupValue:
                                filterSpecificNodeDataController.selectedButton,
                                onChanged: (value) {
                                  filterSpecificNodeDataController.updateSelectedButton(value: value!);
                                },
                                label: 'Custom',
                              ),
                            ],
                          )),
                      Positioned(
                        top: size.height * 0.080,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize),
                          child: filterSpecificNodeDataController.selectedButton == 1
                              ? const SizedBox()
                             : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  GetBuilder<WaterFilterSpecificNodeDataController>(
                                      builder: (filterSpecificNodeDataController) {
                                        return SizedBox(
                                          width: size.width * 0.370,
                                          child: TextFormField(
                                            onTap: () async {

                                              filterSpecificNodeDataController.formDatePicker(context);
                                            },

                                            style: TextStyle(fontSize: size.height * k18TextSize),
                                            controller: filterSpecificNodeDataController.fromDateTEController,
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
                                    width: size.width * 0.050,
                                  ),
                                  GetBuilder<WaterFilterSpecificNodeDataController>(
                                      builder: (filterSpecificNodeDataController) {
                                        return SizedBox(
                                          width: size.width * 0.385,
                                          child: TextFormField(
                                            onTap: () {
                                              filterSpecificNodeDataController.toDatePicker(context);
                                            },
                                            style: TextStyle(fontSize: size.height * k18TextSize),
                                            controller: filterSpecificNodeDataController.toDateTEController,
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
                              SizedBox(height: size.width > 600 ? size.height * k12TextSize : size.height * k8TextSize,),
                              SizedBox(
                                height: size.width > 600 ? size.width * 0.07 : size.width * 0.1,
                                width: size.width * 0.4,
                                child: GetBuilder<WaterFilterSpecificNodeDataController>(
                                    builder: (filterSpecificNodeDataController) {
                                      return ElevatedButton(

                                          onPressed: () async {
                                            filterSpecificNodeDataController.dateDifferenceDates(context);
                                            await filterSpecificNodeDataController.fetchFilterSpecificData(nodeName: widget.nodeName,fromDate:  filterSpecificNodeDataController.fromDateTEController.text, toDate:  filterSpecificNodeDataController.toDateTEController.text,fromButton: true);
                                            await filterSpecificNodeDataController.fetchFilterSpecificTableData(nodeName: widget.nodeName,fromDate:  filterSpecificNodeDataController.fromDateTEController.text, toDate:  filterSpecificNodeDataController.toDateTEController.text,fromButton: false);

                                          }, child: filterSpecificNodeDataController.isFilterButtonInProgress ? SmallButtonCircularProgressBarWidget(size: size) :  const TextComponent(text: "Submit",color: AppColors.whiteTextColor,));
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

