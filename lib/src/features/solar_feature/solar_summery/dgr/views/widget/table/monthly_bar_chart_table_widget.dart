
import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/model/dgr_monthly_chart_model.dart';

class DgrMonthlyBarChartTableWidget extends StatelessWidget {
  final DGRMonthlyChartModel monthlyBarChartModel;

  const DgrMonthlyBarChartTableWidget({super.key, required this.monthlyBarChartModel});

  @override
  Widget build(BuildContext context) {
    List<Data> chartData = monthlyBarChartModel.data ?? [];
    final DgrDataSource dataSource = DgrDataSource(data: chartData);

    // Calculate the total energy for the footer
    final double totalEnergySum = chartData.fold(0.0, (sum, item) => sum + (item.totalEnergy ?? 0.0));

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
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
                        : ColumnWidthMode.auto,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    headerRowHeight: 50,
                    rowHeight: 30,
                    columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                    source: dataSource,
                    columns: [
                      GridColumn(
                        columnName: 'date',
                        label: Container(
                          alignment: Alignment.center,
                          child: TextComponent(
                            text: 'Date',
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.whiteTextColor,
                            fontSize: MediaQuery.sizeOf(context).width > 500 ? 13 : 16,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'cumulativePr',
                        label: Container(
                          alignment: Alignment.center,
                          child: TextComponent(
                            text: 'Cumulative PR',
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.whiteTextColor,
                            fontSize: MediaQuery.sizeOf(context).width > 500 ? 13 : 16,
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
                            color: AppColors.whiteTextColor,
                            fontSize: MediaQuery.sizeOf(context).width > 500 ? 13 : 16,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'expectedEnergy',
                        label: Center(
                          child: TextComponent(
                            text: 'Expected (kWh)',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.whiteTextColor,
                            fontSize: MediaQuery.sizeOf(context).width > 500 ? 13 : 16,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'totalEnergy',
                        label: Container(
                          alignment: Alignment.center,
                          child: TextComponent(
                            text: 'Total (kWh)',
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.whiteTextColor,
                            fontSize: MediaQuery.sizeOf(context).width > 500 ? 13 : 16,
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'maxAcPower',
                        label: Container(
                          alignment: Alignment.center,
                          child: TextComponent(
                            text: 'Max AC (kW)',
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.whiteTextColor,
                            fontSize: MediaQuery.sizeOf(context).width > 500 ? 13 : 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
                // Align the total value with the 'totalEnergy' column
                SizedBox(
                  width: 100, // Adjust to match the 'totalEnergy' column width
                  child: Text(
                    _formatNumber(totalEnergySum, unit: 'kWh'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // Spacer to align with the last column (maxAcPower)
                const SizedBox(width: 100), // Adjust to match the 'maxAcPower' column width
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
    String formattedNumber = number.toStringAsFixed(2)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
    return '$formattedNumber $unit';
  }
}

class DgrDataSource extends DataGridSource {
  final List<Data> data;
  late List<DataGridRow> _dataGridRows;

  DgrDataSource({required this.data}) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    _dataGridRows = data.map((data) {
      return DataGridRow(cells: [
        DataGridCell<String>(
          columnName: 'date',
          value: _formatDate(data.date),
        ),
        DataGridCell<String>(
          columnName: 'cumulativePr',
          value: _formatNumber(data.cumulativePr), // Assuming PR is in percentage
        ),
        DataGridCell<String>(
          columnName: 'poaDayAvg',
          value: _formatNumber(data.poaDayAvg, unit: ''),
        ),
        DataGridCell<String>(
          columnName: 'expectedEnergy',
          value: _formatNumber(data.expectedEnergy, unit: ''),
        ),
        DataGridCell<String>(
          columnName: 'totalEnergy',
          value: _formatNumber(data.totalEnergy, unit: ''),
        ),
        DataGridCell<String>(
          columnName: 'maxAcPower',
          value: _formatNumber(data.maxAcPower, unit: ''),
        ),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

/*  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell.value.toString(),
            overflow: TextOverflow.ellipsis,
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
          padding: const EdgeInsets.all(8.0),
          color: isTotalRow
              ? const Color(0xFFD3D3D3) // Distinct background color for Total row
              : (isOddRow && !isTotalRow)
              ? null // No background for odd rows (except Total row)
              : const Color(0xFFE0E1FF), // Background for even rows
          child: Text(
            cell.value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal, // Bold text for Total row
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    return date; // Return the date as it is since it's already formatted
  }

  String _formatNumber(double? number, {String unit = ''}) {
    if (number == null) {
      return '0.00 $unit';
    }
    // Format with 2 decimal places and remove trailing zeros
    String formattedNumber = number.toStringAsFixed(2)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
    return '$formattedNumber $unit';
  }
}