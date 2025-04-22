import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/monthly_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AnalysisProMonthlyButtonController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isMonthProgress = false;
  String _errorMessage = '';
  List<DgrDataModel> _dgrMonthDataSourceList = <DgrDataModel>[];
  List<DgrDataModel> _dgrMonthDataLoadList = <DgrDataModel>[];

  List<WaterDataModel> _waterMonthDataSourceList = <WaterDataModel>[];
  List<WaterDataModel> _waterMonthDataLoadList = <WaterDataModel>[];

  List<NaturalGasDataModel> _naturalGasMonthDataSourceList = <NaturalGasDataModel>[];
  List<NaturalGasDataModel> _naturalGasMonthDataLoadList = <NaturalGasDataModel>[];

  bool get isConnected => _isConnected;
  bool get isMonthProgress => _isMonthProgress;
  String get errorMessage => _errorMessage;
  List<DgrDataModel> get dgrMonthDataSourceList => _dgrMonthDataSourceList;
  List<DgrDataModel> get dgrMonthDataLoadList => _dgrMonthDataLoadList;

  List<WaterDataModel> get waterMonthDataSourceList => _waterMonthDataSourceList;
  List<WaterDataModel> get waterMonthDataLoadList => _waterMonthDataLoadList;

  List<NaturalGasDataModel> get naturalGasMonthDataSourceList => _naturalGasMonthDataSourceList;
  List<NaturalGasDataModel> get naturalGasMonthDataLoadList => _naturalGasMonthDataLoadList;

  List<dynamic> _monthDataList = <dynamic>[];
  List<dynamic> get monthDataList => _monthDataList;

  var allSourceItems = <DgrDataModel>[];
  var allLoadItems = <DgrDataModel>[];

  var allWaterSourceItems = <WaterDataModel>[];
  var allWaterLoadItems = <WaterDataModel>[];

  var allNaturalGasSourceItems = <NaturalGasDataModel>[];
  var allNaturalGasLoadItems = <NaturalGasDataModel>[];
  Set<String> itemsList = {};
  Set<String> removeList = {};


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


  Future<bool> fetchMonthDGRData({required String selectedMonth, required String selectedYear}) async {

    _isMonthProgress = true;
    update();


    Map<String, String> requestBody = {
      "month": selectedMonth,
      "year": selectedYear,
    };

    log("Request DGR month Date: $selectedMonth $selectedYear");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: "Urls.getMonthUrl",
        body: requestBody,
      );

      // log("MonthPostRequestBottomSheet statusCode ==> ${response.statusCode}");
      // log("MonthPostRequestBottomSheet body ==> ${response.body}");

      _isMonthProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = response.body;

        if (jsonData is Map<String, dynamic>) {
          bool hasData = false;

          MonthlyModel monthlyModel = MonthlyModel.fromJson(jsonData);
          _monthDataList = [monthlyModel];


          // Process DGR Data
          if (jsonData.containsKey('dgr_data')) {
            final dataList = jsonData['dgr_data'];

            if (dataList is List) {
              var sourceSeenItems = <String>{};
              var loadSeenItems = <String>{};

              _dgrMonthDataSourceList = dataList.where((item) =>
              (item['category'] != 'Electricity' && item['node_type'] == 'Bus_Bar') || item['category'] != 'Electricity')
                  .map((item) => DgrDataModel.fromJson(item as Map<String, dynamic>)).where((data) => sourceSeenItems.add(data.node!)).toList();

              itemsList.addAll(sourceSeenItems);

              _dgrMonthDataLoadList = dataList.where((item) =>
              item['category'] == 'Electricity' && item['node_type'] == 'Load')
                  .map((item) => DgrDataModel.fromJson(item as Map<String, dynamic>)).where((data) => loadSeenItems.add(data.node!)).toList();


              itemsList.addAll(loadSeenItems);

              // if(_dgrDayDataSourceList.isNotEmpty){
              //   selectedGridItemsMapString['Source'] = _dgrDayDataSourceList.map((data) => data.node!).toList();
              // }
              //
              // if(_dgrDayDataLoadList.isNotEmpty){
              //   selectedGridItemsMapString['Load'] = _dgrDayDataLoadList.map((data) => data.node!).toList();
              // }


              hasData = true;

            } else {
              log('Error: DGR Data is not a list.');
            }
          }

          // Process Water Data
          if (jsonData.containsKey('water_data')) {
            final dataList = jsonData['water_data'];

            if (dataList is List) {
              var sourceSeenItems = <String>{};
              var loadSeenItems = <String>{};
              _waterMonthDataSourceList = dataList.where((item) =>
              (item['node_type'] == 'Source' && item['category'] == 'Water'))
                  .map((item) => WaterDataModel.fromJson(item as Map<String, dynamic>)).where((data) => sourceSeenItems.add(data.node!)).toList();

              itemsList.addAll(sourceSeenItems);


              _waterMonthDataLoadList = dataList.where((item) =>
              (item['node_type'] == 'Load' && item['category'] == 'Water'))
                  .map((item) => WaterDataModel.fromJson(item as Map<String, dynamic>)).where((data) => loadSeenItems.add(data.node!)).toList();

              itemsList.addAll(loadSeenItems);

              if(_waterMonthDataSourceList.isNotEmpty){
                selectedGridItemsMapString['Water Source'] = _waterMonthDataSourceList.map((data) => data.node!).toList();
              }

              if(_waterMonthDataLoadList.isNotEmpty){
                selectedGridItemsMapString['Water Load'] = _waterMonthDataLoadList.map((data) => data.node!).toList();
              }

              hasData = true;
            } else {
              log('Error: Water Data is not a list.');
            }
          }

          // Process Gas Data
          if (jsonData.containsKey('gas_data')) {
            final dataList = jsonData['gas_data'];

            if (dataList is List) {
              var sourceSeenItems = <String>{};
              var loadSeenItems = <String>{};

              _naturalGasMonthDataSourceList = dataList.where((item) =>
              (item['node_type'] == 'Source' && item['category'] == 'Natural_Gas'))
                  .map((item) =>
                  NaturalGasDataModel.fromJson(item as Map<String, dynamic>))
                  .where((data) => sourceSeenItems.add(data.node!)).toList();


              itemsList.addAll(sourceSeenItems);

              _naturalGasMonthDataLoadList = dataList.where((item) =>
              (item['node_type'] == 'Load' && item['category'] == 'Natural_Gas'))
                  .map((item) =>
                  NaturalGasDataModel.fromJson(item as Map<String, dynamic>))
                  .where((data) => loadSeenItems.add(data.node!)).toList();

              itemsList.addAll(loadSeenItems);


              if(_naturalGasMonthDataSourceList.isNotEmpty){
                selectedGridItemsMapString['Natural Gas Source'] = _naturalGasMonthDataSourceList.map((data) => data.node!).toList();
              }

              if(_naturalGasMonthDataLoadList.isNotEmpty){
                selectedGridItemsMapString['Natural Gas Load'] = _naturalGasMonthDataLoadList.map((data) => data.node!).toList();
              }

              hasData = true;
            } else {
              log('Error: Gas Data is not a list.');
            }
          }

          if (hasData) {
            update();
            return true;
          } else {
            log('Error: No valid data found.');
            update();
            return false;
          }
        } else {
          log('Error: Response is not a valid Map.');
          return false;
        }
      } else {
        log('Error: API call failed with status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _isMonthProgress = false;
      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching Month data: $_errorMessage');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
  }


  // UI methods
  Set<int> selectedIndices = {};
  void toggleSelection(int index, bool selected) {
    if (selected) {
      selectedIndices.add(index);
      log("==> Month selectedIndices ==> $selectedIndices");
    } else {
      selectedIndices.remove(index);
      log(selectedIndices.toString());
    }
    update();
  }

  Map<String, List<bool>> checkboxGroupStates = {
    'source': List.filled(1000, true),
    'load': List.filled(1000, true),
    'waterSource': List.filled(1000, true),
    'waterLoad': List.filled(1000, true),
    'naturalGasSource': List.filled(1000, true),
    'naturalGasLoad': List.filled(1000, true),
  };

  Map<String, List<String>> selectedGridItemsMapString = {};

  void updateSelectedGridItems(String key, String node, bool isSelected) {
    if (isSelected) {
      if (!selectedGridItemsMapString[key]!.contains(node)) {
        selectedGridItemsMapString[key]!.add(node);
        log("==BeforeADD==>>+++$itemsList");

        if (!itemsList.contains(node)) {
          itemsList.add(node);
        }

        removeList.removeWhere((element) => element == node);

        log("==AfterADD==>>+++$itemsList");
      }
    } else {
      selectedGridItemsMapString[key]!.remove(node);
      log("====>>BeforeRemove removeList +++$removeList");

      removeList.add(node);
      itemsList.remove(node);

      log("====>>AfterRemove removeList+++$removeList");
    }

    log("====>>Stay in Set +++$itemsList");
    update();
  }

  void toggleGroup(String group, bool isSelected) {
    checkboxGroupStates[group] = (checkboxGroupStates[group] ?? List.filled(100, false)).map((_) => isSelected).toList();
    update();
  }


  Future<bool> fetchSelectedNodeData({required String selectedMonth, required String selectedYear}) async {


    Map<String, String> requestBody = {
      "month": selectedMonth,
      "year": selectedYear,
    };

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: "Urls.getMonthUrl",
        body: requestBody,
      );

      // log("fetchSelectedNodeData statusCode ==> ${response.statusCode}");
      // log("fetchSelectedNodeData body ==> ${response.body}");


      if (response.isSuccess) {
        final jsonData = response.body;

        if (jsonData is Map<String, dynamic>) {
          bool hasData = false;

          // Process DGR Data
          if (jsonData.containsKey('dgr_data')) {
            final dataList = jsonData['dgr_data'];

            if (dataList is List) {

              // log("Remove List : $removeList");

              allSourceItems =  dataList.where((item) =>
              ((item['category'] != 'Electricity' && item['node_type'] == 'Bus_Bar') || item['category'] != 'Electricity') && itemsList.contains(item['node']))
                  .map((item) => DgrDataModel.fromJson(item as Map<String, dynamic>)).toList();


              allLoadItems = dataList.where((item) => (item['category'] == 'Electricity' && item['node_type'] == 'Load') && itemsList.contains(item['node']))
                  .map((item) => DgrDataModel.fromJson(item as Map<String, dynamic>)).toList();


              if(_dgrMonthDataSourceList.isNotEmpty){
                selectedGridItemsMapString['Source'] = _dgrMonthDataSourceList.where((item)=> !removeList.contains(item.node)).map((data) => data.node!).toList();
              }

              if(_dgrMonthDataLoadList.isNotEmpty){
                selectedGridItemsMapString['Load'] = _dgrMonthDataLoadList.where((item)=> !removeList.contains(item.node)).map((data) => data.node!).toList();
              }


              hasData = true;
            } else {
              log('Error: Water Data is not a list.');
            }
          }

          // Process Water Data
          if (jsonData.containsKey('water_data')) {
            final dataList = jsonData['water_data'];

            if (dataList is List) {

              //  log("Remove List : $removeList");

              allWaterSourceItems = dataList.where((item) =>
              (item['node_type'] == 'Source' && item['category'] == 'Water') && itemsList.contains(item['node']))
                  .map((item) => WaterDataModel.fromJson(item as Map<String, dynamic>))
                  .toList();


              allWaterLoadItems = dataList.where((item) =>
              (item['node_type'] == 'Load' && item['category'] == 'Water') && itemsList.contains(item['node']))
                  .map((item) => WaterDataModel.fromJson(item as Map<String, dynamic>)).toList();

              if(_waterMonthDataSourceList.isNotEmpty){
                selectedGridItemsMapString['Water Source'] = _waterMonthDataSourceList.where((item)=> !removeList.contains(item.node)).map((data) => data.node!).toList();
              }

              if(_waterMonthDataLoadList.isNotEmpty){
                selectedGridItemsMapString['Water Load'] = _waterMonthDataLoadList.where((item)=> !removeList.contains(item.node)).map((data) => data.node!).toList();
              }


              hasData = true;
            } else {
              log('Error: Water Data is not a list.');
            }
          }


          // Process Natural Gas Data
          if (jsonData.containsKey('gas_data')) {
            final dataList = jsonData['gas_data'];

            if (dataList is List) {
              //  log("Remove List : $removeList");
              log("Natural Gas List : $removeList");

              allNaturalGasSourceItems = dataList.where((item) =>
              (item['node_type'] == 'Source' && item['category'] == 'Natural_Gas') && itemsList.contains(item['node'])  )
                  .map((item) =>
                  NaturalGasDataModel.fromJson(item as Map<String, dynamic>)).toList();

              allNaturalGasLoadItems = dataList.where((item) =>
              (item['node_type'] == 'Load' && item['category'] == 'Natural_Gas') && itemsList.contains(item['node']))
                  .map((item) =>
                  NaturalGasDataModel.fromJson(item as Map<String, dynamic>)).toList();



              if(_naturalGasMonthDataSourceList.isNotEmpty){
                selectedGridItemsMapString['Natural Gas Source'] = _naturalGasMonthDataSourceList.where((item)=> !removeList.contains(item.node)).map((data) => data.node!).toList();
              }

              if(_naturalGasMonthDataLoadList.isNotEmpty){
                selectedGridItemsMapString['Natural Gas Load'] = _naturalGasMonthDataLoadList.where((item)=> !removeList.contains(item.node)).map((data) => data.node!).toList();
              }

              hasData = true;
            } else {
              log('Error: Gas Data is not a list.');
            }
          }


          if (hasData) {
            update();
            return true;
          } else {
            log('Error: No valid data found.');
            update();
            return false;
          }
        } else {
          log('Error: Response is not a valid Map.');
          return false;
        }
      } else {
        log('Error: API call failed with status ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _isMonthProgress = false;
      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching Month data: $_errorMessage');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
      return false;
    }
  }










  /// Request Storage Permissions
  Future<void> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Handle permission for Android 11 and above
      if (await Permission.manageExternalStorage.request().isGranted ||
          await Permission.storage.request().isGranted) {
        log("Storage permission granted");
      } else if (await Permission.manageExternalStorage.isPermanentlyDenied ||
          await Permission.storage.isPermanentlyDenied) {
        Get.snackbar(
          "Permission Denied",
          "Please enable storage permission in app settings",
          snackPosition: SnackPosition.BOTTOM,
          mainButton: const TextButton(
            onPressed: openAppSettings,
            child: Text('Settings'),
          ),
        );
      } else {
        Get.snackbar("Error", "Storage permission is required to save files");
      }
    } else if (Platform.isIOS) {
      // iOS-specific storage permissions
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted) {
        log("Storage permission granted");
      } else if (await Permission.photos.isPermanentlyDenied ||
          await Permission.storage.isPermanentlyDenied) {
        Get.snackbar(
          "Permission Denied",
          "Please enable storage permission in app settings",
          snackPosition: SnackPosition.BOTTOM,
          mainButton: const TextButton(
            onPressed: openAppSettings,
            child: Text('Settings'),
          ),
        );
      } else {
        Get.snackbar("Error", "Storage permission is required to save files");
      }
    }
  }
  /*-------------------one time ask----------*/

  Future<void> downloadDataSheet() async {
    await requestStoragePermission();

    // Ensure permission before proceeding
    if (await Permission.manageExternalStorage.isGranted || await Permission.storage.isGranted) {
      var excel = Excel.createExcel();

      // Sheet for allSourceItems
      Sheet sourceSheet = excel['Source Monthly Report'];
      sourceSheet.appendRow([
        TextCellValue('Date and Time'),
        TextCellValue('Category'),
        TextCellValue('Node'),
        TextCellValue('Power'),
        TextCellValue('Cost')
      ]);

      for (var data in allSourceItems) {
        sourceSheet.appendRow([
          TextCellValue(data.timedate != null ? DateFormat('dd-MMM-yyyy').format(data.timedate!) : 'N/A'), // Format DateTime
          TextCellValue(data.category ?? ''),
          TextCellValue(data.node ?? ''),
          DoubleCellValue((data.energy ?? 0).toDouble()),
          DoubleCellValue((data.cost ?? 0).toDouble()),
        ]);
      }

      // Sheet for allLoadItems
      Sheet loadSheet = excel['Load Monthly Report'];
      loadSheet.appendRow([
        TextCellValue('Date and Time'),
        TextCellValue('Category'),
        TextCellValue('Load Type'),
        TextCellValue('Load Value'),
        TextCellValue('Cost')
      ]);

      for (var data in allLoadItems) {
        loadSheet.appendRow([
          TextCellValue(data.timedate != null ? DateFormat('dd-MMM-yyyy').format(data.timedate!) : 'N/A'), // Format DateTime
          TextCellValue(data.category ?? ''),
          TextCellValue(data.node ?? ''),
          DoubleCellValue((data.energy ?? 0).toDouble()),
          DoubleCellValue((data.cost ?? 0).toDouble()),
        ]);
      }


      // Sheet for allWaterSourceItems
      Sheet waterSourceSheet = excel['Water Source Monthly Report'];
      waterSourceSheet.appendRow([
        TextCellValue('Date and Time'),
        TextCellValue('Node'),
        TextCellValue('instant Flow'),
        TextCellValue('Cost')
      ]);

      for (var data in allWaterSourceItems) {
        waterSourceSheet.appendRow([
          TextCellValue(data.timedate != null ? DateFormat('dd-MMM-yyyy').format(data.timedate!) : 'N/A'), // Format DateTime
          TextCellValue(data.node ?? ''),
          DoubleCellValue((data.instantFlow ?? 0).toDouble()),
          DoubleCellValue((data.cost ?? 0).toDouble()),
        ]);
      }

      // Sheet for allWaterLoadItems
      Sheet waterLoadSheet = excel['Water Load Monthly Report'];
      waterLoadSheet.appendRow([
        TextCellValue('Date and Time'),
        TextCellValue('Node'),
        TextCellValue('instant Flow'),
        TextCellValue('Cost')
      ]);

      for (var data in allWaterLoadItems) {
        waterLoadSheet.appendRow([
          TextCellValue(data.timedate != null ? DateFormat('dd-MMM-yyyy').format(data.timedate!) : 'N/A'), // Format DateTime

          TextCellValue(data.node ?? ''),
          DoubleCellValue((data.instantFlow ?? 0).toDouble()),
          DoubleCellValue((data.cost ?? 0).toDouble()),
        ]);
      }




      try {
        // Prompt user to select a directory
        String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
        if (selectedDirectory != null) {
          String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
          String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());

          // Define file path
          String filePath = "$selectedDirectory/Analysis Pro Monthly Report $formattedDate $formattedTime.xlsx";
          List<int>? bytes = excel.save();
          if (bytes != null) {
            // Create and write file
            File(filePath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(bytes);

            AppToast.showSuccessDownloadToast("Download Complete, File saved at $filePath");
          } else {
            throw Exception("Failed to generate Excel file");
          }
        } else {
          Get.snackbar("Cancelled", "No directory selected");
        }
      } catch (e) {
        log("Error saving Excel file: $e");
        Get.snackbar("Error", "Could not save file: $e");
      }
    } else {
      Get.snackbar("Permission Denied", "Storage permission is required to save the file.");
    }
  }









}


