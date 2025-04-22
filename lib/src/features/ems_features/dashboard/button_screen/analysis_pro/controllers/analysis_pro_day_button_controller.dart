import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/day_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AnalysisProDayButtonController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isDayProgress = false;
  String _errorMessage = '';
  List<DgrDataModel> _dgrDayDataSourceList = <DgrDataModel>[];
  List<DgrDataModel> _dgrDayDataLoadList = <DgrDataModel>[];

  List<WaterDataModel> _waterDayDataSourceList = <WaterDataModel>[];
  List<WaterDataModel> _waterDayDataLoadList = <WaterDataModel>[];

  List<NaturalGasDataModel> _naturalGasDayDataSourceList = <NaturalGasDataModel>[];
  List<NaturalGasDataModel> _naturalGasDayDataLoadList = <NaturalGasDataModel>[];

  bool get isConnected => _isConnected;
  bool get isDayProgress => _isDayProgress;
  String get errorMessage => _errorMessage;
  List<DgrDataModel> get dgrDayDataSourceList => _dgrDayDataSourceList;
  List<DgrDataModel> get dgrDayDataLoadList => _dgrDayDataLoadList;

  List<WaterDataModel> get waterDayDataSourceList => _waterDayDataSourceList;
  List<WaterDataModel> get waterDayDataLoadList => _waterDayDataLoadList;

  List<NaturalGasDataModel> get naturalGasDayDataSourceList => _naturalGasDayDataSourceList;
  List<NaturalGasDataModel> get naturalGasDayDataLoadList => _naturalGasDayDataLoadList;

  List<dynamic> _dayDataList = <dynamic>[];
  List<dynamic> get dayDataList => _dayDataList;

  var allSourceItems = <DgrDataModel>[];
  var allLoadItems = <DgrDataModel>[];

  var allWaterSourceItems = <WaterDataModel>[];
  var allWaterLoadItems = <WaterDataModel>[];

  var allNaturalGasSourceItems = <NaturalGasDataModel>[];
  var allNaturalGasLoadItems = <NaturalGasDataModel>[];
  Set<String> itemsList = {};
  Set<String> removeList = {};

  @override
  void onInit() {
    super.onInit();
    String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    _fromMonthTEController.text = todayDate;
    _toMonthTEController.text = todayDate;
  }

  Future<bool> fetchDayModelDGRData({required String fromDate, required String toDate}) async {

    _isDayProgress = true;
    update();

    final formattedFromDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(DateFormat("dd-MM-yyyy").parse(fromDate));
    final parsedToDate = DateFormat("dd-MM-yyyy").parse(toDate);
    final adjustedToDate = parsedToDate.add(const Duration(hours: 23, minutes: 59, seconds: 59));
    final formattedToDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(adjustedToDate);

    Map<String, String> requestBody = {
      "start": formattedFromDate,
      "end": formattedToDate,
    };

    // log("Request DGR Body Date: $requestBody");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.getDayUrl,
        body: requestBody,
      );

      // log("dayPostRequestBottomSheet statusCode ==> ${response.statusCode}");
      // log("dayPostRequestBottomSheet body ==> ${response.body}");

      _isDayProgress = false;
      update();

      if (response.isSuccess) {
        final jsonData = response.body;

        if (jsonData is Map<String, dynamic>) {
          bool hasData = false;

          DayModel dayModel = DayModel.fromJson(jsonData);
          _dayDataList = [dayModel];




          // Process DGR Data
          if (jsonData.containsKey('dgr_data')) {
            final dataList = jsonData['dgr_data'];

            if (dataList is List) {
              var sourceSeenItems = <String>{};
              var loadSeenItems = <String>{};

              _dgrDayDataSourceList = dataList.where((item) =>
              (item['category'] != 'Electricity' && item['type'] == 'Bus_Bar') || item['category'] != 'Electricity')
                  .map((item) => DgrDataModel.fromJson(item as Map<String, dynamic>)).where((data) => sourceSeenItems.add(data.node!)).toList();

              itemsList.addAll(sourceSeenItems);


              _dgrDayDataLoadList = dataList.where((item) =>
              item['category'] == 'Electricity' && item['type'] == 'Load')
                  .map((item) => DgrDataModel.fromJson(item as Map<String, dynamic>)).where((data) => loadSeenItems.add(data.node!)).toList();


              itemsList.addAll(loadSeenItems);

              if(_dgrDayDataSourceList.isNotEmpty){
                selectedGridItemsMapString['Source'] = _dgrDayDataSourceList.map((data) => data.node!).toList();
              }

              if(_dgrDayDataLoadList.isNotEmpty){
                selectedGridItemsMapString['Load'] = _dgrDayDataLoadList.map((data) => data.node!).toList();
              }


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
              _waterDayDataSourceList = dataList.where((item) =>
              (item['type'] == 'Source' && item['category'] == 'Water'))
                  .map((item) => WaterDataModel.fromJson(item as Map<String, dynamic>)).where((data) => sourceSeenItems.add(data.node!)).toList();

              itemsList.addAll(sourceSeenItems);


              _waterDayDataLoadList = dataList.where((item) =>
              (item['type'] == 'Load' && item['category'] == 'Water'))
                  .map((item) => WaterDataModel.fromJson(item as Map<String, dynamic>)).where((data) => loadSeenItems.add(data.node!)).toList();

              itemsList.addAll(loadSeenItems);

             if(_waterDayDataSourceList.isNotEmpty){
               selectedGridItemsMapString['Water Source'] = _waterDayDataSourceList.map((data) => data.node!).toList();
             }

             if(_waterDayDataLoadList.isNotEmpty){
               selectedGridItemsMapString['Water Load'] = _waterDayDataLoadList.map((data) => data.node!).toList();

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

              _naturalGasDayDataSourceList = dataList.where((item) =>
              (item['type'] == 'Source' && item['category'] == 'Natural_Gas'))
                  .map((item) =>
                  NaturalGasDataModel.fromJson(item as Map<String, dynamic>))
                  .where((data) => sourceSeenItems.add(data.node!)).toList();


              itemsList.addAll(sourceSeenItems);

              _naturalGasDayDataLoadList = dataList.where((item) =>
              (item['type'] == 'Load' && item['category'] == 'Natural_Gas'))
                  .map((item) =>
                  NaturalGasDataModel.fromJson(item as Map<String, dynamic>))
                  .where((data) => loadSeenItems.add(data.node!)).toList();

              itemsList.addAll(loadSeenItems);


              if(_naturalGasDayDataSourceList.isNotEmpty){
                selectedGridItemsMapString['Natural Gas Source'] = _naturalGasDayDataSourceList.map((data) => data.node!).toList();
              }

              if(_naturalGasDayDataLoadList.isNotEmpty){
                selectedGridItemsMapString['Natural Gas Load'] = _naturalGasDayDataLoadList.map((data) => data.node!).toList();
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
      _isDayProgress = false;
      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching day data: $_errorMessage');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        update();
      });
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



  Future<bool> fetchSelectedNodeData({required String fromDate, required String toDate}) async {

    final formattedFromDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(DateFormat("dd-MM-yyyy").parse(fromDate));
    final parsedToDate = DateFormat("dd-MM-yyyy").parse(toDate);
    final adjustedToDate = parsedToDate.add(const Duration(hours: 23, minutes: 59, seconds: 59));
    final formattedToDate = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(adjustedToDate);

    Map<String, String> requestBody = {
      "start": formattedFromDate,
      "end": formattedToDate,
    };

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.getDayUrl,
        body: requestBody,
      );

     //  log("fetchSelectedNodeData statusCode ==> ${response.statusCode}");
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
              ((item['category'] != 'Electricity' && item['type'] == 'Bus_Bar') || item['category'] != 'Electricity') && itemsList.contains(item['node']))
                  .map((item) => DgrDataModel.fromJson(item as Map<String, dynamic>)).toList();


              allLoadItems = dataList.where((item) => (item['category'] == 'Electricity' && item['type'] == 'Load') && itemsList.contains(item['node']))
                  .map((item) => DgrDataModel.fromJson(item as Map<String, dynamic>)).toList();


              if(_dgrDayDataSourceList.isNotEmpty){
                selectedGridItemsMapString['Source'] = _dgrDayDataSourceList.where((item)=> !removeList.contains(item.node)).map((data) => data.node!).toList();
              }

              if(_dgrDayDataLoadList.isNotEmpty){
                selectedGridItemsMapString['Load'] = _dgrDayDataLoadList.where((item)=> !removeList.contains(item.node)).map((data) => data.node!).toList();
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
              (item['type'] == 'Source' && item['category'] == 'Water') && itemsList.contains(item['node']))
                  .map((item) => WaterDataModel.fromJson(item as Map<String, dynamic>))
                  .toList();


              allWaterLoadItems = dataList.where((item) =>
              (item['type'] == 'Load' && item['category'] == 'Water') && itemsList.contains(item['node']))
                  .map((item) => WaterDataModel.fromJson(item as Map<String, dynamic>)).toList();

              if(_waterDayDataSourceList.isNotEmpty){
                selectedGridItemsMapString['Water Source'] = _waterDayDataSourceList.where((item)=> !removeList.contains(item.node)).map((data) => data.node!).toList();
              }

              if(_waterDayDataLoadList.isNotEmpty){
                selectedGridItemsMapString['Water Load'] = _waterDayDataLoadList.where((item)=> !removeList.contains(item.node)).map((data) => data.node!).toList();
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
             //  log("Natural Gas List : $removeList");

              allNaturalGasSourceItems = dataList.where((item) =>
              (item['type'] == 'Source' && item['category'] == 'Natural_Gas') && itemsList.contains(item['node'])  )
                  .map((item) =>
                  NaturalGasDataModel.fromJson(item as Map<String, dynamic>)).toList();

              allNaturalGasLoadItems = dataList.where((item) =>
              (item['type'] == 'Load' && item['category'] == 'Natural_Gas') && itemsList.contains(item['node']))
                  .map((item) =>
                  NaturalGasDataModel.fromJson(item as Map<String, dynamic>)).toList();

              if(_naturalGasDayDataSourceList.isNotEmpty){
                selectedGridItemsMapString['Natural Gas Source'] = _naturalGasDayDataSourceList.where((item)=> !removeList.contains(item.node)).map((data) => data.node!).toList();
              }

              if(_naturalGasDayDataLoadList.isNotEmpty){
                selectedGridItemsMapString['Natural Gas Load'] = _naturalGasDayDataLoadList.where((item)=> !removeList.contains(item.node)).map((data) => data.node!).toList();
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
      _isDayProgress = false;
      _errorMessage = e.toString();
      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in fetching day data: $_errorMessage');
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
  // Future<void> downloadDataSheet() async {
  //   await requestStoragePermission();
  //
  //   // Ensure permission before proceeding
  //   if (await Permission.manageExternalStorage.isGranted || await Permission.storage.isGranted) {
  //     var excel = Excel.createExcel();
  //     Sheet sheet = excel['Analysis Pro Daily Report'];
  //
  //     // Add header row
  //     sheet.appendRow([
  //       'Date and Time', 'Category', 'Node', 'Power', 'Cost'
  //     ]);
  //
  //     for (var data in allSourceItems) {
  //       sheet.appendRow([
  //         data.timedate != null ? DateFormat('dd-MMM-yyyy').format(data.timedate!) : 'N/A', // Format DateTime
  //         data.category ?? '',
  //         data.node ?? '',
  //         data.power ?? 0,
  //         data.cost ?? 0,
  //
  //       ]);
  //     }
  //
  //     try {
  //       // Prompt user to select a directory
  //       String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  //       if (selectedDirectory != null) {
  //
  //         String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
  //         String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
  //
  //         // Define file path
  //         String filePath = "$selectedDirectory/Analysis Pro Daily Report $formattedDate $formattedTime.xlsx";
  //         List<int>? bytes = excel.save();
  //         if (bytes != null) {
  //           // Create and write file
  //           File(filePath)
  //             ..createSync(recursive: true)
  //             ..writeAsBytesSync(bytes);
  //
  //           //  Get.snackbar("Download Complete", "File saved at $filePath");
  //           AppToast.showSuccessDownloadToast("Download Complete, File saved at $filePath");
  //         } else {
  //           throw Exception("Failed to generate Excel file");
  //         }
  //       } else {
  //         Get.snackbar("Cancelled", "No directory selected");
  //       }
  //     } catch (e) {
  //       log("Error saving Excel file: $e");
  //       Get.snackbar("Error", "Could not save file: $e");
  //     }
  //   } else {
  //     Get.snackbar("Permission Denied", "Storage permission is required to save the file.");
  //   }
  // }
  Future<void> downloadDataSheet() async {
    await requestStoragePermission();

    // Ensure permission before proceeding
    if (await Permission.manageExternalStorage.isGranted || await Permission.storage.isGranted) {
      var excel = Excel.createExcel();

      // Sheet for allSourceItems
      Sheet sourceSheet = excel['Source Daily Report'];
      // sourceSheet.appendRow([
      //   'Date and Time', 'Category', 'Node', 'Power Value', 'Cost'
      // ]);
      //
      // for (var data in allSourceItems) {
      //   sourceSheet.appendRow([
      //     data.timedate != null ? DateFormat('dd-MMM-yyyy').format(data.timedate!) : 'N/A', // Format DateTime
      //     data.category ?? '',
      //     data.node ?? '',
      //     data.power ?? 0,
      //     data.cost ?? 0,
      //   ]);
      // }


      // Add header row
      sourceSheet.appendRow([
        TextCellValue('Date and Time'),
        TextCellValue('Category'),
        TextCellValue('Node'),
        TextCellValue('Power Value'),
        TextCellValue('Cost'),
      ]);

// Add data rows
      for (var data in allSourceItems) {
        sourceSheet.appendRow([
          TextCellValue(data.timedate != null ? DateFormat('dd-MMM-yyyy').format(data.timedate!) : 'N/A'),
          TextCellValue(data.category ?? ''),
          TextCellValue(data.node ?? ''),
          DoubleCellValue((data.power ?? 0).toDouble()),
          DoubleCellValue((data.cost ?? 0).toDouble()),
        ]);
      }


      // Sheet for allLoadItems
      Sheet loadSheet = excel['Load Daily Report'];
      loadSheet.appendRow([
        TextCellValue('Date and Time'),
        TextCellValue('Category'),
        TextCellValue('Node'),
        TextCellValue('Energy Value'),
        TextCellValue('Cost')
      ]);

      for (var data in allLoadItems) {
        loadSheet.appendRow([
          TextCellValue(data.timedate != null ? DateFormat('dd-MMM-yyyy').format(data.timedate!) : 'N/A'), // Format DateTime
          TextCellValue(data.category ?? ''),
          TextCellValue(data.node ?? ''),
          DoubleCellValue((data.power ?? 0).toDouble()),
          DoubleCellValue((data.cost ?? 0).toDouble()),
        ]);
      }


      // Sheet for allWaterSourceItems
      Sheet waterSourceSheet = excel['Water Source Daily Report'];
      waterSourceSheet.appendRow([
        TextCellValue('Date and Time'),
        TextCellValue('Category'),
        TextCellValue('Node'),
        TextCellValue('instant Flow'),
        TextCellValue('Cost')
      ]);

      for (var data in allWaterSourceItems) {
        waterSourceSheet.appendRow([
          TextCellValue(data.timedate != null ? DateFormat('dd-MMM-yyyy').format(data.timedate!) : 'N/A'), // Format DateTime
          TextCellValue(data.category ?? ''),
          TextCellValue(data.node ?? ''),
          DoubleCellValue((data.instantFlow ?? 0).toDouble()),
          DoubleCellValue((data.cost ?? 0).toDouble()),
        ]);
      }

      // Sheet for allWaterLoadItems
      Sheet waterLoadSheet = excel['Water Load Daily Report'];
      waterLoadSheet.appendRow([
        TextCellValue('Date and Time'),
        TextCellValue('Category'),
        TextCellValue('Node'),
        TextCellValue('instant Flow'),
        TextCellValue('Cost')
      ]);

      for (var data in allWaterLoadItems) {
        waterLoadSheet.appendRow([
          TextCellValue(data.timedate != null ? DateFormat('dd-MMM-yyyy').format(data.timedate!) : 'N/A'), // Format DateTime
          TextCellValue(data.category ?? ''),
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
          String filePath = "$selectedDirectory/Analysis Pro Daily Report $formattedDate $formattedTime.xlsx";
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











  final TextEditingController _fromMonthTEController = TextEditingController();
  final TextEditingController _toMonthTEController = TextEditingController();
  final RxBool _clearDate = false.obs;

  RxBool get clearDate => _clearDate;
  TextEditingController get fromDateTEController => _fromMonthTEController;
  TextEditingController get toDateTEController => _toMonthTEController;

  void formDatePicker(BuildContext context) async {
    DateTime? picker = await showDatePicker(
      context: context,
      initialDate:_fromMonthTEController.text.isNotEmpty
          ? DateFormat("dd-MM-yyyy").parse(_fromMonthTEController.text)
          : DateTime.now(),

      firstDate: DateTime(2024),
      lastDate: DateTime(2130),
    );

    if (picker != null) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(picker);
      _fromMonthTEController.text = formattedDate;
      _clearDate.value = true;
      update();
      validateDates(context);
    }
  }

  void toDatePicker(BuildContext context) async {
    DateTime? picker = await showDatePicker(
      context: context,
      initialDate: _toMonthTEController.text.isNotEmpty
          ? DateFormat("dd-MM-yyyy").parse(_toMonthTEController.text)
          : DateTime.now(),

      firstDate: DateTime(2024),
      lastDate: DateTime(2130),
    );

    if (picker != null) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(picker);
      _toMonthTEController.text = formattedDate;
      _clearDate.value = true;
      update();
      validateDates(context);
    }
  }

  void validateDates(BuildContext context) {
    final fromDate = DateFormat("dd-MM-yyyy").parse(_fromMonthTEController.text);
    final toDate = DateFormat("dd-MM-yyyy").parse(_toMonthTEController.text);

    if (fromDate.isAfter(toDate)) {
      AppToast.showWrongToast("Invalid Date Range");
    }
  }

}


