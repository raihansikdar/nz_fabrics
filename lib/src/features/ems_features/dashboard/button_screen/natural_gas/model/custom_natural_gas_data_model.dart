class CustomNaturalGasDataModel {
  String? node;
  double? pressure;
  double? cost;
  String? totalRuntime;

  CustomNaturalGasDataModel({this.node, this.pressure, this.cost, this.totalRuntime});

  CustomNaturalGasDataModel.fromJson(Map<String, dynamic> json) {
    node = json['node'];
    pressure = json['pressure'];
    cost = json['cost'];
    totalRuntime = json['total_runtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node'] = node;
    data['pressure'] = pressure;
    data['cost'] = cost;
    data['total_runtime'] = totalRuntime;
    return data;
  }
}