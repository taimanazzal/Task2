import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/city_search_screen.dart';
import 'screens/home_screen.dart';
import 'screens/weekly_forecast_screen.dart';
import 'models/weather_model.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق الطقس',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Cairo'),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());

          case '/city-search':
            return MaterialPageRoute(builder: (_) => const CitySearchScreen());

          case '/home':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => HomeScreen(
                cityName: args['cityName'] as String,
                latitude: args['latitude'] as double,
                longitude: args['longitude'] as double,
              ),
            );

          case '/weekly-forecast':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => WeeklyForecastScreen(
                weather: args['weather'] as WeatherModel,
              ),
            );

          default:
            return MaterialPageRoute(
              builder: (_) =>
                  const Scaffold(body: Center(child: Text('صفحة غير موجودة'))),
            );
        }
      },
    );
  }
}
