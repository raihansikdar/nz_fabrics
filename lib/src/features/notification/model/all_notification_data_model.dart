class AllNotificationDataModel {
  bool? seen;
  DateTime? timedate;
  String? notification;

  AllNotificationDataModel({this.seen, this.timedate, this.notification});

  AllNotificationDataModel.fromJson(Map<String, dynamic> json) {
    seen = json['seen'];
    timedate = DateTime.parse(json['timedate']);
    notification = json['Notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seen'] = seen;
    data['timedate'] = timedate?.toIso8601String();
    data['Notification'] = notification;
    return data;
  }
}
