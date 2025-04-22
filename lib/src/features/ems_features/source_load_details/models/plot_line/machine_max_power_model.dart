// class MachineMaxPowerModel {
//   dynamic machineMaxPower;
//
//   MachineMaxPowerModel({this.machineMaxPower});
//
//   MachineMaxPowerModel.fromJson(Map<String, dynamic> json) {
//     machineMaxPower = json['machine_max_power'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['machine_max_power'] = machineMaxPower;
//     return data;
//   }
// }

class MachineMaxPowerModel {
  double? machineMaxPower;

  MachineMaxPowerModel({this.machineMaxPower});

  MachineMaxPowerModel.fromJson(Map<String, dynamic> json) {
    machineMaxPower = (json['machine_max_power'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    return {'machine_max_power': machineMaxPower};
  }
}
