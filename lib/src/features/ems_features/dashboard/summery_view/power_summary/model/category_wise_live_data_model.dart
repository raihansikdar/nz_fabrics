class CategoryWiseLiveDataModel {
  String? category;
  dynamic totalPower;
  dynamic totalNetEnergy;
  dynamic totalCost;
  dynamic powerPercentage;

  CategoryWiseLiveDataModel(
      {this.category,
        this.totalPower,
        this.totalNetEnergy,
        this.totalCost,
        this.powerPercentage});

  CategoryWiseLiveDataModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    totalPower = json['total_power'];
    totalNetEnergy = json['total_net_energy'];
    totalCost = json['total_cost'];
    powerPercentage = json['power_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['total_power'] = totalPower;
    data['total_net_energy'] = totalNetEnergy;
    data['total_cost'] = totalCost;
    data['power_percentage'] = powerPercentage;
    return data;
  }
}
