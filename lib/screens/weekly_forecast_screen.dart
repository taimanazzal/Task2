import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../core/utils/weather_code_mapper.dart';

class WeeklyForecastScreen extends StatelessWidget {
  final WeatherModel weather;

  const WeeklyForecastScreen({super.key, required this.weather});

  static const List<String> _arabicWeekDays = [
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  @override
  Widget build(BuildContext context) {
    final daily = weather.daily;

    return Scaffold(
      appBar: AppBar(title: const Text('توقعات 7 أيام')),
      body: ListView.builder(
        itemCount: daily.time.length,
        itemBuilder: (context, index) {
          final date = daily.time[index];
          final info = WeatherCodeMapper.map(daily.weatherCode[index]);
          final dayLabel = index == 0
              ? 'اليوم'
              : _arabicWeekDays[date.weekday % 7];

          return ListTile(
            leading: Icon(info.icon, color: Colors.blue),
            title: Text(dayLabel),
            trailing: Text(
              '${daily.tempMax[index].round()}° / ${daily.tempMin[index].round()}°',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
