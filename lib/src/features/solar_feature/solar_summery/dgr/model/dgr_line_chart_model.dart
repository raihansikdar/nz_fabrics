// class DGRLineChartModel {
//   String? graphType;
//   List<Data>? data;
//
//   DGRLineChartModel({this.graphType, this.data});
//
//   DGRLineChartModel.fromJson(Map<String, dynamic> json) {
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
//   String? timedate;
//   String? plantName;
//   dynamic acPower;
//   dynamic expectedEnergy;
//   dynamic todayEnergy;
//   dynamic pr;
//   dynamic irrEast;
//   dynamic irrWest;
//   dynamic irrNorth;
//   dynamic irrSouth;
//   dynamic irrSouth15;
//
//   Data(
//       {this.id,
//         this.timedate,
//         this.plantName,
//         this.acPower,
//         this.expectedEnergy,
//         this.todayEnergy,
//         this.pr,
//         this.irrEast,
//         this.irrWest,
//         this.irrNorth,
//         this.irrSouth,
//         this.irrSouth15});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     timedate = json['timedate'];
//     plantName = json['plant_name'];
//     acPower = json['ac_power'];
//     expectedEnergy = json['expected_energy'];
//     todayEnergy = json['today_energy'];
//     pr = json['pr'];
//     irrEast = json['irr_east'];
//     irrWest = json['irr_west'];
//     irrNorth = json['irr_north'];
//     irrSouth = json['irr_south'];
//     irrSouth15 = json['irr_south_15'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['timedate'] = timedate;
//     data['plant_name'] = plantName;
//     data['ac_power'] = acPower;
//     data['expected_energy'] = expectedEnergy;
//     data['today_energy'] = todayEnergy;
//     data['pr'] = pr;
//     data['irr_east'] = irrEast;
//     data['irr_west'] = irrWest;
//     data['irr_north'] = irrNorth;
//     data['irr_south'] = irrSouth;
//     data['irr_south_15'] = irrSouth15;
//     return data;
//   }
// }
class DGRLineChartModel {
  String? graphType;
  List<Data>? data;
  dynamic totalEnergy; // New field

  DGRLineChartModel({this.graphType, this.data, this.totalEnergy});

  DGRLineChartModel.fromJson(Map<String, dynamic> json) {
    graphType = json['graph-type'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    totalEnergy = json['total_energy']; // Parse the new field
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['graph-type'] = graphType;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total_energy'] = totalEnergy; // Add to output
    return data;
  }
}

class Data {
  int? id;
  String? timedate;
  String? plantName;
  dynamic acPower;
  dynamic expectedEnergy;
  dynamic todayEnergy;
  dynamic pr;
  dynamic irrEast;
  dynamic irrWest;
  dynamic irrNorth;
  dynamic irrSouth;
  dynamic irrSouth15;

  Data({
    this.id,
    this.timedate,
    this.plantName,
    this.acPower,
    this.expectedEnergy,
    this.todayEnergy,
    this.pr,
    this.irrEast,
    this.irrWest,
    this.irrNorth,
    this.irrSouth,
    this.irrSouth15,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timedate = json['timedate'];
    plantName = json['plant_name'];
    acPower = json['ac_power'];
    expectedEnergy = json['expected_energy'];
    todayEnergy = json['today_energy'];
    pr = json['pr'];
    irrEast = json['irr_east'];
    irrWest = json['irr_west'];
    irrNorth = json['irr_north'];
    irrSouth = json['irr_south'];
    irrSouth15 = json['irr_south_15'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['timedate'] = timedate;
    data['plant_name'] = plantName;
    data['ac_power'] = acPower;
    data['expected_energy'] = expectedEnergy;
    data['today_energy'] = todayEnergy;
    data['pr'] = pr;
    data['irr_east'] = irrEast;
    data['irr_west'] = irrWest;
    data['irr_north'] = irrNorth;
    data['irr_south'] = irrSouth;
    data['irr_south_15'] = irrSouth15;
    return data;
    }
}