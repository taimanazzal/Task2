import 'package:flutter/material.dart';

class WeatherInfo {
  final String description;
  final IconData icon;

  WeatherInfo({required this.description, required this.icon});
}

class WeatherCodeMapper {
  static WeatherInfo map(int code) {
    if (code == 0) {
      return WeatherInfo(description: 'صافي', icon: Icons.wb_sunny);
    } else if (code == 1 || code == 2 || code == 3) {
      return WeatherInfo(description: 'غائم جزئياً', icon: Icons.cloud_queue);
    } else if (code == 45 || code == 48) {
      return WeatherInfo(description: 'ضباب', icon: Icons.foggy);
    } else if (code >= 51 && code <= 67) {
      return WeatherInfo(description: 'أمطار خفيفة', icon: Icons.grain);
    } else if (code >= 71 && code <= 77) {
      return WeatherInfo(description: 'ثلج', icon: Icons.ac_unit);
    } else if (code >= 80 && code <= 82) {
      return WeatherInfo(description: 'زخات مطر', icon: Icons.beach_access);
    } else if (code >= 95 && code <= 99) {
      return WeatherInfo(description: 'عاصفة رعدية', icon: Icons.thunderstorm);
    } else {
      return WeatherInfo(description: 'غير معروف', icon: Icons.help_outline);
    }
  }
}
