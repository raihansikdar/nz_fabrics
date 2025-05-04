class WaterLongSLDPFItemModel {
  final int id;
  final String nodeName;
  final double positionX;
  final double positionY;
  final double width;
  final double height;

  WaterLongSLDPFItemModel({
    required this.id,
    required this.nodeName,
    required this.positionX,
    required this.positionY,
    required this.width,
    required this.height,
  });

  factory WaterLongSLDPFItemModel.fromJson(Map<String, dynamic> json) {
    return WaterLongSLDPFItemModel(
        id: json['id'],
        nodeName: json['node_name'],
        positionX: json['position_x'].toDouble(),
        positionY: json['position_y'].toDouble(),
        width: json['width'].toDouble(),
        height: json['height'].toDouble(),
        );
    }
}