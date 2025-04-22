import 'dart:developer';

import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:nz_fabrics/src/common_widgets/small_button_circular_progress_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_day_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_month_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_year_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatefulWidget {
  const DateWidget({super.key});

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  int onlySelectedYear = DateTime.now().year;



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GetBuilder<ElectricityDayAnalysisProController>(
            builder: (electricityDayAnalysisProController) {
              return CustomContainer(
                  height: size.height * 0.2,
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
                                electricityDayAnalysisProController.selectedButton,
                                onChanged: (value) {
                                  electricityDayAnalysisProController.updateSelectedButton(value: value!);
                                },
                                label: 'Date',
                              ),
                              CustomRectangularRadioButton<int>(
                                value: 2,
                                groupValue:
                                electricityDayAnalysisProController.selectedButton,
                                onChanged: (value) {
                                  electricityDayAnalysisProController.updateSelectedButton(value: value!);
                                },
                                label: 'Monthly',
                              ),
                              CustomRectangularRadioButton<int>(
                                value: 3,
                                groupValue:
                                electricityDayAnalysisProController.selectedButton,
                                onChanged: (value) {
                                  electricityDayAnalysisProController.updateSelectedButton(value: value!);
                                },
                                label: 'Yearly',
                              ),
                            ],
                          )),
                      Positioned(
                        top: size.height * 0.080,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * k16TextSize),
                          child: electricityDayAnalysisProController.selectedButton == 1
                              ? Column(
                                children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GetBuilder<ElectricityDayAnalysisProController>(
                                        builder: (electricityDayAnalysisProController) {
                                      return SizedBox(
                                        width: size.width * 0.370,
                                        child: TextFormField(
                                          onTap: () async {

                                            electricityDayAnalysisProController.formDatePicker(context);
                                          },

                                          style: TextStyle(fontSize: size.height * k18TextSize),
                                          controller: electricityDayAnalysisProController.fromDateTEController,
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
                                          // validator: validator,
                                        ),
                                      );
                                    }),
                                    SizedBox(
                                      width: size.width * 0.050,
                                    ),
                                    GetBuilder<ElectricityDayAnalysisProController>(
                                        builder: (electricityDayAnalysisProController) {
                                      return SizedBox(
                                        width: size.width * 0.385,
                                        child: TextFormField(
                                          onTap: () {
                                            electricityDayAnalysisProController.toDatePicker(context);
                                          },
                                          style: TextStyle(fontSize: size.height * k18TextSize),
                                          controller: electricityDayAnalysisProController.toDateTEController,
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
                                  size.width > 600 ? SizedBox(height: size.height * k25TextSize,)  : SizedBox(height: size.height * k8TextSize,),
                                SizedBox(
                                    height:  size.width > 600 ? size.width * 0.06 : size.width * 0.1,
                                    width: size.width * 0.4,
                                    child: ElevatedButton(

                                        onPressed: () async {
                                          //electricityDayAnalysisProController.selectedGridItemsMapString.clear();
                                          electricityDayAnalysisProController.dateDifferenceDates(context);
                                         await electricityDayAnalysisProController.fetchSelectedNodeData(
                                             fromDate:  electricityDayAnalysisProController.fromDateTEController.text,
                                             toDate:  electricityDayAnalysisProController.toDateTEController.text,
                                           nodes: electricityDayAnalysisProController.itemsList.toList(),fromButton: true,
                                         );


                                    }, child:electricityDayAnalysisProController.isSelectedDataInProgress ?  SmallButtonCircularProgressBarWidget(size: size) : const TextComponent(text: "Submit",color: AppColors.whiteTextColor,)),
                                  )
                                ],
                              )
                              : electricityDayAnalysisProController.selectedButton == 2
                              ? Column(
                                children: [
                                  Row( mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                  GetBuilder<ElectricityMonthAnalysisProController>(
                                    builder: (electricityMonthAnalysisProController) {
                                      return _buildMonthAndYearSelector(
                                        context,
                                        size: size,
                                        'Month',
                                        selectedMonth,
                                            (int value) {
                                          setState(() {
                                            selectedMonth = value;
                                            electricityMonthAnalysisProController.selectedMonthMethod(selectedMonth);
                                          });
                                        },
                                      );
                                    }
                                  ),
                                  SizedBox(width: size.width * k20TextSize),
                              GetBuilder<ElectricityMonthAnalysisProController>(
                                    builder: (electricityMonthAnalysisProController) {
                                      return _buildMonthAndYearSelector(
                                        context,
                                        size: size,
                                        'Year',
                                        selectedYear, (int value) {
                                          setState(() {
                                            selectedYear = value;
                                            electricityMonthAnalysisProController.selectedYearMethod(selectedYear);
                                          });
                                        },
                                      );
                                    }
                                  ),
                               ],
                              ),
                                  size.width > 600 ? SizedBox(height: size.height * k16TextSize,)  : SizedBox(height: size.height * k8TextSize,),
                                  SizedBox(
                                    height:  size.width > 600 ? size.width * 0.06 : size.width * 0.1,
                                    width: size.width * 0.4,
                                    child: GetBuilder<ElectricityMonthAnalysisProController>(
                                      builder: (electricityMonthAnalysisProController) {
                                        return ElevatedButton(

                                            onPressed: () async {

                                              await electricityMonthAnalysisProController.fetchSelectedMonthDGRData(
                                                selectedMonth: selectedMonth.toString(),
                                                selectedYear: selectedYear.toString(),
                                                nodes: electricityMonthAnalysisProController.itemsList.toList(),
                                                fromButton: true,
                                              );


                                            }, child: electricityMonthAnalysisProController.isSelectedMonthInProgress ? SmallButtonCircularProgressBarWidget(size: size) : const TextComponent(text: "Submit",color: AppColors.whiteTextColor,));
                                      }
                                    ),
                                  )
                                ],
                              )
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: size.height * 0.1,),
                              SizedBox(width: size.width * 0.030,),
                              GetBuilder<ElectricityYearAnalysisProController>(
                                builder: (electricityYearAnalysisProController) {
                                  return _buildMonthAndYearSelector(
                                    context,
                                    size: size,
                                    'Year',
                                    onlySelectedYear,
                                        (int value) {
                                      setState(() {
                                        onlySelectedYear = value;
                                        electricityYearAnalysisProController.selectedYearMethod(onlySelectedYear);
                                        log(electricityYearAnalysisProController.selectedYear.toString());
                                      });
                                    },
                                  );
                                }
                              ),
                              SizedBox(width: size.width * k30TextSize),
                              SizedBox(
                                height: size.width > 600 ? size.width * 0.08 : size.width * 0.11,
                                width: size.width * 0.4,
                                child: GetBuilder<ElectricityYearAnalysisProController>(
                                    builder: (electricityYearAnalysisProController) {
                                      return ElevatedButton(

                                          onPressed: () async {
                                          //  log(analysisProYearlyButtonController.selectedYear.toString());
                                            electricityYearAnalysisProController.selectedGridItemsMapString.clear();

                                            await electricityYearAnalysisProController.fetchSelectedYearDGRData(
                                                selectedYear: onlySelectedYear.toString(),
                                              nodes: electricityYearAnalysisProController.itemsList.toList(),
                                              fromButton: true
                                            );

                                          }, child: electricityYearAnalysisProController.isSelectedYearInProgress ? SmallButtonCircularProgressBarWidget(size: size) : const TextComponent(text: "Submit",color: AppColors.whiteTextColor,));
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

Widget _buildMonthAndYearSelector(BuildContext context, String label, int selectedValue,
    Function(int) onValueChanged,
    {required Size size}) {
  return SizedBox(
    height: size.height * 0.054,
    width: size.width * 0.385,
    child: OutlinedButton(
      onPressed: () async {
        int? pickedValue = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              //  title: Text('Select $label'),
              children: List.generate(
                label == 'Month' ? 12 : (2030 - 2022 + 1),
                    (index) {
                  return SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, label == 'Month' ? index + 1 : 2022 + index);
                    },
                    child: Text(
                      label == 'Month'
                          ? DateFormat('MMMM').format(DateTime(2022, index + 1))
                          : '${2022 + index}',
                    ),
                  );
                },
              ),
            );
          },
        );
        if (pickedValue != null) {
          onValueChanged(pickedValue);
        }
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: const BorderSide(color: AppColors.containerBorderColor),
      ),
      child: Row(
       // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //const SizedBox(width: 8),
          Icon(
            Icons.calendar_today, // Calendar icon
            color: AppColors.secondaryTextColor,
            size: size.height * k24TextSize,
          ),
          const SizedBox(width: 8),
          Text(
            '${label == 'Month' ? DateFormat('MMMM').format(DateTime(2022, selectedValue)) : selectedValue}',
            style: TextStyle(
              color: AppColors.secondaryTextColor,
              fontSize: size.height * k18TextSize,
              fontWeight: FontWeight.normal,
            ),
          ),
          // const SizedBox(width: 8),

        ],
      ),
    ),
  );
}



