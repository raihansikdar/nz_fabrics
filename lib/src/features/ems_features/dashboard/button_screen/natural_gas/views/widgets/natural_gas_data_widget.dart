import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/controllers/custom_natural_gas_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/controllers/daily_natural_gas_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/controllers/monthly_natural_gas_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/controllers/yearly_natural_gas_button_controller.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class NaturalGasDateWidget extends StatefulWidget {
  const NaturalGasDateWidget({super.key});

  @override
  State<NaturalGasDateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<NaturalGasDateWidget> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  int onlySelectedYear = DateTime.now().year;




  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GetBuilder<DailyNaturalGasButtonController>(
            builder: (dailyGasButtonController) {
              return CustomContainer(
                  height: dailyGasButtonController.selectedButton == 1 ? size.height * 0.05  : size.height * 0.2,
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
                                dailyGasButtonController.selectedButton,
                                onChanged: (value) {
                                  dailyGasButtonController.updateSelectedButton(value: value!);
                                },
                                label: 'Daily',
                              ),
                              CustomRectangularRadioButton<int>(
                                value: 2,
                                groupValue:
                                dailyGasButtonController.selectedButton,
                                onChanged: (value) {
                                  dailyGasButtonController.updateSelectedButton(value: value!);
                                },
                                label: 'Monthly',
                              ),
                              CustomRectangularRadioButton<int>(
                                value: 3,
                                groupValue:
                                dailyGasButtonController.selectedButton,
                                onChanged: (value) {
                                  dailyGasButtonController.updateSelectedButton(value: value!);
                                },
                                label: 'Yearly',
                              ),
                              CustomRectangularRadioButton<int>(
                                value: 4,
                                groupValue:
                                dailyGasButtonController.selectedButton,
                                onChanged: (value) {
                                  dailyGasButtonController.updateSelectedButton(value: value!);
                                },
                                label: 'Custom',
                              ),
                            ],
                          )),
                      Positioned(
                        top: size.height * 0.080,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.height * k16TextSize),
                          child: dailyGasButtonController.selectedButton == 1
                              ? const SizedBox()
                              : dailyGasButtonController.selectedButton == 2
                              ?  Column(
                            children: [
                              Row( mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GetBuilder<MonthlyNaturalGasButtonController>(
                                      builder: (monthlyGasButtonController) {
                                        return _buildMonthAndYearSelector(
                                          context,
                                          size: size,
                                          'Month',
                                          selectedMonth,
                                              (int value) {
                                            setState(() {
                                              selectedMonth = value;
                                              monthlyGasButtonController.selectedMonthMethod(selectedMonth);
                                            });
                                          },
                                        );
                                      }
                                  ),
                                  SizedBox(width: size.width * k20TextSize),
                                  GetBuilder<MonthlyNaturalGasButtonController>(
                                      builder: (monthlyGasButtonController) {
                                        return _buildMonthAndYearSelector(
                                          context,
                                          size: size,
                                          'Year',
                                          selectedYear, (int value) {
                                          setState(() {
                                            selectedYear = value;
                                            monthlyGasButtonController.selectedYearMethod(selectedYear);
                                          });
                                        },
                                        );
                                      }
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * k8TextSize,),
                              SizedBox(
                                height:  size.width * 0.1,
                                width: size.width * 0.4,
                                child: GetBuilder<MonthlyNaturalGasButtonController>(
                                    builder: (monthlyGasButtonController) {
                                      return ElevatedButton(

                                          onPressed: () async {


                                            await monthlyGasButtonController.fetchMonthlyNaturalGasData(selectedMonth: selectedMonth.toString(), selectedYear: selectedYear.toString());


                                          }, child: const TextComponent(text: "Submit",color: AppColors.whiteTextColor,));
                                    }
                                ),
                              )
                            ],
                          )
                              :  dailyGasButtonController.selectedButton == 3 ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: size.height * 0.1,),
                              SizedBox(width: size.width * 0.030,),
                              GetBuilder<YearlyNaturalGasButtonController>(
                                  builder: (yearlyGasButtonController) {
                                    return _buildMonthAndYearSelector(
                                      context,
                                      size: size,
                                      'Year',
                                      onlySelectedYear,
                                          (int value) {
                                        setState(() {
                                          onlySelectedYear = value;
                                          yearlyGasButtonController.selectedYearMethod(onlySelectedYear);
                                        });
                                      },
                                    );
                                  }
                              ),
                              SizedBox(width: size.width * k30TextSize),
                              SizedBox(
                                height:  size.width * 0.11,
                                width: size.width * 0.4,
                                child: GetBuilder<YearlyNaturalGasButtonController>(
                                    builder: (yearlyGasButtonController) {
                                      return ElevatedButton(

                                          onPressed: () async {


                                            await yearlyGasButtonController.fetchYearlyNaturalGasData(selectedYearDate: onlySelectedYear);


                                          }, child: const TextComponent(text: "Submit",color: AppColors.whiteTextColor,));
                                    }
                                ),
                              )
                            ],
                          ) : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  GetBuilder<CustomNaturalGasButtonController>(
                                      builder: (customGasButtonController) {
                                        return SizedBox(
                                          width: size.width * 0.370,
                                          child: TextFormField(
                                            onTap: () async {

                                              customGasButtonController.formDatePicker(context);
                                            },

                                            style: TextStyle(fontSize: size.height * k18TextSize),
                                            controller: customGasButtonController.fromDateTEController,
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
                                  GetBuilder<CustomNaturalGasButtonController>(
                                      builder: (customDieselButtonController) {
                                        return SizedBox(
                                          width: size.width * 0.385,
                                          child: TextFormField(
                                            onTap: () {
                                              customDieselButtonController.toDatePicker(context);
                                            },
                                            style: TextStyle(fontSize: size.height * k18TextSize),
                                            controller: customDieselButtonController.toDateTEController,
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
                              SizedBox(height: size.height * k8TextSize,),
                              SizedBox(
                                height:  size.width * 0.1,
                                width: size.width * 0.4,
                                child: GetBuilder<CustomNaturalGasButtonController>(
                                    builder: (customGasButtonController) {
                                      return ElevatedButton(

                                          onPressed: () async {
                                            await customGasButtonController.fetchCustomNaturalGasData(fromDate:  customGasButtonController.fromDateTEController.text, toDate:  customGasButtonController.toDateTEController.text);

                                          }, child: const TextComponent(text: "Submit",color: AppColors.whiteTextColor,));
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