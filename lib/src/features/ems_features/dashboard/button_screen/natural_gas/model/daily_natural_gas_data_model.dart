class DailyNaturalGasDataModel {
  String? node;
  double? instantFlow;
  double? cost;
  String? runtime;

  DailyNaturalGasDataModel({this.node, this.instantFlow, this.cost, this.runtime});

  DailyNaturalGasDataModel.fromJson(Map<String, dynamic> json) {
    node = json['node'];
    instantFlow = json['instant_flow'];
    cost = json['cost'];
    runtime = json['runtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['cost'] = cost;
    data['runtime'] = runtime;
    return data;
  }
}