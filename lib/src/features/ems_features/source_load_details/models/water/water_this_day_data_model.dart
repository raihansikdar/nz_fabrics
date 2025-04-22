class WaterThisDayDataModel {
  double? thisDay;
  String? waterRuntimeToday;
  dynamic thisDayCostWater;

  WaterThisDayDataModel(
      {this.thisDay, this.waterRuntimeToday, this.thisDayCostWater});

  WaterThisDayDataModel.fromJson(Map<String, dynamic> json) {
    thisDay = json['this_day'];
    waterRuntimeToday = json['water_runtime_today'];
    thisDayCostWater = json['this_day_cost_water'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['this_day'] = thisDay;
    data['water_runtime_today'] = waterRuntimeToday;
    data['this_day_cost_water'] = thisDayCostWater;
    return data;
  }
}
