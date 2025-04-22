class LayoutNodePositionModel {
  int? id;
  String? nodeName;
  dynamic positionX;
  dynamic positionY;
  dynamic height;
  dynamic width;
  String? pictureName;
  dynamic machineType;
  List<Lines>? lines;
  String? sourceType;

  LayoutNodePositionModel(
      {this.id,
        this.nodeName,
        this.positionX,
        this.positionY,
        this.height,
        this.width,
        this.pictureName,
        this.machineType,
        this.lines,
        this.sourceType});

  LayoutNodePositionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nodeName = json['node_name'];
    positionX = json['position_x'];
    positionY = json['position_y'];
    height = json['height'];
    width = json['width'];
    pictureName = json['picture_name'];
    machineType = json['machine_type'];
    if (json['lines'] != null) {
      lines = <Lines>[];
      json['lines'].forEach((v) {
        lines!.add(Lines.fromJson(v));
      });
    }
    sourceType = json['source_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['node_name'] = nodeName;
    data['position_x'] = positionX;
    data['position_y'] = positionY;
    data['height'] = height;
    data['width'] = width;
    data['picture_name'] = pictureName;
    data['machine_type'] = machineType;
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
  String? picture;
  dynamic startEdgeIndex;
  dynamic endEdgeIndex;
  String? lineColor;

  Lines(
      {this.lineID,
        this.points,
        this.startItemId,
        this.endItemId,
        this.picture,
        this.startEdgeIndex,
        this.endEdgeIndex,
        this.lineColor});

  Lines.fromJson(Map<String, dynamic> json) {
    lineID = json['lineID'];
    if (json['points'] != null) {
      points = <Points>[];
      json['points'].forEach((v) {
        points!.add(Points.fromJson(v));
      });
    }
    startItemId = json['startItemId'];
    endItemId = json['endItemId'];
    picture = json['picture'];
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
    data['picture'] = picture;
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
