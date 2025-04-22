class ThisYearDataModel {
  double? energySum;
  double? costSum;

  ThisYearDataModel({this.energySum, this.costSum});

  ThisYearDataModel.fromJson(Map<String, dynamic> json) {
    energySum = json['energy_sum'];
    costSum = json['cost_sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['energy_sum'] = energySum;
    data['cost_sum'] = costSum;
    return data;
  }
}
