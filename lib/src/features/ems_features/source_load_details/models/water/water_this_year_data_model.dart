// class WaterThisYearDataModel {
//   dynamic instantFlow;
//   dynamic instantCost;
//
//   WaterThisYearDataModel({this.instantFlow, this.instantCost});
//
//   WaterThisYearDataModel.fromJson(Map<String, dynamic> json) {
//     instantFlow = json['instant_flow'];
//     instantCost = json['instant_cost'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['instant_flow'] = instantFlow;
//     data['instant_cost'] = instantCost;
//     return data;
//   }
// }


class WaterThisYearDataModel {
  dynamic volume;
  dynamic cost;

  WaterThisYearDataModel({this.volume, this.cost});

  WaterThisYearDataModel.fromJson(Map<String, dynamic> json) {
    volume = json['volume'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['volume'] = volume;
    data['cost'] = cost;
    return data;
  }
}
