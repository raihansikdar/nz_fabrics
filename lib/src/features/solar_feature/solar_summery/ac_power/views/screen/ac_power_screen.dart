// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:nz_ums/src/common_widgets/text_component.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/ac_power/controller/ac_power_today_data_controller.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/ac_power/views/widget/ac_power_line_cart_widget.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/ac_power/views/widget/ac_power_table.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/assorted_data/controllers/assorted_data_controller.dart';
// import 'package:nz_ums/src/utility/assets_path/assets_path.dart';
// import 'package:nz_ums/src/utility/style/app_colors.dart';
// import 'package:nz_ums/src/utility/style/constant.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
//
// class AcPowerScreen extends StatefulWidget {
//   const AcPowerScreen({super.key});
//
//   @override
//   State<AcPowerScreen> createState() => _AcPowerScreenState();
// }
//
// class _AcPowerScreenState extends State<AcPowerScreen> {
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Get.find<AcPowerTodayDataController>().fetchPlantTodayData();
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: size.height * k10TextSize),
//           child: GetBuilder<AcPowerTodayDataController>(
//             builder: (acPowerTodayDataController) {
//              if( acPowerTodayDataController.isAcPowerDataInProgress){
//
//                  return Center(child: Padding(
//                    padding: EdgeInsets.only(top: size.height * 0.3),
//                    child: Lottie.asset(AssetsPath.loadingJson, height: size.height * 0.12),
//                  ));
//
//              }
//               return Column(
//                 children: [
//                   SizedBox(height: size.height * k16TextSize,),
//                   Container(
//                     height: size.height * 0.3,
//                     decoration: BoxDecoration(
//                       color: AppColors.whiteTextColor,
//                         borderRadius:  BorderRadius.circular(size.height * k12TextSize),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             spreadRadius: 1,
//                             blurRadius: 3,
//                             offset: const Offset(0, 2),
//                           ),
//                         ]
//                     ),
//
//                     child: GetBuilder<AssortedDataController>(
//                         builder: (assortedDataController) {
//                           return Column(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(left: size.height * k16TextSize,right: size.height * k16TextSize,top: size.height * k8TextSize ),
//                                 child: const Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     TextComponent(text: "Solar Live AC Power",color: AppColors.secondaryTextColor,),
//                                   ],
//                                 ),
//                               ),
//                               Divider(color: Colors.grey.shade300,),
//                               SizedBox(
//                                   height: size.height * 0.180,
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(top: 40.0),
//                                     child: SfRadialGauge(
//                                       axes: <RadialAxis>[RadialAxis(
//                                           radiusFactor: 1.5,
//                                           startAngle: 180,
//                                           endAngle: 0,
//                                           minimum: 0,
//                                           maximum: 2300,
//                                           interval: 600,
//                                           pointers:  <GaugePointer>[
//                                             RangePointer(value: assortedDataController.plantLiveDataModel.totalAcPower ?? 0.0, width: 0.109,
//                                                 color: AppColors.primaryColor, sizeUnit: GaugeSizeUnit.factor,enableAnimation: true,
//                                             ),
//                                             NeedlePointer(value: assortedDataController.plantLiveDataModel.totalAcPower ?? 0.0,
//                                                 needleColor: AppColors.primaryColor,
//                                                 needleStartWidth: 0.6, needleEndWidth: 5,enableAnimation: true,
//                                                 knobStyle: const KnobStyle(knobRadius: 0.05, borderColor: AppColors.primaryColor,
//                                                     borderWidth: 0.02,
//                                                     color: AppColors.whiteTextColor
//                                                 )
//                                             )]
//                                       )],
//                                     ),
//                                   )
//                               ),
//
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: size.height * 0.2,),
//                                 child: const Divider(),
//                               ),
//
//                              Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: [
//                                  const TextComponent(text: "AC Power : ",color: AppColors.secondaryTextColor,),
//                                  TextComponent(text: "${assortedDataController.plantLiveDataModel.totalAcPower?.toStringAsFixed(2)} kW",fontSize: size.height * k20TextSize,),
//                                ],
//                              )
//                             ],
//                           );
//                         }
//                     ),
//                   ),
//                   SizedBox(height: size.height * 0.02,),
//                   SizedBox(
//                       height: size.height * 0.5,
//                       width: double.infinity,
//                       child: const AcPowerLineChartWidget()),
//
//                 //  SizedBox(height: size.height * k20TextSize,),
//                   SizedBox(
//                       height: size.height * 0.9,
//                       width: double.infinity,
//                       child: const AcPowerTableWidget()),
//                 ],
//               );
//             }
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/ac_power/controller/ac_power_today_data_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/ac_power/views/widget/ac_power_line_cart_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/ac_power/views/widget/ac_power_table.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/controllers/assorted_data_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Border, Row, Column;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AcPowerScreen extends StatefulWidget {
  const AcPowerScreen({super.key});

  @override
  State<AcPowerScreen> createState() => _AcPowerScreenState();
}

class _AcPowerScreenState extends State<AcPowerScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AcPowerTodayDataController>().fetchPlantTodayData();
    });
    super.initState();
  }
  Future<PermissionStatus> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;

      if (android.version.sdkInt < 33) {
        return await Permission.storage.request();
      } else {
        // For Android 13 and above, we don't need storage permission for downloads
        return PermissionStatus.granted;
      }
    } else if (Platform.isIOS) {
      // For iOS, we don't need explicit storage permission as we'll save to app directory
      return PermissionStatus.granted;
    }
    return PermissionStatus.denied;
  }
  Future<void> downloadDataSheet(BuildContext context) async {
    final controller = Get.find<AcPowerTodayDataController>();
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'AC Power Report';

        // Set column widths
        sheet.getRangeByIndex(1, 1, 1, 1).columnWidth = 15; // Date
        sheet.getRangeByIndex(1, 2, 1, 2).columnWidth = 15; // AC Power

        // Define header style
        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        // Define headers
        final List<String> headers = [
          'Date',
          'AC Power (kW)',
        ];
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
          sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
        }

        // Populate data from plantTodayDataList in descending order
        final dataList = controller.plantTodayDataList.reversed.toList();
        for (int i = 0; i < dataList.length; i++) {
          final rowIndex = i + 2;
          final data = dataList[i];
          sheet.getRangeByIndex(rowIndex, 1).setText(data.timedate != null
              ? DateFormat('dd-MMM-yyyy').format(data.timedate!)
              : 'N/A');
          sheet.getRangeByIndex(rowIndex, 2).setNumber(data.totalAcPower ?? 0);
        }

        sheet.autoFitRow(1);

        // Determine file path based on platform
        String? filePath;
        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (directory.existsSync()) {
            String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
            filePath = "${directory.path}/AC_Power_Report_$formattedDate $formattedTime.xlsx";
          } else {
            final fallbackDir = await getApplicationDocumentsDirectory();
            String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
            filePath = "${fallbackDir.path}/AC_Power_Report_$formattedDate $formattedTime.xlsx";
          }
        } else if (Platform.isIOS) {
          final directory = await getApplicationDocumentsDirectory();
          String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
          String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
          filePath = "${directory.path}/AC_Power_Report_$formattedDate $formattedTime.xlsx";
        }

        if (filePath != null) {
          final List<int> bytes = workbook.saveAsStream();
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(bytes);

          Get.snackbar(
              "Success",
              "File downloaded successfully",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.greenColor,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16)
          );

          FlutterSmartDownloadDialog.show(
            context: context,
            filePath: filePath,
            dialogType: DialogType.popup,
          );
          log("File saved at ==> $filePath");
        } else {
          throw Exception("Unable to determine a valid file path for saving.");
        }
      } catch (e, stackTrace) {
        log("Error saving Excel file: $e");
        log("Stack trace: $stackTrace");
        Get.snackbar(
          "Error",
          "Could not save file: $e",
          duration: const Duration(seconds: 7),
          backgroundColor: AppColors.redColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else if (storageStatus == PermissionStatus.denied) {
      log("======> Permission denied");
      Get.snackbar(
        "Permission Denied",
        "Storage permission is required to save the file.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else if (storageStatus == PermissionStatus.permanentlyDenied) {
      Get.snackbar(
        "Permission Denied",
        "Please enable storage permission in app settings",
        snackPosition: SnackPosition.BOTTOM,
        mainButton: const TextButton(
          onPressed: openAppSettings,
          child: Text('Settings'),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.height * k10TextSize),
              child: GetBuilder<AcPowerTodayDataController>(
                builder: (acPowerTodayDataController) {
                  if (acPowerTodayDataController.isAcPowerDataInProgress) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: size.height * 0.3),
                        child: Lottie.asset(AssetsPath.loadingJson, height: size.height * 0.12),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      SizedBox(height: size.height * k16TextSize),
                      Container(
                        height: size.height * 0.3,
                        decoration: BoxDecoration(
                          color: AppColors.whiteTextColor,
                          borderRadius: BorderRadius.circular(size.height * k12TextSize),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: GetBuilder<AssortedDataController>(
                          builder: (assortedDataController) {
                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: size.height * k16TextSize,
                                    right: size.height * k16TextSize,
                                    top: size.height * k8TextSize,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextComponent(
                                        text: "Solar Live AC Power",
                                        color: AppColors.secondaryTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(color: Colors.grey.shade300),
                                SizedBox(
                                  height: size.height * 0.180,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 40.0),
                                    child: SfRadialGauge(
                                      axes: <RadialAxis>[
                                        RadialAxis(
                                          radiusFactor: 1.5,
                                          startAngle: 180,
                                          endAngle: 0,
                                          minimum: 0,
                                          maximum: 3500,
                                          interval: 800,
                                          pointers: <GaugePointer>[
                                            RangePointer(
                                              value: assortedDataController.plantLiveDataModel.totalAcPower ?? 0.0,
                                              width: 0.109,
                                              color: AppColors.primaryColor,
                                              sizeUnit: GaugeSizeUnit.factor,
                                              enableAnimation: true,
                                            ),
                                            NeedlePointer(
                                              value: assortedDataController.plantLiveDataModel.totalAcPower ?? 0.0,
                                              needleColor: AppColors.primaryColor,
                                              needleStartWidth: 0.6,
                                              needleEndWidth: 5,
                                              enableAnimation: true,
                                              knobStyle: const KnobStyle(
                                                knobRadius: 0.05,
                                                borderColor: AppColors.primaryColor,
                                                borderWidth: 0.02,
                                                color: AppColors.whiteTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: size.height * 0.2),
                                  child: const Divider(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const TextComponent(
                                      text: "AC Power : ",
                                      color: AppColors.secondaryTextColor,
                                    ),
                                    TextComponent(
                                      text: "${assortedDataController.plantLiveDataModel.totalAcPower?.toStringAsFixed(2)} kW",
                                      fontSize: size.height * k20TextSize,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      SizedBox(
                        height: size.height * 0.48,
                        width: double.infinity,
                        child: const AcPowerLineChartWidget(),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            downloadDataSheet(context);
                          },
                          child: CustomContainer(
                            height: size.height * 0.05,
                            width: size.width * 0.4,
                            borderRadius: BorderRadius.circular(size.height * k12TextSize),
                            child: Padding(
                              padding: EdgeInsets.all(size.height * k8TextSize),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextComponent(
                                      text: "Download",
                                      color: AppColors.secondaryTextColor,
                                      fontSize: size.height * k18TextSize,
                                    ),
                                    SvgPicture.asset(
                                      AssetsPath.downloadIconSVG,
                                      height: size.height * k20TextSize,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * k20TextSize),
                      SizedBox(
                        height: size.height * 0.9,
                        width: double.infinity,
                        child: const AcPowerTableWidget(),
                      ),
                    ],
                  );
                },
              ),
            ),
            ),
       );
    }
}