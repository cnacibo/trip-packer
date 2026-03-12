class WeatherConditionModel {
  final int id;
  final String main;
  final String description;
  final String icon;

  WeatherConditionModel({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherConditionModel.fromJson(Map<String, dynamic> json) {
    return WeatherConditionModel(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}