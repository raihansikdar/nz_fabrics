class LTProductionVsCapacityModel {
  dynamic lt01AGeneratorPercentage;
  dynamic lt01ASolarPercentage;
  dynamic lt01AGeneratorPower;
  dynamic lt01ASolarPower;
  dynamic lt01AGridPower;
  dynamic lt01AGridPercentage;
  dynamic lt01BGeneratorPercentage;
  dynamic lt01BSolarPercentage;
  dynamic lt01BGeneratorPower;
  dynamic lt01BSolarPower;
  dynamic lt01BGridPower;
  dynamic lt01BGridPercentage;
  dynamic lt02BGeneratorPercentage;
  dynamic lt02BSolarPercentage;
  dynamic lt02BGeneratorPower;
  dynamic lt02BSolarPower;
  dynamic lt02BGridPower;
  dynamic lt02BGridPercentage;
  dynamic lt02AGeneratorPercentage;
  dynamic lt02ASolarPercentage;
  dynamic lt02AGeneratorPower;
  dynamic lt02ASolarPower;
  dynamic lt02AGridPower;
  dynamic lt02AGridPercentage;
  String? generatorColor;
  String? solarColor;
  String? gridColor;

  LTProductionVsCapacityModel(
      {this.lt01AGeneratorPercentage,
        this.lt01ASolarPercentage,
        this.lt01AGeneratorPower,
        this.lt01ASolarPower,
        this.lt01AGridPower,
        this.lt01AGridPercentage,
        this.lt01BGeneratorPercentage,
        this.lt01BSolarPercentage,
        this.lt01BGeneratorPower,
        this.lt01BSolarPower,
        this.lt01BGridPower,
        this.lt01BGridPercentage,
        this.lt02BGeneratorPercentage,
        this.lt02BSolarPercentage,
        this.lt02BGeneratorPower,
        this.lt02BSolarPower,
        this.lt02BGridPower,
        this.lt02BGridPercentage,
        this.lt02AGeneratorPercentage,
        this.lt02ASolarPercentage,
        this.lt02AGeneratorPower,
        this.lt02ASolarPower,
        this.lt02AGridPower,
        this.lt02AGridPercentage,
        this.generatorColor,
        this.solarColor,
        this.gridColor});

  LTProductionVsCapacityModel.fromJson(Map<String, dynamic> json) {
    lt01AGeneratorPercentage = json['lt_01_a_generator_percentage'];
    lt01ASolarPercentage = json['lt_01_a_solar_percentage'];
    lt01AGeneratorPower = json['lt_01_a_generator_power'];
    lt01ASolarPower = json['lt_01_a_solar_power'];
    lt01AGridPower = json['lt_01_a_grid_power'];
    lt01AGridPercentage = json['lt_01_a_grid_percentage'];
    lt01BGeneratorPercentage = json['lt_01_b_generator_percentage'];
    lt01BSolarPercentage = json['lt_01_b_solar_percentage'];
    lt01BGeneratorPower = json['lt_01_b_generator_power'];
    lt01BSolarPower = json['lt_01_b_solar_power'];
    lt01BGridPower = json['lt_01_b_grid_power'];
    lt01BGridPercentage = json['lt_01_b_grid_percentage'];
    lt02BGeneratorPercentage = json['lt_02_b_generator_percentage'];
    lt02BSolarPercentage = json['lt_02_b_solar_percentage'];
    lt02BGeneratorPower = json['lt_02_b_generator_power'];
    lt02BSolarPower = json['lt_02_b_solar_power'];
    lt02BGridPower = json['lt_02_b_grid_power'];
    lt02BGridPercentage = json['lt_02_b_grid_percentage'];
    lt02AGeneratorPercentage = json['lt_02_a_generator_percentage'];
    lt02ASolarPercentage = json['lt_02_a_solar_percentage'];
    lt02AGeneratorPower = json['lt_02_a_generator_power'];
    lt02ASolarPower = json['lt_02_a_solar_power'];
    lt02AGridPower = json['lt_02_a_grid_power'];
    lt02AGridPercentage = json['lt_02_a_grid_percentage'];
    generatorColor = json['generator_color'];
    solarColor = json['solar_color'];
    gridColor = json['grid_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lt_01_a_generator_percentage'] = lt01AGeneratorPercentage;
    data['lt_01_a_solar_percentage'] = lt01ASolarPercentage;
    data['lt_01_a_generator_power'] = lt01AGeneratorPower;
    data['lt_01_a_solar_power'] = lt01ASolarPower;
    data['lt_01_a_grid_power'] = lt01AGridPower;
    data['lt_01_a_grid_percentage'] = lt01AGridPercentage;
    data['lt_01_b_generator_percentage'] = lt01BGeneratorPercentage;
    data['lt_01_b_solar_percentage'] = lt01BSolarPercentage;
    data['lt_01_b_generator_power'] = lt01BGeneratorPower;
    data['lt_01_b_solar_power'] = lt01BSolarPower;
    data['lt_01_b_grid_power'] = lt01BGridPower;
    data['lt_01_b_grid_percentage'] = lt01BGridPercentage;
    data['lt_02_b_generator_percentage'] = lt02BGeneratorPercentage;
    data['lt_02_b_solar_percentage'] = lt02BSolarPercentage;
    data['lt_02_b_generator_power'] = lt02BGeneratorPower;
    data['lt_02_b_solar_power'] = lt02BSolarPower;
    data['lt_02_b_grid_power'] = lt02BGridPower;
    data['lt_02_b_grid_percentage'] = lt02BGridPercentage;
    data['lt_02_a_generator_percentage'] = lt02AGeneratorPercentage;
    data['lt_02_a_solar_percentage'] = lt02ASolarPercentage;
    data['lt_02_a_generator_power'] = lt02AGeneratorPower;
    data['lt_02_a_solar_power'] = lt02ASolarPower;
    data['lt_02_a_grid_power'] = lt02AGridPower;
    data['lt_02_a_grid_percentage'] = lt02AGridPercentage;
    data['generator_color'] = generatorColor;
    data['solar_color'] = solarColor;
    data['grid_color'] = gridColor;
    return data;
  }
}
