class FindElectricityValueModel {
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
  bool? sensorStatus;
  dynamic powerMod;
  dynamic costMod;
  dynamic importEnergy;
  dynamic exportEnergy;
  dynamic netEnergy;
  String? color;

  FindElectricityValueModel(
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
        this.importEnergy,
        this.exportEnergy,
        this.netEnergy,
        this.color});

  FindElectricityValueModel.fromJson(Map<String, dynamic> json) {
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
    importEnergy = json['import_energy'];
    exportEnergy = json['export_energy'];
    netEnergy = json['net_energy'];
    color = json['color'];
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
    data['power_factor'] = powerFactor;
    data['cost'] = cost;
    data['sensor_status'] = sensorStatus;
    data['power_mod'] = powerMod;
    data['cost_mod'] = costMod;
    data['import_energy'] = importEnergy;
    data['export_energy'] = exportEnergy;
    data['net_energy'] = netEnergy;
    data['color'] = color;
    return data;
  }
}
