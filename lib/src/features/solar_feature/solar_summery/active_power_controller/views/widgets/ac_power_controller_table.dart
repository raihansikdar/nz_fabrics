import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/empty_page_widget/empty_page_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/model/plant_today_data_model.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/active_power_controller/controller/plant_today_data_controller.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ACPowerControlTable extends StatelessWidget {
  const ACPowerControlTable({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GetBuilder<PlantTodayDataController>(
        init: PlantTodayDataController()..fetchPlantTodayData(),
        builder: (controller) {
          if (controller.isAssortedDataInProgress) {
            return  Center(child: SpinKitFadingCircle(
              color: AppColors.primaryColor,
              size: 50.0,
            ),);
          }

          if (controller.plantTodayDataList.isEmpty) {
            return EmptyPageWidget(size: size);
          }

          // Sort data in descending order by time (most recent first)
          final sortedData = List<PlantTodayDataModel>.from(controller.plantTodayDataList)
            ..sort((a, b) => b.timedate!.compareTo(a.timedate!));

          final List<GridRowData> tableData = sortedData.map((data) {
            return GridRowData(
              timedate: data.timedate,
              activePowerController1: data.activePowerControl1,
              activePowerController2: data.activePowerControl2,
            );
          }).toList();

          return Container(
            clipBehavior: Clip.antiAlias,  // Use Clip.hardEdge for hard edge clipping
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SfDataGridTheme(
              data: SfDataGridThemeData(headerColor: AppColors.secondaryTextColor),
              child: SfDataGrid(
                columnWidthMode: ColumnWidthMode.fill,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                source: GridDataSource(tableData,size),
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'timedate',
                    label: Container(
                      padding: EdgeInsets.all(size.height * k8TextSize),
                      alignment: Alignment.center,
                      child:  const Text(
                        'Time Date',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: boldFontWeight,color: AppColors.whiteTextColor),
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'totalAcPower',
                    label: Container(
                      padding: EdgeInsets.all(size.height * k8TextSize),
                      alignment: Alignment.center,
                      child: const Text(
                        'Act. Power Ctrl. 1',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: boldFontWeight,color: AppColors.whiteTextColor),
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'irrEast',
                    label: Container(
                      padding: EdgeInsets.all(size.height * k8TextSize),
                      alignment: Alignment.center,
                      child: const Text(
                        'Act. Power Ctrl. 2',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: boldFontWeight,color: AppColors.whiteTextColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },

    );
  }
}

class GridRowData {
  GridRowData({
    required this.timedate,
    required this.activePowerController1,
    required this.activePowerController2,
  });

  final DateTime? timedate;
  final double? activePowerController1;
  final double? activePowerController2;
}

class GridDataSource extends DataGridSource {
  final List<GridRowData> gridData;

  GridDataSource(this.gridData,this.size);

  Size size;

  @override
  List<DataGridRow> get rows => gridData.map<DataGridRow>((data) {
    return DataGridRow(cells: [
      DataGridCell<String>(
        columnName: 'timedate',
        value: data.timedate != null
            ? DateFormat('yyyy-MM-dd HH:mm').format(data.timedate!)
            : 'N/A',
      ),
      DataGridCell<String>(
        columnName: 'totalAcPower',
        value: data.activePowerController1 != null
            ? data.activePowerController1!.toStringAsFixed(2)
            : '0.00',
      ),
      DataGridCell<String>(
        columnName: 'irrEast',
        value: data.activePowerController2 != null
            ? data.activePowerController2!.toStringAsFixed(2)
            : '0.00',
      ),
    ]);
  }).toList();

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(size.height * k8TextSize),
          child: Text(
            dataGridCell.value.toString(),
            style: TextStyle(fontSize: size.height * k14TextSize),
          ),
        );
      }).toList(),
    );
  }
}
