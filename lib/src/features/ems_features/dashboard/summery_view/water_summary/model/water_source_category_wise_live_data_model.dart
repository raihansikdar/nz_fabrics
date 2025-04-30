class WaterSourceCategoryWiseLiveDataModel {
  List<Data>? data;
  dynamic netTotalInstantFlow;
  dynamic netTotalVolume;
  dynamic netTotalCost;

  WaterSourceCategoryWiseLiveDataModel(
      {this.data,
        this.netTotalInstantFlow,
        this.netTotalVolume,
        this.netTotalCost});

  WaterSourceCategoryWiseLiveDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    netTotalInstantFlow = json['net_total_instant_flow'];
    netTotalVolume = json['net_total_volume'];
    netTotalCost = json['net_total_cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['net_total_instant_flow'] = netTotalInstantFlow;
    data['net_total_volume'] = netTotalVolume;
    data['net_total_cost'] = netTotalCost;
    return data;
  }
}

class Data {
  String? category;
  dynamic totalInstantFlow;
  dynamic totalVolume;
  dynamic totalCost;
  dynamic powerPercentage;

  Data(
      {this.category,
        this.totalInstantFlow,
        this.totalVolume,
        this.totalCost,
        this.powerPercentage});

  Data.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    totalInstantFlow = json['total_instant_flow'];
    totalVolume = json['total_volume'];
    totalCost = json['total_cost'];
    powerPercentage = json['power_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['total_instant_flow'] = totalInstantFlow;
    data['total_volume'] = totalVolume;
    data['total_cost'] = totalCost;
    data['power_percentage'] = powerPercentage;
    return data;
  }
}
