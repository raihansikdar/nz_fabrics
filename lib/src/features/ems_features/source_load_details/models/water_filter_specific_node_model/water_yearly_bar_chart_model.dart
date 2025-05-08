class WaterYearlyBarChartModel {
  String? graphType;
  List<WaterYearlyBarChartData>? data;

  WaterYearlyBarChartModel({this.graphType, this.data});

  WaterYearlyBarChartModel.fromJson(Map<String, dynamic> json) {
    graphType = json['graph-type'];
    if (json['data'] != null) {
      data = <WaterYearlyBarChartData>[];
      json['data'].forEach((v) {
        data!.add(WaterYearlyBarChartData.fromJson(v));
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

class WaterYearlyBarChartData {
  int? id;
  String? date;
  String? node;
  dynamic fuel;
  dynamic volume;
  dynamic cost;
  dynamic powercutInMin;
  dynamic countPowercuts;
  String? nodeType;
  dynamic energyMod;
  dynamic costMod;
  String? category;
  dynamic runtime;

  WaterYearlyBarChartData(
      {this.id,
        this.date,
        this.node,
        this.fuel,
        this.volume,
        this.cost,
        this.powercutInMin,
        this.countPowercuts,
        this.nodeType,
        this.energyMod,
        this.costMod,
        this.category,
        this.runtime});

  WaterYearlyBarChartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    node = json['node'];
    fuel = json['fuel'];
    volume = json['volume'];
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
    data['volume'] = volume;
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
