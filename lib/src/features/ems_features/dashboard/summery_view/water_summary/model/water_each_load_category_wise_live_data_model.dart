// class WaterEachLoadCategoryWiseLiveDataModel {
//   List<Data>? data;
//
//   WaterEachLoadCategoryWiseLiveDataModel({this.data});
//
//   WaterEachLoadCategoryWiseLiveDataModel.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class WaterEachLoadCategoryWiseLiveDataModel {
  String? node;
  String? timedate;
  dynamic instantFlow;
  dynamic volume;
  bool? status;

  WaterEachLoadCategoryWiseLiveDataModel({this.node, this.timedate, this.instantFlow, this.volume, this.status});

  WaterEachLoadCategoryWiseLiveDataModel.fromJson(Map<String, dynamic> json) {
    node = json['node'];
    timedate = json['timedate'];
    instantFlow = json['instant_flow'];
    volume = json['volume'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node'] = node;
    data['timedate'] = timedate;
    data['instant_flow'] = instantFlow;
    data['volume'] = volume;
    data['status'] = status;
    return data;
  }
}
