class DailyDataModel {
  int? id;
  String? timedate;
  String? node;
  double? power;
  double? voltage1;
  double? voltage2;
  double? voltage3;
  double? current1;
  double? current2;
  double? current3;
  double? frequency;
  double? cost;

  DailyDataModel({
    this.id,
    this.timedate,
    this.node,
    this.power,
    this.voltage1,
    this.voltage2,
    this.voltage3,
    this.current1,
    this.current2,
    this.current3,
    this.frequency,
    this.cost,
  });

  DailyDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timedate = json['timedate'];
    node = json['node'];
    power = json['power'];
    voltage1 = json['voltage1'];
    voltage2 = json['voltage2'];
    voltage3 = json['voltage3'];
    current1 = json['current1'];
    current2 = json['current2'];
    current3 = json['current3'];
    frequency = json['frequency'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['timedate'] = timedate;
    data['node'] = node;
    data['power'] = power;
    data['voltage1'] = voltage1;
    data['voltage2'] = voltage2;
    data['voltage3'] = voltage3;
    data['current1'] = current1;
    data['current2'] = current2;
    data['current3'] = current3;
    data['frequency'] = frequency;
    data['cost'] = cost;
    return data;
    }
}