import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/daily_analysis_pro_filter_dgr_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/electricity_analysis_pro_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/monthly_analysis_pro_filter_dgr_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/yearly_analysis_pro_filter_dgr_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ElectricityDayAnalysisProController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isElectricityAnalysisProInProgress = false;
  String _errorMessage = '';
  List<ElectricityAnalysisProModel> _electricityAnalysisProSourceList = <ElectricityAnalysisProModel>[];
  List<ElectricityAnalysisProModel> _electricityAnalysisProLoadList = <ElectricityAnalysisProModel>[];

  bool get isConnected => _isConnected;
  bool get isElectricityAnalysisProInProgress => _isElectricityAnalysisProInProgress;
  String get errorMessage => _errorMessage;

  List<ElectricityAnalysisProModel> get electricityAnalysisProSourceList => _electricityAnalysisProSourceList;
  List<ElectricityAnalysisProModel> get electricityAnalysisProLoadList => _electricityAnalysisProLoadList;

  int _dateDifference = 0;
  int get dateDifference => _dateDifference;

  Set<String> itemsList = {};
  Set<String> removeList = {};

  Future<bool> fetchElectricityAnalysisPro() async {


    _isElectricityAnalysisProInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.nodeNameElectricityAnalysisProUrl);

     // log("dayElectricityAnalysisProUrl statusCode ==> ${response.statusCode}");
      // log("dayElectricityAnalysisProUrl body ==> ${response.body}");

      _isElectricityAnalysisProInProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
          _electricityAnalysisProSourceList = jsonData.where((data)=> data['source_type'] == "Source").map((json)=> ElectricityAnalysisProModel.fromJson(json)).toList();
          _electricityAnalysisProLoadList = jsonData.where((data)=> data['source_type'] == "Load").map((json)=> ElectricityAnalysisProModel.fromJson(json)).toList();
        initializeItems();

        // Get current date
        final currentDate = DateTime.now();
        final formattedFromDate = DateFormat("dd-MM-yyyy").format(currentDate);
        final formattedToDate = DateFormat("dd-MM-yyyy").format(currentDate);

        _fromDateTEController.text = formattedFromDate;
        _toDateTEController.text = formattedToDate;

        // Call fetchSelectedNodeData with current date range
        await fetchSelectedNodeData(
          fromDate: formattedFromDate,
          toDate: formattedToDate,
          nodes: itemsList.toList(),
        );



        log(_fromDateTEController.text.toString());
        log(_toDateTEController.text.toString());

        update();
        return true;

      } else {
        _errorMessage = "Failed to fetch electricity day analysis pro.";
        update();
        return false;
      }
    } catch (e) {
      _isElectricityAnalysisProInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching electricity day analysis pro : $_errorMessage');
      _errorMessage = "Failed to fetch electricity day analysis pro.";

      return false;
    }
  }


  // UI methods
  int selectedButton = 1;
  void updateSelectedButton({required int value}) {
    selectedButton = value;
    log("selectedButton: $selectedButton");
    update();
  }

  Set<int> selectedIndices = {};
  void toggleSelection(int index, bool selected) {
    if (selected) {
      selectedIndices.add(index);
      log("==day selectedIndices ==$selectedIndices");
    } else {
      selectedIndices.remove(index);
      log(selectedIndices.toString());
    }
    update();
  }

  Map<String, List<bool>> checkboxGroupStates = {
    'source': List.filled(1000, false),
    'load': List.filled(1000, false),
    'waterSource': List.filled(1000, true),
    'waterLoad': List.filled(1000, true),
    'naturalGasSource': List.filled(1000, true),
    'naturalGasLoad': List.filled(1000, true),
  };

  Map<String, List<String>> selectedGridItemsMapString = {};

  void updateSelectedGridItems(String key, String node, bool isSelected) {
    if (selectedGridItemsMapString[key] == null) {
      selectedGridItemsMapString[key] = []; // Initialize the list if it's null
    }

    if (isSelected) {
      if (!selectedGridItemsMapString[key]!.contains(node)) {
        selectedGridItemsMapString[key]!.add(node);
       // log("==BeforeADD==>>+++$itemsList");

        if (!itemsList.contains(node)) {
          itemsList.add(node);
          // Ensure checkboxGroupStates reflects this
          int index = electricityAnalysisProSourceList.indexWhere((item) => item.nodeName == node);
          if (index != -1) {
            checkboxGroupStates[key]?[index] = true;
          }
        }

        removeList.removeWhere((element) => element == node);
        //log("==AfterADD==>>+++$itemsList");
      }
    } else {
      selectedGridItemsMapString[key]!.remove(node);
     // log("====>>BeforeRemove removeList +++$removeList");

      removeList.add(node);
      itemsList.remove(node);

      // Update checkboxGroupStates
      int index = electricityAnalysisProSourceList.indexWhere((item) => item.nodeName == node);
      if (index != -1) {
        checkboxGroupStates[key]?[index] = false;
      }

     // log("====>>AfterRemove removeList+++$removeList");
    }

   // log("====>>Stay in Set +++$itemsList");
    update();
  }

  void initializeItems() {

    if (electricityAnalysisProSourceList.isNotEmpty) {
      final firstNode = electricityAnalysisProSourceList.first.nodeName;
      if (!itemsList.contains(firstNode)) {
        itemsList.add(firstNode ?? '');
        updateSelectedGridItems('Source',firstNode ?? '',true);

        checkboxGroupStates['source']?[0] = true;

        //log("==first time itemList==>>+++$itemsList");
        update();
      }
    }


    if (electricityAnalysisProLoadList.isNotEmpty) {
      final firstNode = electricityAnalysisProLoadList.first.nodeName;
      if (!itemsList.contains(firstNode)) {
        itemsList.add(firstNode ?? '');
        updateSelectedGridItems('Load',firstNode ?? '',true);

        checkboxGroupStates['load']?[0] = true;

      //  log("==first time itemList Load ==>>+++$itemsList");
        update();
      }
    }


  }

  void toggleGroup(String group, bool isSelected) {
    checkboxGroupStates[group] = (checkboxGroupStates[group] ?? List.filled(1000, false)).map((_) => isSelected).toList();
    update();
  }



  DailyAnalysisProFilterDgrDataModel _dailyAnalysisProFilterDgrDataModel = DailyAnalysisProFilterDgrDataModel();
  DailyAnalysisProFilterDgrDataModel get dailyAnalysisProFilterDgrDataModel => _dailyAnalysisProFilterDgrDataModel;

  MonthlyAnalysisProFilterDgrDataModel _monthlyAnalysisProFilterDgrDataModel = MonthlyAnalysisProFilterDgrDataModel();
  MonthlyAnalysisProFilterDgrDataModel get monthlyAnalysisProFilterDgrDataModel => _monthlyAnalysisProFilterDgrDataModel;

  YearlyAnalysisProFilterDgrDataModel _yearlyAnalysisProFilterDgrDataModel = YearlyAnalysisProFilterDgrDataModel();
  YearlyAnalysisProFilterDgrDataModel get yearlyAnalysisProFilterDgrDataModel => _yearlyAnalysisProFilterDgrDataModel;

  String _graphType = '';

  String get graphType => _graphType;
  List<DailyDataModel> dailySourceData = [];
  List<DailyDataModel> dailyLoadData = [];

  List<MonthlyDataModel> monthlySourceData = [];
  List<MonthlyDataModel> monthlyLoadData = [];

  List<YearlyDataModel> yearlySourceData = [];
  List<YearlyDataModel> yearlyLoadData = [];

  bool isSelectedDataInProgress = false;

  Future<bool> fetchSelectedNodeData({required String fromDate, required String toDate, required List<String>nodes,bool fromButton = false }) async {

    final formattedFromDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(DateFormat("dd-MM-yyyy").parse(fromDate));
    final parsedToDate = DateFormat("dd-MM-yyyy").parse(toDate);
    final adjustedToDate = parsedToDate.add(const Duration(hours: 23, minutes: 59, seconds: 59));
    final formattedToDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(adjustedToDate);

    Map<String, dynamic> requestBody = {
      "start": formattedFromDate,
      "end": formattedToDate,
      "nodes": nodes,
    };

    try {
      await internetConnectivityCheck();

      isSelectedDataInProgress = fromButton;
      update();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.postFilterDgrDataUrl,
        body: requestBody,
      );

      //  log("postFilterDgrDataUrl statusCode ==> ${response.statusCode}");
      // log("postFilterDgrDataUrl body ==> ${response.body}");

      isSelectedDataInProgress = false;
      update();

      if (response.isSuccess) {
        _graphType = response.body['graph-type'];
        if(_graphType == 'Line-Chart'){
          _dailyAnalysisProFilterDgrDataModel = DailyAnalysisProFilterDgrDataModel.fromJson(response.body);

          dailySourceData = _dailyAnalysisProFilterDgrDataModel.data!
              .where((data) => data.type == "Source")
              .toList();
          dailyLoadData = _dailyAnalysisProFilterDgrDataModel.data!
              .where((data) => data.type == "Load")
              .toList();

        }else  if(_graphType == 'Monthly-Bar-Chart'){
          _monthlyAnalysisProFilterDgrDataModel = MonthlyAnalysisProFilterDgrDataModel.fromJson(response.body);

          monthlySourceData = _monthlyAnalysisProFilterDgrDataModel.data!
              .where((data) => data.nodeType == "Source")
              .toList();
          monthlyLoadData = _monthlyAnalysisProFilterDgrDataModel.data!
              .where((data) => data.nodeType == "Load")
              .toList();

        }else{
          _yearlyAnalysisProFilterDgrDataModel = YearlyAnalysisProFilterDgrDataModel.fromJson(response.body);

          yearlySourceData = _yearlyAnalysisProFilterDgrDataModel.data!
              .where((data) => data.nodeType == "Source")
              .toList();
          yearlyLoadData = _yearlyAnalysisProFilterDgrDataModel.data!
              .where((data) => data.nodeType == "Load")
              .toList();
        }

        update();
        return true;
      }else{
        update();
        return false;
      }

    } catch (e) {

      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching analysis pro day data: $_errorMessage');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
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

 /* Future<void> downloadDataSheet(BuildContext context) async {
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'FilteredData';

        // Get all column headers from your data source
        List<String> headers = ['Date'];
        if (_graphType == "Line-Chart") {
          Set<String> nodeNames = {};
          dailySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
          dailyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          headers.addAll(nodeNames);
        } else {
          Set<String> nodeNames = {};
          if (_graphType == "Monthly-Bar-Chart") {
            monthlySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
            monthlyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          } else {
            yearlySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
            yearlyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          }
          headers.addAll(nodeNames);
        }

        // Apply header styling
        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        // Write headers to the first row
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
          sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
          sheet.getRangeByIndex(1, i + 1, 1, i + 1).columnWidth = i == 0 ? 15 : 12;
        }

        // Process data (same as before)
        List<Map<String, dynamic>> allDataPoints = [];
        if (_graphType == "Line-Chart") {
          Map<String, Map<String, dynamic>> groupedData = {};
          for (var data in dailySourceData) {
            String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(data.timedate!));
            if (!groupedData.containsKey(date)) {
              groupedData[date] = {'Date': date};
            }
            groupedData[date]![data.node ?? ""] = data.power?.toDouble() ?? 0;
          }
          for (var data in dailyLoadData) {
            String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(data.timedate!));
            if (!groupedData.containsKey(date)) {
              groupedData[date] = {'Date': date};
            }
            groupedData[date]![data.node ?? ""] = data.power?.toDouble() ?? 0;
          }
          allDataPoints = groupedData.values.toList();
        } else {
          Map<String, Map<String, dynamic>> groupedData = {};
          void processData(List<dynamic> dataList, String valueField) {
            for (var data in dataList) {
              String date = DateFormat('dd-MM-yyyy').format(DateTime.parse(data.date!));
              if (!groupedData.containsKey(date)) {
                groupedData[date] = {'Date': date};
              }
              groupedData[date]![data.node ?? ""] = (valueField == 'power' ? data.power : data.energy)?.toDouble() ?? 0;
            }
          }

          if (_graphType == "Monthly-Bar-Chart") {
            processData(monthlySourceData, 'energy');
            processData(monthlyLoadData, 'energy');
          } else {
            processData(yearlySourceData, 'energy');
            processData(yearlyLoadData, 'energy');
          }
          allDataPoints = groupedData.values.toList();
        }

        // Sort and write data (same as before)
        allDataPoints.sort((a, b) => b['Date'].compareTo(a['Date']));
        int rowIndex = 2;
        for (var dataPoint in allDataPoints) {
          sheet.getRangeByIndex(rowIndex, 1).setText(dataPoint['Date']);
          for (int i = 1; i < headers.length; i++) {
            String columnName = headers[i];
            double value = dataPoint.containsKey(columnName) ? dataPoint[columnName] : 0;
            sheet.getRangeByIndex(rowIndex, i + 1).setNumber(value);
            sheet.getRangeByIndex(rowIndex, i + 1).numberFormat = '###0.00';
          }
          rowIndex++;
        }

        // File saving logic
        String? filePath;
        String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
        String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
        String reportType = _graphType.replaceAll('-', '_');

        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (await directory.exists()) {
            filePath = "${directory.path}/Power_Data_$reportType/_$formattedDate/_$formattedTime.xlsx";
          } else {
            final fallbackDir = await getApplicationDocumentsDirectory();
            filePath = "${fallbackDir.path}/Power_Data_$reportType/_$formattedDate/_$formattedTime.xlsx";
          }
        } else if (Platform.isIOS) {
          final directory = await getApplicationDocumentsDirectory();
          filePath = "${directory.path}/Power_Data_$reportType/_$formattedDate/_$formattedTime.xlsx";
        }

        if (filePath != null) {
          final List<int> bytes = workbook.saveAsStream();
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(bytes);

          // Show share dialog for iOS
          if (Platform.isIOS) {
            await Share.shareXFiles([XFile(filePath)],
                text: 'Power Data Report',
                subject: 'Power Data Report $formattedDate $formattedTime');
          } else {
            FlutterSmartDownloadDialog.show(
              context: context,
              filePath: filePath,
              dialogType: DialogType.popup,
            );
          }

          log("----------------> File saved at ==> $filePath");
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
      openAppSettings();
      // Get.snackbar(
      //   "Permission Denied",
      //   "Please enable storage permission in app settings",
      //   snackPosition: SnackPosition.BOTTOM,
      //   mainButton: const TextButton(
      //     onPressed: openAppSettings,
      //     child: Text('Settings'),
      //   ),
      // );
    }
  }*/
 /* Future<void> downloadDataSheet(BuildContext context) async {
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'FilteredData';

        bool includeCostData = selectedIndices.contains(0) && selectedIndices.contains(2);

        // Get all column headers from your data source
        List<String> headers = ['Date'];
        List<String> nodeNamesList = [];
        Map<String, double> costPerUnit = {}; // Store cost per node (you can adjust values)

        if (_graphType == "Line-Chart") {
          Set<String> nodeNames = {};
          dailySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
          dailyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          nodeNamesList = nodeNames.toList();
          headers.addAll(nodeNames);
          if (includeCostData) {
            headers.addAll(nodeNames.map((node) => '$node Cost')); // Add cost columns
            // Initialize cost per unit for each node (example values, adjust as needed)
            for (var node in nodeNames) {
              costPerUnit[node] = 0.12; // Example: $0.12 per unit, adjust as needed
            }
          }
        } else {
          Set<String> nodeNames = {};
          if (_graphType == "Monthly-Bar-Chart") {
            monthlySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
            monthlyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          } else {
            yearlySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
            yearlyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          }
          nodeNamesList = nodeNames.toList();
          headers.addAll(nodeNames);
          if (includeCostData) {
            headers.addAll(nodeNames.map((node) => '$node Cost')); // Add cost columns
            // Initialize cost per unit for each node (example values, adjust as needed)
            for (var node in nodeNames) {
              costPerUnit[node] = 0.12; // Example: $0.12 per unit, adjust as needed
            }
          }
        }

        // Apply header styling
        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        // Write headers to the first row
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
          sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
          sheet.getRangeByIndex(1, i + 1, 1, i + 1).columnWidth = i == 0 ? 15 : 12;
        }

        // Process data
        List<Map<String, dynamic>> allDataPoints = [];
        if (_graphType == "Line-Chart") {
          Map<String, Map<String, dynamic>> groupedData = {};
          for (var data in dailySourceData) {
            String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(data.timedate!));
            if (!groupedData.containsKey(date)) {
              groupedData[date] = {'Date': date};
            }
            double power = data.power?.toDouble() ?? 0;
            groupedData[date]![data.node ?? ""] = power;
            if (includeCostData) {
              groupedData[date]!['${data.node} Cost'] = power * (costPerUnit[data.node] ?? 0);
            }
          }
          for (var data in dailyLoadData) {
            String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(data.timedate!));
            if (!groupedData.containsKey(date)) {
              groupedData[date] = {'Date': date};
            }
            double power = data.power?.toDouble() ?? 0;
            groupedData[date]![data.node ?? ""] = power;
            if (includeCostData) {
              groupedData[date]!['${data.node} Cost'] = power * (costPerUnit[data.node] ?? 0);
            }
          }
          allDataPoints = groupedData.values.toList();
        } else {
          Map<String, Map<String, dynamic>> groupedData = {};
          void processData(List<dynamic> dataList, String valueField) {
            for (var data in dataList) {
              String date = DateFormat('dd-MM-yyyy').format(DateTime.parse(data.date!));
              if (!groupedData.containsKey(date)) {
                groupedData[date] = {'Date': date};
              }
              double value = (valueField == 'power' ? data.power : data.energy)?.toDouble() ?? 0;
              groupedData[date]![data.node ?? ""] = value;
              if (includeCostData) {
                groupedData[date]!['${data.node} Cost'] = value * (costPerUnit[data.node] ?? 0);
              }
            }
          }

          if (_graphType == "Monthly-Bar-Chart") {
            processData(monthlySourceData, 'energy');
            processData(monthlyLoadData, 'energy');
          } else {
            processData(yearlySourceData, 'energy');
            processData(yearlyLoadData, 'energy');
          }
          allDataPoints = groupedData.values.toList();
        }

        // Sort and write data
        allDataPoints.sort((a, b) => b['Date'].compareTo(a['Date']));
        int rowIndex = 2;
        for (var dataPoint in allDataPoints) {
          sheet.getRangeByIndex(rowIndex, 1).setText(dataPoint['Date']);
          for (int i = 1; i < headers.length; i++) {
            String columnName = headers[i];
            if (columnName.endsWith(' Cost')) {
              double costValue = dataPoint.containsKey(columnName) ? dataPoint[columnName] : 0;
              sheet.getRangeByIndex(rowIndex, i + 1).setNumber(costValue);
              sheet.getRangeByIndex(rowIndex, i + 1).numberFormat = '\$###0.00';
            } else {
              double value = dataPoint.containsKey(columnName) ? dataPoint[columnName] : 0;
              sheet.getRangeByIndex(rowIndex, i + 1).setNumber(value);
              sheet.getRangeByIndex(rowIndex, i + 1).numberFormat = '###0.00';
            }
          }
          rowIndex++;
        }

        // File saving logic
        String? filePath;
        String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
        String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
        String reportType = _graphType.replaceAll('-', '_');

        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (await directory.exists()) {
            filePath = "${directory.path}/Power_Data_$reportType${includeCostData ? '_WithCost' : ''}_$formattedDate$formattedTime.xlsx";
          } else {
            final fallbackDir = await getApplicationDocumentsDirectory();
            filePath = "${fallbackDir.path}/Power_Data_$reportType${includeCostData ? '_WithCost' : ''}_$formattedDate$formattedTime.xlsx";
          }
        } else if (Platform.isIOS) {
          final directory = await getApplicationDocumentsDirectory();
          filePath = "${directory.path}/Power_Data_$reportType${includeCostData ? '_WithCost' : ''}_$formattedDate$formattedTime.xlsx";
        }

        if (filePath != null) {
          final List<int> bytes = workbook.saveAsStream();
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(bytes);

          // Show share dialog for iOS
          if (Platform.isIOS) {
            await Share.shareXFiles([XFile(filePath)],
                text: 'Power Data Report${includeCostData ? ' with Cost' : ''}',
                subject: 'Power Data Report${includeCostData ? ' with Cost' : ''} $formattedDate $formattedTime');
          } else {
            FlutterSmartDownloadDialog.show(
              context: context,
              filePath: filePath,
              dialogType: DialogType.popup,
            );
          }

          log("----------------> File saved at ==> $filePath");
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
      openAppSettings();
    }
  }*/
 /* Future<void> downloadDataSheet(BuildContext context) async {
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'FilteredData';

        // Determine the download mode based on selectedIndices
        bool includeOnlyCostData = selectedIndices.contains(2) && !selectedIndices.contains(0); // Only cost data
        bool includeBothData = selectedIndices.contains(0) && selectedIndices.contains(2); // Both power/energy and cost
        bool includeOnlyPowerData = selectedIndices.contains(0) && !selectedIndices.contains(2); // Only power/energy

        if (!includeOnlyCostData && !includeBothData && !includeOnlyPowerData) {
          Get.snackbar(
            "Selection Error",
            "Please select at least one valid option to download data.",
            duration: const Duration(seconds: 3),
            backgroundColor: AppColors.redColor,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // Get all column headers from your data source
        List<String> headers = ['Date'];
        List<String> nodeNamesList = [];
        Map<String, double> costPerUnit = {}; // Store cost per node (you can adjust values)

        if (_graphType == "Line-Chart") {
          Set<String> nodeNames = {};
          dailySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
          dailyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          nodeNamesList = nodeNames.toList();
          if (includeOnlyPowerData || includeBothData) {
            headers.addAll(nodeNames); // Add power/energy columns
          }
          if (includeOnlyCostData || includeBothData) {
            headers.addAll(nodeNames.map((node) => '$node Cost')); // Add cost columns
            // Initialize cost per unit for each node (example values, adjust as needed)
            for (var node in nodeNames) {
              costPerUnit[node] = 0.12; // Example: $0.12 per unit, adjust as needed
            }
          }
        } else {
          Set<String> nodeNames = {};
          if (_graphType == "Monthly-Bar-Chart") {
            monthlySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
            monthlyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          } else {
            yearlySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
            yearlyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          }
          nodeNamesList = nodeNames.toList();
          if (includeOnlyPowerData || includeBothData) {
            headers.addAll(nodeNames); // Add power/energy columns
          }
          if (includeOnlyCostData || includeBothData) {
            headers.addAll(nodeNames.map((node) => '$node Cost')); // Add cost columns
            // Initialize cost per unit for each node (example values, adjust as needed)
            for (var node in nodeNames) {
              costPerUnit[node] = 0.12; // Example: $0.12 per unit, adjust as needed
            }
          }
        }

        // Apply header styling
        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        // Write headers to the first row
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
          sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
          sheet.getRangeByIndex(1, i + 1, 1, i + 1).columnWidth = i == 0 ? 15 : 12;
        }

        // Process data
        List<Map<String, dynamic>> allDataPoints = [];
        if (_graphType == "Line-Chart") {
          Map<String, Map<String, dynamic>> groupedData = {};
          for (var data in dailySourceData) {
            String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(data.timedate!));
            if (!groupedData.containsKey(date)) {
              groupedData[date] = {'Date': date};
            }
            double power = data.power?.toDouble() ?? 0;
            if (includeOnlyPowerData || includeBothData) {
              groupedData[date]![data.node ?? ""] = power;
            }
            if (includeOnlyCostData || includeBothData) {
              groupedData[date]!['${data.node} Cost'] = power * (costPerUnit[data.node] ?? 0);
            }
          }
          for (var data in dailyLoadData) {
            String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(data.timedate!));
            if (!groupedData.containsKey(date)) {
              groupedData[date] = {'Date': date};
            }
            double power = data.power?.toDouble() ?? 0;
            if (includeOnlyPowerData || includeBothData) {
              groupedData[date]![data.node ?? ""] = power;
            }
            if (includeOnlyCostData || includeBothData) {
              groupedData[date]!['${data.node} Cost'] = power * (costPerUnit[data.node] ?? 0);
            }
          }
          allDataPoints = groupedData.values.toList();
        } else {
          Map<String, Map<String, dynamic>> groupedData = {};
          void processData(List<dynamic> dataList, String valueField) {
            for (var data in dataList) {
              String date = DateFormat('dd-MM-yyyy').format(DateTime.parse(data.date!));
              if (!groupedData.containsKey(date)) {
                groupedData[date] = {'Date': date};
              }
              double value = (valueField == 'power' ? data.power : data.energy)?.toDouble() ?? 0;
              if (includeOnlyPowerData || includeBothData) {
                groupedData[date]![data.node ?? ""] = value;
              }
              if (includeOnlyCostData || includeBothData) {
                groupedData[date]!['${data.node} Cost'] = value * (costPerUnit[data.node] ?? 0);
              }
            }
          }

          if (_graphType == "Monthly-Bar-Chart") {
            processData(monthlySourceData, 'energy');
            processData(monthlyLoadData, 'energy');
          } else {
            processData(yearlySourceData, 'energy');
            processData(yearlyLoadData, 'energy');
          }
          allDataPoints = groupedData.values.toList();
        }

        // Sort and write data
        allDataPoints.sort((a, b) => b['Date'].compareTo(a['Date']));
        int rowIndex = 2;
        for (var dataPoint in allDataPoints) {
          sheet.getRangeByIndex(rowIndex, 1).setText(dataPoint['Date']);
          for (int i = 1; i < headers.length; i++) {
            String columnName = headers[i];
            if (columnName.endsWith(' Cost')) {
              double costValue = dataPoint.containsKey(columnName) ? dataPoint[columnName] : 0;
              sheet.getRangeByIndex(rowIndex, i + 1).setNumber(costValue);
              sheet.getRangeByIndex(rowIndex, i + 1).numberFormat = '###0.00';
            } else {
              double value = dataPoint.containsKey(columnName) ? dataPoint[columnName] : 0;
              sheet.getRangeByIndex(rowIndex, i + 1).setNumber(value);
              sheet.getRangeByIndex(rowIndex, i + 1).numberFormat = '###0.00';
            }
          }
          rowIndex++;
        }

        // File saving logic
        String? filePath;
        String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
        String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
        String reportType = _graphType.replaceAll('-', '_');

        // Adjust file name based on download type
        String fileSuffix = '';
        if (includeOnlyCostData) {
          fileSuffix = '_CostOnly';
        } else if (includeBothData) {
          fileSuffix = '_WithCost';
        }

        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (await directory.exists()) {
            filePath = "${directory.path}/Power_Data_$reportType$fileSuffix$formattedDate$formattedTime.xlsx";
          } else {
            final fallbackDir = await getApplicationDocumentsDirectory();
            filePath = "${fallbackDir.path}/Power_Data_$reportType$fileSuffix$formattedDate$formattedTime.xlsx";
          }
        } else if (Platform.isIOS) {
          final directory = await getApplicationDocumentsDirectory();
          filePath = "${directory.path}/Power_Data_$reportType$fileSuffix$formattedDate$formattedTime.xlsx";
        }

        if (filePath != null) {
          final List<int> bytes = workbook.saveAsStream();
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(bytes);

          // Show share dialog for iOS
          if (Platform.isIOS) {
            await Share.shareXFiles([XFile(filePath)],
                text: 'Power Data Report${fileSuffix.isNotEmpty ? fileSuffix.replaceFirst('_', ' ') : ''}',
                subject: 'Power Data Report${fileSuffix.isNotEmpty ? fileSuffix.replaceFirst('_', ' ') : ''} $formattedDate $formattedTime');
          } else {
            FlutterSmartDownloadDialog.show(
              context: context,
              filePath: filePath,
              dialogType: DialogType.popup,
            );
          }

          log("----------------> File saved at ==> $filePath");
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
      openAppSettings();
    }
  }*/
  /*Future<void> downloadDataSheet(BuildContext context) async {
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'FilteredData';

        // Determine the download mode based on selectedIndices
        bool includeOnlyCostData = selectedIndices.contains(2) && !selectedIndices.contains(0); // Only cost data
        bool includeBothData = selectedIndices.contains(0) && selectedIndices.contains(2); // Both power/energy and cost
        bool includeOnlyPowerData = selectedIndices.contains(0) && !selectedIndices.contains(2); // Only power/energy

        if (!includeOnlyCostData && !includeBothData && !includeOnlyPowerData) {
          Get.snackbar(
            "Selection Error",
            "Please select at least one valid option to download data.",
            duration: const Duration(seconds: 3),
            backgroundColor: AppColors.redColor,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // Get all column headers from your data source
        List<String> headers = ['Date'];
        List<String> nodeNamesList = [];
        Map<String, double> costPerUnit = {}; // Store cost per node (you can adjust values)

        if (_graphType == "Line-Chart") {
          Set<String> nodeNames = {};
          dailySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
          dailyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          nodeNamesList = nodeNames.toList();
          if (includeOnlyPowerData || includeBothData) {
            headers.addAll(nodeNames.map((node) => '$node Electricity')); // Add power/energy columns with "Electricity"
          }
          if (includeOnlyCostData || includeBothData) {
            headers.addAll(nodeNames.map((node) => '$node Cost')); // Add cost columns
            // Initialize cost per unit for each node (example values, adjust as needed)
            for (var node in nodeNames) {
              costPerUnit[node] = 0.12; // Example: $0.12 per unit, adjust as needed
            }
          }
        } else {
          Set<String> nodeNames = {};
          if (_graphType == "Monthly-Bar-Chart") {
            monthlySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
            monthlyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          } else {
            yearlySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
            yearlyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          }
          nodeNamesList = nodeNames.toList();
          if (includeOnlyPowerData || includeBothData) {
            headers.addAll(nodeNames.map((node) => '$node Electricity')); // Add power/energy columns with "Electricity"
          }
          if (includeOnlyCostData || includeBothData) {
            headers.addAll(nodeNames.map((node) => '$node Cost')); // Add cost columns
            // Initialize cost per unit for each node (example values, adjust as needed)
            for (var node in nodeNames) {
              costPerUnit[node] = 0.12; // Example: $0.12 per unit, adjust as needed
            }
          }
        }

        // Apply header styling
        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        // Write headers to the first row
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
          sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
          sheet.getRangeByIndex(1, i + 1, 1, i + 1).columnWidth = i == 0 ? 15 : 12;
        }

        // Process data
        List<Map<String, dynamic>> allDataPoints = [];
        if (_graphType == "Line-Chart") {
          Map<String, Map<String, dynamic>> groupedData = {};
          for (var data in dailySourceData) {
            String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(data.timedate!));
            if (!groupedData.containsKey(date)) {
              groupedData[date] = {'Date': date};
            }
            double power = data.power?.toDouble() ?? 0;
            if (includeOnlyPowerData || includeBothData) {
              groupedData[date]!['${data.node} Electricity'] = power; // Add "Electricity" to non-cost column
            }
            if (includeOnlyCostData || includeBothData) {
              groupedData[date]!['${data.node} Cost'] = power * (costPerUnit[data.node] ?? 0);
            }
          }
          for (var data in dailyLoadData) {
            String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(data.timedate!));
            if (!groupedData.containsKey(date)) {
              groupedData[date] = {'Date': date};
            }
            double power = data.power?.toDouble() ?? 0;
            if (includeOnlyPowerData || includeBothData) {
              groupedData[date]!['${data.node} Electricity'] = power; // Add "Electricity" to non-cost column
            }
            if (includeOnlyCostData || includeBothData) {
              groupedData[date]!['${data.node} Cost'] = power * (costPerUnit[data.node] ?? 0);
            }
          }
          allDataPoints = groupedData.values.toList();
        } else {
          Map<String, Map<String, dynamic>> groupedData = {};
          void processData(List<dynamic> dataList, String valueField) {
            for (var data in dataList) {
              String date = DateFormat('dd-MM-yyyy').format(DateTime.parse(data.date!));
              if (!groupedData.containsKey(date)) {
                groupedData[date] = {'Date': date};
              }
              double value = (valueField == 'power' ? data.power : data.energy)?.toDouble() ?? 0;
              if (includeOnlyPowerData || includeBothData) {
                groupedData[date]!['${data.node} Electricity'] = value; // Add "Electricity" to non-cost column
              }
              if (includeOnlyCostData || includeBothData) {
                groupedData[date]!['${data.node} Cost'] = value * (costPerUnit[data.node] ?? 0);
              }
            }
          }

          if (_graphType == "Monthly-Bar-Chart") {
            processData(monthlySourceData, 'energy');
            processData(monthlyLoadData, 'energy');
          } else {
            processData(yearlySourceData, 'energy');
            processData(yearlyLoadData, 'energy');
          }
          allDataPoints = groupedData.values.toList();
        }

        // Sort and write data
        allDataPoints.sort((a, b) => b['Date'].compareTo(a['Date']));
        int rowIndex = 2;
        for (var dataPoint in allDataPoints) {
          sheet.getRangeByIndex(rowIndex, 1).setText(dataPoint['Date']);
          for (int i = 1; i < headers.length; i++) {
            String columnName = headers[i];
            if (columnName.endsWith(' Cost')) {
              double costValue = dataPoint.containsKey(columnName) ? dataPoint[columnName] : 0;
              sheet.getRangeByIndex(rowIndex, i + 1).setNumber(costValue);
              sheet.getRangeByIndex(rowIndex, i + 1).numberFormat = '###0.00';
            } else {
              double value = dataPoint.containsKey(columnName) ? dataPoint[columnName] : 0;
              sheet.getRangeByIndex(rowIndex, i + 1).setNumber(value);
              sheet.getRangeByIndex(rowIndex, i + 1).numberFormat = '###0.00';
            }
          }
          rowIndex++;
        }

        // File saving logic
        String? filePath;
        String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
        String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
        String reportType = _graphType.replaceAll('-', '_');

        // Adjust file name based on download type
        String fileSuffix = '';
        if (includeOnlyCostData) {
          fileSuffix = '_CostOnly';
        } else if (includeBothData) {
          fileSuffix = '_WithCost';
        }

        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (await directory.exists()) {
            filePath = "${directory.path}/Power_Data_$reportType$fileSuffix$formattedDate$formattedTime.xlsx";
          } else {
            final fallbackDir = await getApplicationDocumentsDirectory();
            filePath = "${fallbackDir.path}/Power_Data_$reportType$fileSuffix$formattedDate$formattedTime.xlsx";
          }
        } else if (Platform.isIOS) {
          final directory = await getApplicationDocumentsDirectory();
          filePath = "${directory.path}/Power_Data_$reportType$fileSuffix$formattedDate$formattedTime.xlsx";
        }

        if (filePath != null) {
          final List<int> bytes = workbook.saveAsStream();
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(bytes);

          // Show share dialog for iOS
          if (Platform.isIOS) {
            await Share.shareXFiles([XFile(filePath)],
                text: 'Power Data Report${fileSuffix.isNotEmpty ? fileSuffix.replaceFirst('_', ' ') : ''}',
                subject: 'Power Data Report${fileSuffix.isNotEmpty ? fileSuffix.replaceFirst('_', ' ') : ''} $formattedDate $formattedTime');
          } else {
            FlutterSmartDownloadDialog.show(
              context: context,
              filePath: filePath,
              dialogType: DialogType.popup,
            );
          }

          log("----------------> File saved at ==> $filePath");
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
      openAppSettings();
    }
  }*/


  Future<void> downloadDataSheet(BuildContext context) async {
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'FilteredData';

        // Determine the download mode based on selectedIndices
        bool includeOnlyCostData = selectedIndices.contains(2) && !selectedIndices.contains(0); // Only cost data
        bool includeBothData = selectedIndices.contains(0) && selectedIndices.contains(2); // Both power/energy and cost
        bool includeOnlyPowerData = selectedIndices.contains(0) && !selectedIndices.contains(2); // Only power/energy

        if (!includeOnlyCostData && !includeBothData && !includeOnlyPowerData) {
          Get.snackbar(
            "Selection Error",
            "Please select at least one valid option to download data.",
            duration: const Duration(seconds: 3),
            backgroundColor: AppColors.redColor,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // Get all column headers from your data source
        List<String> headers = ['Date'];
        List<String> nodeNamesList = [];
        Map<String, double> costPerUnit = {}; // Not used since we'll use cost directly from JSON

        if (_graphType == "Line-Chart") {
          Set<String> nodeNames = {};
          dailySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
          dailyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          nodeNamesList = nodeNames.toList();
          if (includeOnlyPowerData || includeBothData) {
            headers.addAll(nodeNames.map((node) => '$node Electricity')); // Add power/energy columns with "Electricity"
          }
          if (includeOnlyCostData || includeBothData) {
            headers.addAll(nodeNames.map((node) => '$node Cost')); // Add cost columns
          }
        } else {
          Set<String> nodeNames = {};
          if (_graphType == "Monthly-Bar-Chart") {
            monthlySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
            monthlyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          } else {
            yearlySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
            yearlyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
          }
          nodeNamesList = nodeNames.toList();
          if (includeOnlyPowerData || includeBothData) {
            headers.addAll(nodeNames.map((node) => '$node Electricity')); // Add power/energy columns with "Electricity"
          }
          if (includeOnlyCostData || includeBothData) {
            headers.addAll(nodeNames.map((node) => '$node Cost')); // Add cost columns
          }
        }

        // Apply header styling
        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        // Define a style for data cells (centered alignment)
        final Style dataStyle = workbook.styles.add('DataStyle');
        dataStyle.hAlign = HAlignType.center;

        // Write headers to the first row and set increased column width
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
          sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
          sheet.getRangeByIndex(1, i + 1, 1, i + 1).columnWidth = i == 0 ? 20 : 18; // Increased width: 20 for Date, 18 for others
        }

        // Process data
        List<Map<String, dynamic>> allDataPoints = [];
        if (_graphType == "Line-Chart") {
          Map<String, Map<String, dynamic>> groupedData = {};
          for (var data in dailySourceData) {
            String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(data.timedate!));
            if (!groupedData.containsKey(date)) {
              groupedData[date] = {'Date': date};
            }
            double power = data.power?.toDouble() ?? 0;
            double cost = data.cost?.toDouble() ?? 0; // Use cost directly from JSON (if available in your model)
            if (includeOnlyPowerData || includeBothData) {
              groupedData[date]!['${data.node} Electricity'] = power; // Add "Electricity" to non-cost column
            }
            if (includeOnlyCostData || includeBothData) {
              groupedData[date]!['${data.node} Cost'] = cost; // Use cost directly from JSON
            }
          }
          for (var data in dailyLoadData) {
            String date = DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(data.timedate!));
            if (!groupedData.containsKey(date)) {
              groupedData[date] = {'Date': date};
            }
            double power = data.power?.toDouble() ?? 0;
            double cost = data.cost?.toDouble() ?? 0; // Use cost directly from JSON (if available in your model)
            if (includeOnlyPowerData || includeBothData) {
              groupedData[date]!['${data.node} Electricity'] = power; // Add "Electricity" to non-cost column
            }
            if (includeOnlyCostData || includeBothData) {
              groupedData[date]!['${data.node} Cost'] = cost; // Use cost directly from JSON
            }
          }
          allDataPoints = groupedData.values.toList();
        } else {
          Map<String, Map<String, dynamic>> groupedData = {};
          void processData(List<dynamic> dataList, String valueField) {
            for (var data in dataList) {
              String date = DateFormat('dd-MM-yyyy').format(DateTime.parse(data.date!));
              if (!groupedData.containsKey(date)) {
                groupedData[date] = {'Date': date};
              }
              double value = (valueField == 'power' ? data.power : data.energy)?.toDouble() ?? 0;
              double cost = data.cost?.toDouble() ?? 0; // Use cost directly from JSON
              if (includeOnlyPowerData || includeBothData) {
                groupedData[date]!['${data.node} Electricity'] = value; // Add "Electricity" to non-cost column
              }
              if (includeOnlyCostData || includeBothData) {
                groupedData[date]!['${data.node} Cost'] = cost; // Use cost directly from JSON
              }
            }
          }

          if (_graphType == "Monthly-Bar-Chart") {
            processData(monthlySourceData, 'energy');
            processData(monthlyLoadData, 'energy');
          } else {
            processData(yearlySourceData, 'energy');
            processData(yearlyLoadData, 'energy');
          }
          allDataPoints = groupedData.values.toList();
        }


        allDataPoints.sort((a, b) => b['Date'].compareTo(a['Date']));
        int rowIndex = 2;
        for (var dataPoint in allDataPoints) {
          // Write date in first column
          sheet.getRangeByIndex(rowIndex, 1).setText(dataPoint['Date']);
          sheet.getRangeByIndex(rowIndex, 1).cellStyle = dataStyle; // Center-align date

          // Write values for each column where data exists
          for (int i = 1; i < headers.length; i++) {
            String columnName = headers[i];
            if (columnName.endsWith(' Cost')) {
              double costValue = dataPoint.containsKey(columnName) ? dataPoint[columnName] : 0;
              sheet.getRangeByIndex(rowIndex, i + 1).setNumber(costValue);
              sheet.getRangeByIndex(rowIndex, i + 1).numberFormat = '0.00'; // Format with 2 decimal places
              sheet.getRangeByIndex(rowIndex, i + 1).cellStyle = dataStyle; // Center-align cost value
            } else {
              double value = dataPoint.containsKey(columnName) ? dataPoint[columnName] : 0;
              sheet.getRangeByIndex(rowIndex, i + 1).setNumber(value);
              sheet.getRangeByIndex(rowIndex, i + 1).numberFormat = '0.00'; // Format with 2 decimal places
              sheet.getRangeByIndex(rowIndex, i + 1).cellStyle = dataStyle; // Center-align power/energy value
            }
          }
          rowIndex++;
        }

        // File saving logic
        String? filePath;
        String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
        String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
        String reportType = _graphType.replaceAll('-', '_');

        // Adjust file name based on download type
        String fileSuffix = '';
        if (includeOnlyCostData) {
          fileSuffix = '_CostOnly';
        } else if (includeBothData) {
          fileSuffix = '_WithCost';
        }

        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (await directory.exists()) {
            filePath = "${directory.path}/Power_Data_$reportType$fileSuffix$formattedDate$formattedTime.xlsx";
          } else {
            final fallbackDir = await getApplicationDocumentsDirectory();
            filePath = "${fallbackDir.path}/Power_Data_$reportType$fileSuffix$formattedDate$formattedTime.xlsx";
          }
        } else if (Platform.isIOS) {
          final directory = await getApplicationDocumentsDirectory();
          filePath = "${directory.path}/Power_Data_$reportType$fileSuffix$formattedDate$formattedTime.xlsx";
        }

        if (filePath != null) {
          final List<int> bytes = workbook.saveAsStream();
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(bytes);

          // Show share dialog for iOS
          if (Platform.isIOS) {
            await Share.shareXFiles([XFile(filePath)],
                text: 'Power Data Report${fileSuffix.isNotEmpty ? fileSuffix.replaceFirst('_', ' ') : ''}',
                subject: 'Power Data Report${fileSuffix.isNotEmpty ? fileSuffix.replaceFirst('_', ' ') : ''} $formattedDate $formattedTime');
          } else {
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
          }

          log("----------------> File saved at ==> $filePath");
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
        backgroundColor: AppColors.redColor,
        colorText: Colors.white,
      );
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

    _dateDifference = toDate.difference(fromDate).inDays;
    update();
  }


  void clearFilterIngDate(){
    String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    _fromDateTEController.text = todayDate;
    _toDateTEController.text = todayDate;
    _dateDifference = 0;
    update();
  }

}