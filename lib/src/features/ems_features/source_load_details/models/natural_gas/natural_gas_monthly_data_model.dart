class NaturalGasMonthlyDataModel {
  String? date;
  String? node;
  double? pressure;
  double? volume;
  double? cost;
  int? runtime;
  String? nodeType;

  NaturalGasMonthlyDataModel(
      {this.date,
        this.node,
        this.pressure,
        this.volume,
        this.cost,
        this.runtime,
        this.nodeType});

  NaturalGasMonthlyDataModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    node = json['node'];
    pressure = json['pressure'];
    volume = json['volume'];
    cost = json['cost'];
    runtime = json['runtime'];
    nodeType = json['node_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['node'] = node;
    data['pressure'] = pressure;
    data['volume'] = volume;
    data['cost'] = cost;
    data['runtime'] = runtime;
    data['node_type'] = nodeType;
    return data;
  }
}
