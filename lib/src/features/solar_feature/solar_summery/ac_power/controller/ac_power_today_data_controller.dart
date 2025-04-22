import 'dart:developer';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/model/plant_today_data_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AcPowerTodayDataController extends GetxController with InternetConnectivityCheckMixin{
  bool _isConnected = true;
  bool _isAcPowerDataInProgress= false;
  String _errorMessage = '';
  List <PlantTodayDataModel> _plantTodayDataList = [];

  bool get isConnected => _isConnected;
  bool get isAcPowerDataInProgress=> _isAcPowerDataInProgress;
  String get errorMessage => _errorMessage;
  List <PlantTodayDataModel> get  plantTodayDataList => _plantTodayDataList;


  Future<bool>fetchPlantTodayData()async{
    _isAcPowerDataInProgress= true;
    update();

    try{
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.getRequest(url: Urls.getPlantTodayDataUrl);

      // log("AcPowerTodayDataController statusCode ==> ${response.statusCode}");
      // log("AcPowerTodayDataController body ==> ${response.body}");

      _isAcPowerDataInProgress= false;


      if(response.isSuccess){

        var jsonData = response.body as List<dynamic>;

        _plantTodayDataList = jsonData.map((json)=> PlantTodayDataModel.fromJson(json)).toList();
        update();
        return true;
      }else{
        _errorMessage = "Can't fetch plant today data";
        update();
        return false;
      }

    }catch(e){
      _isAcPowerDataInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }

      log('Error in fetch plant day data: $_errorMessage');
      _errorMessage = "Can't fetch plant day data";

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
      Sheet sheet = excel['Ac Power Data'];

      // Add header row
      sheet.appendRow([
        TextCellValue('Ac Power'),
      ]);

      // for (var data in _plantTodayDataList) {
      //   sheet.appendRow([
      //     data.timedate != null ? DateFormat('dd-MMM-yyyy').format(data.timedate!) : 'N/A', // Format DateTime
      //     data.totalAcPower ?? 0,
      //
      //   ]);
      // }
      for (var data in _plantTodayDataList) {
        sheet.appendRow([
          TextCellValue(data.timedate != null ? DateFormat('dd-MMM-yyyy').format(data.timedate!) : 'N/A'),
          DoubleCellValue((data.totalAcPower ?? 0).toDouble()), // Assuming totalAcPower is a number
        ]);
      }




      try {
        // Prompt user to select a directory
        String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
        if (selectedDirectory != null) {

          String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
          String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());

          // Define file path

          String filePath = "$selectedDirectory/Ac Power Data $formattedDate $formattedTime.xlsx";
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