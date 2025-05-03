// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
// import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
// import 'package:nz_fabrics/src/common_widgets/text_component.dart';
// import 'package:nz_fabrics/src/features/source/controller/over_all_source_data_controller.dart';
// import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
// import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
// import 'package:nz_fabrics/src/utility/style/app_colors.dart';
// import 'package:nz_fabrics/src/utility/style/constant.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column,Row;
//
//
// class SourceDataController extends GetxController {
//   late Future<List<FormattedData>> dataFuture = Future.value([]);
//   //DateTime startDate = DateTime.now().subtract(const Duration(days: 1));
//   // DateTime endDate = DateTime.now();
//   String token = AuthUtilityController.accessToken ?? '';
//
//   @override
//   void onInit() {
//     super.onInit();
//
//
//     ever(AuthUtilityController.accessTokenForApiCall, (String? token){
//       if(token != null){
//         fetchData(
//           Get.find<OverAllSourceDataController>().fromDateTEController.text,
//           Get.find<OverAllSourceDataController>().toDateTEController.text,
//         );
//       }
//     });
//
//
//   }
//
//   Future<void> fetchData(String start, String end) async {
//     if (AuthUtilityController.accessToken == null) {
//       log("[log] Access token is null, cannot fetch data");
//       dataFuture = Future.error("Authentication token is missing");
//       update();
//       return;
//     }
//
//     String formattedStart = _formatFromDate(start);
//     String formattedEnd = _formatToDate(end);
//
//     log("[log] formattedFromDate: $formattedStart");
//     log("[log] formattedToDate: $formattedEnd");
//
//     try {
//       final response = await http.post(
//         Uri.parse('${Urls.baseUrl}/api/filter-overall-source-table-data/'),
//         headers: {
//           'Authorization': AuthUtilityController.accessToken!,
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           "start": formattedStart,
//           "end": formattedEnd,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         List jsonResponse = json.decode(response.body);
//         List<FormattedData> formattedData = _formatData(jsonResponse);
//         dataFuture = Future.value(formattedData);
//         update();
//       } else {
//         throw Exception('Failed to load source Table data: ${response.statusCode}');
//       }
//     } catch (e) {
//       log('Error: $e');
//       dataFuture = Future.error(e);
//       update();
//     }
//   }
//
//
//
//   Future<PermissionStatus> _requestStoragePermission() async {
//     final plugin = DeviceInfoPlugin();
//     final android = await plugin.androidInfo;
//
//     if (android.version.sdkInt < 33) {
//       return await Permission.storage.request();
//     } else {
//       return PermissionStatus.granted;
//     }
//   }
//
//   Future<void> downloadDataSheet(BuildContext context) async {
//     PermissionStatus storageStatus = await _requestStoragePermission();
//
//     if (storageStatus == PermissionStatus.granted) {
//       try {
//         // Create a new Excel workbook
//         final Workbook workbook = Workbook();
//         final Worksheet sheet = workbook.worksheets[0];
//         sheet.name = 'Report';
//
//         // Set column widths for better readability
//         sheet.getRangeByIndex(1, 1, 1, 1).columnWidth = 15; // Date
//         sheet.getRangeByIndex(1, 2, 1, 2).columnWidth = 20; // Total Energy
//         sheet.getRangeByIndex(1, 3, 1, 3).columnWidth = 20; // Total Cost
//         sheet.getRangeByIndex(1, 4, 1, 4).columnWidth = 20; // Solar Energy
//         sheet.getRangeByIndex(1, 5, 1, 5).columnWidth = 20; // Solar Cost
//         sheet.getRangeByIndex(1, 6, 1, 6).columnWidth = 20; // Grid Energy
//         sheet.getRangeByIndex(1, 7, 1, 7).columnWidth = 20; // Grid Cost
//         sheet.getRangeByIndex(1, 8, 1, 8).columnWidth = 20; // Diesel Energy
//         sheet.getRangeByIndex(1, 9, 1, 9).columnWidth = 20; // Diesel Cost
//
//         // Add header row with styling
//         final Style headerStyle = workbook.styles.add('HeaderStyle');
//         headerStyle.bold = true;
//         headerStyle.hAlign = HAlignType.center;
//         headerStyle.backColor = '#D9E1F2';
//         final List<String> headers = [
//           'Date',
//           'Total Energy (kWh)',
//           'Total Cost (৳)',
//           'Solar Energy (kWh)',
//           'Solar Cost (৳)',
//           'Grid Energy (kWh)',
//           'Grid Cost (৳)',
//           'Diesel Energy (kWh)',
//           'Diesel Cost (৳)'
//         ];
//         for (int i = 0; i < headers.length; i++) {
//           sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
//           sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
//         }
//
//         // Await the Future to get the actual List<FormattedData>
//         final formattedData = await dataFuture;
//
//         // Add data rows
//         for (int i = 0; i < formattedData.length; i++) {
//           final rowIndex = i + 2; // Start from row 2 (after header)
//           final data = formattedData[i];
//           sheet.getRangeByIndex(rowIndex, 1).setText(data.date ?? 'N/A');
//           sheet.getRangeByIndex(rowIndex, 2).setNumber(data.totalEnergy ?? 0);
//           sheet.getRangeByIndex(rowIndex, 3).setNumber(data.totalCost ?? 0);
//           sheet.getRangeByIndex(rowIndex, 4).setNumber(data.solarEnergy ?? 0);
//           sheet.getRangeByIndex(rowIndex, 5).setNumber(data.solarCost ?? 0);
//           sheet.getRangeByIndex(rowIndex, 6).setNumber(data.gridEnergy ?? 0);
//           sheet.getRangeByIndex(rowIndex, 7).setNumber(data.gridCost ?? 0);
//           sheet.getRangeByIndex(rowIndex, 8).setNumber(data.dieselEnergy ?? 0);
//           sheet.getRangeByIndex(rowIndex, 9).setNumber(data.dieselCost ?? 0);
//         }
//
//         sheet.autoFitRow(1);
//
//         if (Platform.isAndroid) {
//           final directory = Directory('/storage/emulated/0/Download');
//           if (directory.existsSync()) {
//             String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
//             String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
//             String filePath =
//                 "${directory.path}/Energy_Report_$formattedDate $formattedTime.xlsx";
//
//             final List<int> bytes = workbook.saveAsStream();
//             File(filePath)
//               ..createSync(recursive: true)
//               ..writeAsBytesSync(bytes);
//
//             Get.snackbar(
//                 "Success",
//                 "File downloaded successfully",
//                 snackPosition: SnackPosition.BOTTOM,
//                 backgroundColor: AppColors.greenColor,
//                 colorText: Colors.white,
//                 margin: const EdgeInsets.all(16)
//             );
//             FlutterSmartDownloadDialog.show(
//               context: context,
//               filePath: filePath,
//               dialogType: DialogType.popup,
//             );
//             log("File saved at ==> $filePath");
//           } else {
//             Get.snackbar(
//               "Error",
//               "Could not access the storage directory.",
//               duration: const Duration(seconds: 7),
//               backgroundColor: AppColors.redColor,
//               colorText: Colors.white,
//               snackPosition: SnackPosition.BOTTOM,
//             );
//           }
//         }
//       } catch (e, stackTrace) {
//         log("Error saving Excel file: $e");
//         log("Stack trace: $stackTrace");
//         Get.snackbar(
//           "Error",
//           "Could not save file: $e",
//           duration: const Duration(seconds: 7),
//           backgroundColor: AppColors.redColor,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     } else if (storageStatus == PermissionStatus.denied) {
//       log("======> Permission denied");
//     } else if (storageStatus == PermissionStatus.permanentlyDenied) {
//       openAppSettings();
//     }
//   }
//
//
//
//
//
//
//
//
//   String _formatFromDate(String date) {
//     try {
//       DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
//       DateTime startOfDay = DateTime(parsedDate.year, parsedDate.month, parsedDate.day, 0, 0, 0, 0);
//       return DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(startOfDay);
//     } catch (e) {
//       log('Date format error (From Date): $e');
//       return date; // Return the original string if parsing fails
//     }
//   }
//
//   String _formatToDate(String date) {
//     try {
//       DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
//       DateTime endOfDay = DateTime(parsedDate.year, parsedDate.month, parsedDate.day, 23, 59, 59, 999);
//       return DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(endOfDay);
//     } catch (e) {
//       log('Date format error (To Date): $e');
//       return date; // Return the original string if parsing fails
//     }
//   }
//
//   List<FormattedData> _formatData(List<dynamic> rawData) {
//     List<FormattedData> dailyData = rawData
//         .where((dayData) => dayData.containsKey('date') && dayData.containsKey('sources'))
//         .map((dayData) {
//       Map<String, double> energyMap = {};
//       Map<String, double> costMap = {};
//       Map<String, double> unitCostMap = {}; // New map for unit costs
//       String date = dayData['date'];
//
//       for (var source in dayData['sources']) {
//         String node = source['node'];
//         double energy = (source['energy'] as num).toDouble();
//         double cost = (source['cost'] as num).toDouble();
//         double unitCost = (source['unit_cost'] as num).toDouble(); // Extract unit_cost
//         energyMap[node] = energy;
//         costMap[node] = cost;
//         unitCostMap[node] = unitCost; // Store unit_cost
//       }
//
//       return FormattedData(
//         date: date,
//         totalEnergy: energyMap['Total_Source'] ?? 0,
//         totalCost: costMap['Total_Source'] ?? 0,
//         solarEnergy: energyMap['Solar'] ?? 0,
//         solarCost: costMap['Solar'] ?? 0,
//         solarUnitCost: unitCostMap['Solar'] ?? 0, // Assign unit_cost
//         gridEnergy: energyMap['Grid'] ?? 0,
//         gridCost: costMap['Grid'] ?? 0,
//         gridUnitCost: unitCostMap['Grid'] ?? 0,   // Assign unit_cost
//         dieselEnergy: energyMap['Diesel_Generator'] ?? 0,
//         dieselCost: costMap['Diesel_Generator'] ?? 0,
//         dieselUnitCost: unitCostMap['Diesel_Generator'] ?? 0, // Assign unit_cost
//       );
//     }).toList();
//
//     // Handle totals (assuming API doesn't provide unit_cost for totals)
//     var totals = rawData.lastWhere((data) => !data.containsKey('date'), orElse: () => null);
//     if (totals != null) {
//       dailyData.add(FormattedData(
//         date: 'Total',
//         totalEnergy: totals['total_source_energy'] as double? ?? 0,
//         totalCost: totals['total_source_cost'] as double? ?? 0,
//         solarEnergy: totals['total_solar_energy'] as double? ?? 0,
//         solarCost: totals['total_solar_cost'] as double? ?? 0,
//         solarUnitCost: 0, // Default to 0 or calculate if API provides it
//         gridEnergy: totals['total_grid_energy'] as double? ?? 0,
//         gridCost: totals['total_grid_cost'] as double? ?? 0,
//         gridUnitCost: 0,  // Default to 0 or calculate if API provides it
//         dieselEnergy: totals['total_diesel_energy'] as double? ?? 0,
//         dieselCost: totals['total_diesel_cost'] as double? ?? 0,
//         dieselUnitCost: 0, // Default to 0 or calculate if API provides it
//       ));
//     }
//
//     return dailyData;
//   }
// }
//
// class FormattedData {
//   final String date;
//   final double totalEnergy;
//   final double totalCost;
//   final double solarEnergy;
//   final double solarCost;
//   final double solarUnitCost; // Still needed for calculation/display
//   final double gridEnergy;
//   final double gridCost;
//   final double gridUnitCost;  // Still needed for calculation/display
//   final double dieselEnergy;
//   final double dieselCost;
//   final double dieselUnitCost; // Still needed for calculation/display
//
//   FormattedData({
//     required this.date,
//     required this.totalEnergy,
//     required this.totalCost,
//     required this.solarEnergy,
//     required this.solarCost,
//     required this.solarUnitCost,
//     required this.gridEnergy,
//     required this.gridCost,
//     required this.gridUnitCost,
//     required this.dieselEnergy,
//     required this.dieselCost,
//     required this.dieselUnitCost,
//   });
// }
// final SourceDataController sourceDataController = Get.put(SourceDataController());
//
// class SourceTableWidget extends StatelessWidget {
//   final SourceDataController sourceDataController = Get.put(SourceDataController());
//
//   SourceTableWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.sizeOf(context);
//     return Column(
//       children: [
//         Align(
//           alignment: Alignment.centerRight,
//           child: GestureDetector(
//             onTap: () {
//               sourceDataController.downloadDataSheet(context);
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(right: 4.0, bottom: 2),
//               child: CustomContainer(
//                 height: size.height * 0.050,
//                 width: size.width * 0.3,
//                 borderRadius: BorderRadius.circular(size.height * k8TextSize),
//                 child: const Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       TextComponent(text: "Download"),
//                       Icon(Icons.download),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         GetBuilder<SourceDataController>(
//           init: SourceDataController(),
//           builder: (controller) {
//             return Expanded(
//               child: FutureBuilder<List<FormattedData>>(
//                 future: controller.dataFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                     return Container(
//                       clipBehavior: Clip.antiAlias,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         color: Colors.white,
//                       ),
//                       child: SfDataGridTheme(
//                         data: SfDataGridThemeData(
//                           headerColor: AppColors.secondaryTextColor,
//                           frozenPaneLineColor: AppColors.primaryColor,
//                           frozenPaneLineWidth: 1.0,
//                           gridLineColor: Colors.grey.shade300,
//                           gridLineStrokeWidth: 0.4,
//                         ),
//                         child: SfDataGrid(
//                           headerRowHeight: 47,
//                           headerGridLinesVisibility: GridLinesVisibility.both,
//                           gridLinesVisibility: GridLinesVisibility.both,
//                           rowHeight: 35,
//                           showHorizontalScrollbar: false,
//                           columnWidthMode: size.width > 500 ? ColumnWidthMode.fill : ColumnWidthMode.auto,
//                           source: FormattedDataGridSource(snapshot.data!),
//                           frozenColumnsCount: 1,
//                           footerFrozenRowsCount: 1,
//                           columns: [
//                             GridColumn(
//                               columnName: 'date',
//                               label: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                 alignment: Alignment.center,
//                                 child:  TextComponent(
//                                   text: 'Date',
//                                   color: AppColors.whiteTextColor,
//                                   fontFamily: boldFontFamily,
//                                   maxLines: 2,
//                                   textAlign: TextAlign.center,
//                                   fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
//                                 ),
//                               ),
//                             ),
//                             GridColumn(
//                               columnName: 'totalEnergy',
//                               label: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                 alignment: Alignment.center,
//                                 child:  TextComponent(
//                                   text: 'Energy',
//                                   color: AppColors.whiteTextColor,
//                                   fontFamily: boldFontFamily,
//                                   maxLines: 2,
//                                   textAlign: TextAlign.center,
//                                   fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
//                                 ),
//                               ),
//                             ),
//                             GridColumn(
//                               columnName: 'totalCostUnitCost',
//                               label: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                 alignment: Alignment.center,
//                                 child:  TextComponent(
//                                   text: 'Cost/\nUnit Price',
//                                   color: AppColors.whiteTextColor,
//                                   fontFamily: boldFontFamily,
//                                   maxLines: 2,
//                                   textAlign: TextAlign.center,
//                                   fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
//                                 ),
//                               ),
//                             ),
//                             GridColumn(
//                               columnName: 'solarEnergy',
//                               label: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                 alignment: Alignment.center,
//                                 child:  TextComponent(
//                                   text: 'Energy',
//                                   color: AppColors.whiteTextColor,
//                                   fontFamily: boldFontFamily,
//                                   maxLines: 2,
//                                   textAlign: TextAlign.center,
//                                   fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
//                                 ),
//                               ),
//                             ),
//                             GridColumn(
//                               columnName: 'solarCostUnitCost',
//                               label: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                 alignment: Alignment.center,
//                                 child:  TextComponent(
//                                   text: 'Cost/\nUnit Price',
//                                   color: AppColors.whiteTextColor,
//                                   fontFamily: boldFontFamily,
//                                   maxLines: 2,
//                                   textAlign: TextAlign.center,
//                                   fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
//                                 ),
//                               ),
//                             ),
//                             GridColumn(
//                               columnName: 'gridEnergy',
//                               label: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                 alignment: Alignment.center,
//                                 child:  TextComponent(
//                                   text: 'Energy',
//                                   color: AppColors.whiteTextColor,
//                                   fontFamily: boldFontFamily,
//                                   maxLines: 2,
//                                   textAlign: TextAlign.center,
//                                   fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
//                                 ),
//                               ),
//                             ),
//                             GridColumn(
//                               columnName: 'gridCostUnitCost',
//                               label: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                 alignment: Alignment.center,
//                                 child:  TextComponent(
//                                   text: 'Cost/\nUnit Price',
//                                   color: AppColors.whiteTextColor,
//                                   fontFamily: boldFontFamily,
//                                   maxLines: 2,
//                                   textAlign: TextAlign.center,
//                                   fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
//                                 ),
//                               ),
//                             ),
//                             GridColumn(
//                               columnName: 'dieselEnergy',
//                               label: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                 alignment: Alignment.center,
//                                 child:  TextComponent(
//                                   text: 'Energy',
//                                   color: AppColors.whiteTextColor,
//                                   fontFamily: boldFontFamily,
//                                   maxLines: 2,
//                                   textAlign: TextAlign.center,
//                                   fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
//                                 ),
//                               ),
//                             ),
//                             GridColumn(
//                               columnName: 'dieselCostUnitCost',
//                               label: Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                 alignment: Alignment.center,
//                                 child:  TextComponent(
//                                   text: 'Cost/\nUnit Price',
//                                   color: AppColors.whiteTextColor,
//                                   fontFamily: boldFontFamily,
//                                   maxLines: 2,
//                                   textAlign: TextAlign.center,
//                                   fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
//                                 ),
//                               ),
//                             ),
//                           ],
//                           stackedHeaderRows: [
//                             StackedHeaderRow(cells: [
//                               StackedHeaderCell(
//                                 columnNames: ['totalEnergy', 'totalCostUnitCost'],
//                                 child: Container(
//                                   color: AppColors.secondaryTextColor,
//                                   alignment: Alignment.center,
//                                   child:  TextComponent(
//                                     text: 'Total',
//                                     color: AppColors.whiteTextColor,
//                                     fontFamily: boldFontFamily,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
//                                   ),
//                                 ),
//                               ),
//                               StackedHeaderCell(
//                                 columnNames: ['solarEnergy', 'solarCostUnitCost'],
//                                 child: Container(
//                                   color: AppColors.secondaryTextColor,
//                                   alignment: Alignment.center,
//                                   child:  TextComponent(
//                                     text: 'Solar',
//                                     color: AppColors.whiteTextColor,
//                                     fontFamily: boldFontFamily,
//                                     fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
//                                   ),
//                                 ),
//                               ),
//                               StackedHeaderCell(
//                                 columnNames: ['gridEnergy', 'gridCostUnitCost'],
//                                 child: Container(
//                                   color: AppColors.secondaryTextColor,
//                                   alignment: Alignment.center,
//                                   child:  TextComponent(
//                                     text: 'Grid',
//                                     color: AppColors.whiteTextColor,
//                                     fontFamily: boldFontFamily,
//                                     fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
//                                   ),
//                                 ),
//                               ),
//                               StackedHeaderCell(
//                                 columnNames: ['dieselEnergy', 'dieselCostUnitCost'],
//                                 child: Container(
//                                   color: AppColors.secondaryTextColor,
//                                   alignment: Alignment.center,
//                                   child:  TextComponent(
//                                     text: 'Diesel',
//                                     color: AppColors.whiteTextColor,
//                                     fontFamily: boldFontFamily,
//                                     fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
//                                   ),
//                                 ),
//                               ),
//                             ]),
//                           ],
//                         ),
//                       ),
//                     );
//                   } else {
//                     return const Center(
//                       child: TextComponent(
//                         text: 'No data available',
//                         color: AppColors.secondaryTextColor,
//                       ),
//                     );
//                   }
//                 },
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
// class FormattedDataGridSource extends DataGridSource {
//   List<DataGridRow> _formattedData = [];
//
//   FormattedDataGridSource(List<FormattedData> data) {
//     _formattedData = data.map<DataGridRow>((source) {
//       return DataGridRow(cells: [
//         DataGridCell<String>(columnName: 'date', value: source.date),
//         DataGridCell<String>(
//           columnName: 'totalEnergy',
//           value: source.totalEnergy.toStringAsFixed(2),
//         ),
//         DataGridCell<String>(
//           columnName: 'totalCostUnitCost',
//           value: '${source.totalCost.toStringAsFixed(2)}/${source.totalCost != 0 && source.totalEnergy != 0 ? (source.totalCost / source.totalEnergy).toStringAsFixed(2) : "N/A"}',
//         ),
//         DataGridCell<String>(
//           columnName: 'solarEnergy',
//           value: source.solarEnergy.toStringAsFixed(2),
//         ),
//         DataGridCell<String>(
//           columnName: 'solarCostUnitCost',
//           value: '${source.solarCost.toStringAsFixed(2)}/${source.solarUnitCost.toStringAsFixed(2)}',
//         ),
//         DataGridCell<String>(
//           columnName: 'gridEnergy',
//           value: source.gridEnergy.toStringAsFixed(2),
//         ),
//         DataGridCell<String>(
//           columnName: 'gridCostUnitCost',
//           value: '${source.gridCost.toStringAsFixed(2)}/${source.gridUnitCost.toStringAsFixed(2)}',
//         ),
//         DataGridCell<String>(
//           columnName: 'dieselEnergy',
//           value: source.dieselEnergy.toStringAsFixed(2),
//         ),
//         DataGridCell<String>(
//           columnName: 'dieselCostUnitCost',
//           value: '${source.dieselCost.toStringAsFixed(2)}/${source.dieselUnitCost.toStringAsFixed(2)}',
//         ),
//       ]);
//     }).toList();
//   }
//
//   @override
//   List<DataGridRow> get rows => _formattedData;
//
//   // @override
//   // DataGridRowAdapter buildRow(DataGridRow row) {
//   //   bool isTotalRow = row.getCells().first.value == 'Total';
//   //   return DataGridRowAdapter(
//   //     cells: row.getCells().map<Widget>((cell) {
//   //       return Container(
//   //         alignment: Alignment.center,
//   //         padding: const EdgeInsets.all(4.0),
//   //         child: TextComponent(
//   //           fontSize: 12,
//   //           text: cell.columnName.contains('Energy')
//   //               ? '${cell.value} kWh'
//   //               : cell.columnName.contains('CostUnitCost')
//   //               ? '${cell.value} ৳'
//   //               : cell.value.toString(),
//   //           textAlign: TextAlign.center,
//   //           color: AppColors.secondaryTextColor,
//   //           fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
//   //           softWrap: true,
//   //           maxLines: 2,
//   //         ),
//   //       );
//   //     }).toList(),
//   //   );
//   // }
//
// /*  @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     // Get the index of the current row
//     int rowIndex = rows.indexOf(row);
//     bool isTotalRow = row.getCells().first.value == 'Total';
//     bool isOddRow = rowIndex % 2 == 1; // Odd-indexed rows (1, 3, 5...) will have no background
//
//     return DataGridRowAdapter(
//       cells: row.getCells().map<Widget>((cell) {
//         return Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(4.0),
//           color: (isOddRow && !isTotalRow)
//               ? null // No background for odd rows (except Total row)
//               : const Color(0xFFE0E1FF), // Background for even rows and Total row
//           child: TextComponent(
//             fontSize: 12,
//             text: cell.columnName.contains('Energy')
//                 ? '${cell.value} kWh'
//                 : cell.columnName.contains('CostUnitCost')
//                 ? '${cell.value} ৳'
//                 : cell.value.toString(),
//             textAlign: TextAlign.center,
//             color: AppColors.secondaryTextColor,
//             fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
//             softWrap: true,
//             maxLines: 2,
//           ),
//         );
//       }).toList(),
//     );
//   }*/
//
//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     // Get the index of the current row
//     int rowIndex = rows.indexOf(row);
//     bool isTotalRow = row.getCells().first.value == 'Total';
//     bool isOddRow = rowIndex % 2 == 1; // Odd-indexed rows (1, 3, 5...) will have no background
//
//     return DataGridRowAdapter(
//       cells: row.getCells().map<Widget>((cell) {
//         return Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(4.0),
//           color: isTotalRow
//               ? const Color(0xFFE6F1FF) // Distinct background color for Total row
//               : (isOddRow && !isTotalRow)
//               ? null // No background for odd rows (except Total row)
//               : const Color(0xFFE0E1FF), // Background for even rows
//           child: TextComponent(
//             fontSize: 12,
//             text: cell.columnName.contains('Energy')
//                 ? '${cell.value}
//                 : cell.columnName.contains('CostUnitCost')
//                 ? '${cell.value} ৳'
//                 : cell.value.toString(),
//             textAlign: TextAlign.center,
//             color: AppColors.secondaryTextColor,
//             fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal, // Already bold for Total row
//
//             softWrap: true,
//             maxLines: 2,
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//
// }




import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column,Row;


import '../../../../../../utility/style/constant.dart' show boldFontFamily, k14TextSize, k8TextSize;
import '../../../controller/over_all_source_data_controller.dart';


class SourceDataController extends GetxController {
  late Future<List<FormattedData>> dataFuture = Future.value([]);
  //DateTime startDate = DateTime.now().subtract(const Duration(days: 1));
  // DateTime endDate = DateTime.now();
  String token = AuthUtilityController.accessToken ?? '';

  @override
  void onInit() {
    super.onInit();


    ever(AuthUtilityController.accessTokenForApiCall, (String? token){
      if(token != null){
        fetchData(
          Get.find<OverAllSourceDataController>().fromDateTEController.text,
          Get.find<OverAllSourceDataController>().toDateTEController.text,
        );
      }
    });


  }

  Future<void> fetchData(String start, String end) async {
    if (AuthUtilityController.accessToken == null) {
      log("[log] Access token is null, cannot fetch data");
      dataFuture = Future.error("Authentication token is missing");
      update();
      return;
    }

    String formattedStart = _formatFromDate(start);
    String formattedEnd = _formatToDate(end);

    log("[log] formattedFromDate: $formattedStart");
    log("[log] formattedToDate: $formattedEnd");

    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/api/filter-overall-source-table-data/?type=electricity'),
        headers: {
          'Authorization': AuthUtilityController.accessToken!,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "start": formattedStart,
          "end": formattedEnd,
        }),
      );

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<FormattedData> formattedData = _formatData(jsonResponse);
        dataFuture = Future.value(formattedData);
        update();
      } else {
        throw Exception('Failed to load source Table data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
      dataFuture = Future.error(e);
      update();
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
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        // Create a new Excel workbook
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'Report';

        // Set column widths for better readability
        sheet.getRangeByIndex(1, 1, 1, 1).columnWidth = 15; // Date
        sheet.getRangeByIndex(1, 2, 1, 2).columnWidth = 20; // Total Energy
        sheet.getRangeByIndex(1, 3, 1, 3).columnWidth = 20; // Total Cost
        sheet.getRangeByIndex(1, 4, 1, 4).columnWidth = 20; // Solar Energy
        sheet.getRangeByIndex(1, 5, 1, 5).columnWidth = 20; // Solar Cost
        sheet.getRangeByIndex(1, 6, 1, 6).columnWidth = 20; // Grid Energy
        sheet.getRangeByIndex(1, 7, 1, 7).columnWidth = 20; // Grid Cost
        sheet.getRangeByIndex(1, 8, 1, 8).columnWidth = 20; // Diesel Energy
        sheet.getRangeByIndex(1, 9, 1, 9).columnWidth = 20; // Diesel Cost

        // Add header row with styling
        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';
        final List<String> headers = [
          'Date',
          'Total Energy (kWh)',
          'Total Cost (৳)',
          'Solar Energy (kWh)',
          'Solar Cost (৳)',
          'Grid Energy (kWh)',
          'Grid Cost (৳)',
          'Diesel Energy (kWh)',
          'Diesel Cost (৳)'
        ];
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
          sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
        }

        // Await the Future to get the actual List<FormattedData>
        final formattedData = await dataFuture;

        // Add data rows
        for (int i = 0; i < formattedData.length; i++) {
          final rowIndex = i + 2; // Start from row 2 (after header)
          final data = formattedData[i];
          sheet.getRangeByIndex(rowIndex, 1).setText(data.date ?? 'N/A');
          sheet.getRangeByIndex(rowIndex, 2).setNumber(data.totalEnergy ?? 0);
          sheet.getRangeByIndex(rowIndex, 3).setNumber(data.totalCost ?? 0);
          sheet.getRangeByIndex(rowIndex, 4).setNumber(data.solarEnergy ?? 0);
          sheet.getRangeByIndex(rowIndex, 5).setNumber(data.solarCost ?? 0);
          sheet.getRangeByIndex(rowIndex, 6).setNumber(data.gridEnergy ?? 0);
          sheet.getRangeByIndex(rowIndex, 7).setNumber(data.gridCost ?? 0);
          sheet.getRangeByIndex(rowIndex, 8).setNumber(data.dieselEnergy ?? 0);
          sheet.getRangeByIndex(rowIndex, 9).setNumber(data.dieselCost ?? 0);
        }

        sheet.autoFitRow(1);

        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (directory.existsSync()) {
            String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
            String filePath =
                "${directory.path}/Energy_Report_$formattedDate $formattedTime.xlsx";

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








  String _formatFromDate(String date) {
    try {
      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
      DateTime startOfDay = DateTime(parsedDate.year, parsedDate.month, parsedDate.day, 0, 0, 0, 0);
      return DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(startOfDay);
    } catch (e) {
      log('Date format error (From Date): $e');
      return date; // Return the original string if parsing fails
    }
  }

  String _formatToDate(String date) {
    try {
      DateTime parsedDate = DateFormat("dd-MM-yyyy").parse(date);
      DateTime endOfDay = DateTime(parsedDate.year, parsedDate.month, parsedDate.day, 23, 59, 59, 999);
      return DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(endOfDay);
    } catch (e) {
      log('Date format error (To Date): $e');
      return date; // Return the original string if parsing fails
    }
  }

  List<FormattedData> _formatData(List<dynamic> rawData) {
    List<FormattedData> dailyData = rawData
        .where((dayData) => dayData.containsKey('date') && dayData.containsKey('sources'))
        .map((dayData) {
      Map<String, double> energyMap = {};
      Map<String, double> costMap = {};
      Map<String, double> unitCostMap = {}; // New map for unit costs
      String date = dayData['date'];

      for (var source in dayData['sources']) {
        String node = source['node'];
        double energy = (source['energy'] as num).toDouble();
        double cost = (source['cost'] as num).toDouble();
        // Safely handle unit_cost, default to 0.0 if missing or null
        double unitCost = (source['unit_cost'] as num?)?.toDouble() ?? 0.0;
        energyMap[node] = energy;
        costMap[node] = cost;
        unitCostMap[node] = unitCost; // Store unit_cost
      }

      return FormattedData(
        date: date,
        totalEnergy: energyMap['Total_Source'] ?? 0,
        totalCost: costMap['Total_Source'] ?? 0,
        solarEnergy: energyMap['Solar'] ?? 0,
        solarCost: costMap['Solar'] ?? 0,
        solarUnitCost: unitCostMap['Solar'] ?? 0, // Assign unit_cost
        gridEnergy: energyMap['Grid'] ?? 0,
        gridCost: costMap['Grid'] ?? 0,
        gridUnitCost: unitCostMap['Grid'] ?? 0, // Assign unit_cost
        dieselEnergy: energyMap['Diesel_Generator'] ?? 0,
        dieselCost: costMap['Diesel_Generator'] ?? 0,
        dieselUnitCost: unitCostMap['Diesel_Generator'] ?? 0, // Assign unit_cost
      );
    }).toList();

    // Handle totals (assuming API doesn't provide unit_cost for totals)
    var totals = rawData.lastWhere((data) => !data.containsKey('date'), orElse: () => {});
    if (totals.isNotEmpty) {
      dailyData.add(FormattedData(
        date: 'Total',
        totalEnergy: (totals['total_source_energy'] as num?)?.toDouble() ?? 0,
        totalCost: (totals['total_source_cost'] as num?)?.toDouble() ?? 0,
        solarEnergy: (totals['total_solar_energy'] as num?)?.toDouble() ?? 0,
        solarCost: (totals['total_solar_cost'] as num?)?.toDouble() ?? 0,
        solarUnitCost: (totals['total_solar_unit_cost'] as num?)?.toDouble() ?? 0, // Use provided unit cost or default
        gridEnergy: (totals['total_grid_energy'] as num?)?.toDouble() ?? 0,
        gridCost: (totals['total_grid_cost'] as num?)?.toDouble() ?? 0,
        gridUnitCost: (totals['total_grid_unit_cost'] as num?)?.toDouble() ?? 0, // Use provided unit cost or default
        dieselEnergy: (totals['total_diesel_energy'] as num?)?.toDouble() ?? 0,
        dieselCost: (totals['total_diesel_cost'] as num?)?.toDouble() ?? 0,
        dieselUnitCost: (totals['total_diesel_unit_cost'] as num?)?.toDouble() ?? 0, // Use provided unit cost or default
      ));
    }

    return dailyData;
  }}

class FormattedData {
  final String date;
  final double totalEnergy;
  final double totalCost;
  final double solarEnergy;
  final double solarCost;
  final double solarUnitCost; // Still needed for calculation/display
  final double gridEnergy;
  final double gridCost;
  final double gridUnitCost;  // Still needed for calculation/display
  final double dieselEnergy;
  final double dieselCost;
  final double dieselUnitCost; // Still needed for calculation/display

  FormattedData({
    required this.date,
    required this.totalEnergy,
    required this.totalCost,
    required this.solarEnergy,
    required this.solarCost,
    required this.solarUnitCost,
    required this.gridEnergy,
    required this.gridCost,
    required this.gridUnitCost,
    required this.dieselEnergy,
    required this.dieselCost,
    required this.dieselUnitCost,
  });
}
final SourceDataController sourceDataController = Get.put(SourceDataController());

class SourceTableWidget extends StatelessWidget {
  final SourceDataController sourceDataController = Get.put(SourceDataController());

  SourceTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              sourceDataController.downloadDataSheet(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0, bottom: 2),
              child: CustomContainer(
                height: size.height * 0.050,
                width: size.width * 0.3,
                borderRadius: BorderRadius.circular(size.height * k8TextSize),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextComponent(text: "Download"),
                      Icon(Icons.download),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        GetBuilder<SourceDataController>(
          init: SourceDataController(),
          builder: (controller) {
            return Expanded(
              child: FutureBuilder<List<FormattedData>>(
                future: controller.dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  Center(child: SpinKitFadingCircle(
                      color: AppColors.primaryColor,
                      size: 50.0,
                    ),);
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: SfDataGridTheme(
                        data: SfDataGridThemeData(
                          headerColor: AppColors.secondaryTextColor,
                          frozenPaneLineColor: AppColors.primaryColor,
                          frozenPaneLineWidth: 1.0,
                          gridLineColor: Colors.grey.shade300,
                          gridLineStrokeWidth: 0.4,
                        ),
                        child: SfDataGrid(
                          headerRowHeight: 47,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          gridLinesVisibility: GridLinesVisibility.both,
                          rowHeight: 35,
                          showHorizontalScrollbar: false,
                          columnWidthMode: size.width > 500 ? ColumnWidthMode.fill : ColumnWidthMode.auto,
                          source: FormattedDataGridSource(snapshot.data!),
                          frozenColumnsCount: 1,
                          footerFrozenRowsCount: 1,
                          columns: [
                            GridColumn(
                              columnName: 'date',
                              label: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                alignment: Alignment.center,
                                child:  TextComponent(
                                  text: 'Date',
                                  color: AppColors.whiteTextColor,
                                  fontFamily: boldFontFamily,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'totalEnergy',
                              label: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                alignment: Alignment.center,
                                child:  TextComponent(
                                  text: 'Energy',
                                  color: AppColors.whiteTextColor,
                                  fontFamily: boldFontFamily,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'totalCostUnitCost',
                              label: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                alignment: Alignment.center,
                                child:  TextComponent(
                                  text: 'Cost/\nUnit Price',
                                  color: AppColors.whiteTextColor,
                                  fontFamily: boldFontFamily,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'solarEnergy',
                              label: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                alignment: Alignment.center,
                                child:  TextComponent(
                                  text: 'Energy',
                                  color: AppColors.whiteTextColor,
                                  fontFamily: boldFontFamily,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'solarCostUnitCost',
                              label: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                alignment: Alignment.center,
                                child:  TextComponent(
                                  text: 'Cost/\nUnit Price',
                                  color: AppColors.whiteTextColor,
                                  fontFamily: boldFontFamily,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'gridEnergy',
                              label: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                alignment: Alignment.center,
                                child:  TextComponent(
                                  text: 'Energy',
                                  color: AppColors.whiteTextColor,
                                  fontFamily: boldFontFamily,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'gridCostUnitCost',
                              label: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                alignment: Alignment.center,
                                child:  TextComponent(
                                  text: 'Cost/\nUnit Price',
                                  color: AppColors.whiteTextColor,
                                  fontFamily: boldFontFamily,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'dieselEnergy',
                              label: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                alignment: Alignment.center,
                                child:  TextComponent(
                                  text: 'Energy',
                                  color: AppColors.whiteTextColor,
                                  fontFamily: boldFontFamily,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
                                ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'dieselCostUnitCost',
                              label: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                alignment: Alignment.center,
                                child:  TextComponent(
                                  text: 'Cost/\nUnit Price',
                                  color: AppColors.whiteTextColor,
                                  fontFamily: boldFontFamily,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
                                ),
                              ),
                            ),
                          ],
                          stackedHeaderRows: [
                            StackedHeaderRow(cells: [
                              StackedHeaderCell(
                                columnNames: ['totalEnergy', 'totalCostUnitCost'],
                                child: Container(
                                  color: AppColors.secondaryTextColor,
                                  alignment: Alignment.center,
                                  child:  TextComponent(
                                    text: 'Total',
                                    color: AppColors.whiteTextColor,
                                    fontFamily: boldFontFamily,
                                    fontWeight: FontWeight.bold,
                                    fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
                                  ),
                                ),
                              ),
                              StackedHeaderCell(
                                columnNames: ['solarEnergy', 'solarCostUnitCost'],
                                child: Container(
                                  color: AppColors.secondaryTextColor,
                                  alignment: Alignment.center,
                                  child:  TextComponent(
                                    text: 'Solar',
                                    color: AppColors.whiteTextColor,
                                    fontFamily: boldFontFamily,
                                    fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
                                  ),
                                ),
                              ),
                              StackedHeaderCell(
                                columnNames: ['gridEnergy', 'gridCostUnitCost'],
                                child: Container(
                                  color: AppColors.secondaryTextColor,
                                  alignment: Alignment.center,
                                  child:  TextComponent(
                                    text: 'Grid',
                                    color: AppColors.whiteTextColor,
                                    fontFamily: boldFontFamily,
                                    fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
                                  ),
                                ),
                              ),
                              StackedHeaderCell(
                                columnNames: ['dieselEnergy', 'dieselCostUnitCost'],
                                child: Container(
                                  color: AppColors.secondaryTextColor,
                                  alignment: Alignment.center,
                                  child:  TextComponent(
                                    text: 'Diesel',
                                    color: AppColors.whiteTextColor,
                                    fontFamily: boldFontFamily,
                                    fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k14TextSize,
                                  ),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: TextComponent(
                        text: 'No data available',
                        color: AppColors.secondaryTextColor,
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
class FormattedDataGridSource extends DataGridSource {
  List<DataGridRow> _formattedData = [];

  FormattedDataGridSource(List<FormattedData> data) {
    _formattedData = data.map<DataGridRow>((source) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'date', value: source.date),
        DataGridCell<String>(
          columnName: 'totalEnergy',
          value: source.totalEnergy.toStringAsFixed(2),
        ),
        DataGridCell<String>(
          columnName: 'totalCostUnitCost',
          value: '${source.totalCost.toStringAsFixed(2)}/${source.totalCost != 0 && source.totalEnergy != 0 ? (source.totalCost / source.totalEnergy).toStringAsFixed(2) : "N/A"}',
        ),
        DataGridCell<String>(
          columnName: 'solarEnergy',
          value: source.solarEnergy.toStringAsFixed(2),
        ),
        DataGridCell<String>(
          columnName: 'solarCostUnitCost',
          value: '${source.solarCost.toStringAsFixed(2)}/${source.solarUnitCost.toStringAsFixed(2)}',
        ),
        DataGridCell<String>(
          columnName: 'gridEnergy',
          value: source.gridEnergy.toStringAsFixed(2),
        ),
        DataGridCell<String>(
          columnName: 'gridCostUnitCost',
          value: '${source.gridCost.toStringAsFixed(2)}/${source.gridUnitCost.toStringAsFixed(2)}',
        ),
        DataGridCell<String>(
          columnName: 'dieselEnergy',
          value: source.dieselEnergy.toStringAsFixed(2),
        ),
        DataGridCell<String>(
          columnName: 'dieselCostUnitCost',
          value: '${source.dieselCost.toStringAsFixed(2)}/${source.dieselUnitCost.toStringAsFixed(2)}',
        ),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _formattedData;

  // @override
  // DataGridRowAdapter buildRow(DataGridRow row) {
  //   bool isTotalRow = row.getCells().first.value == 'Total';
  //   return DataGridRowAdapter(
  //     cells: row.getCells().map<Widget>((cell) {
  //       return Container(
  //         alignment: Alignment.center,
  //         padding: const EdgeInsets.all(4.0),
  //         child: TextComponent(
  //           fontSize: 12,
  //           text: cell.columnName.contains('Energy')
  //               ? '${cell.value} kWh'
  //               : cell.columnName.contains('CostUnitCost')
  //               ? '${cell.value} ৳'
  //               : cell.value.toString(),
  //           textAlign: TextAlign.center,
  //           color: AppColors.secondaryTextColor,
  //           fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
  //           softWrap: true,
  //           maxLines: 2,
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

/*  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    // Get the index of the current row
    int rowIndex = rows.indexOf(row);
    bool isTotalRow = row.getCells().first.value == 'Total';
    bool isOddRow = rowIndex % 2 == 1; // Odd-indexed rows (1, 3, 5...) will have no background

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4.0),
          color: (isOddRow && !isTotalRow)
              ? null // No background for odd rows (except Total row)
              : const Color(0xFFE0E1FF), // Background for even rows and Total row
          child: TextComponent(
            fontSize: 12,
            text: cell.columnName.contains('Energy')
                ? '${cell.value} kWh'
                : cell.columnName.contains('CostUnitCost')
                ? '${cell.value} ৳'
                : cell.value.toString(),
            textAlign: TextAlign.center,
            color: AppColors.secondaryTextColor,
            fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
            softWrap: true,
            maxLines: 2,
          ),
        );
      }).toList(),
    );
  }*/

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    // Get the index of the current row
    int rowIndex = rows.indexOf(row);
    bool isTotalRow = row.getCells().first.value == 'Total';
    bool isOddRow = rowIndex % 2 == 1; // Odd-indexed rows (1, 3, 5...) will have no background

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((cell) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(4.0),
            color: isTotalRow
                ? const Color(0xFFE6F1FF) // Distinct background color for Total row
                : (isOddRow && !isTotalRow)
                ? null // No background for odd rows (except Total row)
                : const Color(0xFFE0E1FF), // Background for even rows
            child: TextComponent(
              fontSize: 12,
              text: cell.columnName.contains('Energy')
                  ? '${cell.value} kWh'
                  : cell.columnName.contains('CostUnitCost')
                  ? '${cell.value} ৳'
                  : cell.value.toString(),
              textAlign: TextAlign.center,
              color: AppColors.secondaryTextColor,
              fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal, // Already bold for Total row

              softWrap: true,
              maxLines: 2,
            ),
          );
        }).toList(),
        );
    }


}