// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:lottie/lottie.dart';
// import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
// import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
// import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
// import 'package:nz_fabrics/src/utility/style/app_colors.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'dart:convert';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:intl/intl.dart';
//
// class ShedWiseCustomScreen extends StatefulWidget {
//   @override
//   _ShedWiseCustomScreenState createState() => _ShedWiseCustomScreenState();
// }
//
// class _ShedWiseCustomScreenState extends State<ShedWiseCustomScreen> {
//   List<DataRowModel> allRows = [];
//   bool isLoading = true;
//   NodeLiveData? selectedNodeData;
//   bool isLoadingNodeData = false;
//   String? selectedNodeName;
//   DateTime? startDate;
//   DateTime? endDate;
//
//   @override
//   void initState() {
//     super.initState();
//     startDate = DateTime.now();
//     endDate = DateTime.now();
//     fetchShedData();
//   }
//
//   Future<void> fetchShedData() async {
//     if (startDate == null || endDate == null) return;
//
//     setState(() {
//       isLoading = true;
//     });
//
//     final url = Uri.parse('${Urls.baseUrl}/api/filter-shedwise-date-view/');
//     final response = await http.post(
//       url,
//       headers: {
//         'Authorization': '${AuthUtilityController.accessToken}',
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({
//         'start': DateFormat('yyyy-MM-dd').format(startDate!),
//         'end': DateFormat('yyyy-MM-dd').format(endDate!),
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List<DataRowModel> rows = [];
//
//       data.forEach((shedKey, shedValue) {
//         final shedRow = DataRowModel(
//           level: 0,
//           title: shedKey, // Shed 1, Shed 2, Weaving Shed, Compressor Shed
//           energy: (shedValue['shed_total_energy'] as num).toDouble(),
//           cost: (shedValue['shed_total_cost'] as num).toDouble(),
//           expandable: true,
//           children: [],
//         );
//
//         final machinesList = shedValue['machine_data'] as List;
//         for (var machine in machinesList) {
//           final hasNodes = (machine['children'] as List).isNotEmpty;
//           // Only add machines with nodes or non-zero energy
//           if (hasNodes || (machine['total_energy'] as num) > 0) {
//             final machineRow = DataRowModel(
//               level: 1,
//               title: machine['machine_type'],
//               energy: (machine['total_energy'] as num).toDouble(),
//               cost: (machine['total_cost'] as num).toDouble(),
//               expandable: hasNodes,
//               children: [],
//             );
//
//             if (hasNodes) {
//               for (var node in machine['children']) {
//                 if ((node['total_energy'] as num) > 0) { // Only add nodes with energy > 0
//                   machineRow.children.add(DataRowModel(
//                     level: 2,
//                     title: node['node'],
//                     nodeName: node['node'],
//                     energy: (node['total_energy'] as num).toDouble(),
//                     cost: (node['total_cost'] as num).toDouble(),
//                     expandable: false,
//                   ));
//                 }
//               }
//             }
//
//             shedRow.children.add(machineRow);
//           }
//         }
//
//         if (shedRow.children.isNotEmpty) {
//           rows.add(shedRow);
//         }
//       });
//
//       setState(() {
//         allRows = rows;
//         isLoading = false;
//       });
//
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
//     const batchSize = 5;
//     for (int i = 0; i < nodeNames.length; i += batchSize) {
//       final batch = nodeNames.sublist(
//           i, i + batchSize > nodeNames.length ? nodeNames.length : i + batchSize);
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
//       final url = Uri.parse('${Urls.baseUrl}/get-live-data/$nodeName/');
//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': '${AuthUtilityController.accessToken}',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final nodeData = NodeLiveData.fromJson(data);
//
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
//             node.energy = nodeData.todayEnergy;
//             node.cost = nodeData.cost;
//             _updateMachineTotals(machine);
//             break;
//           }
//         }
//       }
//     }
//
//     if (_dataSource != null) {
//       _dataSource!.buildDataGridRows();
//       _dataSource!.notifyListeners();
//     }
//   }
//
//   void _updateMachineTotals(DataRowModel machine) {
//     if (machine.children.isEmpty) return;
//
//     double totalEnergy = 0;
//     double totalCost = 0;
//
//     for (var node in machine.children) {
//       totalEnergy += node.energy ?? 0;
//       totalCost += node.cost ?? 0;
//     }
//   }
//
//   void _onNodeSelected(String? nodeName) {
//     if (nodeName != null) {
//       fetchNodeLiveData(nodeName);
//     }
//   }
//
//   Future<void> _selectStartDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: startDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null && picked != startDate) {
//       setState(() {
//         startDate = picked;
//       });
//     }
//   }
//
//   Future<void> _selectEndDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: endDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null && picked != endDate) {
//       setState(() {
//         endDate = picked;
//       });
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
//     final dateFormat = DateFormat('yyyy-MM-dd');
//
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SizedBox(
//             height: 70,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     const Text('Start Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primaryTextColor)),
//                     GestureDetector(
//                       onTap: () => _selectStartDate(context),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         height: 40,
//                         width: 120,
//                         child: Center(child: Text(startDate != null ? dateFormat.format(startDate!) : 'Select Start Date', style: const TextStyle(fontSize: 16))),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     const Text('End Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primaryTextColor)),
//                     GestureDetector(
//                       onTap: () => _selectEndDate(context),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         height: 40,
//                         width: 120,
//                         child: Center(child: Text(endDate != null ? dateFormat.format(endDate!) : 'Select End Date', style: const TextStyle(fontSize: 16))),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     const Text('', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primaryTextColor)),
//                     GestureDetector(
//                       onTap: startDate != null && endDate != null ? fetchShedData : null,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: AppColors.secondaryTextColor,
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         height: 40,
//                         width: 100,
//                         child: const Center(child: Text('Submit', style: TextStyle(fontSize: 16, color: AppColors.whiteTextColor))),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         isLoading
//             ? Center(child: Lottie.asset(AssetsPath.loadingJson, height: MediaQuery.sizeOf(context).height * 0.12))
//             : Expanded(
//           child: Container(
//             clipBehavior: Clip.antiAlias,
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16)),
//               color: Colors.white,
//             ),
//             child: SfDataGridTheme(
//               data: SfDataGridThemeData(headerColor: AppColors.secondaryTextColor),
//               child: SfDataGrid(
//                 source: _dataSource!,
//                 columnWidthMode: ColumnWidthMode.fill,
//                 columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
//                 onQueryRowHeight: (RowHeightDetails details) {
//                   if (details.rowIndex == 0) return 50;
//                   var row = _dataSource!.rows[details.rowIndex - 1];
//                   var longestCellText = row
//                       .getCells()
//                       .map((cell) => cell.value.toString().length)
//                       .reduce((value, element) => value > element ? value : element);
//                   return longestCellText > 20 ? 65 : 53;
//                 },
//                 gridLinesVisibility: GridLinesVisibility.both,
//                 headerGridLinesVisibility: GridLinesVisibility.both,
//                 columns: [
//                   GridColumn(
//                     columnName: 'Name',
//                     label: Container(
//                       padding: const EdgeInsets.all(8.0),
//                       alignment: Alignment.center,
//                       child: const Text('Name', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//                     ),
//                   ),
//                   GridColumn(
//                     columnName: 'energy',
//                     label: Container(
//                       padding: const EdgeInsets.all(8.0),
//                       alignment: Alignment.center,
//                       child: const Text('Energy', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//                     ),
//                   ),
//                   GridColumn(
//                     columnName: 'cost',
//                     label: Container(
//                       padding: const EdgeInsets.all(8.0),
//                       alignment: Alignment.center,
//                       child: const Text('Cost', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
//                     ),
//                   ),
//                 ],
//                 allowSorting: false,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
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
// class DataRowModel {
//   final int level;
//   final String title;
//   final String? nodeName;
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
//     this.energy,
//     this.cost,
//     this.expandable = false,
//     this.children = const [],
//     this.isExpanded = false,
//   });
// }
//
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
//       DataGridCell<DataRowModel>(columnName: 'title', value: row),
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
//     final rowModel = row.getCells()[0].value as DataRowModel;
//     final isSelectedNode = rowModel.nodeName == selectedNodeName;
//
//     return DataGridRowAdapter(cells: [
//       GestureDetector(
//         onTap: () {
//           if (rowModel.expandable) {
//             rowModel.isExpanded = !rowModel.isExpanded;
//             buildDataGridRows();
//             notifyListeners();
//           } else if (rowModel.level == 2 && rowModel.nodeName != null) {
//             onNodeSelected(rowModel.nodeName);
//           }
//         },
//         child: Container(
//           padding: EdgeInsets.only(left: 12.0 * rowModel.level, top: 8, bottom: 8),
//           child: Row(
//             children: [
//               if (rowModel.expandable)
//                 Icon(
//                   rowModel.isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
//                   size: 20,
//                 ),
//               if (rowModel.level == 2)
//                 const Icon(
//                   Icons.circle,
//                   size: 6,
//                   // color: isSelectedNode ? Colors.blue : Colors.grey,
//                 ),
//               const SizedBox(width: 4),
//               Flexible(
//                 child: Text(
//                   rowModel.title,
//                   style: TextStyle(
//                     fontWeight: rowModel.level == 0 || isSelectedNode ? FontWeight.normal : FontWeight.normal,
//                     // color: isSelectedNode ? Colors.blue : null,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       _buildTextCell(row.getCells()[1].value, isSelectedNode, 'energy'),
//       _buildTextCell(row.getCells()[2].value, isSelectedNode, 'cost'),
//     ]);
//   }
//
//   Widget _buildTextCell(dynamic value, bool isSelected, String columnName) {
//     String unit = columnName == 'energy' ? 'kWh' : '৳';
//     return Container(
//         alignment: Alignment.center,
//         padding: const EdgeInsets.all(8.0),
//         child: Text(
//             value != null ? '${value.toStringAsFixed(2)} $unit' : '',
//             style: TextStyle(
//               color: (value != null && value > 0 ? Colors.black87 : Colors.grey),
//               fontWeight: isSelected ? FontWeight.normal : FontWeight.normal,
//             ),
//             ),
//         );
//    }
// }
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart' show AuthUtilityController;
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart' show Urls;
import 'package:nz_fabrics/src/common_widgets/flutter_smart_download_widget/flutter_smart_download_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Row,Column,Border;

import '../../../../../../../../utility/style/constant.dart';

/*
class FormattedShedData {
  final String date;
  final String shed;
  final double totalEnergy;
  final double totalCost;
  final double unitCost;

  FormattedShedData({
    required this.date,
    required this.shed,
    required this.totalEnergy,
    required this.totalCost,
    required this.unitCost,
  });
}

class ShedWiseCustomScreen extends StatefulWidget {
  const ShedWiseCustomScreen({super.key});

  @override
  State<ShedWiseCustomScreen> createState() => _ShedWiseCustomScreenState();
}

class _ShedWiseCustomScreenState extends State<ShedWiseCustomScreen> {
  List<DataRowModel> allRows = [];
  List<FormattedShedData> perDayData = [];
  bool isLoadingHierarchical = true;
  bool isLoadingPerDay = false;
  NodeLiveData? selectedNodeData;
  bool isLoadingNodeData = false;
  String? selectedNodeName;
  DateTime? startDate;
  DateTime? endDate;
  List<String> shedNames = [];

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
    fetchShedData();
    fetchPerDayShedData();
  }

  Future<void> fetchShedData() async {
    if (startDate == null || endDate == null) return;

    setState(() {
      isLoadingHierarchical = true;
    });

    final url = Uri.parse('${Urls.baseUrl}/api/filter-shedwise-date-view/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': '${AuthUtilityController.accessToken}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'start': DateFormat('yyyy-MM-dd').format(startDate!),
        'end': DateFormat('yyyy-MM-dd').format(endDate!),
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<DataRowModel> rows = [];

      data.forEach((shedKey, shedValue) {
        final shedRow = DataRowModel(
          level: 0,
          title: shedKey,
          energy: (shedValue['shed_total_energy'] as num).toDouble(),
          cost: (shedValue['shed_total_cost'] as num).toDouble(),
          expandable: true,
          children: [],
        );

        final machinesList = shedValue['machine_data'] as List;
        for (var machine in machinesList) {
          final hasNodes = (machine['children'] as List).isNotEmpty;
          if (hasNodes || (machine['total_energy'] as num) > 0) {
            final machineRow = DataRowModel(
              level: 1,
              title: machine['machine_type'],
              energy: (machine['total_energy'] as num).toDouble(),
              cost: (machine['total_cost'] as num).toDouble(),
              expandable: hasNodes,
              children: [],
            );

            if (hasNodes) {
              for (var node in machine['children']) {
                if ((node['total_energy'] as num) > 0) {
                  machineRow.children.add(DataRowModel(
                    level: 2,
                    title: node['node'],
                    nodeName: node['node'],
                    energy: (node['total_energy'] as num).toDouble(),
                    cost: (node['total_cost'] as num).toDouble(),
                    expandable: false,
                  ));
                }
              }
            }

            shedRow.children.add(machineRow);
          }
        }

        if (shedRow.children.isNotEmpty) {
          rows.add(shedRow);
        }
      });

      setState(() {
        allRows = rows;
        isLoadingHierarchical = false;
      });

      await _fetchInitialNodeData(rows);
    } else {
      log('Failed to load shed data: ${response.statusCode}');
      setState(() {
        isLoadingHierarchical = false;
      });
    }
  }

  Future<void> _fetchInitialNodeData(List<DataRowModel> rows) async {
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

    const batchSize = 5;
    for (int i = 0; i < nodeNames.length; i += batchSize) {
      final batch = nodeNames.sublist(
          i, i + batchSize > nodeNames.length ? nodeNames.length : i + batchSize);
      await Future.wait(batch.map((nodeName) => fetchNodeLiveData(nodeName)));
    }
  }

  Future<void> fetchNodeLiveData(String nodeName) async {
  if(mounted){
    setState(() {
      isLoadingNodeData = true;
      selectedNodeName = nodeName;
    });
  }

    try {
      final url = Uri.parse('${Urls.baseUrl}/get-live-data/$nodeName/');
      final response = await http.get(
        url,
        headers: {
          'Authorization': '${AuthUtilityController.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final nodeData = NodeLiveData.fromJson(data);

        _updateNodeValues(nodeName, nodeData);

        setState(() {
          selectedNodeData = nodeData;
          isLoadingNodeData = false;
        });
      } else {
        log('Failed to load node data: ${response.statusCode}');
       if(mounted){
         setState(() {
           isLoadingNodeData = false;
         });
       }
      }
    } catch (e) {
      log('Error fetching node data: $e');
     if(mounted){
       setState(() {
         isLoadingNodeData = false;
       });
     }
    }
  }

  void _updateNodeValues(String nodeName, NodeLiveData nodeData) {
    for (var shed in allRows) {
      for (var machine in shed.children) {
        for (var node in machine.children) {
          if (node.nodeName == nodeName) {
            node.energy = nodeData.todayEnergy;
            node.cost = nodeData.cost;
            _updateMachineTotals(machine);
            break;
          }
        }
      }
    }

    if (_dataSource != null) {
      _dataSource!.buildDataGridRows();
      _dataSource!.notifyListeners();
    }
  }

  void _updateMachineTotals(DataRowModel machine) {
    if (machine.children.isEmpty) return;

    double totalEnergy = 0;
    double totalCost = 0;

    for (var node in machine.children) {
      totalEnergy += node.energy ?? 0;
      totalCost += node.cost ?? 0;
    }
  }

  void _onNodeSelected(String? nodeName) {
    if (nodeName != null) {
      fetchNodeLiveData(nodeName);
    }
  }

  Future<void> fetchPerDayShedData() async {
    if (startDate == null || endDate == null) return;

    setState(() {
      isLoadingPerDay = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/api/filter-perday-shedwise-view-data/'),
        headers: {
          'Authorization': '${AuthUtilityController.accessToken}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "start": DateFormat('yyyy-MM-dd').format(startDate!),
          "end": DateFormat('yyyy-MM-dd').format(endDate!),
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          shedNames = jsonResponse.keys.toList();
          List<FormattedShedData> formattedData = [];
          jsonResponse.forEach((shed, data) {
            List<dynamic> dailyData = data['daily'];
            for (var day in dailyData) {
              formattedData.add(FormattedShedData(
                date: day['date'],
                shed: shed,
                totalEnergy: (day['total_energy'] as num).toDouble(),
                totalCost: (day['total_cost'] as num).toDouble(),
                unitCost: (day['unit_cost'] as num).toDouble(),
              ));
            }
          });

          setState(() {
            perDayData = formattedData;
            isLoadingPerDay = false;
          });
        } else {
          throw Exception('Empty response received');
        }
      } else {
        throw Exception('Failed to load shed data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
      setState(() {
        perDayData = [];
        if (shedNames.isEmpty) {
          shedNames = ['No sheds available'];
        }
        isLoadingPerDay = false;
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  CustomDataSource? _dataSource;

  Future<PermissionStatus> _requestStoragePermission() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    if (android.version.sdkInt < 33) {
      return await Permission.storage.request();
    } else {
      return PermissionStatus.granted;
    }
  }

  Future<void> downloadDataSheet(BuildContext context) async {
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        final Workbook workbook = Workbook();

        // Sheet 1: Shed Wise Report (Per-Day Table)
        final Worksheet shedSheet = workbook.worksheets[0];
        shedSheet.name = 'Shed Wise Report';

        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        // Set headers for Shed Report
        shedSheet.getRangeByIndex(1, 1).setText('Date');
        int colIndex = 2;
        for (var shed in shedNames) {
          shedSheet.getRangeByIndex(1, colIndex).setText('$shed Energy (kWh)');
          shedSheet.getRangeByIndex(1, colIndex + 1).setText('$shed Cost (৳)');
          colIndex += 2;
        }

        // Apply header style
        shedSheet.getRangeByIndex(1, 1, 1, colIndex - 1).cellStyle = headerStyle;

        // Populate Shed Report data
        Map<String, Map<String, Map<String, double>>> pivotedData = {};
        Map<String, double> totalEnergyMap = {};
        Map<String, double> totalCostMap = {};

        for (var data in perDayData) {
          if (!pivotedData.containsKey(data.date)) {
            pivotedData[data.date] = {};
          }
          pivotedData[data.date]![data.shed] = {
            'energy': data.totalEnergy,
            'cost': data.totalCost,
          };

          totalEnergyMap[data.shed] = (totalEnergyMap[data.shed] ?? 0) + data.totalEnergy;
          totalCostMap[data.shed] = (totalCostMap[data.shed] ?? 0) + data.totalCost;
        }

        int rowIndex = 2;
        pivotedData.forEach((date, sheds) {
          shedSheet.getRangeByIndex(rowIndex, 1).setText(date);
          colIndex = 2;
          for (var shed in shedNames) {
            shedSheet.getRangeByIndex(rowIndex, colIndex).setNumber(sheds[shed]?['energy'] ?? 0);
            shedSheet.getRangeByIndex(rowIndex, colIndex + 1).setNumber(sheds[shed]?['cost'] ?? 0);
            colIndex += 2;
          }
          rowIndex++;
        });

        // Add total row
        shedSheet.getRangeByIndex(rowIndex, 1).setText('Total');
        colIndex = 2;
        for (var shed in shedNames) {
          shedSheet.getRangeByIndex(rowIndex, colIndex).setNumber(totalEnergyMap[shed] ?? 0);
          shedSheet.getRangeByIndex(rowIndex, colIndex + 1).setNumber(totalCostMap[shed] ?? 0);
          colIndex += 2;
        }

        // Sheet 2: Custom Shed Report (Hierarchical Table)
        final Worksheet customSheet = workbook.worksheets.add();
        customSheet.name = 'Custom Shed Report';

        // Set headers for Custom Report
        customSheet.getRangeByIndex(1, 1).setText('Name');
        customSheet.getRangeByIndex(1, 2).setText('Energy (kWh)');
        customSheet.getRangeByIndex(1, 3).setText('Cost (৳)');

        // Apply header style
        customSheet.getRangeByIndex(1, 1, 1, 3).cellStyle = headerStyle;

        // Populate Custom Report data
        rowIndex = 2;
        for (var shed in allRows) {
          customSheet.getRangeByIndex(rowIndex, 1).setText(shed.title);
          customSheet.getRangeByIndex(rowIndex, 2).setNumber(shed.energy ?? 0);
          customSheet.getRangeByIndex(rowIndex, 3).setNumber(shed.cost ?? 0);
          rowIndex++;

          if (shed.isExpanded || true) {
            // Include machines
            for (var machine in shed.children) {
              customSheet.getRangeByIndex(rowIndex, 1).setText('  ${machine.title}');
              customSheet.getRangeByIndex(rowIndex, 2).setNumber(machine.energy ?? 0);
              customSheet.getRangeByIndex(rowIndex, 3).setNumber(machine.cost ?? 0);
              rowIndex++;

              // Include nodes
              for (var node in machine.children) {
                customSheet.getRangeByIndex(rowIndex, 1).setText('    • ${node.title}');
                customSheet.getRangeByIndex(rowIndex, 2).setNumber(node.energy ?? 0);
                customSheet.getRangeByIndex(rowIndex, 3).setNumber(node.cost ?? 0);
                rowIndex++;
              }
            }
          }
        }

        // Auto-fit columns for both sheets
        for (int i = 1; i <= 3; i++) {
          customSheet.autoFitColumn(i);
        }
        for (int i = 1; i <= (shedNames.length * 2 + 1); i++) {
          shedSheet.autoFitColumn(i);
        }

        // Save the file
        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (await directory.exists()) {
            String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
            String filePath =
                "${directory.path}/Shed_Report_$formattedDate $formattedTime.xlsx";

            final List<int> bytes = workbook.saveAsStream();
            File(filePath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(bytes);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("File downloaded successfully"),
                backgroundColor: AppColors.greenColor,
                margin: EdgeInsets.all(16),
                behavior: SnackBarBehavior.floating,
              ),
            );

            FlutterSmartDownloadDialog.show(
              context: context,
              filePath: filePath,
              dialogType: DialogType.popup,
            );
            log("File saved at ==> $filePath");
          } else {
            throw Exception("Download directory does not exist");
          }
        }

        // Dispose workbook
       // workbook.dispose();
      } catch (e) {
        log("Error saving Excel file: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not save file: $e"),
            duration: const Duration(seconds: 7),
            backgroundColor: AppColors.redColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else if (storageStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
    }

  @override
  Widget build(BuildContext context) {
    _dataSource = CustomDataSource(
      data: allRows,
      onNodeSelected: _onNodeSelected,
      selectedNodeName: selectedNodeName,
    );
    final dateFormat = DateFormat('yyyy-MM-dd');
   Size size = MediaQuery.sizeOf(context);
    return  SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => _selectStartDate(context),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          height: size.width > 500 ? size.height * 0.035 : size.height * 0.045,
                          width: size.width / 3.5,
                          child: Center(
                              child: Text(
                                  startDate != null
                                      ? dateFormat.format(startDate!)
                                      : 'Select Start Date',
                                  style: const TextStyle(fontSize: 16))),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectEndDate(context),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          height: size.width > 500 ? size.height * 0.035 : size.height * 0.045,
                          width: size.width / 3.5,
                          child: Center(
                              child: Text(
                                  endDate != null
                                      ? dateFormat.format(endDate!)
                                      : 'Select End Date',
                                  style: const TextStyle(fontSize: 16))),
                        ),
                      ),
                      GestureDetector(
                        onTap: startDate != null && endDate != null
                            ? () {
                          fetchShedData();
                          fetchPerDayShedData();
                        } : null,

                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.secondaryTextColor,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          height: size.width > 500 ? size.height * 0.035 : size.height * 0.045,
                          width: size.width / 4.9,
                          child: const Center(
                              child: Text('Submit',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.whiteTextColor),
                              ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      GestureDetector(
                          onTap: () => downloadDataSheet(context),
                          child: SvgPicture.asset(AssetsPath.downloadIconSVG,height:25 ,))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.4,
                child: isLoadingHierarchical
                    ? const Center(
                      child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0,))
                    : _buildHierarchicalTable(context),
              ),

              const SizedBox(height: 15,),
              SizedBox(
                height: size.height * 0.4,
                child: isLoadingPerDay
                    ? const Center(child: SpinKitFadingCircle(color: AppColors.primaryColor, size: 50.0),)
                    : Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: _buildPerDayTable(context),
                    ),
              ),
            ],
          ),
    );

  }

  Widget _buildHierarchicalTable(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
      ),
      child: SfDataGridTheme(
        data: SfDataGridThemeData(headerColor: AppColors.secondaryTextColor),
        child: SfDataGrid(
          source: _dataSource!,
          columnWidthMode: ColumnWidthMode.fill,
          columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
          onQueryRowHeight: (RowHeightDetails details) {
            if (details.rowIndex == 0) return 50;
            var row = _dataSource!.rows[details.rowIndex - 1];
            var longestCellText = row
                .getCells()
                .map((cell) => cell.value.toString().length)
                .reduce((value, element) => value > element ? value : element);
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
                child:  Text('Name',
                    style: TextStyle(
                        fontSize: size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            GridColumn(
              columnName: 'energy',
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child:  Text('Energy',
                    style: TextStyle(
                      fontSize: size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            GridColumn(
              columnName: 'cost',
              label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child:  Text('Cost',
                    style: TextStyle(
                        fontSize: size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
                        fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
          allowSorting: false,
        ),
      ),
    );
  }

  Widget _buildPerDayTable(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: perDayData.isEmpty
          ? const Center(child: Text('No data available'))
          : SfDataGridTheme(
        data: SfDataGridThemeData(
          headerColor: AppColors.secondaryTextColor,
        ),
        child: SfDataGrid(
          headerRowHeight: size.width > 500 ? 58 : 40,
          headerGridLinesVisibility: GridLinesVisibility.both,
          gridLinesVisibility: GridLinesVisibility.both,
          rowHeight: size.width > 500 ? size.height * 0.03 : size.height * 0.037,
          columnWidthMode: ColumnWidthMode.auto,
          source: ShedDataGridSource(perDayData, shedNames),
          frozenColumnsCount: 1,
          footerFrozenRowsCount: 1,
          columns: _buildColumns(size),
          stackedHeaderRows: _buildStackedHeaders(size),
        ),
      ),
    );
  }

  List<GridColumn> _buildColumns(Size size) {
    List<GridColumn> columns = [
      GridColumn(
        columnName: 'date',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text('Date',
              style: TextStyle(
                  color: AppColors.whiteTextColor,
                  fontSize:  size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    ];

    for (var shed in shedNames) {
      columns.addAll([
        GridColumn(
          columnName: '${shed}_energy',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('Energy',
                style: TextStyle(
                    color: AppColors.whiteTextColor,
                    fontSize: size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        GridColumn(
          columnName: '${shed}_cost',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('Cost/Unit',
                style: TextStyle(
                    color: AppColors.whiteTextColor,
                    fontSize: size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ]);
    }
    return columns;
  }

  List<StackedHeaderRow> _buildStackedHeaders(Size size) {
    List<StackedHeaderCell> cells = [];
    for (var shed in shedNames) {
      cells.add(StackedHeaderCell(
        columnNames: ['${shed}_energy', '${shed}_cost'],
        child: Container(
          color: AppColors.secondaryTextColor,
          alignment: Alignment.center,
          child: Text(shed,
              style: TextStyle(
                  color: AppColors.whiteTextColor,
                  fontSize: size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
                  fontWeight: FontWeight.bold)),
        ),
      ));
    }
    return [StackedHeaderRow(cells: cells)];
  }
}

// Reused Classes (unchanged)
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

class DataRowModel {
  final int level;
  final String title;
  final String? nodeName;
  double? energy;
  double? cost;
  final bool expandable;
  final List<DataRowModel> children;
  bool isExpanded;

  DataRowModel({
    required this.level,
    required this.title,
    this.nodeName,
    this.energy,
    this.cost,
    this.expandable = false,
    this.children = const [],
    this.isExpanded = false,
  });
}

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
  }

  void _addRowWithChildren(DataRowModel row) {
    _rows.add(DataGridRow(cells: [
      DataGridCell<DataRowModel>(columnName: 'title', value: row),
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
          padding: EdgeInsets.only(left: 12.0 * rowModel.level, top: 8, bottom: 8),
          child: Row(
            children: [
              if (rowModel.expandable)
                Icon(
                  rowModel.isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                  size: 20,
                ),
              if (rowModel.level == 2)
                const Icon(
                  Icons.circle,
                  size: 6,
                ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  rowModel.title,
                  style: TextStyle(
                    fontWeight:
                    rowModel.level == 0 || isSelectedNode ? FontWeight.normal : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      _buildTextCell(row.getCells()[1].value, isSelectedNode, 'energy'),
      _buildTextCell(row.getCells()[2].value, isSelectedNode, 'cost'),
    ]);
  }

  Widget _buildTextCell(dynamic value, bool isSelected, String columnName) {
    String unit = columnName == 'energy' ? 'kWh' : '৳';
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value != null ? '${value.toStringAsFixed(2)} $unit' : '',
        style: TextStyle(
          color: (value != null && value > 0 ? Colors.black87 : Colors.grey),
          fontWeight: isSelected ? FontWeight.normal : FontWeight.normal,
        ),
      ),
    );
  }
}

class ShedDataGridSource extends DataGridSource {
  List<DataGridRow> _formattedData = [];
  final List<String> shedNames;

  ShedDataGridSource(List<FormattedShedData> data, this.shedNames) {
    Map<String, Map<String, Map<String, String>>> pivotedData = {};
    Map<String, double> totalEnergyMap = {};
    Map<String, double> totalCostMap = {};

    for (var item in data) {
      if (!pivotedData.containsKey(item.date)) {
        pivotedData[item.date] = {};
      }
      pivotedData[item.date]![item.shed] = {
        'energy': item.totalEnergy.toStringAsFixed(2),
        'cost': '${item.totalCost.toStringAsFixed(0)}/${item.unitCost.toStringAsFixed(2)}',
      };

      totalEnergyMap[item.shed] = (totalEnergyMap[item.shed] ?? 0) + item.totalEnergy;
      totalCostMap[item.shed] = (totalCostMap[item.shed] ?? 0) + item.totalCost;
    }

    _formattedData = pivotedData.entries.map((entry) {
      List<DataGridCell> cells = [
        DataGridCell<String>(columnName: 'date', value: entry.key),
      ];

      for (var shed in shedNames) {
        cells.addAll([
          DataGridCell<String>(
            columnName: '${shed}_energy',
            value: entry.value[shed]?['energy'] ?? '0.00',
          ),
          DataGridCell<String>(
            columnName: '${shed}_cost',
            value: entry.value[shed]?['cost'] ?? '0/0.00',
          ),
        ]);
      }
      return DataGridRow(cells: cells);
    }).toList();

    List<DataGridCell> totalCells = [
      const DataGridCell<String>(columnName: 'date', value: 'Total'),
    ];
    for (var shed in shedNames) {
      double totalEnergy = totalEnergyMap[shed] ?? 0;
      double totalCost = totalCostMap[shed] ?? 0;
      double unitCost = totalEnergy != 0 ? totalCost / totalEnergy : 0;
      totalCells.addAll([
        DataGridCell<String>(
          columnName: '${shed}_energy',
          value: totalEnergy.toStringAsFixed(2),
        ),
        DataGridCell<String>(
          columnName: '${shed}_cost',
          value: '${totalCost.toStringAsFixed(0)}/${unitCost.toStringAsFixed(2)}',
        ),
      ]);
    }
    _formattedData.add(DataGridRow(cells: totalCells));
  }

  @override
  List<DataGridRow> get rows => _formattedData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    bool isTotalRow = row.getCells().first.value == 'Total';
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4.0),
          child: Text(
            cell.columnName.endsWith('_energy')
                ? '${cell.value} kWh'
                : cell.columnName.endsWith('_cost')
                ? '${cell.value} ৳'
                : cell.value.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryTextColor,
              fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
            ),
            softWrap: true,
            maxLines: 2,
          ),
        );
      }).toList(),
    );
  }
}*/






class FormattedShedData {
  final String date;
  final String shed;
  final double totalEnergy;
  final double totalCost;
  final double unitCost;

  FormattedShedData({
    required this.date,
    required this.shed,
    required this.totalEnergy,
    required this.totalCost,
    required this.unitCost,
  });
}

class ShedWiseCustomScreen extends StatefulWidget {
  const ShedWiseCustomScreen({super.key});

  @override
  State<ShedWiseCustomScreen> createState() => _ShedWiseCustomScreenState();
}

class _ShedWiseCustomScreenState extends State<ShedWiseCustomScreen> {
  List<DataRowModel> allRows = [];
  List<FormattedShedData> perDayData = [];
  bool isLoadingHierarchical = true;
  bool isLoadingPerDay = false;
  NodeLiveData? selectedNodeData;
  bool isLoadingNodeData = false;
  String? selectedNodeName;
  DateTime? startDate;
  DateTime? endDate;
  List<String> shedNames = [];
  CustomDataSource? _dataSource;

  // Define row and header heights (same as CombinedMachineScreen)
  final rowHeight = 35.0;
  final headerHeight = 45.0;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
    fetchShedData();
    fetchPerDayShedData();
  }

  Future<void> fetchShedData() async {
    if (startDate == null || endDate == null) return;

    setState(() {
      isLoadingHierarchical = true;
    });

    final url = Uri.parse('${Urls.baseUrl}/api/filter-shedwise-date-view/');
    final response = await http.post(
      url,
      headers: {
        'Authorization': '${AuthUtilityController.accessToken}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'start': DateFormat('yyyy-MM-dd').format(startDate!),
        'end': DateFormat('yyyy-MM-dd').format(endDate!),
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<DataRowModel> rows = [];

      data.forEach((shedKey, shedValue) {
        final shedRow = DataRowModel(
          level: 0,
          title: shedKey,
          energy: (shedValue['shed_total_energy'] as num).toDouble(),
          cost: (shedValue['shed_total_cost'] as num).toDouble(),
          expandable: true,
          children: [],
        );

        final machinesList = shedValue['machine_data'] as List;
        for (var machine in machinesList) {
          final hasNodes = (machine['children'] as List).isNotEmpty;
          if (hasNodes || (machine['total_energy'] as num) > 0) {
            final machineRow = DataRowModel(
              level: 1,
              title: machine['machine_type'],
              energy: (machine['total_energy'] as num).toDouble(),
              cost: (machine['total_cost'] as num).toDouble(),
              expandable: hasNodes,
              children: [],
            );

            if (hasNodes) {
              for (var node in machine['children']) {
                if ((node['total_energy'] as num) > 0) {
                  machineRow.children.add(DataRowModel(
                    level: 2,
                    title: node['node'],
                    nodeName: node['node'],
                    energy: (node['total_energy'] as num).toDouble(),
                    cost: (node['total_cost'] as num).toDouble(),
                    expandable: false,
                  ));
                }
              }
            }

            shedRow.children.add(machineRow);
          }
        }

        if (shedRow.children.isNotEmpty) {
          rows.add(shedRow);
        }
      });

      setState(() {
        allRows = rows;
        isLoadingHierarchical = false;
      });

      await _fetchInitialNodeData(rows);
    } else {
      log('Failed to load shed data: ${response.statusCode}');
      setState(() {
        isLoadingHierarchical = false;
      });
    }
  }

  Future<void> _fetchInitialNodeData(List<DataRowModel> rows) async {
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

    const batchSize = 5;
    for (int i = 0; i < nodeNames.length; i += batchSize) {
      final batch = nodeNames.sublist(
          i, i + batchSize > nodeNames.length ? nodeNames.length : i + batchSize);
      await Future.wait(batch.map((nodeName) => fetchNodeLiveData(nodeName)));
    }
  }

  Future<void> fetchNodeLiveData(String nodeName) async {
    if (mounted) {
      setState(() {
        isLoadingNodeData = true;
        selectedNodeName = nodeName;
      });
    }

    try {
      final url = Uri.parse('${Urls.baseUrl}/get-live-data/$nodeName/');
      final response = await http.get(
        url,
        headers: {
          'Authorization': '${AuthUtilityController.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final nodeData = NodeLiveData.fromJson(data);

        _updateNodeValues(nodeName, nodeData);

        setState(() {
          selectedNodeData = nodeData;
          isLoadingNodeData = false;
        });
      } else {
        log('Failed to load node data: ${response.statusCode}');
        if (mounted) {
          setState(() {
            isLoadingNodeData = false;
          });
        }
      }
    } catch (e) {
      log('Error fetching node data: $e');
      if (mounted) {
        setState(() {
          isLoadingNodeData = false;
        });
      }
    }
  }

  void _updateNodeValues(String nodeName, NodeLiveData nodeData) {
    for (var shed in allRows) {
      for (var machine in shed.children) {
        for (var node in machine.children) {
          if (node.nodeName == nodeName) {
            node.energy = nodeData.todayEnergy;
            node.cost = nodeData.cost;
            _updateMachineTotals(machine);
            break;
          }
        }
      }
    }

    if (_dataSource != null) {
      _dataSource!.buildDataGridRows();
      _dataSource!.notifyListeners();
    }
  }

  void _updateMachineTotals(DataRowModel machine) {
    if (machine.children.isEmpty) return;

    double totalEnergy = 0;
    double totalCost = 0;

    for (var node in machine.children) {
      totalEnergy += node.energy ?? 0;
      totalCost += node.cost ?? 0;
    }
  }

  void _onNodeSelected(String? nodeName) {
    if (nodeName != null) {
      fetchNodeLiveData(nodeName);
    }
  }

  Future<void> fetchPerDayShedData() async {
    if (startDate == null || endDate == null) return;

    setState(() {
      isLoadingPerDay = true;
    });

    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}/api/filter-perday-shedwise-view-data/'),
        headers: {
          'Authorization': '${AuthUtilityController.accessToken}',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "start": DateFormat('yyyy-MM-dd').format(startDate!),
          "end": DateFormat('yyyy-MM-dd').format(endDate!),
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
          shedNames = jsonResponse.keys.toList();
          List<FormattedShedData> formattedData = [];
          jsonResponse.forEach((shed, data) {
            List<dynamic> dailyData = data['daily'];
            for (var day in dailyData) {
              formattedData.add(FormattedShedData(
                date: day['date'],
                shed: shed,
                totalEnergy: (day['total_energy'] as num).toDouble(),
                totalCost: (day['total_cost'] as num).toDouble(),
                unitCost: (day['unit_cost'] as num).toDouble(),
              ));
            }
          });

          setState(() {
            perDayData = formattedData;
            isLoadingPerDay = false;
          });
        } else {
          throw Exception('Empty response received');
        }
      } else {
        throw Exception('Failed to load shed data: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
      setState(() {
        perDayData = [];
        if (shedNames.isEmpty) {
          shedNames = ['No sheds available'];
        }
        isLoadingPerDay = false;
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != startDate) {
     if(mounted){
       setState(() {
         startDate = picked;
       });
     }
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != endDate) {
     if(mounted){
       setState(() {
         endDate = picked;
       });
     }
    }
  }

  Future<PermissionStatus> _requestStoragePermission() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    if (android.version.sdkInt < 33) {
      return await Permission.storage.request();
    } else {
      return PermissionStatus.granted;
    }
  }

  Future<void> downloadDataSheet(BuildContext context) async {
    PermissionStatus storageStatus = await _requestStoragePermission();

    if (storageStatus == PermissionStatus.granted) {
      try {
        final Workbook workbook = Workbook();

        // Sheet 1: Shed Wise Report (Per-Day Table)
        final Worksheet shedSheet = workbook.worksheets[0];
        shedSheet.name = 'Shed Wise Report';

        final Style headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.hAlign = HAlignType.center;
        headerStyle.backColor = '#D9E1F2';

        // Set headers for Shed Report
        shedSheet.getRangeByIndex(1, 1).setText('Date');
        int colIndex = 2;
        for (var shed in shedNames) {
          shedSheet.getRangeByIndex(1, colIndex).setText('$shed Energy (kWh)');
          shedSheet.getRangeByIndex(1, colIndex + 1).setText('$shed Cost (৳)');
          colIndex += 2;
        }

        // Apply header style
        shedSheet.getRangeByIndex(1, 1, 1, colIndex - 1).cellStyle = headerStyle;

        // Populate Shed Report data
        Map<String, Map<String, Map<String, double>>> pivotedData = {};
        Map<String, double> totalEnergyMap = {};
        Map<String, double> totalCostMap = {};

        for (var data in perDayData) {
          if (!pivotedData.containsKey(data.date)) {
            pivotedData[data.date] = {};
          }
          pivotedData[data.date]![data.shed] = {
            'energy': data.totalEnergy,
            'cost': data.totalCost,
          };

          totalEnergyMap[data.shed] = (totalEnergyMap[data.shed] ?? 0) + data.totalEnergy;
          totalCostMap[data.shed] = (totalCostMap[data.shed] ?? 0) + data.totalCost;
        }

        int rowIndex = 2;
        pivotedData.forEach((date, sheds) {
          shedSheet.getRangeByIndex(rowIndex, 1).setText(date);
          colIndex = 2;
          for (var shed in shedNames) {
            shedSheet.getRangeByIndex(rowIndex, colIndex).setNumber(sheds[shed]?['energy'] ?? 0);
            shedSheet.getRangeByIndex(rowIndex, colIndex + 1).setNumber(sheds[shed]?['cost'] ?? 0);
            colIndex += 2;
          }
          rowIndex++;
        });

        // Add total row
        shedSheet.getRangeByIndex(rowIndex, 1).setText('Total');
        colIndex = 2;
        for (var shed in shedNames) {
          shedSheet.getRangeByIndex(rowIndex, colIndex).setNumber(totalEnergyMap[shed] ?? 0);
          shedSheet.getRangeByIndex(rowIndex, colIndex + 1).setNumber(totalCostMap[shed] ?? 0);
          colIndex += 2;
        }

        // Sheet 2: Custom Shed Report (Hierarchical Table)
        final Worksheet customSheet = workbook.worksheets.add();
        customSheet.name = 'Custom Shed Report';

        // Set headers for Custom Report
        customSheet.getRangeByIndex(1, 1).setText('Name');
        customSheet.getRangeByIndex(1, 2).setText('Energy (kWh)');
        customSheet.getRangeByIndex(1, 3).setText('Cost (৳)');

        // Apply header style
        customSheet.getRangeByIndex(1, 1, 1, 3).cellStyle = headerStyle;

        // Populate Custom Report data
        rowIndex = 2;
        for (var shed in allRows) {
          customSheet.getRangeByIndex(rowIndex, 1).setText(shed.title);
          customSheet.getRangeByIndex(rowIndex, 2).setNumber(shed.energy ?? 0);
          customSheet.getRangeByIndex(rowIndex, 3).setNumber(shed.cost ?? 0);
          rowIndex++;

          if (shed.isExpanded) {
            // Include machines
            for (var machine in shed.children) {
              customSheet.getRangeByIndex(rowIndex, 1).setText('  ${machine.title}');
              customSheet.getRangeByIndex(rowIndex, 2).setNumber(machine.energy ?? 0);
              customSheet.getRangeByIndex(rowIndex, 3).setNumber(machine.cost ?? 0);
              rowIndex++;

              // Include nodes
              for (var node in machine.children) {
                customSheet.getRangeByIndex(rowIndex, 1).setText('    • ${node.title}');
                customSheet.getRangeByIndex(rowIndex, 2).setNumber(node.energy ?? 0);
                customSheet.getRangeByIndex(rowIndex, 3).setNumber(node.cost ?? 0);
                rowIndex++;
              }
            }
          }
        }

        // Auto-fit columns for both sheets
        for (int i = 1; i <= 3; i++) {
          customSheet.autoFitColumn(i);
        }
        for (int i = 1; i <= (shedNames.length * 2 + 1); i++) {
          shedSheet.autoFitColumn(i);
        }

        // Save the file
        if (Platform.isAndroid) {
          final directory = Directory('/storage/emulated/0/Download');
          if (await directory.exists()) {
            String formattedDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
            String formattedTime = DateFormat('hh-mm-a').format(DateTime.now());
            String filePath =
                "${directory.path}/Shed_Report_$formattedDate $formattedTime.xlsx";

            final List<int> bytes = workbook.saveAsStream();
            File(filePath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(bytes);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("File downloaded successfully"),
                backgroundColor: AppColors.greenColor,
                margin: EdgeInsets.all(16),
                behavior: SnackBarBehavior.floating,
              ),
            );

            FlutterSmartDownloadDialog.show(
              context: context,
              filePath: filePath,
              dialogType: DialogType.popup,
            );
            log("File saved at ==> $filePath");
          } else {
            throw Exception("Download directory does not exist");
          }
        }

        // Dispose workbook
        // workbook.dispose();
      } catch (e) {
        log("Error saving Excel file: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not save file: $e"),
            duration: const Duration(seconds: 7),
            backgroundColor: AppColors.redColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else if (storageStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    _dataSource = CustomDataSource(
      data: allRows,
      onNodeSelected: _onNodeSelected,
      selectedNodeName: selectedNodeName,
      onRowCountChanged: () {
        setState(() {}); // Rebuild UI when row count changes
      },
    );
    final dateFormat = DateFormat('yyyy-MM-dd');
    Size size = MediaQuery.sizeOf(context);

    // Create data source for per-day table
    final table2Source = ShedDataGridSource(perDayData, shedNames);

    return  SingleChildScrollView(
        child: Column(
          children: [
            // Shared Date Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => _selectStartDate(context),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        height: size.width > 500 ? size.height * 0.035 : size.height * 0.045,
                        width: size.width / 3.5,
                        child: Center(
                          child: Text(
                            startDate != null
                                ? dateFormat.format(startDate!)
                                : 'Select Start Date',
                            style: TextStyle(fontSize: size.width > 500 ? 18 : 16),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectEndDate(context),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        height: size.width > 500 ? size.height * 0.035 : size.height * 0.045,
                        width: size.width / 3.5,
                        child: Center(
                          child: Text(
                            endDate != null
                                ? dateFormat.format(endDate!)
                                : 'Select End Date',
                            style: TextStyle(fontSize: size.width > 500 ? 18 : 16),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: startDate != null && endDate != null
                          ? () {
                        fetchShedData();
                        fetchPerDayShedData();
                      }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondaryTextColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        height: size.width > 500 ? size.height * 0.035 : size.height * 0.045,
                        width: size.width / 4.9,
                        child: const Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.whiteTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: () => downloadDataSheet(context),
                      child: SvgPicture.asset(
                        AssetsPath.downloadIconSVG,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Table 1: Hierarchical Table
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
                child: isLoadingHierarchical
                    ? const Padding(
                      padding: EdgeInsets.only(top: 58.0,bottom: 20),
                      child: Center(
                                        child: SpinKitFadingCircle(
                      color: AppColors.primaryColor,
                      size: 50.0,
                                        ),
                                      ),
                    )
                    : LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate table height dynamically
                    final table1Height =
                        (_dataSource!.rows.length * rowHeight) + headerHeight;
                    return SizedBox(
                      height: table1Height,
                      child: SfDataGridTheme(
                        data: SfDataGridThemeData(
                          headerColor: AppColors.secondaryTextColor,
                        ),
                        child: SfDataGrid(
                          source: _dataSource!,
                          columns: _buildHierarchicalColumns(size),
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          columnWidthMode: ColumnWidthMode.fill,
                          rowHeight: rowHeight,
                          headerRowHeight: headerHeight,
                          shrinkWrapRows: true,
                          isScrollbarAlwaysShown: false,
                          verticalScrollPhysics: const NeverScrollableScrollPhysics(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Table 2: Per-Day Table
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 50, top: 8),
              child: Container(

                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: isLoadingPerDay
                    ? const Padding(
                      padding: EdgeInsets.only(top: 128.0),
                      child: Center(
                                        child: SpinKitFadingCircle(
                      color: AppColors.primaryColor,
                      size: 50.0,
                                        ),
                                      ),
                    )
                    : perDayData.isEmpty
                    ? const Center(
                  child: TextComponent(
                    text: '',
                    color: AppColors.secondaryTextColor,
                  ),
                )
                    : LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate table height dynamically
                    final table2Height = (table2Source.rows.length * rowHeight) + headerHeight+50;
                    return SizedBox(
                      height: table2Height,
                      child: SfDataGridTheme(
                        data: SfDataGridThemeData(
                          headerColor: AppColors.secondaryTextColor,
                          frozenPaneLineColor: AppColors.primaryColor,
                          frozenPaneLineWidth: 1.0,
                          gridLineColor: Colors.grey.shade300,
                          gridLineStrokeWidth: 0.4,
                        ),
                        child: SfDataGrid(
                          source: table2Source,
                          columns: _buildColumns(size),
                          stackedHeaderRows: _buildStackedHeaders(size),
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          columnWidthMode: ColumnWidthMode.auto,
                          rowHeight: rowHeight,
                          headerRowHeight: headerHeight,
                          frozenColumnsCount: 1,
                          footerFrozenRowsCount: 1,
                          shrinkWrapRows: true,
                          isScrollbarAlwaysShown: false,
                          verticalScrollPhysics: const NeverScrollableScrollPhysics(),
                          showHorizontalScrollbar: false,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );

  }

  List<GridColumn> _buildHierarchicalColumns(Size size) {
    return [
      GridColumn(
        columnName: 'Name',
        label: Container(
          padding: const EdgeInsets.all(12.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'Name',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.whiteTextColor,
              fontSize: size.width > 500 ? 16 : 14,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'energy',
        label: Container(
          padding: const EdgeInsets.all(12.0),
          alignment: Alignment.center,
          child: Text(
            'Energy',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.whiteTextColor,
              fontSize: size.width > 500 ? 16 : 14,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'cost',
        label: Container(
          padding: const EdgeInsets.all(12.0),
          alignment: Alignment.center,
          child: Text(
            'Cost',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.whiteTextColor,
              fontSize: size.width > 500 ? 16 : 14,
            ),
          ),
        ),
      ),
    ];
  }

  List<GridColumn> _buildColumns(Size size) {
    List<GridColumn> columns = [
      GridColumn(
        columnName: 'date',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: TextComponent(
            text: 'Date',
            color: AppColors.whiteTextColor,
            fontFamily: boldFontFamily,
            fontSize: size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
          ),
        ),
      ),
    ];

    for (var shed in shedNames) {
      columns.addAll([
        GridColumn(
          columnName: '${shed}_energy',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextComponent(
              text: 'Energy',
              color: AppColors.whiteTextColor,
              fontFamily: boldFontFamily,
              fontSize: size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
            ),
          ),
        ),
        GridColumn(
          columnName: '${shed}_cost',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: TextComponent(
              text: 'Cost/Unit',
              color: AppColors.whiteTextColor,
              fontFamily: boldFontFamily,
              fontSize: size.width > 500 ? size.height * k14TextSize : size.height * k16TextSize,
            ),
          ),
        ),
      ]);
    }
    return columns;
  }

  List<StackedHeaderRow> _buildStackedHeaders(Size size) {
    List<StackedHeaderCell> cells = [];
    for (var shed in shedNames) {
      cells.add(StackedHeaderCell(
        columnNames: ['${shed}_energy', '${shed}_cost'],
        child: Container(
          color: AppColors.secondaryTextColor,
          alignment: Alignment.center,
          child: TextComponent(
            text: shed.replaceAll('_', ' '),
            color: AppColors.whiteTextColor,
            fontFamily: boldFontFamily,
            fontSize: size.width > 500 ? size.height * k13TextSize : size.height * k14TextSize,
          ),
        ),
      ));
    }
    return [StackedHeaderRow(cells: cells)];
  }
}

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

class DataRowModel {
  final int level;
  final String title;
  final String? nodeName;
  double? energy;
  double? cost;
  final bool expandable;
  final List<DataRowModel> children;
  bool isExpanded;

  DataRowModel({
    required this.level,
    required this.title,
    this.nodeName,
    this.energy,
    this.cost,
    this.expandable = false,
    this.children = const [],
    this.isExpanded = false,
  });
}

class CustomDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];
  final List<DataRowModel> data;
  final Function(String?) onNodeSelected;
  final String? selectedNodeName;
  final VoidCallback onRowCountChanged;

  CustomDataSource({
    required this.data,
    required this.onNodeSelected,
    this.selectedNodeName,
    required this.onRowCountChanged,
  }) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    _rows.clear();
    for (var row in data) {
      _addRowWithChildren(row);
    }
    onRowCountChanged(); // Notify when rows change
  }

  void _addRowWithChildren(DataRowModel row) {
    _rows.add(DataGridRow(cells: [
      DataGridCell<DataRowModel>(columnName: 'title', value: row),
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
          padding: EdgeInsets.only(left: 12.0 * rowModel.level, top: 8, bottom: 8),
          child: Row(
            children: [
              if (rowModel.expandable)
                Icon(
                  rowModel.isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
                  size: 20,
                ),
              if (rowModel.level == 2)
                const Icon(
                  Icons.circle,
                  size: 6,
                ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  rowModel.title,
                  style: TextStyle(
                    fontWeight:
                    rowModel.level == 0 || isSelectedNode ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      _buildTextCell(row.getCells()[1].value, isSelectedNode, 'energy'),
      _buildTextCell(row.getCells()[2].value, isSelectedNode, 'cost'),
    ]);
  }

  /*Widget _buildTextCell(dynamic value, bool isSelected, String columnName) {
    String unit = columnName == 'energy' ? 'kWh' : '৳';
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value != null ? '${value.toStringAsFixed(2)} $unit' : '',
        style: TextStyle(
          color: (value != null && value > 0 ? Colors.black87 : Colors.grey),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12
        ),
      ),
    );
  }*/

  Widget _buildTextCell(dynamic value, bool isSelected, String columnName) {
    String unit = columnName == 'energy' ? 'kWh' : '৳';
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value != null
            ? columnName == 'energy'
            ? '${value.toStringAsFixed(2)} $unit'
            : '$unit${value.toStringAsFixed(2)}'
            : '',
        style: TextStyle(
          color: (value != null && value > 0 ? Colors.black87 : Colors.grey),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }

}

class ShedDataGridSource extends DataGridSource {
  List<DataGridRow> _formattedData = [];
  final List<String> shedNames;

  ShedDataGridSource(List<FormattedShedData> data, this.shedNames) {
    Map<String, Map<String, Map<String, String>>> pivotedData = {};
    Map<String, double> totalEnergyMap = {};
    Map<String, double> totalCostMap = {};

    for (var item in data) {
      if (!pivotedData.containsKey(item.date)) {
        pivotedData[item.date] = {};
      }
      pivotedData[item.date]![item.shed] = {
        'energy': item.totalEnergy.toStringAsFixed(2),
        'cost': '${item.totalCost.toStringAsFixed(0)}/${item.unitCost.toStringAsFixed(2)}',
      };

      totalEnergyMap[item.shed] = (totalEnergyMap[item.shed] ?? 0) + item.totalEnergy;
      totalCostMap[item.shed] = (totalCostMap[item.shed] ?? 0) + item.totalCost;
    }

    _formattedData = pivotedData.entries.map((entry) {
      List<DataGridCell> cells = [
        DataGridCell<String>(columnName: 'date', value: entry.key),
      ];

      for (var shed in shedNames) {
        cells.addAll([
          DataGridCell<String>(
            columnName: '${shed}_energy',
            value: entry.value[shed]?['energy'] ?? '0.00',
          ),
          DataGridCell<String>(
            columnName: '${shed}_cost',
            value: entry.value[shed]?['cost'] ?? '0/0.00',
          ),
        ]);
      }
      return DataGridRow(cells: cells);
    }).toList();

    List<DataGridCell> totalCells = [
      const DataGridCell<String>(columnName: 'date', value: 'Total'),
    ];
    for (var shed in shedNames) {
      double totalEnergy = totalEnergyMap[shed] ?? 0;
      double totalCost = totalCostMap[shed] ?? 0;
      double unitCost = totalEnergy != 0 ? totalCost / totalEnergy : 0;
      totalCells.addAll([
        DataGridCell<String>(
          columnName: '${shed}_energy',
          value: totalEnergy.toStringAsFixed(2),
        ),
        DataGridCell<String>(
          columnName: '${shed}_cost',
          value: '${totalCost.toStringAsFixed(0)}/${unitCost.toStringAsFixed(2)}',
        ),
      ]);
    }
    _formattedData.add(DataGridRow(cells: totalCells));
  }

  @override
  List<DataGridRow> get rows => _formattedData;

/*  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    bool isTotalRow = row.getCells().first.value == 'Total';
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((cell) {
          bool isCostCell = cell.columnName.endsWith('_cost');
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(4.0),
            color: isCostCell ? const Color(0xFFE0E1FF) : null, // Background color for cost cells
            child: Text(
              cell.columnName.endsWith('_energy')
                  ? '${cell.value} kWh'
                  : isCostCell
                  ? '৳${cell.value} '
                  : cell.value.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isCostCell ? const Color(0xFF04063E) : AppColors.secondaryTextColor, // Text color for cost cells
                fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
              ),
              softWrap: true,
              maxLines: 2,
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
        bool isCostCell = cell.columnName.endsWith('_cost');
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(4.0),
          color: isTotalRow
              ? const Color(0xFFE6F1FF)  // Background color for cost cells
              : (isOddRow)
              ? null // No background for odd rows (except Total row)
              : const Color(0xFFE0E1FF), // Background for even rows and Total row
          child: Text(
            cell.columnName.endsWith('_energy')
                ? '${cell.value} kWh'
                : isCostCell
                ? '৳${cell.value} '
                : cell.value.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isCostCell ? const Color(0xFF04063E) : AppColors.secondaryTextColor, // Text color for cost cells
              fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
            ),
            softWrap: true,
            maxLines: 2,
          ),
        );
      }).toList(),
    );
  }

}