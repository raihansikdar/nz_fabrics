import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/electricity_analysis_pro_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/only_month_analysis_pro_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ElectricityMonthAnalysisProController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isMonthElectricityAnalysisProInProgress = false;
  String _errorMessage = '';
  List<ElectricityAnalysisProModel> _electricityMonthAnalysisProSourceList = <ElectricityAnalysisProModel>[];
  List<ElectricityAnalysisProModel> _electricityMonthAnalysisProLoadList = <ElectricityAnalysisProModel>[];

  bool get isConnected => _isConnected;
  bool get isMonthElectricityAnalysisProInProgress => _isMonthElectricityAnalysisProInProgress;
  String get errorMessage => _errorMessage;

  List<ElectricityAnalysisProModel> get electricityMonthAnalysisProSourceList => _electricityMonthAnalysisProSourceList;
  List<ElectricityAnalysisProModel> get electricityMonthAnalysisProLoadList => _electricityMonthAnalysisProLoadList;

  Set<String> itemsList = {};
  Set<String> removeList = {};





  Future<bool> fetchMonthlyElectricityAnalysisPro() async {


    _isMonthElectricityAnalysisProInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.nodeNameElectricityAnalysisProUrl);

      log("nodeNameElectricityAnalysisProUrl statusCode ==> ${response.statusCode}");
      // log("dayElectricityAnalysisProUrl body ==> ${response.body}");

      _isMonthElectricityAnalysisProInProgress = false;

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
          _electricityMonthAnalysisProSourceList = jsonData.where((data)=> data['source_type'] == "Source").map((json)=> ElectricityAnalysisProModel.fromJson(json)).toList();
          _electricityMonthAnalysisProLoadList = jsonData.where((data)=> data['source_type'] == "Load").map((json)=> ElectricityAnalysisProModel.fromJson(json)).toList();

          initializeItems();
        update();
        final currentMonth = DateTime.now().month;
        final currentYear= DateTime.now().year;

        await fetchSelectedMonthDGRData(
          selectedMonth: currentMonth.toString(),
          selectedYear: currentYear.toString(),
          nodes: itemsList.toList(),
        );

        update();
        return true;

      } else {
        _errorMessage = "Failed to fetch electricity month analysis pro.";
        update();
        return false;
      }
    } catch (e) {
      _isMonthElectricityAnalysisProInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching electricity month analysis pro : $_errorMessage');
      _errorMessage = "Failed to fetch electricity month analysis pro.";

      return false;
    }
  }


  // // UI methods
  // int selectedButton = 1;
  // void updateSelectedButton({required int value}) {
  //   selectedButton = value;
  //   log("selectedButton: $selectedButton");
  //   update();
  // }

  Set<int> selectedIndices = {};
  void toggleSelection(int index, bool selected) {
    if (selected) {
      selectedIndices.add(index);
    //  log(" ==> day selectedIndices <== $selectedIndices");
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
        //log("==BeforeADD==>>+++$itemsList");

        if (!itemsList.contains(node)) {
          itemsList.add(node);
          // Ensure checkboxGroupStates reflects this
          int index = electricityMonthAnalysisProSourceList.indexWhere((item) => item.nodeName == node);
          if (index != -1) {
            checkboxGroupStates[key]?[index] = true;
          }
        }

        removeList.removeWhere((element) => element == node);
      //  log("==AfterADD==>>+++$itemsList");
      }
    } else {
      selectedGridItemsMapString[key]!.remove(node);
     // log("====>>BeforeRemove removeList +++$removeList");

      removeList.add(node);
      itemsList.remove(node);

      // Update checkboxGroupStates
      int index = electricityMonthAnalysisProLoadList.indexWhere((item) => item.nodeName == node);
      if (index != -1) {
        checkboxGroupStates[key]?[index] = false;
      }

    //  log("====>>AfterRemove removeList+++$removeList");
    }

  //  log("====>>Stay in Set +++$itemsList");
    update();
  }

  void initializeItems() {

    if (electricityMonthAnalysisProSourceList.isNotEmpty) {
      final firstNode = electricityMonthAnalysisProSourceList.first.nodeName;
      if (!itemsList.contains(firstNode)) {
        itemsList.add(firstNode ?? '');
        updateSelectedGridItems('Source',firstNode ?? '',true);

        checkboxGroupStates['source']?[0] = true;

       // log("==first time itemList==>>+++$itemsList");
        update();
      }
    }


    if (electricityMonthAnalysisProLoadList.isNotEmpty) {
      final firstNode = electricityMonthAnalysisProLoadList.first.nodeName;
      if (!itemsList.contains(firstNode)) {
        itemsList.add(firstNode ?? '');
        updateSelectedGridItems('Load',firstNode ?? '',true);

        checkboxGroupStates['load']?[0] = true;

      ///  log("==first time itemList Load ==>>+++$itemsList");
        update();
      }
    }
  }

  void toggleGroup(String group, bool isSelected) {
    checkboxGroupStates[group] = (checkboxGroupStates[group] ?? List.filled(1000, false)).map((_) => isSelected).toList();
    update();
  }

  OnlyMonthAnalysisProModel _onlyMonthAnalysisProFilterDgrDataModel = OnlyMonthAnalysisProModel();
  OnlyMonthAnalysisProModel get onlyMonthAnalysisProFilterDgrDataModel => _onlyMonthAnalysisProFilterDgrDataModel;


  List<OnlyMonthDgrData> onlyMonthlySourceData = [];
  List<OnlyMonthDgrData> onlyMonthlyLoadData = [];



  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  void selectedMonthMethod(int value){
    selectedMonth = value;
    update();
  }

  void selectedYearMethod(int value){
    selectedYear = value;
    update();
  }

  bool isSelectedMonthInProgress = false;

  Future<bool> fetchSelectedMonthDGRData({required String selectedMonth, required String selectedYear, required List<String>nodes,bool fromButton = false }) async {

    Map<String, dynamic> requestBody = {
      "month": selectedMonth,
      "year": selectedYear,
      "nodes": nodes,
    };

    log("Request DGR month Date: $selectedMonth $selectedYear");
    log("Request DGR month Date: $requestBody");
    try {
      await internetConnectivityCheck();

      isSelectedMonthInProgress = fromButton;
      update();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.getMonthlyAnalysisProUrl,
        body: requestBody,
      );

     //   log("getMonthlyAnalysisProUrl statusCode ==> ${response.statusCode}");
     //  log("getMonthlyAnalysisProUrl body ==> ${response.body}");

      isSelectedMonthInProgress = false;
      update();

      if (response.isSuccess) {

          _onlyMonthAnalysisProFilterDgrDataModel = OnlyMonthAnalysisProModel.fromJson(response.body);

          onlyMonthlySourceData = _onlyMonthAnalysisProFilterDgrDataModel.dgrData!
              .where((data) => data.nodeType == "Source")
              .toList();
          onlyMonthlyLoadData = _onlyMonthAnalysisProFilterDgrDataModel.dgrData!
              .where((data) => data.nodeType == "Load")
              .toList();

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
      log('Error in fetching analysis pro month data: $_errorMessage');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
    finally{
      update();
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
  Future<void> downloadDataSheet(BuildContext context) async {
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'MonthlyFilteredData';

        // Determine the download mode based on selectedIndices
        bool includeOnlyCostData = selectedIndices.contains(2) && !selectedIndices.contains(0); // Only cost data
        bool includeBothData = selectedIndices.contains(0) && selectedIndices.contains(2); // Both power/energy and cost
        bool includeOnlyPowerData = selectedIndices.contains(0) && !selectedIndices.contains(2); // Only power/energy

        if (!includeOnlyCostData && !includeBothData && !includeOnlyPowerData) {
          Get.snackbar(
            "Selection Error",
            "Please select at least one valid option to download data.",
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // Get all column headers from your data source
        List<String> headers = ['Date'];
        List<String> nodeNamesList = [];
        Map<String, double> costPerUnit = {}; // Not used for direct cost from JSON

        // Collect unique node names from source and load data
        Set<String> nodeNames = {};
        onlyMonthlySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
        onlyMonthlyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
        nodeNamesList = nodeNames.toList();

        if (includeOnlyPowerData || includeBothData) {
          headers.addAll(nodeNames.map((node) => '$node Electricity')); // Add power/energy columns with "Electricity"
        }
        if (includeOnlyCostData || includeBothData) {
          headers.addAll(nodeNames.map((node) => '$node Cost')); // Add cost columns
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
        Map<String, Map<String, dynamic>> groupedData = {};

        // Process Source Data
        for (var data in onlyMonthlySourceData) {
          String date = DateFormat('dd-MM-yyyy').format(DateTime.parse(data.date!));
          if (!groupedData.containsKey(date)) {
            groupedData[date] = {'Date': date};
          }
          double energy = data.energy?.toDouble() ?? 0;
          double cost = data.cost?.toDouble() ?? 0; // Use the cost directly from JSON
          if (includeOnlyPowerData || includeBothData) {
            groupedData[date]!['${data.node} Electricity'] = energy; // Add "Electricity" to non-cost column
          }
          if (includeOnlyCostData || includeBothData) {
            groupedData[date]!['${data.node} Cost'] = cost; // Use the cost directly from JSON
          }
        }

        // Process Load Data
        for (var data in onlyMonthlyLoadData) {
          String date = DateFormat('dd-MM-yyyy').format(DateTime.parse(data.date!));
          if (!groupedData.containsKey(date)) {
            groupedData[date] = {'Date': date};
          }
          double energy = data.energy?.toDouble() ?? 0;
          double cost = data.cost?.toDouble() ?? 0; // Use the cost directly from JSON
          if (includeOnlyPowerData || includeBothData) {
            groupedData[date]!['${data.node} Electricity'] = energy; // Add "Electricity" to non-cost column
          }
          if (includeOnlyCostData || includeBothData) {
            groupedData[date]!['${data.node} Cost'] = cost; // Use the cost directly from JSON
          }
        }

        allDataPoints = groupedData.values.toList();


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
              sheet.getRangeByIndex(rowIndex, i + 1).numberFormat = '0.00'; // Format cost with 2 decimal places
              sheet.getRangeByIndex(rowIndex, i + 1).cellStyle = dataStyle; // Center-align cost value
            } else {
              double value = dataPoint.containsKey(columnName) ? dataPoint[columnName] : 0;
              sheet.getRangeByIndex(rowIndex, i + 1).setNumber(value);
              sheet.getRangeByIndex(rowIndex, i + 1).numberFormat = '0.00'; // Format energy with 2 decimal places
              sheet.getRangeByIndex(rowIndex, i + 1).cellStyle = dataStyle; // Center-align power/energy value
            }
          }
          rowIndex++;
        }

        // File saving logic
        String? filePath;
        String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
        String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
        String reportType = 'MonthlyAnalysisPro';

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
                text: 'Monthly Power Data Report${fileSuffix.isNotEmpty ? fileSuffix.replaceFirst('_', ' ') : ''}',
                subject: 'Monthly Power Data Report${fileSuffix.isNotEmpty ? fileSuffix.replaceFirst('_', ' ') : ''} $formattedDate $formattedTime');
          } else {
            Get.snackbar(
              "Success",
              "File downloaded successfully",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
            );
            // Uncomment and use this if you have FlutterSmartDownloadDialog
            FlutterSmartDownloadDialog.show(
              context: context,
              filePath: filePath,
              dialogType: DialogType.popup,
            );
          }

          log("----------------> Monthly File saved at ==> $filePath");
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
          backgroundColor: Colors.red,
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
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (storageStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }


}