class SteamShortLiveDataModels {
  final double power;
  final bool sensorStatus;
  final String sourceType;
  final DateTime? timedate;

  SteamShortLiveDataModels({
    required this.power,
    required this.sensorStatus,
    required this.sourceType,
    this.timedate,
  });

  factory SteamShortLiveDataModels.fromJson(Map<String, dynamic> json) {
    return SteamShortLiveDataModels(
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