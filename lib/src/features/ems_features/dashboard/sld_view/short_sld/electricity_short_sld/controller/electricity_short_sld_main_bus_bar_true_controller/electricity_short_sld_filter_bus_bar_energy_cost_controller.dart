import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/model/main_bus_bar_true_model/filter_bus_bar_const_model.dart';
import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';


class ElectricityShortSLDFilterBusBarEnergyCostController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isFilterBusBarEnergyCostInProgress = false;
  bool _isFilterBusBarButtonInProgress = false;
  String _errorMessage = '';

  List<FilterBusBarEnergyCostModel> _filterBusBarEnergyBusBarList = <FilterBusBarEnergyCostModel>[];

  bool get isConnected => _isConnected;
  bool get isFilterBusBarEnergyCostInProgress => _isFilterBusBarEnergyCostInProgress;
  bool get isFilterBusBarButtonInProgress => _isFilterBusBarButtonInProgress;
  String get errorMessage => _errorMessage;


  List<FilterBusBarEnergyCostModel> get filterBusBarEnergyBusBarList => _filterBusBarEnergyBusBarList;
  int dateDifference = 0;

  @override
  void onInit() {
    super.onInit();
    String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    _fromDateTEController.text = todayDate;
    _toDateTEController.text = todayDate;
  }




  Future<bool> fetchFilterSpecificData({required String busBarName,required String fromDate, required String toDate ,bool fromButton = false}) async {

    _isFilterBusBarEnergyCostInProgress = true;
    _isFilterBusBarButtonInProgress = fromButton;
    update();

    final formattedFromDate = DateFormat("yyyy-MM-dd").format(
      DateFormat("dd-MM-yyyy").parse(fromDate).toLocal(),
    );

    final formattedToDate = DateFormat("yyyy-MM-dd").format(
      DateFormat("dd-MM-yyyy").parse(toDate).toLocal(),
    );


    Map<String, String> requestBody = {
      "start": formattedFromDate,
      "end": formattedToDate,
    };

    log("Request Custom Body Date: $requestBody");

    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.filterBusBarEnergyCostUrl(busBarName),
        body: requestBody,
      );

      //  log("filterBusBarEnergyCostUrl statusCode ==> ${Urls.postFilterSpecificNodeDataUrl(nodeName)}");

      log("filterBusBarEnergyCostUrl statusCode ==> ${response.statusCode}");
      log("filterBusBarEnergyCostUrl body ==> ${response.body}");

      _isFilterBusBarEnergyCostInProgress = false;
      _isFilterBusBarButtonInProgress = false;
      update();

      if (response.isSuccess) {

          final jsonData = (response.body as List<dynamic>);
          _filterBusBarEnergyBusBarList = jsonData.map((json) => FilterBusBarEnergyCostModel.fromJson(json as Map<String, dynamic>)).toList();

        update();
        return true;

      } else {
        _errorMessage = " Failed to fetch filter data";
        update();
        return false;
      }
    } catch (e) {
      _isFilterBusBarEnergyCostInProgress = false;
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




  Future<void> downloadFilterBusBarDataSheet(BuildContext context) async {
    // Request storage permission
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        // Create a new Excel workbook and worksheet
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'BusBarEnergyCostReport';

        // Define column widths for better readability
        sheet.getRangeByIndex(1, 1, 1, 1).columnWidth = 15; // Date
        sheet.getRangeByIndex(1, 2, 1, 2).columnWidth = 15; // Energy
        sheet.getRangeByIndex(1, 3, 1, 3).columnWidth = 15; // Cost

        // Add header row with styling
        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        // Define headers (only Date, Energy, Cost)
        List<String> headers = [
          'Date',
          'Energy',
          'Cost',
        ];

        // Populate header row
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
          sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
        }

        // Add data rows from _filterBusBarEnergyBusBarList
        if (_filterBusBarEnergyBusBarList.isNotEmpty) {
          for (int i = 0; i < _filterBusBarEnergyBusBarList.length; i++) {
            final rowIndex = i + 2; // Start from row 2 (after header)
            final data = _filterBusBarEnergyBusBarList[i];

            // Format the date
            String formattedDate = data.date != null
                ? DateFormat('dd/MMM/yyyy').format(DateTime.parse(data.date!))
                : 'N/A';

            sheet.getRangeByIndex(rowIndex, 1).setText(formattedDate);
            sheet.getRangeByIndex(rowIndex, 2).setNumber(data.energy?.toDouble() ?? 0);
            sheet.getRangeByIndex(rowIndex, 3).setNumber(data.cost?.toDouble() ?? 0);
          }
        } else {
          // If no data, show a snackbar and return
          Get.snackbar(
            "No Data",
            "No data available to download.",
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
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

            // Use a default name since Node Name is not included
            String reportName = 'BusBarEnergyCost';

            // Include date range in the file name
            String fromDate = _fromDateTEController.text.replaceAll('-', '');
            String toDate = _toDateTEController.text.replaceAll('-', '');
            String filePath =
                "${directory.path}/${reportName}_${fromDate}_to_${toDate}_$formattedDate$formattedTime.xlsx";

            final List<int> bytes = workbook.saveAsStream();
            File(filePath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(bytes);

            FlutterSmartDownloadDialog.show(
              context: context,
              filePath: filePath,
              dialogType: DialogType.popup,
            );
            log("File saved at ==> $filePath");

            Get.snackbar(
              "Success",
              "File downloaded successfully",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
            );
          } else {
            Get.snackbar(
              "Error",
              "Could not access the storage directory.",
              duration: const Duration(seconds: 7),
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else if (Platform.isIOS) {
          final directory = await getApplicationDocumentsDirectory();
          String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
          String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());

          String reportName = 'BusBarEnergyCost';
          String fromDate = _fromDateTEController.text.replaceAll('-', '');
          String toDate = _toDateTEController.text.replaceAll('-', '');
          String filePath =
              "${directory.path}/${reportName}_${fromDate}_to_${toDate}_$formattedDate$formattedTime.xlsx";

          final List<int> bytes = workbook.saveAsStream();
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(bytes);

          await Share.shareXFiles([XFile(filePath)],
              text: 'Bus Bar Energy Cost Report from $fromDate to $toDate',
              subject: 'Bus Bar Report $formattedDate $formattedTime');
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

  void checkDateDifference(BuildContext context) {
    final fromDate = DateFormat("dd-MM-yyyy").parse(_fromDateTEController.text);
    final toDate = DateFormat("dd-MM-yyyy").parse(_toDateTEController.text);

    dateDifference = toDate.difference(fromDate).inDays;
    log("======> $dateDifference");
    update();
  }


  void clearFilterIngDate(){
    String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
    _fromDateTEController.text = todayDate;
    _fromDateTEController.text = todayDate;

    update();
  }

}