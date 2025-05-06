import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;

class FormattedShedData {
  final String date;
  final String shed;
  final double totalEnergy;
  final double totalCost;
  final double unitCost;

  FormattedShedData({
    required this.date,
    required this.shed,
    required this.totalEnergy,
    required this.totalCost,
    required this.unitCost,
  });
}

class ShedDataPage extends StatefulWidget {
  const ShedDataPage({Key? key}) : super(key: key);

  @override
  State<ShedDataPage> createState() => _ShedDataPageState();
}

class _ShedDataPageState extends State<ShedDataPage> {
  // final TextEditingController fromDateTEController = TextEditingController(text: '2025-03-09');
  // final TextEditingController toDateTEController = TextEditingController(text: '2025-03-10');
  final TextEditingController fromDateTEController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1))),
  );
  final TextEditingController toDateTEController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );

  Future<List<FormattedShedData>> dataFuture = Future.value([]);
 // final String token = 'd735b54f93b7c29835f47b445bbe7eaa722b64ad';
  final String token = '${AuthUtilityController.accessToken}';
  List<String> shedNames = []; // Dynamic shed names
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData(fromDateTEController.text, toDateTEController.text);
  }

  @override
  void dispose() {
    fromDateTEController.dispose();
    toDateTEController.dispose();
    super.dispose();
  }

  Future<void> fetchData(String start, String end) async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/api/filter-perday-shedwise-view-data/'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "start": start,
          "end": end,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          shedNames = jsonResponse.keys.toList();
          List<FormattedShedData> formattedData = _formatData(jsonResponse);

          setState(() {
            dataFuture = Future.value(formattedData);
          });
        } else {
          throw Exception('Empty response received');
        }
      } else {
        throw Exception('Failed to load shed data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
      setState(() {
        dataFuture = Future.error(e);
        if (shedNames.isEmpty) {
          shedNames = ['No sheds available'];
        }
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<FormattedShedData> _formatData(Map<String, dynamic> rawData) {
    List<FormattedShedData> formattedData = [];
    rawData.forEach((shed, data) {
      List<dynamic> dailyData = data['daily'];
      for (var day in dailyData) {
        formattedData.add(FormattedShedData(
          date: day['date'],
          shed: shed,
          totalEnergy: (day['total_energy'] as num).toDouble(),
          totalCost: (day['total_cost'] as num).toDouble(),
          unitCost: (day['unit_cost'] as num).toDouble(),
        ));
      }
    });
    return formattedData;
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
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'Shed Report';

        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        sheet.getRangeByIndex(1, 1).setText('Date');
        int colIndex = 2;
        for (var shed in shedNames) {
          sheet.getRangeByIndex(1, colIndex).setText('$shed Energy (kWh)');
          sheet.getRangeByIndex(1, colIndex + 1).setText('$shed Cost (৳)');
          colIndex += 2;
        }

        final formattedData = await dataFuture;
        Map<String, Map<String, Map<String, double>>> pivotedData = {};
        Map<String, double> totalEnergyMap = {};
        Map<String, double> totalCostMap = {};

        for (var data in formattedData) {
          if (!pivotedData.containsKey(data.date)) {
            pivotedData[data.date] = {};
          }
          pivotedData[data.date]![data.shed] = {
            'energy': data.totalEnergy,
            'cost': data.totalCost,
          };

          totalEnergyMap[data.shed] = (totalEnergyMap[data.shed] ?? 0) + data.totalEnergy;
          totalCostMap[data.shed] = (totalCostMap[data.shed] ?? 0) + data.totalCost;
        }

        int rowIndex = 2;
        pivotedData.forEach((date, sheds) {
          sheet.getRangeByIndex(rowIndex, 1).setText(date);
          colIndex = 2;
          for (var shed in shedNames) {
            sheet.getRangeByIndex(rowIndex, colIndex).setNumber(sheds[shed]?['energy'] ?? 0);
            sheet.getRangeByIndex(rowIndex, colIndex + 1).setNumber(sheds[shed]?['cost'] ?? 0);
            colIndex += 2;
          }
          rowIndex++;
        });

        sheet.getRangeByIndex(rowIndex, 1).setText('Total');
        colIndex = 2;
        for (var shed in shedNames) {
          sheet.getRangeByIndex(rowIndex, colIndex).setNumber(totalEnergyMap[shed] ?? 0);
          sheet.getRangeByIndex(rowIndex, colIndex + 1).setNumber(totalCostMap[shed] ?? 0);
          colIndex += 2;
        }

        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (directory.existsSync()) {
            String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
            String filePath = "${directory.path}/Shed_Report_$formattedDate $formattedTime.xlsx";

            final List<int> bytes = workbook.saveAsStream();
            File(filePath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(bytes);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("File downloaded successfully"),
                backgroundColor: AppColors.greenColor,
                margin: const EdgeInsets.all(16),
                behavior: SnackBarBehavior.floating,
              ),
            );

            FlutterSmartDownloadDialog.show(
              context: context,
              filePath: filePath,
              dialogType: DialogType.popup,
            );
            log("File saved at ==> $filePath");
          }
        }
      } catch (e) {
        log("Error saving Excel file: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not save file: $e"),
            duration: const Duration(seconds: 7),
            backgroundColor: AppColors.redColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else if (storageStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _parseDate(controller.text) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  DateTime? _parseDate(String dateStr) {
    try {
      return DateFormat('yyyy-MM-dd').parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDateFilterSection(context),
        Expanded(
          child: _buildShedTableWidget(context),
        ),
      ],
    );
  }

  Widget _buildDateFilterSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              _buildDateField(
                context,
                'Start Date',
                fromDateTEController,
              ),
              const SizedBox(width: 16),
              _buildDateField(
                context,
                'End Date',
                toDateTEController,
              ),
              const SizedBox(width: 16),
              _buildSubmitButton(context),
              const SizedBox(width: 8),
              // IconButton(
              //   icon: const Icon(Icons.download),
              //   onPressed: () => downloadDataSheet(context),
              //   tooltip: 'Download Report',
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(BuildContext context, String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextComponent(
          text: label,
          fontSize: 12,
          color: AppColors.secondaryTextColor,
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => _selectDate(context, controller),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Text(
                  controller.text,
                  style: const TextStyle(fontSize: 14),
                ),
                const Icon(Icons.calendar_today, size: 18, color: AppColors.secondaryTextColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return GestureDetector(
        onTap:   isLoading ? null : () => fetchData(
          fromDateTEController.text,
          toDateTEController.text,
        ),
        child: Container(
          width: 70,
          height: 30,
          color: AppColors.greyColor,
          child:  isLoading ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Center(child: const Text('Submit')),
        ),
      );
  }

  Widget _buildShedTableWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<List<FormattedShedData>>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Container(
            margin: const EdgeInsets.all(16),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                      headerColor: AppColors.secondaryTextColor,
                    ),
                    child: SfDataGrid(
                      headerRowHeight: size.width > 500 ? 58 : 40,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      gridLinesVisibility: GridLinesVisibility.both,
                      rowHeight: size.width > 500 ? size.height * 0.03 : size.height * 0.037,
                      columnWidthMode: ColumnWidthMode.auto,
                      source: ShedDataGridSource(snapshot.data!, shedNames),
                      frozenColumnsCount: 1,
                      footerFrozenRowsCount: 1,
                      columns: _buildColumns(size),
                      stackedHeaderRows: _buildStackedHeaders(size),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: ElevatedButton(
                //     onPressed: () => downloadDataSheet(context),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColors.secondaryTextColor,
                //     ),
                //     child: const Text('Download Report'),
                //   ),
                // ),
              ],
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
    );
  }

  List<GridColumn> _buildColumns(Size size) {
    List<GridColumn> columns = [
      GridColumn(
        columnName: 'date',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: TextComponent(
            text: 'Date',
            color: AppColors.whiteTextColor,
            fontFamily: boldFontFamily,
            fontSize: size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
          ),
        ),
      ),
    ];

    for (var shed in shedNames) {
      columns.addAll([
        GridColumn(
          columnName: '${shed}_energy',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextComponent(
              text: 'Energy',
              color: AppColors.whiteTextColor,
              fontFamily: boldFontFamily,
              fontSize: size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
            ),
          ),
        ),
        GridColumn(
          columnName: '${shed}_cost',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextComponent(
              text: 'Cost/Unit',
              color: AppColors.whiteTextColor,
              fontFamily: boldFontFamily,
              fontSize: size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
            ),
          ),
        ),
      ]);
    }
    return columns;
  }

  List<StackedHeaderRow> _buildStackedHeaders(Size size) {
    List<StackedHeaderCell> cells = [];
    for (var shed in shedNames) {
      cells.add(StackedHeaderCell(
        columnNames: ['${shed}_energy', '${shed}_cost'],
        child: Container(
          color: AppColors.secondaryTextColor,
          alignment: Alignment.center,
          child: TextComponent(
            text: shed,
            color: AppColors.whiteTextColor,
            fontFamily: boldFontFamily,
            fontSize: size.width > 500 ? size.height * k13TextSize : size.height * k14TextSize,
          ),
        ),
      ));
    }
    return [StackedHeaderRow(cells: cells)];
  }
}

class ShedDataGridSource extends DataGridSource {
  List<DataGridRow> _formattedData = [];
  final List<String> shedNames;

  ShedDataGridSource(List<FormattedShedData> data, this.shedNames) {
    Map<String, Map<String, Map<String, String>>> pivotedData = {};
    Map<String, double> totalEnergyMap = {};
    Map<String, double> totalCostMap = {};

    for (var item in data) {
      if (!pivotedData.containsKey(item.date)) {
        pivotedData[item.date] = {};
      }
      pivotedData[item.date]![item.shed] = {
        'energy': item.totalEnergy.toStringAsFixed(2),
        'cost': '${item.totalCost.toStringAsFixed(0)}/${item.unitCost.toStringAsFixed(2)}',
      };

      totalEnergyMap[item.shed] = (totalEnergyMap[item.shed] ?? 0) + item.totalEnergy;
      totalCostMap[item.shed] = (totalCostMap[item.shed] ?? 0) + item.totalCost;
    }

    _formattedData = pivotedData.entries.map((entry) {
      List<DataGridCell> cells = [
        DataGridCell<String>(columnName: 'date', value: entry.key),
      ];

      for (var shed in shedNames) {
        cells.addAll([
          DataGridCell<String>(
            columnName: '${shed}_energy',
            value: entry.value[shed]?['energy'] ?? '0.00',
          ),
          DataGridCell<String>(
            columnName: '${shed}_cost',
            value: entry.value[shed]?['cost'] ?? '0/0.00',
          ),
        ]);
      }
      return DataGridRow(cells: cells);
    }).toList();

    List<DataGridCell> totalCells = [
      const DataGridCell<String>(columnName: 'date', value: 'Total'),
    ];
    for (var shed in shedNames) {
      double totalEnergy = totalEnergyMap[shed] ?? 0;
      double totalCost = totalCostMap[shed] ?? 0;
      double unitCost = totalEnergy != 0 ? totalCost / totalEnergy : 0;
      totalCells.addAll([
        DataGridCell<String>(
          columnName: '${shed}_energy',
          value: totalEnergy.toStringAsFixed(2),
        ),
        DataGridCell<String>(
          columnName: '${shed}_cost',
          value: '${totalCost.toStringAsFixed(0)}/${unitCost.toStringAsFixed(2)}',
        ),
      ]);
    }
    _formattedData.add(DataGridRow(cells: totalCells));
  }

  @override
  List<DataGridRow> get rows => _formattedData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    bool isTotalRow = row.getCells().first.value == 'Total';
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4.0),
          child: TextComponent(
            fontSize: 12,
            text: cell.columnName.endsWith('_energy')
                ? '${cell.value} kWh'
                : cell.columnName.endsWith('_cost')
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
  }
}