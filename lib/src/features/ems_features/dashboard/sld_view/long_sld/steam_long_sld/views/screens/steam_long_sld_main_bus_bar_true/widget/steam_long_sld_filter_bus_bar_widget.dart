import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/steam_long_sld/model/steam_long_main_bus_bar_true_model/steam_long_filter_bus_bar_const_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';


class SteamLongSLDFilterBusBarWidget extends StatelessWidget {

  final List<SteamLongFilterBusBarEnergyCostModel> monthlyDataList;
  final Size size;
  final int dateDifference;

  const SteamLongSLDFilterBusBarWidget({super.key, required this.size, required this.dateDifference, required this.monthlyDataList});

  @override
  Widget build(BuildContext context) {
    final List<MonthlyChartData> monthlyChartData = monthlyDataList
        .map((monthlyData) => MonthlyChartData(
      date: parseDate(monthlyData.date!),
      energy: (monthlyData.energy ?? 0).toDouble(),
      cost: (monthlyData.cost ?? 0).toDouble(),
    ))
        .toList();

    return Card(
      color: AppColors.whiteTextColor,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: (dateDifference > 3 && dateDifference< 60) ? 1200 : size.width,
          child: SfCartesianChart(
            legend: const Legend(
              isVisible: true,
              overflowMode: LegendItemOverflowMode.wrap,
              position: LegendPosition.top,
            ),
            trackballBehavior: TrackballBehavior(
              enable: true,
              tooltipAlignment: ChartAlignment.near,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              activationMode: ActivationMode.longPress,
            ),
            primaryXAxis: DateTimeAxis(
              dateFormat: getDateFormat(monthlyDataList.isNotEmpty ? monthlyDataList.first.date! : '2022-01-01'),
              intervalType: dateDifference > 60 ? DateTimeIntervalType.months : DateTimeIntervalType.days,

              majorGridLines: const MajorGridLines(width: 1),
            ),
            primaryYAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 1),
              numberFormat: NumberFormat.compact(),
              labelFormat: '{value}',
            ),
            series: <CartesianSeries>[
              ColumnSeries<MonthlyChartData, DateTime>(
                  dataSource: monthlyChartData,
                  xValueMapper: (MonthlyChartData data, _) => data.date,
                  yValueMapper: (MonthlyChartData data, _) => data.energy,
                  name: 'Volume(m³)',
                  color: Colors.deepPurple

              ),
              ColumnSeries<MonthlyChartData, DateTime>(
                  dataSource: monthlyChartData,
                  xValueMapper: (MonthlyChartData data, _) => data.date,
                  yValueMapper: (MonthlyChartData data, _) => data.cost,
                  name: 'Cost(BDT)',
                  color: Colors.orange

              ),
            ],
          ),
        ),
      ),
    );
  }

  DateFormat getDateFormat(String dateString) {
    final monthYearFormat = DateFormat("yyyy-MM");
    DateTime parsedDate;
    try {
      parsedDate = monthYearFormat.parseStrict(dateString);
      return DateFormat('MMM/yyyy');
    } catch (e) {
      return DateFormat('dd/MMM');
    }
  }

}

class MonthlyChartData {
  final DateTime date;
  final dynamic energy;
  final dynamic cost;

  MonthlyChartData({required this.date, required this.energy, required this.cost});
}

DateTime parseDate(String dateString) {
  final monthYearFormat = DateFormat("yyyy-MM");
  final fullDateFormat = DateFormat("yyyy-MM-dd");
  DateTime? parsedDate;

  try {
    parsedDate = monthYearFormat.parseStrict(dateString);
  } catch (e) {
    try {
      parsedDate = fullDateFormat.parseStrict(dateString);
    } catch (e) {
      return DateTime.now();
    }
  }

  return parsedDate;
}




class FilterBusBarTableWidget extends StatelessWidget {
  final List<SteamLongFilterBusBarEnergyCostModel> monthlyDataList;
  final Size size;

  const FilterBusBarTableWidget({
    super.key,
    required this.size,
    required this.monthlyDataList,
  });

  @override
  Widget build(BuildContext context) {
    if (monthlyDataList.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    return Card(
      color: AppColors.whiteTextColor,
      child: SizedBox(
        width: size.width,
        height: size.height * 0.7,
        child: SfDataGridTheme(
          data: SfDataGridThemeData(headerColor: AppColors.secondaryTextColor),
          child: SfDataGrid(
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,                        // columns: getColumns,
            columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
            source: MonthlyDataSource(monthlyDataList: monthlyDataList),
            columnWidthMode: ColumnWidthMode.fill,
            columns: <GridColumn>[
              GridColumn(
                columnName: 'date',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('Date',  style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.whiteTextColor),
                  ),

                ),
              ),
              GridColumn(
                columnName: 'energy',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('Energy', style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.whiteTextColor),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'cost',
                label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: const Text('Cost', style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.whiteTextColor),
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
class MonthlyDataSource extends DataGridSource {
  final List<SteamLongFilterBusBarEnergyCostModel> monthlyDataList;
  final DateFormat monthYearFormat = DateFormat("MMM/yyyy");
  final DateFormat dayFormat = DateFormat("dd/MMM/yyyy");

  MonthlyDataSource({required this.monthlyDataList}) {
    buildDataGridRows();
  }

  List<DataGridRow> _dataGridRows = [];

  void buildDataGridRows() {
    _dataGridRows = monthlyDataList.map<DataGridRow>((data) {
      final date = parseDate(data.date!);
      final dateString = _isMonthOnly(data.date!)
          ? monthYearFormat.format(date)
          : dayFormat.format(date);

      // Add units to the values
      final energyValue = "${(data.energy ?? 0).toDouble().toStringAsFixed(2)} kWh";
      final costValue = "${(data.cost ?? 0).toDouble().toStringAsFixed(2)} BDT";

      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'date', value: dateString),
        DataGridCell<String>(
          columnName: 'energy',
          value: energyValue,
        ),
        DataGridCell<String>(
          columnName: 'cost',
          value: costValue,
        ),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell.value.toString(),
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }

  bool _isMonthOnly(String dateString) {
    final monthYearFormat = DateFormat("yyyy-MM");
    try {
      monthYearFormat.parseStrict(dateString);
      return true;
    } catch (e) {
      return false;
    }
  }

  DateTime parseDate(String dateString) {
    final monthYearFormat = DateFormat("yyyy-MM");
    final fullDateFormat = DateFormat("yyyy-MM-dd");

    try {
      return monthYearFormat.parseStrict(dateString);
    } catch (e) {
      try {
        return fullDateFormat.parseStrict(dateString);
      } catch (e) {
        return DateTime.now();
      }
    }
  }
}