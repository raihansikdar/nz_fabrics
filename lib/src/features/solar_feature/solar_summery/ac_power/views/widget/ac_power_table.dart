import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/model/plant_today_data_model.dart';
import '../../controller/ac_power_today_data_controller.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class AcPowerTableWidget extends StatelessWidget {
  const AcPowerTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: GetBuilder<AcPowerTodayDataController>(
        init: AcPowerTodayDataController()..fetchPlantTodayData(),
        builder: (controller) {
          if (controller.isAcPowerDataInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.plantTodayDataList.isEmpty) {
            return Center(
              child: Text(
                controller.errorMessage.isNotEmpty
                    ? controller.errorMessage
                    : 'No data available',
              ),
            );
          }

          // Sort the data in descending order by timedate
          final sortedData = List<PlantTodayDataModel>.from(controller.plantTodayDataList)
            ..sort((a, b) => b.timedate!.compareTo(a.timedate!));

         // log('Sorted Data: ${sortedData.map((e) => e.timedate).toList()}');

          return SfDataGridTheme(
            data: SfDataGridThemeData(headerColor: AppColors.secondaryTextColor),
            child: Container(
              clipBehavior: Clip.antiAlias,  // Use Clip.hardEdge for hard edge clipping
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SfDataGrid(
                columnWidthMode: ColumnWidthMode.fill,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                source: AcPowerDataSource(sortedData),
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'timedate',
                    label: Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: const Text(
                        'Time Date',
                        style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.whiteTextColor),
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'totalAcPower',
                    label: Container(
                      padding: const EdgeInsets.all(8),
                      alignment: Alignment.center,
                      child: const Text(
                        'AC Power (kW)',
                        style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.whiteTextColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AcPowerDataSource extends DataGridSource {
  final List<PlantTodayDataModel> data;

  AcPowerDataSource(this.data) {
    log('AcPowerDataSource initialized with ${data.length} items');
  }

  @override
  List<DataGridRow> get rows => data.map<DataGridRow>((data) {
    return DataGridRow(cells: [
      DataGridCell<String>(
        columnName: 'timedate',
        value: data.timedate != null
            ? DateFormat('yyyy-MM-dd HH:mm').format(data.timedate!)
            : 'N/A', // Format DateTime or display 'N/A' if null
      ),
      DataGridCell<String>(
        columnName: 'totalAcPower',
        value: data.totalAcPower != null
            ? data.totalAcPower!.toStringAsFixed(2) // Two decimal places
            : '0.00', // Default if null
      ),
    ]);
  }).toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(
            dataGridCell.value.toString(),
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }
}