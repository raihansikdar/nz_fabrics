class CustomDieselDataModel {
  String? node;
  double? totalFuel;
  double? totalEnergy;
  double? totalCost;
  String? totalRuntime;

  CustomDieselDataModel(
      {this.node,
        this.totalFuel,
        this.totalEnergy,
        this.totalCost,
        this.totalRuntime});

  CustomDieselDataModel.fromJson(Map<String, dynamic> json) {
    node = json['node'];
    totalFuel = (json['total_fuel'] as num?)?.toDouble();
    totalEnergy = (json['total_energy'] as num?)?.toDouble();
    totalCost = (json['total_cost'] as num?)?.toDouble();
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
