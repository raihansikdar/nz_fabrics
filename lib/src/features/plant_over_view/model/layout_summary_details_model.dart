// class LayoutSummaryDetailsModel {
//   String? machineType;
//   double? totalPower;
//   int? totalMachine;
//   int? activeMachine;
//   Data? data;
//
//   LayoutSummaryDetailsModel(
//       {this.machineType,
//         this.totalPower,
//         this.totalMachine,
//         this.activeMachine,
//         this.data});
//
//   LayoutSummaryDetailsModel.fromJson(Map<String, dynamic> json) {
//     machineType = json['machine_type'];
//     totalPower = json['total_power'];
//     totalMachine = json['total_machine'];
//     activeMachine = json['active_machine'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['machine_type'] = machineType;
//     data['total_power'] = totalPower;
//     data['total_machine'] = totalMachine;
//     data['active_machine'] = activeMachine;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   dynamic aCPlant1;
//   String? aCPlant1Color;
//   dynamic aCPlant2;
//   String? aCPlant2Color;
//   dynamic aCPlant3;
//   String? aCPlant3Color;
//
//   Data(
//       {this.aCPlant1,
//         this.aCPlant1Color,
//         this.aCPlant2,
//         this.aCPlant2Color,
//         this.aCPlant3,
//         this.aCPlant3Color});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     aCPlant1 = json['AC Plant 1'];
//     aCPlant1Color = json['AC Plant 1_color'];
//     aCPlant2 = json['AC Plant 2'];
//     aCPlant2Color = json['AC Plant 2_color'];
//     aCPlant3 = json['AC Plant 3'];
//     aCPlant3Color = json['AC Plant 3_color'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['AC Plant 1'] = aCPlant1;
//     data['AC Plant 1_color'] = aCPlant1Color;
//     data['AC Plant 2'] = aCPlant2;
//     data['AC Plant 2_color'] = aCPlant2Color;
//     data['AC Plant 3'] = aCPlant3;
//     data['AC Plant 3_color'] = aCPlant3Color;
//     return data;
//   }
// }
/*class LayoutSummaryDetailsModel {
  String? machineType;
  double? totalPower;
  int? totalMachine;
  int? activeMachine;
  Map<String, dynamic>? data;

  LayoutSummaryDetailsModel({
    this.machineType,
    this.totalPower,
    this.totalMachine,
    this.activeMachine,
    this.data,
  });

  // From JSON method
  factory LayoutSummaryDetailsModel.fromJson(Map<String, dynamic> json) {
    return LayoutSummaryDetailsModel(
      machineType: json['machine_type'],
      totalPower: (json['total_power'] as num?)?.toDouble(),
      totalMachine: json['total_machine'] as int?,
      activeMachine: json['active_machine'] as int?,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'machine_type': machineType,
      'total_power': totalPower,
      'total_machine': totalMachine,
      'active_machine': activeMachine,
      'data': data,
    };
  }
}*/
class LayoutSummaryDetailsModel {
  String? machineType;
  double? totalPower;
  int? totalMachine;
  int? activeMachine;
  Map<String, dynamic>? data;

  LayoutSummaryDetailsModel({
    this.machineType,
    this.totalPower,
    this.totalMachine,
    this.activeMachine,
    this.data,
  });

  factory LayoutSummaryDetailsModel.fromJson(Map<String, dynamic> json) {
    return LayoutSummaryDetailsModel(
      machineType: json['machine_type'],
      totalPower: (json['total_power'] as num?)?.toDouble(),
      totalMachine: json['total_machine'] as int?,
      activeMachine: json['active_machine'] as int?,
      data: json['data'] as Map<String, dynamic>?, // Ensure it's a map
    );
  }

  Map<String, dynamic> toJson() {
    return {
    'machine_type': machineType,
    'total_power': totalPower,
    'total_machine': totalMachine,
    'active_machine': activeMachine,
    'data': data,
    };
    }
}