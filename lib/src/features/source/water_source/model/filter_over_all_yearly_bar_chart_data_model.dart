// class FilterOverAllYearlyBarChartDataModel {
//   String? graphType;
//   List<OverAllYealyData>? data;
//   Percentages? percentages;
//   IndividualTotals? individualTotals;
//   IndividualTotalCost? individualTotalCost;
//
//   FilterOverAllYearlyBarChartDataModel(
//       {this.graphType, this.data, this.percentages, this.individualTotals,this.individualTotalCost});
//
//   FilterOverAllYearlyBarChartDataModel.fromJson(Map<String, dynamic> json) {
//     graphType = json['graph-type'];
//     if (json['data'] != null) {
//       data = <OverAllYealyData>[];
//       json['data'].forEach((v) {
//         data!.add(OverAllYealyData.fromJson(v));
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
// class OverAllYealyData {
//   int? id;
//   String? date;
//   String? node;
//   dynamic fuel;
//   dynamic energy;
//   dynamic cost;
//   dynamic powercutInMin;
//   dynamic countPowercuts;
//   String? nodeType;
//   dynamic energyMod;
//   dynamic costMod;
//   String? category;
//   dynamic runtime;
//
//   OverAllYealyData(
//       {this.id,
//         this.date,
//         this.node,
//         this.fuel,
//         this.energy,
//         this.cost,
//         this.powercutInMin,
//         this.countPowercuts,
//         this.nodeType,
//         this.energyMod,
//         this.costMod,
//         this.category,
//         this.runtime});
//
//   OverAllYealyData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     date = json['date'];
//     node = json['node'];
//     fuel = json['fuel'];
//     energy = json['energy'];
//     cost = json['cost'];
//     powercutInMin = json['powercut_in_min'];
//     countPowercuts = json['count_powercuts'];
//     nodeType = json['node_type'];
//     energyMod = json['energy_mod'];
//     costMod = json['cost_mod'];
//     category = json['category'];
//     runtime = json['runtime'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['date'] = date;
//     data['node'] = node;
//     data['fuel'] = fuel;
//     data['energy'] = energy;
//     data['cost'] = cost;
//     data['powercut_in_min'] = powercutInMin;
//     data['count_powercuts'] = countPowercuts;
//     data['node_type'] = nodeType;
//     data['energy_mod'] = energyMod;
//     data['cost_mod'] = costMod;
//     data['category'] = category;
//     data['runtime'] = runtime;
//     return data;
//   }
// }
//
// class Percentages {
//   dynamic solar;
//   dynamic grid;
//   dynamic dieselGenerator;
//
//   Percentages({this.solar, this.grid, this.dieselGenerator});
//
//   Percentages.fromJson(Map<String, dynamic> json) {
//     solar = json['Solar'];
//     grid = json['Grid'];
//     dieselGenerator = json['Diesel_Generator'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Solar'] = solar;
//     data['Grid'] = grid;
//     data['Diesel_Generator'] = dieselGenerator;
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
class FilterOverAllWaterYearlyBarChartDataModel {
  String? graphType;
  List<OverAllYearlyData>? data;
  Percentages? percentages;
  IndividualTotals? individualTotals;
  IndividualTotalCost? individualTotalCost;

  FilterOverAllWaterYearlyBarChartDataModel({
    this.graphType,
    this.data,
    this.percentages,
    this.individualTotals,
    this.individualTotalCost,
  });

  FilterOverAllWaterYearlyBarChartDataModel.fromJson(Map<String, dynamic> json) {
    graphType = json['graph-type'];
    if (json['data'] != null) {
      data = <OverAllYearlyData>[];
      json['data'].forEach((v) {
        data!.add(OverAllYearlyData.fromJson(v));
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

class OverAllYearlyData {
  int? id;
  String? date;
  String? node;
  dynamic instantFlow;
  dynamic cost;
  dynamic runtime;
  String? nodeType;
  String? category;
  dynamic volume;

  OverAllYearlyData({
    this.id,
    this.date,
    this.node,
    this.instantFlow,
    this.cost,
    this.runtime,
    this.nodeType,
    this.category,
    this.volume,
  });

  OverAllYearlyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    node = json['node'];
    instantFlow = json['instant_flow'];
    cost = json['cost'];
    runtime = json['runtime'];
    nodeType = json['node_type'];
    category = json['category'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['cost'] = cost;
    data['runtime'] = runtime;
    data['node_type'] = nodeType;
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