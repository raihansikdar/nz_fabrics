// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/active_power_controller/controller/plant_today_data_controller.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/active_power_controller/views/widgets/ac_power_controller_table.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/active_power_controller/views/widgets/power_control_line_chart_widget.dart';
// import 'package:nz_ums/src/utility/style/app_colors.dart';
// import 'package:nz_ums/src/utility/style/constant.dart';
//
// class ActivePowerControllerScreen extends StatefulWidget {
//   const ActivePowerControllerScreen({super.key});
//
//   @override
//   State<ActivePowerControllerScreen> createState() => _ActivePowerControllerScreenState();
// }
//
// class _ActivePowerControllerScreenState extends State<ActivePowerControllerScreen> {
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Get.find<PlantTodayDataController>().fetchPlantTodayData();
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
//           child: Column(
//             children: [
//               SizedBox(height: size.height * k16TextSize,),
//               SizedBox(
//                   height: size.height * 0.56,
//                   child: const PowerControlLineChartWidget()),
//             //  SizedBox(height: size.height * k20TextSize,),
//               SizedBox(
//                   height: size.height * 0.8,
//                   child: const ACPowerControlTable()),
//             ],
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
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/active_power_controller/controller/plant_today_data_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/active_power_controller/views/widgets/ac_power_controller_table.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/active_power_controller/views/widgets/power_control_line_chart_widget.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Border, Row, Column;
import 'package:flutter_svg/flutter_svg.dart';

class ActivePowerControllerScreen extends StatefulWidget {
  const ActivePowerControllerScreen({super.key});

  @override
  State<ActivePowerControllerScreen> createState() => _ActivePowerControllerScreenState();
}

class _ActivePowerControllerScreenState extends State<ActivePowerControllerScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<PlantTodayDataController>().fetchPlantTodayData();
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
    final controller = Get.find<PlantTodayDataController>();
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'Active Power Control Report';
        sheet.getRangeByIndex(1, 1).columnWidth = 20;
        sheet.getRangeByIndex(1, 2).columnWidth = 30;
        sheet.getRangeByIndex(1, 3).columnWidth = 30;
        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';
        final List<String> headers = [
          'Date',
          'Active Power Control 1 (kW)',
          'Active Power Control 2 (kW)',
        ];
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
          sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
        }

        // Sort and populate data
        final dataList = List.from(controller.plantTodayDataList)
          ..sort((a, b) => b.timedate!.compareTo(a.timedate!));
        for (int i = 0; i < dataList.length; i++) {
          final rowIndex = i + 2;
          final data = dataList[i];
          sheet.getRangeByIndex(rowIndex, 1).setText(data.timedate != null
              ? DateFormat('dd-MMM-yyyy HH:mm').format(data.timedate!)
              : 'N/A');
          sheet.getRangeByIndex(rowIndex, 2).setNumber(data.activePowerControl1 ?? 0);
          sheet.getRangeByIndex(rowIndex, 3).setNumber(data.activePowerControl2 ?? 0);
        }

        sheet.autoFitRow(1);

        // Determine file path
        String? filePath;
        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (directory.existsSync()) {
            String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
            filePath = "${directory.path}/Active_Power_Control_Report_$formattedDate $formattedTime.xlsx";
          }
        } else if (Platform.isIOS) {
          final directory = await getApplicationDocumentsDirectory();
          String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
          String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
          filePath = "${directory.path}/Active_Power_Control_Report_$formattedDate $formattedTime.xlsx";
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
          child: Column(
            children: [
              SizedBox(height: size.height * k16TextSize),
              SizedBox(
                height: size.height * 0.53,
                child: const PowerControlLineChartWidget(),
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

              const SizedBox(height: 20,),

              SizedBox(
                height: size.height * 0.8,
                child: const ACPowerControlTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}