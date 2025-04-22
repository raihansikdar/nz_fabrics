import 'package:flutter_svg/svg.dart';

class SensorDataModel{
  final SvgPicture image;
  final String name;
  final int temperature;

  SensorDataModel(this.image,this.name, this.temperature);
}