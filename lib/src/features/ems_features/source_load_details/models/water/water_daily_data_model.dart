class WaterDailyDataModel {
  String? timedate;
  String? node;
  dynamic instantFlow;
  dynamic instantCost;
  dynamic totalWaterQuantity;

  WaterDailyDataModel(
      {this.timedate,
        this.node,
        this.instantFlow,
        this.instantCost,
        this.totalWaterQuantity});

  WaterDailyDataModel.fromJson(Map<String, dynamic> json) {
    timedate = json['timedate'];
    node = json['node'];
    instantFlow = json['instant_flow'];
    instantCost = json['instant_cost'];
    totalWaterQuantity = json['total_water_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timedate'] = timedate;
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['instant_cost'] = instantCost;
    data['total_water_quantity'] = totalWaterQuantity;
    return data;
  }
}
