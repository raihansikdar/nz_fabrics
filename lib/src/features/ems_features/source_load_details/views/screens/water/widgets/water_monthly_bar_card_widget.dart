import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/models/water/water_monthly_data_model.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class WaterMonthlyDetailsBarChartWidget extends StatefulWidget {
  final String elementName;
  final String viewName;
  final String screenName;
  final List<WaterMonthlyDataModel>? waterMonthlyDataModel;

  const WaterMonthlyDetailsBarChartWidget({
    super.key,
    required this.elementName,
    required this.viewName,
    required this.screenName,
    this.waterMonthlyDataModel,
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
  List<WaterChartData>? _chartData;
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
    if (oldWidget.waterMonthlyDataModel != widget.waterMonthlyDataModel ||
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
            () => DateTime(now.year, now.month + 1, 0));
  }

  // Build X axis configuration
  DateTimeAxis _buildXAxis(DateTime now) {
    final lastDay = _getLastDayOfMonth(now);
    return DateTimeAxis(
      dateFormat: _dateFormat,
      majorGridLines: const MajorGridLines(width: 0),
      minimum: DateTime(now.year, now.month, 1), // Start from 1st of the month
      maximum: lastDay, // End at last day of the month
      intervalType: DateTimeIntervalType.days,
      interval: 1,
      majorTickLines: MajorTickLines(size: widget.viewName == 'powerView' ? 4 : 0),
    );
  }

  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
      enableDoubleTapZooming:true,
      );


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
            zoomPanBehavior: _zoomPanBehavior,
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
  List<WaterChartData> _prepareChartData() {
    try {
      if (widget.screenName != 'waterScreen') {
        return _generateEmptyMonthData();
      }

      final now = DateTime.now();
      final lastDay = _getLastDayOfMonth(now);
      final daysInMonth = lastDay.day;
      final List<WaterChartData> chartData = [];

      // Initialize data for all days in the month with zero values
      for (int day = 1; day <= daysInMonth; day++) {
        chartData.add(WaterChartData(
          date: DateTime(now.year, now.month, day),
          instantFlow: 0.0,
          instantCost: 0.0,
        ));
      }

      // Update with API data if available
      if (widget.waterMonthlyDataModel != null && widget.waterMonthlyDataModel!.isNotEmpty) {
        for (var data in widget.waterMonthlyDataModel!) {
          try {
            final date = DateTime.parse(data.date ?? '');
            if (date.month == now.month && date.year == now.year && date.day >= 1 && date.day <= daysInMonth) {
              chartData[date.day - 1] = WaterChartData(
                date: date,
                instantFlow: data.instantFlow ?? 0.0,
                instantCost: data.cost ?? 0.0,
              );
            }
          } catch (_) {
            // Skip invalid data
          }
        }
      }

      return chartData;
    } catch (e) {
      return _generateEmptyMonthData();
    }
  }

  // Generate empty data for the entire month
  List<WaterChartData> _generateEmptyMonthData() {
    final now = DateTime.now();
    final lastDay = _getLastDayOfMonth(now);
    final daysInMonth = lastDay.day;
    return List.generate(
      daysInMonth,
          (index) => WaterChartData(
        date: DateTime(now.year, now.month, index + 1),
        instantFlow: 0.0,
        instantCost: 0.0,
      ),
    );
  }

  List<CartesianSeries> _getChartSeries(List<WaterChartData>? chartData) {
    if (chartData == null || chartData.isEmpty) return [];

    try {
      return <CartesianSeries>[
        ColumnSeries<WaterChartData, DateTime>(
          color: AppColors.primaryColor,
          dataSource: chartData,
          xValueMapper: (data, _) => data.date,
          yValueMapper: (data, _) => widget.viewName == 'powerView' ? data.instantFlow : data.instantCost,
          name: widget.viewName == 'powerView' ? 'Water Flow(m³)' : 'Cost (BDT)',
          // Ensure bars are visible even for zero values
          width: 0.8,
          spacing: 0.1,
          emptyPointSettings: EmptyPointSettings(
            mode: EmptyPointMode.zero,
          ),
        ),
      ];
    } catch (e) {
      return [];
    }
  }
}

// Optimized data class with const constructor
class WaterChartData {
  final DateTime date;
  final double instantFlow;
  final double instantCost;

  const WaterChartData({
  required this.date,
  required this.instantFlow,
  required this.instantCost,
 });
}