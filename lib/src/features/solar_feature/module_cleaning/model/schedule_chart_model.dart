class ScheduleChartModel {
  int? id;
  String? timedate;
  String? shedName;
  String? cleaningStatus;
  String? reason;

  ScheduleChartModel(
      {this.id, this.timedate, this.shedName, this.cleaningStatus, this.reason});

  ScheduleChartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timedate = json['date'];
    shedName = json['shed_name'];
    cleaningStatus = json['cleaning_status'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = timedate;
    data['shed_name'] = shedName;
    data['cleaning_status'] = cleaningStatus;
    data['reason'] = reason;
    return data;
  }
}