//
// class PieChartDataModel {
//   List<Data>? data;
//   dynamic netTotalPower;
//   dynamic netTotalNetEnergy;
//
//   PieChartDataModel({this.data, this.netTotalPower, this.netTotalNetEnergy});
//
//   PieChartDataModel.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(Data.fromJson(v));
//       });
//     }
//     netTotalPower = json['net_total_power'];
//     netTotalNetEnergy = json['net_total_net_energy'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['net_total_power'] = netTotalPower;
//     data['net_total_net_energy'] = netTotalNetEnergy;
//     return data;
//   }
// }
//
// class Data {
//   String? category;
//   dynamic totalPower;
//   dynamic totalNetEnergy;
//   dynamic powerPercentage;
//
//   Data({this.category, this.totalPower, this.totalNetEnergy, this.powerPercentage});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     category = json['category'];
//     totalPower = json['total_power'];
//     totalNetEnergy = json['total_net_energy'];
//     powerPercentage = json['power_percentage'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['category'] = category;
//     data['total_power'] = totalPower;
//     data['total_net_energy'] = totalNetEnergy;
//     data['power_percentage'] = powerPercentage;
//     return data;
//   }
// }
class PieChartDataModel {
  List<Data>? data;
  dynamic netTotalPower;
  dynamic netTotalNetEnergy;
  dynamic netTotalCost;

  PieChartDataModel(
      {this.data,
        this.netTotalPower,
        this.netTotalNetEnergy,
        this.netTotalCost});

  PieChartDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    netTotalPower = json['net_total_power'];
    netTotalNetEnergy = json['net_total_net_energy'];
    netTotalCost = json['net_total_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['net_total_power'] = this.netTotalPower;
    data['net_total_net_energy'] = this.netTotalNetEnergy;
    data['net_total_cost'] = this.netTotalCost;
    return data;
  }
}

class Data {
  String? category;
  dynamic totalPower;
  dynamic totalNetEnergy;
  dynamic totalCost;
  dynamic powerPercentage;

  Data(
      {this.category,
        this.totalPower,
        this.totalNetEnergy,
        this.totalCost,
        this.powerPercentage});

  Data.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    totalPower = json['total_power'];
    totalNetEnergy = json['total_net_energy'];
    totalCost = json['total_cost'];
    powerPercentage = json['power_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['total_power'] = this.totalPower;
    data['total_net_energy'] = this.totalNetEnergy;
    data['total_cost'] = this.totalCost;
    data['power_percentage'] = this.powerPercentage;
    return data;
  }
}
