class YearlyDieselDataModel {
  String? node;
  double? totalFuel;
  double? totalEnergy;
  double? totalCost;
  String? totalRuntime;

  YearlyDieselDataModel({
    this.node,
    this.totalFuel,
    this.totalEnergy,
    this.totalCost,
    this.totalRuntime,
  });

  YearlyDieselDataModel.fromJson(Map<String, dynamic> json) {
    node = json['node'];
    totalFuel = (json['total_fuel'] is int)
        ? (json['total_fuel'] as int).toDouble()
        : json['total_fuel'] as double?;
    totalEnergy = (json['total_energy'] is int)
        ? (json['total_energy'] as int).toDouble()
        : json['total_energy'] as double?;
    totalCost = (json['total_cost'] is int)
        ? (json['total_cost'] as int).toDouble()
        : json['total_cost'] as double?;
    totalRuntime = json['total_runtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node'] = node;
    data['total_fuel'] = totalFuel;
    data['total_energy'] = totalEnergy;
    data['total_cost'] = totalCost;
    data['total_runtime'] = totalRuntime;
    return data;
  }
}
