class FilterOverAllWaterMonthlyBarChartDataModel {
  String? graphType;
  List<OverAllMonthlyData>? data;
  Percentages? percentages;
  IndividualTotals? individualTotals;
  IndividualTotalCost? individualTotalCost;

  FilterOverAllWaterMonthlyBarChartDataModel({
    this.graphType,
    this.data,
    this.percentages,
    this.individualTotals,
    this.individualTotalCost,
  });

  FilterOverAllWaterMonthlyBarChartDataModel.fromJson(Map<String, dynamic> json) {
    graphType = json['graph-type'];
    if (json['data'] != null) {
      data = <OverAllMonthlyData>[];
      json['data'].forEach((v) {
        data!.add(OverAllMonthlyData.fromJson(v));
      });
    }
    percentages = json['percentages'] != null
        ? Percentages.fromJson(json['percentages'])
        : null;
    individualTotals = json['individual_totals'] != null
        ? IndividualTotals.fromJson(json['individual_totals'])
        : null;
    individualTotalCost = json['individual_total_cost'] != null
        ? IndividualTotalCost.fromJson(json['individual_total_cost'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['graph-type'] = graphType;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (percentages != null) {
      data['percentages'] = percentages!.toJson();
    }
    if (individualTotals != null) {
      data['individual_totals'] = individualTotals!.toJson();
    }
    if (individualTotalCost != null) {
      data['individual_total_cost'] = individualTotalCost!.toJson();
    }
    return data;
  }
}

class OverAllMonthlyData {
  int? id;
  String? date;
  String? node;
  dynamic instantFlow;
  dynamic cost;
  dynamic runtime;
  String? nodeType;
  String? category;
  dynamic volume;

  OverAllMonthlyData({
    this.id,
    this.date,
    this.node,
    this.instantFlow,
    this.cost,
    this.runtime,
    this.nodeType,
    this.category,
    this.volume,
  });

  OverAllMonthlyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    node = json['node'];
    instantFlow = json['instant_flow'];
    cost = json['cost'];
    runtime = json['runtime'];
    nodeType = json['node_type'];
    category = json['category'];
    volume = json['volume'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['node'] = node;
    data['instant_flow'] = instantFlow;
    data['cost'] = cost;
    data['runtime'] = runtime;
    data['node_type'] = nodeType;
    data['category'] = category;
    data['volume'] = volume;
    return data;
  }
}

class Percentages {
  Map<String, dynamic>? values;

  Percentages({this.values});

  Percentages.fromJson(Map<String, dynamic> json) {
    values = json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = values ?? {};
    return data;
  }
}

class IndividualTotals {
  Map<String, dynamic>? values;

  IndividualTotals({this.values});

  IndividualTotals.fromJson(Map<String, dynamic> json) {
    values = json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = values ?? {};
    return data;
  }
}

class IndividualTotalCost {
  Map<String, dynamic>? values;

  IndividualTotalCost({this.values});

  IndividualTotalCost.fromJson(Map<String, dynamic> json) {
    values = json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = values ?? {};
    return data;
  }
}