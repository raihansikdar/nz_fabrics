class FilterSpecificNodeTableModel {
  List<Data>? data;
  dynamic totalEnergy;

  FilterSpecificNodeTableModel({this.data, this.totalEnergy});

  FilterSpecificNodeTableModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    totalEnergy = json['total_energy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total_energy'] = totalEnergy;
    return data;
  }
}

class Data {
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
  String? category;

  Data(
      {this.id,
        this.date,
        this.node,
        this.fuel,
        this.energy,
        this.cost,
        this.runtime,
        this.nodeType,
        this.energyMod,
        this.costMod,
        this.category});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    node = json['node'];
    fuel = json['fuel'];
    energy = json['energy'];
    cost = json['cost'];
    runtime = json['runtime'];
    nodeType = json['node_type'];
    energyMod = json['energy_mod'];
    costMod = json['cost_mod'];
    category = json['category'];
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
    data['category'] = category;
    return data;
  }
}
