class TripWeatherForecast {
  final String id;
  final String tripId;
  final DateTime date;
  final double temperatureAfternoon;  
  final int precipitation;
  final int cloudCover;

  TripWeatherForecast({
    required this.id,
    required this.tripId,
    required this.date,
    required this.temperatureAfternoon,
    required this.precipitation,
    required this.cloudCover,
  });
}