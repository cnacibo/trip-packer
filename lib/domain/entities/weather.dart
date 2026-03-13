class Weather {
  final DateTime date;
  final double temperatureMax;  
  final double temperatureMin;  
  final double temperatureAfternoon;  

  final double windSpeed;

  final int pressure;
  final int humidity;
  final int precipitation;
  final int cloudCover;

  Weather({
    required this.date,
    required this.temperatureMax,
    required this.temperatureMin,
    required this.temperatureAfternoon,

    required this.windSpeed,

    required this.pressure,
    required this.humidity,
    required this.precipitation,
    required this.cloudCover,
  });
}