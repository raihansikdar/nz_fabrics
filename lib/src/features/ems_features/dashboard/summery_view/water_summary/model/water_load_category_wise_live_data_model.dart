class WaterLoadCategoryWiseLiveDataModel {
  List<Data>? data;
  dynamic netTotalInstantFlow;
  dynamic netTotalVolume;
  dynamic netTotalCost;

  WaterLoadCategoryWiseLiveDataModel(
      {this.data,
        this.netTotalInstantFlow,
        this.netTotalVolume,
        this.netTotalCost});

  WaterLoadCategoryWiseLiveDataModel.fromJson(Map<String, dynamic> json) {
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
  dynamic instantFlowPercentage;

  Data(
      {this.category,
        this.totalInstantFlow,
        this.totalVolume,
        this.totalCost,
        this.instantFlowPercentage});

  Data.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    totalInstantFlow = json['total_instant_flow'];
    totalVolume = json['total_volume'];
    totalCost = json['total_cost'];
    instantFlowPercentage = json['instant_flow_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['total_instant_flow'] = totalInstantFlow;
    data['total_volume'] = totalVolume;
    data['total_cost'] = totalCost;
    data['instant_flow_percentage'] = instantFlowPercentage;
    return data;
  }
}
