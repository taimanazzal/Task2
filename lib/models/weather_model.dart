class CurrentWeather {
  final double temperature;
  final int humidity;
  final double apparentTemperature;
  final int weatherCode;
  final double windSpeed;
  final double pressure;
  final double uvIndex;
  final bool isDay;

  CurrentWeather({
    required this.temperature,
    required this.humidity,
    required this.apparentTemperature,
    required this.weatherCode,
    required this.windSpeed,
    required this.pressure,
    required this.uvIndex,
    required this.isDay,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num).toDouble(),
      humidity: (json['relative_humidity_2m'] as num).toInt(),
      apparentTemperature: (json['apparent_temperature'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
      pressure: (json['surface_pressure'] as num).toDouble(),
      uvIndex: (json['uv_index'] as num).toDouble(),
      isDay: (json['is_day'] as num).toInt() == 1,
    );
  }
}

class HourlyWeather {
  final List<DateTime> time;
  final List<double> temperature;
  final List<int> weatherCode;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: (json['time'] as List).map((t) => DateTime.parse(t)).toList(),
      temperature: (json['temperature_2m'] as List)
          .map((t) => (t as num).toDouble())
          .toList(),
      weatherCode: (json['weather_code'] as List)
          .map((c) => (c as num).toInt())
          .toList(),
    );
  }
}

class DailyWeather {
  final List<DateTime> time;
  final List<double> tempMax;
  final List<double> tempMin;
  final List<int> weatherCode;

  DailyWeather({
    required this.time,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      time: (json['time'] as List).map((t) => DateTime.parse(t)).toList(),
      tempMax: (json['temperature_2m_max'] as List)
          .map((t) => (t as num).toDouble())
          .toList(),
      tempMin: (json['temperature_2m_min'] as List)
          .map((t) => (t as num).toDouble())
          .toList(),
      weatherCode: (json['weather_code'] as List)
          .map((c) => (c as num).toInt())
          .toList(),
    );
  }
}

class WeatherModel {
  final CurrentWeather current;
  final HourlyWeather hourly;
  final DailyWeather daily;

  WeatherModel({
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      current: CurrentWeather.fromJson(json['current']),
      hourly: HourlyWeather.fromJson(json['hourly']),
      daily: DailyWeather.fromJson(json['daily']),
    );
  }
}
