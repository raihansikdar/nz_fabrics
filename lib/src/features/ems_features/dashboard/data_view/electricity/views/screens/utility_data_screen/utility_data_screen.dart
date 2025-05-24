
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/electricity/views/screens/utility_data_screen/utility_all_data_table.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';


class UtilityDataScreen extends StatefulWidget {
  const UtilityDataScreen({super.key});

  @override
  _UtilityDataScreenState createState() => _UtilityDataScreenState();
}

class _UtilityDataScreenState extends State<UtilityDataScreen> {
  String graphType = '';
  List<ElectricityData> electricityData = [];
  List<WaterData> waterData = [];
  List<FormattedMachineData> tableData = [];
  bool isLoading = false;
  bool showElectricity = true;
  bool showWater = true;
  final fromDateTEController = TextEditingController();
  final toDateTEController = TextEditingController();
  bool isFilterButtonProgress = false;
  late MachineDataGridSource machineDataSource;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    fromDateTEController.text = DateFormat('yyyy-MM-dd').format(now);
    toDateTEController.text = DateFormat('yyyy-MM-dd').format(now);
    machineDataSource = MachineDataGridSource(tableData);
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    await fetchData(start, end);
  }

  Future<void> fetchData(DateTime start, DateTime end) async {
    if(mounted){
      setState(() {
        isLoading = true;
      });
    }


    log('-----------ALL ------------->> ${Urls.baseUrl}/api/filter-all-utility-data/');

    await fetchChartData(start, end);
    await fetchTableData(start, end);

    if(mounted){
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchChartData(DateTime start, DateTime end) async {

    final url = Uri.parse('${Urls.baseUrl}/api/filter-all-utility-data/');
    final headers = {
      'Authorization': '${AuthUtilityController.accessToken}',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'start': DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(start),
      'end': DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(end),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      log('-----------ALL ------------->> ${Urls.baseUrl}/api/filter-all-utility-data/');


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          if (data is List) {
            final duration = end.difference(start).inDays;
            final targetGraphType = duration > 365
                ? 'Yearly-Bar-Chart'
                : duration > 30
                ? 'Monthly-Bar-Chart'
                : 'Line-Chart';
            final selectedData = data.firstWhere(
                  (item) => item['graph-type'] == targetGraphType,
              orElse: () => data.firstWhere(
                    (item) => item['graph-type'] == 'Line-Chart',
                orElse: () => data[0],
              ),
            );
            graphType = selectedData['graph-type'] ?? 'Line-Chart';
            electricityData = (selectedData['electricity_data'] as List)
                .map((e) => ElectricityData.fromJson(e))
                .toList();
            waterData = (selectedData['water_data'] as List)
                .map((w) => WaterData.fromJson(w))
                .toList();
          } else {
            graphType = data['graph-type'] ?? 'Line-Chart';
            electricityData = (data['electricity_data'] as List)
                .map((e) => ElectricityData.fromJson(e))
                .toList();
            waterData = (data['water_data'] as List)
                .map((w) => WaterData.fromJson(w))
                .toList();
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch chart data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching chart data: $e')),
      );
    }
  }

  Future<void> fetchTableData(DateTime start, DateTime end) async {
    final url = Uri.parse('${Urls.baseUrl}/api/filter-all-utility-table-data/');
    final headers = {
      'Authorization': '${AuthUtilityController.accessToken}',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'start': DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(start),
      'end': DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(end),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      log('-----------ALL ------------->> ${Urls.baseUrl}/api/filter-all-utility-data/');

      debugPrint('Table API Response Status: ${response.statusCode}');
      debugPrint('Table API Response Body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tableData = [];
          for (var item in data['electric_data']) {
            tableData.add(FormattedMachineData(
              date: item['date'],
              machine: item['node'],
              totalEnergy: item['energy'].toDouble(),
              totalCost: item['cost'].toDouble(),
              unitCost: item['unit_cost'].toDouble(),
              type: 'electric',
            ));
          }
          for (var item in data['water_data']) {
            tableData.add(FormattedMachineData(
              date: item['date'],
              machine: item['node'],
              totalEnergy: item['volume'].toDouble(),
              totalCost: item['cost'].toDouble(),
              unitCost: item['unit_cost'].toDouble(),
              type: 'water',
            ));
          }
          debugPrint('Table Data Length: ${tableData.length}');
          machineDataSource = MachineDataGridSource(tableData);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch table data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      debugPrint('Error fetching table data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching table data: $e')),
      );
    }
  }

  void formDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        fromDateTEController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void toDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        toDateTEController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void dateDifferenceDates() {
    final fromDate = DateTime.tryParse(fromDateTEController.text);
    final toDate = DateTime.tryParse(toDateTEController.text);
    if (fromDate == null || toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid date format')),
      );
      return;
    }
    if (toDate.isBefore(fromDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date cannot be before start date')),
      );
    }
  }






  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
      body:  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0),
              child: Container(
                height: size.height * 0.14,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.containerBorderColor),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: size.height * 0.020,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: size.width * 0.4,
                                  child: TextFormField(
                                    onTap: formDatePicker,
                                    style: const TextStyle(fontSize: 18),
                                    controller: fromDateTEController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 16),
                                      hintText: "From Date",
                                      suffixIcon: Icon(Icons.calendar_today_outlined, size: 24),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                SizedBox(
                                  width: size.width * 0.42,
                                  child: TextFormField(
                                    onTap: toDatePicker,
                                    style: const TextStyle(fontSize: 18),
                                    controller: toDateTEController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 16),
                                      hintText: "To Date",
                                      suffixIcon: Icon(Icons.calendar_today_outlined, size: 24),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.width > 500 ? 16: 8),
                            SizedBox(
                              height: size.width > 500 ? size.height * 0.04 : size.width * 0.09,
                              width: size.width * 0.4,
                              child: ElevatedButton(
                                onPressed: () async {
                                  dateDifferenceDates();
                                  final fromDate = DateTime.tryParse(fromDateTEController.text);
                                  final toDate = DateTime.tryParse(toDateTEController.text);
                                  if (fromDate == null || toDate == null || toDate.isBefore(fromDate)) {
                                    return;
                                  }
                                  setState(() {
                                    isFilterButtonProgress = true;
                                  });
                                  await fetchData(
                                    fromDate,
                                    DateTime(toDate.year, toDate.month, toDate.day, 23, 59, 59),
                                  );
                                  setState(() {
                                    isFilterButtonProgress = false;
                                  });
                                },
                                child: isFilterButtonProgress
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : const Text("Submit", style: TextStyle(color: Colors.white,fontSize: 16)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
            isLoading
                ? const Center(child: Padding(
              padding: EdgeInsets.only(top: 158.0),
              child: SpinKitFadingCircle(
                color: AppColors.primaryColor,
                size: 50.0,
              ),
            ))
                :  Column(
              children: [
                graphType == 'Line-Chart'
                    ? LineChartWidget(
                  electricityData: electricityData,
                  waterData: waterData,
                  showElectricity: showElectricity,
                  showWater: showWater,
                )
                    : graphType == 'Monthly-Bar-Chart'
                    ? MonthlyBarChartWidget(
                  electricityData: electricityData,
                  waterData: waterData,
                  showElectricity: showElectricity,
                  showWater: showWater,
                )
                    : YearlyBarChartWidget(
                  electricityData: electricityData,
                  waterData: waterData,
                  showElectricity: showElectricity,
                  showWater: showWater,
                ),
                const SizedBox(height: 16),
                SizedBox(
                    height: 160,
                    child: UtilityAllDataTable()),

                const SizedBox(height: 16),

                tableData.isEmpty
                    ? const Text(
                  'No data available for the selected date range',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
                    : Container(
                  height: 300,
                  width: double.infinity,
                  margin: const EdgeInsets.all(8.0),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child:
                  SfDataGridTheme(
                    data: SfDataGridThemeData(
                      headerColor: AppColors.secondaryTextColor,
                    ),
                    child: SfDataGrid(
                      source: machineDataSource,
                      columnWidthMode: size.width > 500 ? ColumnWidthMode.fill : ColumnWidthMode.fitByCellValue,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      headerRowHeight: 47,
                      rowHeight: 35,
                      stackedHeaderRows: [
                        StackedHeaderRow(cells: [
                          StackedHeaderCell(
                            columnNames: ['electricity_energy', 'electricity_cost'],
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Electricity',
                                style: TextStyle(color: AppColors.whiteTextColor),
                              ),
                            ),
                          ),
                          StackedHeaderCell(
                            columnNames: ['water_volume', 'water_cost'],
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Water',
                                style: TextStyle(color: AppColors.whiteTextColor),
                              ),
                            ),
                          ),
                        ]),
                      ],
                      columns: <GridColumn>[
                        GridColumn(
                          columnName: 'date',
                          label: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Date',
                              style: TextStyle(color: AppColors.whiteTextColor),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'electricity_energy',
                          label: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Energy',
                              style: TextStyle(color: AppColors.whiteTextColor),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'electricity_cost',
                          label: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Cost/Unit Cost',
                              style: TextStyle(color: AppColors.whiteTextColor),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'water_volume',
                          label: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Volume',
                              style: TextStyle(color: AppColors.whiteTextColor),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'water_cost',
                          label: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Cost /Unit Cost',
                              style: TextStyle(color: AppColors.whiteTextColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ElectricityData {
  final DateTime? timedate;
  final String? date;
  final double power;
  final double energy;

  ElectricityData({
    this.timedate,
    this.date,
    required this.power,
    required this.energy,
  });

  factory ElectricityData.fromJson(Map<String, dynamic> json) {
    return ElectricityData(
      timedate: json['timedate'] != null ? DateTime.parse(json['timedate']) : null,
      date: json['date'],
      power: (json['power'] ?? json['energy'] ?? 0.0).toDouble(),
      energy: (json['energy'] ?? 0.0).toDouble(),
    );
  }
}

class WaterData {
  final DateTime? timedate;
  final String? date;
  final double volume;
  final double instantFlow;

  WaterData({
    this.timedate,
    this.date,
    required this.volume,
    required this.instantFlow,
  });

  factory WaterData.fromJson(Map<String, dynamic> json) {
    return WaterData(
      timedate: json['timedate'] != null ? DateTime.parse(json['timedate']) : null,
      date: json['date'],
      volume: (json['volume'] ?? 0.0).toDouble(),
      instantFlow: (json['instant_flow'] ?? json['sensor_value'] ?? 0.0).toDouble(),
    );
  }
}

class FormattedMachineData {
  final String date;
  final String machine;
  final double totalEnergy;
  final double totalCost;
  final double unitCost;
  final String type;

  FormattedMachineData({
    required this.date,
    required this.machine,
    required this.totalEnergy,
    required this.totalCost,
    required this.unitCost,
    required this.type,
  });
}

class MachineDataGridSource extends DataGridSource {
  List<DataGridRow> _formattedData = [];

  MachineDataGridSource(List<FormattedMachineData> data) {
    Map<String, Map<String, Map<String, String>>> pivotedData = {};

    // Process data into a pivoted structure
    for (var item in data) {
      if (!pivotedData.containsKey(item.date)) {
        pivotedData[item.date] = {};
      }
      pivotedData[item.date]![item.type] = {
        'energy': item.totalEnergy.toStringAsFixed(2),
        'cost': item.totalCost.toStringAsFixed(2),
        'unit_cost': item.unitCost.toStringAsFixed(2),
      };
    }

    // Create data grid rows
    _formattedData = pivotedData.entries.map((entry) {
      final date = entry.key;
      final electricData = entry.value['electric'] ?? {
        'energy': '0.00',
        'cost': '0.00',
        'unit_cost': '0.00'
      };
      final waterData = entry.value['water'] ?? {
        'energy': '0.00',
        'cost': '0.00',
        'unit_cost': '0.00'
      };
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'date', value: date),
        DataGridCell<String>(
          columnName: 'electricity_energy',
          value: '${electricData['energy']} kWh',
        ),
        DataGridCell<String>(
          columnName: 'electricity_cost',
          value: '৳${electricData['cost']} /${electricData['unit_cost']}',
        ),
        DataGridCell<String>(
          columnName: 'water_volume',
          value: '${waterData['energy']} m³',
        ),
        DataGridCell<String>(
          columnName: 'water_cost',
          value: '৳${waterData['cost']} /${waterData['unit_cost']}',
        ),
      ]);
    }).toList();

    // Add total row
    double totalElectricEnergy = data
        .where((item) => item.type == 'electric')
        .fold(0.0, (sum, item) => sum + item.totalEnergy);
    double totalElectricCost = data
        .where((item) => item.type == 'electric')
        .fold(0.0, (sum, item) => sum + item.totalCost);
    double totalElectricUnitCost = totalElectricEnergy > 0
        ? totalElectricCost / totalElectricEnergy
        : 0.0;
    double totalWaterVolume = data
        .where((item) => item.type == 'water')
        .fold(0.0, (sum, item) => sum + item.totalEnergy);
    double totalWaterCost = data
        .where((item) => item.type == 'water')
        .fold(0.0, (sum, item) => sum + item.totalCost);
    double totalWaterUnitCost = totalWaterVolume > 0
        ? totalWaterCost / totalWaterVolume
        : 0.0;

    _formattedData.add(DataGridRow(cells: [
      const DataGridCell<String>(columnName: 'date', value: 'Total'),
      DataGridCell<String>(
        columnName: 'electricity_energy',
        value: '${totalElectricEnergy.toStringAsFixed(2)} kWh',
      ),
      DataGridCell<String>(
        columnName: 'electricity_cost',
        value: '৳${totalElectricCost.toStringAsFixed(2)} / ৳${totalElectricUnitCost.toStringAsFixed(2)}',
      ),
      DataGridCell<String>(
        columnName: 'water_volume',
        value: '${totalWaterVolume.toStringAsFixed(2)} m³',
      ),
      DataGridCell<String>(
        columnName: 'water_cost',
        value: '৳${totalWaterCost.toStringAsFixed(2)} / ৳${totalWaterUnitCost.toStringAsFixed(2)}',
      ),
    ]));
  }

  @override
  List<DataGridRow> get rows => _formattedData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    int rowIndex = rows.indexOf(row);
    bool isTotalRow = row.getCells().first.value == 'Total';
    bool isOddRow = rowIndex % 2 == 1;

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4.0),
          color: isTotalRow
              ? const Color(0xFFE6F1FF)
              : isOddRow
              ? null
              : const Color(0xFFE0E1FF),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF04063E),
              fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
            ),
            softWrap: true,
            maxLines: 2,
          ),
        );
      }).toList(),
    );
  }
}
class LineChartWidget extends StatefulWidget {
  final List<ElectricityData> electricityData;
  final List<WaterData> waterData;
  final bool showElectricity;
  final bool showWater;

  const LineChartWidget({
    super.key,
    required this.electricityData,
    required this.waterData,
    required this.showElectricity,
    required this.showWater,
  });

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  late bool _showElectricity;
  late bool _showWater;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    super.initState();
    _showElectricity = widget.showElectricity;
    _showWater = widget.showWater;
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      enablePinching: true, // Enable pinch-to-zoom
      zoomMode: ZoomMode.x, // Restrict zooming to x-axis
      enableDoubleTapZooming: true, // Allow double-tap to zoom
    );

    // Debug: Log data counts and all values
    debugPrint('Electricity Data Count: ${widget.electricityData.length}');
    debugPrint('Electricity Power Values: ${widget.electricityData.map((d) => d.power).toList()}');
    debugPrint('Water Data Count: ${widget.waterData.length}');
    debugPrint('Water Flow Values: ${widget.waterData.map((d) => d.instantFlow).toList()}');
  }

  // Safe conversion method to handle potential NaN/Infinity issues
  double safeToDouble(dynamic value) {
    if (value == null) return 0.0;
    try {
      double result = value is double ? value : double.parse(value.toString());
      if (result.isNaN || !result.isFinite) return 0.0;
      return result;
    } catch (e) {
      return 0.0;
    }
  }

  // Calculate maximum values for each series with a minimum threshold
  double calculateMaxPower(List<ElectricityData> data) {
    if (data.isEmpty) return 10.0; // Minimum threshold if data is empty
    double maxValue = data
        .map((d) => safeToDouble(d.power))
        .reduce((a, b) => a > b ? a : b);
    double result = maxValue > 0 ? maxValue * 1.1 : 10.0; // Ensure minimum range
    debugPrint('Max Power: $result');
    return result;
  }

  double calculateMaxFlow(List<WaterData> data) {
    if (data.isEmpty) return 10.0; // Minimum threshold if data is empty
    double maxValue = data
        .map((d) => safeToDouble(d.instantFlow))
        .reduce((a, b) => a > b ? a : b);
    double result = maxValue > 0 ? maxValue * 1.1 : 10.0; // Ensure minimum range
    debugPrint('Max Flow: $result');
    return result;
  }

  DateTime _parseDateTime(DateTime? timedate) {
    if (timedate == null) {
      debugPrint('Null timedate, using fallback');
      return DateTime.now();
    }
    try {
      return timedate.toLocal();
    } catch (e) {
      debugPrint('Error parsing timedate: $e');
      return DateTime.now();
    }
  }
  double determineInterval(int dataLength) {
    if (dataLength > 720) {
      return 720.0;
    } else if (dataLength > 450) {
      return 450.0;
    } else if (dataLength > 360) {
      return 360.0;
    } else {
      return 240.0;
    }
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<ElectricityData> electricityChartData = widget.electricityData;
    List<WaterData> waterChartData = widget.waterData;

    // Find min and max dates for x-axis
    DateTime? minDate, maxDate;
    List<DateTime> allDates = [
      ...electricityChartData
          .map((d) => d.timedate)
          .where((d) => d != null)
          .cast<DateTime>(),
      ...waterChartData
          .map((d) => d.timedate)
          .where((d) => d != null)
          .cast<DateTime>(),
    ];

    if (allDates.isNotEmpty) {
      minDate = allDates.reduce((a, b) => a.isBefore(b) ? a : b);
      maxDate = allDates.reduce((a, b) => a.isAfter(b) ? a : b);
      debugPrint('Min Date: $minDate, Max Date: $maxDate');
    } else {
      debugPrint('No valid dates found');
      minDate = DateTime.now().subtract(const Duration(hours: 1));
      maxDate = DateTime.now();
    }

    // Check if there's data to display
    if (electricityChartData.isEmpty && waterChartData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No data available to display',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: AppColors.whiteTextColor,
        elevation: 4,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  FilterChip(
                    label: const Text('Electricity', style: TextStyle(fontSize: 12)),
                    selected: _showElectricity,
                    onSelected: (selected) {
                      setState(() {
                        _showElectricity = selected;
                      });
                    },
                    selectedColor: Colors.orange.withOpacity(0.3),
                    checkmarkColor: Colors.orange,
                  ),
                  FilterChip(
                    label: const Text('Water', style: TextStyle(fontSize: 12)),
                    selected: _showWater,
                    onSelected: (selected) {
                      setState(() {
                        _showWater = selected;
                      });
                    },
                    selectedColor: Colors.green.withOpacity(0.3),
                    checkmarkColor: Colors.blue,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: SizedBox(
                height: size.width > 500 ? size.height * 0.48 : size.height * 0.38,
                width: size.width - 16,
                child:

                SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  zoomPanBehavior: _zoomPanBehavior,
                  trackballBehavior: TrackballBehavior(
                    enable: true,
                    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                    activationMode: ActivationMode.longPress,
                  ),
                  legend: const Legend(
                    isVisible: false,
                    position: LegendPosition.top,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  primaryXAxis: DateTimeAxis(
                    dateFormat: DateFormat('dd-MMM-yyyy'),
                    majorGridLines: const MajorGridLines(width: 0),
                    labelStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                    intervalType: DateTimeIntervalType.days,
                    interval: 1,
                    minimum: minDate,
                    maximum: maxDate,
                    initialZoomFactor: 0.5, // Show 50% of the data range initially
                    initialZoomPosition: 0.0, // Start from the beginning
                    axisLabelFormatter: (AxisLabelRenderDetails args) {
                      final String text = DateFormat('dd/MMM').format(
                        DateTime.fromMillisecondsSinceEpoch(args.value.toInt()),
                      );
                      return ChartAxisLabel(text, args.textStyle);
                    },
                  ),
                  primaryYAxis: NumericAxis(
                    name: 'PowerAxis',
                    minimum: 0,
                    maximum: electricityChartData.isNotEmpty
                        ? calculateMaxPower(electricityChartData)
                        : 10,
                    majorGridLines: const MajorGridLines(width: 1),
                    labelFormat: '{value}',
                    labelStyle: const TextStyle(color: Colors.blue),
                    isVisible: _showElectricity && electricityChartData.isNotEmpty,
                    axisLabelFormatter: (AxisLabelRenderDetails args) {
                      double value = safeToDouble(args.value);
                      String formattedText = value >= 1000
                          ? '${(value / 1000).toStringAsFixed(1)}k'
                          : value.toStringAsFixed(1);
                      return ChartAxisLabel(formattedText, args.textStyle);
                    },
                  ),
                  axes: [
                    NumericAxis(
                      name: 'FlowAxis',

                      opposedPosition: true,
                      minimum: 0,
                      maximum: waterChartData.isNotEmpty
                          ? calculateMaxFlow(waterChartData)
                          : 10,
                      labelStyle: const TextStyle(color: Colors.blue),
                      isVisible: _showWater && waterChartData.isNotEmpty,
                      axisLabelFormatter: (AxisLabelRenderDetails args) {
                        double value = safeToDouble(args.value);
                        String formattedText = value >= 1000
                            ? '${(value / 1000).toStringAsFixed(1)}k'
                            : value.toStringAsFixed(1);
                        return ChartAxisLabel(formattedText, args.textStyle);
                      },
                    ),
                  ],
                  series: <CartesianSeries<dynamic, DateTime>>[
                    if (_showElectricity && electricityChartData.isNotEmpty)
                      SplineSeries<ElectricityData, DateTime>(
                        name: 'Power (kW)',

                        dataSource: electricityChartData,
                        xValueMapper: (ElectricityData data, _) =>
                            _parseDateTime(data.timedate),
                        yValueMapper: (ElectricityData data, _) =>
                            safeToDouble(data.power) , // Convert to kW if in watts
                        yAxisName: 'PowerAxis',
                        color: Colors.orange,
                        width: 2.0, // Make the line slightly thicker for visibility
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: false, // Data labels disabled
                        ),
                      ),
                    if (_showWater && waterChartData.isNotEmpty)
                      SplineSeries<WaterData, DateTime>(
                        name: 'Water Flow (m³/h)',
                        dataSource: waterChartData,
                        xValueMapper: (WaterData data, _) =>
                            _parseDateTime(data.timedate),
                        yValueMapper: (WaterData data, _) =>
                            safeToDouble(data.instantFlow),
                        yAxisName: 'FlowAxis',
                        color: Colors.blue,
                        width: 2.0, // Make the line slightly thicker for visibility
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: false, // Data labels disabled
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_showElectricity && electricityChartData.isNotEmpty)
                    Transform.rotate(
                      angle: 90 * 3.14159 / 180,
                      child: Container(
                        transform: Matrix4.translationValues(-15, -20, 0),
                        child: const Text(
                          'Electricity',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (_showWater && waterChartData.isNotEmpty)
                    Transform.rotate(
                      angle: 90 * 3.14159 / 180,
                      child: Container(
                        transform: Matrix4.translationValues(-25, 42, 0),
                        child: const Text(
                          'Water',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class MonthlyBarChartWidget extends StatelessWidget {
  final List<ElectricityData> electricityData;
  final List<WaterData> waterData;
  final bool showElectricity;
  final bool showWater;

   MonthlyBarChartWidget({
    super.key,
    required this.electricityData,
    required this.waterData,
    required this.showElectricity,
    required this.showWater,
  });
  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
      enableDoubleTapZooming:true,
      );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SfCartesianChart(
        zoomPanBehavior: _zoomPanBehavior,
        trackballBehavior: TrackballBehavior(
          enable: true,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
          activationMode: ActivationMode.longPress,
        ),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}k', // Formats the value with a 'k' suffix
          numberFormat: NumberFormat.decimalPattern()..maximumFractionDigits = 0, // No decimals
          axisLabelFormatter: (AxisLabelRenderDetails details) {
            // Divide the value by 1000 to convert to 'k' (e.g., 1000000 -> 1000k)
            int value = (details.value / 1000).toInt();
            return ChartAxisLabel('${value}k', details.textStyle);
          },
        ),
        legend: Legend(isVisible: true, position: LegendPosition.top),
        series: <CartesianSeries<dynamic, dynamic>>[
          if (showElectricity)
            ColumnSeries<ElectricityData, String>(
              dataSource: electricityData,
              xValueMapper: (ElectricityData data, _) => data.date!,
              yValueMapper: (ElectricityData data, _) => data.energy,
              name: 'Energy (kWh)',
              color: Colors.orange,
            ),
          if (showWater)
            ColumnSeries<WaterData, String>(
              dataSource: waterData,
              xValueMapper: (WaterData data, _) => data.date!,
              yValueMapper: (WaterData data, _) => data.volume,
              name: 'Water Volume (m³)',
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}

class YearlyBarChartWidget extends StatelessWidget {
  final List<ElectricityData> electricityData; // Corrected from 'Electricity deodorantsData'
  final List<WaterData> waterData;
  final bool showElectricity;
  final bool showWater;

   YearlyBarChartWidget({
    super.key,
    required this.electricityData,
    required this.waterData,
    required this.showElectricity,
    required this.showWater,
  });
  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
      enableDoubleTapZooming:true,
      );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 400,
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              labelFormat: '{value}k',
              numberFormat: NumberFormat.decimalPattern()..maximumFractionDigits = 0,
              axisLabelFormatter: (AxisLabelRenderDetails details) {
                int value = (details.value / 1000).toInt();
                return ChartAxisLabel('${value}k', details.textStyle);
              },
            ),
            legend: Legend(isVisible: true, position: LegendPosition.top),
            tooltipBehavior: TooltipBehavior(enable: true),
          zoomPanBehavior: _zoomPanBehavior,
            trackballBehavior: TrackballBehavior(
              enable: true,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              activationMode: ActivationMode.longPress,
            ),
            series: <CartesianSeries<dynamic, dynamic>>[
              if (showElectricity)
                ColumnSeries<ElectricityData, String>(
                  dataSource: electricityData,
                  xValueMapper: (ElectricityData data, _) => data.date!,
                  yValueMapper: (ElectricityData data, _) => data.energy,
                  name: 'Energy (kWh)',
                  color: Colors.orange,
                ),
              if (showWater)
                ColumnSeries<WaterData, String>(
                  dataSource: waterData,
                  xValueMapper: (WaterData data, _) => data.date!,
                  yValueMapper: (WaterData data, _) => data.volume,
                  name: 'Water Volume (m³)',
                  color: Colors.blue,
                ),
            ],
            ),
        );
    }
}