class ElectricityLongBusBarStatusInfoModel {
  BusBar? busBar;
  List<ConnectedWithDetails>? connectedWithDetails;

  ElectricityLongBusBarStatusInfoModel({this.busBar, this.connectedWithDetails});

  ElectricityLongBusBarStatusInfoModel.fromJson(Map<String, dynamic> json) {
    busBar =
    json['bus_bar'] != null ? BusBar.fromJson(json['bus_bar']) : null;
    if (json['connected_with_details'] != null) {
      connectedWithDetails = <ConnectedWithDetails>[];
      json['connected_with_details'].forEach((v) {
        connectedWithDetails!.add(ConnectedWithDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (busBar != null) {
      data['bus_bar'] = busBar!.toJson();
    }
    if (connectedWithDetails != null) {
      data['connected_with_details'] =
          connectedWithDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BusBar {
  int? id;
  String? nodeName;
  String? sourceType;

  BusBar({this.id, this.nodeName, this.sourceType});

  BusBar.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nodeName = json['node_name'];
    sourceType = json['source_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['node_name'] = nodeName;
    data['source_type'] = sourceType;
    return data;
  }
}

class ConnectedWithDetails {
  String? nodeName;
  bool? sensorStatus;
  String? lineID;
  String? color;

  ConnectedWithDetails(
      {this.nodeName, this.sensorStatus, this.lineID, this.color});

  ConnectedWithDetails.fromJson(Map<String, dynamic> json) {
    nodeName = json['node_name'];
    sensorStatus = json['sensor_status'];
    lineID = json['lineID'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node_name'] = nodeName;
    data['sensor_status'] = sensorStatus;
    data['lineID'] = lineID;
    data['color'] = color;
    return data;
  }
}
