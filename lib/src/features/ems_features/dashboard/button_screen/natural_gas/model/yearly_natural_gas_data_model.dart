class YearlyNaturalGasDataModel {
  String? node;
  dynamic instantFlow;
  dynamic cost;
  String? runtime;

  YearlyNaturalGasDataModel({this.node, this.instantFlow, this.cost, this.runtime});

  YearlyNaturalGasDataModel.fromJson(Map<String, dynamic> json) {
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