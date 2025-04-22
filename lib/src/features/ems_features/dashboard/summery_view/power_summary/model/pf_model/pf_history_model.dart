class PFHistoryModel {
  int? id;
  String? timedate;
  String? nodeName;
  String? eventName;
  dynamic value;
  bool? acknowledged;

  PFHistoryModel(
      {this.id,
        this.timedate,
        this.nodeName,
        this.eventName,
        this.value,
        this.acknowledged});

  PFHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timedate = json['timedate'];
    nodeName = json['node_name'];
    eventName = json['event_name'];
    value = json['value'];
    acknowledged = json['acknowledged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['timedate'] = timedate;
    data['node_name'] = nodeName;
    data['event_name'] = eventName;
    data['value'] = value;
    data['acknowledged'] = acknowledged;
    return data;
  }
}
