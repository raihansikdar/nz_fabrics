import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/table_model/filter_specific_table_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/water_filter_specific_node_model/water_line_chart_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/water_filter_specific_node_model/water_monthly_bar_chart_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/water_filter_specific_node_model/water_yearly_bar_chart_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class WaterFilterSpecificNodeDataController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isFilterSpecificNodeInProgress = false;
  bool _isFilterButtonInProgress = false;
  bool _isFilterTableInProgress = false;
  String _errorMessage = '';

  List<WaterLineData> _lineChartDataList = <WaterLineData>[];
  List<WaterMonthlyBarChartData> _monthlyBarChartDataList = <WaterMonthlyBarChartData>[];
  List<WaterYearlyBarChartData> _yearlyBarChartDataList = <WaterYearlyBarChartData>[];
  FilterSpecificNodeTableModel _filterSpecificNodeTableModel = FilterSpecificNodeTableModel();

  bool get isConnected => _isConnected;
  bool get isFilterSpecificNodeInProgress => _isFilterSpecificNodeInProgress;
  bool get isFilterTableInProgress => _isFilterTableInProgress;
  bool get isFilterButtonInProgress => _isFilterButtonInProgress;
  String get errorMessage => _errorMessage;

  List<WaterLineData> get lineChartDataList => _lineChartDataList;
  List<WaterMonthlyBarChartData> get monthlyBarChartDataList => _monthlyBarChartDataList;
  List<WaterYearlyBarChartData> get yearlyBarChartDataList => _yearlyBarChartDataList;

  FilterSpecificNodeTableModel get filterSpecificNodeTableModel => _filterSpecificNodeTableModel;



  String _graphType = '';
  String get graphType => _graphType;

  int dateDifference  = 0;


  @override
  void onInit() {
    super.onInit();
    String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    _fromDateTEController.text = todayDate;
    _toDateTEController.text = todayDate;
  }


  void clearFilterIngDate(){
    String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    _fromDateTEController.text = todayDate;
    _fromDateTEController.text = todayDate;

    update();
  }

  Future<bool> fetchFilterSpecificData({required String nodeName,required String fromDate, required String toDate ,bool fromButton = false}) async {

    _isFilterSpecificNodeInProgress = true;
    _isFilterButtonInProgress = fromButton;
    update();

    final formattedFromDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(
      DateFormat("dd-MM-yyyy").parse(fromDate).toLocal(), // Use local time without converting to UTC
    );

    final parsedToDate = DateFormat("dd-MM-yyyy").parse(toDate);
    final adjustedToDate = parsedToDate.add(const Duration(hours: 23, minutes: 59, seconds: 59));
    final formattedToDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(adjustedToDate.toLocal());


    Map<String, String> requestBody = {
      "start": formattedFromDate,
      "end": formattedToDate,
    };

    log("Request Custom Body Date: $requestBody");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.postFilterSpecificNodeDataUrl(nodeName),
        body: requestBody,
      );

    //  log("postFilterSpecificNodeDataUrl statusCode ==> ${Urls.postFilterSpecificNodeDataUrl(nodeName)}");

     // log("postFilterSpecificNodeDataUrl statusCode ==> ${response.statusCode}");
     //log("postFilterSpecificNodeDataUrl body ==> ${response.body}");

      _isFilterSpecificNodeInProgress = false;
      _isFilterButtonInProgress = false;
      update();

      if (response.isSuccess) {
        _graphType = response.body['graph-type'];

        if(_graphType == "Line-Chart"){
          final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
          _lineChartDataList = jsonData.map((json) => WaterLineData.fromJson(json as Map<String, dynamic>)).toList();
        }  else if (_graphType == "Monthly-Bar-Chart"){
          final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
          _monthlyBarChartDataList = jsonData.map((json) => WaterMonthlyBarChartData.fromJson(json as Map<String, dynamic>)).toList();




        }else{
          final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
          _yearlyBarChartDataList = jsonData.map((json) => WaterYearlyBarChartData.fromJson(json as Map<String, dynamic>)).toList();
        }


      //  log("---> $_graphType");
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


  /*--------------------> Second <-----------------------*/
  Future<bool> fetchFilterSpecificTableData({required String nodeName,required String fromDate, required String toDate ,bool fromButton = false}) async {

    _isFilterTableInProgress = true;
    _isFilterButtonInProgress = fromButton;
    update();

    final formattedFromDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(
      DateFormat("dd-MM-yyyy").parse(fromDate).toLocal(), // Use local time without converting to UTC
    );

    final parsedToDate = DateFormat("dd-MM-yyyy").parse(toDate);
    final adjustedToDate = parsedToDate.add(const Duration(hours: 23, minutes: 59, seconds: 59));
    final formattedToDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(adjustedToDate.toLocal());


    Map<String, String> requestBody = {
      "start": formattedFromDate,
      "end": formattedToDate,
      "node": nodeName
    };

    log("Request Custom Body Date: $requestBody");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.getFilterSSpecificTableDataUrl,
        body: requestBody,
      );

      //  log("getFilterSSpecificTableDataUrl statusCode ==> ${Urls.getFilterSSpecificTableDataUrl}");
      //
       log("getWaterFilterSSpecificTableDataUrl statusCode ==> ${response.statusCode}");
       log("getFilterSSpecificTableDataUrl body ==> ${response.body}");

      _isFilterTableInProgress = false;
     // _isFilterButtonInProgress = false;
      update();

      if (response.isSuccess) {


          // final jsonData = (response.body as Map<String, dynamic>)['data'] as List<dynamic>;
          // _lineChartDataList = jsonData.map((json) => LineData.fromJson(json as Map<String, dynamic>)).toList();

         final jsonData = (response.body);
         _filterSpecificNodeTableModel = FilterSpecificNodeTableModel.fromJson(jsonData);

     //   log("---> $_graphType");
        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch filter data";
        update();
        return false;
      }
    } catch (e) {
      _isFilterTableInProgress = false;
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

  Future<void> downloadDataSheet(context) async {
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        // Create a new Excel workbook
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'Report';

        // Set column widths for better readability
        sheet.getRangeByIndex(1, 1, 1, 1).columnWidth = 15; // Date
        sheet.getRangeByIndex(1, 2, 1, 2).columnWidth = 20; // Energy
        sheet.getRangeByIndex(1, 3, 1, 3).columnWidth = 15; // Cost


        // Add header row with styling
        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';
        final List<String> headers = ['Date', 'Energy', 'Cost'];
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
          sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
        }

        // Add data rows
        final nodeTableData = List.from(_filterSpecificNodeTableModel.data ?? []);
        for (int i = 0; i < nodeTableData.length; i++) {
          final rowIndex = i + 2; // Start from row 2 (after header)
          final data = nodeTableData[i];
          sheet.getRangeByIndex(rowIndex, 1).setText(data.date?.toString() ?? 'N/A');
          sheet.getRangeByIndex(rowIndex, 2).setText(data.volume?.toString() ?? 'N/A');
          sheet.getRangeByIndex(rowIndex, 3).setNumber(data.cost?.toDouble() ?? 0);

        }


        sheet.autoFitRow(1);

        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (directory.existsSync()) {
            String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
            String filePath =
                "${directory.path}/${_filterSpecificNodeTableModel.data?.first.node?.replaceAll('_', '') ?? 'N/A'} $formattedDate $formattedTime.xlsx";


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
            log("==>$filePath");
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

      firstDate: DateTime(2022),
      lastDate: DateTime(2130),
    );

    if (picker != null) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(picker);
      _fromDateTEController.text = formattedDate;
      _clearDate.value = true;
      validateDates(context);
      log( "Start date: ${_fromDateTEController.text}");
      update();
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
      validateDates(context);
      log( "End date: ${_toDateTEController.text}");
      update();
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







  int selectedButton = 1;
  void updateSelectedButton({required int value}) {
    selectedButton = value;
    log("selected button $selectedButton");
    update();
  }


  // void findMinMaxCostDates() {
  //   if (_monthlyBarChartDataList.isEmpty) {
  //     log("No data available.");
  //     return;
  //   }
  //
  //   // Find min and max cost entries
  //   MonthlyBarChartData minCostData = WaterMonthlyBarChartData.reduce((a, b) => a.cost < b.cost ? a : b);
  //   MonthlyBarChartData maxCostData = WaterMonthlyBarChartData.reduce((a, b) => a.cost > b.cost ? a : b);
  //
  //   log("Minimum cost date: ${minCostData.date}, Cost: ${minCostData.cost}");
  //   log("Maximum cost date: ${maxCostData.date}, Cost: ${maxCostData.cost}");
  // }


}