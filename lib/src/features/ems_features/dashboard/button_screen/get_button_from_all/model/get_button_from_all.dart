// class GetButtonFromGetAllModel {
//   int? id;
//   String? nodeName;
//   String? sourceType;
//   String? category;
//
//
//   GetButtonFromGetAllModel(
//       {this.id,
//         this.nodeName,
//         this.sourceType,
//         this.category,
//         });
//
//   GetButtonFromGetAllModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     nodeName = json['node_name'];
//     sourceType = json['source_type'];
//     category = json['category'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['node_name'] = nodeName;
//     data['source_type'] = sourceType;
//     data['category'] = category;
//     return data;
//   }
// }
class GetButtonFromGetAllModel {
  String? category;

  GetButtonFromGetAllModel({this.category});

  GetButtonFromGetAllModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    return data;
  }
}