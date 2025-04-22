// class DGRYearlyBarChartModel {
//   String? graphType;
//   List<Data>? data;
//
//   DGRYearlyBarChartModel({this.graphType, this.data});
//
//   DGRYearlyBarChartModel.fromJson(Map<String, dynamic> json) {
//     graphType = json['graph-type'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['graph-type'] = graphType;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   int? id;
//   String? date;
//   String? plantName;
//   dynamic cumulativePr;
//   dynamic poaDayAvg;
//   dynamic totalEnergy;
//   dynamic maxAcPower;
//   dynamic expectedEnergy;
//
//   Data(
//       {this.id,
//         this.date,
//         this.plantName,
//         this.cumulativePr,
//         this.poaDayAvg,
//         this.totalEnergy,
//         this.maxAcPower,
//         this.expectedEnergy,
//       });
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     date = json['date'];
//     plantName = json['plant_name'];
//     cumulativePr = json['cumulative_pr'];
//     poaDayAvg = json['poa_day_avg'];
//     totalEnergy = json['total_energy'];
//     maxAcPower = json['max_ac_power'];
//     expectedEnergy = json['expected_energy'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['date'] = date;
//     data['plant_name'] = plantName;
//     data['cumulative_pr'] = cumulativePr;
//     data['poa_day_avg'] = poaDayAvg;
//     data['total_energy'] = totalEnergy;
//     data['max_ac_power'] = maxAcPower;
//     data['expected_energy'] = expectedEnergy;
//     return data;
//   }
// }
class DGRYearlyBarChartModel {
  String? graphType;
  List<Data>? data;

  DGRYearlyBarChartModel({this.graphType, this.data});

  DGRYearlyBarChartModel.fromJson(Map<String, dynamic> json) {
    graphType = json['graph-type'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  int? id;
  String? date;
  String? plantName;
  dynamic cumulativePr;
  dynamic poaDayAvg;
  dynamic totalEnergy;
  dynamic maxAcPower;
  dynamic expectedEnergy;

  Data({
    this.id,
    this.date,
    this.plantName,
    this.cumulativePr,
    this.poaDayAvg,
    this.totalEnergy,
    this.maxAcPower,
    this.expectedEnergy,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    plantName = json['plant_name'];
    cumulativePr = json['cumulative_pr'];
    poaDayAvg = json['poa_day_avg'];
    totalEnergy = json['total_energy'];
    maxAcPower = json['max_ac_power'];
    expectedEnergy = json['expected_energy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['plant_name'] = plantName;
    data['cumulative_pr'] = cumulativePr;
    data['poa_day_avg'] = poaDayAvg;
    data['total_energy'] = totalEnergy;
    data['max_ac_power'] = maxAcPower;
    data['expected_energy'] = expectedEnergy;
    return data;
    }
}