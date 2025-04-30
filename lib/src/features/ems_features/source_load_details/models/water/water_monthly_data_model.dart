class WaterMonthlyDataModel {
  String? date;
  String? node;
  dynamic instantFlow;
  dynamic cost;
  dynamic runtime;
  dynamic nodeType;
  dynamic category;
  dynamic volume;

  WaterMonthlyDataModel(
      {this.date,
        this.node,
        this.instantFlow,
        this.cost,
        this.runtime,
        this.nodeType,
        this.category,
        this.volume});

  WaterMonthlyDataModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    node = json['node'];
    instantFlow = json['instant_flow'];
    cost = json['cost'];
    runtime = json['runtime'];
    nodeType = json['node_type'];
    category = json['category'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['cost'] = cost;
    data['runtime'] = runtime;
    data['node_type'] = nodeType;
    data['category'] = category;
    data['volume'] = volume;
    return data;
  }
}
