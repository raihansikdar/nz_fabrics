class FilterBusBarEnergyCostModel {
  String? date;
  dynamic energy;
  dynamic cost;

  FilterBusBarEnergyCostModel({this.date, this.energy, this.cost});

  FilterBusBarEnergyCostModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    energy = json['energy'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['energy'] = energy;
    data['cost'] = cost;
    return data;
  }
}
