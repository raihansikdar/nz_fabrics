import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/empty_page_widget/empty_page_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:http/http.dart' as http;


class SelectedPlantDataGridWidget extends StatelessWidget {
  final String columnNamed;
  final String? time;

  SelectedPlantDataGridWidget({super.key, required this.columnNamed, this.time});

  final PlantDataController _controller = Get.put(PlantDataController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    _controller.setSelectedColumn(columnNamed);

    if (time != null) {
      _controller.fetchSelectedTime(time!);
    } else {
      _controller.fetchData();
    }

    return GetBuilder<PlantDataController>(
        builder: (controller) {
          if (controller.isLoading) {
            return Center(
              child: SpinKitFadingCircle(
                color: AppColors.primaryColor,
                size: 50.0,
              ),
            );
          }
          else if(controller.plantDataList.isEmpty){
            return EmptyPageWidget(size: size);
          }

          return Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
              color: Colors.white,
            ),
            child: SfDataGridTheme(
              data: SfDataGridThemeData(headerColor: AppColors.secondaryTextColor),
              child: SfDataGrid(
                columnWidthMode: ColumnWidthMode.fill,
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                source: controller.plantDataSource,
                columns: [
                  GridColumn(
                    columnName: 'timedate',
                    label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.center,
                      child: TextComponent(
                        text: 'Time Date',
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.whiteTextColor,
                        fontFamily: boldFontFamily,
                        fontSize: size.height * k17TextSize,
                      ),
                    ),
                  ),
                  if (controller.selectedColumn == 'irr_east')
                    GridColumn(
                      columnName: 'irr_east',
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.center,
                        child: TextComponent(
                          text: 'Irr East',
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.whiteTextColor,
                          fontFamily: boldFontFamily,
                          fontSize: size.height * k17TextSize,
                        ),
                      ),
                    ),
                  if (controller.selectedColumn == 'irr_west')
                    GridColumn(
                      columnName: 'irr_west',
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.center,
                        child: TextComponent(
                          text: 'Irr West',
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.whiteTextColor,
                          fontFamily: boldFontFamily,
                          fontSize: size.height * k17TextSize,
                        ),
                      ),
                    ),
                  if (controller.selectedColumn == 'module_temperature')
                    GridColumn(
                      columnName: 'module_temperature',
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.center,
                        child: TextComponent(
                          text: 'Module Temperature',
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.whiteTextColor,
                          fontFamily: boldFontFamily,
                          fontSize: size.height * k17TextSize,
                        ),
                      ),
                    ),
                  if (controller.selectedColumn == 'ambient_temperature')
                    GridColumn(
                      columnName: 'ambient_temperature',
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.center,
                        child: TextComponent(
                          text: 'Ambient Temperature',
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.whiteTextColor,
                          fontFamily: boldFontFamily,
                          fontSize: size.height * k17TextSize,
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

class PlantData {
  PlantData({
    required this.timedate,
    required this.irrEast,
    required this.irrWest,
    required this.moduleTemperature,
    required this.ambientTemperature,
  });

  final String timedate;
  final double irrEast;
  final double irrWest;
  final double moduleTemperature;
  final double ambientTemperature;

  factory PlantData.fromJson(Map<String, dynamic> json, {required String selectedColumn}) {
    String formattedTime = '';
    try {
      DateTime parsedDate = DateTime.parse(json['timedate']);
      formattedTime = DateFormat('H:mm').format(parsedDate); // Hour and minute in 24-hour format
    } catch (e) {
      formattedTime = 'Invalid Date'; // Handle invalid date format
    }
    return PlantData(
      timedate: formattedTime,
      irrEast: selectedColumn == 'irr_east' ? json['irr_east'] ?? 0.0 : 0.0,
      irrWest: selectedColumn == 'irr_west' ? json['irr_west'] ?? 0.0 : 0.0,
      moduleTemperature: selectedColumn == 'module_temperature' ? json['module_temperature'] ?? 0.0 : 0.0,
      ambientTemperature: selectedColumn == 'ambient_temperature' ? json['ambient_temperature'] ?? 0.0 : 0.0,
    );
  }
}

class PlantDataSource extends DataGridSource {
  final String selectedColumn;

  PlantDataSource({required List<PlantData> plantData, required this.selectedColumn}) {
    dataGridRows = plantData
        .map<DataGridRow>((data) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'timedate', value: data.timedate),
      if (selectedColumn == 'irr_east')
        DataGridCell<double>(columnName: 'irr_east', value: data.irrEast),
      if (selectedColumn == 'irr_west')
        DataGridCell<double>(columnName: 'irr_west', value: data.irrWest),
      if (selectedColumn == 'module_temperature')
        DataGridCell<double>(columnName: 'module_temperature', value: data.moduleTemperature),
      if (selectedColumn == 'ambient_temperature')
        DataGridCell<double>(columnName: 'ambient_temperature', value: data.ambientTemperature),
    ]))
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList());
  }
}

class PlantDataController extends GetxController {
  List<PlantData> plantDataList = [];
  late PlantDataSource plantDataSource;
  String selectedColumn = '';
  String url = Urls.getPlantTodayDataUrl;
  bool isLoading = true;

  void setSelectedColumn(String columnNamed) {
    switch (columnNamed) {
      case 'Irr East':
        selectedColumn = 'irr_east';
        break;
      case 'Irr West':
        selectedColumn = 'irr_west';
        break;
      case 'Module Temp':
        selectedColumn = 'module_temperature';
        break;
      case 'Ambient Temp':
        selectedColumn = 'ambient_temperature';
        break;
      default:
        selectedColumn = '';
    }
  }

  Future<void> fetchData() async {
    isLoading = true;
    update();
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': '${AuthUtilityController.accessToken}',
      });

      log("==== fetchData Controller===> ${response.statusCode}");
      log("==== fetchData Controller===> ${response.body}");
    //  log("=======> ${AuthUtilityController.accessToken}");
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        plantDataList = data
            .reversed
            .map((e) => PlantData.fromJson(e, selectedColumn: selectedColumn))
            .toList();
        plantDataSource = PlantDataSource(
          plantData: plantDataList,
          selectedColumn: selectedColumn,
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error fetching data: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchSelectedTime(String time) async {
    isLoading = true;
    update();
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': '${AuthUtilityController.accessToken}',
      });
      log("======fetchSelectedTime => ${response.statusCode}");
      log("======Bottom Sheet SelectedTime => ${time}");
      //log("======fetchSelectedTime => ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // final filteredData = data.where((entry) {
        //   try {
        //     String timedate = entry['timedate'];
        //     String timePart = timedate.split('T')[1];
        //     String hour = timePart.split(':')[0];
        //
        //     log("timePart===$timePart");
        //     log("hour===$hour");
        //
        //     return hour == time;
        //   } catch (e) {
        //     return false;
        //   }
        // }).toList();

        final filteredData = data.where((entry) {
          try {
            String timedate = entry['timedate'];
            String timePart = timedate.split('T')[1];
            String hour = timePart.split(':')[0];

            log("timePart === $timePart");
            log("hour === $hour");

            return int.parse(hour) == int.parse(time); // Convert both to integers
          } catch (e) {
            return false;
          }
        }).toList();


        plantDataList = filteredData
            .reversed
            .map((e) => PlantData.fromJson(e, selectedColumn: selectedColumn))
            .toList();
        plantDataSource = PlantDataSource(
          plantData: plantDataList,
          selectedColumn: selectedColumn,
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error fetching data: $e');
    } finally {
      isLoading = false;
      update();
    }
  }
}