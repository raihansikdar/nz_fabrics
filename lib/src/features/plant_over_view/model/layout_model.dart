class LayoutImageModel {
  int? id;
  String? name;
  String? imageUrl;

  LayoutImageModel({this.id, this.name, this.imageUrl});

  LayoutImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image_url'] = imageUrl;
    return data;
  }
}
