class TimeUsagePercentageModel {
  dynamic grid;
  dynamic generator;
  dynamic solar;

  TimeUsagePercentageModel({this.grid, this.generator, this.solar});

  TimeUsagePercentageModel.fromJson(Map<String, dynamic> json) {
    grid = json['Grid'];
    generator = json['Generator'];
    solar = json['Solar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Grid'] = grid;
    data['Generator'] = generator;
    data['Solar'] = solar;
    return data;
  }
}
