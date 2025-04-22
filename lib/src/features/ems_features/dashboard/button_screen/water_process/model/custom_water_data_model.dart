class CustomWaterDataModel {
  String? node;
  dynamic? instantFlow;
  double? cost;
  String? totalRuntime;

  CustomWaterDataModel({this.node, this.instantFlow, this.cost, this.totalRuntime});

  CustomWaterDataModel.fromJson(Map<String, dynamic> json) {
    node = json['node'];
    instantFlow = json['instant_flow'];
    cost = json['cost'];
    totalRuntime = json['total_runtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['cost'] = cost;
    data['total_runtime'] = totalRuntime;
    return data;
  }
}