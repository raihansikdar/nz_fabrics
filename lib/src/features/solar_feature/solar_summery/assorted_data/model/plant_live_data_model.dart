class PlantLiveDataModel {
  int? id;
  double? avgIrr;
  String? plantName;
  String? timedate;
  double? totalAcPower;
  double? totalDcPower;
  double? todayEnergy;
  double? yesterdayEnergy;
  double? totalEnergy;
  double? livePr;
  double? cumulativePr;
  double? irrEast;
  double? irrWest;
  double? irrNorth;
  double? irrSouth;
  double? irrSouth15;
  double? profit;
  double? maxAcPower;
  double? maxDcPower;
  double? maxIrrEast;
  double? maxIrrWest;
  double? maxIrrNorth;
  double? maxIrrSouth;
  double? maxIrrSouth15;
  double? specificYield;
  double? moduleTemperature;
  double? ambientTemperature;
  double? poaDayAverage;
  double? activePowerControl1;
  double? activePowerControl2;
  double? activePowerControl3;
  double? activePowerControl4;
  double? activePowerControl5;
  double? yesterdayPr;
  double? yesterdayMaxIrr;
  double? yesterdayMaxAc;
  double? yesterdayMaxDc;
  double? yesterdaySpecificYield;
  double? plantGeneration;
  double? weightedAvgIrr;
  double? dg1;
  double? dg2;
  double? dg3;
  double? dg4;
  double? dg5;
  double? dg6;
  double? dg7;
  double? dg8;
  double? dg9;
  double? dg10;
  double? dg11;
  double? dg12;
  double? dg13;
  double? dg14;

  PlantLiveDataModel(
      {this.id,
        this.avgIrr,
        this.plantName,
        this.timedate,
        this.totalAcPower,
        this.totalDcPower,
        this.todayEnergy,
        this.yesterdayEnergy,
        this.totalEnergy,
        this.livePr,
        this.cumulativePr,
        this.irrEast,
        this.irrWest,
        this.irrNorth,
        this.irrSouth,
        this.irrSouth15,
        this.profit,
        this.maxAcPower,
        this.maxDcPower,
        this.maxIrrEast,
        this.maxIrrWest,
        this.maxIrrNorth,
        this.maxIrrSouth,
        this.maxIrrSouth15,
        this.specificYield,
        this.moduleTemperature,
        this.ambientTemperature,
        this.poaDayAverage,
        this.activePowerControl1,
        this.activePowerControl2,
        this.activePowerControl3,
        this.activePowerControl4,
        this.activePowerControl5,
        this.yesterdayPr,
        this.yesterdayMaxIrr,
        this.yesterdayMaxAc,
        this.yesterdayMaxDc,
        this.yesterdaySpecificYield,
        this.plantGeneration,
        this.weightedAvgIrr,
        this.dg1,
        this.dg2,
        this.dg3,
        this.dg4,
        this.dg5,
        this.dg6,
        this.dg7,
        this.dg8,
        this.dg9,
        this.dg10,
        this.dg11,
        this.dg12,
        this.dg13,
        this.dg14});

  PlantLiveDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avgIrr = json['avg_irr'];
    plantName = json['plant_name'];
    timedate = json['timedate'];
    totalAcPower = json['total_ac_power'];
    totalDcPower = json['total_dc_power'];
    todayEnergy = json['today_energy'];
    yesterdayEnergy = json['yesterday_energy'];
    totalEnergy = json['total_energy'];
    livePr = json['live_pr'];
    cumulativePr = json['cumulative_pr'];
    irrEast = json['irr_east'];
    irrWest = json['irr_west'];
    irrNorth = json['irr_north'];
    irrSouth = json['irr_south'];
    irrSouth15 = json['irr_south_15'];
    profit = json['profit'];
    maxAcPower = json['max_ac_power'];
    maxDcPower = json['max_dc_power'];
    maxIrrEast = json['max_irr_east'];
    maxIrrWest = json['max_irr_west'];
    maxIrrNorth = json['max_irr_north'];
    maxIrrSouth = json['max_irr_south'];
    maxIrrSouth15 = json['max_irr_south_15'];
    specificYield = json['specific_yield'];
    moduleTemperature = json['module_temperature'];
    ambientTemperature = json['ambient_temperature'];
    poaDayAverage = json['poa_day_average'];
    activePowerControl1 = json['active_power_control_1'];
    activePowerControl2 = json['active_power_control_2'];
    activePowerControl3 = json['active_power_control_3'];
    activePowerControl4 = json['active_power_control_4'];
    activePowerControl5 = json['active_power_control_5'];
    yesterdayPr = json['yesterday_pr'];
    yesterdayMaxIrr = json['yesterday_max_irr'];
    yesterdayMaxAc = json['yesterday_max_ac'];
    yesterdayMaxDc = json['yesterday_max_dc'];
    yesterdaySpecificYield = json['yesterday_specific_yield'];
    plantGeneration = json['plant_generation'];
    weightedAvgIrr = json['weighted_avg_irr'];
    dg1 = json['dg_1'];
    dg2 = json['dg_2'];
    dg3 = json['dg_3'];
    dg4 = json['dg_4'];
    dg5 = json['dg_5'];
    dg6 = json['dg_6'];
    dg7 = json['dg_7'];
    dg8 = json['dg_8'];
    dg9 = json['dg_9'];
    dg10 = json['dg_10'];
    dg11 = json['dg_11'];
    dg12 = json['dg_12'];
    dg13 = json['dg_13'];
    dg14 = json['dg_14'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['avg_irr'] = avgIrr;
    data['plant_name'] = plantName;
    data['timedate'] = timedate;
    data['total_ac_power'] = totalAcPower;
    data['total_dc_power'] = totalDcPower;
    data['today_energy'] = todayEnergy;
    data['yesterday_energy'] = yesterdayEnergy;
    data['total_energy'] = totalEnergy;
    data['live_pr'] = livePr;
    data['cumulative_pr'] = cumulativePr;
    data['irr_east'] = irrEast;
    data['irr_west'] = irrWest;
    data['irr_north'] = irrNorth;
    data['irr_south'] = irrSouth;
    data['irr_south_15'] = irrSouth15;
    data['profit'] = profit;
    data['max_ac_power'] = maxAcPower;
    data['max_dc_power'] = maxDcPower;
    data['max_irr_east'] = maxIrrEast;
    data['max_irr_west'] = maxIrrWest;
    data['max_irr_north'] = maxIrrNorth;
    data['max_irr_south'] = maxIrrSouth;
    data['max_irr_south_15'] = maxIrrSouth15;
    data['specific_yield'] = specificYield;
    data['module_temperature'] = moduleTemperature;
    data['ambient_temperature'] = ambientTemperature;
    data['poa_day_average'] = poaDayAverage;
    data['active_power_control_1'] = activePowerControl1;
    data['active_power_control_2'] = activePowerControl2;
    data['active_power_control_3'] = activePowerControl3;
    data['active_power_control_4'] = activePowerControl4;
    data['active_power_control_5'] = activePowerControl5;
    data['yesterday_pr'] = yesterdayPr;
    data['yesterday_max_irr'] = yesterdayMaxIrr;
    data['yesterday_max_ac'] = yesterdayMaxAc;
    data['yesterday_max_dc'] = yesterdayMaxDc;
    data['yesterday_specific_yield'] = yesterdaySpecificYield;
    data['plant_generation'] = plantGeneration;
    data['weighted_avg_irr'] = weightedAvgIrr;
    data['dg_1'] = dg1;
    data['dg_2'] = dg2;
    data['dg_3'] = dg3;
    data['dg_4'] = dg4;
    data['dg_5'] = dg5;
    data['dg_6'] = dg6;
    data['dg_7'] = dg7;
    data['dg_8'] = dg8;
    data['dg_9'] = dg9;
    data['dg_10'] = dg10;
    data['dg_11'] = dg11;
    data['dg_12'] = dg12;
    data['dg_13'] = dg13;
    data['dg_14'] = dg14;
    return data;
  }
}
