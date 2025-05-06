import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';



class UtilityAllDataTable extends StatefulWidget {
  const UtilityAllDataTable({super.key});

  @override
  _UtilityAllDataTableState createState() => _UtilityAllDataTableState();
}

class _UtilityAllDataTableState extends State<UtilityAllDataTable> {
  List<UtilityData> utilityDataList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUtilityData();
  }

  Future<void> fetchUtilityData() async {
     String url = '${Urls.baseUrl}/api/get-all-utility-live-data/';
     String token = '${AuthUtilityController.accessToken}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<UtilityData> tempList = [];

        // Process electric data
        if (jsonData['electric_data'] != null) {
          for (var item in jsonData['electric_data']) {
            tempList.add(UtilityData(
              category: 'Electricity',
              liveData: '${item['power'].toStringAsFixed(2)} kW',
              consumption: '${item['today_energy'].toStringAsFixed(2)} kWh',
              cost: '\৳${item['cost'].toStringAsFixed(2)}',
            ));
          }
        }

        // Process water data
        if (jsonData['water_data'] != null) {
          for (var item in jsonData['water_data']) {
            tempList.add(UtilityData(
              category: 'Water',
              liveData: '${item['instant_flow'].toStringAsFixed(2)} m³/h',
              consumption: '${item['volume'].toStringAsFixed(2)} m³',
              cost: '\৳${item['cost'].toStringAsFixed(2)}',
            ));
          }
        }

        setState(() {
          utilityDataList = tempList;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: isLoading
          ?  Center(child:  SpinKitFadingCircle(
        color: AppColors.primaryColor,
        size: 50.0,
      ))
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : utilityDataList.isEmpty
          ? const Center(child: Text('No data available'))
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
            frozenPaneLineColor: AppColors.primaryColor,
            frozenPaneLineWidth: 1.0,
            gridLineColor: Colors.grey.shade300,
            gridLineStrokeWidth: 0.4,
                    ),
                    child: SfDataGrid(
                      showHorizontalScrollbar: false,
                      verticalScrollPhysics: NeverScrollableScrollPhysics(),
            columnWidthMode: size.width > 500 ? ColumnWidthMode.fill : ColumnWidthMode.auto,
            headerGridLinesVisibility: GridLinesVisibility.both,
            gridLinesVisibility: GridLinesVisibility.both,
            source: UtilityDataSource(utilityDataList),
            columns: <GridColumn>[
              GridColumn(
                columnName: 'category',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('Category',style: TextStyle(color: AppColors.whiteTextColor),),
                ),
              ),
              GridColumn(
                columnName: 'liveData',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('Live Data',style: TextStyle(color: AppColors.whiteTextColor),),
                ),
              ),
              GridColumn(
                columnName: 'consumption',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('Consumption',style: TextStyle(color: AppColors.whiteTextColor),),
                ),
              ),
              GridColumn(
                columnName: 'cost',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('Cost',style: TextStyle(color: AppColors.whiteTextColor),),
                ),
              ),
            ],
                    ),
                  ),
          ),
    );
  }
}

class UtilityData {
  final String category;
  final String liveData;
  final String consumption;
  final String cost;

  UtilityData({
    required this.category,
    required this.liveData,
    required this.consumption,
    required this.cost,
  });
}

class UtilityDataSource extends DataGridSource {
  UtilityDataSource(List<UtilityData> utilityDataList) {
    _dataGridRows = utilityDataList
        .map<DataGridRow>((data) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'category', value: data.category),
      DataGridCell<String>(columnName: 'liveData', value: data.liveData),
      DataGridCell<String>(
          columnName: 'consumption', value: data.consumption),
      DataGridCell<String>(columnName: 'cost', value: data.cost),
    ]))
        .toList();
  }

  List<DataGridRow> _dataGridRows = [];

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}