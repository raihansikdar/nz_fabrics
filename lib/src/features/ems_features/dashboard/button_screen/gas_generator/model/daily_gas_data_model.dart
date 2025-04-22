class DailyGasDataModel {
  String? node;
  dynamic fuel;
  dynamic energy;
  dynamic cost;
  String? runtime;

  DailyGasDataModel({this.node, this.fuel, this.energy, this.cost, this.runtime});

  DailyGasDataModel.fromJson(Map<String, dynamic> json) {
    node = json['node'];
    fuel = json['fuel'];
    energy = json['energy'];
    cost = json['cost'];
    runtime = json['runtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node'] = node;
    data['fuel'] = fuel;
    data['energy'] = energy;
    data['cost'] = cost;
    data['runtime'] = runtime;
    return data;
  }
}