class DayModel {
  List<DgrDataModel>? dgrData;
  List<WaterDataModel>? waterData;
  List<NaturalGasDataModel>? gasData;

  DayModel({this.dgrData, this.waterData, this.gasData});

  DayModel.fromJson(Map<String, dynamic> json) {
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
  double? power;
  double? cost;
  String? type;
  String? category;

  DgrDataModel(
      {this.id,
        this.timedate,
        this.node,
        this.power,
        this.cost,
        this.type,
        this.category});

  DgrDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timedate = DateTime.parse(json["timedate"]);
    node = json['node'];
    power = json['power'];
    cost = json['cost'];
    type = json['type'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data["timedate"] = timedate?.toIso8601String();
    data['node'] = node;
    data['power'] = power;
    data['cost'] = cost;
    data['type'] = type;
    data['category'] = category;
    return data;
  }
}

class WaterDataModel {
  int? id;
  DateTime? timedate;
  String? node;
  double? instantFlow;
  double? cost;
  String? type;
  String? category;

  WaterDataModel(
      {this.id,
        this.timedate,
        this.node,
        this.instantFlow,
        this.cost,
        this.type,
        this.category});

  WaterDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timedate = DateTime.parse(json["timedate"]);
    node = json['node'];
    instantFlow = json['instant_flow'];
    cost = json['cost'];
    type = json['type'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data["timedate"] = timedate?.toIso8601String();
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['cost'] = cost;
    data['type'] = type;
    data['category'] = category;
    return data;
  }

  @override
  String toString() {
    return 'node: $node';
  }


}
class NaturalGasDataModel {
  int? id;
  DateTime? timedate;
  String? node;
  double? instantFlow;
  double? cost;
  String? type;
  String? category;

  NaturalGasDataModel({
    this.id,
    this.timedate,
    this.node,
    this.instantFlow,
    this.cost,
    this.type,
    this.category,
  });

  NaturalGasDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timedate = DateTime.parse(json["timedate"]);
    node = json['node'];
    instantFlow = json['instant_flow'];
    cost = json['cost'];
    type = json['type'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data["timedate"] = timedate?.toIso8601String();
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['cost'] = cost;
    data['type'] = type;
    data['category'] = category;
    return data;
  }
}
