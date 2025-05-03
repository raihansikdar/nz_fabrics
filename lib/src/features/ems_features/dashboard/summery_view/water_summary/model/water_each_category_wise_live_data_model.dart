// class WaterEachCategoryWiseLiveDataModel {
//   List<Data>? data;
//
//   WaterEachCategoryWiseLiveDataModel({this.data});
//
//   WaterEachCategoryWiseLiveDataModel.fromJson(Map<String, dynamic> json) {
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class WaterEachCategoryWiseLiveDataModel {
  String? node;
  String? timedate;
  dynamic instantFlow;
  dynamic volume;
  dynamic cost;
  bool? status;
  //List<Null>? connectedWith;

  WaterEachCategoryWiseLiveDataModel(
      {this.node,
        this.timedate,
        this.instantFlow,
        this.volume,
        this.cost,
        this.status,
       // this.connectedWith
      });

  WaterEachCategoryWiseLiveDataModel.fromJson(Map<String, dynamic> json) {
    node = json['node'];
    timedate = json['timedate'];
    instantFlow = json['instant_flow'];
    volume = json['volume'];
    cost = json['cost'];
    status = json['status'];
    // if (json['connected_with'] != null) {
    //   connectedWith = <Null>[];
    //   json['connected_with'].forEach((v) {
    //     connectedWith!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node'] = node;
    data['timedate'] = timedate;
    data['instant_flow'] = instantFlow;
    data['volume'] = volume;
    data['cost'] = cost;
    data['status'] = status;
    // if (connectedWith != null) {
    //   data['connected_with'] =
    //       connectedWith!.map((v) => v?.toJson()).toList();
    // }
    return data;
  }
}
