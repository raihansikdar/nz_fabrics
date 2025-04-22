import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/controllers/dgr_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/model/dgr_line_chart_model.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class DgrLineChartTableWidget extends StatelessWidget {
  final DGRLineChartModel lineChartModel;

  const DgrLineChartTableWidget({super.key, required this.lineChartModel});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DgrController>(
      builder: (dgrController) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: Colors.white,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      color: Colors.white,
                    ),
                    height: 450, // Reduced height to accommodate footer
                    child: SfDataGridTheme(
                      data: SfDataGridThemeData(
                        headerColor: AppColors.secondaryTextColor,
                        frozenPaneLineColor: AppColors.primaryColor,
                        frozenPaneLineWidth: 1.0,
                        gridLineColor: Colors.grey.shade300,
                        gridLineStrokeWidth: 0.4,
                      ),
                      child: SfDataGrid(
                        columnWidthMode: MediaQuery.sizeOf(context).width > 500
                            ? ColumnWidthMode.fill
                            : ColumnWidthMode.fitByCellValue,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerRowHeight: 50,
                        rowHeight: 30,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                        frozenColumnsCount: 1,
                        source: DataGridSourceImpl(lineChartModel.data ?? [], lineChartModel.totalEnergy),
                        columns: [
                          GridColumn(
                            width: 180,
                            columnName: 'timedate',
                            label: const Center(
                              child: Text(
                                'Date & Time',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.whiteTextColor),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'acPower',
                            label: const Center(
                              child: Text(
                                'AC Power \n(kW)',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.whiteTextColor),
                              ),
                            ),
                          ),
                          GridColumn(
                            width: 100,
                            columnName: 'pr',
                            label: const Center(
                              child: Text(
                                'PR',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.whiteTextColor),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'irrEast',
                            label: const Center(
                              child: Text(
                                'Irr East \n(W/m²)',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.whiteTextColor),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'irrWest',
                            label: const Center(
                              child: Text(
                                'Irr West \n(W/m²)',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.whiteTextColor),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'todayEnergy',
                            label: const Center(
                              child: Text(
                                'Today\n(kWh)',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.whiteTextColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      // Align "Total" with the first column (timedate)
                      const SizedBox(
                        width: 180, // Match the width of the 'timedate' column
                        child: Text(
                          'Total',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Spacer to push the total value to the last column (todayEnergy)
                      const Spacer(),
                      // Align the total value with the 'todayEnergy' column
                      SizedBox(
                        width: 100, // Adjust width to match the 'todayEnergy' column
                        child: Text(
                          lineChartModel.totalEnergy != null
                              ? _formatNumber((lineChartModel.totalEnergy as num).toDouble(), 'todayEnergy')
                              : '0.00',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DateTime _parseDateTime(String? timedate) {
    if (timedate == null || timedate.isEmpty) {
      return DateTime.now().subtract(const Duration(hours: 6));
    }
    try {
      return DateTime.parse(timedate).toLocal().subtract(const Duration(hours: 6));
    } catch (e) {
      return DateTime.now().subtract(const Duration(hours: 6));
    }
  }

  String _formatNumber(double number, String columnName) {
    String unit = '';
    if (columnName == 'acPower') {
      unit = ' kW';
    } else if (columnName == 'irrEast' || columnName == 'irrWest') {
      unit = ' W/m²';
    } else if (columnName == 'todayEnergy') {
      unit = ' kWh';
    }

    // Format with 2 decimal places and remove trailing zeros
    String formattedNumber = number.toStringAsFixed(2)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
    return '$formattedNumber$unit';
  }
}

class DataGridSourceImpl extends DataGridSource {
  final List<Data> data;
  final dynamic totalEnergy;
  late List<DataGridRow> _dataGridRows;

  DataGridSourceImpl(this.data, this.totalEnergy) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    // Only include regular data rows (Total is moved to footer)
    _dataGridRows = data.map((data) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'timedate', value: data.timedate ?? ''),
        DataGridCell<double>(columnName: 'acPower', value: data.acPower ?? 0.0),
        DataGridCell<double>(columnName: 'pr', value: data.pr ?? 0.0),
        DataGridCell<double>(columnName: 'irrEast', value: data.irrEast ?? 0.0),
        DataGridCell<double>(columnName: 'irrWest', value: data.irrWest ?? 0.0),
        DataGridCell<double>(columnName: 'todayEnergy', value: data.todayEnergy ?? 0.0),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  // @override
  // DataGridRowAdapter? buildRow(DataGridRow row) {
  //   return DataGridRowAdapter(cells: [
  //     for (final cell in row.getCells())
  //       Container(
  //         alignment: Alignment.center,
  //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //         child: Text(
  //           cell.columnName == 'timedate'
  //               ? _formatDateTime(cell.value)
  //               : _formatNumber(cell.value, cell.columnName),
  //         ),
  //       ),
  //   ]);
  // }
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    // Get the index of the current row
    int rowIndex = rows.indexOf(row);
    bool isTotalRow = row.getCells().first.value == 'Total';
    bool isOddRow = rowIndex % 2 == 1; // Odd-indexed rows (1, 3, 5...) will have no background

    return DataGridRowAdapter(
      cells: [
        for (final cell in row.getCells())
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            color: isTotalRow
                ? const Color(0xFFD3D3D3) // Distinct background color for Total row
                : (isOddRow && !isTotalRow)
                ? null // No background for odd rows (except Total row)
                : const Color(0xFFE0E1FF), // Background for even rows
            child: Text(
              cell.columnName == 'timedate'
                  ? _formatDateTime(cell.value)
                  : _formatNumber(cell.value, cell.columnName),
              style: TextStyle(
                fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal, // Bold text for Total row
              ),
            ),
          ),
      ],
    );
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return 'N/A';
    }
    try {
      final DateTime parsedDateTime = DateTime.parse(dateTimeString).toLocal();
      return DateFormat('dd-MMM-yyyy HH:mm:ss').format(parsedDateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String _formatNumber(dynamic value, String columnName) {
    if (value == null) {
      return '0.00';
    }
    double number = (value is num) ? value.toDouble() : 0.0;
    String unit = '';
    if (columnName == 'acPower') {
      unit = '';
    } else if (columnName == 'irrEast' || columnName == 'irrWest') {
      unit = '';
    } else if (columnName == 'todayEnergy') {
      unit = '';
    }

    // Format with 2 decimal places and remove trailing zeros
    String formattedNumber = number.toStringAsFixed(2)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
    return '$formattedNumber$unit';
    }
}