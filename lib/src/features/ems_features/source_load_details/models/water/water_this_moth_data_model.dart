class WaterThisMonthDataModel {
  String? date;
  String? node;
  dynamic instantFlow;
  dynamic cost;
  dynamic nodeType;
  dynamic category;
  dynamic volume;

  WaterThisMonthDataModel(
      {this.date,
        this.node,
        this.instantFlow,
        this.cost,
        this.nodeType,
        this.category,
        this.volume});

  WaterThisMonthDataModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    node = json['node'];
    instantFlow = json['volume'];
    cost = json['cost'];
    nodeType = json['node_type'];
    category = json['category'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['node'] = node;
    data['volume'] = instantFlow;
    data['cost'] = cost;
    data['node_type'] = nodeType;
    data['category'] = category;
    data['volume'] = volume;
    return data;
  }
}
