import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nz_fabrics/src/common_widgets/empty_page_widget/empty_page_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/find_power_value_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/generators/generator_element_details_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/views/screens/power_and_energy/power_and_energy_element_details_screen.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SteamDetailsScreen extends StatefulWidget {
  const SteamDetailsScreen({super.key});

  @override
  State<SteamDetailsScreen> createState() => _SteamDetailsScreenState();
}

class _SteamDetailsScreenState extends State<SteamDetailsScreen> {
  late NodeDataSource _nodeDataSource;
  final Set<String> _expandedRows = {};
  final String token = '${AuthUtilityController.accessToken}';
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _nodeDataSource = NodeDataSource(context, [], _expandedRows, token);
    _fetchMainBusbars();
  }


  Future<void> _fetchMainBusbars() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true; // Set loading to true before fetching
        });
      }

      final response = await http.get(
        Uri.parse(Urls.getMainBusBarNamesUrl),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<TableNodeModel> nodes = (data['main_busbars'] as List)
            .map((busbar) => TableNodeModel(busbar, 'Main Busbar', true, false, []))
            .toList();

        for (var node in nodes) {
          await _fetchNodePowerAndUpdate(node);
          await _fetchNodeMonthlyData(node);
        }

        if (mounted) {
          setState(() {
            _nodeDataSource = NodeDataSource(context, nodes, _expandedRows, token);
            _isLoading = false; // Set loading to false after successful fetch
          });
        }
      } else {
        throw Exception('Failed to fetch main busbars');
      }
    } catch (e) {
      log('Error fetching main busbars: $e');
      if (mounted) {
        setState(() {
          _isLoading = false; // Set loading to false on error
        });
      }
    }
  }


  Future<void> _fetchNodePowerAndUpdate(TableNodeModel node) async {
    try {
      final response = await http.get(
        //Uri.parse('http://192.168.68.60:8081/react/get-live-data/${node.nodeName}/'),
        Uri.parse(Urls.getLiveDataUrl(node.nodeName)),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        node.power = data['power'] as double?;
        node.netEnergy = data['net_energy'] as double?;
        node.cost = data['cost'] != null ? data['cost'] as double : 0.0;
        log('Updated ${node.nodeName} with Power: ${node.power}, Energy: ${node.netEnergy}, Cost: ${node.cost}');
      } else {
        log('Failed to fetch data for ${node.nodeName}');
      }
    } catch (e) {
      log('Error fetching data for ${node.nodeName}: $e');
    }
  }


  Future<void> _fetchNodeMonthlyData(TableNodeModel node) async {

    try {
      final response = await http.get(
        // Uri.parse('http://192.168.68.60:8081/react/api/get-running-month-data/${node.nodeName}/'),
        Uri.parse(Urls.getRunningMonthDataUrl(node.nodeName)),
        headers: {'Authorization': token},
      );



      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        node.monthlyEnergy = data['monthly_energy'] as double?;
        node.monthlyCost = data['monthly_cost'] as double?;
      } else {
        log('Failed to fetch monthly data for ${node.nodeName}');
      }

    } catch (e) {
      log('Error fetching monthly data for ${node.nodeName}: $e');
    }

  }



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.sizeOf(context);
    double calculateTextHeight(String text, double fontSize, double maxWidth) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(fontSize: fontSize),
        ),
        textDirection: TextDirection.ltr,
        maxLines: null, // Allow multiline
      )..layout(maxWidth: maxWidth);

      return textPainter.size.height;
    }

    return LoaderOverlay(
      overlayWidgetBuilder: (context) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: SpinKitFadingCircle(
              color: AppColors.primaryColor,
              size: 50.0,
            ),
          ),
        );
      },

      child: _isLoading ? const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
            child: Center(child: SpinKitFadingCircle(
              color: AppColors.primaryColor,
              size: 50.0,
            ),)),
      ) :  _nodeDataSource.rows.isEmpty
          ?  EmptyPageWidget(size: size) // Show a loader while fetching data
          : Container(
        clipBehavior: Clip.antiAlias,
        // height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SfDataGrid(
          gridLinesVisibility: GridLinesVisibility.both,
          headerGridLinesVisibility: GridLinesVisibility.both,
          columnWidthMode: ColumnWidthMode.fill,
          source: _nodeDataSource,
          onQueryRowHeight: (RowHeightDetails details) {
            if (details.rowIndex == 0) {
              // Header row height
              return 50.0;
            }

            // Get the row data
            final DataGridRow row = _nodeDataSource.rows[details.rowIndex - 1];

            // Dynamically calculate the height required for each cell in the row
            double maxCellHeight = 0.0;
            for (final cell in row.getCells()) {
              final String? cellValue = cell.value?.toString();
              if (cellValue != null) {
                // Dynamically calculate height for each cell
                double cellHeight = calculateTextHeight(cellValue, 14.0, 200.0);
                maxCellHeight = maxCellHeight > cellHeight ? maxCellHeight : cellHeight;
              }
            }

            // Add padding or extra space to avoid overflow
            return maxCellHeight + 20.0; // Adding 20.0 as base padding
          },


          columns: <GridColumn>[
            GridColumn(
              columnName: 'node',
              width: 150,
              label: Container(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center,
                  color: AppColors.primaryColor,
                  child: const TextComponent(text: 'Node',color: AppColors.whiteTextColor,fontFamily: semiBoldFontFamily,fontSize: 15,)
                /*const Text(
                    'Node',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),*/
              ),
            ),
            GridColumn(
              columnName: 'dailyEnergyCost',
              label: Container(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center,
                  color: AppColors.primaryColor,
                  child:  const TextComponent(text: 'Today',color: AppColors.whiteTextColor,fontFamily: semiBoldFontFamily,fontSize: 15,)

              ),
            ),
            GridColumn(
              columnName: 'monthlyEnergyCost',
              label: Container(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.center,
                  color: AppColors.primaryColor,
                  child: const TextComponent(text: 'Monthly',color: AppColors.whiteTextColor,fontFamily: semiBoldFontFamily,fontSize: 13,)

              ),
            ),

          ],
        ),
      ),

    );
  }
}
class TableNodeModel {

  TableNodeModel(
      this.nodeName,
      this.category,
      this.droppable,
      this.childrenLoaded,
      this.children, {
        this.power,
        this.netEnergy,
        this.cost,
        this.monthlyEnergy,
        this.monthlyCost,
      });



  final String nodeName;
  final String category;
  final bool droppable;
  bool childrenLoaded;
  final List<TableNodeModel> children;
  double? power;
  double? netEnergy;
  double? cost;
  double? monthlyEnergy;
  double? monthlyCost;

}

class NodeDataSource extends DataGridSource {
  NodeDataSource(this.context, this.nodes, this.expandedRows, this.token) {
    buildDataGridRows();
  }

  final BuildContext context;
  final List<TableNodeModel> nodes;
  final Set<String> expandedRows;
  final String token;
  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRows() {
    dataGridRows = [];
    for (var node in nodes) {
      _addRow(node, 0);
    }
  }

  void _addRow(TableNodeModel node, int level) {
    // Avoid duplicates
    // if (dataGridRows.any((row) => row.getCells().any((cell) => cell.value == node.nodeName))) {
    //   return;
    // }
    if (dataGridRows.any((row) => row.getCells().any((cell) => cell.value == node.nodeName))) {
      return;
    }
    // Add the current node
    dataGridRows.add(DataGridRow(cells: [
      DataGridCell<String>(columnName: 'node', value: node.nodeName),
      DataGridCell<String>(
        columnName: 'dailyEnergyCost',
        value: '${node.netEnergy?.toStringAsFixed(2) ?? 'N/A'}\n${node.cost?.toStringAsFixed(2) ?? 'N/A'}',
      ),
      DataGridCell<String>(
        columnName: 'monthlyEnergyCost',
        value: '${node.monthlyEnergy?.toStringAsFixed(2) ?? 'N/A'}\n${node.monthlyCost?.toStringAsFixed(2) ?? 'N/A'}',
      ),
    ]));

    // Recursively add children if the row is expanded
    if (expandedRows.contains(node.nodeName)) {
      for (var child in node.children) {
        _addRow(child, level + 1);
      }
    }
  }


  int _getLevel(TableNodeModel? node, [int currentLevel = 0]) {
    if (node == null) return currentLevel;

    // Find parent recursively to calculate the level
    for (var parentNode in nodes) {
      if (parentNode.children.contains(node)) {
        return _getLevel(parentNode, currentLevel + 1);
      }
    }
    return currentLevel;
  }


// Add a variable to track the selected parent node
  String? selectedParentNode;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    String nodeName = row.getCells()[0].value.toString();
    bool isExpanded = expandedRows.contains(nodeName);
    TableNodeModel? targetNode = _findNode(nodeName);
    int level = _getLevel(targetNode);

    // Determine if the current node is a selected parent
    bool isSelectedParent = selectedParentNode == nodeName;

    return DataGridRowAdapter(
      cells: row.getCells().map((dataCell) {
        if (dataCell.columnName == 'node') {
          // Determine the type of icon to show
          Widget leadingIcon;
          if (targetNode != null && targetNode.droppable) {
            // Expand/Collapse icon for droppable nodes
            leadingIcon = Icon(
              isExpanded ? Icons.arrow_drop_down : Icons.arrow_right,
              size: 30,
              color: Colors.blue,
            );
          } else {
            // Bullet icon for non-droppable nodes
            leadingIcon = const Padding(
              padding: EdgeInsets.only(left: 20.0,right: 3),
              child: Icon(
                Icons.circle,
                size: 8,
                color: Colors.grey,
              ),
            );
          }

          return GestureDetector(
            onTap: () {
              if (targetNode != null) {
                if (targetNode.droppable) {
                  // Toggle expansion for droppable nodes
                  toggleExpanded(nodeName);
                  selectedParentNode = nodeName; // Update selected parent
                } else {
                  // Navigate to a new page for non-droppable nodes
                  if (targetNode.category == "Diesel_Generator" ||
                      targetNode.category == "Gas_Generator") {
                    Get.to(() => GetBuilder<FindPowerValueController>(
                        builder: (findPowerValueController) {
                          return GeneratorElementDetailsScreen(
                            elementName: targetNode.nodeName ?? '',
                            gaugeValue: findPowerValueController.electricityValues[targetNode.nodeName]
                                ?.power ??
                                0.00,
                            gaugeUnit: 'kW',
                            elementCategory: 'Power',
                          );
                        }
                    ));
                  } else if (targetNode.category == "Grid" ||
                      targetNode.category == "Electricity") {
                    Get.to(
                            () => GetBuilder<FindPowerValueController>(
                            builder: (findPowerValueController) {
                              return PowerAndEnergyElementDetailsScreen(
                                  elementName: targetNode.nodeName ?? '',
                                  gaugeValue: findPowerValueController.electricityValues[targetNode.nodeName]
                                      ?.power ??
                                      0.00,
                                  gaugeUnit: 'kW',
                                  elementCategory: 'Power',
                                  solarCategory: '');
                            }
                        ),
                        transition: Transition.rightToLeft);
                  } else if (targetNode.category == "Solar") {
                    Get.to(
                            () => GetBuilder<FindPowerValueController>(
                            builder: (findPowerValueController) {
                              return PowerAndEnergyElementDetailsScreen(
                                  elementName: targetNode.nodeName ?? '',
                                  gaugeValue: findPowerValueController.electricityValues[targetNode.nodeName]
                                      ?.power ??
                                      0.00,
                                  gaugeUnit: 'kW',
                                  elementCategory: 'Power',
                                  solarCategory: 'Solar');
                            }
                        ),
                        transition: Transition.rightToLeft);
                  }
                }
              }
            },
            child: Row(
              children: [
                // Add dynamic spacing for layers
                SizedBox(width: level * 10),
                leadingIcon, // Add the appropriate leading icon
                const SizedBox(width: 4), // Space between icon and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          targetNode?.nodeName ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelectedParent
                                ? Colors.green
                                : Colors.black, // Change color if selected
                          ),
                        ),
                      ),
                      if (targetNode?.power != null)
                        Text(
                          '${targetNode!.power!.toStringAsFixed(2)} kW',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (dataCell.columnName == 'dailyEnergyCost') {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Text(
                  ' ${targetNode?.netEnergy?.toStringAsFixed(2) ?? 'N/A'} kWh',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Text(
                '${targetNode?.cost?.toStringAsFixed(2) ?? 'N/A'} BDT',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          );
        } else if (dataCell.columnName == 'monthlyEnergyCost') {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Text(
                  '${targetNode?.monthlyEnergy?.toStringAsFixed(2) ?? 'N/A'} kWh',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Text(
                '${targetNode?.monthlyCost?.toStringAsFixed(2) ?? 'N/A'} BDT',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          );
        } else {
          // Render other columns without any icon
          return Text(
            dataCell.value?.toString() ?? '',
            style: const TextStyle(fontSize: 14),
          );
        }
      }).toList(),
    );
  }

  TableNodeModel? _findNode(String nodeName) {
    TableNodeModel? foundNode;
    void findNodeRecursively(TableNodeModel node) {
      if (node.nodeName == nodeName) {
        foundNode = node;
      } else {
        for (var child in node.children) {
          findNodeRecursively(child);
        }
      }
    }

    for (var node in nodes) {
      findNodeRecursively(node);
      if (foundNode != null) break;
    }

    return foundNode;
  }


  void toggleExpanded(String nodeName) async {
    TableNodeModel? targetNode = _findNode(nodeName);

    if (targetNode == null) return;

    context.loaderOverlay.show(); // Show loader when expansion starts

    try {
      if (expandedRows.contains(nodeName)) {
        // Collapse the row
        expandedRows.remove(nodeName);
      } else {
        // Expand the row
        expandedRows.add(nodeName);

        // Fetch children nodes if not already loaded
        if (!targetNode.childrenLoaded) {
          targetNode.childrenLoaded = true;
          List<TableNodeModel> children = await _fetchChildNodes(nodeName, nodeName);

          // Add children to the target node
          for (var child in children) {
            if (!targetNode.children
                .any((existingChild) => existingChild.nodeName == child.nodeName)) {
              targetNode.children.add(child);
            }
          }
        }
      }
    } catch (e) {
      log('Error during expansion: $e');
    } finally {
      context.loaderOverlay.hide(); // Hide loader after data is fetched
    }

    // Rebuild the rows and notify listeners
    buildDataGridRows();
    notifyListeners();
  }
  Future<List<TableNodeModel>> _fetchChildNodes(String parent, String node) async {
    try {
      final response = await http.get(
        Uri.parse('${Urls.baseUrl}/api/V2.1/get-children-name/?parent=$parent&node=$node'),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<TableNodeModel> children = (data['children'] as List)
            .map((child) => TableNodeModel(
          child['node_name'],
          child['category'],
          child['droppable'],
          false,
          [],
        ))
            .toList();

        // Fetch additional data for each child
        for (var child in children) {
          await _fetchNodePowerAndUpdate(child);
          await _fetchNodeMonthlyData(child);
        }

        return children;
      } else {
        throw Exception('Failed to fetch children');
      }
    } catch (e) {
      log('Error fetching children: $e');
      return [];
    }
  }
  Future<void> _fetchNodePowerAndUpdate(TableNodeModel node) async {
    try {
      final response = await http.get(
        //   Uri.parse('${Urls.baseUrl}/get-live-data/${node.nodeName}/'),
        Uri.parse(Urls.getLiveDataUrl(node.nodeName)),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        node.power = data['power'] as double?;
        node.netEnergy = data['net_energy'] as double?;
        node.cost = data['cost'] != null ? data['cost'] as double : 0.0;
      } else {
        log('Failed to fetch data for ${node.nodeName}');
      }
    } catch (e) {
      log('Error fetching data for ${node.nodeName}: $e');
    }
  }




  Future<void> _fetchNodeMonthlyData(TableNodeModel node) async {
    try {
      final response = await http.get(
        // Uri.parse('${Urls.baseUrl}/api/get-running-month-data/${node.nodeName}/'),
        Uri.parse(Urls.getRunningMonthDataUrl(node.nodeName)),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        node.monthlyEnergy = data['monthly_energy'] as double?;
        node.monthlyCost = data['monthly_cost'] as double?;
      } else {
        log('Failed to fetch monthly data for ${node.nodeName}');
      }
    } catch (e) {
      log('Error fetching monthly data for ${node.nodeName}: $e');
    }
  }

  Future<double?> _fetchNodePower(String nodeName) async {
    log('Fetching power for node: $nodeName');
    final response = await http.get(
      //Uri.parse('http://192.168.68.60:8081/react/get-live-data/$nodeName/'),
      Uri.parse(Urls.getLiveDataUrl(nodeName)),
      headers: {'Authorization': token},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      log('Power fetched for $nodeName: ${data['power']}');
      return data['power'] as double?;
    } else {
      log('Failed to fetch power for $nodeName');
      return null;
    }
  }

}


class NodeDetailPage extends StatelessWidget {
  final String nodeName;

  const NodeDetailPage({super.key, required this.nodeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Node Details'),
      ),
      body: Center(
        child: Text(
          'Details for Node: $nodeName',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}