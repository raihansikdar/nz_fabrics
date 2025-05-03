import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../model/filter_over_all_water_line_chart_model.dart';
import '../model/filter_over_all_yearly_bar_chart_data_model.dart';
import '../model/filter_over_water_all_monthly_bar_chart_Model.dart';
import '../views/widgets/sub_part/water_source_table_widget.dart';

class OverAllWaterSourceDataController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isFilterSpecificNodeInProgress = false;
  bool _isFilterButtonProgress = false;
  String _errorMessage = '';

  FilterOverAllLineChartModel _lineChartModel = FilterOverAllLineChartModel();
  FilterOverAllWaterMonthlyBarChartDataModel _monthlyBarchartModel = FilterOverAllWaterMonthlyBarChartDataModel();
  FilterOverAllWaterYearlyBarChartDataModel _yearlyBarChartModel = FilterOverAllWaterYearlyBarChartDataModel();


  bool get isConnected => _isConnected;
  bool get isFilterSpecificNodeInProgress => _isFilterSpecificNodeInProgress;
  bool get isFilterButtonProgress => _isFilterButtonProgress;
  String get errorMessage => _errorMessage;

  FilterOverAllLineChartModel get  lineChartModel => _lineChartModel;
  FilterOverAllWaterMonthlyBarChartDataModel get  monthlyBarchartModel => _monthlyBarchartModel;
  FilterOverAllWaterYearlyBarChartDataModel get  yearlyBarChartModel => _yearlyBarChartModel;


  String _graphType = '';

  String get graphType => _graphType;

  String formattedFromDate = '';
  String formattedToDate = '';

  int dateDifference  = 0;

  void clearFilterIngDate(){
    String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    _fromDateTEController.text = todayDate;
    _toDateTEController.text = todayDate;
    dateDifference = 0;
    Get.find<WaterSourceDataController>().fetchData(_fromDateTEController.text, _toDateTEController.text);
    update();
  }
  @override
  void onInit() {
    super.onInit();
    String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    _fromDateTEController.text = todayDate;
    _toDateTEController.text = todayDate;
  }

  Future<bool> fetchOverAllSourceData({required String fromDate, required String toDate,bool fromButton = false }) async {

    _isFilterSpecificNodeInProgress = true;
    _isFilterButtonProgress = fromButton;
    update();


    // final formattedFromDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(
    //   DateFormat("dd-MM-yyyy").parse(fromDate).toUtc(),
    // );

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

  //  log("Request Custom Body Date: $requestBody");
  //  log("formattedFromDate: $formattedFromDate");
   // log("formattedToDate: $formattedToDate");

    try {
      await internetConnectivityCheck();
      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.getFilterOverallWaterSourceDataUrl,
        body: requestBody,
      );

      // log("getFilterOverallSourceDataUrl statusCode ==> ${Urls.getFilterOverallSourceDataUrl}");
      //
      // log("getFilterOverallSourceDataUrl statusCode ==> ${response.statusCode}");
      // log("getFilterOverallSourceDataUrl body ==> ${response.body}");

      _isFilterSpecificNodeInProgress = false;
      _isFilterButtonProgress = false;
      update();

      if (response.isSuccess) {
        _graphType = response.body['graph-type'];

        if(_graphType == "Line-Chart"){

          _lineChartModel = FilterOverAllLineChartModel.fromJson(response.body);

        }  else if (_graphType == "Monthly-Bar-Chart"){
          _monthlyBarchartModel = FilterOverAllWaterMonthlyBarChartDataModel.fromJson(response.body);
        }else{
          _yearlyBarChartModel = FilterOverAllWaterYearlyBarChartDataModel.fromJson(response.body);
        }


        log(_graphType);
        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch filter data";
        update();
        return false;
      }
    } catch (e) {
      _isFilterSpecificNodeInProgress = false;
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
      try {
        // Create a new Excel workbook and worksheet
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'Report';

        // Define column widths for better readability
        sheet.getRangeByIndex(1, 1, 1, 1).columnWidth = 15; // Date
        sheet.getRangeByIndex(1, 2, 1, 2).columnWidth = 20; // Plant Name
        sheet.getRangeByIndex(1, 3, 1, 3).columnWidth = 15; // AC Power / Cumulative PR
        sheet.getRangeByIndex(1, 4, 1, 4).columnWidth = 15; // PR / POA Day Avg
        sheet.getRangeByIndex(1, 5, 1, 5).columnWidth = 15; // Irradiation East
        sheet.getRangeByIndex(1, 6, 1, 6).columnWidth = 15; // Irradiation West

        // Add header row with styling
        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        List<String> headers = [];
        if (_graphType == "Line-Chart") {
          headers = [
            'Date',
            'Node Name',
            'Instant Flow',
            'Cost',
          ];
        } else if (_graphType == "Monthly-Bar-Chart" || _graphType == "Yearly-Bar-Chart") {
          headers = [
            'Date',
            'Node Name',
            'Volume',
            'Cost',
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
            String formattedDate = DateFormat('dd/MMM/yyyy HH:mm:ss').format(DateTime.parse(data.timedate!));
            sheet.getRangeByIndex(rowIndex, 1).setText(formattedDate);
            sheet.getRangeByIndex(rowIndex, 2).setText(data.node ?? 'N/A');
            sheet.getRangeByIndex(rowIndex, 3).setNumber(data.instantFlow?.toDouble() ?? 0);
            sheet.getRangeByIndex(rowIndex, 4).setNumber(data.cost?.toDouble() ?? 0);

          }
        } else if (_graphType == "Monthly-Bar-Chart" && monthlyBarchartModel.data?.isNotEmpty == true) {
          for (int i = 0; i < monthlyBarchartModel.data!.length; i++) {
            final rowIndex = i + 2; // Start from row 2 (after header)
            final data = monthlyBarchartModel.data![i];
            String formattedDate = DateFormat('dd/MMM/yyyy').format(DateTime.parse(data.date!));
            sheet.getRangeByIndex(rowIndex, 1).setText(formattedDate);
            sheet.getRangeByIndex(rowIndex, 2).setText(data.node ?? 'N/A');
            sheet.getRangeByIndex(rowIndex, 3).setNumber(data.volume?.toDouble() ?? 0);
            sheet.getRangeByIndex(rowIndex, 4).setNumber(data.cost?.toDouble() ?? 0);
          }
        } else if (_graphType == "Yearly-Bar-Chart" && yearlyBarChartModel.data?.isNotEmpty == true) {
          for (int i = 0; i < yearlyBarChartModel.data!.length; i++) {
            final rowIndex = i + 2; // Start from row 2 (after header)
            final data = yearlyBarChartModel.data![i];
            String formattedDate = DateFormat('dd/MMM/yyyy').format(DateTime.parse(data.date!));
            sheet.getRangeByIndex(rowIndex, 1).setText(formattedDate);
            sheet.getRangeByIndex(rowIndex, 2).setText(data.node ?? 'N/A');
            sheet.getRangeByIndex(rowIndex, 3).setNumber(data.volume?.toDouble() ?? 0);
            sheet.getRangeByIndex(rowIndex, 4).setNumber(data.cost?.toDouble() ?? 0);
          }
        }

        // Auto-fit header row
        if (headers.isNotEmpty) {
          sheet.autoFitRow(1); // Auto-fit only after ensuring the header row is populated
        }

        // Save the file to the Download directory
        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (directory.existsSync()) {
            String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());

            // Safely get plant name or use a default
            String plantName = "Report";
            if (_graphType == "Line-Chart" && lineChartModel.data?.isNotEmpty == true) {
              plantName = lineChartModel.data!.first.node?.replaceAll('_', ' ') ?? 'Report';
            } else if (_graphType == "Monthly-Bar-Chart" && monthlyBarchartModel.data?.isNotEmpty == true) {
              plantName = monthlyBarchartModel.data!.first.node?.replaceAll('_', ' ') ?? 'Report';
            } else if (_graphType == "Yearly-Bar-Chart" && yearlyBarChartModel.data?.isNotEmpty == true) {
              plantName = yearlyBarChartModel.data!.first.node?.replaceAll('_', ' ') ?? 'Report';
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
                margin: const EdgeInsets.all(16)
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








  final TextEditingController _fromDateTEController = TextEditingController();
  final TextEditingController _toDateTEController = TextEditingController();
  final RxBool _clearDate = false.obs;

  RxBool get clearDate => _clearDate;
  TextEditingController get fromDateTEController => _fromDateTEController;
  TextEditingController get toDateTEController => _toDateTEController;

  void formDatePicker(BuildContext context) async {
    DateTime? picker = await showDatePicker(
      context: context,
      initialDate:_fromDateTEController.text.isNotEmpty
          ? DateFormat("dd-MM-yyyy").parse(_fromDateTEController.text)
          : DateTime.now(),

      firstDate: DateTime(2024),
      lastDate: DateTime(2130),
    );

    if (picker != null) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(picker);
      _fromDateTEController.text = formattedDate;
      _clearDate.value = true;
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
      update();
      validateDates(context);
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

    dateDifference = toDate.difference(fromDate).inDays;
    log("======> $dateDifference");
    update();
  }



  int selectButtonValue = 1;

  void updateSelectedValue(int value){
    selectButtonValue = value;
    update();
  }


}