class PFItem {
  final int id;
  final String nodeName;
  final double positionX;
  final double positionY;
  final double width;
  final double height;

  PFItem({
    required this.id,
    required this.nodeName,
    required this.positionX,
    required this.positionY,
    required this.width,
    required this.height,
  });

  factory PFItem.fromJson(Map<String, dynamic> json) {
    return PFItem(
        id: json['id'],
        nodeName: json['node_name'],
        positionX: json['position_x'].toDouble(),
        positionY: json['position_y'].toDouble(),
        width: json['width'].toDouble(),
        height: json['height'].toDouble(),
        );
    }
}