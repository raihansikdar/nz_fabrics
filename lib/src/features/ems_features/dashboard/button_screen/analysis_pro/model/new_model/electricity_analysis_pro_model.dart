class ElectricityAnalysisProModel {
  String? nodeName;
  String? sourceType;

  ElectricityAnalysisProModel({this.nodeName, this.sourceType});

  ElectricityAnalysisProModel.fromJson(Map<String, dynamic> json) {
    nodeName = json['node_name'];
    sourceType = json['source_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node_name'] = nodeName;
    data['source_type'] = sourceType;
    return data;
  }
}