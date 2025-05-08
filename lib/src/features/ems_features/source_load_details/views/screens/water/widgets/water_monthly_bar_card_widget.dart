

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/natural_gas/natural_gas_monthly_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/power_and_energy/monthly_data_model.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/water/water_monthly_data_model.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class WaterMonthlyDetailsBarChartWidget extends StatefulWidget {
  final String elementName;
  final String viewName;
  final String? solarCategory;
  final String screenName;
  final List<MonthlyDataModel>? monthlyDataModelList;
  final List<WaterMonthlyDataModel>? waterMonthlyDataModel;
  final List<NaturalGasMonthlyDataModel>? naturalGasMonthlyDataModel;

  const WaterMonthlyDetailsBarChartWidget({
    super.key,
    required this.elementName,
    required this.viewName,
    this.monthlyDataModelList,
    this.solarCategory,
    required this.screenName,
    this.waterMonthlyDataModel,
    this.naturalGasMonthlyDataModel,
  });

  @override
  State<WaterMonthlyDetailsBarChartWidget> createState() => _WaterMonthlyDetailsBarChartWidgetState();
}

class _WaterMonthlyDetailsBarChartWidgetState extends State<WaterMonthlyDetailsBarChartWidget> with AutomaticKeepAliveClientMixin {
  // Global static configuration
  static final _dateFormat = DateFormat('d');
  static final _legend = const Legend(isVisible: false);
  static final _trackballBehavior = TrackballBehavior(
    enable: true,
    tooltipAlignment: ChartAlignment.near,
    tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    activationMode: ActivationMode.singleTap,
  );
  static final _yAxis = NumericAxis(
    majorGridLines: const MajorGridLines(width: 1),
    numberFormat: NumberFormat.compact(),
    labelFormat: '{value}',
  );

  // Last day of month cache
  static final Map<int, DateTime> _lastDayCache = {};

  // Cached chart data and series
  dynamic _chartData;
  List<CartesianSeries>? _chartSeries;
  DateTimeAxis? _xAxis;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _prepareData();
  }

  @override
  void didUpdateWidget(WaterMonthlyDetailsBarChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.monthlyDataModelList != widget.monthlyDataModelList ||
        oldWidget.waterMonthlyDataModel != widget.waterMonthlyDataModel ||
        oldWidget.naturalGasMonthlyDataModel != widget.naturalGasMonthlyDataModel ||
        oldWidget.viewName != widget.viewName ||
        oldWidget.screenName != widget.screenName) {
      _prepareData();
    }
  }

  // Prepare all data once
  void _prepareData() {
    final now = DateTime.now();
    _chartData = _prepareChartData();
    _chartSeries = _getChartSeries(_chartData);
    _xAxis = _buildXAxis(now);
  }

  // Get last day with optimized caching
  DateTime _getLastDayOfMonth(DateTime now) {
    final monthKey = now.year * 100 + now.month; // Unique key for year+month
    return _lastDayCache.putIfAbsent(
        monthKey,
            () => DateTime(now.year, now.month + 1, 0)
    );
  }

  // Build X axis configuration
  DateTimeAxis _buildXAxis(DateTime now) {
    return DateTimeAxis(
      dateFormat: _dateFormat,
      majorGridLines: const MajorGridLines(width: 0),
      maximum: _getLastDayOfMonth(now),
      intervalType: DateTimeIntervalType.days,
      interval: 1,
      majorTickLines: MajorTickLines(size: widget.viewName == 'powerView' ? 4 : 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Return widget quickly if data isn't available
    if (_chartSeries == null || _chartSeries!.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Container(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: RepaintBoundary(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.height * k16TextSize),
          child: SfCartesianChart(
            trackballBehavior: _trackballBehavior,
            legend: _legend,
            primaryXAxis: _xAxis!,
            primaryYAxis: _yAxis,
            series: _chartSeries!,
          ),
        ),
      ),
    );
  }

  // Optimized data preparation with early returns
  dynamic _prepareChartData() {
    try {
      if (widget.screenName == 'waterScreen') {
        if (widget.waterMonthlyDataModel == null || widget.waterMonthlyDataModel!.isEmpty) return [];
        return widget.waterMonthlyDataModel!.map((data) {
          try {
            return WaterChartData(
              date: DateTime.parse(data.date ?? ''),
              instantFlow: data.instantFlow ?? 0.0,
              instantCost: data.cost ?? 0.0,
            );
          } catch (_) {
            return null;
          }
        }).whereType<WaterChartData>().toList();
      } else if (widget.screenName == 'naturalGasScreen') {
        if (widget.naturalGasMonthlyDataModel == null || widget.naturalGasMonthlyDataModel!.isEmpty) return [];
        return widget.naturalGasMonthlyDataModel!.map((data) {
          try {
            return NaturalGasChartData(
              date: DateTime.parse(data.date ?? ''),
              volume: data.volume ?? 0.0,
              cost: data.cost ?? 0.0,
            );
          } catch (_) {
            return null;
          }
        }).whereType<NaturalGasChartData>().toList();
      } else {
        if (widget.monthlyDataModelList == null || widget.monthlyDataModelList!.isEmpty) return [];
        return widget.monthlyDataModelList!.map((data) {
          try {
            return ChartData(
              date: DateTime.parse(data.date ?? ''),
              energy: data.energy ?? 0.0,
              cost: data.cost ?? 0.00,
            );
          } catch (_) {
            return null;
          }
        }).whereType<ChartData>().toList();
      }
    } catch (e) {
      return [];
    }
  }

  List<CartesianSeries> _getChartSeries(dynamic chartData) {
    if (chartData == null || chartData.isEmpty) return [];

    try {
      if (widget.screenName == 'waterScreen') {
        return <CartesianSeries>[
          ColumnSeries<WaterChartData, DateTime>(
            color: AppColors.primaryColor,
            dataSource: chartData,
            xValueMapper: (data, _) => data.date,
            yValueMapper: (data, _) => widget.viewName == 'powerView' ? data.instantFlow : data.instantCost,
            name: widget.viewName == 'powerView' ? 'Water Flow(m³/h)' : 'Cost (BDT)',
          ),
        ];
      } else if (widget.screenName == 'naturalGasScreen') {
        return <CartesianSeries>[
          ColumnSeries<NaturalGasChartData, DateTime>(
            color: AppColors.primaryColor,
            dataSource: chartData,
            xValueMapper: (data, _) => data.date,
            yValueMapper: (data, _) => widget.viewName == 'powerView' ? data.volume : data.cost,
            name: widget.viewName == 'powerView' ? 'Volume(cf)' : 'Cost (BDT)',
          ),
        ];
      } else {
        return <CartesianSeries>[
          ColumnSeries<ChartData, DateTime>(
            color: AppColors.primaryColor,
            dataSource: chartData,
            xValueMapper: (data, _) => data.date,
            yValueMapper: (data, _) => widget.viewName == 'powerView' ? data.energy : data.cost,
            name: widget.viewName == 'powerView'
                ? 'Energy(kWh)'
                : (widget.solarCategory == 'Solar' ? 'Revenue (BDT)' : 'Cost (BDT)'),
            width: widget.viewName == 'powerView' ? 1 : 0.7,
            spacing: widget.viewName == 'powerView' ? 0.2 : 0.1,
          ),
        ];
      }
    } catch (e) {
      return [];
    }
  }
}

// Optimized data classes with const constructors
class ChartData {
  final DateTime date;
  final double energy;
  final double cost;

  const ChartData({required this.date, required this.energy, required this.cost});
}

class WaterChartData {
  final DateTime date;
  final double instantFlow;
  final double instantCost;

  const WaterChartData({required this.date, required this.instantFlow, required this.instantCost});
}

class NaturalGasChartData {
  final DateTime date;
  final double volume;
  final double cost;

  const NaturalGasChartData({required this.date, required this.volume, required this.cost});
}