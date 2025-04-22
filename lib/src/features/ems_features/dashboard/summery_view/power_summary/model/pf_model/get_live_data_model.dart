class GetLiveDataModel {
  int? id;
  String? timedate;
  String? node;
  dynamic power;
  dynamic voltage1;
  dynamic voltage2;
  dynamic voltage3;
  dynamic current1;
  dynamic current2;
  dynamic current3;
  dynamic frequency;
  dynamic powerFactor;
  dynamic cost;
  dynamic sensorStatus;
  dynamic powerMod;
  dynamic costMod;
  dynamic yesterdayNetEnergy;
  dynamic todayEnergy;
  dynamic netEnergy;
  dynamic color;

  GetLiveDataModel(
      {this.id,
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
        this.powerFactor,
        this.cost,
        this.sensorStatus,
        this.powerMod,
        this.costMod,
        this.yesterdayNetEnergy,
        this.todayEnergy,
        this.netEnergy,
        this.color});

  GetLiveDataModel.fromJson(Map<String, dynamic> json) {
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
    powerFactor = json['power_factor'];
    cost = json['cost'];
    sensorStatus = json['sensor_status'];
    powerMod = json['power_mod'];
    costMod = json['cost_mod'];
    yesterdayNetEnergy = json['yesterday_net_energy'];
    todayEnergy = json['today_energy'];
    netEnergy = json['net_energy'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timedate'] = this.timedate;
    data['node'] = this.node;
    data['power'] = this.power;
    data['voltage1'] = this.voltage1;
    data['voltage2'] = this.voltage2;
    data['voltage3'] = this.voltage3;
    data['current1'] = this.current1;
    data['current2'] = this.current2;
    data['current3'] = this.current3;
    data['frequency'] = this.frequency;
    data['power_factor'] = this.powerFactor;
    data['cost'] = this.cost;
    data['sensor_status'] = this.sensorStatus;
    data['power_mod'] = this.powerMod;
    data['cost_mod'] = this.costMod;
    data['yesterday_net_energy'] = this.yesterdayNetEnergy;
    data['today_energy'] = this.todayEnergy;
    data['net_energy'] = this.netEnergy;
    data['color'] = this.color;
    return data;
  }
}
