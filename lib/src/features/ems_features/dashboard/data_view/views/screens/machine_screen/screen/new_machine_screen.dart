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

class FormattedMachineData {
  final String date;
  final String machine;
  final double totalEnergy;
  final double totalCost;
  final double unitCost;

  FormattedMachineData({
    required this.date,
    required this.machine,
    required this.totalEnergy,
    required this.totalCost,
    required this.unitCost,
  });
}

class MachineDataPage extends StatefulWidget {
  const MachineDataPage({Key? key}) : super(key: key);

  @override
  State<MachineDataPage> createState() => _MachineDataPageState();
}

class _MachineDataPageState extends State<MachineDataPage> {
  // final TextEditingController fromDateTEController = TextEditingController(text: '2025-03-09');
  // final TextEditingController toDateTEController = TextEditingController(text: '2025-03-10');


  final TextEditingController fromDateTEController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1))),
  );
  final TextEditingController toDateTEController = TextEditingController(
    text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );

  Future<List<FormattedMachineData>> dataFuture = Future.value([]);
  final String token = '${AuthUtilityController.accessToken}';
  //final String token = 'd735b54f93b7c29835f47b445bbe7eaa722b64ad';
  List<String> machineNames = []; // Dynamic machine names
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
        Uri.parse('${Urls.baseUrl}/api/filter-perday-machine-view-data/'),
        headers: {
          'Authorization': "${token}",
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
          machineNames = jsonResponse.keys.toList();
          List<FormattedMachineData> formattedData = _formatData(jsonResponse);

          setState(() {
            dataFuture = Future.value(formattedData);
          });
        } else {
          throw Exception('Empty response received');
        }
      } else {
        throw Exception('Failed to load machine data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
      setState(() {
        dataFuture = Future.error(e);
        if (machineNames.isEmpty) {
          machineNames = ['No machines available'];
        }
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<FormattedMachineData> _formatData(Map<String, dynamic> rawData) {
    List<FormattedMachineData> formattedData = [];
    rawData.forEach((machine, data) {
      List<dynamic> dailyData = data['daily'];
      for (var day in dailyData) {
        formattedData.add(FormattedMachineData(
          date: day['date'],
          machine: machine,
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
        sheet.name = 'Machine Report';

        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        sheet.getRangeByIndex(1, 1).setText('Date');
        int colIndex = 2;
        for (var machine in machineNames) {
          sheet.getRangeByIndex(1, colIndex).setText('$machine Energy (kWh)');
          sheet.getRangeByIndex(1, colIndex + 1).setText('$machine Cost (৳)');
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
          pivotedData[data.date]![data.machine] = {
            'energy': data.totalEnergy,
            'cost': data.totalCost,
          };

          totalEnergyMap[data.machine] = (totalEnergyMap[data.machine] ?? 0) + data.totalEnergy;
          totalCostMap[data.machine] = (totalCostMap[data.machine] ?? 0) + data.totalCost;
        }

        int rowIndex = 2;
        pivotedData.forEach((date, machines) {
          sheet.getRangeByIndex(rowIndex, 1).setText(date);
          colIndex = 2;
          for (var machine in machineNames) {
            sheet.getRangeByIndex(rowIndex, colIndex).setNumber(machines[machine]?['energy'] ?? 0);
            sheet.getRangeByIndex(rowIndex, colIndex + 1).setNumber(machines[machine]?['cost'] ?? 0);
            colIndex += 2;
          }
          rowIndex++;
        });

        sheet.getRangeByIndex(rowIndex, 1).setText('Total');
        colIndex = 2;
        for (var machine in machineNames) {
          sheet.getRangeByIndex(rowIndex, colIndex).setNumber(totalEnergyMap[machine] ?? 0);
          sheet.getRangeByIndex(rowIndex, colIndex + 1).setNumber(totalCostMap[machine] ?? 0);
          colIndex += 2;
        }

        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (directory.existsSync()) {
            String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
            String filePath =
                "${directory.path}/Machine_Report_$formattedDate $formattedTime.xlsx";

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
          child: _buildMachineTableWidget(context),
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

  Widget _buildMachineTableWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<List<FormattedMachineData>>(
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
                      source: MachineDataGridSource(snapshot.data!, machineNames),
                      frozenColumnsCount: 1,
                      footerFrozenRowsCount: 1,
                      columns: _buildColumns(size),
                      stackedHeaderRows: _buildStackedHeaders(size),
                    ),
                  ),
                ),
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

    for (var machine in machineNames) {
      columns.addAll([
        GridColumn(
          columnName: '${machine}_energy',
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
          columnName: '${machine}_cost',
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
    for (var machine in machineNames) {
      cells.add(StackedHeaderCell(
        columnNames: ['${machine}_energy', '${machine}_cost'],
        child: Container(
          color: AppColors.secondaryTextColor,
          alignment: Alignment.center,
          child: TextComponent(
            text: machine.replaceAll('_', ' '),
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

class MachineDataGridSource extends DataGridSource {
  List<DataGridRow> _formattedData = [];
  final List<String> machineNames;

  MachineDataGridSource(List<FormattedMachineData> data, this.machineNames) {
    Map<String, Map<String, Map<String, String>>> pivotedData = {};
    Map<String, double> totalEnergyMap = {};
    Map<String, double> totalCostMap = {};

    for (var item in data) {
      if (!pivotedData.containsKey(item.date)) {
        pivotedData[item.date] = {};
      }
      pivotedData[item.date]![item.machine] = {
        'energy': item.totalEnergy.toStringAsFixed(2),
        'cost': '${item.totalCost.toStringAsFixed(0)}/${item.unitCost.toStringAsFixed(2)}',
      };

      totalEnergyMap[item.machine] = (totalEnergyMap[item.machine] ?? 0) + item.totalEnergy;
      totalCostMap[item.machine] = (totalCostMap[item.machine] ?? 0) + item.totalCost;
    }

    _formattedData = pivotedData.entries.map((entry) {
      List<DataGridCell> cells = [
        DataGridCell<String>(columnName: 'date', value: entry.key),
      ];

      for (var machine in machineNames) {
        cells.addAll([
          DataGridCell<String>(
            columnName: '${machine}_energy',
            value: entry.value[machine]?['energy'] ?? '0.00',
          ),
          DataGridCell<String>(
            columnName: '${machine}_cost',
            value: entry.value[machine]?['cost'] ?? '0/0.00',
          ),
        ]);
      }
      return DataGridRow(cells: cells);
    }).toList();

    List<DataGridCell> totalCells = [
      const DataGridCell<String>(columnName: 'date', value: 'Total'),
    ];
    for (var machine in machineNames) {
      double totalEnergy = totalEnergyMap[machine] ?? 0;
      double totalCost = totalCostMap[machine] ?? 0;
      double unitCost = totalEnergy != 0 ? totalCost / totalEnergy : 0;
      totalCells.addAll([
        DataGridCell<String>(
          columnName: '${machine}_energy',
          value: totalEnergy.toStringAsFixed(2),
        ),
        DataGridCell<String>(
          columnName: '${machine}_cost',
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