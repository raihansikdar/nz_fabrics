class NaturalGasPieChartTotalDataModel {
  dynamic totalPressure;
  dynamic totalCost;
  double? nGL1;
  double? nGL2;
  double? nGL3;
  double? nGL4;

  NaturalGasPieChartTotalDataModel(
      {this.totalPressure,
        this.totalCost,
        this.nGL1,
        this.nGL2,
        this.nGL3,
        this.nGL4});

  NaturalGasPieChartTotalDataModel.fromJson(Map<String, dynamic> json) {
    totalPressure = json['total'];
    totalCost = json['total_cost'];
    nGL1 = json['NGL-1'];
    nGL2 = json['NGL-2'];
    nGL3 = json['NGL-3'];
    nGL4 = json['NGL-4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = totalPressure;
    data['total_cost'] = totalCost;
    data['NGL-1'] = nGL1;
    data['NGL-2'] = nGL2;
    data['NGL-3'] = nGL3;
    data['NGL-4'] = nGL4;
    return data;
  }
}


