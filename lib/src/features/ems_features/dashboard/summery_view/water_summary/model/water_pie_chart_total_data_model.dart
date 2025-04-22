class WaterPieChartTotalDataModel {
  dynamic total;
  dynamic totalCost;
  dynamic wS1;
  dynamic wS2;
  dynamic wS3;

  WaterPieChartTotalDataModel(
      {this.total, this.totalCost, this.wS1, this.wS2, this.wS3});

  WaterPieChartTotalDataModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    totalCost = json['total_cost'];
    wS1 = json['WS-1'];
    wS2 = json['WS-2'];
    wS3 = json['WS-3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['total_cost'] = totalCost;
    data['WS-1'] = wS1;
    data['WS-2'] = wS2;
    data['WS-3'] = wS3;
    return data;
  }
}

