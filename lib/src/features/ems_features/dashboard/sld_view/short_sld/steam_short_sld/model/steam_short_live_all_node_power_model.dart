class SteamShortLiveAllNodePowerModel {
  dynamic power;
  dynamic instantFlow;
  String? timedate;
  String? color;
  String? node;
  bool? sensorStatus;
  String? sourceType;
  dynamic percentage;
  dynamic capacity;

  SteamShortLiveAllNodePowerModel(
      {this.power,
        this.instantFlow,
        this.timedate,
        this.color,
        this.node,
        this.sensorStatus,
        this.sourceType});

  SteamShortLiveAllNodePowerModel.fromJson(Map<String, dynamic> json) {
    power = json['power'];
    instantFlow = json['instant_flow'];
    timedate = json['timedate'];
    color = json['color'];
    node = json['node'];
    sensorStatus = json['sensor_status'];
    sourceType = json['source_type'];
    percentage = json['percentage'];
    capacity = json['capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['power'] = power;
    data['instant_flow'] = instantFlow;
    data['timedate'] = timedate;
    data['color'] = color;
    data['node'] = node;
    data['sensor_status'] = sensorStatus;
    data['source_type'] = sourceType;
    data['sourceType'] = sourceType;
    data['capacity'] = capacity;
    return data;
  }
}
