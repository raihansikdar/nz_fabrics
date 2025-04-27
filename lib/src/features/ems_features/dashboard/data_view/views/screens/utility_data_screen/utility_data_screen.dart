import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/utility_data_screen/utility_all_data_table.dart';
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
    setState(() {
      isLoading = true;
    });

    await fetchChartData(start, end);
    await fetchTableData(start, end);

    setState(() {
      isLoading = false;
    });
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
                            const SizedBox(height: 8),
                            SizedBox(
                              height: size.width > 600 ? size.height * 0.05 : size.width * 0.1,
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
                                    : const Text("Submit", style: TextStyle(color: Colors.white)),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: showElectricity,
                  onChanged: (value) {
                    setState(() {
                      showElectricity = value ?? true;
                    });
                  },
                ),
                const Text('Show Electricity', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 16),
                Checkbox(
                  value: showWater,
                  onChanged: (value) {
                    setState(() {
                      showWater = value ?? true;
                    });
                  },
                ),
                const Text('Show Water', style: TextStyle(fontSize: 16)),
              ],
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
                 child: SfDataGridTheme(
                   data: SfDataGridThemeData(
                     headerColor: AppColors.secondaryTextColor,
                   ),
                   child: SfDataGrid(
                     source: machineDataSource,
                     columnWidthMode: size.width > 500 ? ColumnWidthMode.fill : ColumnWidthMode.fitByCellValue,
                     gridLinesVisibility: GridLinesVisibility.both,
                     headerGridLinesVisibility: GridLinesVisibility.both,
                     headerRowHeight:47,
                     rowHeight: 35,
                     stackedHeaderRows: [
                       StackedHeaderRow(cells: [
                         // StackedHeaderCell(
                         //   columnNames: ['date'],
                         //   child: Container(
                         //     alignment: Alignment.center,
                         //     child: const Text('Date'),
                         //   ),
                         // ),
                         StackedHeaderCell(
                           columnNames: ['electricity_energy', 'electricity_cost'],
                           child: Container(
                             alignment: Alignment.center,
                             child:  Text('Electricity',style: TextStyle(color: AppColors.whiteTextColor),),
                           ),
                         ),
                         StackedHeaderCell(
                           columnNames: ['water_volume', 'water_cost'],
                           child: Container(
                             alignment: Alignment.center,
                             child: const Text('Water',style: TextStyle(color: AppColors.whiteTextColor),),
                           ),
                         ),
                       ]),
                     ],
                     columns: <GridColumn>[
                       GridColumn(
                         columnName: 'date',
                         label: Container(
                           alignment: Alignment.center,
                           child: const Text('Date',style: TextStyle(color: AppColors.whiteTextColor),),
                         ),
                       ),
                       GridColumn(
                         columnName: 'electricity_energy',
                         label: Container(
                           alignment: Alignment.center,
                           child: const Text('Energy (kWh)',style: TextStyle(color: AppColors.whiteTextColor),),
                         ),
                       ),
                       GridColumn(
                         columnName: 'electricity_cost',
                         label: Container(
                           alignment: Alignment.center,
                           child: const Text('Cost (৳)',style: TextStyle(color: AppColors.whiteTextColor),),
                         ),
                       ),
                       GridColumn(
                         columnName: 'water_volume',
                         label: Container(
                           alignment: Alignment.center,
                           child: const Text('Volume (L)',style: TextStyle(color: AppColors.whiteTextColor),),
                         ),
                       ),
                       GridColumn(
                         columnName: 'water_cost',
                         label: Container(
                           alignment: Alignment.center,
                           child: const Text('Cost (৳)',style: TextStyle(color: AppColors.whiteTextColor),),
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
      final electricData = entry.value['electric'] ?? {'energy': '0.00', 'cost': '0.00'};
      final waterData = entry.value['water'] ?? {'energy': '0.00', 'cost': '0.00'};
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'date', value: date),
        DataGridCell<String>(
          columnName: 'electricity_energy',
          value: '${electricData['energy']} kWh',
        ),
        DataGridCell<String>(
          columnName: 'electricity_cost',
          value: '৳${electricData['cost']}',
        ),
        DataGridCell<String>(
          columnName: 'water_volume',
          value: '${waterData['energy']} L',
        ),
        DataGridCell<String>(
          columnName: 'water_cost',
          value: '৳${waterData['cost']}',
        ),
      ]);
    }).toList();

    // Add total row (assuming totals are available in tableData or from API)
    double totalElectricEnergy = data
        .where((item) => item.type == 'electric')
        .fold(0.0, (sum, item) => sum + item.totalEnergy);
    double totalElectricCost = data
        .where((item) => item.type == 'electric')
        .fold(0.0, (sum, item) => sum + item.totalCost);
    double totalWaterVolume = data
        .where((item) => item.type == 'water')
        .fold(0.0, (sum, item) => sum + item.totalEnergy);
    double totalWaterCost = data
        .where((item) => item.type == 'water')
        .fold(0.0, (sum, item) => sum + item.totalCost);

    _formattedData.add(DataGridRow(cells: [
      const DataGridCell<String>(columnName: 'date', value: 'Total'),
      DataGridCell<String>(
        columnName: 'electricity_energy',
        value: '${totalElectricEnergy.toStringAsFixed(2)} kWh',
      ),
      DataGridCell<String>(
        columnName: 'electricity_cost',
        value: '৳${totalElectricCost.toStringAsFixed(2)}',
      ),
      DataGridCell<String>(
        columnName: 'water_volume',
        value: '${totalWaterVolume.toStringAsFixed(2)} L',
      ),
      DataGridCell<String>(
        columnName: 'water_cost',
        value: '৳${totalWaterCost.toStringAsFixed(2)}',
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

class LineChartWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: SfCartesianChart(
        trackballBehavior: TrackballBehavior(
          enable: true,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
          activationMode: ActivationMode.longPress,
        ),
        primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat('dd/MM hh:mm'),
          intervalType: DateTimeIntervalType.hours,
          majorGridLines: const MajorGridLines(width: 0.2),
        ),
        legend: Legend(isVisible: false, position: LegendPosition.top),
        series: <CartesianSeries<dynamic, dynamic>>[
          if (showElectricity)
            SplineSeries<ElectricityData, DateTime>(
              dataSource: electricityData,
              xValueMapper: (ElectricityData data, _) => data.timedate!,
              yValueMapper: (ElectricityData data, _) => data.power,
              name: 'Power (kW)',
              color: Colors.blue,
            ),
          if (showWater)
            SplineSeries<WaterData, DateTime>(
              dataSource: waterData,
              xValueMapper: (WaterData data, _) => data.timedate!,
              yValueMapper: (WaterData data, _) => data.instantFlow,
              name: 'Flow (L/min)',
              color: Colors.green,
            ),
        ],
      ),
    );
  }
}

class MonthlyBarChartWidget extends StatelessWidget {
  final List<ElectricityData> electricityData;
  final List<WaterData> waterData;
  final bool showElectricity;
  final bool showWater;

  const MonthlyBarChartWidget({
    super.key,
    required this.electricityData,
    required this.waterData,
    required this.showElectricity,
    required this.showWater,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SfCartesianChart(
        trackballBehavior: TrackballBehavior(
          enable: true,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
          activationMode: ActivationMode.longPress,
        ),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        legend: Legend(isVisible: false, position: LegendPosition.top),
        series: <CartesianSeries<dynamic, dynamic>>[
          if (showElectricity)
            ColumnSeries<ElectricityData, String>(
              dataSource: electricityData,
              xValueMapper: (ElectricityData data, _) => data.date!,
              yValueMapper: (ElectricityData data, _) => data.energy,
              name: 'Energy (kWh)',
              color: Colors.blue,
            ),
          if (showWater)
            ColumnSeries<WaterData, String>(
              dataSource: waterData,
              xValueMapper: (WaterData data, _) => data.date!,
              yValueMapper: (WaterData data, _) => data.volume,
              name: 'Volume (L)',
              color: Colors.green,
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

  const YearlyBarChartWidget({
    super.key,
    required this.electricityData,
    required this.waterData,
    required this.showElectricity,
    required this.showWater,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(title: AxisTitle(text: 'Value')),
        legend: Legend(isVisible: false, position: LegendPosition.top),
        tooltipBehavior: TooltipBehavior(enable: true),
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
              color: Colors.blue,
            ),
          if (showWater)
            ColumnSeries<WaterData, String>(
              dataSource: waterData,
              xValueMapper: (WaterData data, _) => data.date!,
              yValueMapper: (WaterData data, _) => data.volume,
              name: 'Volume (L)',
              color: Colors.green,
            ),
        ],
      ),
    );
  }
}