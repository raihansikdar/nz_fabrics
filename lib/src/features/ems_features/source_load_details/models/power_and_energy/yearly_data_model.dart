class YearlyDataModel {
  int? id;
  String? date;
  String? node;
  dynamic fuel;
  double? energy;
  double? cost;
  int? powercutInMin;
  int? countPowercuts;
  String? nodeType;
  dynamic energyMod;
  dynamic costMod;

  YearlyDataModel({
    this.id,
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
  });

  factory YearlyDataModel.fromJson(Map<String, dynamic> json) {
    return YearlyDataModel(
      id: json['id'],
      date: json['date'],
      node: json['node'],
      fuel: json['fuel'],
      energy: (json['energy'] as num?)?.toDouble(),
      cost: (json['cost'] as num?)?.toDouble(),
      powercutInMin: json['powercut_in_min'],
      countPowercuts: json['count_powercuts'],
      nodeType: json['node_type'],
      energyMod: json['energy_mod'],
      costMod: json['cost_mod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'node': node,
      'fuel': fuel,
      'energy': energy,
      'cost': cost,
      'powercut_in_min': powercutInMin,
      'count_powercuts': countPowercuts,
      'node_type': nodeType,
      'energy_mod': energyMod,
      'cost_mod': costMod,
    };
  }
}