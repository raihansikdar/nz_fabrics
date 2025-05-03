// Represents the top-level model containing a list of category-wise data and net totals.
class SourceCategoryModel {
  List<SourceCategoryWiseLiveDataModel> data;
  double? netTotalInstantFlow;
  double? netTotalVolume;
  double? netTotalCost;

  SourceCategoryModel({
    this.data = const [], // Default to empty list to avoid null
    this.netTotalInstantFlow,
    this.netTotalVolume,
    this.netTotalCost,
  });

  // Factory constructor to create an instance from JSON
  factory SourceCategoryModel.fromJson(Map<String, dynamic> json) {
    return SourceCategoryModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((v) => SourceCategoryWiseLiveDataModel.fromJson(v as Map<String, dynamic>))
          .toList() ??
          [],
      netTotalInstantFlow: (json['net_total_instant_flow'] as num?)?.toDouble(),
      netTotalVolume: (json['net_total_volume'] as num?)?.toDouble(),
      netTotalCost: (json['net_total_cost'] as num?)?.toDouble(),
    );
  }

  // Convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'data': data.map((v) => v.toJson()).toList(),
      'net_total_instant_flow': netTotalInstantFlow,
      'net_total_volume': netTotalVolume,
      'net_total_cost': netTotalCost,
    };
  }
}

// Represents individual category-wise data
class SourceCategoryWiseLiveDataModel {
  String category; // Non-nullable, assuming category is always provided
  double? totalInstantFlow;
  double? totalVolume;
  double? totalCost;
  double? instantFlowPercentage;

  SourceCategoryWiseLiveDataModel({
    required this.category, // Required to ensure category is always set
    this.totalInstantFlow,
    this.totalVolume,
    this.totalCost,
    this.instantFlowPercentage,
  });

  // Factory constructor to create an instance from JSON
  factory SourceCategoryWiseLiveDataModel.fromJson(Map<String, dynamic> json) {
    return SourceCategoryWiseLiveDataModel(
      category: json['category'] as String? ?? 'Unknown', // Default to 'Unknown' if null
      totalInstantFlow: (json['total_instant_flow'] as num?)?.toDouble(),
      totalVolume: (json['total_volume'] as num?)?.toDouble(),
      totalCost: (json['total_cost'] as num?)?.toDouble(),
      instantFlowPercentage: (json['instant_flow_percentage'] as num?)?.toDouble(),
    );
  }

  // Convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'total_instant_flow': totalInstantFlow,
      'total_volume': totalVolume,
      'total_cost': totalCost,
      'instant_flow_percentage': instantFlowPercentage,
    };
  }
}