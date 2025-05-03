// class FilterOverAllLineChartModel {
//   String? graphType;
//   List<OverAllLineData>? data;
//   Percentages? percentages;
//   IndividualTotals? individualTotals;
//   IndividualTotalCost? individualTotalCost;
//
//   FilterOverAllLineChartModel(
//       {this.graphType, this.data, this.percentages, this.individualTotals,this.individualTotalCost});
//
//   FilterOverAllLineChartModel.fromJson(Map<String, dynamic> json) {
//     graphType = json['graph-type'];
//     if (json['data'] != null) {
//       data = <OverAllLineData>[];
//       json['data'].forEach((v) {
//         data!.add(OverAllLineData.fromJson(v));
//       });
//     }
//     percentages = json['percentages'] != null
//         ? Percentages.fromJson(json['percentages'])
//         : null;
//     individualTotals = json['individual_totals'] != null
//         ? IndividualTotals.fromJson(json['individual_totals'])
//         : null;
//     individualTotalCost = json['individual_total_cost'] != null
//         ? IndividualTotalCost.fromJson(json['individual_total_cost'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['graph-type'] = graphType;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     if (percentages != null) {
//       data['percentages'] = percentages!.toJson();
//     }
//     if (individualTotals != null) {
//       data['individual_totals'] = individualTotals!.toJson();
//     }
//     if (individualTotalCost != null) {
//       data['individual_total_cost'] = individualTotalCost!.toJson();
//     }
//     return data;
//   }
// }
//
// class OverAllLineData {
//   int? id;
//   String? timedate;
//   String? node;
//   dynamic power;
//   dynamic cost;
//   String? type;
//   String? category;
//
//   OverAllLineData(
//       {this.id,
//         this.timedate,
//         this.node,
//         this.power,
//         this.cost,
//         this.type,
//         this.category});
//
//   OverAllLineData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     timedate = json['timedate'];
//     node = json['node'];
//     power = json['power'];
//     cost = json['cost'];
//     type = json['type'];
//     category = json['category'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['timedate'] = timedate;
//     data['node'] = node;
//     data['power'] = power;
//     data['cost'] = cost;
//     data['type'] = type;
//     data['category'] = category;
//     return data;
//   }
// }
//
// class Percentages {
//   dynamic dieselGenerator;
//   dynamic solar;
//   dynamic grid;
//
//   Percentages({this.dieselGenerator, this.solar, this.grid});
//
//   Percentages.fromJson(Map<String, dynamic> json) {
//     dieselGenerator = json['Diesel_Generator'];
//     solar = json['Solar'];
//     grid = json['Grid'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Diesel_Generator'] = dieselGenerator;
//     data['Solar'] = solar;
//     data['Grid'] = grid;
//     return data;
//   }
// }
//
// class IndividualTotals {
//   dynamic solar;
//   dynamic grid;
//   dynamic dieselGenerator;
//   dynamic total;
//
//   IndividualTotals({this.solar, this.grid, this.dieselGenerator, this.total});
//
//   IndividualTotals.fromJson(Map<String, dynamic> json) {
//     solar = json['Solar'];
//     grid = json['Grid'];
//     dieselGenerator = json['Diesel_Generator'];
//     total = json['Total'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Solar'] = solar;
//     data['Grid'] = grid;
//     data['Diesel_Generator'] = dieselGenerator;
//     data['Total'] = total;
//     return data;
//   }
// }
//
// class IndividualTotalCost {
//   dynamic solar;
//   dynamic grid;
//   dynamic dieselGenerator;
//   dynamic total;
//
//   IndividualTotalCost({this.solar, this.grid, this.dieselGenerator, this.total});
//
//   IndividualTotalCost.fromJson(Map<String, dynamic> json) {
//     solar = json['Solar'];
//     grid = json['Grid'];
//     dieselGenerator = json['Diesel_Generator'];
//     total = json['Total'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Solar'] = solar;
//     data['Grid'] = grid;
//     data['Diesel_Generator'] = dieselGenerator;
//     data['Total'] = total;
//     return data;
//   }
// }
class FilterOverAllLineChartModel {
  String? graphType;
  List<OverAllLineData>? data;
  Percentages? percentages;
  IndividualTotals? individualTotals;
  IndividualTotalCost? individualTotalCost;

  FilterOverAllLineChartModel({
    this.graphType,
    this.data,
    this.percentages,
    this.individualTotals,
    this.individualTotalCost,
  });

  FilterOverAllLineChartModel.fromJson(Map<String, dynamic> json) {
    graphType = json['graph-type'];
    if (json['data'] != null) {
      data = <OverAllLineData>[];
      json['data'].forEach((v) {
        data!.add(OverAllLineData.fromJson(v));
      });
    }
    percentages = json['percentages'] != null
        ? Percentages.fromJson(json['percentages'])
        : null;
    individualTotals = json['individual_totals'] != null
        ? IndividualTotals.fromJson(json['individual_totals'])
        : null;
    individualTotalCost = json['individual_total_cost'] != null
        ? IndividualTotalCost.fromJson(json['individual_total_cost'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['graph-type'] = graphType;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (percentages != null) {
      data['percentages'] = percentages!.toJson();
    }
    if (individualTotals != null) {
      data['individual_totals'] = individualTotals!.toJson();
    }
    if (individualTotalCost != null) {
      data['individual_total_cost'] = individualTotalCost!.toJson();
    }
    return data;
  }
}

class OverAllLineData {
  int? id;
  String? timedate;
  String? node;
  dynamic instantFlow;
  dynamic cost;
  String? type;
  String? category;
  dynamic volume;

  OverAllLineData({
    this.id,
    this.timedate,
    this.node,
    this.instantFlow,
    this.cost,
    this.type,
    this.category,
    this.volume,
  });

  OverAllLineData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timedate = json['timedate'];
    node = json['node'];
    instantFlow = json['instant_flow'];
    cost = json['cost'];
    type = json['type'];
    category = json['category'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['timedate'] = timedate;
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['cost'] = cost;
    data['type'] = type;
    data['category'] = category;
    data['volume'] = volume;
    return data;
  }
}

class Percentages {
  Map<String, dynamic>? values;

  Percentages({this.values});

  Percentages.fromJson(Map<String, dynamic> json) {
    values = json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = values ?? {};
    return data;
  }
}

class IndividualTotals {
  Map<String, dynamic>? values;

  IndividualTotals({this.values});

  IndividualTotals.fromJson(Map<String, dynamic> json) {
    values = json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = values ?? {};
    return data;
  }
}

class IndividualTotalCost {
  Map<String, dynamic>? values;

  IndividualTotalCost({this.values});

  IndividualTotalCost.fromJson(Map<String, dynamic> json) {
    values = json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = values ?? {};
    return data;
  }
}