// class WaterYearlyDataModel {
//   String? date;
//   String? node;
//   dynamic instantFlow;
//   dynamic instantCost;
//   dynamic totalWaterQuantity;
//   String? nodeType;
//
//   WaterYearlyDataModel(
//       {this.date,
//         this.node,
//         this.instantFlow,
//         this.instantCost,
//         this.totalWaterQuantity,
//         this.nodeType});
//
//   WaterYearlyDataModel.fromJson(Map<String, dynamic> json) {
//     date = json['date'];
//     node = json['node'];
//     instantFlow = json['instant_flow'];
//     instantCost = json['instant_cost'];
//     totalWaterQuantity = json['total_water_quantity'];
//     nodeType = json['node_type'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['date'] = date;
//     data['node'] = node;
//     data['instant_flow'] = instantFlow;
//     data['instant_cost'] = instantCost;
//     data['total_water_quantity'] = totalWaterQuantity;
//     data['node_type'] = nodeType;
//     return data;
//   }
// }


class WaterYearlyDataModel {
  String? date;
  String? node;
  dynamic instantFlow;
  dynamic cost;
  dynamic nodeType;
  dynamic category;
  dynamic volume;

  WaterYearlyDataModel(
      {this.date,
        this.node,
        this.instantFlow,
        this.cost,
        this.nodeType,
        this.category,
        this.volume});

  WaterYearlyDataModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    node = json['node'];
    instantFlow = json['instant_flow'];
    cost = json['cost'];
    nodeType = json['node_type'];
    category = json['category'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['cost'] = cost;
    data['node_type'] = nodeType;
    data['category'] = category;
    data['volume'] = volume;
    return data;
  }
}
