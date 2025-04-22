class DailyAnalysisProFilterDgrDataModel {
  String? graphType;
  List<DailyDataModel>? data;

  DailyAnalysisProFilterDgrDataModel({this.graphType, this.data});

  DailyAnalysisProFilterDgrDataModel.fromJson(Map<String, dynamic> json) {
    graphType = json['graph-type'];
    if (json['data'] != null) {
      data = <DailyDataModel>[];
      json['data'].forEach((v) {
        data!.add(DailyDataModel.fromJson(v));
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

class DailyDataModel {
  int? id;
  String? timedate;
  String? node;
  dynamic power;
  dynamic cost;
  String? type;
  String? category;

  DailyDataModel(
      {this.id,
        this.timedate,
        this.node,
        this.power,
        this.cost,
        this.type,
        this.category});

  DailyDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timedate = json['timedate'];
    node = json['node'];
    power = json['power'];
    cost = json['cost'];
    type = json['type'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['timedate'] = timedate;
    data['node'] = node;
    data['power'] = power;
    data['cost'] = cost;
    data['type'] = type;
    data['category'] = category;
    return data;
  }
}
