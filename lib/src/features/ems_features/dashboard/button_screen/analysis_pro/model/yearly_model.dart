class YearlyModel {
  List<DgrDataModel>? dgrData;
  List<WaterDataModel>? waterData;
  List<NaturalGasDataModel>? gasData;

  YearlyModel({this.dgrData, this.waterData, this.gasData});

  YearlyModel.fromJson(Map<String, dynamic> json) {
    if (json['dgr_data'] != null) {
      dgrData = <DgrDataModel>[];
      json['dgr_data'].forEach((v) {
        dgrData!.add(DgrDataModel.fromJson(v));
      });
    }
    if (json['water_data'] != null) {
      waterData = <WaterDataModel>[];
      json['water_data'].forEach((v) {
        waterData!.add(WaterDataModel.fromJson(v));
      });
    }
    if (json['gas_data'] != null) {
      gasData = <NaturalGasDataModel>[];
      json['gas_data'].forEach((v) {
        gasData!.add(NaturalGasDataModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dgrData != null) {
      data['dgr_data'] = dgrData!.map((v) => v.toJson()).toList();
    }
    if (waterData != null) {
      data['water_data'] = waterData!.map((v) => v.toJson()).toList();
    }
    if (gasData != null) {
      data['gas_data'] = gasData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DgrDataModel {
  int? id;
  DateTime? timedate;
  String? node;
  double? fuel;
  double? energy;
  double? cost;
  int? powercutInMin;
  int? countPowercuts;
  String? nodeType;
  double? energyMod;
  double? costMod;

  DgrDataModel(
      {this.id,
        this.timedate,
        this.node,
        this.fuel,
        this.energy,
        this.cost,
        this.powercutInMin,
        this.countPowercuts,
        this.nodeType,
        this.energyMod,
        this.costMod});

  DgrDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timedate =  DateTime.parse(json["date"]);
    node = json['node'];
    fuel = json['fuel'];
    energy = json['energy'];
    cost = json['cost'];
    powercutInMin = json['powercut_in_min'];
    countPowercuts = json['count_powercuts'];
    nodeType = json['node_type'];
    energyMod = json['energy_mod'];
    costMod = json['cost_mod'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = timedate?.toIso8601String();
    data['node'] = node;
    data['fuel'] = fuel;
    data['energy'] = energy;
    data['cost'] = cost;
    data['powercut_in_min'] = powercutInMin;
    data['count_powercuts'] = countPowercuts;
    data['node_type'] = nodeType;
    data['energy_mod'] = energyMod;
    data['cost_mod'] = costMod;
    return data;
  }
}

class WaterDataModel {
  DateTime? timedate;
  String? node;
  double? instantFlow;
  double? cost;
  String? nodeType;

  WaterDataModel({this.timedate, this.node, this.instantFlow, this.cost, this.nodeType});

  WaterDataModel.fromJson(Map<String, dynamic> json) {
    timedate =  DateTime.parse(json["date"]);
    node = json['node'];
    instantFlow = json['instant_flow'];
    cost = json['cost'];
    nodeType = json['node_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = timedate?.toIso8601String();
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['cost'] = cost;
    data['node_type'] = nodeType;
    return data;
  }
}

class NaturalGasDataModel {
  DateTime? timedate;
  String? node;
  double? instantFlow;
  double? cost;
  int? runtime;
  String? nodeType;

  NaturalGasDataModel(
      {this.timedate,
        this.node,
        this.instantFlow,
        this.cost,
        this.runtime,
        this.nodeType});

  NaturalGasDataModel.fromJson(Map<String, dynamic> json) {
    timedate =  DateTime.parse(json["date"]);
    node = json['node'];
    instantFlow = json['instant_flow'];
    cost = json['cost'];
    runtime = json['runtime'];
    nodeType = json['node_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = timedate?.toIso8601String();
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['cost'] = cost;
    data['runtime'] = runtime;
    data['node_type'] = nodeType;
    return data;
  }
}
