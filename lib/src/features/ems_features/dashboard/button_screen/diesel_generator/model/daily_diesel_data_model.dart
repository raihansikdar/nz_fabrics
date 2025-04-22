class DailyDieselDataModel {
  String? node;
  double? fuel;
  double? energy;
  double? cost;
  String? runtime;

  DailyDieselDataModel({this.node, this.fuel, this.energy, this.cost, this.runtime});

  DailyDieselDataModel.fromJson(Map<String, dynamic> json) {
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
