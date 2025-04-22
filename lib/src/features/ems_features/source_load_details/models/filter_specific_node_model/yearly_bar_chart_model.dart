class YearlyBarChartModel {
  String? graphType;
  List<YearlyBarChartData>? data;

  YearlyBarChartModel({this.graphType, this.data});

  YearlyBarChartModel.fromJson(Map<String, dynamic> json) {
    graphType = json['graph-type'];
    if (json['data'] != null) {
      data = <YearlyBarChartData>[];
      json['data'].forEach((v) {
        data!.add(YearlyBarChartData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['graph-type'] = graphType;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class YearlyBarChartData {
  int? id;
  String? date;
  String? node;
  dynamic fuel;
  dynamic energy;
  dynamic cost;
  dynamic powercutInMin;
  dynamic countPowercuts;
  String? nodeType;
  dynamic energyMod;
  dynamic costMod;
  String? category;
  dynamic runtime;

  YearlyBarChartData(
      {this.id,
        this.date,
        this.node,
        this.fuel,
        this.energy,
        this.cost,
        this.powercutInMin,
        this.countPowercuts,
        this.nodeType,
        this.energyMod,
        this.costMod,
        this.category,
        this.runtime});

  YearlyBarChartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    node = json['node'];
    fuel = json['fuel'];
    energy = json['energy'];
    cost = json['cost'];
    powercutInMin = json['powercut_in_min'];
    countPowercuts = json['count_powercuts'];
    nodeType = json['node_type'];
    energyMod = json['energy_mod'];
    costMod = json['cost_mod'];
    category = json['category'];
    runtime = json['runtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['node'] = node;
    data['fuel'] = fuel;
    data['energy'] = energy;
    data['cost'] = cost;
    data['powercut_in_min'] = powercutInMin;
    data['count_powercuts'] = countPowercuts;
    data['node_type'] = nodeType;
    data['energy_mod'] = energyMod;
    data['cost_mod'] = costMod;
    data['category'] = category;
    data['runtime'] = runtime;
    return data;
  }
}
