//
//
// import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
// import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
// import 'package:nz_fabrics/src/common_widgets/text_component.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_day_button_controller.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/controllers/custom_diesel_button_controller.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/controllers/daily_diesel_button_controller.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/controllers/monthly_diesel_button_controller.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/controllers/yearly_diesel_button_controller.dart';
// import 'package:nz_fabrics/src/utility/style/app_colors.dart';
// import 'package:nz_fabrics/src/utility/style/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// class DieselDateWidget extends StatefulWidget {
//   const DieselDateWidget({super.key});
//
//   @override
//   State<DieselDateWidget> createState() => _DateWidgetState();
// }
//
// class _DateWidgetState extends State<DieselDateWidget> {
//   int selectedMonth = DateTime.now().month;
//   int selectedYear = DateTime.now().year;
//   int onlySelectedYear = DateTime.now().year;
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         GetBuilder<DailyDieselButtonController>(
//             builder: (dailyDieselButtonController) {
//               return CustomContainer(
//                   height: dailyDieselButtonController.selectedButton == 1 ? size.height * 0.05  : size.height * 0.2,
//                   width: double.infinity,
//                   borderRadius:
//                   BorderRadius.circular(size.height * k16TextSize),
//                   child: Stack(
//                     children: [
//                       Container(
//                           height: size.height * 0.070,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(size.height * k16TextSize),
//                               border: const Border(
//                                 bottom: BorderSide(
//                                   color: AppColors.containerBorderColor,
//                                   width: 1.0,
//                                 ),
//                               )),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               CustomRectangularRadioButton<int>(
//                                 value: 1,
//                                 groupValue:
//                                 dailyDieselButtonController.selectedButton,
//                                 onChanged: (value) {
//                                   dailyDieselButtonController.updateSelectedButton(value: value!);
//                                 },
//                                 label: 'Daily',
//                               ),
//                               CustomRectangularRadioButton<int>(
//                                 value: 2,
//                                 groupValue:
//                                 dailyDieselButtonController.selectedButton,
//                                 onChanged: (value) {
//                                   dailyDieselButtonController.updateSelectedButton(value: value!);
//                                 },
//                                 label: 'Monthly',
//                               ),
//                               CustomRectangularRadioButton<int>(
//                                 value: 3,
//                                 groupValue:
//                                 dailyDieselButtonController.selectedButton,
//                                 onChanged: (value) {
//                                   dailyDieselButtonController.updateSelectedButton(value: value!);
//                                 },
//                                 label: 'Yearly',
//                               ),
//                               CustomRectangularRadioButton<int>(
//                                 value: 4,
//                                 groupValue:
//                                 dailyDieselButtonController.selectedButton,
//                                 onChanged: (value) {
//                                   dailyDieselButtonController.updateSelectedButton(value: value!);
//                                 },
//                                 label: 'Custom',
//                               ),
//                             ],
//                           )),
//                       Positioned(
//                         top: size.height * 0.080,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: size.height * k16TextSize),
//                           child: dailyDieselButtonController.selectedButton == 1
//                               ?Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   GetBuilder<AnalysisProDayButtonController>(
//                                       builder: (analysisProController) {
//                                         return SizedBox(
//                                           width: size.width * 0.370,
//                                           child: TextFormField(
//                                             onTap: () async {
//
//                                               analysisProController.formDatePicker(context);
//                                             },
//
//                                             style: TextStyle(fontSize: size.height * k18TextSize),
//                                             controller: analysisProController.fromDateTEController,
//                                             readOnly: true,
//                                             decoration: InputDecoration(
//                                               contentPadding: EdgeInsets.only(
//                                                   top: 0,
//                                                   bottom: 0,
//                                                   left: size.height * k16TextSize),
//                                               hintText: "From Date",
//                                               suffixIcon: Icon(
//                                                 Icons.calendar_today_outlined,
//                                                 size: size.height * k24TextSize,
//                                               ),
//                                             ),
//                                             // validator: validator,
//                                           ),
//                                         );
//                                       }),
//                                   SizedBox(
//                                     width: size.width * 0.050,
//                                   ),
//                                   GetBuilder<AnalysisProDayButtonController>(
//                                       builder: (analysisProController) {
//                                         return SizedBox(
//                                           width: size.width * 0.385,
//                                           child: TextFormField(
//                                             onTap: () {
//                                               analysisProController.toDatePicker(context);
//                                             },
//                                             style: TextStyle(fontSize: size.height * k18TextSize),
//                                             controller: analysisProController.toDateTEController,
//                                             readOnly: true,
//                                             decoration: InputDecoration(
//                                               contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: size.height * k16TextSize),
//                                               hintText: "To Date",
//                                               suffixIcon: Icon(
//                                                 Icons.calendar_today_outlined,
//                                                 size: size.height * k24TextSize,
//                                               ),
//                                             ),
//                                             // validator: validator,
//                                           ),
//                                         );
//                                       }),
//                                 ],
//                               ),
//                               SizedBox(height: size.height * k8TextSize,),
//                               SizedBox(
//                                 height:  size.width * 0.1,
//                                 width: size.width * 0.4,
//                                 child: ElevatedButton(
//
//                                     onPressed: () async {
//
//
//                                     }, child: const TextComponent(text: "Submit",color: AppColors.whiteTextColor,)),
//                               )
//                             ],
//                           )
//                               : dailyDieselButtonController.selectedButton == 2
//                               ?  Column(
//                             children: [
//                               Row( mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   GetBuilder<MonthlyDieselButtonController>(
//                                       builder: (monthlyDieselButtonController) {
//                                         return _buildMonthAndYearSelector(
//                                           context,
//                                           size: size,
//                                           'Month',
//                                           selectedMonth,
//                                               (int value) {
//                                             setState(() {
//                                               selectedMonth = value;
//                                               monthlyDieselButtonController.selectedMonthMethod(selectedMonth);
//                                             });
//                                           },
//                                         );
//                                       }
//                                   ),
//                                   SizedBox(width: size.width * k20TextSize),
//                                   GetBuilder<MonthlyDieselButtonController>(
//                                       builder: (monthlyDieselButtonController) {
//                                         return _buildMonthAndYearSelector(
//                                           context,
//                                           size: size,
//                                           'Year',
//                                           selectedYear, (int value) {
//                                           setState(() {
//                                             selectedYear = value;
//                                             monthlyDieselButtonController.selectedYearMethod(selectedYear);
//                                           });
//                                         },
//                                         );
//                                       }
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: size.height * k8TextSize,),
//                               SizedBox(
//                                 height:  size.width * 0.1,
//                                 width: size.width * 0.4,
//                                 child: GetBuilder<MonthlyDieselButtonController>(
//                                     builder: (monthlyDieselButtonController) {
//                                       return ElevatedButton(
//
//                                           onPressed: () async {
//
//
//                                             await monthlyDieselButtonController.fetchMonthlyDieselData(selectedMonth: selectedMonth.toString(), selectedYear: selectedYear.toString());
//
//
//                                           }, child: const TextComponent(text: "Submit",color: AppColors.whiteTextColor,));
//                                     }
//                                 ),
//                               )
//                             ],
//                           )
//                               :  dailyDieselButtonController.selectedButton == 3 ? Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(height: size.height * 0.1,),
//                               SizedBox(width: size.width * 0.030,),
//                               GetBuilder<YearlyDieselButtonController>(
//                                   builder: (yearlyDieselButtonController) {
//                                     return _buildMonthAndYearSelector(
//                                       context,
//                                       size: size,
//                                       'Year',
//                                       onlySelectedYear,
//                                           (int value) {
//                                         setState(() {
//                                           onlySelectedYear = value;
//                                           yearlyDieselButtonController.selectedYearMethod(onlySelectedYear);
//                                         });
//                                       },
//                                     );
//                                   }
//                               ),
//                               SizedBox(width: size.width * k30TextSize),
//                               SizedBox(
//                                 height:  size.width * 0.11,
//                                 width: size.width * 0.4,
//                                 child: GetBuilder<YearlyDieselButtonController>(
//                                     builder: (yearlyDieselButtonController) {
//                                       return ElevatedButton(
//
//                                           onPressed: () async {
//
//
//                                             await yearlyDieselButtonController.fetchYearlyDieselData(selectedYearDate: onlySelectedYear);
//
//
//                                           }, child: const TextComponent(text: "Submit",color: AppColors.whiteTextColor,));
//                                     }
//                                 ),
//                               )
//                             ],
//                           ) : Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   GetBuilder<CustomDieselButtonController>(
//                                       builder: (customDieselButtonController) {
//                                         return SizedBox(
//                                           width: size.width * 0.370,
//                                           child: TextFormField(
//                                             onTap: () async {
//
//                                               customDieselButtonController.formDatePicker(context);
//                                             },
//
//                                             style: TextStyle(fontSize: size.height * k18TextSize),
//                                             controller: customDieselButtonController.fromDateTEController,
//                                             readOnly: true,
//                                             decoration: InputDecoration(
//                                               contentPadding: EdgeInsets.only(
//                                                   top: 0,
//                                                   bottom: 0,
//                                                   left: size.height * k16TextSize),
//                                               hintText: "From Date",
//                                               suffixIcon: Icon(
//                                                 Icons.calendar_today_outlined,
//                                                 size: size.height * k24TextSize,
//                                               ),
//                                             ),
//                                             // validator: validator,
//                                           ),
//                                         );
//                                       }),
//                                   SizedBox(
//                                     width: size.width * 0.050,
//                                   ),
//                                   GetBuilder<CustomDieselButtonController>(
//                                       builder: (customDieselButtonController) {
//                                         return SizedBox(
//                                           width: size.width * 0.385,
//                                           child: TextFormField(
//                                             onTap: () {
//                                               customDieselButtonController.toDatePicker(context);
//                                             },
//                                             style: TextStyle(fontSize: size.height * k18TextSize),
//                                             controller: customDieselButtonController.toDateTEController,
//                                             readOnly: true,
//                                             decoration: InputDecoration(
//                                               contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: size.height * k16TextSize),
//                                               hintText: "To Date",
//                                               suffixIcon: Icon(
//                                                 Icons.calendar_today_outlined,
//                                                 size: size.height * k24TextSize,
//                                               ),
//                                             ),
//                                             // validator: validator,
//                                           ),
//                                         );
//                                       }),
//                                 ],
//                               ),
//                               SizedBox(height: size.height * k8TextSize,),
//                               SizedBox(
//                                 height:  size.width * 0.1,
//                                 width: size.width * 0.4,
//                                 child: GetBuilder<CustomDieselButtonController>(
//                                   builder: (customDieselButtonController) {
//                                     return ElevatedButton(
//
//                                         onPressed: () async {
//                                            await customDieselButtonController.fetchCustomDieselData(fromDate:  customDieselButtonController.fromDateTEController.text, toDate:  customDieselButtonController.toDateTEController.text);
//
//                                         }, child: const TextComponent(text: "Submit",color: AppColors.whiteTextColor,));
//                                   }
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ));
//             })
//       ],
//     );
//   }
//
//   void fetchData(DateTime fromDate, DateTime toDate) {
//     // Implement the logic to fetch data based on the selected date range.
//     // For example:
//     debugPrint('Fetching data from $fromDate to $toDate');
//   }
// }
//
// Widget _buildMonthAndYearSelector(BuildContext context, String label, int selectedValue,
//     Function(int) onValueChanged,
//     {required Size size}) {
//   return SizedBox(
//     height: size.height * 0.054,
//     width: size.width * 0.385,
//     child: OutlinedButton(
//       onPressed: () async {
//         int? pickedValue = await showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return SimpleDialog(
//               //  title: Text('Select $label'),
//               children: List.generate(
//                 label == 'Month' ? 12 : (2030 - 2022 + 1),
//                     (index) {
//                   return SimpleDialogOption(
//                     onPressed: () {
//                       Navigator.pop(context, label == 'Month' ? index + 1 : 2022 + index);
//                     },
//                     child: Text(
//                       label == 'Month'
//                           ? DateFormat('MMMM').format(DateTime(2022, index + 1))
//                           : '${2022 + index}',
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         );
//         if (pickedValue != null) {
//           onValueChanged(pickedValue);
//         }
//       },
//       style: OutlinedButton.styleFrom(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         side: const BorderSide(color: AppColors.containerBorderColor),
//       ),
//       child: Row(
//         // mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           //const SizedBox(width: 8),
//           Icon(
//             Icons.calendar_today, // Calendar icon
//             color: AppColors.secondaryTextColor,
//             size: size.height * k24TextSize,
//           ),
//           const SizedBox(width: 8),
//           Text(
//             '${label == 'Month' ? DateFormat('MMMM').format(DateTime(2022, selectedValue)) : selectedValue}',
//             style: TextStyle(
//               color: AppColors.secondaryTextColor,
//               fontSize: size.height * k18TextSize,
//               fontWeight: FontWeight.normal,
//             ),
//           ),
//           // const SizedBox(width: 8),
//
//         ],
//       ),
//     ),
//   );
// }