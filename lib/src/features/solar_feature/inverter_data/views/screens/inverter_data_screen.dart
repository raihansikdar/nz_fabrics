import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';


class InverterDataScreen extends StatefulWidget {
  const InverterDataScreen({super.key});

  @override
  State<InverterDataScreen> createState() => _InverterDataScreenState();
}

class _InverterDataScreenState extends State<InverterDataScreen> with WidgetsBindingObserver{
  late List<InverterData> _inverterData;
  late InverterDataSource _inverterDataSource;
  bool _isLoading = true;
  Timer? _timer;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchData();
    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      startTimer();
    } else {
      stopTimer();
    }
  }

  void startTimer() {
    stopTimer();
    _timer = Timer.periodic(const Duration(seconds: kTimer), (Timer timer) {
      _fetchData();
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      stopTimer();
    } else if (state == AppLifecycleState.resumed) {
      startTimer();
    }
  }



  Future<void> _fetchData() async {
    if(!mounted)  return;
    List<InverterData> allInverterData = [];
    String? nextUrl = Urls.getInverterDataUrl;

    while (nextUrl != null) {
      final url = Uri.parse(nextUrl);
      final response = await http.get(url, headers: {
        'Authorization': '${AuthUtilityController.accessToken}',
      });


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log("Inverter statusCode =====> ${response.statusCode}");

        final List<InverterData> inverterData = (data['results'] as List)
            .map((item) => InverterData.fromJson(item))
            .toList();

        // Add the data from the current page to the overall list
        allInverterData.addAll(inverterData);

        // Update nextUrl with the URL for the next page
        nextUrl = data['next']; // This will be null if there are no more pages
      } else {
        throw Exception('Failed to load data');
      }
    }

    // Update the state with all the fetched data
   if(mounted){
     setState(() {
       _inverterData = allInverterData;
       _inverterDataSource = InverterDataSource(_inverterData,MediaQuery.of(context).size);
       _isLoading = false;
     });
   }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
      appBar: const CustomAppBarWidget(text: "Inverter", backPreviousScreen: true),
      body: _isLoading
          ? Center(child: Lottie.asset(AssetsPath.loadingJson, height: size.height * 0.12))
          : Padding(
        padding: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize),
        child: SfDataGridTheme(
          data: SfDataGridThemeData(
            headerColor: AppColors.secondaryTextColor,
            frozenPaneLineColor: Colors.white70,
           // gridLineColor: AppColors.secondaryTextColor,
          ),
          child: SfDataGrid(
            rowHeight: size.height * 0.065,
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,

            // columnWidthMode: ColumnWidthMode.fill,
            columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
            frozenColumnsCount: 1,
            source: _inverterDataSource,

            headerRowHeight: size.height * 0.06,
            columns: [
              GridColumn(

                columnName: 'parameter',
                label: Container(
                  padding: EdgeInsets.all(size.height * k8TextSize),
                  alignment: Alignment.center,
                  child: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: size.height * k18TextSize,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              for (var inverter in _inverterData)
                GridColumn(
                  width: size.width * 0.28,
                  columnName: inverter.inverter,
                  label: Container(

                    padding: EdgeInsets.all(size.height * k8TextSize),
                    alignment: Alignment.center,
                    child: Text(
                      inverter.inverter.replaceAll('inverter_', 'Inverter '),
                      style:  TextStyle(
                        fontSize: size.height * k18TextSize,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],

          ),
        ),
      ),
    );
  }
}

class InverterData {
  final String inverter;
  final double acPower;
  final double acVoltageL1;
  final double acVoltageL2;
  final double acVoltageL3;
  final double acCurrentL1;
  final double acCurrentL2;
  final double acCurrentL3;
  final double frequency;
  final List<double> dcVoltages;
  final List<double> dcCurrents;
  final Map<String, Color> statusColors;

  InverterData({
    required this.inverter,
    required this.acPower,
    required this.acVoltageL1,
    required this.acVoltageL2,
    required this.acVoltageL3,
    required this.acCurrentL1,
    required this.acCurrentL2,
    required this.acCurrentL3,
    required this.frequency,
    required this.dcVoltages,
    required this.dcCurrents,
    required this.statusColors,
  });

  static Color parseColor(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'white':
        return Colors.white;
      case 'black':
        return Colors.black;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      default:
        return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    }
  }

  factory InverterData.fromJson(Map<String, dynamic> json) {
    Map<String, Color> colors = {};
    for (int i = 1; i <= 20; i++) {
      String colorValue = json['s_$i'] ?? '#FFFFFF'; // Default to white
      colors['S_$i'] = parseColor(colorValue);
    }

    return InverterData(
      inverter: json['inverter'],
      acPower: json['ac_power'].toDouble(),
      acVoltageL1: json['ac_voltage_l1'].toDouble(),
      acVoltageL2: json['ac_voltage_l2'].toDouble(),
      acVoltageL3: json['ac_voltage_l3'].toDouble(),
      acCurrentL1: json['ac_current_l1'].toDouble(),
      acCurrentL2: json['ac_current_l2'].toDouble(),
      acCurrentL3: json['ac_current_l3'].toDouble(),
      frequency: json['frequency'].toDouble(),
      dcVoltages: [
        for (int i = 1; i <= 20; i++) json['dc_voltage_s$i'].toDouble()
      ],
      dcCurrents: [
        for (int i = 1; i <= 20; i++) json['dc_current_s$i'].toDouble()
      ],
      statusColors: colors,
    );
  }
}

class InverterDataSource extends DataGridSource {

  InverterDataSource(this.inverterData,this.size) {
    buildDataGridRows();
  }

  List<InverterData> inverterData;
  List<DataGridRow> dataGridRows = [];
  Size size;

  void buildDataGridRows() {
    dataGridRows = [
      // Row for AC Power
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'parameter', value: 'AC Power'),
        for (var data in inverterData)
          DataGridCell<String>(
            columnName: data.acPower.toString(),
            value: '${data.acPower.toStringAsFixed(
                2)} kW', // Added unit for AC Power
          ),
      ]),

      DataGridRow(cells: [
        const DataGridCell<String>(
            columnName: 'parameter', value: 'AC Voltage L1'),
        for (var data in inverterData)
          DataGridCell<String>(
            columnName: data.inverter,
            value: '${data.acVoltageL1.toStringAsFixed(
                2)} V', // Unit added for AC Voltage L1
          ),
      ]),

      // Row for AC Voltage L2
      DataGridRow(cells: [
        const DataGridCell<String>(
            columnName: 'parameter', value: 'AC Voltage L2'),
        for (var data in inverterData)
          DataGridCell<String>(
            columnName: data.inverter,
            value: '${data.acVoltageL2.toStringAsFixed(
                2)} V', // Unit added for AC Voltage L2
          ),
      ]),

      // Row for AC Voltage L3
      DataGridRow(cells: [
        const DataGridCell<String>(
            columnName: 'parameter', value: 'AC Voltage L3'),
        for (var data in inverterData)
          DataGridCell<String>(
            columnName: data.inverter,
            value: '${data.acVoltageL3.toStringAsFixed(
                2)} V', // Unit added for AC Voltage L3
          ),
      ]),

      // Row for AC Current L1
      DataGridRow(cells: [
        const DataGridCell<String>(
            columnName: 'parameter', value: 'AC Current L1'),
        for (var data in inverterData)
          DataGridCell<String>(
            columnName: data.inverter,
            value: '${data.acCurrentL1.toStringAsFixed(
                2)} A', // Unit added for AC Current L1
          ),
      ]),

      // Row for AC Current L2
      DataGridRow(cells: [
        const DataGridCell<String>(
            columnName: 'parameter', value: 'AC Current L2'),
        for (var data in inverterData)
          DataGridCell<String>(
            columnName: data.inverter,
            value: '${data.acCurrentL2.toStringAsFixed(
                2)} A', // Unit added for AC Current L2
          ),
      ]),

      // Row for AC Current L3
      DataGridRow(cells: [
        const DataGridCell<String>(
            columnName: 'parameter', value: 'AC Current L3'),
        for (var data in inverterData)
          DataGridCell<String>(
            columnName: data.inverter,
            value: '${data.acCurrentL3.toStringAsFixed(
                2)} A', // Unit added for AC Current L3
          ),
      ]),

      // Row for Frequency
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'parameter', value: 'Frequency'),
        for (var data in inverterData)
          DataGridCell<String>(
            columnName: data.inverter,
            value: '${data.frequency.toStringAsFixed(2)} Hz', // Unit added for Frequency
          ),
      ]),

      // Rows for S1 to S20 with Voltage and Current values
      for (int i = 1; i <= 20; i++)
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'parameter', value: 'S$i'),
          for (var data in inverterData)
            DataGridCell<Widget>(
              columnName: data.inverter,
              value: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data.dcVoltages[i - 1].toStringAsFixed(2)} V',
                    style:  const TextStyle(color: Colors.black,/*fontSize: size.height * k16TextSize*/),
                  ),
                  Container(
                    height: size.height * 0.026,
                    padding: EdgeInsets.all(size.height * k4TextSize),
                    color: (data.statusColors['S_$i'] == Colors.white)
                        ? null
                        : data.statusColors['S_$i'],
                    child: Text(
                      '${data.dcCurrents[i - 1].toStringAsFixed(2)} A',
                      style:  const TextStyle(color: Colors.black,/*fontSize: size.height * k16TextSize*/),
                    ),
                  ),
                ],
              ),
            ),
        ]),
    ];
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    int rowIndex = dataGridRows.indexOf(row);
    InverterData data = inverterData[rowIndex]; // Get corresponding data

    return DataGridRowAdapter(cells: row.getCells().map((dataCell) {
      String parameter = 's_${dataCell.columnName
          .split('_')
          .last}'; // Ensure it captures the parameter correctly, such as 's_19'
      String statusColor = data.statusColors[parameter].toString() ??
          'default'; // Safely fetch the status color

      Color backgroundColor = _getColorFromStatus(statusColor);
      Color textColor = backgroundColor.computeLuminance() > 0.5
          ? Colors.black
          : Colors.white;

      // Checking if the value is a Widget or needs to be converted to Text
      Widget content = (dataCell.value is Widget)
          ? dataCell.value
          : Text(
        dataCell.value.toString(),
        style: TextStyle(color: textColor),
      );

      return Container(
        padding: EdgeInsets.all(size.height* k8TextSize),
        alignment: Alignment.center,
        color: backgroundColor,
        child: content,
      );
    }).toList());
  }
}


Color _getColorFromStatus(String status) {
  // Remove whitespace and hash symbol if present
  String cleanStatus = status.trim().replaceAll('#', '');

  try {
    // Convert the cleaned hex code to a Color object
    return Color(int.parse('FF$cleanStatus', radix: 16));
  } catch (e) {
    // Fallback to white if parsing fails
    return Colors.white;
  }
}