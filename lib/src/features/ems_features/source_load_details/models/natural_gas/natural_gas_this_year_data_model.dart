class NaturalGasThisYearDataModel {
  double? volume;
  double? cost;

  NaturalGasThisYearDataModel({this.volume, this.cost});

  NaturalGasThisYearDataModel.fromJson(Map<String, dynamic> json) {
    volume = json['volume'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['volume'] = volume;
    data['cost'] = cost;
    return data;
  }
}
