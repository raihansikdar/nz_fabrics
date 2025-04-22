class ThisMonthDataModel {
  int? id;
  String? date;
  String? node;
  double? fuel;
  double? energy;
  double? cost;
  int? powercutInMin;
  int? countPowercuts;
  String? nodeType;
  double? energyMod;
  double? costMod;

  ThisMonthDataModel(
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
        this.costMod});

  ThisMonthDataModel.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
