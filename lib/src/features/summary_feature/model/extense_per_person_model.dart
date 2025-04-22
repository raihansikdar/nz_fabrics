// class ExpensePerPersonModel {
//   double? totalEnergyPerPerson;
//   double? totalCostPerPerson;
//   double? flowRatePerPerson;
//   double? flowRateCost;
//   double? carbonEmissionDpdcGeneratorPerPerson;
//   double? carbonEmissionDpdcGeneratorPerMachine;
//
//   ExpensePerPersonModel(
//       {this.totalEnergyPerPerson,
//         this.totalCostPerPerson,
//         this.flowRatePerPerson,
//         this.flowRateCost,
//         this.carbonEmissionDpdcGeneratorPerPerson,
//         this.carbonEmissionDpdcGeneratorPerMachine});
//
//   ExpensePerPersonModel.fromJson(Map<String, dynamic> json) {
//     totalEnergyPerPerson = json['total_energy_per_person'];
//     totalCostPerPerson = json['total_cost_per_person'];
//     flowRatePerPerson = json['flow_rate_per_person'];
//     flowRateCost = json['flow_rate_cost'];
//     carbonEmissionDpdcGeneratorPerPerson =
//     json['carbon_emission_dpdc_generator_per_person'];
//     carbonEmissionDpdcGeneratorPerMachine =
//     json['carbon_emission_dpdc_generator_per_machine'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['total_energy_per_person'] = totalEnergyPerPerson;
//     data['total_cost_per_person'] = totalCostPerPerson;
//     data['flow_rate_per_person'] = flowRatePerPerson;
//     data['flow_rate_cost'] = flowRateCost;
//     data['carbon_emission_dpdc_generator_per_person'] =
//         carbonEmissionDpdcGeneratorPerPerson;
//     data['carbon_emission_dpdc_generator_per_machine'] =
//         carbonEmissionDpdcGeneratorPerMachine;
//     return data;
//   }
// }


class ExpensePerPersonModel {
  Map<String, dynamic>? expensePerPerson;

  ExpensePerPersonModel({this.expensePerPerson});

  ExpensePerPersonModel.fromJson(Map<String, dynamic> json) {
    expensePerPerson = json;
  }

  Map<String, dynamic> toJson() {
    return expensePerPerson ?? {};
  }
}