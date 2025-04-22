class EachCategoryLiveDataModel {
  String? node;
  String? timedate;
  dynamic power;
  dynamic netEnergy;
  bool? status;
  String? color;

  EachCategoryLiveDataModel(
      {this.node,
        this.timedate,
        this.power,
        this.netEnergy,
        this.status,
        this.color});

  EachCategoryLiveDataModel.fromJson(Map<String, dynamic> json) {
    node = json['node'];
    timedate = json['timedate'];
    power = json['power'];
    netEnergy = json['net_energy'];
    status = json['status'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node'] = node;
    data['timedate'] = timedate;
    data['power'] = power;
    data['net_energy'] = netEnergy;
    data['status'] = status;
    data['color'] = color;
    return data;
  }
}
