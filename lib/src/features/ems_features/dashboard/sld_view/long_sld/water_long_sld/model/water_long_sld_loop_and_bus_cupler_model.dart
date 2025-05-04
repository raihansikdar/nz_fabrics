class WaterLongSLDLoopAndBusCouplerModel {
  String? timedate;
  dynamic powerMeter;
  String? node;
  List<Lines>? lines;
  String? sourceType;

  WaterLongSLDLoopAndBusCouplerModel(
      {this.timedate, this.powerMeter, this.node, this.lines, this.sourceType});

  WaterLongSLDLoopAndBusCouplerModel.fromJson(Map<String, dynamic> json) {
    timedate = json['timedate'];
    powerMeter = json['power_meter'];
    node = json['node'];
    if (json['lines'] != null) {
      lines = <Lines>[];
      json['lines'].forEach((v) {
        lines!.add(new Lines.fromJson(v));
      });
    }
    sourceType = json['source_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timedate'] = timedate;
    data['power_meter'] = powerMeter;
    data['node'] = node;
    if (lines != null) {
      data['lines'] = lines!.map((v) => v.toJson()).toList();
    }
    data['source_type'] = sourceType;
    return data;
  }
}

class Lines {
  String? lineID;
  List<Points>? points;
  dynamic startItemId;
  dynamic endItemId;
  dynamic startEdgeIndex;
  dynamic endEdgeIndex;
  String? lineColor;

  Lines(
      {this.lineID,
        this.points,
        this.startItemId,
        this.endItemId,
        this.startEdgeIndex,
        this.endEdgeIndex,
        this.lineColor});

  Lines.fromJson(Map<String, dynamic> json) {
    lineID = json['lineID'];
    if (json['points'] != null) {
      points = <Points>[];
      json['points'].forEach((v) {
        points!.add(new Points.fromJson(v));
      });
    }
    startItemId = json['startItemId'];
    endItemId = json['endItemId'];
    startEdgeIndex = json['startEdgeIndex'];
    endEdgeIndex = json['endEdgeIndex'];
    lineColor = json['lineColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lineID'] = lineID;
    if (points != null) {
      data['points'] = points!.map((v) => v.toJson()).toList();
    }
    data['startItemId'] = startItemId;
    data['endItemId'] = endItemId;
    data['startEdgeIndex'] = startEdgeIndex;
    data['endEdgeIndex'] = endEdgeIndex;
    data['lineColor'] = lineColor;
    return data;
  }
}

class Points {
  dynamic x;
  dynamic y;

  Points({this.x, this.y});

  Points.fromJson(Map<String, dynamic> json) {
    x = json['x'];
    y = json['y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['x'] = x;
    data['y'] = y;
    return data;
  }
}
