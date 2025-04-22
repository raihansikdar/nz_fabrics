class MonthlyDataModel {
  int? id;
  String? date;
  String? node;
  dynamic fuel;
  dynamic energy;
  dynamic cost;
  int? runtime;
  String? nodeType;
  dynamic energyMod;
  dynamic costMod;

  MonthlyDataModel({
    this.id,
    this.date,
    this.node,
    this.fuel,
    this.energy,
    this.cost,
    this.runtime,
    this.nodeType,
    this.energyMod,
    this.costMod,
  });

  MonthlyDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    node = json['node'];
    fuel = json['fuel'];
    energy = (json['energy'] as num?)?.toDouble();
    cost = (json['cost'] as num?)?.toDouble();
    runtime = json['runtime'];
    nodeType = json['node_type'];
    energyMod = json['energy_mod'];
    costMod = json['cost_mod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['node'] = node;
    data['fuel'] = fuel;
    data['energy'] = energy;
    data['cost'] = cost;
    data['runtime'] = runtime;
    data['node_type'] = nodeType;
    data['energy_mod'] = energyMod;
    data['cost_mod'] = costMod;
    return data;
   }
}