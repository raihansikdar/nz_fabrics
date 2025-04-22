class OnlyMonthAnalysisProModel {
  List<OnlyMonthDgrData>? dgrData;


  OnlyMonthAnalysisProModel({this.dgrData, });

  OnlyMonthAnalysisProModel.fromJson(Map<String, dynamic> json) {
    if (json['dgr_data'] != null) {
      dgrData = <OnlyMonthDgrData>[];
      json['dgr_data'].forEach((v) {
        dgrData!.add(OnlyMonthDgrData.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dgrData != null) {
      data['dgr_data'] = dgrData!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class OnlyMonthDgrData {
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

  OnlyMonthDgrData(
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

  OnlyMonthDgrData.fromJson(Map<String, dynamic> json) {
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
