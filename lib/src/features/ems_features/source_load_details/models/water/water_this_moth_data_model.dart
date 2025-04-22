class WaterThisMonthDataModel {
  String? date;
  String? node;
  dynamic instantFlow;
  dynamic instantCost;
  dynamic totalWaterQuantity;
  String? nodeType;

  WaterThisMonthDataModel(
      {this.date,
        this.node,
        this.instantFlow,
        this.instantCost,
        this.totalWaterQuantity,
        this.nodeType});

  WaterThisMonthDataModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    node = json['node'];
    instantFlow = json['instant_flow'];
    instantCost = json['instant_cost'];
    totalWaterQuantity = json['total_water_quantity'];
    nodeType = json['node_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['instant_cost'] = instantCost;
    data['total_water_quantity'] = totalWaterQuantity;
    data['node_type'] = nodeType;
    return data;
  }
}
