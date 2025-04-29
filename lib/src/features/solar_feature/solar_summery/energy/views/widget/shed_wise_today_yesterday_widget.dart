
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Border, Row, Column;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';

class ShedWiseEnergyChartWidget extends StatefulWidget {
  @override
  State<ShedWiseEnergyChartWidget> createState() => _ShedWiseEnergyChartWidgetState();
}

class _ShedWiseEnergyChartWidgetState extends State<ShedWiseEnergyChartWidget> {
  List<ShedData> shedDataList = [];
  late ShedDataSource _shedDataSource;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var url = Urls.getShedTodayYesterdayEnergyUrl;
    var token = '${AuthUtilityController.accessToken}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['sheds'];
        final double totalEnergy = jsonResponse['total_energy']; // Today total energy from API

        setState(() {
          shedDataList = data
              .map((item) => ShedData(
            shedName: item['shed_name'],
            todayEnergy: double.parse(item['today_energy'].toStringAsFixed(2)),
            yesterdayEnergy: double.parse(item['yesterday_energy'].toStringAsFixed(2)),
            todayDate: DateTime.parse(item['timedate']),
            yesterdayDate: DateTime.parse(item['timedate']),
          ))
              .toList();

          // Calculate total yesterday energy if needed (not provided by API)
          final double totalYesterdayEnergy = shedDataList.fold(0, (sum, item) => sum + item.yesterdayEnergy);

          _shedDataSource = ShedDataSource(
            shedDataList,
            MediaQuery.of(context).size,
            totalEnergy, // Today total from API
            totalYesterdayEnergy, // Calculated yesterday total
          );
        });
      } else {
        log('Failed to load data with status code: ${response.statusCode}');
      }
    } catch (error) {
      log('Error: $error');
    }
  }

  Future<PermissionStatus> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;

      if (android.version.sdkInt < 33) {
        return await Permission.storage.request();
      } else {
        return PermissionStatus.granted;
      }
    } else if (Platform.isIOS) {
      return PermissionStatus.granted;
    }
    return PermissionStatus.denied;
  }

  Future<void> downloadDataSheet(BuildContext context) async {
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        final Workbook workbook = Workbook();
        final Worksheet sheet = workbook.worksheets[0];
        sheet.name = 'Shed Energy Report';

        sheet.getRangeByIndex(1, 1, 1, 1).columnWidth = 20;
        sheet.getRangeByIndex(1, 2, 1, 2).columnWidth = 15;
        sheet.getRangeByIndex(1, 3, 1, 3).columnWidth = 15;
        sheet.getRangeByIndex(1, 4, 1, 4).columnWidth = 15; // Added for yesterday energy

        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        final List<String> headers = [
          'Shed Name',
          'Today Energy (kWh)',
          'Yesterday Energy (kWh)', // Added
          'Today Date',
        ];
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
          sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
        }

        for (int i = 0; i < shedDataList.length; i++) {
          final rowIndex = i + 2;
          final data = shedDataList[i];
          sheet.getRangeByIndex(rowIndex, 1).setText(data.shedName ?? 'N/A');
          sheet.getRangeByIndex(rowIndex, 2).setNumber(data.todayEnergy ?? 0);
          sheet.getRangeByIndex(rowIndex, 3).setNumber(data.yesterdayEnergy ?? 0); // Added
          sheet.getRangeByIndex(rowIndex, 4).setText(data.todayDate != null
              ? DateFormat('dd-MMM-yyyy').format(data.todayDate)
              : 'N/A');
        }

        sheet.autoFitRow(1);

        String? filePath;
        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (directory.existsSync()) {
            String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
            filePath = "${directory.path}/Shed_Energy_Report_$formattedDate $formattedTime.xlsx";
          }
        } else if (Platform.isIOS) {
          final directory = await getApplicationDocumentsDirectory();
          String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
          String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
          filePath = "${directory.path}/Shed_Energy_Report_$formattedDate $formattedTime.xlsx";
        }

        if (filePath != null) {
          final List<int> bytes = workbook.saveAsStream();
          File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(bytes);

          Get.snackbar(
            "Success",
            "File downloaded successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.greenColor,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );

          FlutterSmartDownloadDialog.show(
            context: context,
            filePath: filePath,
            dialogType: DialogType.popup,
          );
          log("File saved at ==> $filePath");
        } else {
          throw Exception("Unable to determine a valid file path for saving.");
        }
      } catch (e, stackTrace) {
        log("Error saving Excel file: $e");
        log("Stack trace: $stackTrace");
        Get.snackbar(
          "Error",
          "Could not save file: $e",
          duration: const Duration(seconds: 7),
          backgroundColor: AppColors.redColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else if (storageStatus == PermissionStatus.denied) {
      log("======> Permission denied");
      Get.snackbar(
        "Permission Denied",
        "Storage permission is required to save the file.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else if (storageStatus == PermissionStatus.permanentlyDenied) {
      Get.snackbar(
        "Permission Denied",
        "Please enable storage permission in app settings",
        snackPosition: SnackPosition.BOTTOM,
        mainButton: TextButton(
          onPressed: openAppSettings,
          child: const Text('Settings'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: shedDataList.isNotEmpty
          ? Padding(
        padding: EdgeInsets.only(left: size.height * k8TextSize, right: size.height * k4TextSize),
        child: Column(
          children: [
            SizedBox(height: size.height * k16TextSize),
            Container(
              height: size.height / 2,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.containerBorderColor),
                borderRadius: BorderRadius.circular(size.height * k16TextSize),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.compact(),
                ),
                trackballBehavior: TrackballBehavior(
                  enable: true,
                  tooltipAlignment: ChartAlignment.near,
                  tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                  activationMode: ActivationMode.singleTap,
                ),
                series: <CartesianSeries>[
                  ColumnSeries<ShedData, String>(
                    name: 'Today Energy (kWh)',
                    legendItemText: 'Today Energy',
                    dataSource: shedDataList,
                    xValueMapper: (ShedData data, _) => data.shedName,
                    yValueMapper: (ShedData data, _) => data.todayEnergy,
                    color: Colors.blue,
                    // dataLabelSettings: DataLabelSettings(
                    //   isVisible: true,
                    //   textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    //   labelAlignment: ChartDataLabelAlignment.top,
                    //   labelPosition: ChartDataLabelPosition.outside,
                    //   builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                    //     return Text('${point.y} kWh');
                    //   },
                    // ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  downloadDataSheet(context);
                },
                child: CustomContainer(
                  height: size.height * 0.05,
                  width: size.width * 0.4,
                  borderRadius: BorderRadius.circular(size.height * k12TextSize),
                  child: Padding(
                    padding: EdgeInsets.all(size.height * k8TextSize),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextComponent(
                            text: "Download",
                            color: AppColors.secondaryTextColor,
                            fontSize: size.height * k18TextSize,
                          ),
                          SvgPicture.asset(
                            AssetsPath.downloadIconSVG,
                            height: size.height * k20TextSize,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * k16TextSize),
            Container(
              height: size.height / 3.13,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  headerColor: AppColors.secondaryTextColor,
                ),
                child: SfDataGrid(
                  verticalScrollPhysics: const NeverScrollableScrollPhysics(),
                  rowHeight: size.height * 0.05,
                  headerRowHeight: size.height * 0.050,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columnWidthMode: ColumnWidthMode.fill,
                  columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                  source: _shedDataSource,
                  columns: <GridColumn>[
                    GridColumn(
                      columnName: 'shedName',
                      label: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Shed Name',
                          style: TextStyle(color: Colors.white, fontSize: size.height * k16TextSize),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'todayEnergy',
                      label: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Today',
                          style: TextStyle(color: Colors.white, fontSize: size.height * k16TextSize),
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'yesterdayEnergy', // Added
                      label: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'Yesterday',
                          style: TextStyle(color: Colors.white, fontSize: size.height * k16TextSize),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      )
          : Padding(

            padding: const EdgeInsets.only(bottom: 120.0),
            child: Center(child:SpinKitFadingCircle(
                    color: AppColors.primaryColor,
                    size: 50.0,
                  ),),
          ),
    );
  }
}

class ShedData {
  final String shedName;
  final double todayEnergy;
  final double yesterdayEnergy;
  final DateTime todayDate;
  final DateTime yesterdayDate;

  ShedData({
    required this.shedName,
    required this.todayEnergy,
    required this.yesterdayEnergy,
    required this.todayDate,
    required this.yesterdayDate,
  });
}

class ShedDataSource extends DataGridSource {
  List<ShedData> shedDataList;
  double totalTodayEnergy; // Renamed for clarity
  double totalYesterdayEnergy; // Added
  List<DataGridRow> _dataGridRows = [];
  final Size size;

  ShedDataSource(this.shedDataList, this.size, this.totalTodayEnergy, this.totalYesterdayEnergy) {
    _dataGridRows = shedDataList.map<DataGridRow>(
          (data) => DataGridRow(cells: [
        DataGridCell<String>(columnName: 'shedName', value: data.shedName),
        DataGridCell<double>(columnName: 'todayEnergy', value: data.todayEnergy),
        DataGridCell<double>(columnName: 'yesterdayEnergy', value: data.yesterdayEnergy), // Added
      ]),
    ).toList();

    // Add a row for totals
    _dataGridRows.add(DataGridRow(cells: [
      DataGridCell<String>(columnName: 'shedName', value: 'Total'),
      DataGridCell<double>(columnName: 'todayEnergy', value: totalTodayEnergy),
      DataGridCell<double>(columnName: 'yesterdayEnergy', value: totalYesterdayEnergy), // Added
    ]));
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataCell) {
          String displayText = '';
          if (dataCell.columnName.contains('Energy')) {
            displayText = '${NumberFormat('##0.00').format(dataCell.value)} kWh';
          } else if (dataCell.columnName.contains('Date')) {
            displayText = DateFormat('yyyy-MM-dd').format(dataCell.value as DateTime);
          } else {
            displayText = dataCell.value.toString();
          }
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              displayText,
              style: TextStyle(
                fontSize: size.width > 500 ? size.height * k16TextSize : size.height * k14TextSize,
                fontWeight: dataCell.columnName == 'shedName' && dataCell.value == 'Total'
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
        );
    }
}