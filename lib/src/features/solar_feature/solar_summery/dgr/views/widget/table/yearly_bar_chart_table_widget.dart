
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/model/dgr_yearly_bar_chart_model.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

class DgrYearlyBarChartTableWidget extends StatelessWidget {
  final DGRYearlyBarChartModel yearlyBarChartModel;

  const DgrYearlyBarChartTableWidget({super.key, required this.yearlyBarChartModel});

  @override
  Widget build(BuildContext context) {
    List<Data> chartData = yearlyBarChartModel.data ?? [];

    // Format the date for both chart and table
    List<Data> formattedChartData = chartData.map((data) {
      try {
        DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(data.date ?? '');
        data.date = DateFormat("yyyy-MM-dd").format(parsedDate);
        log(data.date.toString());
      } catch (e) {
        data.date = '';
      }
      return data;
    }).toList();

    final YearlyDataSource dataSource = YearlyDataSource(data: formattedChartData);

    // Calculate the total energy for the footer
    final double totalEnergySum = formattedChartData.fold(0.0, (sum, item) => sum + (item.totalEnergy ?? 0.0));

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
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
                    selectionColor: Colors.transparent, // Disable selection color if any
                    currentCellStyle: const DataGridCurrentCellStyle(
                      borderWidth: 0,
                      borderColor: Colors.transparent,
                    ),
                  ),
                  child: SfDataGrid(
                    source: dataSource,
                    columnWidthMode: MediaQuery.sizeOf(context).width > 500
                        ? ColumnWidthMode.fill
                        : ColumnWidthMode.auto,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    headerRowHeight: 50,
                    rowHeight: 30,
                    allowSorting: false, // Disable sorting to avoid interference
                    allowFiltering: false, // Disable filtering to avoid interference
                    columns: [
                      GridColumn(
                        columnName: 'date',
                        label: Container(
                          alignment: Alignment.center,
                          child: TextComponent(
                            text: 'Date',
                            fontSize: MediaQuery.sizeOf(context).width > 500 ? 13 : 13,
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.whiteTextColor,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'cumulativePr',
                        label: Container(
                          alignment: Alignment.center,
                          child: TextComponent(
                            text: 'Cumulative PR',
                            fontSize: MediaQuery.sizeOf(context).width > 500 ? 13 : 13,
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.whiteTextColor,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'poaDayAvg',
                        label: Container(
                          alignment: Alignment.center,
                          child: TextComponent(
                            text: 'POA Day Avg',
                            overflow: TextOverflow.ellipsis,
                            fontSize: MediaQuery.sizeOf(context).width > 500 ? 13 : 13,
                            color: AppColors.whiteTextColor,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'maxAcPower',
                        label: Container(
                          alignment: Alignment.center,
                          child: TextComponent(
                            text: 'Max AC Power',
                            overflow: TextOverflow.ellipsis,
                            fontSize: MediaQuery.sizeOf(context).width > 500 ? 13 : 13,
                            color: AppColors.whiteTextColor,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'expectedEnergy',
                        label: Container(
                          alignment: Alignment.center,
                          child: TextComponent(
                            text: 'Expected Energy',
                            fontSize: MediaQuery.sizeOf(context).width > 500 ? 13 : 13,
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.whiteTextColor,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'totalEnergy',
                        label: Container(
                          alignment: Alignment.center,
                          child: TextComponent(
                            text: 'Total Energy',
                            fontSize: MediaQuery.sizeOf(context).width > 500 ? 13 : 13,
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.whiteTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Add footer with total energy sum
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                // Align "Total" with the 'date' column
                const SizedBox(
                  width: 100, // Adjust to match the 'date' column width
                  child: Text(
                    'Total',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // Spacer to push the total value to the 'totalEnergy' column
                const Spacer(),
                // Empty space for the columns between date and totalEnergy
                const SizedBox(width: 100), // For maxAcPower column
                const SizedBox(width: 100), // For expectedEnergy column
                // Align the total value with the 'totalEnergy' column
                SizedBox(
                  width: 100, // Adjust to match the 'totalEnergy' column width
                  child: Text(
                    _formatNumber(totalEnergySum, unit: 'kWh'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double? number, {String unit = ''}) {
    if (number == null) {
      return '0.00 $unit';
    }
    // Format with 2 decimal places and remove trailing zeros
    String formattedNumber = number
        .toStringAsFixed(2)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
    return '$formattedNumber $unit';
  }
}

class YearlyDataSource extends DataGridSource {
  final List<Data> data;
  int _rowIndex = -1; // Add a counter to track the row index
  YearlyDataSource({required this.data});

  @override
  List<DataGridRow> get rows => data.map((data) {
    return DataGridRow(cells: [
      DataGridCell<String>(columnName: 'date', value: data.date),
      DataGridCell<String>(
          columnName: 'cumulativePr', value: _formatNumber(data.cumulativePr)),
      DataGridCell<String>(
          columnName: 'poaDayAvg',
          value: _formatNumber(data.poaDayAvg, unit: 'kWh/m²')),
      DataGridCell<String>(
          columnName: 'maxAcPower',
          value: _formatNumber(data.maxAcPower, unit: 'kW')),
      DataGridCell<String>(
          columnName: 'expectedEnergy',
          value: _formatNumber(data.expectedEnergy, unit: 'kWh')),
      DataGridCell<String>(
          columnName: 'totalEnergy',
          value: _formatNumber(data.totalEnergy, unit: 'kWh')),
    ]);
  }).toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {

    _rowIndex++;
    bool isOddRow = _rowIndex % 2 == 1;



    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          // Use distinct colors for debugging
          color: isOddRow ?  null : const Color(0xFFE0E1FF), // Debug colors
          child: Text(
            cell.value.toString(),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatNumber(double? number, {String unit = ''}) {
    if (number == null) {
      return '0.00 $unit';
    }
    return '${number.toStringAsFixed(2)} $unit';
  }
}