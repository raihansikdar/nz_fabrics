class NaturalGasPieChartDataModel {
  NaturalGasPieChartDataModel(this.category, this.value);

  final String category;
  final dynamic value;

  @override
  String toString() =>
      'Category: $category, LoadValue: $value';
}