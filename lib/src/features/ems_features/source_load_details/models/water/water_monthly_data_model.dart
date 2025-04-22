class WaterMonthlyDataModel {
  String? date;
  String? node;
  dynamic instantFlow;
  dynamic instantCost;
  dynamic totalWaterQuantity;
  int? runtime;
  String? nodeType;

  WaterMonthlyDataModel(
      {this.date,
        this.node,
        this.instantFlow,
        this.instantCost,
        this.totalWaterQuantity,
        this.runtime,
        this.nodeType});

  WaterMonthlyDataModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    node = json['node'];
    instantFlow = json['instant_flow'];
    instantCost = json['instant_cost'];
    totalWaterQuantity = json['total_water_quantity'];
    runtime = json['runtime'];
    nodeType = json['node_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['instant_cost'] = instantCost;
    data['total_water_quantity'] = totalWaterQuantity;
    data['runtime'] = runtime;
    data['node_type'] = nodeType;
    return data;
  }
}
