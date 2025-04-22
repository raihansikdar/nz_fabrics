class MonthlyAnalysisProFilterDgrDataModel {
  String? graphType;
  List<MonthlyDataModel>? data;

  MonthlyAnalysisProFilterDgrDataModel({this.graphType, this.data});

  MonthlyAnalysisProFilterDgrDataModel.fromJson(Map<String, dynamic> json) {
    graphType = json['graph-type'];
    if (json['data'] != null) {
      data = <MonthlyDataModel>[];
      json['data'].forEach((v) {
        data!.add(MonthlyDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['graph-type'] = graphType;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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
  String? category;

  MonthlyDataModel(
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

  MonthlyDataModel.fromJson(Map<String, dynamic> json) {
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
