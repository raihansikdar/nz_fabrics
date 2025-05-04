class WaterShortLiveDataModels {
  final double power;
  final bool sensorStatus;
  final String sourceType;
  final DateTime? timedate;

  WaterShortLiveDataModels({
    required this.power,
    required this.sensorStatus,
    required this.sourceType,
    this.timedate,
  });

  factory WaterShortLiveDataModels.fromJson(Map<String, dynamic> json) {
    return WaterShortLiveDataModels(
      power: json['power']?.toDouble() ?? 0.0,
      sensorStatus: json['sensor_status'] ?? false,
      sourceType: json['source_type'] ?? '',
      timedate: json['timedate'] != null ? DateTime.tryParse(json['timedate']) : null,
    );
  }

  @override
  String toString() {
    return 'LiveDataModels(power: $power, sensorStatus: $sensorStatus, sourceType: $sourceType, timedate: $timedate)';
  }
}