// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:lottie/lottie.dart';
// import 'package:nz_ums/src/shared_preferences/auth_utility_controller.dart';
// import 'package:nz_ums/src/utility/app_urls/app_urls.dart';
// import 'package:nz_ums/src/utility/assets_path/assets_path.dart';
// import 'package:nz_ums/src/utility/style/app_colors.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'dart:convert';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
//
//
//
// class ShedWiseTodayScreen extends StatefulWidget {
//   @override
//   _ShedWiseTodayScreenState createState() => _ShedWiseTodayScreenState();
// }
//
// class _ShedWiseTodayScreenState extends State<ShedWiseTodayScreen> {
//   List<DataRowModel> allRows = [];
//   bool isLoading = true;
//   NodeLiveData? selectedNodeData;
//   bool isLoadingNodeData = false;
//   String? selectedNodeName;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchShedData();
//   }
//
//   Future<void> fetchShedData() async {
//     final url = Uri.parse(
//         '${Urls.baseUrl}/api/get-shedwise-data-view/');
//     final response = await http.get(url, headers: {
//       'Authorization': "${AuthUtilityController.accessToken}",
//     });
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List<DataRowModel> rows = [];
//
//       data.forEach((shedKey, shedValue) {
//         rows.add(DataRowModel(
//           level: 0,
//           title: shedKey,
//           power: (shedValue['shed_daily_power'] as num).toDouble(),
//           energy: (shedValue['shed_daily_energy'] as num).toDouble(),
//           cost: (shedValue['shed_daily_cost'] as num).toDouble(),
//           expandable: true,
//           children: (shedValue['machine_data'] as List).map<DataRowModel>((
//               machine) {
//             final hasNodes = (machine['node_names'] as List).isNotEmpty;
//             return DataRowModel(
//               level: 1,
//               title: machine['machine_type'],
//               power: (machine['daily_power'] as num).toDouble(),
//               energy: (machine['daily_energy'] as num).toDouble(),
//               cost: (machine['daily_cost'] as num).toDouble(),
//               expandable: hasNodes,
//               children: hasNodes
//                   ? (machine['node_names'] as List)
//                   .map<DataRowModel>((node) =>
//                   DataRowModel(
//                     level: 2,
//                     title: node,
//                     nodeName: node,
//                     power: 0.0,
//                     // Initial placeholder
//                     energy: 0.0,
//                     cost: 0.0,
//                     expandable: false,
//                   ))
//                   .toList()
//                   : [],
//             );
//           }).toList(),
//         ));
//       });
//
//       setState(() {
//         allRows = rows;
//         isLoading = false;
//       });
//
//       // Fetch initial live data for all nodes
//       await _fetchInitialNodeData(rows);
//     } else {
//       log('Failed to load shed data: ${response.statusCode}');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _fetchInitialNodeData(List<DataRowModel> rows) async {
//     // Collect all node names
//     List<String> nodeNames = [];
//     for (var shed in rows) {
//       for (var machine in shed.children) {
//         for (var node in machine.children) {
//           if (node.nodeName != null) {
//             nodeNames.add(node.nodeName!);
//           }
//         }
//       }
//     }
//
//     // Fetch data in batches to avoid overwhelming the server
//     const batchSize = 5;
//     for (int i = 0; i < nodeNames.length; i += batchSize) {
//       final batch = nodeNames.sublist(
//           i,
//           i + batchSize > nodeNames.length ? nodeNames.length : i + batchSize);
//       await Future.wait(batch.map((nodeName) => fetchNodeLiveData(nodeName)));
//     }
//   }
//
//   Future<void> fetchNodeLiveData(String nodeName) async {
//     setState(() {
//       isLoadingNodeData = true;
//       selectedNodeName = nodeName;
//     });
//
//     try {
//       final url = Uri.parse(
//           '${Urls.baseUrl}/get-live-data/$nodeName/');
//       log('Fetching data from URL: $url');
//       final response = await http.get(url, headers: {
//         'Authorization': '${AuthUtilityController.accessToken}',
//       });
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final nodeData = NodeLiveData.fromJson(data);
//
//         // Update the corresponding node in allRows with live data values
//         _updateNodeValues(nodeName, nodeData);
//
//         setState(() {
//           selectedNodeData = nodeData;
//           isLoadingNodeData = false;
//         });
//       } else {
//         log('Failed to load node data: ${response.statusCode}');
//         setState(() {
//           isLoadingNodeData = false;
//         });
//       }
//     } catch (e) {
//       log('Error fetching node data: $e');
//       setState(() {
//         isLoadingNodeData = false;
//       });
//     }
//   }
//
//   void _updateNodeValues(String nodeName, NodeLiveData nodeData) {
//     for (var shed in allRows) {
//       for (var machine in shed.children) {
//         for (var node in machine.children) {
//           if (node.nodeName == nodeName) {
//             node.power = nodeData.power;
//             node.energy = nodeData.todayEnergy;
//             node.cost = nodeData.cost;
//
//             _updateMachineTotals(machine);
//             break;
//           }
//         }
//       }
//     }
//
//     // Notify the data source to refresh
//     if (_dataSource != null) {
//       _dataSource!.buildDataGridRows();
//       _dataSource!.notifyListeners();
//     }
//   }
//
//   void _updateMachineTotals(DataRowModel machine) {
//     if (machine.children.isEmpty) return;
//
//     double totalPower = 0;
//     double totalEnergy = 0;
//     double totalCost = 0;
//
//     for (var node in machine.children) {
//       totalPower += node.power ?? 0;
//       totalEnergy += node.energy ?? 0;
//       totalCost += node.cost ?? 0;
//     }
//
//     // Optionally update machine totals based on node values
//     // Uncomment if you want this behavior
//     /*
//     machine.power = totalPower;
//     machine.energy = totalEnergy;
//     machine.cost = totalCost;
//     */
//   }
//
//   void _onNodeSelected(String? nodeName) {
//     if (nodeName != null) {
//       fetchNodeLiveData(nodeName);
//     }
//   }
//
//   CustomDataSource? _dataSource;
//
//   @override
//   Widget build(BuildContext context) {
//     _dataSource = CustomDataSource(
//       data: allRows,
//       onNodeSelected: _onNodeSelected,
//       selectedNodeName: selectedNodeName,
//     );
//     Size size = MediaQuery.sizeOf(context);
//
//     // Create a default ColumnSizer
//     final columnSizer = ColumnSizer();
//
//     return  isLoading
//           ?  Center(child:  Lottie.asset(AssetsPath.loadingJson, height: MediaQuery.sizeOf(context).height * 0.12))
//           : Column(
//                   children: [
//           Expanded(
//             child: Container(
//               clipBehavior: Clip.antiAlias,
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
//                 color: Colors.white,
//               ),
//               child: SfDataGridTheme(
//
//                 data: SfDataGridThemeData(
//                     headerColor: AppColors.secondaryTextColor),
//                 child: SfDataGrid(
//                   source: _dataSource!,
//                   columnWidthMode: ColumnWidthMode.fill,
//                   // columnWidthMode:
//                   // size.width > 500 ? ColumnWidthMode.fill : ColumnWidthMode.auto,
//                   columnWidthCalculationRange: ColumnWidthCalculationRange
//                       .allRows,
//                   columnSizer: columnSizer,
//                   // Use the default ColumnSizer
//                   onQueryRowHeight: (RowHeightDetails details) {
//                     if (details.rowIndex == 0) {
//                       return 50; // Height for the header row
//                     }
//                     var row = _dataSource!.rows[details.rowIndex - 1];
//                     var longestCellText = row
//                         .getCells()
//                         .map((cell) =>
//                     cell.value
//                         .toString()
//                         .length)
//                         .reduce((value, element) =>
//                     value > element
//                         ? value
//                         : element);
//                     return longestCellText > 20 ? 65 : 53;
//                   },
//                   gridLinesVisibility: GridLinesVisibility.both,
//                   headerGridLinesVisibility: GridLinesVisibility.both,
//                   columns: [
//                     GridColumn(
//                         columnName: 'Name',
//                         label: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             alignment: Alignment.center,
//                             child: const Text('Name',
//                                 style: TextStyle(fontWeight: FontWeight.bold,
//                                     color: Colors.white
//                                 )))),
//                     GridColumn(
//                         columnName: 'power',
//                         label: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             alignment: Alignment.center,
//                             child: const Text('Power',
//                                 style: TextStyle(fontWeight: FontWeight.bold,
//                                     color: Colors.white
//
//                                 )))),
//                     GridColumn(
//                         columnName: 'energy',
//                         label: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             alignment: Alignment.center,
//                             child: const Text('Energy',
//                                 style: TextStyle(fontWeight: FontWeight.bold,                              color: Colors.white
//                                 )))),
//                     GridColumn(
//                         columnName: 'cost',
//                         label: Container(
//                             padding: const EdgeInsets.all(8.0),
//                             alignment: Alignment.center,
//                             child: const Text('Cost',
//                                 style: TextStyle(fontWeight: FontWeight.bold,
//                                     color: Colors.white
//
//                                 )))),
//                   ],
//                   allowSorting: false,
//                 ),
//               ),
//             ),
//           ),
//                   ],
//                 );
//
//   }
// }
// // === Node Live Data Model ===
// class NodeLiveData {
//   final int id;
//   final String timedate;
//   final String node;
//   final double power;
//   final double voltage1;
//   final double voltage2;
//   final double voltage3;
//   final double current1;
//   final double current2;
//   final double current3;
//   final double frequency;
//   final double powerFactor;
//   final double cost;
//   final bool sensorStatus;
//   final double powerMod;
//   final double costMod;
//   final double yesterdayNetEnergy;
//   final double todayEnergy;
//   final double netEnergy;
//   final String color;
//   final double maxMeterValue;
//
//   NodeLiveData({
//     required this.id,
//     required this.timedate,
//     required this.node,
//     required this.power,
//     required this.voltage1,
//     required this.voltage2,
//     required this.voltage3,
//     required this.current1,
//     required this.current2,
//     required this.current3,
//     required this.frequency,
//     required this.powerFactor,
//     required this.cost,
//     required this.sensorStatus,
//     required this.powerMod,
//     required this.costMod,
//     required this.yesterdayNetEnergy,
//     required this.todayEnergy,
//     required this.netEnergy,
//     required this.color,
//     required this.maxMeterValue,
//   });
//
//   factory NodeLiveData.fromJson(Map<String, dynamic> json) {
//     return NodeLiveData(
//       id: json['id'],
//       timedate: json['timedate'],
//       node: json['node'],
//       power: (json['power'] as num).toDouble(),
//       voltage1: (json['voltage1'] as num).toDouble(),
//       voltage2: (json['voltage2'] as num).toDouble(),
//       voltage3: (json['voltage3'] as num).toDouble(),
//       current1: (json['current1'] as num).toDouble(),
//       current2: (json['current2'] as num).toDouble(),
//       current3: (json['current3'] as num).toDouble(),
//       frequency: (json['frequency'] as num).toDouble(),
//       powerFactor: (json['power_factor'] as num).toDouble(),
//       cost: (json['cost'] as num).toDouble(),
//       sensorStatus: json['sensor_status'],
//       powerMod: (json['power_mod'] as num).toDouble(),
//       costMod: (json['cost_mod'] as num).toDouble(),
//       yesterdayNetEnergy: (json['yesterday_net_energy'] as num).toDouble(),
//       todayEnergy: (json['today_energy'] as num).toDouble(),
//       netEnergy: (json['net_energy'] as num).toDouble(),
//       color: json['color'],
//       maxMeterValue: (json['max_meter_value'] as num).toDouble(),
//     );
//   }
// }
//
//
//
// Widget _buildDataRow(String label, String value, Color color) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 4),
//     child: Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
//         ),
//         Expanded(
//           flex: 3,
//           child: Text(
//             value,
//             style: TextStyle(color: color, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// // === Data Model ===
// class DataRowModel {
//   final int level;
//   final String title;
//   final String? nodeName;
//   double? power;
//   double? energy;
//   double? cost;
//   final bool expandable;
//   final List<DataRowModel> children;
//   bool isExpanded;
//
//   DataRowModel({
//     required this.level,
//     required this.title,
//     this.nodeName,
//     this.power,
//     this.energy,
//     this.cost,
//     this.expandable = false,
//     this.children = const [],
//     this.isExpanded = false,
//   });
// }
//
// // === Data Source ===
// class CustomDataSource extends DataGridSource {
//   List<DataGridRow> _rows = [];
//   final List<DataRowModel> data;
//   final Function(String?) onNodeSelected;
//   final String? selectedNodeName;
//
//   CustomDataSource({
//     required this.data,
//     required this.onNodeSelected,
//     this.selectedNodeName,
//   }) {
//     buildDataGridRows();
//   }
//
//   void buildDataGridRows() {
//     _rows.clear();
//     for (var row in data) {
//       _addRowWithChildren(row);
//     }
//   }
//
//   void _addRowWithChildren(DataRowModel row) {
//     _rows.add(DataGridRow(cells: [
//       DataGridCell<String>(columnName: 'title', value: row.title),
//       DataGridCell<double>(columnName: 'power', value: row.power),
//       DataGridCell<double>(columnName: 'energy', value: row.energy),
//       DataGridCell<double>(columnName: 'cost', value: row.cost),
//     ]));
//
//     if (row.isExpanded) {
//       for (var child in row.children) {
//         _addRowWithChildren(child);
//       }
//     }
//   }
//
//   @override
//   List<DataGridRow> get rows => _rows;
//
//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     final title = row.getCells()[0].value as String;
//     final model = _findRowByTitle(title);
//     final isSelectedNode = model?.nodeName == selectedNodeName;
//
//     return DataGridRowAdapter(cells: [
//       GestureDetector(
//         onTap: () {
//           if (model != null) {
//             if (model.expandable) {
//               model.isExpanded = !model.isExpanded;
//               buildDataGridRows();
//               notifyListeners();
//             } else if (model.level == 2 && model.nodeName != null) {
//               onNodeSelected(model.nodeName);
//             }
//
//             if (model.level == 2) {
//               model.power ??= 0.0;
//               model.energy ??= 0.0;
//               model.cost ??= 0.0;
//             }
//           }
//         },
//         child: Container(
//           color: isSelectedNode ? Colors.blue.withOpacity(0.1) : null,
//           padding: EdgeInsets.only(left: 12.0 * (model?.level ?? 0), top: 8, bottom: 8),
//           child: Row(
//             children: [
//               if (model != null && model.expandable)
//                 Icon(
//                   model.isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
//                   size: 20,
//                 ),
//               if (model != null && model.level == 2)
//                 Icon(
//                   Icons.minimize_rounded,
//                   size: 16,
//                   color: isSelectedNode ? Colors.blue : Colors.grey,
//                 ),
//               const SizedBox(width: 4),
//               Flexible(
//                 child: Text(
//                   model?.title ?? '',
//                   style: TextStyle(
//                     fontWeight: isSelectedNode ? FontWeight.bold : FontWeight.normal,
//                     color: isSelectedNode ? Colors.blue : null,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       _buildTextCell(row.getCells()[1].value, isSelectedNode),
//       _buildTextCell(row.getCells()[2].value, isSelectedNode),
//       _buildTextCell(row.getCells()[3].value, isSelectedNode),
//     ]);
//   }
//
//   Widget _buildTextCell(dynamic value, bool isSelected) {
//     return Container(
//       color: isSelected ? Colors.blue.withOpacity(0.1) : null,
//       alignment: Alignment.center,
//       padding: const EdgeInsets.all(8.0),
//       child: Text(
//         value != null ? value.toStringAsFixed(2) : '',
//         style: TextStyle(
//           color: isSelected
//               ? Colors.blue
//               : (value != null && value > 0 ? Colors.black87 : Colors.grey),
//           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//         ),
//       ),
//     );
//   }
//
//   DataRowModel? _findRowByTitle(String title) {
//     DataRowModel? find(List<DataRowModel> rows) {
//       for (var row in rows) {
//         if (row.title == title) return row;
//         final found = find(row.children);
//         if (found != null) return found;
//       }
//       return null;
//     }
//
//     return find(data);
//     }
// }



import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ShedWiseTodayScreen extends StatefulWidget {
  @override
  _ShedWiseTodayScreenState createState() => _ShedWiseTodayScreenState();
}

class _ShedWiseTodayScreenState extends State<ShedWiseTodayScreen> {
  List<DataRowModel> allRows = [];
  bool isLoading = true;
  NodeLiveData? selectedNodeData;
  bool isLoadingNodeData = false;
  String? selectedNodeName;

  @override
  void initState() {
    super.initState();
    fetchShedData();
  }

  Future<void> fetchShedData() async {
    final url = Uri.parse('${Urls.baseUrl}/api/get-shedwise-data-view/');
    final response = await http.get(url, headers: {
      'Authorization': "${AuthUtilityController.accessToken}",
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<DataRowModel> rows = [];

      data.forEach((shedKey, shedValue) {
        // Create shed level row
        final shedRow = DataRowModel(
          level: 0,
          title: shedKey,
          power: (shedValue['shed_daily_power'] as num).toDouble(),
          energy: (shedValue['shed_daily_energy'] as num).toDouble(),
          cost: (shedValue['shed_daily_cost'] as num).toDouble(),
          expandable: true,
          children: [],
        );

        // Process machine data for this shed
        final machinesList = shedValue['machine_data'] as List;
        for (var machine in machinesList) {
          final hasNodes = (machine['node_names'] as List).isNotEmpty;
          // Only add machines with nodes or with power > 0
          if (hasNodes || (machine['daily_power'] as num) > 0) {
            final machineRow = DataRowModel(
              level: 1,
              title: machine['machine_type'],
              power: (machine['daily_power'] as num).toDouble(),
              energy: (machine['daily_energy'] as num).toDouble(),
              cost: (machine['daily_cost'] as num).toDouble(),
              expandable: hasNodes,
              children: [],
            );

            // Add nodes to this machine if they exist
            if (hasNodes) {
              for (var nodeName in machine['node_names']) {
                machineRow.children.add(DataRowModel(
                  level: 2,
                  title: nodeName,
                  nodeName: nodeName,
                  power: 0.0, // Initial placeholder
                  energy: 0.0,
                  cost: 0.0,
                  expandable: false,
                ));
              }
            }

            shedRow.children.add(machineRow);
          }
        }

        // Only add the shed if it has valid machine data
        if (shedRow.children.isNotEmpty) {
          rows.add(shedRow);
        }
      });

      setState(() {
        allRows = rows;
        isLoading = false;
      });

      // Fetch initial live data for all nodes
      await _fetchInitialNodeData(rows);
    } else {
      log('Failed to load shed data: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchInitialNodeData(List<DataRowModel> rows) async {
    // Collect all node names
    List<String> nodeNames = [];
    for (var shed in rows) {
      for (var machine in shed.children) {
        for (var node in machine.children) {
          if (node.nodeName != null) {
            nodeNames.add(node.nodeName!);
          }
        }
      }
    }

    // Fetch data in batches to avoid overwhelming the server
    const batchSize = 5;
    for (int i = 0; i < nodeNames.length; i += batchSize) {
      final batch = nodeNames.sublist(
          i, i + batchSize > nodeNames.length ? nodeNames.length : i + batchSize);
      await Future.wait(batch.map((nodeName) => fetchNodeLiveData(nodeName)));
    }
  }

  Future<void> fetchNodeLiveData(String nodeName) async {
    setState(() {
      isLoadingNodeData = true;
      selectedNodeName = nodeName;
    });

    try {
      final url = Uri.parse('${Urls.baseUrl}/get-live-data/$nodeName/');
      log('Fetching data from URL: $url');
      final response = await http.get(url, headers: {
        'Authorization': '${AuthUtilityController.accessToken}',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final nodeData = NodeLiveData.fromJson(data);

        // Update the corresponding node in allRows with live data values
        _updateNodeValues(nodeName, nodeData);

        setState(() {
          selectedNodeData = nodeData;
          isLoadingNodeData = false;
        });
      } else {
        log('Failed to load node data: ${response.statusCode}');
        setState(() {
          isLoadingNodeData = false;
        });
      }
    } catch (e) {
      log('Error fetching node data: $e');
      setState(() {
        isLoadingNodeData = false;
      });
    }
  }

  void _updateNodeValues(String nodeName, NodeLiveData nodeData) {
    for (var shed in allRows) {
      for (var machine in shed.children) {
        for (var node in machine.children) {
          if (node.nodeName == nodeName) {
            node.power = nodeData.power;
            node.energy = nodeData.todayEnergy;
            node.cost = nodeData.cost;

            _updateMachineTotals(machine);
            break;
          }
        }
      }
    }

    // Notify the data source to refresh
    if (_dataSource != null) {
      _dataSource!.buildDataGridRows();
      _dataSource!.notifyListeners();
    }
  }

  void _updateMachineTotals(DataRowModel machine) {
    if (machine.children.isEmpty) return;

    double totalPower = 0;
    double totalEnergy = 0;
    double totalCost = 0;

    for (var node in machine.children) {
      totalPower += node.power ?? 0;
      totalEnergy += node.energy ?? 0;
      totalCost += node.cost ?? 0;
    }

    // Optionally update machine totals based on node values
    // Uncomment if you want this behavior
    /*
    machine.power = totalPower;
    machine.energy = totalEnergy;
    machine.cost = totalCost;
    */
  }

  void _onNodeSelected(String? nodeName) {
    if (nodeName != null) {
      fetchNodeLiveData(nodeName);
    }
  }

  CustomDataSource? _dataSource;

  @override
  Widget build(BuildContext context) {
    _dataSource = CustomDataSource(
      data: allRows,
      onNodeSelected: _onNodeSelected,
      selectedNodeName: selectedNodeName,
    );
    Size size = MediaQuery.sizeOf(context);

    // Create a default ColumnSizer
    final columnSizer = ColumnSizer();

    return isLoading
        ? Center(
        child: Lottie.asset(AssetsPath.loadingJson,
            height: MediaQuery.sizeOf(context).height * 0.12))
        : Column(
      children: [
        Expanded(
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16), topLeft: Radius.circular(16)),
              color: Colors.white,
            ),
            child: SfDataGridTheme(
              data: SfDataGridThemeData(headerColor: AppColors.secondaryTextColor),
              child: SfDataGrid(
                source: _dataSource!,
                columnWidthMode: ColumnWidthMode.fill,
                columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
                columnSizer: columnSizer,
                onQueryRowHeight: (RowHeightDetails details) {
                  if (details.rowIndex == 0) {
                    return 50; // Height for the header row
                  }
                  var row = _dataSource!.rows[details.rowIndex - 1];
                  var longestCellText = row
                      .getCells()
                      .map((cell) => cell.value.toString().length)
                      .reduce((value, element) =>
                  value > element ? value : element);
                  return longestCellText > 20 ? 65 : 53;
                },
                gridLinesVisibility: GridLinesVisibility.both,
                headerGridLinesVisibility: GridLinesVisibility.both,
                columns: [
                  GridColumn(
                      columnName: 'Name',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))),
                  GridColumn(
                      columnName: 'power',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Power',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))),
                  GridColumn(
                      columnName: 'energy',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Energy',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))),
                  GridColumn(
                      columnName: 'cost',
                      label: Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.center,
                          child: const Text('Cost',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))),
                ],
                allowSorting: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// === Node Live Data Model ===
class NodeLiveData {
  final int id;
  final String timedate;
  final String node;
  final double power;
  final double voltage1;
  final double voltage2;
  final double voltage3;
  final double current1;
  final double current2;
  final double current3;
  final double frequency;
  final double powerFactor;
  final double cost;
  final bool sensorStatus;
  final double powerMod;
  final double costMod;
  final double yesterdayNetEnergy;
  final double todayEnergy;
  final double netEnergy;
  final String color;
  final double maxMeterValue;

  NodeLiveData({
    required this.id,
    required this.timedate,
    required this.node,
    required this.power,
    required this.voltage1,
    required this.voltage2,
    required this.voltage3,
    required this.current1,
    required this.current2,
    required this.current3,
    required this.frequency,
    required this.powerFactor,
    required this.cost,
    required this.sensorStatus,
    required this.powerMod,
    required this.costMod,
    required this.yesterdayNetEnergy,
    required this.todayEnergy,
    required this.netEnergy,
    required this.color,
    required this.maxMeterValue,
  });

  factory NodeLiveData.fromJson(Map<String, dynamic> json) {
    return NodeLiveData(
      id: json['id'],
      timedate: json['timedate'],
      node: json['node'],
      power: (json['power'] as num).toDouble(),
      voltage1: (json['voltage1'] as num).toDouble(),
      voltage2: (json['voltage2'] as num).toDouble(),
      voltage3: (json['voltage3'] as num).toDouble(),
      current1: (json['current1'] as num).toDouble(),
      current2: (json['current2'] as num).toDouble(),
      current3: (json['current3'] as num).toDouble(),
      frequency: (json['frequency'] as num).toDouble(),
      powerFactor: (json['power_factor'] as num).toDouble(),
      cost: (json['cost'] as num).toDouble(),
      sensorStatus: json['sensor_status'],
      powerMod: (json['power_mod'] as num).toDouble(),
      costMod: (json['cost_mod'] as num).toDouble(),
      yesterdayNetEnergy: (json['yesterday_net_energy'] as num).toDouble(),
      todayEnergy: (json['today_energy'] as num).toDouble(),
      netEnergy: (json['net_energy'] as num).toDouble(),
      color: json['color'],
      maxMeterValue: (json['max_meter_value'] as num).toDouble(),
    );
  }
}

Widget _buildDataRow(String label, String value, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

// === Data Model ===
class DataRowModel {
  final int level;
  final String title;
  final String? nodeName;
  double? power;
  double? energy;
  double? cost;
  final bool expandable;
  final List<DataRowModel> children;
  bool isExpanded;

  DataRowModel({
    required this.level,
    required this.title,
    this.nodeName,
    this.power,
    this.energy,
    this.cost,
    this.expandable = false,
    this.children = const [],
    this.isExpanded = false,
  });

  @override
  String toString() {
    return 'DataRowModel(level: $level, title: $title, expandable: $expandable, children: ${children.length})';
  }
}

// === Data Source ===
class CustomDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];
  final List<DataRowModel> data;
  final Function(String?) onNodeSelected;
  final String? selectedNodeName;

  CustomDataSource({
    required this.data,
    required this.onNodeSelected,
    this.selectedNodeName,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    _rows.clear();
    for (var row in data) {
      _addRowWithChildren(row);
    }
    log('Built ${_rows.length} rows');
  }

  void _addRowWithChildren(DataRowModel row) {
    _rows.add(DataGridRow(cells: [
      DataGridCell<DataRowModel>(columnName: 'title', value: row),
      DataGridCell<double>(columnName: 'power', value: row.power),
      DataGridCell<double>(columnName: 'energy', value: row.energy),
      DataGridCell<double>(columnName: 'cost', value: row.cost),
    ]));

    if (row.isExpanded) {
      for (var child in row.children) {
        _addRowWithChildren(child);
      }
    }
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final rowModel = row.getCells()[0].value as DataRowModel;
    final isSelectedNode = rowModel.nodeName == selectedNodeName;

    return DataGridRowAdapter(cells: [
      GestureDetector(
        onTap: () {
          if (rowModel.expandable) {
            rowModel.isExpanded = !rowModel.isExpanded;
            buildDataGridRows();
            notifyListeners();
          } else if (rowModel.level == 2 && rowModel.nodeName != null) {
            onNodeSelected(rowModel.nodeName);
          }
        },
        child: Container(
          //  color: isSelectedNode ? Colors.blue.withOpacity(0.1) : null,
          padding: EdgeInsets.only(left: 12.0 * rowModel.level, top: 8, bottom: 8),
          child: Row(
            children: [
              if (rowModel.expandable)
                Icon(
                  rowModel.isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                  size: 20,
                ),
              if (rowModel.level == 2)
                Icon(
                  Icons.circle,
                  size: 6,
                ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  rowModel.title,
                  style: TextStyle(
                    fontWeight: rowModel.level == 0 || isSelectedNode
                        ? FontWeight.normal
                        : FontWeight.normal,

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      _buildTextCell(row.getCells()[1].value, isSelectedNode, 'power'),
      _buildTextCell(row.getCells()[2].value, isSelectedNode, 'energy'),
      _buildTextCell(row.getCells()[3].value, isSelectedNode, 'cost'),
    ]);
  }

  Widget _buildTextCell(dynamic value, bool isSelected, String columnName) {
    String unit;
    switch (columnName) {
      case 'power':
        unit = 'kW'; // Unit for power
        break;
      case 'energy':
        unit = 'kWh'; // Unit for energy
        break;
      case 'cost':
        unit = '৳'; // Unit for cost (change to '$' or other currency if needed)
        break;
      default:
        unit = '';
    }

    return Container(
      // color: isSelected ? Colors.blue.withOpacity(0.1) : null,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value != null ? '${value.toStringAsFixed(2)} $unit' : '',
        style: TextStyle(
          color: (value != null && value > 0 ? Colors.black87 : Colors.black87),
          fontWeight: isSelected ? FontWeight.normal : FontWeight.normal,
        ),
      ),
    );
  }
}