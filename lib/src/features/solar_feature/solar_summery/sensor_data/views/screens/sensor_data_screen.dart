import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/sensor_data/views/widget/selected_plant_data_grid_widget.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Border, Row, Column;
import 'package:permission_handler/permission_handler.dart';

class SensorDataScreen extends StatefulWidget {
  const SensorDataScreen({super.key});

  @override
  State<SensorDataScreen> createState() => _SensorDataScreenState();
}

class _SensorDataScreenState extends State<SensorDataScreen> with WidgetsBindingObserver {
  List<ChartData> chartData = [];
  bool isLoading = true;
  Timer? _timer;
  bool showIrrEast = true;
  bool showIrrWest = true;
  bool showModuleTemp = false;
  bool showAmbientTemp = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchData();
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
    _timer = Timer.periodic(const Duration(seconds: kTimer), (Timer t) => fetchData());
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

  Future<void> fetchData() async {
    String url = Urls.getPlantTodayDataUrl;
    if (!mounted) return;
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Authorization': '${AuthUtilityController.accessToken}',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        log("===> Sensor Data Api call happening");

        if (mounted) {
          setState(() {
            chartData = data.map((item) => ChartData(
              DateTime.parse(item['timedate']),
              item['irr_east'] ?? 0.0,
              item['irr_west'] ?? 0.0,
              item['module_temperature'] ?? 0.0,
              item['ambient_temperature'] ?? 0.0,
            )).toList();
            isLoading = false;
          });
        }
      } else {
        log('Failed to load data');
      }
    } catch (e) {
      log('Error: $e');
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
        sheet.name = 'Sensor Data Report';

        // Set column widths
        sheet.getRangeByIndex(1, 1).columnWidth = 20; // Date
        sheet.getRangeByIndex(1, 2).columnWidth = 15; // Irr East
        sheet.getRangeByIndex(1, 3).columnWidth = 15; // Irr West
        sheet.getRangeByIndex(1, 4).columnWidth = 20; // Module Temp
        sheet.getRangeByIndex(1, 5).columnWidth = 20; // Ambient Temp

        // Define header style
        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        // Define headers
        final List<String> headers = [
          'Date',
          'Irr East (W/m²)',
          'Irr West (W/m²)',
          'Module Temp (°C)',
          'Ambient Temp (°C)',
        ];
        for (int i = 0; i < headers.length; i++) {
          sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
          sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
        }

        // Sort chartData in descending order by time
        final sortedChartData = List<ChartData>.from(chartData)
          ..sort((a, b) => b.time.compareTo(a.time)); // Sort in descending order

        // Populate data in descending order
        for (int i = 0; i < sortedChartData.length; i++) {
          final rowIndex = i + 2;
          final data = sortedChartData[i];
          sheet.getRangeByIndex(rowIndex, 1).setText(
              DateFormat('dd-MMM-yyyy HH:mm').format(data.time));
          sheet.getRangeByIndex(rowIndex, 2).setNumber(data.irrEast);
          sheet.getRangeByIndex(rowIndex, 3).setNumber(data.irrWest);
          sheet.getRangeByIndex(rowIndex, 4).setNumber(data.moduleTemperature);
          sheet.getRangeByIndex(rowIndex, 5).setNumber(data.ambientTemperature);
        }

        sheet.autoFitRow(1);

        // Determine file path
        String? filePath;
        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (directory.existsSync()) {
            String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
            filePath = "${directory.path}/Sensor_Data_Report_$formattedDate $formattedTime.xlsx";
          }
        } else if (Platform.isIOS) {
          final directory = await getApplicationDocumentsDirectory();
          String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
          String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
          filePath = "${directory.path}/Sensor_Data_Report_$formattedDate $formattedTime.xlsx";
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
              margin: const EdgeInsets.all(16)
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
        mainButton: const TextButton(
          onPressed: openAppSettings,
          child: Text('Settings'),
        ),
      );
    }
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    DateTime _today = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: isLoading
          ? Center(child: Lottie.asset(AssetsPath.loadingJson, height: size.height * 0.12))
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * k8TextSize),
          child: Column(
            children: [
              SizedBox(height: size.height * k16TextSize),
             
            Card(
              color: AppColors.whiteTextColor,
              elevation: 3,
              child: Column(
                children: [
                  Wrap(
                    spacing: 8.0,
                    children: [
                      FilterChip(
                        label: const Text('Irr East'),
                        selected: showIrrEast,
                        onSelected: (value) => setState(() => showIrrEast = value),
                        selectedColor: AppColors.irrEastColor.withOpacity(0.3),
                        checkmarkColor: AppColors.irrEastColor,
                      ),
                      FilterChip(
                        label: const Text('Irr West'),
                        selected: showIrrWest,
                        onSelected: (value) => setState(() => showIrrWest = value),
                        selectedColor: AppColors.irrWestColor.withOpacity(0.3),
                        checkmarkColor: AppColors.irrWestColor,
                      ),
                      FilterChip(
                        label: const Text('Module Temp'),
                        selected: showModuleTemp,
                        onSelected: (value) => setState(() => showModuleTemp = value),
                        selectedColor: AppColors.moduleTempColor.withOpacity(0.3),
                        checkmarkColor: AppColors.moduleTempColor,
                      ),
                      FilterChip(
                        label: const Text('Ambient Temp'),
                        selected: showAmbientTemp,
                        onSelected: (value) => setState(() => showAmbientTemp = value),
                        selectedColor: AppColors.moduleTempColor.withOpacity(0.3),
                        checkmarkColor: AppColors.moduleTempColor,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * k8TextSize),
                  SizedBox(
                    height:  MediaQuery.sizeOf(context).width > 500 ? MediaQuery.sizeOf(context).height * 0.48 : MediaQuery.sizeOf(context).height * 0.38,
                    width: MediaQuery.of(context).size.width - 16,

                    child: Padding(
                      padding: EdgeInsets.all(size.height * k8TextSize),
                      child: SfCartesianChart(
                        trackballBehavior: TrackballBehavior(
                          enable: true,
                          tooltipAlignment: ChartAlignment.near,
                          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
                          activationMode: ActivationMode.singleTap,
                        ),
                        primaryXAxis: DateTimeAxis(
                          dateFormat: DateFormat('dd-MMM-yyyy HH:mm:ss'),
                          majorTickLines: MajorTickLines(width: size.height * k5TextSize),
                          minorTicksPerInterval: 0,
                          minimum: DateTime(_today.year, _today.month, _today.day, 5, 0, 0),
                          maximum: DateTime(_today.year, _today.month, _today.day, 19, 0, 0),
                          intervalType: DateTimeIntervalType.hours,
                          interval: 2,
                          labelStyle: TextStyle(fontSize: size.height * k10TextSize),
                          labelFormat: '{value} ',
                          majorGridLines: const MajorGridLines(width: 1),
                          axisLabelFormatter: (axisLabelRenderArgs) {
                            final String text = DateFormat('HH:mm ').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                axisLabelRenderArgs.value.toInt(),
                              ),
                            );
                            TextStyle style = TextStyle(
                                color: Colors.grey.shade500, fontWeight: FontWeight.bold);
                            return ChartAxisLabel(text, style);
                          },
                        ),
                        primaryYAxis: NumericAxis(
                          // title: AxisTitle(text: 'Irradiance (W/m²)'),
                        ),
                        axes: [
                          NumericAxis(
                            name: 'temperatureAxis', // Give it a unique name
                            // title: AxisTitle(text: 'Temperature (°C)'),
                            opposedPosition: true, // Places it on the right side
                          ),
                        ],
                        series: <CartesianSeries>[
                          if (showIrrEast)
                            SplineSeries<ChartData, DateTime>(
                              name: 'Irr East',
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.time.subtract(const Duration(hours: 6)),
                              yValueMapper: (ChartData data, _) => data.irrEast,
                              color: AppColors.irrEastColor,
                            ),
                          if (showIrrWest)
                            SplineSeries<ChartData, DateTime>(
                              name: 'Irr West',
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.time.subtract(const Duration(hours: 6)),
                              yValueMapper: (ChartData data, _) => data.irrWest,
                              color: AppColors.irrWestColor,
                            ),
                          if (showModuleTemp)
                            SplineSeries<ChartData, DateTime>(
                              name: 'Module Temp',
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.time.subtract(const Duration(hours: 6)),
                              yValueMapper: (ChartData data, _) => data.moduleTemperature,
                              yAxisName: 'temperatureAxis',
                              color: AppColors.moduleTempColor,
                            ),
                          if (showAmbientTemp)
                            SplineSeries<ChartData, DateTime>(
                              name: 'Ambient Temp',
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.time.subtract(const Duration(hours: 6)),
                              yValueMapper: (ChartData data, _) => data.ambientTemperature,
                              yAxisName: 'temperatureAxis',
                              color: AppColors.moduleTempColor,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
              




              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    downloadDataSheet(context);
                  },
        child: Container(
          height: size.height * 0.05,
          width: size.width * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(size.height * k12TextSize),
            border: Border.all(color: Colors.black.withOpacity(0.3))
          ),
          child: Padding(
            padding: EdgeInsets.all(size.height * k8TextSize),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Download",
                    style: TextStyle(
                      color: AppColors.secondaryTextColor,
                      fontSize: size.height * k18TextSize,
                    ),
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
                height: MediaQuery.sizeOf(context).height / 3.4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.containerBorderColor),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SfDataGridTheme(
                  data: SfDataGridThemeData(
                    headerColor: AppColors.secondaryTextColor,
                    frozenPaneLineColor: Colors.white70,
                  ),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: SfDataGrid(
                      rowHeight: size.height * 0.05,
                      headerRowHeight: size.height * 0.050,
                      verticalScrollPhysics: const NeverScrollableScrollPhysics(),
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      columnWidthMode: ColumnWidthMode.fill,
                      columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                      source: ChartDataSource(chartData, context, size),
                      columns: [
                        GridColumn(
                          columnName: 'Sensor',
                          label: Container(
                            padding: EdgeInsets.all(size.height * k8TextSize),
                            alignment: Alignment.center,
                            child: Text(
                              "Sensor Name",
                              style: TextStyle(
                                color: AppColors.whiteTextColor,
                                fontSize: size.height * k16TextSize,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Value',
                          label: Container(
                            padding: EdgeInsets.all(size.height * k8TextSize),
                            alignment: Alignment.center,
                            child: Text(
                              "Live Data",
                              style: TextStyle(
                                color: AppColors.whiteTextColor,
                                fontSize: size.height * k16TextSize,
                              ),
                            ),
                          ),
                        ),
                        GridColumn(
                          columnName: 'Action',
                          label: Container(
                            padding: EdgeInsets.all(size.height * k8TextSize),
                            alignment: Alignment.center,
                            child: Text(
                              "Action",
                              style: TextStyle(
                                color: AppColors.whiteTextColor,
                                fontSize: size.height * k16TextSize,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0,top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    if (showIrrEast || showIrrWest)
                      Transform.rotate(
                        angle: 90 * 3.14159 / 180,
                        child: Container(
                          transform: MediaQuery.sizeOf(context).width > 500 ? Matrix4.translationValues(-500, -50, 0) : Matrix4.translationValues(-375, -40, 0),
                          child: const Text(
                            'IRR',
                            style: TextStyle(
                              color: AppColors.irrWestColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (showAmbientTemp || showModuleTemp)
                      Transform.rotate(
                        angle: 90 * 3.14159 / 180,
                        child: Container(
                          transform:  MediaQuery.sizeOf(context).width > 500 ? Matrix4.translationValues(-498, 20, 0) : Matrix4.translationValues(-375, 20, 0),
                          child: const Text(
                            'Temp',
                            style: TextStyle(
                              color: AppColors.moduleTempColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: size.height * k16TextSize),
            ],
          ),
        ),
      ),
    );
  }


  void _actionBottomSheet({required String sensorName}) {
    final List<String> items = List.generate(24, (index) => (index + 1).toString());
    String? selectedValue;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 650,
              decoration: BoxDecoration(
                color: AppColors.whiteTextColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const TextComponent(
                                text: "Sensor Name : ",
                                color: AppColors.whiteTextColor,
                                fontSize: 16,
                                fontFamily: mediumFontFamily,
                              ),
                              TextComponent(
                                text: sensorName,
                                color: AppColors.whiteTextColor,
                                fontSize: 16,
                                fontFamily: semiBoldFontFamily,
                              ),
                            ],
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: const TextComponent(
                                text: 'Select Hour',
                                color: AppColors.whiteTextColor,
                              ),
                              items: items.map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: TextComponent(
                                  text: item,
                                  color: AppColors.whiteTextColor,
                                ),
                              )).toList(),
                              value: selectedValue,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: 140,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade600,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: WidgetStateProperty.all(6),
                                  thumbVisibility: WidgetStateProperty.all(true),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: AppColors.whiteTextColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: SelectedPlantDataGridWidget(columnNamed: sensorName, time: selectedValue),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ChartData {
  final DateTime time;
  final double irrEast;
  final double irrWest;
  final double moduleTemperature;
  final double ambientTemperature;

  ChartData(
      this.time,
      this.irrEast,
      this.irrWest,
      this.moduleTemperature,
      this.ambientTemperature,
      );
}

class ChartDataSource extends DataGridSource {
  final List<ChartData> chartData;
  final BuildContext context;
  final Size size;

  ChartDataSource(this.chartData, this.context,this.size) {
    buildDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  void buildDataGridRows() {
    ChartData latestData = chartData.last;
    dataGridRows = [
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'Sensor', value: 'Irr East'),
        DataGridCell<double>(columnName: 'Value', value: latestData.irrEast),
        const DataGridCell<String>(columnName: 'Action', value: 'Details'),
      ]),
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'Sensor', value: 'Irr West'),
        DataGridCell<double>(columnName: 'Value', value: latestData.irrWest),
        const DataGridCell<String>(columnName: 'Action', value: 'Details'),
      ]),
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'Sensor', value: 'Module Temp'),
        DataGridCell<double>(columnName: 'Value', value: latestData.moduleTemperature),
        const DataGridCell<String>(columnName: 'Action', value: 'Details'),
      ]),
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'Sensor', value: 'Ambient Temp'),
        DataGridCell<double>(columnName: 'Value', value: latestData.ambientTemperature),
        const DataGridCell<String>(columnName: 'Action', value: 'Details'),
      ]),
    ];
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'Action') {
          return Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                _actionBottomSheet(sensorName: row.getCells().first.value);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cell.value.toString(),
                    style:  TextStyle(fontSize: size.height * k16TextSize, color: Colors.black),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(AssetsPath.listIconSVG),
                ],
              ),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(cell.value.toString(),style:  TextStyle(fontSize: size.height * k16TextSize),),
        );
      }).toList(),
    );
  }



  void _actionBottomSheet({required String sensorName}) {
    final List<String> items = List.generate(24, (index) => (index + 1).toString());

    String? selectedValue;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 650,
              decoration: BoxDecoration(
                  color: AppColors.whiteTextColor,
                  borderRadius: BorderRadius.circular(16)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const TextComponent(
                                text: "Sensor Name : ",
                                color: AppColors.whiteTextColor,
                                fontSize: 16,
                                fontFamily: mediumFontFamily,
                              ),
                              TextComponent(
                                text: sensorName,
                                color: AppColors.whiteTextColor,
                                fontSize: 16,
                                fontFamily: semiBoldFontFamily,
                              ),
                            ],
                          ),

                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(

                              isExpanded: true,
                              hint: const TextComponent(
                                text: 'Select Hour',
                                color: AppColors.whiteTextColor,
                              ),
                              items: items.map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: TextComponent(
                                  text: item,
                                  color: AppColors.whiteTextColor,
                                ),
                              )).toList(),
                              value: selectedValue,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedValue = value;
                                });
                              },
                              buttonStyleData:  const ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: 140,
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(5),
                                //   border: Border.all(
                                //     color: Colors.black26,
                                //   ),
                                //   color: Colors.redAccent,
                                // ),
                              ),




                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade600,
                                  //   color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                  //color: Colors.redAccent,
                                ),
                                //offset: const Offset(-20, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: WidgetStateProperty.all(6),
                                  thumbVisibility: WidgetStateProperty.all(true),
                                ),

                              ),

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            color: AppColors.whiteTextColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: SelectedPlantDataGridWidget(columnNamed: sensorName,time: selectedValue,)),
                      ))
                ],
              ),
            );
          },
        );
      },
    );
  }

}
