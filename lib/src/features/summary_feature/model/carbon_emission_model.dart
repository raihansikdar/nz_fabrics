// class CarbonEmissionModel {
//   double? grid;
//   double? generator;
//
//   CarbonEmissionModel({this.grid, this.generator});
//
//   CarbonEmissionModel.fromJson(Map<String, dynamic> json) {
//     grid = json['Grid'];
//     generator = json['Generator'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Grid'] = grid;
//     data['Generator'] = generator;
//     return data;
//   }
// }
class CarbonEmissionModel {
  Map<String, dynamic>? emissions;

  CarbonEmissionModel({this.emissions});

  CarbonEmissionModel.fromJson(Map<String, dynamic> json) {
    emissions = json;
  }

  Map<String, dynamic> toJson() {
    return emissions ?? {};
  }
}
