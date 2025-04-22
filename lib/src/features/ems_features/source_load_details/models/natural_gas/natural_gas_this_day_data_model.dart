class NaturalGasThisDayDataModel {
  double? thisDay;
  String? gasRuntimeToday;
  double? thisDayCostGas;

  NaturalGasThisDayDataModel(
      {this.thisDay, this.gasRuntimeToday, this.thisDayCostGas});

  NaturalGasThisDayDataModel.fromJson(Map<String, dynamic> json) {
    thisDay = json['this_day'];
    gasRuntimeToday = json['gas_runtime_today'];
    thisDayCostGas = json['this_day_cost_gas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['this_day'] = thisDay;
    data['gas_runtime_today'] = gasRuntimeToday;
    data['this_day_cost_gas'] = thisDayCostGas;
    return data;
  }
}
