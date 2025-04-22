class WaterRuntimeTodayDataModel {
  String? runtimeToday;

  WaterRuntimeTodayDataModel({this.runtimeToday});

  WaterRuntimeTodayDataModel.fromJson(Map<String, dynamic> json) {
    runtimeToday = json['runtime_today'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['runtime_today'] = runtimeToday;
    return data;
  }
}
