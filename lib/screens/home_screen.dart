import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_api_service.dart';
import '../core/network/api_exceptions.dart';
import '../core/utils/weather_code_mapper.dart';

enum ViewStatus { loading, loaded, error }

class HomeScreen extends StatefulWidget {
  final String cityName;
  final double latitude;
  final double longitude;

  const HomeScreen({
    super.key,
    required this.cityName,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherApiService _weatherService = WeatherApiService();

  ViewStatus _status = ViewStatus.loading;
  WeatherModel? _weather;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() => _status = ViewStatus.loading);

    try {
      final weather = await _weatherService.getWeather(
        latitude: widget.latitude,
        longitude: widget.longitude,
      );
      if (!mounted) return;
      setState(() {
        _weather = weather;
        _status = ViewStatus.loaded;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _status = ViewStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildBody()));
  }

  Widget _buildBody() {
    switch (_status) {
      case ViewStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case ViewStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _fetchWeather,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        );

      case ViewStatus.loaded:
        return RefreshIndicator(
          onRefresh: _fetchWeather,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildTopCard(),
              _buildStatsRow(),
              _buildHourlyForecast(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/weekly-forecast',
                      arguments: {'weather': _weather},
                    );
                  },
                  child: const Text('عرض توقعات 7 أيام ←'),
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildTopCard() {
    final current = _weather!.current;
    final info = WeatherCodeMapper.map(current.weatherCode);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      color: Colors.blue,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.cityName,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48), // موازنة زر الرجوع
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${current.temperature.round()}°',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            info.description,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'أعلى ${_weather!.daily.tempMax[0].round()}° · أقل ${_weather!.daily.tempMin[0].round()}°',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final current = _weather!.current;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem(Icons.water_drop, 'رطوبة ${current.humidity}%'),
          _statItem(Icons.air, 'رياح ${current.windSpeed.round()}كم'),
          _statItem(Icons.speed, '${current.pressure.round()}hPa'),
          _statItem(Icons.wb_sunny, 'UV ${current.uvIndex.round()}'),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    final hourly = _weather!.hourly;
    final now = DateTime.now();

    // بنلاقي أقرب ساعة للوقت الحالي، وبناخد 6 ساعات بعدها
    int startIndex = hourly.time.indexWhere((t) => t.isAfter(now));
    if (startIndex == -1) startIndex = 0;

    final endIndex = (startIndex + 6).clamp(0, hourly.time.length);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الساعات الجاية',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: endIndex - startIndex,
              itemBuilder: (context, i) {
                final index = startIndex + i;
                final info = WeatherCodeMapper.map(hourly.weatherCode[index]);
                final label = i == 0 ? 'الآن' : '${hourly.time[index].hour}:00';

                return Container(
                  width: 60,
                  margin: const EdgeInsets.only(left: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(label, style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 8),
                      Icon(info.icon, color: Colors.blue),
                      const SizedBox(height: 8),
                      Text('${hourly.temperature[index].round()}°'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
