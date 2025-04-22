import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/machine_screen/screen/acknowledge_history_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/each_machine_wise_load_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/model/each_category_live_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/power_and_energy_element_details_screen.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_core/theme.dart';

import 'package:get/get.dart';

class MachineController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<MachineModel> machines = <MachineModel>[].obs;
  late MachineDataSource machineDataSource;

  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();

  @override
  void onInit() {
    super.onInit();
    ever(AuthUtilityController.accessTokenForApiCall, (String? token) {
      if (token != null) {
        fetchMachineData();

      }
    });



  }

  Future<void> fetchMachineData() async {
    final response = await http.get(
      Uri.parse('${Urls.baseUrl}/api/get-machine-view-names-data/'),
      headers: {
        'Authorization': '${AuthUtilityController.accessToken}',
      },
    );

    //  log("====>${response.statusCode}");
    //log("====>${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      machines.value = data.map((e) => MachineModel.fromJson(e)).toList();

      // Prefetch node data
      for (var machine in machines) {
        for (var node in machine.nodes) {
          await node.fetchLiveData();
        }
      }

      machineDataSource = MachineDataSource(machines, Get.context!);
    } else {
      throw Exception('Failed to load daily machine data');
    }

    isLoading.value = false;
    update();
  }

  void toggleExpansion(MachineModel machine) {
    machine.isExpanded = !machine.isExpanded;
    machineDataSource.buildDataGridRows();
    update(); // Notify GetBuilder to rebuild
  }

  Future<void> fetchNodeData(MachineModel machine) async {
    // Fetch only if node data isn't already fetched
    for (var node in machine.nodes) {
      if (node.power == 0.0 && node.energy == 0.0 && node.cost == 0.0) {
        await node.fetchLiveData();
      }
    }
    machineDataSource.buildDataGridRows();
    update();
  }
}
class MachineModel {
  String machineType;
  dynamic dailyPower;
  dynamic dailyCost;
  dynamic dailyEnergy;
  List<NodeModel> nodes;
  bool isExpanded = false;

  MachineModel({
    required this.machineType,
    required this.dailyPower,
    required this.dailyCost,
    required this.dailyEnergy,
    required this.nodes,
  });

  factory MachineModel.fromJson(Map<String, dynamic> json) {
    var nodesList = json['node_names'] as List;
    List<NodeModel> nodes = nodesList.map((n) => NodeModel(name: n)).toList();
    return MachineModel(
      machineType: json['machine_type'],
      dailyPower: json['daily_power'],
      dailyCost: json['daily_cost'],
      dailyEnergy: json['daily_energy'],
      nodes: nodes,
    );
  }
}

class NodeModel {
  String name;
  double power = 0.0;
  double energy = 0.0;
  double cost = 0.0;

  NodeModel({required this.name});

  Future<void> fetchLiveData() async {
    final response = await http.get(
      Uri.parse('${Urls.baseUrl}/get-live-data/$name/'),
      headers: {
        'Authorization': '${AuthUtilityController.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      power = data['power'];
      energy = data['today_energy'];
      cost = data['cost'];
    } else {
      throw Exception('Failed to fetch live data for $name');
    }
  }
}

class MachineDataSource extends DataGridSource {
  List<MachineModel> machines;
  List<DataGridRow> dataGridRows = [];
  BuildContext context;

  MachineDataSource(this.machines, this.context) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    dataGridRows.clear();
    for (var machine in machines) {
      dataGridRows.add(DataGridRow(cells: [
        DataGridCell(columnName: 'node', value: machine.machineType),
        const DataGridCell(columnName: 'ack', value: 'N/A'),
        DataGridCell(columnName: 'power', value: machine.dailyPower.toStringAsFixed(2)),
        DataGridCell(columnName: 'energy', value: machine.dailyEnergy.toStringAsFixed(2)),
        DataGridCell(columnName: 'cost', value: machine.dailyCost.toStringAsFixed(2)),
      ]));

      if (machine.isExpanded) {
        for (var node in machine.nodes) {
          dataGridRows.add(DataGridRow(cells: [
            DataGridCell(columnName: 'node', value: node.name),
            const DataGridCell(columnName: 'ack', value: 'Ack'),
            DataGridCell(columnName: 'power', value: node.power.toStringAsFixed(2)),
            DataGridCell(columnName: 'energy', value: node.energy.toStringAsFixed(2)),
            DataGridCell(columnName: 'cost', value: node.cost.toStringAsFixed(2)),
          ]));
        }
      }
    }
    notifyListeners();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    var nodeName = row.getCells().first.value as String;
    var isNodeRow = machines.any((machine) =>
        machine.nodes.any((node) => node.name == nodeName));

    // Find the corresponding machine for the row
    //MachineModel? machine = machines.firstWhereOrNull((m) => m.machineType == nodeName);

    MachineModel machine = machines.firstWhere(
          (m) => m.machineType == nodeName,
      orElse: () => MachineModel(
        machineType: 'default',
        dailyPower: 0,
        dailyCost: 0,
        dailyEnergy: 0,
        nodes: [],
      ),
    );



    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        var isFirstColumn = dataGridCell.columnName == 'node';

        // Wrap the entire row with a GestureDetector for row-wide click
        return GestureDetector(
          onTap: () async {
            if (machine != null && !isNodeRow) {
              if (machine.nodes.isNotEmpty) {
                await fetchNodeData(machine);
                toggleExpansion(machine);
                Get.find<EachMachineWiseLoadLiveDataController>().fetchEachCategoryLiveData(categoryName: dataGridCell.value.toString());
              }
            }
          },
          child: isFirstColumn && !isNodeRow
              ? Row(
            children: [
              if (machine != null && machine.nodes.isNotEmpty)
                Icon(machine.isExpanded ? Icons.expand_less : Icons.expand_more),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  dataGridCell.value.toString(), // with nodes
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,

                ),
              ),
            ],
          )
              : dataGridCell.columnName == 'ack'
              ? isNodeRow
              ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AcKnowledgeHistoryScreen(nodeName: nodeName),
                ),
              );
            },
            child: const Icon(
              Icons.edit_note_sharp,
              color: Colors.green,
            ),
          )
              : const Icon(
            Icons.notes,
            color: Colors.blue,
          )
              : dataGridCell.columnName == 'power'
              ? Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            alignment: Alignment.center,
            child: Text(
              "${dataGridCell.value} kW",
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          )
              : dataGridCell.columnName == 'energy'
              ? Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            alignment: Alignment.center,
            child: Text(
              "${dataGridCell.value} kWh",
              //overflow: TextOverflow.ellipsis,
              //  softWrap: false,
              overflow: TextOverflow.visible,
              softWrap: false,
            ),
          )
              : dataGridCell.columnName == 'cost'
              ? Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            alignment: Alignment.center,
            child: Text(
              isNodeRow
                  ? "${dataGridCell.value}"
                  : "${dataGridCell.value} ৳",

              softWrap: false,
              // Only adds "৳" for machines
              overflow: TextOverflow.ellipsis,
            ),
          )
              : GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => GetBuilder<EachMachineWiseLoadLiveDataController>(
                    builder: (controller) {


                      var nodeData = controller.eachMachineWiseLoadDataList.firstWhere(
                            (data) => data.node == nodeName,
                        orElse: () =>  EachCategoryLiveDataModel(),
                      );


                      log("---power--->${nodeData.power}");
                      return PowerAndEnergyElementDetailsScreen(
                        elementName: nodeName,
                        gaugeValue: nodeData.power ?? 0.0,
                        gaugeUnit: 'kW',
                        elementCategory: 'Power',
                        solarCategory: nodeName,
                      );
                    },
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 0),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              alignment: Alignment.centerLeft,
              child: Text(
                "${dataGridCell.value}",
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  Future<void> fetchNodeData(MachineModel machine) async {
    // Fetch only if node data isn't already fetched
    for (var node in machine.nodes) {
      if (node.power == 0.0 && node.energy == 0.0 && node.cost == 0.0) {
        await node.fetchLiveData();
      }
    }
    // Cache the data to prevent redundant calls
    buildDataGridRows();
    notifyListeners();
  }
  Future<void> fetchNodeDataAsync(MachineModel machine) async {
    await compute(fetchNodeData, machine);
  }
  void toggleExpansion(MachineModel machine) {
    machine.isExpanded = !machine.isExpanded;
    buildDataGridRows();
    notifyListeners();

    if (machine.isExpanded) {
      // Adding a slight delay to allow UI updates before fetching data
      Future.delayed(const Duration(milliseconds: 100), () async {
        await fetchNodeData(machine);
      });
    }
  }
}

class DailyMachineScreen extends StatelessWidget {
  final MachineController _machineController = Get.put(MachineController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Column(
      children: [
        GetBuilder<MachineController>(
          builder: (controller) {
            return controller.isLoading.value
                ? Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Center(child: Lottie.asset(AssetsPath.loadingJson, height: 120)),
            )
                : SizedBox(
              height: size.height * 0.65,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
                  color: Colors.white,
                ),
                child: SfDataGridTheme(
                  data: SfDataGridThemeData(headerColor: AppColors.secondaryTextColor),
                  child: SfDataGrid(
                    columnWidthMode: size.width > 500 ? ColumnWidthMode.fill : ColumnWidthMode.auto,
                    columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                    columnSizer: _machineController._customColumnSizer,
                    onQueryRowHeight: (RowHeightDetails details) {
                      if (details.rowIndex == 0) {
                        return 50; // Height for the header row
                      }
                      var row = _machineController.machineDataSource.rows[details.rowIndex - 1];
                      var longestCellText = row
                          .getCells()
                          .map((cell) => cell.value.toString().length)
                          .reduce((value, element) => value > element ? value : element);
                      return longestCellText > 20 ? 65 : 53;
                    },
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    source: _machineController.machineDataSource,
                    columns: [
                      GridColumn(
                        columnName: 'node',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Node', style: TextStyle(color: AppColors.whiteTextColor,fontSize: 18)),
                        ),
                      ),
                      GridColumn(
                        width: 55,
                        columnName: 'ack',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Ack', style: TextStyle(color: AppColors.whiteTextColor,fontSize: 18)),
                        ),
                      ),
                      GridColumn(
                        columnName: 'power',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Power', style: TextStyle(color: AppColors.whiteTextColor,fontSize: 18)),
                        ),
                      ),
                      GridColumn(
                        columnName: 'energy',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Energy', style: TextStyle(color: AppColors.whiteTextColor,fontSize: 18)),
                        ),
                      ),
                      GridColumn(
                        columnName: 'cost',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Cost', style: TextStyle(color: AppColors.whiteTextColor,fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
class CustomColumnSizer extends ColumnSizer {
  @override
  double computeHeaderCellWidth(GridColumn column, TextStyle style) {
    style = const TextStyle(fontWeight: FontWeight.bold);

    return super.computeHeaderCellWidth(column, style);
  }

  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue,
      TextStyle textStyle) {
    textStyle = const TextStyle(fontWeight: FontWeight.bold);

    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}