// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/model/dgr_line_chart_model.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/model/dgr_monthly_chart_model.dart';
// import 'package:nz_ums/src/features/solar_feature/solar_summery/dgr/model/dgr_yearly_bar_chart_model.dart';
// import 'package:nz_ums/src/services/internet_connectivity_check_mixin.dart';
// import 'package:nz_ums/src/services/network_caller.dart';
// import 'package:nz_ums/src/services/network_response.dart';
// import 'package:nz_ums/src/utility/app_toast/app_toast.dart';
// import 'package:nz_ums/src/utility/app_urls/app_urls.dart';
// import 'package:nz_ums/src/utility/exception/app_exception.dart';
//
// class DgrController extends GetxController with InternetConnectivityCheckMixin{
//
//
//   bool _isConnected = true;
//   bool _isDgrPantProgress = false;
//   bool _isDgrPantButtonProgress = false;
//   String _errorMessage = '';
//   DGRLineChartModel _lineChartModel = DGRLineChartModel();
//   DGRMonthlyChartModel _monthlyBarchartModel = DGRMonthlyChartModel();
//   DGRYearlyBarChartModel _yearlyBarChartModel = DGRYearlyBarChartModel();
//
//   bool firstTimeLoader = true;
//
//   bool get isConnected => _isConnected;
//   bool get isDgrPantProgress => _isDgrPantProgress;
//   bool get isDgrPantButtonProgress => _isDgrPantButtonProgress;
//   String get errorMessage => _errorMessage;
//
//   DGRLineChartModel get  lineChartModel => _lineChartModel;
//   DGRMonthlyChartModel get  monthlyBarchartModel => _monthlyBarchartModel;
//   DGRYearlyBarChartModel get  yearlyBarChartModel => _yearlyBarChartModel;
//
//
//   int _dateDifference = 0;
//   int get dateDifference => _dateDifference;
//
//   String _graphType = '';
//   String get graphType => _graphType;
//
//   String formattedFromDate = '';
//   String formattedToDate = '';
//
//
//   @override
//   void onInit() {
//     super.onInit();
//     String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
//     _fromDateTEController.text = todayDate;
//     _toDateTEController.text = todayDate;
//   }
//
//   Future<bool> fetchDgrData({required String fromDate, required String toDate, bool fromButton = false,}) async {
//
//     if(firstTimeLoader){
//       _isDgrPantProgress = true;
//       update();
//     }
//
//     _isDgrPantButtonProgress = fromButton;
//     update();
//
//
//     // final formattedFromDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(
//     //   DateFormat("dd-MM-yyyy").parse(fromDate).toUtc(),
//     // );
//
//     formattedFromDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(
//       DateFormat("dd-MM-yyyy").parse(fromDate).toLocal(),
//     );
//
//     final parsedToDate = DateFormat("dd-MM-yyyy").parse(toDate);
//     final adjustedToDate = parsedToDate.add(const Duration(hours: 23, minutes: 59, seconds: 59));
//     formattedToDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(adjustedToDate.toUtc());
//     update();
//
//     Map<String, String> requestBody = {
//       "start": formattedFromDate,
//       "end": formattedToDate,
//     };
//
//     //  log("Request Custom Body Date: $requestBody");
//     //  log("formattedFromDate: $formattedFromDate");
//     // log("formattedToDate: $formattedToDate");
//
//     try {
//       await internetConnectivityCheck();
//
//       NetworkResponse response = await NetworkCaller.postRequest(
//         url: Urls.postDgrFilterPlantDataUrl,
//         body: requestBody,
//       );
//
//       log("postDgrFilterPlantDataUrl statusCode ==> ${Urls.postDgrFilterPlantDataUrl}");
//
//        log("postDgrFilterPlantDataUrl statusCode ==> ${response.statusCode}");
//       // log("postDgrFilterPlantDataUrl body ==> ${response.body}");
//
//       _isDgrPantProgress = false;
//       _isDgrPantButtonProgress = false;
//       update();
//
//       if (response.isSuccess) {
//         _graphType = response.body['graph-type'];
//
//         if(_graphType == "Line-Chart"){
//
//           _lineChartModel = DGRLineChartModel.fromJson(response.body);
//
//         }  else if (_graphType == "Monthly-Bar-Chart"){
//           _monthlyBarchartModel = DGRMonthlyChartModel.fromJson(response.body);
//         }else{
//           _yearlyBarChartModel = DGRYearlyBarChartModel.fromJson(response.body);
//         }
//
//
//         log(_graphType);
//         update();
//         return true;
//
//       } else {
//         _errorMessage = " Failed to fetch filter data";
//         update();
//         return false;
//       }
//     } catch (e) {
//       _isDgrPantProgress = false;
//       _isDgrPantButtonProgress = false;
//       _errorMessage = e.toString();
//       if (e is AppException) {
//         _errorMessage = e.error.toString();
//         _isConnected = false;
//       }
//       log('Error in fetching filter data: $_errorMessage');
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         update();
//       });
//       return false;
//     }
//     finally{
//       firstTimeLoader = false;
//       update();
//     }
//   }
//
//
//
//   final TextEditingController _fromDateTEController = TextEditingController();
//   final TextEditingController _toDateTEController = TextEditingController();
//   final RxBool _clearDate = false.obs;
//
//   RxBool get clearDate => _clearDate;
//   TextEditingController get fromDateTEController => _fromDateTEController;
//   TextEditingController get toDateTEController => _toDateTEController;
//
//   void formDatePicker(BuildContext context) async {
//     DateTime? picker = await showDatePicker(
//       context: context,
//       initialDate:_fromDateTEController.text.isNotEmpty
//           ? DateFormat("dd-MM-yyyy").parse(_fromDateTEController.text)
//           : DateTime.now(),
//
//       firstDate: DateTime(2024),
//       lastDate: DateTime(2130),
//     );
//
//     if (picker != null) {
//       String formattedDate = DateFormat("dd-MM-yyyy").format(picker);
//       _fromDateTEController.text = formattedDate;
//       _clearDate.value = true;
//
//       fetchDgrData(fromDate: _fromDateTEController.text, toDate: _toDateTEController.text);
//       update();
//
//
//       validateDates(context);
//     }
//   }
//
//   void toDatePicker(BuildContext context) async {
//     DateTime? picker = await showDatePicker(
//       context: context,
//       initialDate: _toDateTEController.text.isNotEmpty
//           ? DateFormat("dd-MM-yyyy").parse(_toDateTEController.text)
//           : DateTime.now(),
//
//       firstDate: DateTime(2024),
//       lastDate: DateTime(2130),
//     );
//
//     if (picker != null) {
//       String formattedDate = DateFormat("dd-MM-yyyy").format(picker);
//       _toDateTEController.text = formattedDate;
//       _clearDate.value = true;
//       fetchDgrData(fromDate: _fromDateTEController.text, toDate: _toDateTEController.text);
//       update();
//       validateDates(context);
//     }
//   }
//
//   void validateDates(BuildContext context) {
//     final fromDate = DateFormat("dd-MM-yyyy").parse(_fromDateTEController.text);
//     final toDate = DateFormat("dd-MM-yyyy").parse(_toDateTEController.text);
//
//     if (fromDate.isAfter(toDate)) {
//       AppToast.showWrongToast("Invalid Date Range");
//     }
//   }
//
//
//   void dateDifferenceDates(BuildContext context) {
//     final fromDate = DateFormat("dd-MM-yyyy").parse(_fromDateTEController.text);
//     final toDate = DateFormat("dd-MM-yyyy").parse(_toDateTEController.text);
//
//
//
//     _dateDifference = toDate.difference(fromDate).inDays;
//      update();
//
//   }
//
//
//
//   int selectButtonValue = 1;
//
//   void updateSelectedValue(int value){
//     selectButtonValue = value;
//     update();
//   }
//
//
//
//
//   void clearFilterIngDate(){
//     String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
//     _fromDateTEController.text = todayDate;
//     _toDateTEController.text = todayDate;
//     _dateDifference = 0;
//     update();
//   }
// }

import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/model/dgr_line_chart_model.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/model/dgr_monthly_chart_model.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/model/dgr_yearly_bar_chart_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class DgrController extends GetxController with InternetConnectivityCheckMixin {
  bool _isConnected = true;
  bool _isDgrPantProgress = false;
  bool _isDgrPantButtonProgress = false;
  String _errorMessage = '';
  DGRLineChartModel _lineChartModel = DGRLineChartModel();
  DGRMonthlyChartModel _monthlyBarchartModel = DGRMonthlyChartModel();
  DGRYearlyBarChartModel _yearlyBarChartModel = DGRYearlyBarChartModel();

  bool firstTimeLoader = true;

  bool get isConnected => _isConnected;
  bool get isDgrPantProgress => _isDgrPantProgress;
  bool get isDgrPantButtonProgress => _isDgrPantButtonProgress;
  String get errorMessage => _errorMessage;

  DGRLineChartModel get lineChartModel => _lineChartModel;
  DGRMonthlyChartModel get monthlyBarchartModel => _monthlyBarchartModel;
  DGRYearlyBarChartModel get yearlyBarChartModel => _yearlyBarChartModel;

  int _dateDifference = 0;
  int get dateDifference => _dateDifference;

  String _graphType = '';
  String get graphType => _graphType;

  String formattedFromDate = '';
  String formattedToDate = '';

  @override
  void onInit() {
    super.onInit();
    String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    _fromDateTEController.text = todayDate;
    _toDateTEController.text = todayDate;
  }

  Future<bool> fetchDgrData({
    required String fromDate,
    required String toDate,
    bool fromButton = false,
  }) async {
    if (firstTimeLoader) {
      _isDgrPantProgress = true;
      update();
    }

    _isDgrPantButtonProgress = fromButton;
    update();

    formattedFromDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(
      DateFormat("dd-MM-yyyy").parse(fromDate).toLocal(),
    );

    final parsedToDate = DateFormat("dd-MM-yyyy").parse(toDate);
    final adjustedToDate = parsedToDate.add(const Duration(hours: 23, minutes: 59, seconds: 59));
    formattedToDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(adjustedToDate.toUtc());
    update();

    Map<String, String> requestBody = {
      "start": formattedFromDate,
      "end": formattedToDate,
    };

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.postDgrFilterPlantDataUrl,
        body: requestBody,
      );

      log("postDgrFilterPlantDataUrl statusCode ==> ${Urls.postDgrFilterPlantDataUrl}");
      log("postDgrFilterPlantDataUrl statusCode ==> ${response.statusCode}");

      _isDgrPantProgress = false;
      _isDgrPantButtonProgress = false;
      update();

      if (response.isSuccess) {
        _graphType = response.body['graph-type'];

        if (_graphType == "Line-Chart") {
          _lineChartModel = DGRLineChartModel.fromJson(response.body);
        } else if (_graphType == "Monthly-Bar-Chart") {
          _monthlyBarchartModel = DGRMonthlyChartModel.fromJson(response.body);
        } else {
          _yearlyBarChartModel = DGRYearlyBarChartModel.fromJson(response.body);
        }

        log(_graphType);
        update();
        return true;
      } else {
        _errorMessage = "Failed to fetch filter data";
        update();
        return false;
      }
    } catch (e) {
      _isDgrPantProgress = false;
      _isDgrPantButtonProgress = false;
      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching filter data: $_errorMessage');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    } finally {
      firstTimeLoader = false;
      update();
    }
  }

  final TextEditingController _fromDateTEController = TextEditingController();
  final TextEditingController _toDateTEController = TextEditingController();
  final RxBool _clearDate = false.obs;

  RxBool get clearDate => _clearDate;
  TextEditingController get fromDateTEController => _fromDateTEController;
  TextEditingController get toDateTEController => _toDateTEController;

  void formDatePicker(BuildContext context) async {
    DateTime? picker = await showDatePicker(
      context: context,
      initialDate: _fromDateTEController.text.isNotEmpty
          ? DateFormat("dd-MM-yyyy").parse(_fromDateTEController.text)
          : DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2130),
    );

    if (picker != null) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(picker);
      _fromDateTEController.text = formattedDate;
      _clearDate.value = true;

      fetchDgrData(fromDate: _fromDateTEController.text, toDate: _toDateTEController.text);
      update();

      validateDates(context);
    }
  }

  void toDatePicker(BuildContext context) async {
    DateTime? picker = await showDatePicker(
      context: context,
      initialDate: _toDateTEController.text.isNotEmpty
          ? DateFormat("dd-MM-yyyy").parse(_toDateTEController.text)
          : DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2130),
    );

    if (picker != null) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(picker);
      _toDateTEController.text = formattedDate;
      _clearDate.value = true;
      fetchDgrData(fromDate: _fromDateTEController.text, toDate: _toDateTEController.text);
      update();
      validateDates(context);
    }
  }


  Future<PermissionStatus> _requestStoragePermission() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    if (android.version.sdkInt < 33) {
      return await Permission.storage.request();
    } else {
      return PermissionStatus.granted;
    }
  }

  Future<void> downloadDataSheet(BuildContext context) async {
    // Request storage permission
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      Workbook? workbook;
      try {
        workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'DGR Report';
        sheet.getRangeByIndex(1, 1).columnWidth = 20;
        sheet.getRangeByIndex(1, 2).columnWidth = 20;
        sheet.getRangeByIndex(1, 3).columnWidth = 15;
        sheet.getRangeByIndex(1, 4).columnWidth = 15;
        sheet.getRangeByIndex(1, 5).columnWidth = 15;
        sheet.getRangeByIndex(1, 6).columnWidth = 15;

        // Add header row with styling
        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        List<String> headers = [];
        if (_graphType == "Line-Chart") {
          headers = [
            'Date',
            'AC Power',
            'PR',
            'Irradiation East',
            'Irradiation West',
            'Today Energy',
          ];
        } else if (_graphType == "Monthly-Bar-Chart" || _graphType == "Yearly-Bar-Chart") {
          headers = [
            'Date',
            'Ac Power',
            'Total Energy',
            'Cumulative PR',
            'Expected Energy',
            'POA Day Avg',
          ];
        }

        // Populate header row
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
          sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
        }

        // Add data rows based on graph type
        if (_graphType == "Line-Chart" && lineChartModel.data?.isNotEmpty == true) {
          for (int i = 0; i < lineChartModel.data!.length; i++) {
            final rowIndex = i + 2; // Start from row 2 (after header)
            final data = lineChartModel.data![i];
            try {
              String formattedDate = DateFormat('dd/MMM/yyyy HH:mm:ss').format(DateTime.parse(data.timedate!));
              sheet.getRangeByIndex(rowIndex, 1).setText(formattedDate);
            } catch (e) {
              log("Error parsing timedate for Line-Chart: ${data.timedate}, error: $e");
              sheet.getRangeByIndex(rowIndex, 1).setText("Invalid Date");
            }
            sheet.getRangeByIndex(rowIndex, 2).setNumber(data.acPower != null ? double.tryParse(data.acPower.toString()) ?? 0 : 0);
            sheet.getRangeByIndex(rowIndex, 3).setNumber(data.pr != null ? double.tryParse(data.pr.toString()) ?? 0 : 0);
            sheet.getRangeByIndex(rowIndex, 4).setNumber(data.irrEast != null ? double.tryParse(data.irrEast.toString()) ?? 0 : 0);
            sheet.getRangeByIndex(rowIndex, 5).setNumber(data.irrWest != null ? double.tryParse(data.irrWest.toString()) ?? 0 : 0);
            sheet.getRangeByIndex(rowIndex, 6).setNumber(data.todayEnergy != null ? double.tryParse(data.todayEnergy.toString()) ?? 0 : 0);
          }
        } else if (_graphType == "Monthly-Bar-Chart" && monthlyBarchartModel.data?.isNotEmpty == true) {
          for (int i = 0; i < monthlyBarchartModel.data!.length; i++) {
            final rowIndex = i + 2; // Start from row 2 (after header)
            final data = monthlyBarchartModel.data![i];
            try {
              log("Parsing date for Monthly-Bar-Chart: ${data.date}");
              String formattedDate;
              if (data.date!.contains(RegExp(r'^\d{2}/[A-Za-z]{3}$'))) {
                // If the date is in "dd/MMM" format (e.g., "15/Mar"), append the current year
                final currentYear = DateTime.now().year;
                formattedDate = DateFormat('dd/MMM/yyyy').format(
                  DateFormat('dd/MMM/yyyy').parse("${data.date}/$currentYear"),
                );
              } else {
                // Otherwise, assume "yyyy-MM-dd" format
                formattedDate = DateFormat('dd/MMM/yyyy').format(
                  DateFormat('yyyy-MM-dd').parse(data.date!),
                );
              }
              sheet.getRangeByIndex(rowIndex, 1).setText(formattedDate);
            } catch (e) {
              log("Error parsing date for Monthly-Bar-Chart: ${data.date}, error: $e");
              sheet.getRangeByIndex(rowIndex, 1).setText("Invalid Date");
            }
            sheet.getRangeByIndex(rowIndex, 2).setNumber(data.maxAcPower ?? 0);
            sheet.getRangeByIndex(rowIndex, 3).setNumber(data.totalEnergy != null ? double.tryParse(data.totalEnergy.toString()) ?? 0 : 0);
            sheet.getRangeByIndex(rowIndex, 4).setNumber(data.cumulativePr != null ? double.tryParse(data.cumulativePr.toString()) ?? 0 : 0);
            sheet.getRangeByIndex(rowIndex, 5).setNumber(data.expectedEnergy != null ? double.tryParse(data.expectedEnergy.toString()) ?? 0 : 0);
            sheet.getRangeByIndex(rowIndex, 6).setNumber(data.poaDayAvg != null ? double.tryParse(data.poaDayAvg.toString()) ?? 0 : 0);
          }
        } else if (_graphType == "Yearly-Bar-Chart" && yearlyBarChartModel.data?.isNotEmpty == true) {
          for (int i = 0; i < yearlyBarChartModel.data!.length; i++) {
            final rowIndex = i + 2; // Start from row 2 (after header)
            final data = yearlyBarChartModel.data![i];
            try {
              log("Parsing date for Yearly-Bar-Chart: ${data.date}");
              String formattedDate;
              if (data.date!.contains(RegExp(r'^\d{2}/[A-Za-z]{3}$'))) {
                // If the date is in "dd/MMM" format (e.g., "15/Mar"), append the current year
                final currentYear = DateTime.now().year;
                formattedDate = DateFormat('dd/MMM/yyyy').format(
                  DateFormat('dd/MMM/yyyy').parse("${data.date}/$currentYear"),
                );
              } else {
                // Otherwise, assume "yyyy-MM-dd" format
                formattedDate = DateFormat('dd/MMM/yyyy').format(
                  DateFormat('yyyy-MM-dd').parse(data.date!),
                );
              }
              sheet.getRangeByIndex(rowIndex, 1).setText(formattedDate);
            } catch (e) {
              log("Error parsing date for Yearly-Bar-Chart: ${data.date}, error: $e");
              sheet.getRangeByIndex(rowIndex, 1).setText("Invalid Date");
            }
            sheet.getRangeByIndex(rowIndex, 2).setNumber(data.maxAcPower ?? 0);
            sheet.getRangeByIndex(rowIndex, 3).setNumber(data.totalEnergy != null ? double.tryParse(data.totalEnergy.toString()) ?? 0 : 0);
            sheet.getRangeByIndex(rowIndex, 4).setNumber(data.cumulativePr != null ? double.tryParse(data.cumulativePr.toString()) ?? 0 : 0);
            sheet.getRangeByIndex(rowIndex, 5).setNumber(data.expectedEnergy != null ? double.tryParse(data.expectedEnergy.toString()) ?? 0 : 0);
            sheet.getRangeByIndex(rowIndex, 6).setNumber(data.poaDayAvg != null ? double.tryParse(data.poaDayAvg.toString()) ?? 0 : 0);
          }
        }

        // Auto-fit header row
        if (headers.isNotEmpty) {
          sheet.autoFitRow(1);
        }

        // Save the file to the Download directory
        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (directory.existsSync()) {
            String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());

            String plantName = "DGR_Report";
            if (_graphType == "Line-Chart" && lineChartModel.data?.isNotEmpty == true) {
              plantName = lineChartModel.data!.first.plantName?.replaceAll('_', ' ') ?? 'DGR_Report';
            } else if (_graphType == "Monthly-Bar-Chart" && monthlyBarchartModel.data?.isNotEmpty == true) {
              plantName = monthlyBarchartModel.data!.first.plantName?.replaceAll('_', ' ') ?? 'DGR_Report';
            } else if (_graphType == "Yearly-Bar-Chart" && yearlyBarChartModel.data?.isNotEmpty == true) {
              plantName = yearlyBarChartModel.data!.first.plantName?.replaceAll('_', ' ') ?? 'DGR_Report';
            }

            String filePath = "${directory.path}/$plantName $formattedDate $formattedTime.xlsx";

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
              margin: const EdgeInsets.all(16),
            );

            FlutterSmartDownloadDialog.show(
              context: context,
              filePath: filePath,
              dialogType: DialogType.popup,
            );
            log("File saved at ==> $filePath");
          } else {
            Get.snackbar(
              "Error",
              "Could not access the storage directory.",
              duration: const Duration(seconds: 7),
              backgroundColor: AppColors.redColor,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
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
    } else if (storageStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }





  void validateDates(BuildContext context) {
    final fromDate = DateFormat("dd-MM-yyyy").parse(_fromDateTEController.text);
    final toDate = DateFormat("dd-MM-yyyy").parse(_toDateTEController.text);

    if (fromDate.isAfter(toDate)) {
      AppToast.showWrongToast("Invalid Date Range");
    }
  }

  void dateDifferenceDates(BuildContext context) {
    final fromDate = DateFormat("dd-MM-yyyy").parse(_fromDateTEController.text);
    final toDate = DateFormat("dd-MM-yyyy").parse(_toDateTEController.text);

    _dateDifference = toDate.difference(fromDate).inDays;
    update();
  }

  int selectButtonValue = 1;

  void updateSelectedValue(int value) {
    selectButtonValue = value;
    update();
  }

  void clearFilterIngDate() {
    String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    _fromDateTEController.text = todayDate;
    _toDateTEController.text = todayDate;
    _dateDifference = 0;
    update();
  }
}