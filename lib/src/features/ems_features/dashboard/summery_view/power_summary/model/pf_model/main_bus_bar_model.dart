class MainBusBarModel {
  final List<String> mainBusbars;

  MainBusBarModel({required this.mainBusbars});

  factory MainBusBarModel.fromJson(Map<String, dynamic> json) {
    return MainBusBarModel(
      mainBusbars: List<String>.from(json['main_busbars']),
    );
  }
}
