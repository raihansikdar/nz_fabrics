class WaterThisYearDataModel {
  dynamic instantFlow;
  dynamic instantCost;

  WaterThisYearDataModel({this.instantFlow, this.instantCost});

  WaterThisYearDataModel.fromJson(Map<String, dynamic> json) {
    instantFlow = json['instant_flow'];
    instantCost = json['instant_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instant_flow'] = instantFlow;
    data['instant_cost'] = instantCost;
    return data;
  }
}
