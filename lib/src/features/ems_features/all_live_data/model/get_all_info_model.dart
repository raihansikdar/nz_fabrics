class GetAllLiveInfoModel {
  int? id;
  String? nodeName;
  String? sourceType;
  bool? mainBusbar;
  String? shape;


  GetAllLiveInfoModel(
      {this.id,
        this.nodeName,
        this.sourceType,
        this.mainBusbar,
        this.shape,
        });

  GetAllLiveInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nodeName = json['node_name'];
    sourceType = json['source_type'];
    mainBusbar = json['main_busbar'];
    shape = json['shape'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['node_name'] = nodeName;
    data['source_type'] = sourceType;
    data['main_busbar'] = mainBusbar;
    data['shape'] = shape;
    return data;
  }
}
