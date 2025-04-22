class SearchModel {
  int? id;
  String? nodeName;
  String? sourceType;
  String? category;

  SearchModel({this.id, this.nodeName,this.sourceType,this.category});

  SearchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nodeName = json['node_name'];
    sourceType = json['source_type'];
    category = json['category'];
  }

  static List<SearchModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SearchModel.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['node_name'] = nodeName;
    data['source_type'] = sourceType;
    data['category'] = category;
    return data;
  }
}
