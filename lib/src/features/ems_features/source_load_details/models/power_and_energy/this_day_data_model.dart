class ThisDayDataModel {
  dynamic totalPowerSum;
  dynamic energy;
  dynamic cost;

  ThisDayDataModel({this.totalPowerSum, this.energy, this.cost});

  ThisDayDataModel.fromJson(Map<String, dynamic> json) {
    totalPowerSum = json['total_power_sum'];
    energy = json['energy'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_power_sum'] = totalPowerSum;
    data['energy'] = energy;
    data['cost'] = cost;
    return data;
  }

  void clear() {
    totalPowerSum = 0.0;
    energy = 0.0;
    cost = 0.0;
  }

}
