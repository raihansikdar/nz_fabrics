import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/electricity_analysis_pro_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/only_year_analysis_pro_model.dart';
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

class ElectricityYearAnalysisProController extends GetxController with InternetConnectivityCheckMixin {

  bool _isConnected = true;
  bool _isYearElectricityAnalysisProInProgress = false;
  String _errorMessage = '';
  List<ElectricityAnalysisProModel> _electricityYearlyAnalysisProSourceList = <ElectricityAnalysisProModel>[];
  List<ElectricityAnalysisProModel> _electricityYearlyAnalysisProLoadList = <ElectricityAnalysisProModel>[];

  bool get isConnected => _isConnected;
  bool get isYearElectricityAnalysisProInProgress => _isYearElectricityAnalysisProInProgress;
  String get errorMessage => _errorMessage;

  List<ElectricityAnalysisProModel> get electricityYearlyAnalysisProSourceList => _electricityYearlyAnalysisProSourceList;
  List<ElectricityAnalysisProModel> get electricityYearlyAnalysisProLoadList => _electricityYearlyAnalysisProLoadList;

  Set<String> itemsList = {};
  Set<String> removeList = {};


  Future<bool> fetchYearlyElectricityAnalysisPro() async {

    _isYearElectricityAnalysisProInProgress = true;
    update();

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.nodeNameElectricityAnalysisProUrl);

      log("nodeNameElectricityAnalysisProUrl statusCode ==> ${response.statusCode}");
      // log("dayElectricityAnalysisProUrl body ==> ${response.body}");

      _isYearElectricityAnalysisProInProgress = false;

      if (response.isSuccess) {
        final jsonData = (response.body as List<dynamic>);
        _electricityYearlyAnalysisProSourceList = jsonData.where((data)=> data['source_type'] == "Source").map((json)=> ElectricityAnalysisProModel.fromJson(json)).toList();
        _electricityYearlyAnalysisProLoadList = jsonData.where((data)=> data['source_type'] == "Load").map((json)=> ElectricityAnalysisProModel.fromJson(json)).toList();

        initializeItems();
        update();

        final currentYear= DateTime.now().year;

        await fetchSelectedYearDGRData(
          selectedYear: currentYear.toString(),
          nodes: itemsList.toList(),
        );

        update();
        return true;

      } else {
        _errorMessage = "Failed to fetch electricity year analysis pro.";
        update();
        return false;
      }
    } catch (e) {
      _isYearElectricityAnalysisProInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetching electricity year analysis pro : $_errorMessage');
      _errorMessage = "Failed to fetch electricity year analysis pro.";

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
      log(" ==> day selectedIndices <== $selectedIndices");
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
      selectedGridItemsMapString[key] = [];
    }

    if (isSelected) {
      if (!selectedGridItemsMapString[key]!.contains(node)) {
        selectedGridItemsMapString[key]!.add(node);
        log("==BeforeADD==>>+++$itemsList");

        if (!itemsList.contains(node)) {
          itemsList.add(node);
          // Ensure checkboxGroupStates reflects this
          int index = _electricityYearlyAnalysisProSourceList.indexWhere((item) => item.nodeName == node);
          if (index != -1) {
            checkboxGroupStates[key]?[index] = true;
          }
        }

        removeList.removeWhere((element) => element == node);
        log("==AfterADD==>>+++$itemsList");
      }
    } else {
      selectedGridItemsMapString[key]!.remove(node);
      log("====>>BeforeRemove removeList +++$removeList");

      removeList.add(node);
      itemsList.remove(node);

      // Update checkboxGroupStates
      int index = _electricityYearlyAnalysisProLoadList.indexWhere((item) => item.nodeName == node);
      if (index != -1) {
        checkboxGroupStates[key]?[index] = false;
      }

      log("====>>AfterRemove removeList+++$removeList");
    }

    log("====>>Stay in Set +++$itemsList");
    update();
  }

  void initializeItems() {

    if (_electricityYearlyAnalysisProSourceList.isNotEmpty) {
      final firstNode = _electricityYearlyAnalysisProSourceList.first.nodeName;
      if (!itemsList.contains(firstNode)) {
        itemsList.add(firstNode ?? '');
        updateSelectedGridItems('Source',firstNode ?? '',true);

        checkboxGroupStates['source']?[0] = true;

        log("==first time itemList==>>+++$itemsList");
        update();
      }
    }


    if (_electricityYearlyAnalysisProLoadList.isNotEmpty) {
      final firstNode = _electricityYearlyAnalysisProLoadList.first.nodeName;
      if (!itemsList.contains(firstNode)) {
        itemsList.add(firstNode ?? '');
        updateSelectedGridItems('Load',firstNode ?? '',true);

        checkboxGroupStates['load']?[0] = true;

        log("==first time itemList Load ==>>+++$itemsList");
        update();
      }
    }
  }

  void toggleGroup(String group, bool isSelected) {
    checkboxGroupStates[group] = (checkboxGroupStates[group] ?? List.filled(1000, false)).map((_) => isSelected).toList();
    update();
  }

  OnlyYearAnalysisProModel _onlyYearlyAnalysisProFilterDgrDataModel = OnlyYearAnalysisProModel();
  OnlyYearAnalysisProModel get onlyYearlyAnalysisProFilterDgrDataModel => _onlyYearlyAnalysisProFilterDgrDataModel;


  List<OnlyYearlyDgrData> onlyYearlySourceData = [];
  List<OnlyYearlyDgrData> onlyYearlyLoadData = [];



  int selectedYear = DateTime.now().year;

  void selectedYearMethod(int value){
    selectedYear = value;
    update();
  }

  bool isSelectedYearInProgress = false;

  Future<bool> fetchSelectedYearDGRData({required String selectedYear, required List<String>nodes,bool fromButton = false }) async {

    Map<String, dynamic> requestBody = {
      "year": selectedYear,
      "nodes": nodes,
    };

    log("Request DGR year Date: $selectedYear");
    log("Request DGR year body: $requestBody");
    try {
      await internetConnectivityCheck();

      isSelectedYearInProgress = fromButton;
      update();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.getYearlyAnalysisProUrl,
        body: requestBody,
      );

    // log("getYearlyAnalysisProUrl statusCode ==> ${response.statusCode}");
    // log("getYearlyAnalysisProUrl body ==> ${response.body}");

      isSelectedYearInProgress = false;
      update();

      if (response.isSuccess) {

        _onlyYearlyAnalysisProFilterDgrDataModel = OnlyYearAnalysisProModel.fromJson(response.body);

        onlyYearlySourceData = _onlyYearlyAnalysisProFilterDgrDataModel.dgrData!
            .where((data) => data.nodeType == "Source")
            .toList();
        onlyYearlyLoadData = _onlyYearlyAnalysisProFilterDgrDataModel.dgrData!
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
      log('Error in fetching analysis pro year data: $_errorMessage');
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

  Future<void> downloadYearlyDataSheet(BuildContext context) async {
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'YearlyFilteredData';

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
        List<String> headers = ['Month/Year']; // Updated header to reflect Month/Year format
        List<String> nodeNamesList = [];
        Map<String, double> costPerUnit = {}; // Not used for direct cost from JSON

        // Collect unique node names from source and load data
        Set<String> nodeNames = {};
        onlyYearlySourceData.forEach((item) => nodeNames.add(item.node ?? ""));
        onlyYearlyLoadData.forEach((item) => nodeNames.add(item.node ?? ""));
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
          sheet.getRangeByIndex(1, i + 1, 1, i + 1).columnWidth = i == 0 ? 20 : 18; // Increased width: 20 for Month/Year, 18 for others
        }

        // Process data
        List<Map<String, dynamic>> allDataPoints = [];
        Map<String, Map<String, dynamic>> groupedData = {};

        // Process Source Data
        for (var data in onlyYearlySourceData) {
          String monthYear = 'Unknown';
          if (data.date != null) {
            try {
              // Parse the date and extract the month and year
              DateTime parsedDate = DateTime.parse(data.date!);
              String monthName = DateFormat('MMMM').format(parsedDate); // e.g., "January"
              String year = parsedDate.year.toString(); // e.g., "2024"
              monthYear = '$monthName/$year'; // e.g., "January/2024"
            } catch (e) {
              log("Error parsing date for source data: ${data.date}, error: $e");
            }
          }

          if (!groupedData.containsKey(monthYear)) {
            groupedData[monthYear] = {'Month/Year': monthYear};
          }
          double energy = (data.energy != null) ? (data.energy is num ? (data.energy as num).toDouble() : 0) : 0;
          double cost = (data.cost != null) ? (data.cost is num ? (data.cost as num).toDouble() : 0) : 0;
          if (includeOnlyPowerData || includeBothData) {
            groupedData[monthYear]!['${data.node} Electricity'] = energy; // Add "Electricity" to non-cost column
          }
          if (includeOnlyCostData || includeBothData) {
            groupedData[monthYear]!['${data.node} Cost'] = cost; // Use the cost directly from JSON
          }
        }

        // Process Load Data
        for (var data in onlyYearlyLoadData) {
          String monthYear = 'Unknown';
          if (data.date != null) {
            try {
              // Parse the date and extract the month and year
              DateTime parsedDate = DateTime.parse(data.date!);
              String monthName = DateFormat('MMMM').format(parsedDate); // e.g., "January"
              String year = parsedDate.year.toString(); // e.g., "2024"
              monthYear = '$monthName/$year'; // e.g., "January/2024"
            } catch (e) {
              log("Error parsing date for load data: ${data.date}, error: $e");
            }
          }

          if (!groupedData.containsKey(monthYear)) {
            groupedData[monthYear] = {'Month/Year': monthYear};
          }
          double energy = (data.energy != null) ? (data.energy is num ? (data.energy as num).toDouble() : 0) : 0;
          double cost = (data.cost != null) ? (data.cost is num ? (data.cost as num).toDouble() : 0) : 0;
          if (includeOnlyPowerData || includeBothData) {
            groupedData[monthYear]!['${data.node} Electricity'] = energy; // Add "Electricity" to non-cost column
          }
          if (includeOnlyCostData || includeBothData) {
            groupedData[monthYear]!['${data.node} Cost'] = cost; // Use the cost directly from JSON
          }
        }

        allDataPoints = groupedData.values.toList();

        // Sort by year and then by month
        allDataPoints.sort((a, b) {
          // Extract year and month from the "Month/Year" string
          List<String> partsA = a['Month/Year'].split('/');
          List<String> partsB = b['Month/Year'].split('/');

          // Handle cases where split fails (e.g., "Unknown")
          if (partsA.length != 2 || partsB.length != 2) {
            return a['Month/Year'].compareTo(b['Month/Year']);
          }

          String monthA = partsA[0];
          String yearA = partsA[1];
          String monthB = partsB[0];
          String yearB = partsB[1];

          // Compare years first
          int yearComparison = yearA.compareTo(yearB);
          if (yearComparison != 0) {
            return yearComparison; // Sort by year if years are different
          }

          // If years are the same, sort by month
          List<String> monthOrder = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
          ];
          return monthOrder.indexOf(monthA).compareTo(monthOrder.indexOf(monthB));
        });

        int rowIndex = 2;
        for (var dataPoint in allDataPoints) {
          // Write month/year in first column
          sheet.getRangeByIndex(rowIndex, 1).setText(dataPoint['Month/Year']);
          sheet.getRangeByIndex(rowIndex, 1).cellStyle = dataStyle; // Center-align month/year

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
        String reportType = 'YearlyAnalysisPro';

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
                text: 'Yearly Power Data Report${fileSuffix.isNotEmpty ? fileSuffix.replaceFirst('_', ' ') : ''}',
                subject: 'Yearly Power Data Report${fileSuffix.isNotEmpty ? fileSuffix.replaceFirst('_', ' ') : ''} $formattedDate $formattedTime');
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

          log("----------------> Yearly File saved at ==> $filePath");
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