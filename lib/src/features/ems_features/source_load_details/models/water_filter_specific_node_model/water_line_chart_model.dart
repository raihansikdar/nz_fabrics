class WaterLineChartModel {
  String? graphType;
  List<WaterLineData>? data;

  WaterLineChartModel({this.graphType, this.data});

  WaterLineChartModel.fromJson(Map<String, dynamic> json) {
    graphType = json['graph-type'];
    if (json['data'] != null) {
      data = <WaterLineData>[];
      json['data'].forEach((v) {
        data!.add(WaterLineData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['graph-type'] = graphType;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WaterLineData {
  int? id;
  String? timedate;
  String? node;
  dynamic instantFlow;
  dynamic cost;
  String? type;
  String? category;

  WaterLineData(
      {this.id,
        this.timedate,
        this.node,
        this.instantFlow,
        this.cost,
        this.type,
        this.category});

  WaterLineData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timedate = json['timedate'];
    node = json['node'];
    instantFlow = json['instant_flow'];
    cost = json['cost'];
    type = json['type'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['timedate'] = timedate;
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['cost'] = cost;
    data['type'] = type;
    data['category'] = category;
    return data;
  }
}
