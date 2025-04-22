import 'dart:convert';

List<PowerModel> powerFromJson(String str) => List<PowerModel>.from(json.decode(str).map((x) => PowerModel.fromJson(x)));

String powerToJson(List<PowerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PowerModel {
  int? id;
  String? nodeName;
  String? sourceType;
  String? sourceCategory;
  dynamic height;
  dynamic width;
  dynamic positionX;
  dynamic positionY;
  dynamic ip; // Updated this field to be a double instead of int if necessary
  List<Line>? lines;

  PowerModel({
    this.id,
    this.nodeName,
    this.sourceType,
    this.sourceCategory,
    this.height,
    this.width,
    this.positionX,
    this.positionY,
    this.ip, // Adjust the type to match the API response
    this.lines,
  });

  factory PowerModel.fromJson(Map<String, dynamic> json) => PowerModel(
    id: json['id'] as int?,
    nodeName: json['node_name'] as String?,
    sourceType: json['source_type'] as String?,
    sourceCategory: json['category'] as String?,
    height: (json['height'] as num?)?.toDouble(), // Safely parse as double
    width: (json['width'] as num?)?.toDouble(),
    positionX: (json['position_x'] as num?)?.toDouble(),
    positionY: (json['position_y'] as num?)?.toDouble(),
    ip: (json['ip'] as num?)?.toDouble(), // Ensure 'ip' is parsed as a double
    lines: (json['lines'] as List<dynamic>?)
        ?.map((e) => Line.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'node_name': nodeName,
    'source_type': sourceType,
    'category': sourceCategory,
    'height': height,
    'width': width,
    'position_x': positionX,
    'position_y': positionY,
    'ip': ip,
    'lines': lines?.map((line) => line.toJson()).toList(),
  };
}

class Line {
  String lineId;
  List<Point> points;
  int startItemId;
  int endItemId;
  int startEdgeIndex;
  int endEdgeIndex;

  Line({
    required this.lineId,
    required this.points,
    required this.startItemId,
    required this.endItemId,
    required this.startEdgeIndex,
    required this.endEdgeIndex,
  });

  factory Line.fromJson(Map<String, dynamic> json) => Line(
    lineId: json["lineID"],
    points: List<Point>.from(json["points"].map((x) => Point.fromJson(x))),
    startItemId: json["startItemId"],
    endItemId: json["endItemId"],
    startEdgeIndex: json["startEdgeIndex"],
    endEdgeIndex: json["endEdgeIndex"],
  );

  Map<String, dynamic> toJson() => {
    "lineID": lineId,
    "points": List<dynamic>.from(points.map((x) => x.toJson())),
    "startItemId": startItemId,
    "endItemId": endItemId,
    "startEdgeIndex": startEdgeIndex,
    "endEdgeIndex": endEdgeIndex,
  };
}

class Point {
  double x;
  double y;

  Point({
    required this.x,
    required this.y,
  });

  factory Point.fromJson(Map<String, dynamic> json) => Point(
    x: json["x"]?.toDouble(),
    y: json["y"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "x": x,
    "y": y,
  };
}

enum LoadCategory { ELECTRICITY, EMPTY, NATURAL_GAS, WATER }

final loadCategoryValues = EnumValues({
  "Electricity": LoadCategory.ELECTRICITY,
  "": LoadCategory.EMPTY,
  "Natural_Gas": LoadCategory.NATURAL_GAS,
  "Water": LoadCategory.WATER
});

enum Shape { BOX, BUS_BAR, CIRCLE }

final shapeValues = EnumValues({
  "box": Shape.BOX,
  "Bus_Bar": Shape.BUS_BAR,
  "circle": Shape.CIRCLE
});

enum SourceType { BUS_BAR, LOAD, SOURCE }

final sourceTypeValues = EnumValues({
  "Bus_Bar": SourceType.BUS_BAR,
  "Load": SourceType.LOAD,
  "Source": SourceType.SOURCE
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
    }
}