class ElectricityShortLivePFDataModel {
  dynamic powerFactor;
  String? color;
  int? count;

  ElectricityShortLivePFDataModel({this.powerFactor, this.color, this.count});

  ElectricityShortLivePFDataModel.fromJson(Map<String, dynamic> json) {
    powerFactor = json['power_factor'];
    color = json['Color'];
    count = json['Count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['power_factor'] = powerFactor;
    data['Color'] = color;
    data['Count'] = count;
    return data;
  }
}
