class TodayTotalEnergyModel {
  double? totalEnergy;
  double? totalPower;
  double? totalEnergyPerSqft;

  TodayTotalEnergyModel({this.totalEnergy, this.totalPower, this.totalEnergyPerSqft});

  TodayTotalEnergyModel.fromJson(Map<String, dynamic> json) {
    totalEnergy = (json['total_energy'] as num?)?.toDouble();
    totalPower = (json['total_power'] as num?)?.toDouble();
    totalEnergyPerSqft = (json['total_energy_per_sqft'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_energy'] = totalEnergy;
    data['total_power'] = totalPower;
    data['total_energy_per_sqft'] = totalEnergyPerSqft;
    return data;
  }
}
