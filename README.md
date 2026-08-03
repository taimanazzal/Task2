# 🌤️ Weather App — Flutter Trainee Task

A Flutter weather application built as part of a trainee task, consuming the free [Open-Meteo API](https://open-meteo.com/en/docs) (no API key required).

## Features

- **Splash Screen** — simple branded intro screen
- **City Search** — search for any city with debounced input (400–500ms) and geocoding via Open-Meteo
- **Current Weather** — temperature, condition, high/low, humidity, wind, pressure, and UV index
- **Hourly Forecast** — scrollable next-hours forecast strip
- **7-Day Forecast** — full weekly outlook reusing the same API response (no extra calls)
- **Pull to Refresh** on the home screen
- **Robust error handling** — no internet, request timeout, server errors, and empty search results, each with a clear message and retry option

## Tech Stack

- **Flutter & Dart**
- **[dio](https://pub.dev/packages/dio)** — HTTP client with timeout & structured error handling
- **[Open-Meteo API](https://open-meteo.com/en/docs)** — free weather & geocoding data

## Project Structure

```
lib/
├── core/
│   ├── network/       # Dio client setup + custom API exceptions
│   └── utils/          # WeatherCodeMapper (weather code → text + icon)
├── models/              # CityModel, WeatherModel
├── services/             # GeocodingApiService, WeatherApiService
└── screens/               # SplashScreen, CitySearchScreen, HomeScreen, WeeklyForecastScreen
```

## Getting Started

```bash
flutter pub get
flutter run
```

## Screens

| Splash | City Search | Home | Weekly Forecast |
|---|---|---|---|
| Logo + app name | Search with debounce | Current conditions + hourly | 7-day outlook |

---

Built as part of a Flutter training program (Week 2 — State Basics & APIs).
