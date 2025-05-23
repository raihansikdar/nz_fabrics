
import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/table_model/filter_specific_table_model.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

class WaterSpecificNodeDataTable extends StatefulWidget {
  final FilterSpecificNodeTableModel tableData;
  final bool isLoading;

  const WaterSpecificNodeDataTable({
    Key? key,
    required this.tableData,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<WaterSpecificNodeDataTable> createState() => _WaterSpecificNodeDataTableState();
}

class _WaterSpecificNodeDataTableState extends State<WaterSpecificNodeDataTable> {
  late NodeDataSource _nodeDataSource;
  bool isSolarNode = false;

  bool _isSolarNode(FilterSpecificNodeTableModel data) {
    return data.data != null &&
        data.data!.isNotEmpty &&
        data.data![0].node != null &&
        data.data![0].node!.toLowerCase().contains("solar");
  }

  @override
  void initState() {
    super.initState();
    isSolarNode = _isSolarNode(widget.tableData);
    _nodeDataSource = NodeDataSource(
      tableData: widget.tableData,
      isSolarNode: isSolarNode,
    );
  }

  @override
  void didUpdateWidget(WaterSpecificNodeDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tableData != widget.tableData) {
      isSolarNode = _isSolarNode(widget.tableData);
      _nodeDataSource = NodeDataSource(
        tableData: widget.tableData,
        isSolarNode: isSolarNode,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Column(
        children: [
          Expanded(
            child: widget.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SfDataGridTheme(
              data: SfDataGridThemeData(
                headerColor: AppColors.primaryColor,
                frozenPaneLineColor: Colors.white70,
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: SfDataGrid(
                  source: _nodeDataSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  columns: _buildGridColumns(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<GridColumn> _buildGridColumns() {
    List<GridColumn> columns = [
      GridColumn(
        columnName: 'date',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.whiteTextColor,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'volume',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Volume',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.whiteTextColor,
            ),
          ),
        ),
      ),
      GridColumn(
        columnName: 'runtime',
        label: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Runtime',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.whiteTextColor,
            ),
          ),
        ),
      ),
    ];

    if (isSolarNode) {
      columns.add(
        GridColumn(
          columnName: 'revenue',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text(
              'Revenue',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.whiteTextColor,
              ),
            ),
          ),
        ),
      );
    } else {
      columns.add(
        GridColumn(
          columnName: 'cost',
          label: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: const Text(
              'Cost',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.whiteTextColor,
              ),
            ),
          ),
        ),
      );
    }

    return columns;
  }
}

class NodeDataSource extends DataGridSource {
  final FilterSpecificNodeTableModel tableData;
  final bool isSolarNode;
  List<DataGridRow> _dataGridRows = [];

  NodeDataSource({
    required this.tableData,
    this.isSolarNode = false,
  }) {
    _buildDataGridRows();
  }

  String _formatRuntime(int? runtime) {
    if (runtime == null) return 'N/A';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    return '${hours}h ${minutes}m';
  }

  void _buildDataGridRows() {
    _dataGridRows = tableData.data?.map<DataGridRow>((dataItem) {
      List<DataGridCell> cells = [
        DataGridCell<String>(
          columnName: 'date',
          value: _formatDate(dataItem.date),
        ),
        DataGridCell<String>(
          columnName: 'volume',
          value: dataItem.energyMod != null
              ? '${NumberFormat("#,##0.00").format(dataItem.energyMod)} m³'
              : '0.0',
        ),
        DataGridCell<String>(
          columnName: 'runtime',
          value: _formatRuntime(dataItem.runtime),
        ),
      ];

      if (isSolarNode) {
        final revenue = dataItem.cost != null ? dataItem.cost * 1.2 : null;
        cells.add(
          DataGridCell<String>(
            columnName: 'revenue',
            value: revenue != null
                ? '৳${NumberFormat("#,##0.00").format(revenue)}'
                : '0.0',
          ),
        );
      } else {
        cells.add(
          DataGridCell<String>(
            columnName: 'cost',
            value: dataItem.cost != null
                ? '৳${NumberFormat("#,##0.00").format(dataItem.cost)}'
                : '0.0',
          ),
        );
      }

      return DataGridRow(cells: cells);
    }).toList() ??
        [];

    final totalEnergy =
        tableData.data?.fold(0.0, (sum, item) => sum + (item.energyMod ?? 0.0)) ??
            0.0;
    final totalRuntime =
        tableData.data?.fold(0, (sum, item) => sum + (item.runtime ?? 0)) ?? 0;

    List<DataGridCell> totalCells = [
      const DataGridCell<String>(columnName: 'date', value: 'Total'),
      DataGridCell<String>(
          columnName: 'volume',
          value: '${NumberFormat("#,##0.00").format(totalEnergy)} m³'),
      DataGridCell<String>(
          columnName: 'runtime', value: _formatRuntime(totalRuntime)),
    ];

    if (isSolarNode) {
      final totalRevenue = tableData.data?.fold(0.0, (sum, item) {
        final itemRevenue = item.cost != null ? item.cost * 1.2 : 0.0;
        return sum + itemRevenue;
      }) ??
          0.0;
      totalCells.add(
        DataGridCell<String>(
            columnName: 'revenue',
            value: '৳${NumberFormat("#,##0.00").format(totalRevenue)}'),
      );
    } else {
      final totalCost =
          tableData.data?.fold(0.0, (sum, item) => sum + (item.cost ?? 0.0)) ??
              0.0;
      totalCells.add(
        DataGridCell<String>(
            columnName: 'cost',
            value: '৳${NumberFormat("#,##0.00").format(totalCost)}'),
      );
    }

    _dataGridRows.add(DataGridRow(cells: totalCells));
  }

  String _formatDate(String? date) {
    if (date == null) return 'N/A';
    try {
      final DateTime dateTime = DateTime.parse(date);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    bool isTotalRow = row.getCells()[0].value == 'Total';

    return DataGridRowAdapter(
      color: isTotalRow ? Colors.blue[50] : null,
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          alignment: dataGridCell.columnName == 'date'
              ? Alignment.center
              : Alignment.center,
          child: Text(
            dataGridCell.value ?? 'N/A',
            style: TextStyle(
              fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class NodeData {
  final int? id;
  final String? date;
  final String? node;
  final String? fuel;
  final dynamic volume;
  final dynamic cost;
  final int? runtime;
  final String? nodeType;
  final dynamic energyMod;
  final dynamic costMod;
  final String? category;

  NodeData({
    this.id,
    this.date,
    this.node,
    this.fuel,
    this.volume,
    this.cost,
    this.runtime,
    this.nodeType,
    this.energyMod,
    this.costMod,
    this.category,
  });

  factory NodeData.fromJson(Map<String, dynamic> json) {
    return NodeData(
      id: json['id'],
      date: json['date'],
      node: json['node'],
      fuel: json['fuel'],
      volume:
      json['volume'] != null ? double.parse(json['volume'].toString()) : null,
      cost: json['cost'] != null ? double.parse(json['cost'].toString()) : null,
      runtime: json['runtime'],
      nodeType: json['node_type'],
      energyMod: json['energy_mod'] != null
          ? double.parse(json['energy_mod'].toString())
          : null,
      costMod: json['cost_mod'] != null
          ? double.parse(json['cost_mod'].toString())
          : null,
      category: json['category'],
    );
  }
}