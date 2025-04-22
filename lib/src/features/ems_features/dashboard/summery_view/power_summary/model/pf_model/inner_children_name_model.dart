class InnerChildrenNameModel {
  String? parent;
  List<Children>? children;

  InnerChildrenNameModel({this.parent, this.children});

  InnerChildrenNameModel.fromJson(Map<String, dynamic> json) {
    parent = json['parent'];
    if (json['children'] != null) {
      children = <Children>[];
      json['children'].forEach((v) {
        children!.add(Children.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parent'] = parent;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Children {
  String? nodeName;
  String? category;
  bool? droppable;

  Children({this.nodeName, this.category, this.droppable});

  Children.fromJson(Map<String, dynamic> json) {
    nodeName = json['node_name'];
    category = json['category'];
    droppable = json['droppable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node_name'] = nodeName;
    data['category'] = category;
    data['droppable'] = droppable;
    return data;
  }
}
