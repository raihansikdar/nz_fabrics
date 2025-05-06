// import 'dart:developer';
// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
// import 'package:nz_fabrics/src/common_widgets/text_component.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/electricity/views/screens/machine_screen/screen/acknowledge_history_screen.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/each_machine_wise_load_live_data_controller.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/each_category_live_data_model.dart';
// import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/power_and_energy_element_details_screen.dart';
// import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
// import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
// import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
// import 'package:nz_fabrics/src/utility/style/app_colors.dart';
// import 'package:nz_fabrics/src/utility/style/constant.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row, Border;
//
// class FormattedWaterData {
//   final String date;
//   final String machine;
//   final double totalEnergy;
//   final double totalCost;
//   final double unitCost;
//
//   FormattedWaterData({
//     required this.date,
//     required this.machine,
//     required this.totalEnergy,
//     required this.totalCost,
//     required this.unitCost,
//   });
// }
//
// class CombinedSteamScreen extends StatefulWidget {
//   const CombinedSteamScreen({super.key});
//
//   @override
//   State<CombinedSteamScreen> createState() => _CombinedSteamScreenState();
// }
//
// class _CombinedSteamScreenState extends State<CombinedSteamScreen> {
//
//   List<DataGridRow> _dataGridRows = [];
//   List<DataGridRow> _filteredRows = [];
//   Map<String, dynamic> _apiData = {};
//   Map<String, bool> _expandState = {};
//   bool _isLoadingTable1 = true;
//   DateTime? _startDate;
//   DateTime? _endDate;
//   Future<List<FormattedWaterData>> dataFuture = Future.value([]);
//   List<String> machineNames = [];
//   bool _isLoadingTable2 = false;
//
//   @override
//   void initState() {
//     super.initState();
//     final today = DateTime.now();
//     _startDate = today;
//     _endDate = today;
//     _fetchAllData();
//   }
//
//   Future<void> _fetchAllData() async {
//     await Future.wait([
//       _fetchApiDataTable1(),
//       _fetchApiDataTable2(),
//     ]);
//   }
//
//   Future<void> _fetchApiDataTable1() async {
//     if (_startDate == null || _endDate == null) {
//       log('Table 1: Start or end date is null');
//       return;
//     }
//
//     final apiUrl1 = '${Urls.baseUrl}/api/filter-machine-view-data/?type=water';
//     final apiUrl2 = '${Urls.baseUrl}/api/filter-acknowledge-data/';
//     final token = AuthUtilityController.accessToken ?? 'Bearer default_token';
//     final body = {
//       "start": _startDate!.toIso8601String().split('T')[0] ?? DateTime.now().toIso8601String().split('T')[0],
//       "end": _endDate!.toIso8601String().split('T')[0] ?? DateTime.now().toIso8601String().split('T')[0],
//     };
//
//     try {
//       if(mounted){
//         setState(() {
//           _isLoadingTable1 = true;
//         });
//       }
//
//       final responses = await Future.wait([
//         http.post(
//           Uri.parse(apiUrl1),
//           headers: {
//             'Authorization': token,
//             'Content-Type': 'application/json',
//           },
//           body: json.encode(body),
//         ),
//         http.post(
//           Uri.parse(apiUrl2),
//           headers: {
//             'Authorization': token,
//             'Content-Type': 'application/json',
//           },
//           body: json.encode(body),
//         ),
//       ]);
//
//       if (responses[0].statusCode == 200 && responses[1].statusCode == 200) {
//         final apiData1 = json.decode(responses[0].body);
//         final apiData2 = json.decode(responses[1].body);
//
//         apiData1.forEach((key, value) {
//           if (value['children'] != null && (value['children'] as List).isNotEmpty) {
//             value['acknowledged'] = true;
//           } else if (apiData2.containsKey(key)) {
//             value['acknowledged'] = _areAllChildrenAcknowledged(apiData2[key]['children']);
//           } else {
//             value['acknowledged'] = false;
//           }
//         });
//         _apiData = apiData1;
//
//         _apiData.forEach((key, value) {
//           if (value['children'] != null && (value['children'] as List).isNotEmpty) {
//             _expandState[key] = false;
//           }
//         });
//
//         if(mounted){
//           setState(() {
//             _dataGridRows = _buildDataGridRows();
//             _filteredRows = _dataGridRows;
//           });
//         }
//       } else {
//         throw Exception('Failed to fetch Table 1 data: ${responses[0].statusCode}, ${responses[1].statusCode}');
//       }
//     } catch (e) {
//       log('Table 1 Error: $e');
//     } finally {
//       if(mounted){
//         setState(() {
//           _isLoadingTable1 = false;
//         });
//       }
//     }
//   }
//
//   bool _areAllChildrenAcknowledged(List<dynamic>? children) {
//     if (children == null || children.isEmpty) return true;
//
//     bool allAcknowledged = children.every((child) =>
//     child['acknowledged'] ?? false || _areAllChildrenAcknowledged(child['children']));
//     bool anyAcknowledged = children.any((child) =>
//     child['acknowledged'] ?? false || _areAllChildrenAcknowledged(child['children']));
//     return allAcknowledged ? true : anyAcknowledged;
//   }
//
//   List<DataGridRow> _buildDataGridRows() {
//     final rows = <DataGridRow>[];
//     _apiData.forEach((key, value) {
//       rows.add(DataGridRow(cells: [
//         DataGridCell<String>(columnName: 'Node', value: key),
//         DataGridCell<bool>(
//             columnName: 'Acknowledged', value: value['acknowledged'] ?? false),
//         DataGridCell<double>(
//             columnName: 'Energy',
//             value: (value['total_volume'] as num?)?.toDouble() ?? 0.0),
//         DataGridCell<double>(
//             columnName: 'Cost',
//             value: (value['total_cost'] as num?)?.toDouble() ?? 0.0),
//       ]));
//     });
//     return rows;
//   }
//
//   Future<void> _fetchApiDataTable2() async {
//     final start = _startDate?.toIso8601String().split('T')[0] ?? '';
//     final end = _endDate?.toIso8601String().split('T')[0] ?? '';
//     if (start.isEmpty || end.isEmpty) {
//       log('Table 2: Start or end date is empty');
//       return;
//     }
//
//     try {
//       if(mounted){
//         setState(() {
//           _isLoadingTable2 = true;
//         });
//       }
//
//       final response = await http.post(
//         Uri.parse('${Urls.baseUrl}/api/filter-perday-machine-view-data/?type=water'),
//         headers: {
//           'Authorization': AuthUtilityController.accessToken ?? '',
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode({
//           "start": start,
//           "end": end,
//         }),
//       );
//
//       log('Table 2 API Status Code: ${response.statusCode}');
//       log('Table 2 API Response: ${response.body}');
//
//       if (response.statusCode == 200) {
//         Map<String, dynamic> jsonResponse = json.decode(response.body);
//         log('Table 2 JSON Response Keys: ${jsonResponse.keys.toList()}');
//
//         if (jsonResponse.isNotEmpty) {
//           if(mounted){
//             setState(() {
//               machineNames = jsonResponse.keys.toList();
//             });
//           }
//           log('Table 2 Machine Names: $machineNames');
//           List<FormattedWaterData> formattedData = _formatData(jsonResponse);
//           log('Table 2 Formatted Data Length: ${formattedData.length}');
//           if(mounted){
//             setState(() {
//               dataFuture = Future.value(formattedData);
//             });
//           }
//         } else {
//           log('Table 2: Empty response');
//           if(mounted){
//             setState(() {
//               dataFuture = Future.value([]);
//               machineNames = ['No machines available'];
//             });
//           }
//         }
//       } else {
//         throw Exception('Failed to load Table 2 data: ${response.statusCode}');
//       }
//     } catch (e) {
//       log('Table 2 Error: $e');
//       if(mounted){
//         setState(() {
//           dataFuture = Future.error(e);
//           if (machineNames.isEmpty) {
//             machineNames = ['No machines available'];
//           }
//         });
//       }
//     } finally {
//       if(mounted){
//         setState(() {
//           _isLoadingTable2 = false;
//         });
//       }
//     }
//   }
//
//   List<FormattedWaterData> _formatData(Map<String, dynamic> rawData) {
//     List<FormattedWaterData> formattedData = [];
//     rawData.forEach((machine, data) {
//       List<dynamic> dailyData = data['daily'] ?? [];
//       for (var day in dailyData) {
//         formattedData.add(FormattedWaterData(
//           date: day['date']?.toString() ?? '',
//           machine: machine,
//           totalEnergy: (day['total_volume'] as num?)?.toDouble() ?? 0.0,
//           totalCost: (day['total_cost'] as num?)?.toDouble() ?? 0.0,
//           unitCost: (day['unit_cost'] as num?)?.toDouble() ?? 0.0,
//         ));
//       }
//     });
//     return formattedData;
//   }
//
//   Future<void> _selectStartDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _startDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != _startDate) {
//       setState(() {
//         _startDate = picked;
//       });
//     }
//   }
//
//   Future<void> _selectEndDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _endDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != _endDate) {
//       setState(() {
//         _endDate = picked;
//       });
//     }
//   }
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
//         final Workbook workbook = Workbook();
//         final Worksheet machineSheet = workbook.worksheets[0];
//         machineSheet.name = 'Day Wise Machine Report';
//
//         final Style headerStyle = workbook.styles.add('HeaderStyle');
//         headerStyle.bold = true;
//         headerStyle.hAlign = HAlignType.center;
//         headerStyle.backColor = '#D9E1F2';
//
//         machineSheet.getRangeByIndex(1, 1).setText('Date');
//         int colIndex = 2;
//         for (var machine in machineNames) {
//           machineSheet.getRangeByIndex(1, colIndex).setText('$machine Water (m³)');
//           machineSheet.getRangeByIndex(1, colIndex + 1).setText('$machine Cost/Unit Cost (৳/(৳/kWh))');
//           colIndex += 2;
//         }
//
//         machineSheet.getRangeByIndex(1, 1, 1, colIndex - 1).cellStyle = headerStyle;
//
//         final formattedData = await dataFuture;
//         Map<String, Map<String, Map<String, double>>> pivotedData = {};
//         Map<String, double> totalEnergyMap = {};
//         Map<String, double> totalCostMap = {};
//
//         for (var data in formattedData) {
//           if (!pivotedData.containsKey(data.date)) {
//             pivotedData[data.date] = {};
//           }
//           pivotedData[data.date]![data.machine] = {
//             'energy': data.totalEnergy,
//             'cost': data.totalCost,
//             'unit_cost': data.unitCost,
//           };
//
//           totalEnergyMap[data.machine] = (totalEnergyMap[data.machine] ?? 0) + data.totalEnergy;
//           totalCostMap[data.machine] = (totalCostMap[data.machine] ?? 0) + data.totalCost;
//         }
//
//         int rowIndex = 2;
//         pivotedData.forEach((date, machines) {
//           machineSheet.getRangeByIndex(rowIndex, 1).setText(date);
//           colIndex = 2;
//           for (var machine in machineNames) {
//             machineSheet.getRangeByIndex(rowIndex, colIndex).setNumber(machines[machine]?['total_volume'] ?? 0);
//             machineSheet.getRangeByIndex(rowIndex, colIndex + 1).setText(
//                 '${(machines[machine]?['cost'] ?? 0).toStringAsFixed(2)}/${(machines[machine]?['unit_cost'] ?? 0).toStringAsFixed(2)}');
//             colIndex += 2;
//           }
//           rowIndex++;
//         });
//
//         machineSheet.getRangeByIndex(rowIndex, 1).setText('Total');
//         colIndex = 2;
//         for (var machine in machineNames) {
//           double totalEnergy = totalEnergyMap[machine] ?? 0;
//           double totalCost = totalCostMap[machine] ?? 0;
//           double unitCost = totalEnergy != 0 ? totalCost / totalEnergy : 0;
//           machineSheet.getRangeByIndex(rowIndex, colIndex).setNumber(totalEnergy);
//           machineSheet.getRangeByIndex(rowIndex, colIndex + 1).setText(
//               '${totalCost.toStringAsFixed(2)}/${unitCost.toStringAsFixed(2)}');
//           colIndex += 2;
//         }
//
//         final Worksheet nodeSheet = workbook.worksheets.add();
//         nodeSheet.name = 'Custom Machine Report';
//
//         nodeSheet.getRangeByIndex(1, 1).setText('Node');
//         nodeSheet.getRangeByIndex(1, 2).setText('Volume (m³)');
//         nodeSheet.getRangeByIndex(1, 3).setText('Cost (৳)');
//
//         nodeSheet.getRangeByIndex(1, 1, 1, 3).cellStyle = headerStyle;
//
//         rowIndex = 2;
//         _apiData.forEach((key, value) {
//           nodeSheet.getRangeByIndex(rowIndex, 1).setText(key);
//           nodeSheet.getRangeByIndex(rowIndex, 2).setNumber((value['total_volume'] as num?)?.toDouble() ?? 0);
//           nodeSheet.getRangeByIndex(rowIndex, 3).setNumber((value['total_cost'] as num?)?.toDouble() ?? 0);
//           rowIndex++;
//
//           if (_expandState[key] == true && value['children'] != null) {
//             final children = value['children'] as List<dynamic>;
//             for (var child in children) {
//               nodeSheet.getRangeByIndex(rowIndex, 1).setText('  • ${child['node']}');
//               nodeSheet.getRangeByIndex(rowIndex, 2).setNumber((child['total_volume'] as num?)?.toDouble() ?? 0);
//               nodeSheet.getRangeByIndex(rowIndex, 3).setNumber((child['total_cost'] as num?)?.toDouble() ?? 0);
//               rowIndex++;
//             }
//           }
//         });
//
//         for (int i = 1; i <= 3; i++) {
//           nodeSheet.autoFitColumn(i);
//         }
//         for (int i = 1; i <= (machineNames.length * 2 + 1); i++) {
//           machineSheet.autoFitColumn(i);
//         }
//
//         if (Platform.isAndroid) {
//           final directory = Directory('/storage/emulated/0/Download');
//           if (await directory.exists()) {
//             String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
//             String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
//             String filePath =
//                 "${directory.path}/Machine_Report_$formattedDate $formattedTime.xlsx";
//
//             final List<int> bytes = workbook.saveAsStream();
//             File(filePath)
//               ..createSync(recursive: true)
//               ..writeAsBytesSync(bytes);
//
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text("File downloaded successfully"),
//                 backgroundColor: AppColors.greenColor,
//                 margin: EdgeInsets.all(16),
//                 behavior: SnackBarBehavior.floating,
//               ),
//             );
//
//             FlutterSmartDownloadDialog.show(
//               context: context,
//               filePath: filePath,
//               dialogType: DialogType.popup,
//             );
//             log("File saved at ==> $filePath");
//           } else {
//             throw Exception("Download directory does not exist");
//           }
//         }
//
//       } catch (e) {
//         log("Error saving Excel file: $e");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Could not save file: $e"),
//             duration: const Duration(seconds: 7),
//             backgroundColor: AppColors.redColor,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } else if (storageStatus == PermissionStatus.permanentlyDenied) {
//       openAppSettings();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.sizeOf(context);
//
//     final table1Source = CustomTreeDataSource(
//       dataGridRows: _filteredRows,
//       apiData: _apiData,
//       expandState: _expandState,
//       onExpandToggle: (parentKey) {
//         setState(() {
//           _expandState[parentKey] = !(_expandState[parentKey] ?? false);
//           _dataGridRows = _buildDataGridRows();
//         });
//       },
//       context: context,
//     );
//
//     final rowHeight = 35.0;
//     final headerHeight = 45.0;
//     final table1Height = (table1Source.rows.length * rowHeight) + headerHeight;
//
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0, right: 8, top: 10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 GestureDetector(
//                   onTap: () => _selectStartDate(context),
//                   child: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     width: size.width / 3.5,
//                     height: size.width > 500 ? size.height * 0.035 : size.height * 0.045,
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Center(
//                       child: Text(
//                         _startDate != null
//                             ? _startDate!.toIso8601String().split('T')[0]
//                             : 'Select Start Date',
//                         style: TextStyle(fontSize: size.width > 500 ? 18 : 16),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8.0),
//                 GestureDetector(
//                   onTap: () => _selectEndDate(context),
//                   child: Container(
//                     width: size.width / 3.5,
//                     height: size.width > 500 ? size.height * 0.035 : size.height * 0.045,
//                     padding: const EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     child: Center(
//                       child: Text(
//                         _endDate != null
//                             ? _endDate!.toIso8601String().split('T')[0]
//                             : 'Select End Date',
//                         style: TextStyle(fontSize: size.width > 500 ? 18 : 16),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 4.0),
//                 GestureDetector(
//                   onTap: _fetchAllData,
//                   child: Container(
//                     width: size.width / 4.9,
//                     height: size.width > 500 ? size.height * 0.035 : size.height * 0.045,
//                     decoration: BoxDecoration(
//                       color: AppColors.secondaryTextColor,
//                       borderRadius: BorderRadius.circular(size.height * k8TextSize),
//                     ),
//                     child: Center(
//                       child: TextComponent(
//                         text: 'Submit',
//                         color: AppColors.whiteTextColor,
//                         fontSize: size.width > 500 ? size.width * 0.025 : size.width * 0.035,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 4.0),
//                 GestureDetector(
//                   onTap: () => downloadDataSheet(context),
//                   child: SvgPicture.asset(
//                     AssetsPath.downloadIconSVG,
//                     height: 25,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _isLoadingTable1
//               ? const Center(
//             child: Padding(
//               padding: EdgeInsets.only(top: 250.0),
//               child: SpinKitFadingCircle(
//                 color: AppColors.primaryColor,
//                 size: 50.0,
//               ),
//             ),
//           )
//               : Column(
//             children: [
//               Container(
//                 height: table1Height,
//                 margin: const EdgeInsets.all(8.0),
//                 clipBehavior: Clip.antiAlias,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   color: Colors.white,
//                 ),
//                 child: SfDataGridTheme(
//                   data: SfDataGridThemeData(
//                     headerColor: AppColors.secondaryTextColor,
//                   ),
//                   child: SfDataGrid(
//                     source: table1Source,
//                     columns: _buildTable1Columns(size),
//                     gridLinesVisibility: GridLinesVisibility.both,
//                     headerGridLinesVisibility: GridLinesVisibility.both,
//                     columnWidthMode: ColumnWidthMode.fill,
//                     rowHeight: rowHeight,
//                     headerRowHeight: headerHeight,
//                     shrinkWrapRows: true,
//                     isScrollbarAlwaysShown: false,
//                     verticalScrollPhysics: const NeverScrollableScrollPhysics(),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 70,top: 10),
//                 clipBehavior: Clip.antiAlias,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.white,
//                 ),
//                 child: FutureBuilder<List<FormattedWaterData>>(
//                   future: dataFuture,
//                   builder: (context, snapshot) {
//                     log('Table 2 FutureBuilder State: ${snapshot.connectionState}');
//                     if (snapshot.hasData) {
//                       log('Table 2 Data Length: ${snapshot.data!.length}');
//                     }
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 20.0,),
//                           child: SpinKitFadingCircle(
//                             color: AppColors.primaryColor,
//                             size: 50.0,
//                           ),
//                         ),
//                       );
//                     } else if (snapshot.hasError) {
//                       log('Table 2 Error: ${snapshot.error}');
//                       return Center(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 20.0),
//                           child: Text('Error: ${snapshot.error}'),
//                         ),
//                       );
//                     } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//                       final table2Source = MachineDataGridSource(snapshot.data!, machineNames);
//                       log('Table 2 Source Rows: ${table2Source.rows.length}');
//                       return SfDataGridTheme(
//                         data: SfDataGridThemeData(
//                             headerColor: AppColors.secondaryTextColor,
//                             frozenPaneLineColor: AppColors.primaryColor,
//                             frozenPaneLineWidth: 1.0,
//                             gridLineColor: Colors.grey.shade700,
//                             gridLineStrokeWidth: 0.4,
//                             columnDragIndicatorColor: Colors.red,
//                             columnDragIndicatorStrokeWidth: 2
//                         ),
//                         child: SfDataGrid(
//                           //   selectionMode: SelectionMode.multiple,
//                           source: table2Source,
//                           columns: _buildTable2Columns(size),
//                           stackedHeaderRows: _buildStackedHeaders(size),
//                           gridLinesVisibility: GridLinesVisibility.both,
//                           headerGridLinesVisibility: GridLinesVisibility.both,
//                           columnWidthMode: ColumnWidthMode.auto,
//                           rowHeight: rowHeight,
//                           headerRowHeight: headerHeight,
//                           frozenColumnsCount: 1,
//                           footerFrozenRowsCount: 1,
//                           allowSorting: false,
//                           allowSwiping: false,
//                           horizontalScrollPhysics: const ClampingScrollPhysics(),
//                           verticalScrollPhysics: const NeverScrollableScrollPhysics(),
//                           defaultColumnWidth: 100.0,
//                           shrinkWrapRows: true,
//                           highlightRowOnHover: false,
//                           showHorizontalScrollbar: false,
//                           onCellTap: (details) {
//                             if (details.rowColumnIndex.rowIndex == table2Source.rows.length - 1) {
//                               return;
//                             }
//                           },
//                         ),
//                       );
//                     } else {
//                       log('Table 2: No data available');
//                       return const Center(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 20.0),
//                           child: TextComponent(
//                             text: 'No data available for Table 2',
//                             color: AppColors.secondaryTextColor,
//                           ),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//
//   }
//
//   List<GridColumn> _buildTable1Columns(Size size) {
//     return [
//       GridColumn(
//         // width: 130,
//         width: 157,
//         columnName: 'Node',
//         label: Container(
//           alignment: Alignment.centerLeft,
//           padding: const EdgeInsets.all(12),
//           child: Text(
//             'Node',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: AppColors.whiteTextColor,
//               fontSize: size.width > 500 ? size.height * k12TextSize : size.height * k13TextSize,
//             ),
//           ),
//         ),
//       ),
//       GridColumn(
//         width: 32,
//         columnName: 'Acknowledged',
//         label: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(4),
//           child: Text(
//             'Ack',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: AppColors.whiteTextColor,
//               fontSize: size.width > 500 ? size.height * k12TextSize : size.height * k13TextSize,
//             ),
//           ),
//         ),
//       ),
//       GridColumn(
//         columnName: 'Energy',
//         label: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(12),
//           child: Text(
//             'Volume',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: AppColors.whiteTextColor,
//               fontSize: size.width > 500 ? size.height * k12TextSize : size.height * k13TextSize,
//             ),
//           ),
//         ),
//       ),
//       GridColumn(
//         columnName: 'Cost',
//         label: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(12),
//           child: Text(
//             'Cost',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: AppColors.whiteTextColor,
//               fontSize: size.width > 500 ? size.height * k12TextSize : size.height * k13TextSize,
//             ),
//           ),
//         ),
//       ),
//     ];
//   }
//
//   List<GridColumn> _buildTable2Columns(Size size) {
//     List<GridColumn> columns = [
//       GridColumn(
//         columnName: 'date',
//         label: Container(
//           padding: const EdgeInsets.all(8.0),
//           alignment: Alignment.center,
//           child: TextComponent(
//             text: 'Date',
//             color: AppColors.whiteTextColor,
//             fontFamily: boldFontFamily,
//             fontSize: size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
//           ),
//         ),
//       ),
//     ];
//
//     for (var machine in machineNames) {
//       columns.addAll([
//         GridColumn(
//           columnName: '${machine}_energy',
//           label: Container(
//             padding: const EdgeInsets.all(8.0),
//             alignment: Alignment.center,
//             child: TextComponent(
//               text: 'Volume',
//               color: AppColors.whiteTextColor,
//               fontFamily: boldFontFamily,
//               fontSize: size.width > 500 ? size.height * k12TextSize : size.height * k14TextSize,
//             ),
//           ),
//         ),
//         GridColumn(
//           columnName: '${machine}_cost_per_unit',
//           label: Container(
//             padding: const EdgeInsets.all(8.0),
//             alignment: Alignment.center,
//             child: TextComponent(
//               text: 'Cost/Unit Cost',
//               color: AppColors.whiteTextColor,
//               fontFamily: boldFontFamily,
//               fontSize: size.width > 500 ? size.height * k12TextSize : size.height * k14TextSize,
//             ),
//           ),
//         ),
//       ]);
//     }
//     log('Table 2 Columns Count: ${columns.length}');
//     return columns;
//   }
//
//   List<StackedHeaderRow> _buildStackedHeaders(Size size) {
//     List<StackedHeaderCell> cells = [];
//     for (var machine in machineNames) {
//       cells.add(StackedHeaderCell(
//         columnNames: ['${machine}_energy', '${machine}_cost_per_unit'],
//         child: Container(
//           color: AppColors.secondaryTextColor,
//           alignment: Alignment.center,
//           child: TextComponent(
//             text: machine.replaceAll('_', ' '),
//             color: AppColors.whiteTextColor,
//             fontFamily: boldFontFamily,
//             fontSize: size.width > 500 ? size.height * k12TextSize : size.height * k14TextSize,
//           ),
//         ),
//       ));
//     }
//     log('Table 2 Stacked Header Cells: ${cells.length}');
//     return [StackedHeaderRow(cells: cells)];
//   }
// }
//
// class CustomTreeDataSource extends DataGridSource {
//   CustomTreeDataSource({
//     required List<DataGridRow> dataGridRows,
//     required this.apiData,
//     required this.onExpandToggle,
//     required this.expandState,
//     required this.context,
//   }) : _dataGridRows = dataGridRows;
//
//   final Map<String, dynamic> apiData;
//   final Function(String parentKey) onExpandToggle;
//   final Map<String, bool> expandState;
//   final List<DataGridRow> _dataGridRows;
//   final BuildContext context;
//
//   @override
//   List<DataGridRow> get rows {
//     List<DataGridRow> rows = [];
//     apiData.forEach((key, value) {
//       rows.add(DataGridRow(cells: [
//         DataGridCell<String>(columnName: 'Node', value: key),
//         DataGridCell<bool>(
//             columnName: 'Acknowledged', value: value['acknowledged'] ?? false),
//         DataGridCell<double>(
//             columnName: 'Energy',
//             value: (value['total_volume'] as num?)?.toDouble() ?? 0.0),
//         DataGridCell<double>(
//             columnName: 'Cost',
//             value: (value['total_cost'] as num?)?.toDouble() ?? 0.0),
//       ]));
//
//       if (expandState[key] == true && value['children'] != null) {
//         final children = value['children'] as List<dynamic>;
//         for (var child in children) {
//           rows.add(DataGridRow(cells: [
//             DataGridCell<String>(
//                 columnName: 'Node', value: '  • ${child['node']}'),
//             DataGridCell<bool>(
//                 columnName: 'Acknowledged',
//                 value: child['acknowledged'] ?? false),
//             DataGridCell<double>(
//                 columnName: 'Energy',
//                 value: (child['total_volume'] as num?)?.toDouble() ?? 0.0),
//             DataGridCell<double>(
//                 columnName: 'Cost',
//                 value: (child['total_cost'] as num?)?.toDouble() ?? 0.0),
//           ]));
//         }
//       }
//     });
//     return rows;
//   }
//
//
//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     final node = row.getCells()[0].value as String;
//     final isParentNode = !node.contains('•');
//     final hasChildren = apiData[node.trim()]?['children'] != null &&
//         (apiData[node.trim()]?['children'] as List).isNotEmpty;
//
//     bool isAcknowledged = row.getCells()[1].value;
//
//     String iconPath = isParentNode
//         ? (isAcknowledged ? AssetsPath.imgIconPNG : AssetsPath.imgIconPNG)
//         : (isAcknowledged
//         ? AssetsPath.twitch1IconPNG
//         : AssetsPath.twitchIconPNG);
//
//     return DataGridRowAdapter(cells: [
//       GestureDetector(
//         onTap: () {
//           if (isParentNode && hasChildren) {
//             onExpandToggle(node.trim());
//             String cleanNodeName = node.replaceAll('•', '').trim();
//             Get.find<EachMachineWiseLoadLiveDataController>()
//                 .fetchEachCategoryLiveData(categoryName: cleanNodeName);
//           }
//           if (!isParentNode) {
//             String cleanNodeName = node.replaceAll('•', '').trim();
//             log(cleanNodeName);
//             Navigator.push(
//               context,
//               PageRouteBuilder(
//                 pageBuilder: (context, animation, secondaryAnimation) =>
//                     GetBuilder<EachMachineWiseLoadLiveDataController>(
//                       builder: (controller) {
//                         final nodeName = cleanNodeName;
//                         var nodeData = controller.eachMachineWiseLoadDataList
//                             .firstWhere(
//                               (data) => data?.node == nodeName,
//                           orElse: () => EachCategoryLiveDataModel(),
//                         );
//                         log("---->${nodeData.power}");
//                         return PowerAndEnergyElementDetailsScreen(
//                           elementName: nodeName,
//                           gaugeValue: nodeData.power ?? 0.0,
//                           gaugeUnit: 'kW',
//                           elementCategory: 'Power',
//                           solarCategory: nodeName,
//                         );
//                       },
//                     ),
//                 transitionsBuilder:
//                     (context, animation, secondaryAnimation, child) {
//                   return FadeTransition(
//                     opacity: animation,
//                     child: child,
//                   );
//                 },
//                 transitionDuration: const Duration(milliseconds: 0),
//               ),
//             );
//           }
//         },
//         child: Container(
//           alignment: Alignment.centerLeft,
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               if (isParentNode && hasChildren)
//                 Icon(
//                   expandState[node.trim()] == true
//                       ? Icons.arrow_drop_down
//                       : Icons.arrow_right,
//                   size: 20,
//                   color: Colors.grey,
//                 ),
//               Expanded(
//                 child: Text(
//                   node,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       GestureDetector(
//         onTap: () {
//           if (!isParentNode) {
//             String cleanNodeName = node.replaceAll('•', '').trim();
//             log(cleanNodeName);
//             Get.to(() => AcKnowledgeHistoryScreen(nodeName: cleanNodeName),
//                 transition: Transition.fadeIn,
//                 duration: const Duration(seconds: 0));
//           }
//         },
//         child: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(8.0),
//           child: Image.asset(
//             iconPath,
//             width: 24,
//             height: 24,
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//       Container(
//         alignment: Alignment.center,
//         padding: const EdgeInsets.all(4.0),
//         child: Text(
//           _formatDouble(row.getCells()[2].value, unit: 'm³', unitFirst: false),
//           style: const TextStyle(fontSize: 12),
//         ),
//       ),
//       Container(
//         alignment: Alignment.center,
//         padding: const EdgeInsets.all(4.0),
//         child: Text(
//           _formatDouble(row.getCells()[3].value, unit: '৳', unitFirst: true),
//           style: const TextStyle(fontSize: 12),
//         ),
//       ),
//     ]);
//   }
//
//   String _formatDouble(dynamic value, {String? unit, required bool unitFirst}) {
//     if (value is double || value is num) {
//       String formatted = value.toStringAsFixed(2);
//       if (unit != null) {
//         return unitFirst ? '$unit$formatted' : '$formatted $unit';
//       }
//       return formatted;
//     }
//     return '0.00';
//   }
//
//
// }
//
// class MachineDataGridSource extends DataGridSource {
//   List<DataGridRow> _formattedData = [];
//   final List<String> machineNames;
//
//   MachineDataGridSource(List<FormattedWaterData> data, this.machineNames) {
//     // Initialize data structures
//     Map<String, Map<String, Map<String, String>>> pivotedData = {};
//     Map<String, double> totalEnergyMap = {for (var machine in machineNames) machine: 0.0};
//     Map<String, double> totalCostMap = {for (var machine in machineNames) machine: 0.0};
//
//     // Pivot the data and calculate totals
//     for (var item in data) {
//       if (!pivotedData.containsKey(item.date)) {
//         pivotedData[item.date] = {};
//       }
//       pivotedData[item.date]![item.machine] = {
//         'energy': item.totalEnergy.toStringAsFixed(2),
//         'cost': item.totalCost.toStringAsFixed(2),
//         'unit_cost': item.unitCost.toStringAsFixed(2),
//       };
//
//       totalEnergyMap[item.machine] = (totalEnergyMap[item.machine] ?? 0) + item.totalEnergy;
//       totalCostMap[item.machine] = (totalCostMap[item.machine] ?? 0) + item.totalCost;
//     }
//
//     // Build rows for pivoted data
//     _formattedData = pivotedData.entries.map((entry) {
//       List<DataGridCell> cells = [
//         DataGridCell<String>(columnName: 'date', value: entry.key),
//       ];
//
//       for (var machine in machineNames) {
//         final machineData = entry.value[machine] ?? {
//           'energy': '0.00',
//           'cost': '0.00',
//           'unit_cost': '0.00',
//         };
//         cells.addAll([
//           DataGridCell<String>(
//             columnName: '${machine}_energy',
//             value: machineData['energy']!,
//           ),
//           DataGridCell<String>(
//             columnName: '${machine}_cost_per_unit',
//             value: '${machineData['cost']!}/${machineData['unit_cost']!}',
//           ),
//         ]);
//       }
//       return DataGridRow(cells: cells);
//     }).toList();
//
//     // Build totals row
//     List<DataGridCell> totalCells = [
//       const DataGridCell<String>(columnName: 'date', value: 'Total'),
//     ];
//     for (var machine in machineNames) {
//       final totalEnergy = totalEnergyMap[machine] ?? 0.0;
//       final totalCost = totalCostMap[machine] ?? 0.0;
//       final unitCost = totalEnergy != 0 ? totalCost / totalEnergy : 0.0;
//       totalCells.addAll([
//         DataGridCell<String>(
//           columnName: '${machine}_energy',
//           value: totalEnergy.toStringAsFixed(2),
//         ),
//         DataGridCell<String>(
//           columnName: '${machine}_cost_per_unit',
//           value: '${totalCost.toStringAsFixed(2)}/${unitCost.toStringAsFixed(2)}',
//         ),
//       ]);
//     }
//     _formattedData.add(DataGridRow(cells: totalCells));
//   }
//
//   @override
//   List<DataGridRow> get rows => _formattedData;
//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     // Get the index of the current row
//     int rowIndex = rows.indexOf(row);
//     bool isTotalRow = row.getCells().first.value == 'Total';
//     bool isOddRow = rowIndex % 2 == 1; // Odd-indexed rows (1, 3, 5...) will have no background
//
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((cell) {
//           return Container(
//             alignment: Alignment.center,
//             padding: const EdgeInsets.all(4.0),
//             color: isTotalRow
//                 ? const Color(0xFFE6F1FF) // Apply specified background color for cost_per_unit cells
//                 : (isOddRow )
//                 ? null // No background for odd rows (except Total row)
//                 : const Color(0xFFE0E1FF), // Light gray background for even rows and Total row
//             child: Text(
//               cell.columnName.endsWith('_energy')
//                   ? '${cell.value} m³'
//                   : cell.columnName.endsWith('_cost_per_unit')
//                   ? '৳${cell.value}'
//                   : cell.value.toString(),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: const Color(0xFF04063E), // Apply specified text color for all cells
//                 fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
//               ),
//               softWrap: true,
//               maxLines: 2,
//             ),
//           );
//         }).toList(),
//         );
//     }
// }


import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';

class CombinedSteamScreen extends StatelessWidget {
  const CombinedSteamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextComponent(text: "No Data Available now",color: AppColors.secondaryTextColor,),
      ),
    );
  }
}



