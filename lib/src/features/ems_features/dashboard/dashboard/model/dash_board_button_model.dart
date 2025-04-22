class DashBoardButtonModel {
  String? name;
  String? color;
  String? type;
  double? positionX;
  double? positionY;
  double? height;
  double? width;
  String? icon;
  String? shape;
  String? borderColor;
  String? textColor;

  DashBoardButtonModel(
      {this.name,
        this.color,
        this.type,
        this.positionX,
        this.positionY,
        this.height,
        this.width,
        this.icon,
        this.shape,
        this.borderColor,
        this.textColor});

  DashBoardButtonModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = json['color'];
    type = json['type'];
    positionX = json['position_x'];
    positionY = json['position_y'];
    height = json['height'];
    width = json['width'];
    icon = json['icon'];
    shape = json['shape'];
    borderColor = json['border_color'];
    textColor = json['text_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['color'] = color;
    data['type'] = type;
    data['position_x'] = positionX;
    data['position_y'] = positionY;
    data['height'] = height;
    data['width'] = width;
    data['icon'] = icon;
    data['shape'] = shape;
    data['border_color'] = borderColor;
    data['text_color'] = textColor;
    return data;
  }
}
