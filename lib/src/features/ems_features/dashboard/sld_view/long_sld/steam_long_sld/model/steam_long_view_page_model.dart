import 'package:flutter/cupertino.dart';
import 'dart:convert';

class SteamLongViewPageModel {
  final int id;
  final String nodeName;
  final String sourceType;
  final String category;
  final bool? mainBusbar;
  final String? machineType;
  final double? machineMaxPower;
  final String? deviceType;
  final String? meterModel;
  final String? connectionType;
  final List<String>? nodeId;
  final int? blockNo;
  final int? plcNo;
  final int? portNo;
  final int? meterNo;
  final int? ip3;
  final int? ip4UnitId;
  final double? aiMinValue;
  final double? aiMaxValue;
  final bool doCmd;
  final double? unitCost;
  final double? scalingFactor;
  final double height;
  final double width;
  final double positionX;
  final double positionY;
  final String shape;
  final List<Line> lines;
  final List<int> connectedWith;
  final String color;
  final String? icon;
  final String borderColor;
  final String? textColor;
  final double textSize;
  final String orientation;

  SteamLongViewPageModel({
    required this.id,
    required this.nodeName,
    required this.sourceType,
    required this.category,
    this.mainBusbar,
    this.machineType,
    this.machineMaxPower,
    this.deviceType,
    this.meterModel,
    this.connectionType,
    this.nodeId,
    this.blockNo,
    this.plcNo,
    this.portNo,
    this.meterNo,
    this.ip3,
    this.ip4UnitId,
    this.aiMinValue,
    this.aiMaxValue,
    required this.doCmd,
    this.unitCost,
    this.scalingFactor,
    required this.height,
    required this.width,
    required this.positionX,
    required this.positionY,
    required this.shape,
    required this.lines,
    required this.connectedWith,
    required this.color,
    this.icon,
    required this.borderColor,
    this.textColor,
    required this.textSize,
    required this.orientation,
  });

  factory SteamLongViewPageModel.fromJson(Map<String, dynamic> json) {
    if (json['position_x'] == null ||
        json['position_y'] == null ||
        json['width'] == null ||
        json['height'] == null) {
      debugPrint("Invalid node data: $json");
      throw Exception("Missing or invalid position/width/height in node data");
    }

    debugPrint('ViewPageModel: node_name=${json['node_name']}, '
        'source_type=${json['source_type']}, '
        'category=${json['category']}, '
        'shape=${json['shape']}, '
        'color=${json['color']}, '
        'border_color=${json['border_color']}, '
        'text_color=${json['text_color']}, '
        'text_size=${json['text_size']}, '
        'orientation=${json['orientation']}');

    try {
      return SteamLongViewPageModel(
        id: json['id'] as int,
        nodeName: json['node_name']?.toString() ?? '',
        sourceType: json['source_type']?.toString() ?? '',
        category: json['category']?.toString() ?? '',
        mainBusbar: json['main_busbar'] as bool?,
        machineType: json['machine_type']?.toString(),
        machineMaxPower: json['machine_max_power']?.toDouble(),
        deviceType: json['device_type']?.toString(),
        meterModel: json['meter_model']?.toString(),
        connectionType: json['connection_type']?.toString(),
        nodeId: json['node_id'] != null
            ? List<String>.from(json['node_id'])
            : null,
        blockNo: json['block_no'] as int?,
        plcNo: json['plc_no'] as int?,
        portNo: json['port_no'] as int?,
        meterNo: json['meter_no'] as int?,
        ip3: json['ip3'] as int?,
        ip4UnitId: json['ip4_unit_id'] as int?,
        aiMinValue: json['ai_min_value']?.toDouble(),
        aiMaxValue: json['ai_max_value']?.toDouble(),
        doCmd: json['do_cmd'] as bool? ?? false,
        unitCost: json['unit_cost']?.toDouble(),
        scalingFactor: json['scaling_factor']?.toDouble(),
        height: (json['height'] as num?)?.toDouble() ?? 100.0,
        width: (json['width'] as num?)?.toDouble() ?? 100.0,
        positionX: (json['position_x'] as num?)?.toDouble() ?? 0.0,
        positionY: (json['position_y'] as num?)?.toDouble() ?? 0.0,
        shape: json['shape']?.toString() ?? 'box',
        lines: List<Line>.from(
            json['lines']?.map((line) => Line.fromJson(line)) ?? []),
        connectedWith: List<int>.from(json['connected_with'] ?? []),
        color: json['color']?.toString() ?? '#FF0000',
        icon: json['icon']?.toString(),
        borderColor: json['border_color']?.toString() ?? '#FF0000',
        textColor: json['text_color']?.toString(),
        textSize: (json['text_size'] as num?)?.toDouble() ?? 12.0,
        orientation: json['orientation']?.toString() ?? 'horizontal',
      );
    } catch (e) {
      debugPrint('Error in ViewPageModel.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'node_name': nodeName,
    'source_type': sourceType,
    'category': category,
    'main_busbar': mainBusbar,
    'machine_type': machineType,
    'machine_max_power': machineMaxPower,
    'device_type': deviceType,
    'meter_model': meterModel,
    'connection_type': connectionType,
    'node_id': nodeId,
    'block_no': blockNo,
    'plc_no': plcNo,
    'port_no': portNo,
    'meter_no': meterNo,
    'ip3': ip3,
    'ip4_unit_id': ip4UnitId,
    'ai_min_value': aiMinValue,
    'ai_max_value': aiMaxValue,
    'do_cmd': doCmd,
    'unit_cost': unitCost,
    'scaling_factor': scalingFactor,
    'height': height,
    'width': width,
    'position_x': positionX,
    'position_y': positionY,
    'shape': shape,
    'lines': lines.map((line) => line.toJson()).toList(),
    'connected_with': connectedWith,
    'color': color,
    'icon': icon,
    'border_color': borderColor,
    'text_color': textColor,
    'text_size': textSize,
    'orientation': orientation,
  };
}

class Line {
  final String lineId;
  final List<Point> points;
  final int startItemId;
  final int endItemId;
  final int startEdgeIndex;
  final int endEdgeIndex;
  final String? lineColor;

  Line({
    required this.lineId,
    required this.points,
    required this.startItemId,
    required this.endItemId,
    required this.startEdgeIndex,
    required this.endEdgeIndex,
    this.lineColor,
  });

  factory Line.fromJson(Map<String, dynamic> json) {
    debugPrint('Line.fromJson: lineID=${json['lineID']}, lineColor=${json['lineColor']}');
    try {
      return Line(
        lineId: json['lineID']?.toString() ?? '',
        points: List<Point>.from(json['points']?.map((point) => Point.fromJson(point)) ?? []),
        startItemId: json['startItemId'] as int? ?? 0,
        endItemId: json['endItemId'] as int? ?? 0,
        startEdgeIndex: json['startEdgeIndex'] as int? ?? 0,
        endEdgeIndex: json['endEdgeIndex'] as int? ?? 0,
        lineColor: json['lineColor']?.toString(),
      );
    } catch (e) {
      debugPrint('Error in Line.fromJson: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'lineID': lineId,
    'points': points.map((point) => point.toJson()).toList(),
    'startItemId': startItemId,
    'endItemId': endItemId,
    'startEdgeIndex': startEdgeIndex,
    'endEdgeIndex': endEdgeIndex,
    'lineColor': lineColor,
  };
}

class Point {
  final double x;
  final double y;

  Point({
    required this.x,
    required this.y,
  });

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      x: (json['x'] as num?)?.toDouble() ?? 0.0,
      y: (json['y'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
  };
}
// LiveDataModel liveDataModelFromJson(String str) => LiveDataModel.fromJson(json.decode(str));
//
// String liveDataModelToJson(LiveDataModel data) => json.encode(data.toJson());

class SteamLiveDataModel {
  int? id;
  DateTime? timedate;
  String? node;
  double? power;
  double? voltage1;
  double? voltage2;
  double? voltage3;
  double? current1;
  double? current2;
  double? current3;
  double? frequency;
  double? powerFactor;
  double? cost;
  bool? sensorStatus;
  double? powerMod;
  double? costMod;
  double? importEnergy;
  double? exportEnergy;
  double? netEnergy;
  String? shape;         // Adding shape for distinguishing between different types
  String? sourceType;    // Adding sourceType to handle bus couplers and loops

  SteamLiveDataModel({
    this.id,
    this.timedate,
    this.node,
    this.power,
    this.voltage1,
    this.voltage2,
    this.voltage3,
    this.current1,
    this.current2,
    this.current3,
    this.frequency,
    this.powerFactor,
    this.cost,
    this.sensorStatus,
    this.powerMod,
    this.costMod,
    this.importEnergy,
    this.exportEnergy,
    this.netEnergy,
    this.shape,         // Initialize shape
    this.sourceType,    // Initialize sourceType
  });

  factory SteamLiveDataModel.fromJson(Map<String, dynamic> json) {
    return SteamLiveDataModel(
      id: json["id"] != null ? json["id"] as int : null,
      timedate: json["timedate"] != null ? DateTime.tryParse(json["timedate"]) : null,
      node: json["node"] != null ? json["node"] as String : null,
      power: json["power"]?.toDouble(),
      voltage1: json["voltage1"]?.toDouble(),
      voltage2: json["voltage2"]?.toDouble(),
      voltage3: json["voltage3"]?.toDouble(),
      current1: json["current1"]?.toDouble(),
      current2: json["current2"]?.toDouble(),
      current3: json["current3"]?.toDouble(),
      frequency: json["frequency"]?.toDouble(),
      powerFactor: json["power_factor"]?.toDouble(),
      cost: json["cost"]?.toDouble(),
      sensorStatus: json["sensor_status"] != null ? json["sensor_status"] as bool : null,
      powerMod: json["power_mod"]?.toDouble(),
      costMod: json["cost_mod"]?.toDouble(),
      importEnergy: json["import_energy"]?.toDouble(),
      exportEnergy: json["export_energy"]?.toDouble(),
      netEnergy: json["net_energy"]?.toDouble(),
      shape: json["shape"],               // Parse shape
      sourceType: json["source_type"],    // Parse sourceType
    );
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "timedate": timedate?.toIso8601String(),
    "node": node,
    "power": power,
    "voltage1": voltage1,
    "voltage2": voltage2,
    "voltage3": voltage3,
    "current1": current1,
    "current2": current2,
    "current3": current3,
    "frequency": frequency,
    "power_factor": powerFactor,
    "cost": cost,
    "sensor_status": sensorStatus,
    "power_mod": powerMod,
    "cost_mod": costMod,
    "import_energy": importEnergy,
    "export_energy": exportEnergy,
    "net_energy": netEnergy,
    "shape": shape,               // Add shape to JSON
    "source_type": sourceType,    // Add sourceType to JSON
  };
}




class PowerData {
  final double power;
  final double? instantFlow;
  final DateTime timedate;
  final String node;
  final bool sensorStatus;
  final String sourceType;
  final double? percentage;

  PowerData({
    required this.power,
    this.instantFlow,
    required this.timedate,
    required this.node,
    required this.sensorStatus,
    required this.sourceType,
    this.percentage,
  });

  factory PowerData.fromJson(Map<String, dynamic> json) {
    return PowerData(
      power: (json['power'] as num).toDouble(),
      instantFlow: json['instant_flow'] != null ? (json['instant_flow'] as num).toDouble() : null,
      timedate: DateTime.parse(json['timedate']),
      node: json['node'],
      sensorStatus: json['sensor_status'],
      sourceType: json['source_type'],
      percentage: json['percentage'] != null ? (json['percentage'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'power': power,
      'instant_flow': instantFlow,
      'timedate': timedate.toIso8601String(),
      'node': node,
      'sensor_status': sensorStatus,
      'source_type': sourceType,
      'percentage': percentage,
    };
  }

  static List<PowerData> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PowerData.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<PowerData> list) {
    return list.map((data) => data.toJson()).toList();
  }
}


class PfDataModel {
  final double powerFactor;
  final String nodeName;
  final bool sensorStatus;

  PfDataModel({
    required this.powerFactor,
    required this.nodeName,
    required this.sensorStatus,
  });

  factory PfDataModel.fromJson(Map<String, dynamic> json) {
    return PfDataModel(
      powerFactor: json['power_factor']?.toDouble() ?? 0.0,
      nodeName: json['node_name'] ?? '',
      sensorStatus: json['sensor_status'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'power_factor': powerFactor,
      'node_name': nodeName,
      'sensor_status': sensorStatus,
    };
  }
}