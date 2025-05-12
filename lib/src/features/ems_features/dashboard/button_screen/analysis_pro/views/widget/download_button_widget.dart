// import 'dart:developer';
//
// import 'package:get/get.dart';
// import 'package:nz_fabrics/src/common_widgets/text_component.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_day_button_controller.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_monthly_button_controller.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_yearly_button_controller.dart';
// import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
// import 'package:nz_fabrics/src/utility/style/app_colors.dart';
// import 'package:nz_fabrics/src/utility/style/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class DownloadButtonWidget extends StatelessWidget {
//   const DownloadButtonWidget({
//     super.key,
//     required this.size,
//   });
//
//   final Size size;
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AnalysisProDayButtonController>(
//       builder: (controller) {
//         return GestureDetector(
//           onTap: (){
//             log("-------------press---------------");
//             controller.selectedButton == 1 ?  Get.find<AnalysisProDayButtonController>().downloadDataSheet()
//             : controller.selectedButton == 2 ? Get.find<AnalysisProMonthlyButtonController>().downloadDataSheet()
//             : Get.find<AnalysisProYearlyButtonController>().downloadDataSheet();
//           },
//           child: Container(
//             transform: Matrix4.translationValues(size.height * 0.120, size.height * 0.022, 0),
//             height: size.height * .050,
//             width: size.width * 0.350,
//             decoration: BoxDecoration(
//                 color: AppColors.whiteTextColor,
//                 borderRadius: BorderRadius.circular(size.height * k8TextSize),
//                 border: Border.all(color: AppColors.secondaryTextColor, width: 2.0)
//             ),
//             child: Center(child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextComponent(text: "Download",color: AppColors.secondaryTextColor,fontSize: size.height * k18TextSize ,fontFamily: boldFontFamily,),
//                 SizedBox(width: size.width * k16TextSize,),
//                 SvgPicture.asset(AssetsPath.downloadIconSVG,height: size.height * k25TextSize,),
//               ],
//             ),
//             ),
//           ),
//         );
//       }
//     );
//   }
// }