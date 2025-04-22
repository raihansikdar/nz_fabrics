class NaturalGasDailyDataModel {
  String? timedate;
  String? node;
  int? instantFlow;
  int? pressure;
  int? cost;

  NaturalGasDailyDataModel({this.timedate, this.node, this.instantFlow, this.pressure, this.cost});

  NaturalGasDailyDataModel.fromJson(Map<String, dynamic> json) {
    timedate = json['timedate'];
    node = json['node'];
    instantFlow = json['instant_flow'];
    pressure = json['pressure'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timedate'] = timedate;
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['pressure'] = pressure;
    data['cost'] = cost;
    return data;
  }
}