class YearlyGasDataModel {
  String? node;
  int? totalFuel;
  int? totalEnergy;
  int? totalCost;
  String? totalRuntime;

  YearlyGasDataModel(
      {this.node,
        this.totalFuel,
        this.totalEnergy,
        this.totalCost,
        this.totalRuntime});

  YearlyGasDataModel.fromJson(Map<String, dynamic> json) {
    node = json['node'];
    totalFuel = json['total_fuel'];
    totalEnergy = json['total_energy'];
    totalCost = json['total_cost'];
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