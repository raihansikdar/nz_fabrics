class NaturalGasYearlyDataModel {
  String? date;
  String? node;
  double? pressure;
  double? volume;
  double? cost;
  String? nodeType;

  NaturalGasYearlyDataModel(
      {this.date,
        this.node,
        this.pressure,
        this.volume,
        this.cost,
        this.nodeType});

  NaturalGasYearlyDataModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    node = json['node'];
    pressure = json['pressure'];
    volume = json['volume'];
    cost = json['cost'];
    nodeType = json['node_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['node'] = node;
    data['pressure'] = pressure;
    data['volume'] = volume;
    data['cost'] = cost;
    data['node_type'] = nodeType;
    return data;
  }
}
