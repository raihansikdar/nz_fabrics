class GetProductionVsCapacityModel {
  String? node;
  double? percentage;

  GetProductionVsCapacityModel({this.node, this.percentage});

  GetProductionVsCapacityModel.fromJson(Map<String, dynamic> json) {
    node = json['node'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node'] = node;
    data['percentage'] = percentage;
    return data;
  }
}
